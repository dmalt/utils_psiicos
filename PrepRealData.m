function [ConData, G2dLRU] = PrepRealData(Subj, Band, bInducedOnly, TimeRange)
 % ----------------------------------------------------------
 % PrepRealData: Calculate band-pass filtered cross-spectrum
 % and reduced forward model matrices for subject Subj
 % ----------------------------------------------------------
 % FORMAT:
 %   [ConData, G2dLRU] = PrepRealData(Subj) 
 % INPUTS:
 %   Subj           - subject name (should be in Brainstorm protocol)        -
 % OUTPUTS:
 %   ConData        - structure
 % ________________________________________
 % Dmitrii Altukhov, dm.altukhov@ya.ru
 
 run('/home/dmalt/fif_matlab/brainstorm3/brainstorm(''nogui'')');
% FolderName = '~/fif_matlab/Brainstorm_db/PSIICOS/data/';
FolderName = '~/PSIICOS_osadtchii/data/';
ChUsed = 1:306; ChUsed(3:3:end) = [];
if nargin < 4
    TimeRange = [0, 0.700];
end
% TimeRange = [0.4, 0.700];
% Subject = '0003_pran/brainstormsubject.mat';
Subject = strcat(Subj, '/brainstormsubject.mat');

Conditions = {'1','2','4'}; % '2','4'};
% Band = [15 30];
%Band = [70 85];
% Band = [8 12];
% Band = [4,8];
Fsamp = 500;
[b,a] = butter(5, Band / (Fsamp / 2));
Protocol = bst_get('ProtocolStudies', 'PSIICOS');
clear ConData;
fprintf('Loading real data from BST database.. \n');
%% Load data and compute cross-spectral matrix 
% ConditionsFound = 0;
clear ConData;
for c = 1:length(Conditions)
    for s = 1:length(Protocol.Study)
        if(strcmp(Protocol.Study(s).Name,Conditions{c}) && strcmp(Protocol.Study(s).BrainStormSubject, Subject))
            fprintf('Found study condition %s %s\n ', Conditions{c},Protocol.Study(s).BrainStormSubject); 
            for hm = 1:length(Protocol.Study(s).HeadModel)
                if(strcmp(Protocol.Study(s).HeadModel(hm).Comment,'Overlapping spheres_HR'))
                    ConData{c}.HM_HR = load([FolderName Protocol.Study(s).HeadModel(hm).FileName]);
                else
                    ConData{c}.HM_LR = load([FolderName Protocol.Study(s).HeadModel(hm).FileName]);
                end
            end;
        end;
    end;
end;

% run('/home/meg/fif_matlab/brainstorm3/brainstorm(''stop'')');
run('/home/dmalt/fif_matlab/brainstorm3/brainstorm(''stop'')');
%% Reduce tangent dimension and transform into virtual sensors 
% the forward model is the same for both conditions
% so pick the first oneCOnData
GainSVDTh = 0.01;
NsitesLR = size(ConData{1}.HM_LR.GridLoc, 1);
Nch    = length(ChUsed);
G2dLR = zeros(Nch,NsitesLR * 2);
G2d0LR = zeros(Nch,NsitesLR * 2);
% reduce tangent space
range = 1:2;
for i=1:NsitesLR
    g = [ConData{1}.HM_LR.Gain(ChUsed,1 + 3 * (i - 1)) ...
         ConData{1}.HM_LR.Gain(ChUsed,2 + 3 * (i - 1)) ...
         ConData{1}.HM_LR.Gain(ChUsed,3 + 3 * (i - 1))];
    [u,sv,v] = svd(g);
    gt = g * v(:,1:2);
    G2dLR(:,range) = gt * diag(1 ./ sqrt(sum(gt .^ 2, 1)));
    G2d0LR(:,range) = gt;
    range = range + 2;
end;
%reduce sensor space
[ug,sg,vg] = spm_svd(G2dLR*G2dLR',GainSVDTh);
UP = ug';
G2dLRU = UP*G2dLR;
G2d0LRU = UP*G2d0LR;

% do the same for HR
NsitesHR = size(ConData{1}.HM_HR.GridLoc,1);
Nch    = length(ChUsed);
G2dHR = zeros(Nch,NsitesHR * 2);
% reduce tangent space
range = 1:2;
for i=1:NsitesHR
    g = [ConData{1}.HM_HR.Gain(ChUsed,1 + 3 * (i - 1)) ...
         ConData{1}.HM_HR.Gain(ChUsed,2 + 3 * (i - 1)) ...
         ConData{1}.HM_HR.Gain(ChUsed,3 + 3 * (i - 1))];
    [u,sv,v] = svd(g);
    gt = g * v(:,1:2);
    G2dHR(:,range) = gt * diag(1 ./ sqrt(sum(gt .^ 2, 1)));
    range = range + 2;
end;
%reduce sensor space
G2dHRU = UP*G2dHR;
% now load data
Nch = size(UP, 1);
ConditionsFound = 0;
for c = 1:length(Conditions)
    for s = 1:length(Protocol.Study)
        if(strcmp(Protocol.Study(s).Name,Conditions{c}) & strcmp(Protocol.Study(s).BrainStormSubject,Subject))
            fprintf('Found study condition %s %s\n ', Conditions{c},Protocol.Study(s).BrainStormSubject); 
            ConData{c}.NumTrials = length(Protocol.Study(s).Data);
            fprintf('Loading Trials (Max %d) : ', ConData{c}.NumTrials); 
            for t = 1:ConData{c}.NumTrials
                aux = load([FolderName Protocol.Study(s).Data(t).FileName]);
                if(t==1)
                    [ans, ind0] =min(abs(aux.Time-TimeRange(1)));
                    [ans, ind1] =min(abs(aux.Time-TimeRange(2)));
                    T = ind1-ind0+1; 
                    ConData{c}.Trials = zeros(Nch,T,ConData{c}.NumTrials);
                    ConData{c}.Fsamp = 1./(aux.Time(2)-aux.Time(1));
                end;
                tmp = filtfilt(b,a,(UP*aux.F(ChUsed,:))')';
                ConData{c}.Trials(:,:,t) = tmp(:,ind0:ind1);
                if t>1
                    for tt=0:log10(t-1)
                        fprintf('\b'); % delete previous counter display
                    end
                end
                fprintf('%d', t);
            end; % trials t
            fprintf(' -> Done\n');
        end;
    end;
    
    if(length(ConData) >= c)
        P = sum(sum(abs(ConData{c}.Trials), 1), 2);
        Pm = median(squeeze(P));
        ind = find(P > 2 * Pm | P < 0.5 * Pm);
        REJ{c} = ind;
        ConData{c}.Trials(:,:,ind) = [];
        fprintf('Computing cross-spectral matrix ....' ); 
        ConData{c}.CrossSpec = CrossSpectralMatrix(ConData{c}.Trials, Band, 500);
        ConData{c}.CrossSpecTime = CrossSpectralTimeseries( ConData{c}.Trials, bInducedOnly);
        %ConData{c}.CrossSpec = reshape(mean(ConData{c}.CrossSpecTime,2),Nch,Nch);
        fprintf('-> Done\n' ); 
    end;
end;


%[ Cs, Result, CTp, IND, Upwr,SubC] = RAPPSIICOSTime2CondSubcorr( ConData{2}.CrossSpecTime,[],20, G2dLRU, G2d0LRU, R,350, 5,1);
% R = ConData{1}.HM_LR.GridLoc;
% [ Cs2min1, Result, CTp, IND, Upwr] = RAPPSIICOSTime2Cond( ConData{2}.CrossSpecTime, ConData{1}.CrossSpecTime,20, G2dLRU, G2d0LRU, R,350, 5,1);
%[Q3, IND] = IrmxNE_dip(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU);
return;

% ------------------------------------------------------------------------------------------------------------------------- %
% ------------------------------------------------------------------------------------------------------------------------- % 
% ------------------------------------------------------------------------------------------------------------------------- %

%Ctx = load('D:\Brainstorm_db\PSIICOS\anat\0003_pran\tess_cortex_concat_2000V.mat');
Ctx = load('/home/meg/fif_matlab/Brainstorm_db/PSIICOS/anat/0019_shev/tess_cortex_pial_low_2000V.mat');
%42175428 29

figure;
hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[0.1,0.51,1], 'EdgeColor','none','FaceAlpha', 0.3);
hold on;
camlight left; lighting phong
camlight right; 
hold on;

cols = ['r','g','m','y','k','c']
D =sum(Cs2min1{1},2);
for k=1:size(D,2)
    Dmx = max(D(:,k));
    ind = find(D(:,k)>0.983*Dmx);
    for i=1:length(ind)
        h = line([R(IND(ind(i),1),1) R(IND(ind(i),2),1)],[R(IND(ind(i),1),2) R(IND(ind(i),2),2)],[R(IND(ind(i),1),3) R(IND(ind(i),2),3)] );
        plot3(R(IND(ind(i),1),1),R(IND(ind(i),1),2),R(IND(ind(i),1),3),[cols(k) '.']);
        plot3(R(IND(ind(i),2),1),R(IND(ind(i),2),2),R(IND(ind(i),2),3),[cols(k) '.']);
        set(h,'Color',cols(k),'LineWidth',1);
    end;
end;

return

Avg = mean(ConData{2}.Trials,3);
[ua sa va] = svd(Avg);

Ns = size(G2dLRU,2)/2;
range = 1:2;
MusSc = zeros(Ns,1);
for s = 1:Ns
    aux = subcorr(G2dLRU(:,range),ua(:,1:4));
    range = range+2;
    MusSc(s) = aux(1);
end;


ConData{c}.Trials(:,:,[41,62]) = [];
ConData{c}.CrossSpec = CrossSpectralMatrix(ConData{c}.Trials,Band,500);
ConData{c}.CrossSpecTime = CrossSpectralTimeseries( ConData{c}.Trials);


[ Cp, Upwr ] = ProjectFromPower( ConData{c}.CrossSpecTime, G2dLRU, 350, []);
CP = zeros(size(Cp,1),size(Cp,2),100);
Ntr = size(ConData{c}.Trials,3);
for mc = 1:100
    
    bst_trials = fix(rand(1,Ntr)*Ntr+1);
    while((max(bst_trials)>Ntr) | (min(bst_trials)<1) )
        bst_trials = fix(rand(1,Ntr)*Ntr+1);
    end;
    C = CrossSpectralTimeseries(ConData{c}.Trials(:,:,bst_trials));
    CP(:,:,mc) = ProjectFromPower( C, G2dLRU, 350, Upwr);
end;
CPav = mean(CP,3);

P = sum(sum(abs(ConData{c}.Trials),1),2);

mar = mean(real(CP),3);
mai = mean(imag(CP),3);
str = std(real(CP),[],3);
sti = std(imag(CP),[],3);

t = ma./st;

return
%ConData{2}.CrossSpecTime = CrossSpectralTimeseries( ConData{2}.Trials);
%ConData{3}.CrossSpecTime = CrossSpectralTimeseries( ConData{3}.Trials);
%[Qpsiicos, IND, CpProjs ] = RAPPSIICOS(ConData{2}.CrossSpec-ConData{1}.CrossSpec, G2dLRU,G2dHRU,4);
%[Qpsiicos, IND, CpProjs ] = RAPPSIICOS(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU,G2dHRU,3);
%[Q3vs1, IND, CpProjs3vs1, Upwr ] = PSIICOS(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU);
%[Q2vs1, IND, CpProjs2vs1, Upwr ] = PSIICOS(ConData{2}.CrossSpec-ConData{1}.CrossSpec, G2dLRU);
[Q3, IND, CpProjs3, Upwr ] = PSIICOS(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU);
%[Q2, IND, CpProjs2, Upwr ] = PSIICOS(ConData{2}.CrossSpec, G2dLRU);

%[Q3vs2_rap2, IND, CpProjs3vs1, Upwr ] = RAPPSIICOS(ConData{3}.CrossSpec-ConData{2}.CrossSpec, G2dLRU,4);
%[Cs3, Ps, INDdics] = iDICS(ConData{3}.CrossSpec, G2dLRU);
%[Cs1, Ps, INDdics] = iDICS(ConData{1}.CrossSpec, G2dLRU);
[Q3vs1_rap, IND, CpProjs3vs1, Upwr ] = RAPPSIICOS(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU,5);
[Cdics, Ps, INDdics] = iDICS(ConData{3}.CrossSpec-ConData{1}.CrossSpec, G2dLRU);

return
Cons = [1,3];
Ntr = size(ConData{3}.Trials,3);
for mc = 1:100
    trials = fix(0.99*rand(1,Ntr)*Ntr+1);
    CrossSpec = CrossSpectralMatrix(ConData{3}.Trials(:,:,trials),Band,500);
    [Qpsiicosmc, IND, CpProjs ] = RAPPSIICOS(CrossSpec-ConData{1}.CrossSpec, G2dLRU,G2dHRU,4);
    fname = sprintf('qpsiicos_mc_trial_%d.mat',mc);
    save(fname,'Qpsiicosmc');
%    QQmc{mc} = Qpsiicosmc;
end;
    
return

clear CP;
CP = Cp{1}; 
[Qs key] = sort(QpsiicosP{1});
INDs = IND{1}(key,:);
tmp0 = CP;
a0 = norm(tmp0(:));
aa = zeros(1,100);
VV = [];
for r=1:100
    ii = INDs(end-k+1,1);
    jj = INDs(end-k+1,2);
    range_i = ii*2-1:ii*2;
    range_j = jj*2-1:jj*2;
    gi = G2dU(:,range_i);
    gj = G2dU(:,range_j);
    V = zeros(73^2, 4);
    Vre = zeros(73^2, 4);
    Vim = zeros(73^2, 4);
    k = 1;
    for i=1:2
        for j=1:2
            gg =bsxfun(@times,gi(:,i),gj(:,j)'); 
            v = gg+gg';
            Vre(:,k) = v(:);
            v = gg-gg';
            Vim(:,k) = v(:);
            k = k+1;
        end;
    end;
    VV= [VV V];
    [u s v] = svd(VV,'econ');
    c = u'*CP(:);
    CPp = reshape(CP(:)-u*c,73,73);
%    aare(k) = norm(real(tmp1(:)))/norm(real(tmp0(:)));
%    aaim(k) = norm(imag(tmp1(:)))/norm(imag(tmp0(:)));
    aa(r) = norm((CPp(:)))/norm((CP(:)));
end;

for mc=1:40
    fname = sprintf('qpsiicos_mc_trial_%d.mat',mc);
    h = load(fname);

    D = h.Qpsiicosmc;
    R = ConData{1}.HM_LR.GridLoc;
    for k=1:size(D,2)
        [Dmx ind] = max(D(:,k));
        for i=1:length(ind)
         h = line([R(IND(ind(i),1),1) R(IND(ind(i),2),1)],[R(IND(ind(i),1),2) R(IND(ind(i),2),2)],[R(IND(ind(i),1),3) R(IND(ind(i),2),3)] );
        plot3(R(IND(ind(i),1),1),R(IND(ind(i),1),2),R(IND(ind(i),1),3),[cols(k) '.']);
        plot3(R(IND(ind(i),2),1),R(IND(ind(i),2),2),R(IND(ind(i),2),3),[cols(k) '.']);
        set(h,'Color',cols(k));
        end;
    end;
    mc
end




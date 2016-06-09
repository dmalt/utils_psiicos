
function [G2dU, CrossSpecTime, UP, Trials] = GenerData(PhaseLag, InducedScale, EvokedScale) 
% --------------------------------------------------------------------------
% Generate forward model and cross-spectrum on sensors for simulations
% --------------------------------------------------------------------------
% FORMAT:
%   [G2dU, CrossSpecTime] = GenerData(PhaseLag, InducedScale, EvokedScale)
% INPUTS:
%   PhaseLag          - phase lag for simulations
%   InducedScale      - coefficient for induced activity (default = 0.35)
%   EvokedScale       - coefficient for evoked activity (default = 0)
% OUTPUTS:
%   G2dU              - {nSources x nSensors_reduced} forward model matrix 
%                       with PCA-reduced number of sensors
%   CrossSpecTime     - {nSensors ^ 2 x nTimes} matrix of cross-spectrum on sensors
%   UP                - {nSensors_reduced x nSensors} matrix of a linear 
%                       transformation to PCA-reduced sensor space. To go back
%                       to full-sensors space type G = UP' * G2dU
%   Trials            - {nSensors_reduced x nTimes x nTrials} matrix of trials
%                       timeseries
% ______________________________________________________________________________
% Alex Ossadtchi, ossadtchi@gmail; Dmitrii Altukhov, dm.altukhov@ya.ru


if nargin == 2
    EvokedScale = 0.0 / 2.5;
elseif nargin == 1
       InducedScale = 0.35;
       EvokedScale = 0;
end

phi = PhaseLag;
GainSVDTh = 0.001; % 0.05 results into 47 eigensensors and makes it run faster but produces less contrasting subcorr scans
% for a more reliable preformance use 0.01 to get all the sensor on board but be ready to wait;
NetworkPairIndex{1} = [1,2];
NetworkPairIndex{2} = [1,2,3];
%% Load forward model and reduce it  
% load reduced forward model (GLowRes)
load('GLowRes.mat'); 
% get grid node locations
Rloc = GLowRes.GridLoc;
% set to use gradiometers only
ChUsed = 1:306; 
ChUsed(3:3:end) = [];
% calculate tangential plane dipoles
[Nch, Nsites] = size(GLowRes.Gain(ChUsed,1:3:end));
% Nsites = 24;
% G2d = zeros(Nch,Nsites * 2);
% G2d0 = zeros(Nch,Nsites * 2);
range = 1:2;

Dmax = 0.02;
NPI = NetworkPairIndex{2};
XYZGen = 1.3 * [0.05, 0.04, 0.05; 0.05, -0.04, 0.05; -0.05, 0.04, 0.05; -0.05, -0.04, 0.05; 0.00, 0.05, 0.06; 0.00, -0.05, 0.06];
[allnw, nw1, nw2, nw3] = FindEffSources(Dmax, Rloc, XYZGen, NPI);
effSites = unique([allnw(:,1); allnw(:,2)]);
effSites(effSites == 0) = Nsites;

for i = 1:Nsites
    g = [GLowRes.Gain(ChUsed, 1 + 3 * (i - 1)), GLowRes.Gain(ChUsed, 2 + 3 * (i - 1)), GLowRes.Gain(ChUsed, 3 + 3 * (i - 1))];
    [u sv v] = svd(g);
    gt = g * v(:,1:2);
    G2d(:,range) = gt * diag(1 ./ sqrt(sum(gt .^ 2, 1)));
    G2d0(:,range) = gt;
    range = range + 2;
end;
% reduce the sensor space
[ug sg vg] = spm_svd(G2d * G2d',GainSVDTh);
UP = ug';
G2dU = UP * G2d;
G2d0U = UP * G2d0;
% G2dU = G2dU_full([100000 : 250000, 680000:1130000]);
% PHI = [pi / 20 pi / 2];
it = 1;
% for phi = PHI 
% phi = PHI(1);
    %% Data simulation
    if(it == 1)
        % we will use the same phase shifts in the second and subsequent
        % iterations. We will store the random phases in PhaseShifts 
        [ Evoked, Induced, BrainNoise, SensorNoise, G2dHiRes, RHiRes, Fs,Ntr, XYZGen, Ggen, PhaseShifts] = ...
        SimulateDataPhase(NetworkPairIndex{2},phi,true,[]);
    else
        % and use PhaseShits from the first iteration
        [ Evoked, Induced, BrainNoise, SensorNoise, G2dHiRes, RHiRes, Fs,Ntr, XYZGen, Ggen, PhaseShifts] = ...
        SimulateDataPhase(NetworkPairIndex{2},phi,false,PhaseShifts);
    end;        
    % mix noise and data 
    % in order to control SNR we first normalize norm(BrainNoise(:)) = 1 and 
    % norm(Induced(:)) = 1 and then mix the two with the coefficient
    Data0 = InducedScale * Induced + EvokedScale*Evoked + BrainNoise ;
    clear Induced;
    clear Evoked;
    clear BrainNoise;
    clear SensorNoise;
    [bf af] = butter(5,[2, 20] / (0.5 * 500));
    % Filter in the band of interest
    Data = filtfilt(bf,af,Data0')';
    clear Data0;
    % Noise = filtfilt(bf, af, BrainNoise')';
    % Data_clear = filtfilt(bf, af, InducedScale * Induced')';
    %% Reshape the data in a 3D structure(Space x Time x Epochs)
    [Nch Tcnt] = size(Data);
    T = fix(Tcnt/Ntr);
    Nch = size(UP,1);
    %reshape Data and store in a 3D array X
    X1 = zeros(Nch,T,Ntr);
    N1 = zeros(Nch,T,Ntr);
    N2 = zeros(Nch, T, Ntr);
    range = 1:T;
    for i=1:Ntr
        X1(:,:,i) = UP * Data(:,range);
%         N1(:,:,i) = UP * Noise(:,range);
%         N2(:,:,i) = UP * Data_clear(:,range);
        range = range + T;
    end;
    Trials = X1;
    %% Calculate band cross-spectral matrix 
    CrossSpecTime = CrossSpectralTimeseries(X1);
    % CrossSpecNoise = CrossSpectralTimeseries(N1);
    % CrossSpecClData = CrossSpectralTimeseries(N2);
    % C = reshape(mean(CrossSpecTime{it},2),Nch,Nch); 
    
    % %% Experiment with different methods
    [dummy, T] = size(CrossSpecTime);
    % M  = ProjOut(CrossSpecTime, G2dU) ;
    % M_noiseonly = ProjOut(CrossSpecNoise, G2dU);
    % Data_clear_p = ProjOut(CrossSpecClData, G2dU);
    % it = it + 1;
% end;
return;
end



function [ BrainNoise ] = GenerateBrainNoise(G,T,Tw,N,Fs)

Nsrc = size(G,2);
SrcIndex = fix(rand(1,N)*Nsrc+1);

q = randn(N,T+2*Tw);

alpha_band  = [8,  12]/(Fs/2);
beta_band   = [15, 30]/(Fs/2);
gamma1_band = [30, 50]/(Fs/2);
gamma2_band = [50, 70]/(Fs/2);


[b_alpha, a_alpha] = butter(4,alpha_band);
[b_beta, a_beta] = butter(4,beta_band);
[b_gamma1, a_gamma1] = butter(4,gamma1_band);
[b_gamma2, a_gamma2] = butter(4,gamma2_band);

SourceNoise = 1/mean(alpha_band)* filtfilt(b_alpha,a_alpha,q')' + ...
              1/mean(beta_band)*filtfilt(b_beta,a_beta,q')' + ...
              1/mean(gamma1_band)*filtfilt(b_gamma1,a_gamma1,q')'+...
              1/mean(gamma2_band)*filtfilt(b_gamma2,a_gamma2,q')';

BrainNoise = G(:,SrcIndex)*SourceNoise(:,Tw+1:Tw+T)/N;



end

function [ans_idx, nw1, nw2, nw3] = FindEffSources(Dmax, R, XYZGen, NPI)
%Dmax = 0.015;
% create binary arrays indicators for each network from NPI 
Nsites = size(R, 1);
IND(Nsites * (Nsites - 1) / 2, 2) = 0; % Memory allocation; faster then zeroes(...) 
s = 1;
for k = 1:Nsites
    for l = k:Nsites
        IND(s,1) = k;
        IND(s,2) = l;
        s = s + 1;
    end
end
R1 = R(IND(:,1),:);
R2 = R(IND(:,2),:);
k = 1;
for nw = NPI
    i1 = nw * 2 - 1;
    i2 = nw * 2;
    d11 = bsxfun(@minus,R1,XYZGen(i1,:));
    d12 = bsxfun(@minus,R1,XYZGen(i2,:));
    d21 = bsxfun(@minus,R2,XYZGen(i1,:));
    d22 = bsxfun(@minus,R2,XYZGen(i2,:));

    D11 = sqrt(sum(d11.^2,2));
    D12 = sqrt(sum(d12.^2,2));
    D21 = sqrt(sum(d21.^2,2));
    D22 = sqrt(sum(d22.^2,2));

    Nw(:,k) = ( (D11 < Dmax) & (D22 < Dmax) ) | ( (D12 < Dmax) & (D21 < Dmax) );
    k = k + 1;
end;
AllNw = (sum(Nw, 2) > 0);
ans_idx_lin = find(AllNw); % We`ve obtained indices that lay near generator coordinates.
ans_idx = IND(ans_idx_lin,:); 
nw1 = IND(find(Nw(:,1)),:);
nw2 = IND(find(Nw(:,2)),:);
nw3 = IND(find(Nw(:,3)),:);
end


function [ Evoked, Induced, BrainNoise, SensorNoise, G2d, R, Fs,Ntr,XYZGenOut,Ggen, PhaseShiftsOut] = SimulateDataPhase(NetworkPairIndex, dPhi, bNewBrainNoise,PhaseShiftsIn,alpha_in)

bUsePhases = ~isempty(PhaseShiftsIn);

if(nargin < 5)
    alpha = 1.;
else
    alpha = alpha_in;
end;

ISD = load('InputData4Simulations.mat');
% load reduced forward model (GLowRes)
 % load('GLowRes.mat'); 
 % ISD.G = GLowRes;
% clear GLowRes;
% set to use gradiometers only

ISD.Channels = load('channel_vectorview306.mat');

SSPVE = 0.98;
RAP = 1;% number of RAP-MUSIC iterations

if(nargin == 0)
    bNewBrainNoise = true; % whether or not to generate new brain noise
end;
% specify locations of the generators
XYZGen = 1.3*[0.05,0.04,0.05; 0.05,-0.04,0.05;-0.05,0.04,0.05; -0.05,-0.04,0.05; 0.00,0.05,0.06; 0.00,-0.05,0.06];

%We will use only gradiometers
ChUsed = 1:306; 
ChUsed(3:3:end) = [];

% create normalized forward matrix, leaving only two components in the tangential plane 
[Ns, Nsites] = size(ISD.G.Gain(ChUsed,1:3:end));
G2d = zeros(Ns,Nsites*2);
G2dn = zeros(Ns,Nsites*2);
range = 1:2;
for i=1:Nsites
    g = [ISD.G.Gain(ChUsed,1+3*(i-1)) ISD.G.Gain(ChUsed,2+3*(i-1)) ISD.G.Gain(ChUsed,3+3*(i-1))];
    [dummy, dummy, v] = svd(g);
    G2d(:,range) = g * v(:,1:2);
    G2dn(:,range) = G2d(:,range) * diag(1 ./ sqrt(sum(G2d(:,range) .^ 2, 1)));
    range = range + 2;
end;

% Assign topographies to generator coordinates(do not recompute, just find the closest one)
R = ISD.G.GridLoc;
for i=1:size(XYZGen,1)
    d = repmat(XYZGen(i,:),size(R,1),1) - R;
    d = sum(d.*d,2);
    [dummy, ind] = min(d);
    XYZGenAct(i,:) = R(ind,:);
    Ggen(:,i) = G2d(:,ind * 2 - 1); % take the first dipole in the tangent plane
    GenInd(i) = ind; 
end;

% specify pairing nodes for each network
nwp{1} = [1,2];
nwp{2} = [3,4];
nwp{3} = [5,6];
nwp{4} = [1,3];
% Specify all networks  

nw = [nwp{NetworkPairIndex}]; % If you want to simulate all four networks use
%nw = [nw1 nw2 nw3 nw4]; see also line 87

Ngen = 6; % total number of generators
sp = zeros(2,500); 
T = 500;   % number of timeslices per trial
t = 1:T;

% synchrony profiles of networks, one of each  as specified in lines 34-37
sp(1,:) = exp(-1e-8 * (abs(t - 100)) .^ 4) ;
sp(2,:) = exp(-1e-8 * (abs(t - 350)) .^ 4) ;
sp(3,:) = exp(-0.2e-8 * (abs(t - 225)) .^ 4) ;
sp(4,:) = 0.5*(sin(10*t/500)+1);

Ntr = 100; %  number of trials
range = 1:T;
clear Data;
Fs = 500; % sampling rate
BrainNoise  = zeros(Ns,Ntr*T);
SensorNoise  = zeros(Ns,Ntr*T);
Induced     = zeros(Ns,Ntr*T);
Evoked     = zeros(Ns,Ntr*T);
F1 = 10; % Hz;
t = linspace(0,1,Fs);
clear s;
if(~bNewBrainNoise)
    BN = load('BrainNoiseBiomag2014.mat');
end;
fprintf('Simulating trial data ...\n');
fprintf('Current trial number (Max %d):', Ntr);
PhaseShiftsOut = zeros(Ntr,8);
for tr = 1:Ntr
    
    if(bUsePhases)
        phi1 = PhaseShiftsIn(tr,1);
        phi_alpha = PhaseShiftsIn(tr,2);
    else
        phi1= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,1:2) = [phi1 phi_alpha];
    rnd_phi12 = phi_alpha + dPhi;
    s{1}(1,:) = sin(2 * pi * F1 * t + phi1) .* sp(1,:);
    s{1}(2,:) = sin(2 * pi * F1 * t + phi1 + rnd_phi12) .* sp(1,:);

    if(bUsePhases)
        phi2 = PhaseShiftsIn(tr, 3);
        phi_alpha = PhaseShiftsIn(tr, 4);
    else
        phi2= 2 * (rand - 0.5) * pi;
        phi_alpha = alpha * (rand - 0.5) * pi;
    end;
    PhaseShiftsOut(tr,3:4) = [phi2 phi_alpha];
    rnd_phi34 = phi_alpha + dPhi;
    s{2}(1,:) =  sin(2*pi*F1*t+phi2).*sp(2,:); 
    s{2}(2,:) =  sin(2*pi*F1*t+phi2+rnd_phi34).*sp(2,:); 

    if(bUsePhases)
        phi3 = PhaseShiftsIn(tr,5);        
        phi_alpha = PhaseShiftsIn(tr,6);
    else
        phi3= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,5:6) = [phi3 phi_alpha];
    rnd_phi56 =  phi_alpha + dPhi;
    s{3}(1,:) =  sin(2*pi*F1*t+phi3).*sp(3,:); 
    s{3}(2,:) =  sin(2*pi*F1*t+phi3+rnd_phi56).*sp(3,:); 

    if(bUsePhases)
        phi4 = PhaseShiftsIn(tr,7);
        phi_alpha = PhaseShiftsIn(tr,8);
    else
        phi4= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,7:8) = [phi4 phi_alpha];
    rnd_phi78 = phi_alpha + dPhi;
    s{4}(1,:) =  sin(2*pi*F1*t+phi3).*sp(4,:); 
    s{4}(2,:) =  sin(2*pi*F1*t+phi3+rnd_phi56).*sp(4,:); 

    % generate evoked activity
    e(1,:) = exp(-15 * (t - 0.2) .^ 2) .* sin(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);
    e(2,:) = exp(-15 * (t - 0.2) .^ 2) .* cos(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);
    
    % collect activity from the selected networks
    induced = zeros(Ns,T);
    for n=NetworkPairIndex
         a = Ggen(:,nwp{n}) * s{n};
         a = a / norm(a(:));   
        induced = induced + a;
    end;
    induced = induced/sqrt(sum((induced(:).^2)));
    Induced(:,range) = induced;
    
    evoked = zeros(Ns,T);
    evoked = Ggen(:,[2,4])*e;
    evoked = evoked/sqrt(sum(evoked(:).^2));
    Evoked(:,range) = evoked;
    
    if(bNewBrainNoise)
        brainnoise = GenerateBrainNoise(G2d,T,500,1000,Fs);
    else
        brainnoise = BN.BrainNoise(:,range);
    end;
    
    brainnoise = brainnoise/sqrt(sum((brainnoise(:).^2)));
    BrainNoise(:,range) = brainnoise;
    
    sensornoise = randn(size(brainnoise));
    sensornoise = sensornoise/sqrt(sum((sensornoise(:).^2)));
    SensorNoise(:,range) = sensornoise;
    range = range+T;
    if tr>1
      for j=0:log10(tr-1)
          fprintf('\b'); % delete previous counter display
      end
     end
     fprintf('%d', tr);
end

if(bNewBrainNoise)
    save('BrainNoiseBiomag2014.mat','BrainNoise');
end;

fprintf('\nDone.\n');

XYZGenOut = XYZGenAct(nw,:);
end
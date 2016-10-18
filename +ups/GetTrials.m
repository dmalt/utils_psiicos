%% GetTrials: function description
function [ConData] = GetTrials(subj_ID)
% -------------------------------------------------------
% Load trials from brainstorm protocol
% -------------------------------------------------------
% FORMAT:
%   [Trials] = GetTrials(subj_ID) 
% INPUTS:
%   subj_ID        - string; subject ID
% OUTPUTS:
%   Trials         - {} matrix
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	run('/home/dmalt/fif_matlab/brainstorm3/brainstorm(''nogui'')');
	FolderName = '~/PSIICOS_osadtchii/data/';
    % CondDirs = dir([FolderName, '')



    % Conditions = {'1', '2', '4'};
	Conditions = {'2'};
	Protocol = bst_get('ProtocolStudies', 'PSIICOS');
	fprintf('Loading real data from BST database.. \n');

    for c = 1:length(Conditions)
       for s = 1:length(Protocol.Study)
           if(strcmp(Protocol.Study(s).Name, Conditions{c}) & strcmp(Protocol.Study(s).BrainStormSubject, Subject))
               fprintf('Found study condition %s %s\n ', Conditions{c},Protocol.Study(s).BrainStormSubject); 
               ConData{c}.NumTrials = length(Protocol.Study(s).Data);
               fprintf('Loading Trials (Max %d) : ', ConData{c}.NumTrials); 
               for t = 1:ConData{c}.NumTrials
                   aux = load([FolderName Protocol.Study(s).Data(t).FileName]);
                   if(t==1)
                       [ans, ind0] =min(abs(aux.Time - TimeRange(1)));
                       [ans, ind1] =min(abs(aux.Time - TimeRange(2)));
                       T = ind1 - ind0 + 1; 
                       ConData{c}.Trials = zeros(Nch, T, ConData{c}.NumTrials);
                       ConData{c}.Fsamp = 1 ./ (aux.Time(2) - aux.Time(1));
                   end;
                   tmp = filtfilt(b,a , (UP * aux.F(ChUsed,:))')';
                   ConData{c}.Trials(:,:,t) = tmp(:,ind0:ind1);
                   if t > 1
                       for tt = 0:log10(t - 1)
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
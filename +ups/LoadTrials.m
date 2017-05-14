function trials = LoadTrials(subjID, condition, freqBand,...
                             timeRange, HM, protocolPath)
% ---------------------------------------------------------------------------------------
% Load trials data from brainstorm protocol, reduce dimensions, bandpass filter and crop 
% ---------------------------------------------------------------------------------------
% FORMAT:
%   trials = LoadTrials(subjID, condition, freqBand, timeRange, GainSVDTh, protocolPath)
% INPUTS:
%   subjID        - string; subject name in BST protocol
%   condition     - string; condition name in BST protocol
%   freqBand      - {2 x 1} array; bandpass filtering frequency range
%   timeRange     - {2 x 1} array; cropping timerange; 
%   protocolPath  - string; absolute path to BST protocol
%   GainSVDTh     - scalar; parameter for spm_svd for dim reduction. Higher values
%                   correspond to less channels. If GainSVDTh = 0, no dim. reduction
%                   is made. default = 0.01
% OUTPUTS:
%   trials:
%----------------
%   trials.subjID       - string; subject name in BST protocol
%   trials.data         - {nSenReduced x nTimes x nTrials} matrix of trials data
%   trials.nTrials      - scalar; number of trials
%   trials.sFreq        - scalar; sampling frequency
%   trials.freqBand     - {2 x 1} array;
%   trials.timeRange    - {2 x 1} array;
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov dm.altukhov@ya.ru

    import ups.LoadHeadModel

    ChUsed = 1:306; ChUsed(3:3:end) = []; % use only gradiometers

    % -------- init defaults ------------ %
    if nargin < 6
        protocolPath = '~/PSIICOS_osadtchii';
        fprintf('Setting protocol path to %s \n', protocolPath)
    end


    if ~ischar(condition)
        ME = MException('CallError:wrongType', ...
        'Arg "condition" should have type "string"');
        throw(ME);
    end


    fprintf('Loading data from BST database.. \n');
    G = HM;
    UP = G.UP; % need it for dimensiion reduction
    nCh = size(UP, 1);

    condPath = [protocolPath, '/data/', subjID, '/', condition];
    trialFiles = dir([condPath, '/data*trial*.mat']);
    trials.nTrials = length(trialFiles);

    fprintf('Loading trials (Max %d) : ', trials.nTrials);
    for iTrial = 1:trials.nTrials
        trialFileName = [condPath, '/', trialFiles(iTrial).name];
        aux = load(trialFileName); % load trial
        if(iTrial == 1)
            [~, ind0] = min(abs(aux.Time - timeRange(1)));
            [~, ind1] = min(abs(aux.Time - timeRange(2)));
            T = ind1 - ind0 + 1; 
            trials.data = zeros(nCh, T, trials.nTrials);
            trials.sFreq = 1 ./ (aux.Time(2) - aux.Time(1));
            % ----------- define filter ------------ %
            [b,a] = fir1(128, freqBand / (trials.sFreq / 2), 'bandpass');
        end;
        tmp = filtfilt(b, a, (UP * aux.F(ChUsed,:))')';     % filter and reduce dim
        trials.data(:,:, iTrial) = 1e12 * tmp(:, ind0:ind1);       % crop

        % ----- print counter ----- %
        if iTrial > 1
            for tt = 0:log10(iTrial - 1)
                fprintf('\b'); 
            end
        end
        fprintf('%d', iTrial);
        % ------------------------- %

    end;
    fprintf(' -> Done\n');

    trials.subjID = subjID;
    trials.freqBand = freqBand;
    trials.timeRange = timeRange;
end

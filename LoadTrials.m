function trials = LoadTrials(subjID, condition, freqBand, timeRange, protocolPath)
% ---------------------------------------------------------------------------------------
% Load trials data from brainstorm protocol, reduce dimensions, bandpass filter and crop 
% ---------------------------------------------------------------------------------------
% FORMAT:
%   trials = LoadTrials(subjID, condition, freqBand, timeRange, protocolPath)
% INPUTS:
%   subjID        - string; subject name in BST protocol
%   condition     - string; condition name in BST protocol
%   freqBand      - {2 x 1} array; bandpass filtering frequency range
%   timeRange     - {2 x 1} array; cropping timerange
%   protocolPath  - string; absolute path to BST protocol
% OUTPUTS:
%   trials:
%   trials.subjID       - string; subject name in BST protocol
%   trials.data         - {nSenReduced x nTimes x nTrials} matrix of trials data
%   trials.nTrials      - scalar; number of trials
%   trials.sFreq        - scalar; sampling frequency
%   trials.freqBand     - {2 x 1} array;
%   trials.timeRange    - {2 x 1} array;
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov dm.altukhov@ya.ru

    ChUsed = 1:306; ChUsed(3:3:end) = []; % use only gradiometers

    % -------- init defaults ------------ %
    if nargin < 5
        protocolPath = '~/PSIICOS_osadtchii';
    end
    if nargin < 4
        timeRange = [0, 0.700];
    end
    
    % ---------------------------------- %

    sFreq = 500;                                  % can I figure this out from the data?
    [b,a] = butter(5, freqBand / (sFreq / 2));    % define filter

    fprintf('Loading data from BST database.. \n');
    G = GetHeadModel(subjID, protocolPath);
    UP = G.UP;
    nCh = size(UP, 1);

    condPath = [protocolPath, '/data/', subjID, '/', condition];
    trialFiles = dir([condPath, '/*trial*.mat']);
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
        end;
        tmp = filtfilt(b, a, (UP * aux.F(ChUsed,:))')';     % filter and reduce dim
        trials.data(:,:, iTrial) = tmp(:, ind0:ind1);       % crop

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
    % ------------------------------------------------------------------------------ %
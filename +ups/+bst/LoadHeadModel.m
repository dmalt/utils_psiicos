function HM_ps = LoadHeadModel(subjID, condName, protocolPath, isLR, GainSVDTh, ch_type)
% -------------------------------------------------------
% Load brainstorm and get grid locations matrix for
% subject subjID
% -------------------------------------------------------
% FORMAT:
%   HM_ps = LoadHeadModel(subjID, condName, protocolPath, isLR, GainSVDTh)
% INPUTS:
%   subjID        - string; BST-imported subject name
%   condName      - string; name of condition in BST protocol
%   protocolPath  - string; absolute path to BST protocol
%   isLR          - boolean; if true, take low resolution
%                   cortex (default = true)
%   GainSVDTh     - float; PVU threshold for PCA-driven
%                   sensor space reduction (default = 0.01)
%   ch_type       - string; channel from brainstorm channels structure
%                   for which the head model should be returned
%                   default = 'MEG'
% OUTPUTS:
%   HM_ps             - structure; PSIICOS head model;
%                       forward model operator for reduced
%                       sensor space and additional info.
% -----------
%   HM_ps.gain        - {nSenReduced x nSrc * 2} matrix of
%                       topographies for reduced sensor space
%   HM_ps.UP          - {nSenReduced x nGradiometers} matrix
%                       of transformation between reduced and
%                       normal sensors
%   HM_ps.subjID      - string; BST-imported subject name
%   HM_ps.path        - string; path to BST head model
%                       (file we load from)
%   HM_ps.svdThresh   - float; PVU threshold for PCA-driven
%                       sensor space reduction
%   HM_ps.GridLoc     - {nSrc x 3} matrix of source location
%                       coordinates
%   HM_ps.condName    - string; name of condtion in BST
%                       protocol
%   HM_ps.ch_type     - string; channel type
% ________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.ReduceToTangentSpace
    import ups.ReduceSensorSpace
    import ups.bst.PickChannels

    % ------------- set up defaults ----------- %
    if nargin < 6
        ch_type = 'MEG GRAD';
    end
    if nargin < 5
        GainSVDTh = 0.01;
    end
    if nargin < 4
        isLR = true;
    end
    if nargin < 3
        protocolPath = '~/PSIICOS_osadtchii';
    end
    % ------------------------------------------- %

    % ---------- load BST head model ------------ %
    hm_path = [protocolPath, '/data/', subjID];  % path to subject folder in protocol

    if ~exist(hm_path, 'dir')
        error('LoadError:noSubj', ['Subject not found at ', hm_path] );
    end
    if strcmp(condName, 'raw')
        hmFolderName = dir([hm_path , '/@raw*']);   % wildcard
        hm_path = [hm_path, '/', hmFolderName.name]; % path to HM_ps folder
    elseif ischar(condName)
        hm_path = [hm_path , '/', condName, '/'];
    end
    hmFiles = dir([hm_path, '/headmodel*.mat']); % available HM_ps files
    ch_file = dir([hm_path, '/channel*.mat']);
    if isempty(hmFiles)
        error('LoadError:noFile', 'No head model files');
    end
    if isLR
        [~, key] = min([hmFiles.bytes]); % find HM_ps with smallest size to get LR
    else
        [~, key] = max([hmFiles.bytes]); % find HM_ps with biggest size to get HR
    end
    hm_abs_path = [hm_path, '/', hmFiles(key).name]; % final path to HM_ps
    ch_path = [hm_path, '/', ch_file.name]; % final path to HM_ps

    HM_bst = load(hm_abs_path);
    % -- read channels file from brainstorm protocol -- % 
    channels = load(ch_path);
    channels = channels.Channel;
    ch_used = PickChannels(channels, ch_type);
    % ------------------------------------------------- %

    G2dLR = ReduceToTangentSpace(HM_bst.Gain(ch_used,:), 'all');

    % --------------- reduce sensor space ---------------- %
    if GainSVDTh
        [G2dLRU, UP] = ReduceSensorSpace(G2dLR, GainSVDTh);
    else
        G2dLRU = G2dLR;
        UP = eye(size(G2dLR,1));
    end
    % ---------------------------------------------------- %

    % -------- produce output ------------ %
    HM_ps.subjID = subjID;
    HM_ps.gain = G2dLRU;
    HM_ps.path = hm_path;
    HM_ps.svdThresh = GainSVDTh;
    HM_ps.UP = UP;
    HM_ps.GridLoc = HM_bst.GridLoc;
    HM_ps.condName = condName;
    HM_ps.ch_type = ch_type;
    % ------------------------------------ %
end

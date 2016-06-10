function HM_ps = LoadHeadModel(subjID, condName, protocolPath, isLR, GainSVDTh)
% -------------------------------------------------------
% Load brainstorm and get grid locations matrix for 
% subject subjID 
% -------------------------------------------------------
% FORMAT:
%   HM_ps = LoadHeadModel(subjID, protocolPath, isLR, GainSVDTh) 
% INPUTS:
%   subjID        - string; BST-imported subject name
%   protocolPath  - string; absolute path to BST protocol
%   isLR          - boolean; if true, take low resolution
%                   cortex (default = true)
%   GainSVDTh     - float; PVU threshold for PCA-driven 
%                   sensor space reduction (default = 0.01)
% OUTPUTS:
%   HM_ps             - structure; forward model operator 
%                   for reduced sensor space and additional
%                   info.
% -----------
%   HM_ps.gain        - {nSenReduced x nSrc * 2} matrix of 
%                   topographies for reduced sensor space
%   HM_ps.UP          - {nSenReduced x nGradiometers} matrix
%                   of transformation between reduced and
%                   normal sensors
%   HM_ps.subjID      - string; BST-imported subject name
%   HM_ps.path        - string; path to  
%   HM_ps.svdThresh   - float; PVU threshold for PCA-driven 
%                   sensor space reduction
% ________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    % ------------- set up defaults ----------- %
    if nargin < 5
        GainSVDTh = 0.01;
    end
    if nargin < 4 
        isLR = true;
    end
    if nargin < 3
        protocolPath = '~/PSIICOS_osadtchii';
    end
    %-------------------------------------------%

    % ---------- load BST head model ------------ %
    hm_path = [protocolPath, '/data/', subjID];  % path to subject folder in protocol

    if ~exist(hm_path, 'dir')
        error('LoadError:noSubj', 'Subject not found');
    end
    if strcmp(condName, 'raw')
        hmFolderName = dir([hm_path , '/@raw*/']);   % wildcard
        hm_path = [hm_path, '/', hmFolderName.name]; % path to HM_ps folder
    elseif ischar(condName)
        hm_path = [hm_path , '/', condName, '/'];
    end 
    hmFiles = dir([hm_path, '/headmodel*.mat']); % available HM_ps files
    if isempty(hmFiles)
        error('LoadError:noFile', 'No head model files');
    end
    if isLR
        [~, key] = min([hmFiles.bytes]); % find HM_ps with smallest size to get LR
    else
        [~, key] = max([hmFiles.bytes]); % find HM_ps with biggest size to get HR
    end
    hm_path = [hm_path, '/', hmFiles(key).name]; % final path to HM_ps
    HM_bst = load(hm_path);
    % ------------------------------------------- %    

    G2dLR = ReduceToTangentSpace(HM_bst.Gain, 'grad');

    % --------------- reduce sensor space ---------------- %
    [ug,~,~] = spm_svd(G2dLR * G2dLR', GainSVDTh);
    UP = ug';
    G2dLRU = UP * G2dLR;
    % ---------------------------------------------------- %

    % -------- produce output ------------ %
    HM_ps.subjID = subjID;
    HM_ps.gain = G2dLRU;
    HM_ps.path = hm_path;
    HM_ps.svdThresh = GainSVDTh;
    HM_ps.UP = UP;
    HM_ps.GridLoc = HM_bst.GridLoc;
    HM_ps.condName = condName;
    % ------------------------------------ %
end
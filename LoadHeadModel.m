function G = LoadHeadModel(subjID, protocolPath, isLR, GainSVDTh)
% -------------------------------------------------------
% Load brainstorm and get grid locations matrix for 
% subject subjID 
% -------------------------------------------------------
% FORMAT:
%   G = LoadHeadModel(subjID, protocolPath, isLR, GainSVDTh) 
% INPUTS:
%   subjID        - string; BST-imported subject name
%   protocolPath  - string; absolute path to BST protocol
%   isLR          - boolean; if true, take low resolution
%                   cortex (default = true)
%   GainSVDTh     - float; PVU threshold for PCA-driven 
%                   sensor space reduction (default = 0.01)
% OUTPUTS:
%   G             - structure; forward model operator 
%                   for reduced sensor space and additional
%                   info.
% -----------
%   G.data        - {nSenReduced x nSrc * 2} matrix of 
%                   topographies for reduced sensor space
%   G.UP          - {nSenReduced x nGradiometers} matrix
%                   of transformation between reduced and
%                   normal sensors
%   G.subjID      - string; BST-imported subject name
%   G.path        - string; path to  
%   G.svdThresh   - float; PVU threshold for PCA-driven 
%                   sensor space reduction
% ________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    if nargin < 4
        GainSVDTh = 0.01;
    end
    if nargin < 3 
        isLR = true;
    end
    if nargin < 2
        protocolPath = '~/PSIICOS_osadtchii';
    end

    % -------- load BST head model ------------ %
    hm_path = [protocolPath, '/data/', subjID];  % path to subject folder in protocol
    hmFolderName = dir([hm_path , '/@raw*/']);   % wildcard
    hm_path = [hm_path, '/', hmFolderName.name]; % path to HM folder

    hmFiles = dir([hm_path, '/headmodel*.mat']); % available HM files

    if isLR
        [~, key] = min([hmFiles.bytes]); % find HM with smallest size to get LR
    else
        [~, key] = max([hmFiles.bytes]); % find HM with biggest size to get HR
    end

    hm_path = [hm_path, '/', hmFiles(key).name]; % final path to HM
    HM = load(hm_path);
    % ----------------------------------------- %    

    chUsed = 1:306; chUsed(3:3:end) = []; % use only gradiometers
    nSites = size(HM.GridLoc, 1);
    nCh    = length(chUsed);
    G2dLR  = zeros(nCh, nSites * 2);

    % ------------ reduce tangent space ------------- %
    range = 1:2;
    for i = 1:nSites
        gainOneSrc = [HM.Gain(chUsed, 1 + 3 * (i - 1)) ...
             HM.Gain(chUsed, 2 + 3 * (i - 1)) ...
             HM.Gain(chUsed, 3 + 3 * (i - 1))];
        [u, ~, ~] = svd(gainOneSrc);
        gt = u(:, 1:2);
        G2dLR(:, range) = gt;
        range = range + 2;
    end;
    % ---------------------------------------------- %

    % --------------- reduce sensor space ---------------- %
    [ug,~,~] = spm_svd(G2dLR * G2dLR', GainSVDTh);
    UP = ug';
    G2dLRU = UP * G2dLR;
    % ---------------------------------------------------- %

    % -------- produce output ------------ %
    G.subjID = subjID;
    G.data = G2dLRU;
    G.path = hm_path;
    G.svdThresh = GainSVDTh;
    G.UP = UP;
    % ------------------------------------ %
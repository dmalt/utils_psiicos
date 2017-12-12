function [Ctx, CtxHR, CtxHHR] = GetCtx(subjID, protocol_path)
% -------------------------------------------------------
% Load low and hidh resolution cortex surfaces from BST
% protocol
% -------------------------------------------------------
% FORMAT:
%   [Ctx, CtxHR] = GetCtx(subjID, protocolPath)
% INPUTS:
%   subjID        - string; bst subj name
%   protocolPath  - string; abs path to bst protocol
% OUTPUTS:
%   Ctx           - struct; low res cortex surface
%   CtxHR         - struct; high res cortes surface
% _______________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.bst.GetCtxPaths

    % if nargin < 2
    %     protocol_path = '/home/dmalt/Documents/MATLAB/bst/brainstorm_db/mentrot';
    % end
    [pathCtx, pathCtxHR, pathCtxHHR] = GetCtxPaths(subjID, protocol_path);
    if ~isempty(pathCtx)
        Ctx   = load(pathCtx);
    else
        Ctx = [];
    end

    if ~isempty(pathCtxHR)
        CtxHR = load(pathCtxHR);
    else
        CtxHR = [];
    end
    if ~isempty(pathCtxHHR)
        CtxHHR = load(pathCtxHHR);
    else
        CtxHHR = [];
    end
end

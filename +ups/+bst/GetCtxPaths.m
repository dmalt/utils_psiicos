function [pathCtx, pathCtxHR, pathCtxHHR] = GetCtxPaths(subjName, Protocol_path)
% -------------------------------------------------------
% Get paths to triangulated cortex surfaces from brainstorm
% protocol
% -------------------------------------------------------
% FORMAT:
%   [pathCtx, pathCtxHR] = GetCtxPaths(subjName, Protocol_path)
% INPUTS:
%   subjName        - string; name of the subject
%   Protocol_path   - string; absolute path to
%                     brainstorm protocol
%
% OUTPUTS:
%   pathCtx         - string; absolute path to low resolution
%                     surface in BST protocol folder
%   pathCtxHR       - string; absolute path to high resolution
%                     surface in BST protocol folder
% TODO:
%   Find all Ctx files in subdirs of bst database
%   instead of looking for just 3 surfaces
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    % Define test arguments
    if nargin < 2
        Protocol_path = '/home/dmalt/Documents/MATLAB/bst/brainstorm_db/mentrot';
    end
    if nargin < 1
        subjName = 'biomag2010';
    end
    %----------------------%

    pathCtx  = '';
    pathCtxHR = '';
    pathCtxHHR = '';

    anatPath = [Protocol_path, '/anat/', subjName];
    if exist(anatPath, 'dir')
        files = dir(anatPath);
    else
        fprintf('ERROR: %s: "%s" doesn''t exist!', 'GetCtxPaths.m', anatPath);
        fprintf('\n');
        return;
    end
    isFoundHR = false;
    isFoundLR = false;
    isFoundHHR = false;
    for iFile = 1:length(files)
        match_HR = regexp(files(iFile).name, 'tess_cortex_?(concat|pial_low)\.mat');
        match_LR = regexp(files(iFile).name, 'tess_cortex_?(concat|pial_low)_\d+V\.mat');
        match_HHR = regexp(files(iFile).name, 'tess_cortex_?(concat|pial_high)\.mat');

        if ~isempty(match_HR)
            isFoundHR = true;
            pathCtxHR = [anatPath, '/',files(iFile).name];
        elseif ~isempty(match_LR)
            isFoundLR = true;
            pathCtx = [anatPath, '/', files(iFile).name];
        elseif ~isempty(match_HHR)
            isFoundHHR = true;
            pathCtxHHR = [anatPath, '/', files(iFile).name];
        end
    end
    if ~isFoundHR
        fprintf('Failed to find HR cortex for subject %s in %s' , subjName, Protocol_path)
        fprintf('\n');
    end

    if ~isFoundLR
        fprintf('Failed to find HR cortex for subject %s in %s' , subjName, Protocol_path)
        fprintf('\n');
    end

    if ~isFoundHHR
        fprintf('Failed to find HHR cortex for subject %s in %s' , subjName, Protocol_path)
        fprintf('\n');
        pathCtx = '';
    end
end

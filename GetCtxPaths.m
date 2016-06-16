function [pathCtx, pathCtxHR] = GetCtxPaths(subjName, Protocol_path)
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
%                     surface
%   pathCtxHR       - string; absolute path to high resolution
%                     surface;
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	% Define test arguments
	if nargin < 2
		Protocol_path = '/home/dmalt/PSIICOS_osadtchii';
	end
	if nargin < 1
		subjName = '0003_pran';
	end
	%----------------------%

	pathCtx  = [];
	pathCtxHR = [];
	
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
	for iFile = 1:length(files)
		match_HR = regexp(files(iFile).name, 'tess_cortex_?(concat|pial_low)\.mat');
		match_LR = regexp(files(iFile).name, 'tess_cortex_?(concat|pial_low)_\d+V\.mat');

		if ~isempty(match_HR)
			isFoundHR = true;
			pathCtxHR = [anatPath, '/',files(iFile).name];
		elseif ~isempty(match_LR)
			isFoundLR = true;
			pathCtx = [anatPath, '/', files(iFile).name];
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
	return;
function [Ctx, CtxHR, CtxHHR] = GetCtx(subjID, protocolPath)
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

	import ups.GetCtxPaths

	if nargin < 2
		protocolPath = '/home/dmalt/PSIICOS_osadtchii';
	end
	[pathCtx, pathCtxHR, pathCtxHHR] = GetCtxPaths(subjID, protocolPath);
	Ctx   = load(pathCtx);
	CtxHR = load(pathCtxHR);
	CtxHHR = load(pathCtxHHR);

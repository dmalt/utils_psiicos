function [Ctx, CtxHR] = GetCtx(subjID, protocolPath)
	if nargin < 2
		protocolPath = '/home/dmalt/PSIICOS_osadtchii';
	end
	[pathCtx, pathCtxHR] = GetCtxPaths(subjID, protocolPath);
	Ctx   = load(pathCtx);
	CtxHR = load(pathCtxHR);

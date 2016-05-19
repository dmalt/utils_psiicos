classdef Connections < handle
	properties (Access = private)
		BST_path % path to brainstorm protocol
		CtxHR    % high res. cortex surface 
		Ctx      % low res. cortex surface
	end
	properties
		headModel 		 
		subjId
		conInds
		% Clusters % Will have con indices and center index
		conData % Conditions and trials
	end 

	methods
		PlotCon(obj, iCol)      % plot connections on HR brain
		PlotClust(obj, inds)    % plot clusters in dif. colors
		PlotCent(obj, inds)     % plot clust. centers  
		PlotPhase(obj, inds)    % plot phases for selected centers
		Clusterize(obj)			% clusterize connections

		% PairwiseClust(obj, distThresh, clustSizeThresh)

		% --- constructor --- %
		function obj = Connections(subjId, conInds, BST_path)
			if nargin < 3
				obj.BST_path = '/home/dmalt/PSIICOS_osadtchii';
			elseif nargin >= 3
				obj.BST_path = BST_path;
			end
			obj.subjId = subjId;
			[pathCtx, pathCtxHR] = GetCtxPaths(subjId, obj.BST_path);
			obj.Ctx = load(pathCtx);
			obj.CtxHR = load(pathCtxHR);
			obj.conInds = conInds;
			obj.headModel = GetHeadModel(subjId, obj.BST_path);
			% obj.Clusters = 
		end
		% ------------------- % 
	end
end
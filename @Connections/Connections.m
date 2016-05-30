classdef Connections < handle
	properties (Access = private)
		protocolPath 	 % path to brainstorm protocol
		CtxHR         	 % high res. cortex surface 
		Ctx           	 % low res. cortex surface
		CT               % cross-spectrum timeseries
		headModel 		 % low res. head model struct from BST
	end
	properties
		subjId			 % brainstorm subj. name
		condName		 % 
		freqBand
		timeRange
		conInds			 % 
		% Clusters 		 % will have con indices and center index
	end 

	methods
		PlotCon(obj, iCol)      % plot connections on HR brain
		PlotClust(obj, inds)    % plot clusters in dif. colors
		PlotCent(obj, inds)     % plot clust. centers  
		PlotPhase(obj, inds)    % plot phases for selected centers
		Clusterize(obj)			% clusterize connections

		% PairwiseClust(obj, distThresh, clustSizeThresh)

		% ----------------------- constructor ---------------------- %
		function obj = Connections(subjId, conInds, freqBand,...
		                           timeRange, CT, protocolPath)
			if nargin < 6
				obj.protocolPath = '/home/dmalt/PSIICOS_osadtchii';
			elseif nargin >= 6
				obj.protocolPath = protocolPath;
			end
			obj.subjId = subjId;
			[pathCtx, pathCtxHR] = GetCtxPaths(subjId, obj.protocolPath);
			obj.Ctx       = load(pathCtx);
			obj.CtxHR     = load(pathCtxHR);
			obj.conInds   = conInds;
			obj.freqBand  = freqBand;
			obj.timeRange = timeRange;
			obj.headModel = LoadHeadModel(subjId, obj.protocolPath);
			% obj.CT 		  = CT;
		end
		% --------------------------------------------------------- % 
	end
end
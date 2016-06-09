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
		                           timeRange, CT, condName, HM, CtxHR)
		
			obj.subjId    = subjId;
			obj.CtxHR     = CtxHR;
			obj.conInds   = conInds;
			obj.freqBand  = freqBand;
			obj.timeRange = timeRange;
			obj.condName  = condName;
			obj.headModel = HM;
			% obj.CT 		  = CT;
		end
		% --------------------------------------------------------- % 
	end
end
classdef Connections 
	properties (Access = private)
		protocolPath 	 % path to brainstorm protocol
		CtxHR         	 % high res. cortex surface 
		Ctx           	 % low res. cortex surface
		CT               % cross-spectrum timeseries
		headModel 		 % low res. head model struct from BST
	end
	properties
		subjId			 % BST subj name
		condName		 % BST condition name
		freqBand		 % {1 x 2} array; frequency band
		timeRange		 % {1 x 2} array;
		conInds			 % {nConnections x 2}; 
	end 

	methods
		Plot(obj, iCol)                          % plot connections on HR brain
		PlotPhase(obj, src, event)				 % plot amplitude and phase for connecion
		obj = Clusterize(obj, clustSize, dPair)	 % clusterize connections
		obj = Average(obj)						 % average connections.
		obj = Merge(obj)						 % merge connection indeces

		% ----------------------- constructor ---------------------- %
		function obj = Connections(subjId, conInds, freqBand,...
		                           timeRange, CT, condName, HM, CtxHR)
			if iscell(conInds)
				obj.conInds = conInds;
			else
				obj.conInds{1} = conInds;
			end
			obj.subjId    = subjId;
			obj.CtxHR     = CtxHR;
			obj.freqBand  = freqBand;
			obj.timeRange = timeRange;
			obj.condName  = condName;
			obj.headModel = HM;
			obj.CT 		  = CT;
		end
		% --------------------------------------------------------- % 
	end
end
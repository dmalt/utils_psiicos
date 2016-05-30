classdef sConnections < Connections & pran.sInits
	methods
		function obj = sConnections(ConInds)
			obj@Connections(ConInds);
		end
	end
end
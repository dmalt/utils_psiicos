function obj = Clusterize(obj, clustSize, dPair)
	% dPair = 0.02;
	% clustSize = 2;
	obj = obj.Merge();
	obj.conInds = PairwiseClust(obj.conInds{1}, obj.headModel.GridLoc, dPair, clustSize);
    for iClust = 1:length(obj.conInds)
        obj.conInds{iClust} = CoOrientCluster(obj.conInds{iClust}, obj.headModel.GridLoc);
    end
    % return obj
end
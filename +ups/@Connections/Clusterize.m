function obj = Clusterize(obj, clustSize, dPair)
% -----------------------------------------------
% Perform pairwise clustering on connections
% -----------------------------------------------
    import ups.PairwiseClust
    import ups.CoOrientCluster

    obj = obj.Merge();
    obj.conInds = PairwiseClust(obj.conInds{1}, obj.headModel.GridLoc, dPair, clustSize);
    for iClust = 1:length(obj.conInds)
        obj.conInds{iClust} = CoOrientCluster(obj.conInds{iClust}, obj.headModel.GridLoc);
    end
end

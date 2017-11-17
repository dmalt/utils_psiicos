function obj = Clusterize(obj, d_pair, clust_size)
% ------------------------------------------------
% Merge sticks from all clusters into one and
% perform pairwise clustering.
% ------------------------------------------------
% INPUT:
%   d_pair      - float; thresholc distance between stick
%                ends in meters; default = 0.01 (1cm)
%   clust_size - int; minimal number of sticks in 
%                cluster; smaller clusters are not
%                saved; default = 1
% OUTPUT:
%   C          - Connections instancsss
% ________________________________________________
% AUTHOR: dmalt (dm.altukhov@ya)

    import ups.PairwiseClust
    import ups.CoOrientCluster

    if nargin < 3
        clust_size = 1;
    end

    if nargin < 2
        d_pair = 0.01;
    end

    obj = obj.Merge();
    obj.conInds = PairwiseClust(obj.conInds{1}, obj.headModel.GridLoc, d_pair, clust_size);
    for iClust = 1:length(obj.conInds)
        obj.conInds{iClust} = CoOrientCluster(obj.conInds{iClust}, obj.headModel.GridLoc);
    end
end

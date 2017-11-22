function obj = Threshold(obj, n)
    ind = [];
    for i_clust = 1:length(obj.conInds)
        n_connections = size(obj.conInds{i_clust},1);
        if n_connections > n
            ind = [ind, i_clust];
        end
    end
    obj = obj.Get(ind);
end

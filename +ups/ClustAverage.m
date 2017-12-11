function  [ClustCenters, means, vars] = ClustAverage(clusters, GridLoc)
% -------------------------------------------------------------
% Given indices of connected sites calculate average connection
% and map it onto the grid nodes. Return indices of these nodes.
% -------------------------------------------------------------
% FORMAT:
%   ClustCenters = ClustAverage(SetInd, GridLoc, clustRadius, clustSize) 
% INPUTS:
%   clusters     - {nClusters x 1} cell array; each cell is 
%                  {nBundles x 2} matrix of inds if con. sites
%   GridLoc      - {nSources x 3} matrix of grid nodes 
%                  coordinates
% OUTPUTS:
%   ClustCenters - {nClusters x 2} matrix of indices of 
%                  cluster centers.
%  NOTE:
%   Clusters must be co-oriented
% _____________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.FindXYZonGrid    

    nClust = length(clusters);
    ClustCenters = zeros(nClust, 2);
    means = cell(nClust,2);
    vars = cell(nClust,2);

    for iClust = 1:nClust
        clust = clusters{iClust};

        lefts = GridLoc(clust(:, 1), :);
        rights = GridLoc(clust(:, 2), :);

        % ----- Find coords of left and right centers of a cluster -------- %
        lefts_average = mean(lefts, 1);
        rights_average = mean(rights, 1);

        lefts_var = sum(var(lefts, 1));
        rights_var = sum(var(rights, 1));

        xyz_i = lefts_average;
        xyz_j = rights_average;

        means{iClust,1} = xyz_i;
        means{iClust,2} = xyz_j;

        vars{iClust,1} = lefts_var;
        vars{iClust,2} = rights_var;

        ind_i = FindXYZonGrid(xyz_i, GridLoc);
        ind_j = FindXYZonGrid(xyz_j, GridLoc);
        ClustCenters(iClust,:) = [ind_i, ind_j];
        % ----------------------------------------------------------------- %
    end
end

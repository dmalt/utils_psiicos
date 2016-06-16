function  ClustCenters = ClustAverage(clusters, R)
% -------------------------------------------------------------
% Given indices of connected sites calculate average connection
% and map it onto the grid nodes. Return indices of these nodes.
% -------------------------------------------------------------
% FORMAT:
%   ClustCenters = ClustAverage(SetInd, R, clustRadius, clustSize) 
% INPUTS:
%   SetInd       - {nConnections x 2} matrix of indices of 
%                  connected pairs
%   R            - {nSources x 3} matrix of grid nodes 
%                  coordinates
%   clustDist    - scalar; assign connections to the same
%                  cluster if their ends are closer then
%                  clustDist 
%   clustSize    - scalar; minimal number of connections
%                  in cluster. Smaller clusters are dropped out
% OUTPUTS:
%   ClustCenters - {nClusters x 2} matrix of indices of 
%                  cluster centers.
% _____________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	% [clusters] = PairwiseClust(SetInd, R, clustDistance, clustSize); % clusters is a matrix {nClusters x nConnections}

	nClust = length(clusters);
	ClustCenters = zeros(nClust, 2);

	for iClust = 1:nClust
		clust = clusters{iClust};

		lefts = R(clust(:, 1), :);
		rights = R(clust(:, 2), :);

		% ----- Find coords of left and right centers of a cluster -------- %
		lefts_average = mean(lefts, 1);
		rights_average = mean(rights, 1);

		xyz_i = lefts_average;
		xyz_j = rights_average;

		ind_i = FindXYZonGrid(xyz_i, R);
		ind_j = FindXYZonGrid(xyz_j, R);
		ClustCenters(iClust,:) = [ind_i, ind_j];
		% ----------------------------------------------------------------- %
	end

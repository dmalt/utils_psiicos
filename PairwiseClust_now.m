function [clusters] = PairwiseClust(connections, Dpair, clustSize)
% ------------------------------------------------------------------------
% PairwiseClust: perform pairwise clustering procedure
% on bootstrap connections. Retrun cell array with indices of clustered 
% connections
% ------------------------------------------------------------------------
% FORMAT:
%   [clusters] = PairwiseClust(DipInd, R, Dpair, clustSize) 
% INPUTS:
%   DipInd        - {nBootsrapIterations x 1} cell array; each cell is 
%                     {nconnections x 2} matrix with indices of connected
%                     pairs
%   R               - {nSites x 3} matrix of grid locations
%   Dpair           - float; pairwise clustering distance threshold
%   clustSize       - int; clustersize threshold
% OUTPUTS:
%   clusters        - {nClusters x 1} cell array; each cell is
%                     {nClustconnections x 2} matrix containing indices of
%                     connected pairs for this cluster
% ________________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import(connections.GetImportStr());
    DipInd = connections.ConInds;
    disp(DipInd)
    R = connections.GridXYZ;

    clusters = {};

    % ----------- Pairwise clustering ------------------------------ %
    [Npairs, ~] = size(DipInd);
    adjMat = zeros(Npairs, Npairs);
    for p1 = 1:Npairs
        for p2 = p1:Npairs
            if norm(R(DipInd(p1, 1),:) - R(DipInd(p2,1),:)) < Dpair ...
    && norm(R(DipInd(p1,2),:) - R(DipInd(p2,2),:)) < Dpair || ...
               norm(R(DipInd(p1, 1),:) - R(DipInd(p2,2),:)) < Dpair ...
    && norm(R(DipInd(p1,2),:) - R(DipInd(p2,1),:))
                adjMat(p1,p2) = 1;
                adjMat(p2,p1) = 1;
            end
        end
    end

    % N = size(DipInd, 1);
    i = 1; % Number of column in adjacence martrix
    clustNum = 0;
    % clusters = cell(1, 20);
    restPairs = DipInd;
    while(~isempty(restPairs))
        if length(nonzeros(bfs(adjMat,i) > 0)) > clustSize;
            % restPairs(i,:)
            clustNum = clustNum + 1;
            clustInds = restPairs(bfs(adjMat,i) > -1,:);
            % drawset(clust, R, cols(clustNum,:));
            clust = sCluster(clustInds, R);
            clusters{clustNum} = clust;
            restPairs = restPairs(bfs(adjMat, i) == -1,:);
            adjMat = adjMat(bfs(adjMat, i) == -1, bfs(adjMat, i) == -1);
        	% L1 = line( R(restPairs(i,:), 1), R(restPairs(i,:),2), R(restPairs(i,:),3) );
        	% plot3( R(restPairs(i,1), 1), R(restPairs(i,1),2), R(restPairs(i,1),3), 'c.', 'Markersize', 40 );
       		% plot3( R(restPairs(i,2), 1), R(restPairs(i,2),2), R(restPairs(i,2),3), 'c.', 'Markersize', 40 );
        	% set(L1, 'Color', 'c', 'linewidth',2);
            % i = 1;
        else
            restPairs = restPairs(2:end, :);
            adjMat = adjMat(2:end, 2:end);
            % i = i + 1;
        end
    end
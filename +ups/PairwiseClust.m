function [clusters] = PairwiseClust(DipInd, GridLoc, Dpair, clustSize)
% ------------------------------------------------------------------------
% PairwiseClust: perform pairwise clustering procedure
% on connections 
% ------------------------------------------------------------------------
% FORMAT:
%   [clusters] = PairwiseClust(BootsIND, GridLoc, Dpair, clustSize) 
% INPUTS:
%   BootsIND        - {nBootsrapIterations x 1} cell array; each cell is 
%                     {nBundles x 2} matrix with indices of connected
%                     pairs
%   GridLoc         - {nSites x 3} matrix of grid locations
%   Dpair           - float; pairwise clustering distance threshold
%   clustSize       - int; clulstersize threshold
% OUTPUTS:
%   clusters        - {nClusters x 1} cell array; each cell is
%                     {nSticks x 2} matrix containing indices of
%                     connected pairs for this cluster
%  NOTES:
%    Pairwise clustering algorithm is described at
%    "Connectivity differences in brain networks",
%    Zalesky et al., Neuroimage, 2012, doi: 10.1016/j.neuroimage.2012.01.068 
% ________________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import ups.ext.bfs

    clusters = {};
    % -------------- create adjacence matrix ------------------ %
    [Npairs, ~] = size(DipInd);
    adjMat = zeros(Npairs, Npairs);
    for p1 = 1:Npairs
        for p2 = p1:Npairs
            areCloseCoDir = norm(GridLoc(DipInd(p1,1),:) - GridLoc(DipInd(p2,1),:))  < Dpair ...
                         && norm(GridLoc(DipInd(p1,2),:) - GridLoc(DipInd(p2,2),:))  < Dpair;
            areCloseContraDir = norm(GridLoc(DipInd(p1,1),:) - GridLoc(DipInd(p2,2),:))  < Dpair ...
                             && norm(GridLoc(DipInd(p1,2),:) - GridLoc(DipInd(p2,1),:))  < Dpair;
            if  areCloseCoDir || areCloseContraDir
                adjMat(p1,p2) = 1;
                adjMat(p2,p1) = 1;
            end
        end
    end
    % -------------------------------------------------------- %

    % ------------- clusterize using breadth first search ------------- %
    iCol = 1; % Column index in adjacency martrix
    clustNum = 0;
    restPairs = DipInd;
    while(~isempty(restPairs))
        if length(nonzeros(bfs(adjMat, iCol) >= 0)) >= clustSize;
            clust = restPairs(bfs(adjMat,iCol) > -1,:);
            clustNum = clustNum + 1;
            clusters{clustNum} = clust;
            restPairs = restPairs(bfs(adjMat, iCol) == -1,:);
            adjMat = adjMat(bfs(adjMat, iCol) == -1, bfs(adjMat, iCol) == -1);
        else
            restPairs = restPairs(2:end,:);
            adjMat = adjMat(2:end,2:end);
        end
    end
    % ----------------------------------------------------------------- %
end

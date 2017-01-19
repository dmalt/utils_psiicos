function clustInds = CoOrientCluster(clustInds, GridLoc)
% -------------------------------------------------------
% Swap ends of connections that are contradirectional
% with the first connection in the cluster
% -------------------------------------------------------
% FORMAT:
%   clustInds = CoOrientCluster(clustInds, GridLoc) 
% INPUTS:
%   clustInds        - {nConnections x 2} matrix 
%                      of indices of connected sources
%   GridLoc          - {nSources x 3} matrix of
%                      sources coordinates
% OUTPUTS:
%   clustInds        - {nConnections x 2} matrix 
%                      of indices of connected sources
% _______________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    nConnections = size(clustInds, 1);
    v1 = GridLoc(clustInds(1,2),:) - GridLoc(clustInds(1,1),:);
    for iConn = 2 : nConnections
        v_cur = GridLoc(clustInds(iConn, 2),:) - GridLoc(clustInds(iConn,1),:);
        if v1 * v_cur' < 0
            clustInds(iConn,:) = clustInds(iConn, 2:-1:1);
        end
    end
end
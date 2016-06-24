function lineHandles = drawset(conInds, Loc, col)
% -------------------------------------------------------
% Draw set of indices ConIndS using grid locations Loc 
% and color col
% -------------------------------------------------------
% FORMAT:
%   drawset(conInds, Loc, col) 
% INPUTS:
%   conInds  - {nConnections x 2} matrix of connection 
%              indices
%   Loc      - {nLocations x 3} matrix of xyz coordinates
%              of sensors or source grid locations
%   col      - char or {1 x 3} array; color for connections
% OUTPUTS:
%   lineHandles  - {nConnections x 1} cell array of handles 
%                  to lines representing connections.
% ___________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    linewidth = 2;
    Markersize = 40;
    lineHandles = {};
    for i = 1:size(conInds, 1)
            lineHandles{i} = line( Loc(conInds(i,:), 1), Loc(conInds(i,:),2), Loc(conInds(i,:),3));
            plot3( Loc(conInds(i, 1), 1), Loc(conInds(i, 1), 2), Loc(conInds(i, 1), 3),'.', 'Color', col, 'Markersize', Markersize );
            plot3( Loc(conInds(i, 2), 1), Loc(conInds(i, 2), 2), Loc(conInds(i, 2), 3),'.', 'Color', col, 'Markersize', Markersize );
            set(lineHandles{i}, 'Color', col, 'linewidth', linewidth);
    end
end
 
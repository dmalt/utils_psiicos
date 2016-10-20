function lineHandles = drawset(conInds, Loc, col, linewidth, m_radius)
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
	if nargin < 5
	    m_radius = 0.02;
	end

	if nargin < 4
	    linewidth = 2;
	end
    linecol = col;
    lineHandles = {};
    for i = 1:size(conInds, 1)
            lineHandles{i} = line( Loc(conInds(i,:), 1), Loc(conInds(i,:),2), Loc(conInds(i,:),3));

            sphere_marker(Loc(conInds(i,1),1), Loc(conInds(i,1),2), Loc(conInds(i,1),3), m_radius, col)
            sphere_marker(Loc(conInds(i,2),1), Loc(conInds(i,2),2), Loc(conInds(i,2),3), m_radius, col)

            set(lineHandles{i}, 'Color', linecol, 'linewidth', linewidth);
    end
end


function sphere_marker(x0, y0, z0, r, col) 

    [x,y,z] = sphere;
    % r = 0.002;
    x = r * x; y = r * y; z = r * z;
    x = x + x0; y = y + y0; z = z + z0;
    h = surf(x,y,z);
    set(h,'Facecolor', col, 'EdgeColor', 'none');
end
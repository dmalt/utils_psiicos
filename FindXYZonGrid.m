function ind = FindXYZonGrid(xyz, GridLoc)
% -------------------------------------------------------
% Given a point in 3-d spacd find the closest node on grid.
% -------------------------------------------------------
% FORMAT:
%   ind = FindXYZonGrid(xyz, GridLoc) 
% INPUTS:
%   xyz        - {1 x 3} row-vector; coordinates of a point
%   GridLoc    - {nSrc x 3} matrix of grid locations
% OUTPUTS:
%   ind        - integer; index of grid location that is 
%                the closest to specified point.
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	temp_Loc = sum( ( GridLoc - repmat(xyz, [size(GridLoc, 1), 1]) ) .^ 2, 2  );
	[~, inds_sort] = sort(temp_Loc);
	ind = inds_sort(1);
end
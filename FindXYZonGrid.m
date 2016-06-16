function ind = FindXYZonGrid(xyz, GridLoc)
	temp_Loc = sum( ( GridLoc - repmat(xyz, [size(GridLoc, 1), 1]) ) .^ 2, 2  );
	[~, inds_sort] = sort(temp_Loc);
	ind = inds_sort(1);
end
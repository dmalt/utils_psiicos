function drawset(ConInds, R, col)
% -------------------------------------------------------
% Draw set of indices ConIndS using grid locations R and color col
% -------------------------------------------------------
% FORMAT:
%   drawset(ConInds, R, col) 
% INPUTS:
%   ConInds        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	linewidth = 2;
	Markersize = 40;
	for i = 1:size(ConInds, 1)
			L1 = line( R(ConInds(i,:), 1), R(ConInds(i,:),2), R(ConInds(i,:),3) );
			plot3( R(ConInds(i,1), 1), R(ConInds(i,1),2), R(ConInds(i,1),3),'.', 'Color', col, 'Markersize', Markersize );
	        plot3( R(ConInds(i,2), 1), R(ConInds(i,2),2), R(ConInds(i,2),3),'.', 'Color', col, 'Markersize', Markersize );
	     	set(L1, 'Color', col, 'linewidth', linewidth);
	end
function PlotCon(obj, iCol)
% -------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on
% brain
% -------------------------------------------------------
% FORMAT:
%   drawConnectionsOnBrain(obj, iSet, iCol) 
% INPUTS:
%   conInds{iSet}        - {nConnections x 2} matrix of indices
%                    of connected grid nodes
%   GridXYZ		   - {nSources x 3} matrix of coordinates
%                    of grid nodes
%   iCol
%   Ctx            - structure; triangular surface of cortex;
%                    usually generated in brainstorm
% OUTP   None
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	if nargin < 2
		iCol = 1;
	end
	orange = [255 141 0] / 256;
	green = [12 232 126] / 256;
	blue = [0 35 255] / 256;
	violet = [174 12 232] / 256;
	yellow = [255 248 13] / 256;
	red = [232 12 143] / 256;
	grey = [112,127,127] / 256;
	colors = {orange; green; blue; violet; yellow; red};
	figure;
	trisurf(obj.CtxHR.Faces,obj.CtxHR.Vertices(:,1),obj.CtxHR.Vertices(:,2),obj.CtxHR.Vertices(:,3),...
					'FaceColor', grey, 'EdgeColor','none','FaceAlpha', 0.6); 
	camlight left; lighting phong;
	camlight right; 
	hold on;
	drawset(obj.conInds, obj.headModel.GridLoc, colors{iCol});
	

function drawset(conInds, R, col)
% -------------------------------------------------------
% Draw set of indices ConIndS using grid locations R and color col
% -------------------------------------------------------
% FORMAT:
%   drawset(conInds, R, col) 
% INPUTS:
%   conInds        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	linewidth = 1;
	Markersize = 40;
	for i = 1:size(conInds, 1)
			L1 = line( R(conInds(i,:), 1), R(conInds(i,:),2), R(conInds(i,:),3) );
			plot3( R(conInds(i,1), 1), R(conInds(i,1),2), R(conInds(i,1),3),'.', 'Color', col, 'Markersize', Markersize );
	        plot3( R(conInds(i,2), 1), R(conInds(i,2),2), R(conInds(i,2),3),'.', 'Color', col, 'Markersize', Markersize );
	     	set(L1, 'Color', col, 'linewidth', linewidth);
	end
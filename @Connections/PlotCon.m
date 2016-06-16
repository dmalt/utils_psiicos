function PlotCon(obj, opacity)
% ---------------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on brain
% ---------------------------------------------------------------
% FORMAT:
%   PlotCon(obj, iCol) 
% INPUTS:
%   obj.conInds{iSet}     - {nConnections x 2} matrix of indices
%                    	    of connected grid nodes
%   obj.headModel.GridLoc - {nSources x 3} matrix of coordinates
%                           of grid nodes
%   iCol
%   Ctx                 - structure; triangular surface of cortex;
%                    	  usually generated in brainstorm
% OUTP   None
% _______________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	if nargin < 2
		opacity = 0.6;
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
	h = trisurf(obj.CtxHR.Faces, obj.CtxHR.Vertices(:,1), ...
								 obj.CtxHR.Vertices(:,2), ...
								 obj.CtxHR.Vertices(:,3), ...
				'FaceColor', grey, 'EdgeColor','none','FaceAlpha', opacity); 
	set(h, 'PickableParts', 'none')
	camlight left; lighting phong;
	camlight right; 
	hold on;
	for iSet = 1:length(obj.conInds)
		iCol = mod(iSet, length(colors));
		if iCol == 0
			iCol = length(colors);
		end
		drawset(obj.conInds{iSet}, obj.headModel.GridLoc, colors{iCol}, obj);
	end
end

function drawset(conInds, R, col, obj)
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

	linewidth = 2;
	Markersize = 40;
	for i = 1:size(conInds, 1)
			L1 = line( R(conInds(i,:), 1), R(conInds(i,:),2), R(conInds(i,:),3));
			plot3( R(conInds(i,1), 1), R(conInds(i,1),2), R(conInds(i,1),3),'.', 'Color', col, 'Markersize', Markersize );
	        plot3( R(conInds(i,2), 1), R(conInds(i,2),2), R(conInds(i,2),3),'.', 'Color', col, 'Markersize', Markersize );
	     	set(L1, 'Color', col, 'linewidth', linewidth);
	     	set(L1,  'ButtonDownFcn', @obj.plotPhase);
	end
end



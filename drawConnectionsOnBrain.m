function drawConnectionsOnBrain(ConInds, GridXYZ, iCol, Ctx)
% -------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on
% brain
% -------------------------------------------------------
% FORMAT:
%   drawConnectionsOnBrain(A, R, iCol, Ctx) 
% INPUTS:
%   ConInds        - {nConnections x 2} matrix of indices
%                    of connected grid nodes
%   GridXYZ		   - {nSources x 3} matrix of coordinates
%                    of grid nodes
%   iCol
%   Ctx            - structure; triangular surface of cortex;
%                    usually generated in brainstorm
% OUTPUTS:
%   None
% _______________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	orange = [255 141 0] / 256;
	green = [12 232 126] / 256;
	blue = [0 35 255] / 256;
	violet = [174 12 232] / 256;
	yellow = [255 248 13] / 256;
	red = [232 12 143] / 256;
	grey = [112,127,127] / 256;
	colors = {orange; green; blue; violet; yellow};
	figure;
	hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),...
					'FaceColor', grey, 'EdgeColor','none','FaceAlpha', 0.6); 
	camlight left; lighting phong;
	camlight right; 
	hold on;
	drawset(ConInds, GridXYZ, colors{iCol});
end
function Plot(obj, opacity, linewidth, m_radius)
% ---------------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on brain
% ---------------------------------------------------------------
% FORMAT:
%   Plot(obj, iCol) 
% INPUTS:
%   obj.conInds{iSet}     - {nConnections x 2} matrix of indices
%                    	    of connected grid nodes
%   obj.headModel.GridLoc - {nSources x 3} matrix of coordinates
%                           of grid nodes
%   obj.Ctx               - structure; triangular surface of cortex;
%                           usually generated in brainstorm
%   opacity               - scalar; opacity of a cortex surface;
%                           should be between 0 and 1;
% __________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	import ups.GetColors
	import ups.drawset

	if nargin < 2
		opacity = 0.6;
	end

	if nargin < 3
		linewidth = 2;
	end

	if nargin < 4 
		m_radius = 0.002;
	end
	
	colorScheme = GetColors();
	bg_color = colorScheme(1).RGB;
	colors = {colorScheme(2:end).RGB};
	
	% ------------ Draw brain ------------------- %
	% figure;
	h_br = trisurf(obj.CtxHR.Faces, ...
				   obj.CtxHR.Vertices(:,1), ...
				   obj.CtxHR.Vertices(:,2), ...
				   obj.CtxHR.Vertices(:,3), ...
				   'FaceColor', bg_color, ...
				   'EdgeColor','none', ...
				   'FaceAlpha', opacity); 

	% - make brain unclicable; without it - %
	% - clicks on connections won't work  - %
	set(h_br, 'PickableParts', 'none') 

	lighting phong;
	axis equal;
	view(-90,90);
	axis off;
	grid off
	camlight right; 
	hold on;
	% ------------------------------------------- %

	% ------------------ Draw connections ---------------------- %
	for iSet = 1:length(obj.conInds)
		iCol = mod(iSet, length(colors));
		if iCol == 0
			iCol = length(colors);
		end
		lineHandles = drawset(obj.conInds{iSet}, obj.headModel.GridLoc, colors{iCol}, linewidth, m_radius);
		
		for i = 1:length(lineHandles)
	     	set(lineHandles{i},  'ButtonDownFcn', @obj.PlotPhase); % make connections clickable
		end
	end
	% ----------------------------------------------------------- %
end

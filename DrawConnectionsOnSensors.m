function h_ax = DrawConnectionsOnSensors(conInds, channels_path, isFun)
% -------------------------------------------------------
% Draw sensor-level connections.
% -------------------------------------------------------
% FORMAT:
%   [h_ax, h_fig]  = DrawConnectionsOnSensors(conInds, channels_path, isFun) 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	if nargin < 3
		isFun = false;
	end
	if nargin < 2
		channels_path = 'channel_vectorview306.mat';
	end
	ChUsed = PickChannels('grad');
	ChLoc = ReadChannelLocations(channels_path, ChUsed);
	% size(ChLoc)
	x = ChLoc(1,:)';
	y = ChLoc(2,:)';
	z = ChLoc(3,:)';
	colors = GetColors();
	bg_color = colors(1).RGB;
	fg_color = colors(2).RGB;
	if isFun
		style = 'p';
		msize = 10;
	else
		style = '.';
		msize = 18;
	end

	plot3(x, y, z, style, 'Color', bg_color, 'MarkerFaceColor', bg_color,'Markersize', msize);
	hold on;
	h_ax = gca;
	% channels = []
	drawset(conInds, ChLoc', fg_color, 1, 10);
end
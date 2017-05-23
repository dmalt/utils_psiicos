function h_ax = DrawConnectionsOnSensors(conInds, channels_path, isFun)
% -----------------------------------------------------------------
% Draw sensor-level connections in 3D.
% -----------------------------------------------------------------
% FORMAT:
%   h_ax = DrawConnectionsOnSensors(conInds, channels_path, isFun) 
% INPUTS:
%   conInds        - {n_connections x 2} array of indices of connected
%                    sensors
%   channels_path  - string; path to brainstorm-extracted structure
%                    with channel locations. Number of channels must
%                    be superior to the max index in conInds
%   isFun          - boolean flag; If true, sensors are plotted as
%                    stars
% OUTPUTS:
%   h_ax           - axis object of generated figure 
% _________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.PickElectaChannels
    import ups.ReadChannelLocations
    import ups.plt.GetColors
    import ups.plt.drawset

    if nargin < 3
        isFun = false;
    end
    if nargin < 2
        channels_path = 'channel_vectorview306.mat';
    end

    ChUsed = PickElectaChannels('grad');
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
    drawset(conInds, ChLoc', fg_color, 1, 0.002);
end

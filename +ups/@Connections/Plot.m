function light_handle = Plot(obj, opacity, linewidth, m_radius)
% ---------------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on brain
% ---------------------------------------------------------------
% FORMAT:
%   Plot(obj, opacity, linewidth, m_radius) 
% INPUTS:
%   obj.conInds{iSet}     - {nConnections x 2} matrix of indices
%                           of connected grid nodes
%   obj.headModel.GridLoc - {nSources x 3} matrix of coordinates
%                           of grid nodes
%   obj.Ctx               - structure; triangular surface of cortex;
%                           usually generated in brainstorm
%   opacity               - scalar; opacity of a cortex surface;
%                           should be between 0 and 1; default=0.6
%   linewidth             - int scalar; default=2
%   m_radius              - float scalar; sphere marker radius
%                           default=0.002
% __________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.plt.GetColors
    import ups.plt.drawset

    if nargin < 2
        opacity = 0.6;
    end

    if nargin < 3
        linewidth = 2;
    end

    if nargin < 4 
        m_radius = 0.002;
    end
    
    colorScheme = GetColors(3);
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

    % whitebg;
    % - make brain unclicable; without it - %
    % - clicks on connections won't work  - %
    set(h_br, 'PickableParts', 'none') 

    lighting phong;
    axis equal;
    view(-90,90);
    axis off;
    grid off
    light_handle = camlight('right'); 
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

function light_handle = Plot(obj, opacity, linewidth, m_radius, icol, alpha)
% ---------------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on brain
% ---------------------------------------------------------------
% FORMAT:
%   Plot(obj, opacity, linewidth, m_radius, icol, alpha)
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
%                           or array of ints with one value per cluster.
%   m_radius              - float scalar; sphere marker radius
%                           default=0.002
%                           or array of floats with one
%                           value per cluster
%   icol                  - positive int or array of
%                           positive ints; if unset, each cluster
%                           is assigned a color in a cyclic manner.
%                           if array, clusters with the same index
%                           will have the same color
%                           default = []
%   alpha                 - float in range [0,1] or array of
%                           those.
%                           opacity of lines in cluster
%                           default = 1
%
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

    if nargin < 5
        icol = [];
    end

    if nargin < 6
        alpha = 1;
    end

% ------------------ check input ------------------------ %
    if ~isscalar(linewidth)
        assert(length(linewidth) == length(obj.conInds),...
               ['Connections.Plot: If non scalar, the length of linewidths should ',...
                'conform to the number of clusters in conInds']);
    end

    assert(all(floor(linewidth) == linewidth),...
           ['Connections.Plot: linewidth must be one integer value ',...
            'or a vector of integers having the ',...
            'same size as the number of clusters ',...
            'in conInds.' ]);

    if ~isscalar(m_radius)
        assert(length(m_radius) == length(obj.conInds),...
               ['Connections.Plot: Nonscalar number of m_radius should ',...
                'conform to the number of clusters in conInds']);
    end

    if ~isempty(icol)
        if ~isscalar(icol)
            assert(length(icol) == length(obj.conInds),...
                   ['Connections.Plot: Nonscalar number of icol should ',...
                    'conform to the number of clusters in conInds']);
        end
        assert(all(floor(icol) == icol),...
               ['Connections.Plot: icol must be one integer value ',...
                'or a vector of integers having the ',...
                'same size as the number of clusters ',...
                'in conInds.' ]);
    end

% ------------------------------------------------------- %

    colorScheme = GetColors(3);
    bg_color = colorScheme(1).RGB;
    colors = {colorScheme(2:end).RGB};
    % ------------ Draw brain ------------------- %
    % figure;
    h_br = trisurf(obj.Ctx.Faces, ...
                   obj.Ctx.Vertices(:,1), ...
                   obj.Ctx.Vertices(:,2), ...
                   obj.Ctx.Vertices(:,3), ...
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
        if isempty(icol)
            iCol = mod(iSet, length(colors));
        else
            if isscalar(icol)
                iCol = mod(icol, length(colors));
            else
                iCol = mod(icol(iSet), length(colors));
            end
        end

        if iCol == 0
            iCol = length(colors);
        end


        if ~isscalar(linewidth)
            lw = linewidth(iSet);
        else
            lw = linewidth;
        end

        if ~isscalar(m_radius)
            mr = m_radius(iSet);
        else
            mr = m_radius;
        end
        % if iSet == 1
        %     c = colors{2};
        %     alpha = 1;
        % else 
        %     c = colors{1};
        %     alpha = 0.3;
        % end
        if isscalar(alpha)
            alpha_ = alpha;
        else
            alpha_ = alpha(iSet);
        end
        lineHandles = drawset(obj.conInds{iSet}, obj.headModel.GridLoc,...
                              colors{iCol}, alpha_, lw, mr);

        for i = 1:length(lineHandles)
            set(lineHandles{i},  'ButtonDownFcn', @obj.PlotPhase); % make connections clickable
        end
    end
    % ----------------------------------------------------------- %
end

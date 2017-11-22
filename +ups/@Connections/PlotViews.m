function lh =  PlotViews(obj, opacity, linewidth, m_radius, icol, alpha)
% -------------------------------------------------------
% Given indices of connected grid locations, grid nodes
% coordinates and cortex surface, draw connections on brain
% in 3 views: right side, top and back
% ---------------------------------------------------------------
% FORMAT:
%   PlotViews(obj, opacity, linewidth, m_radius, icol, alpha)
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
    if nargin < 2
        opacity = 0.6;
    end

    if nargin < 3
        linewidth = obj.lwidth;
    end

    if nargin < 4
        m_radius = obj.m_rad;
    end

    if nargin < 5
        icol = obj.icol;
    end

    if nargin < 6
        alpha = obj.alpha;
    end

    subplot(1,3,1)
    light_handle = obj.Plot(opacity, linewidth, m_radius, icol, alpha);
    view(0,0);
    camlight(light_handle, 'left');


    subplot(1,3,2)
    obj.Plot(opacity, linewidth, m_radius, icol, alpha);

    subplot(1,3,3)
    light_handle = obj.Plot(opacity, linewidth, m_radius, icol, alpha);
    view(-90,0)
    camlight(light_handle, 'right');
end

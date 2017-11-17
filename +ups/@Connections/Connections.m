classdef Connections
% -------------------------------------------------------
% Class to store and visualize source-level connections
% -------------------------------------------------------
% FORMAT:
% function obj = Connections(conInds, HM, Ctx)
%
% INPUTS:
%   subjId        - string; subject name
%   conInds       - {n_connections x 2} array of indices
%                   of connected sources
%   HM            - structure; contains forward operator
%   Ctx           - structure; triangulated brain surface
%
% OUTPUTS:
%   obj           - Connections instance
%
% METHODS:
%   Clusterize    - clusterize sticks;
%   Average       - average sticks within each cluster
%   Merge         - merge all sticks into one cluster
%   Plot          - plot stick on a single brain
%   PlotViews     - plot sticks on a brain in 3 different
%                   views
% USAGE:
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    properties (Access = private)
        Ctx              % high res. cortex surface
        headModel        % low res. head model struct from BST
    end
    properties
        CT               % cross-spectrum timeseries
        subjId           % BST subj name
        condName         % BST condition name
        freqBand         % {1 x 2} array; frequency band
        timeRange        % {1 x 2} array;
        conInds          % {nConnections x 2} cell array;
    end

    methods
        light_handle = Plot(obj, opacity, linewidth, m_radius, icol, alpha)  % plot connections on HR brain
        PlotViews(obj, opacity, linewidth, m_radius, icol, alpha)
        PlotPhase(obj, src, event)                 % plot amplitude and phase for connection
        obj = Clusterize(obj, d_pair, clust_size)  % clusterize connections
        obj = Average(obj)                         % average connections.
        obj = Merge(obj)                           % merge connection indices

        % ----------------------- constructor ---------------------- %
        function obj = Connections(conInds, HM, Ctx)
            if iscell(conInds)
                obj.conInds = conInds;
            else
                obj.conInds{1} = conInds;
            end
            obj.headModel = HM;
            obj.Ctx       = Ctx;
        end
        % ---------------------------------------------------------- %
    end
end

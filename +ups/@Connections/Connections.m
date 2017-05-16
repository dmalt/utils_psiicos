classdef Connections 
% -------------------------------------------------------
% Class to store and visualize source-level connections
% -------------------------------------------------------
% FORMAT:
% function obj = Connections(subjId, conInds, freqBand,...
%                       timeRange, CT, condName, HM, CtxHR)
%    
% INPUTS:
%   subjId        - string; subject name
%   conInds       - {n_connections x 2} array of indices
%                   of connected sources
%   freqBand      - {2 x 1} array of bandpass filter 
%                   frequencies
%   timeRange     - {2 x 1} array of time
%   CT            - {n_sensors ^ 2 x n_times} matrix of
%                   cross-spectrum timeseries
%   condName      - string; name of condition
%   HM            - structure; contains forward operator
%   CtxHR         - structure; triangulated brain surface
% 
% OUTPUTS:
%   obj           - Connections instance
% 
% USAGE:
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    properties (Access = private)
        protocolPath     % path to brainstorm protocol
        CtxHR            % high res. cortex surface 
        Ctx              % low res. cortex surface
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
        light_handle = Plot(obj, opacity, linewidth, m_radius)  % plot connections on HR brain
        PlotViews(obj, opacity, linewidth, m_radius)
        PlotPhase(obj, src, event)               % plot amplitude and phase for connecion
        obj = Clusterize(obj, clustSize, dPair)  % clusterize connections
        obj = Average(obj)                       % average connections.
        obj = Merge(obj)                         % merge connection indeces

        % ----------------------- constructor ---------------------- %
        function obj = Connections(conInds, HM, CtxHR)
            if iscell(conInds)
                obj.conInds = conInds;
            else
                obj.conInds{1} = conInds;
            end
            obj.headModel = HM;
            obj.CtxHR     = CtxHR;
        end
        % --------------------------------------------------------- % 
    end
end

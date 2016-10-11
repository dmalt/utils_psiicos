function [Gain_reduced_n, Gain_reduced] = ReduceToTangentSpace(Gain, chSelect)
% ----------------------------------------------------------------
% ReduceToTangentSpace: takes takes as input Gain matrix with three 
% dipoles for each source location and reduces them to two
% laying in a tangent plane
% ----------------------------------------------------------------
% FORMAT:
%   Gain_reduced_n = ReduceToTangentSpace(Gain, chSelect) 
% INPUTS:
%   nSrc        - number of source locations on cortex
%   Gain          - {Nchannels x 3 * Nsources} forward operator 
%                   gain matrix
%   chSelect        - {1 x NumOfChannelsUsed} array of indeces of
%                   channels that are left for analysis; 
%                   to use gradiometers only go for
%                   chSelect = 1:306; chSelect(3:3:end) = []; 
% OUTPUTS:
%   Gain_reduced_n  - {Nchannels x 2 * Nsources} reduced forward 
%                     operator matrix with only two dipols per
%                     source location confined to a tangent plane
% ________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    switch nargin
        case 1
            chSelect = 'grad';
    end

    if ~strcmp(chSelect, 'all')
        chUsed = PickChannels(chSelect);
        nSen = length(chUsed);
    else
        nSen = size(Gain, 1);
        chUsed = 1:nSen;
    end
    nSrc = size(Gain, 2) / 3;

    Gain_reduced_n   = zeros(nSen, nSrc * 2);
    Gain_reduced     = zeros(nSen, nSrc * 2);
    range = 1:2;
    for i=1:nSrc
        g = [Gain(chUsed, 1 + 3 * (i - 1)) ...
             Gain(chUsed, 2 + 3 * (i - 1)) ...
             Gain(chUsed, 3 + 3 * (i - 1))];
        [u, s, ~] = svd(g);
        Gain_reduced_n(:,range)   = u(:,1:2);                                                                                                                                                                                                                              
        Gain_reduced(:,range)     = u(:,1:2) * s(1:2,1:2);                                                                                                                                                                                                                              
        range = range + 2;
    end;

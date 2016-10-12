function [Gain_reduced_n, Gain_reduced] = ReduceToTangentSpace(Gain)
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
% OUTPUTS:
%   Gain_reduced_n  - {Nchannels x 2 * Nsources} reduced forward 
%                     operator matrix with only two dipols per
%                     source location confined to a tangent plane
% ________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    nSrc = size(Gain, 2) / 3;
    nSen = size(Gain, 1);

    Gain_reduced_n   = zeros(nSen, nSrc * 2);
    Gain_reduced     = zeros(nSen, nSrc * 2);
    range = 1:2;
    for i=1:nSrc
        g = [Gain(:, 1 + 3 * (i - 1)) ...
             Gain(:, 2 + 3 * (i - 1)) ...
             Gain(:, 3 + 3 * (i - 1))];
        [u, s, ~] = svd(g);
        Gain_reduced_n(:,range)   = u(:,1:2);                                                                                                                                                                                                                              
        Gain_reduced(:,range)     = u(:,1:2) * s(1:2,1:2);                                                                                                                                                                                                                              
        range = range + 2;
    end;

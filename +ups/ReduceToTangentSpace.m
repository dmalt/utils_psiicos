function [Gain_reduced_n, Gain_reduced] = ReduceToTangentSpace(Gain)
% ----------------------------------------------------------------
% ReduceToTangentSpace: takes takes as input Gain matrix with three 
% dipoles for each source location and reduces them to two
% laying in a tangent plane
% ----------------------------------------------------------------
% FORMAT:
%   Gain_reduced_n = ReduceToTangentSpace(Gain) 
% INPUTS:
%   Gain          - {Nchannels x Nsources * 3} forward operator 
%                   gain matrix
% OUTPUTS:
%   Gain_reduced_n  - {Nchannels x Nsources * 2} reduced forward 
%                     operator with two dipoles per
%                     source location confined to a tangent plane
% ________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    n_src = size(Gain, 2) / 3;
    n_sen = size(Gain, 1);

    Gain_reduced_n   = zeros(n_sen, n_src * 2);
    Gain_reduced     = zeros(n_sen, n_src * 2);
    range = 1:2;

    for i=1:n_src
        g = [Gain(:, 1 + 3 * (i - 1)) ...
             Gain(:, 2 + 3 * (i - 1)) ...
             Gain(:, 3 + 3 * (i - 1))];
        [u, s, ~] = svd(g);
        Gain_reduced_n(:,range)   = u(:,1:2);
        Gain_reduced(:,range)     = u(:,1:2) * s(1:2,1:2);
        range = range + 2;
    end
end

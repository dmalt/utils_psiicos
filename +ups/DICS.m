function [A,Ps] = DICS(C,G, lambda)
% -------------------------------------------------------
% DICS beamformer on cross-spectrum
% -------------------------------------------------------
% FORMAT:
%  [A,Ps] = DICS(C,G)
% INPUTS:
%   C        -
%   G
% OUTPUTS:
%   A
%   Ps
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    if nargin < 3
        lambda = 10;
    end

    Nch = size(C,1);
    iC = inv(C + lambda * trace(C) / Nch * eye(Nch));
    Ns = fix(0.5 * size(G,2)); % assume tangent space dimension of 2 

    range = 1:2;
    A = zeros(size(G'));

    for i = 1:Ns
        L = G(:,range);
        A(range,:) = inv(L' * iC * L) * L' * iC;
        range = range + 2;
    end

    for i=1:Ns
        range_i = i * 2 - 1 : i * 2;
        ai = A(range_i,:);
        cs = ai * C * ai';
        [~, s, ~] = svd(cs);
        Ps(i) = sqrt(s(1,1));
    end;

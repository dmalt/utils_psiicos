function [Cs, Ps, IND] = GCS_MNE(C, G, Ce, Cmu)
% ------------------------------------------------------------
% Apply geometric correction scheme + minimum norm estimation
% ------------------------------------------------------------
% FORMAT:
%   [Cs, Ps, IND] = GCS_MNE(C,G, Ce, Cmu) 
% INPUTS:
%   C
%   G
%   Ce
%   Cmu
% OUTPUTS:
%   Cs
%   Ps
%   IND
% ______________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.GCS_ScanFast
    Nch = size(C,1);

    kappa = trace(inv(Ce) * G * G') / (trace(inv(Ce) * Cmu) - Nch);

    A = G' * inv((G * G' + kappa * Ce));

    Ns = fix(0.5 * size(G, 2)); % assume tangent space dimension of 2 

    for i=1 : Ns
        range_i = i * 2 - 1 : i * 2;
        ai = A(range_i,:);
        cs = ai * C * ai';
        [~, s, ~] = svd(cs);
        Ps(i) = sqrt(s(1,1));
    end;

    p = 1;
    Cs  = zeros(Ns * (Ns - 1) / 2, 1);
    IND = zeros(Ns * (Ns - 1) / 2, 2);

    [Cs,IND] = GCS_ScanFast(C,G,A);

function [A, Ps, Cs, IND] = DICS(C, G, lambda, is_imag)
% -------------------------------------------------------
% DICS beamformer on cross-spectrum. compute beamformer
% topographies and use them to estimate powers and
% rank source-level connections by their correlation
% with sensor-level cross-spectrum
% -------------------------------------------------------
% FORMAT:
%  [A, Ps, Cs, IND] = DICS(C, G, lambda)
% INPUTS:
%   C        - {n_sensors x n_sensors} matrix;
%              sensor-level cross-spectrum
%   G        - {n_sensors x n_sources * 2} matrix;
%              forward operator
% OUTPUTS:
%   A        - {n_sources * 2 x n_sensors} matrix;
%              inverse operator
%   Ps       - {n_sensors x 1} vector;
%              source-level power estimates
%   Cs       - {n_sources * (n_sources - 1) / 2 x 1} vector
%              vectorized upper diagonal of matrix of
%              source-level connection correlations with
%              sensor-level cross-spectrum
%   IND      - {n_sources * (n_sources - 1) / 2 x 2} matrix;
%              mapping between linear and matrix index notation;
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ps.PSIICOS_ScanFast

    if nargin < 4
        is_imag = false;
    end

    if nargin < 3
        lambda = 10;
    end

    Nch = size(C,1);
    C_reg = (C + lambda * trace(C) / Nch * eye(Nch));
    Ns = fix(0.5 * size(G, 2)); % assume tangent space dimension of 2

    range = 1:2;
    A = zeros(size(G'));

    for i = 1:Ns
        L = G(:,range);
        A(range,:) = (L' * inv(C_reg) * L) \ L' / C_reg;
        range = range + 2;
    end


    % ---------- Estimate powers -------- %
    Ps = zeros(Ns,1);
    for i=1:Ns
        range_i = i * 2 - 1 : i * 2;
        ai = A(range_i,:);
        cs = ai * C * ai';
        if is_imag
            cs = imag(cs);
        end
        [~, s, ~] = svd(cs);
        Ps(i) = sqrt(s(1,1));
    end;
    % ----------------------------------- %

    % Rank connections by their correlation with vec(C)
    [Cs, IND] = PSIICOS_ScanFast(A', C(:), is_imag);
end

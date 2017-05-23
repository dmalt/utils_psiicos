function [Cs, IND] = GCS_ScanFast(C, G, A)
% -------------------------------------------------------------------------
% Perform scanning algorithm to find strongest connections using correlation
% of cross-spectrum with the forward operator
% -------------------------------------------------------------------------
% FORMAT:
%   [Cs, IND Cs0] = GCS_ScanFast(G, C, A) 
% INPUTS:
%   G       - {n_sensors x n_sources} matrix of forward model
%   C       - {n_sensors ^ 2 x n_times} or
%             {n_sensors ^ 2 x n_components}
%             matrix of timeseries or left singular vectors of
%             cross-spectrum on sensors % OUTPUTS:
%   A       - {n_sources x n_sensors} matrix of inverce operator
% OUTPUTS:
%   Cs         - {(n_sources ^ 2 - n_sources) / 2} matrix of 
%                correlations between source topographies
%                and forward operator
%   IND        - {(n_sources ^ 2 - n_sources) / 2} matrix of
%                indices to build a mapping between upper
%                triangle and (i,j) matrix indexing 
%                IND(l,:) --> [i,j]
% ___________________________________________________________________________
% Alex Ossadtchii, ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    [Nsns, Nsrc2] = size(G);
    Nsrc = Nsrc2 / 2;

    % if(size(C,1)~=Nsns)
    %     disp('Incomptible dimensions G vs C');
    %     return;
    % end

    % n_comp = size(C, 2);
    T = zeros(1, Nsrc * (Nsrc - 1) / 2);
    D = zeros(1, Nsrc * (Nsrc - 1) / 2);
    Ti = zeros(1, Nsrc);
    Di = zeros(1, Nsrc);
    IND = zeros(Nsrc * (Nsrc - 1) / 2, 2);
    cs2 = zeros(2, 2);
    cs = zeros(2, 2);
    tmp = zeros(2, Nsrc * 2);
    ai = zeros(2, Nsns);
    aj = zeros(Nsns, 2);
    cslong = zeros(2, Nsrc * 2);
    cs2long = zeros(2, Nsrc * 2);
    cs2longd = zeros(1, Nsrc * 2);
    cs2_11_22 = zeros(2, Nsrc);
    cs2_12_21 = zeros(1, Nsrc);
    Cs0 =  zeros(1, Nsrc * (Nsrc - 1) / 2);

    % below is the optimized implementation of this:
    % Look at each pair and estimate subspace correlation
    % between cross-spectrum and topography of this pair

    % for i = 1:Ns
    %     range_i = i * 2 - 1 : i * 2;
    %     ai = A(range_i,:);
    %     gi = G(:,range_i);
    %     P = eye(Nsns)- gi(:,1) * ai(1,:) / (ai(1,:) * gi(:,1)) - gi(:,2) * ai(2,:) / (ai(2,:) * gi(:,2))  ;
    %     temp = ai * C;
    %     %temp = ai * C;
    %     for j = i + 1:Ns
    %          range_j = j * 2 - 1 : j * 2;
    %          aj = A(range_j,:) * P;
    %          cs = temp * aj';
    %          %[~, s ,~] = svd(imag(cs));
    %          [~, s ,~] = svd((cs));

    %          Cs(p) = max(diag(s));%/(Ps(i)*Ps(j));
    %          IND(p,:) = [i,j];
    %          p = p + 1;
    %     end;
    % end;

% ----------------------- %
    p = 1;
    ai = zeros(2, Nsns);
    for iSrc = 1:Nsrc
            % --- Take iSrc-th location topographies ---- %
        range_i = iSrc * 2 - 1 : iSrc * 2;
        ai = A(range_i,:);
        gi = G(:,range_i);
        P = eye(Nsns) - gi(:,1) * ai(1,:) / (ai(1,:) * gi(:,1))...
                      - gi(:,2) * ai(2,:) / (ai(2,:) * gi(:,2));

        tmp = ai * C;
        cslong =  tmp * P' * A'; % {2 x n_sen} matrix

        cs2long = cslong .* conj(cslong);
        cs2longd = cslong(1,:) .* conj(cslong(2,:));
        cs2_11_22 = [sum(reshape(cs2long(1,:), 2, Nsrc), 1);...
                     sum(reshape(cs2long(2,:), 2, Nsrc), 1)];
        cs2_12_21 =  sum(reshape(cs2longd, 2, Nsrc), 1);

        Ti = sum(cs2_11_22, 1);
        Di = prod(cs2_11_22, 1) - cs2_12_21 .* conj(cs2_12_21);

        T(p : p + Nsrc - 1 - iSrc) = Ti(iSrc + 1 : Nsrc);
        D(p : p + Nsrc - 1 - iSrc) = Di(iSrc + 1 : Nsrc);

        IND(p : p + Nsrc - iSrc - 1, 2) = (iSrc + 1 : Nsrc)';
        IND(p : p + Nsrc - iSrc - 1, 1) = iSrc;
        p = p + Nsrc - iSrc;
    end;
    Cs = 0.5 * T + sqrt(0.25 * T .* T - D); 
end

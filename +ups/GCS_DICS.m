function [Cs, Ps, IND] = GCS_DICS(C,G)
% -------------------------------------------------------
% Apply geometric correction scheme + DICS beamformer
% -------------------------------------------------------
% FORMAT:
%   [Cs, Ps, IND] = GCS_DICS(C,G) 
% INPUTS:
%   C
%   G
% OUTPUTS:
%   Cs
%   Ps
%   IND
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru
    import ups.GCS_ScanFast

    Nch = size(C,1);
    iC = inv(C + 10 * trace(C) / Nch * eye(Nch));
    Ns = fix(0.5 * size(G,2)); % assume tangent space dimension of 2 

    range = 1:2;
    A = zeros(size(G'));

    for i=1:Ns
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

    p = 1;
    Cs  = zeros(Ns * (Ns - 1) / 2, 1);
    IND = zeros(Ns * (Ns - 1) / 2, 2);
    fprintf('iDICS searching the grid... \n');
    fprintf('Reference index (Max %d) : ', Ns); 

    % for i = 1:Ns
    %     range_i = i * 2 - 1 : i * 2;
    %     ai = A(range_i,:);
    %     gi = G(:,range_i);
    %     P = eye(Nch)- gi(:,1) * ai(1,:) / (ai(1,:) * gi(:,1)) - gi(:,2) * ai(2,:) / (ai(2,:) * gi(:,2))  ;
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

    %     if i > 1
    %        for j=0:log10(i - 1)
    %             fprintf('\b'); % delete previous counter display
    %        end
    %     end
    %     fprintf('%d', i);
    % end;
    % C = ps.ProjectAwayFromPowerComplete(C(:),G,500);
    % C = reshape(C, Nch, Nch) ;
    [Cs,IND] = GCS_ScanFast(C,G,A);
    fprintf('\n Done\n');

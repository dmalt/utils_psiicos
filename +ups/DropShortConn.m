function conInds_long = DropShortConn(conInds, ChLoc, d_min, n_conn_max)
% -------------------------------------------------------
% Exclude connections with length less than d_min
% -------------------------------------------------------
% FORMAT:
%  function conInds_long = DropLongConn(conInds, ChLoc, min_length, n_conn_max)
% INPUTS:
%   conInds        -
%   ChLoc
%   d_min
%   n_conn_max
% OUTPUTS:
%   conInds_long
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya

    if nargin < 4
        n_conn_max = [];
    end

    conInds_long = conInds;
    for iCon = 1:length(conInds_long)
        xyz1 = ChLoc(:, conInds_long(iCon,1));
        xyz2 = ChLoc(:, conInds_long(iCon,2));
        d12 = norm(xyz1 - xyz2);
        if d12 < d_min
            conInds_long(iCon,:) = [-1, -1];
        end
    end
    conInds_long(conInds_long(:,1) == -1, :) = [];

    if n_conn_max
        try
            conInds_long = conInds_long(1:n_conn_max,:);
        catch
            error('PS_UTILS:SizeError', 'Not enough connections to return n_conn_max');
        end
    end
end

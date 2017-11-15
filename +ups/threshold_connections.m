function con_inds = threshold_connections(Cs, thresh, IND)
% -------------------------------------------------------
% Return indices of connections that have subspace
% correlations above a relative threshold
% -------------------------------------------------------
% FORMAT:
%   con_inds = threshold_connections(Cs, thresh, IND)
% INPUTS:
%   Cs       - {n * (n - 1) / 2} vector
%   thresh   - scalar; either float between 0 and 1
%              or positive integer; in the former case
%              return connections stronger than a relative
%              threshold based on min and max values;
%              in the latter case return thresh strongest
%              connections
%   IND      - {n * (n - 1) / 2 x 2} matrix
% OUTPUTS:
%   con_inds - {n x 2} matrix of indices
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    corr_min  = min(Cs);
    corr_max = max(Cs);
    corr_delta = corr_max - corr_min;
    corr_threshold = corr_min + corr_delta * thresh;

    % ind_threshold = find(sqrt(Cs * 2) > corr_threshold);
    if thresh < 1
        ind_threshold = find(Cs > corr_threshold);
    elseif thresh >= 1 && fix(thresh) == thresh
        thresh = int32(thresh);
        [~, key] = sort(Cs, 'descend');
        ind_threshold = key(1:thresh);
    end

    i = IND(ind_threshold, 1);
    j = IND(ind_threshold, 2);

    con_inds(:,1) = i;
    con_inds(:,2) = j;
end

function con_inds = threshold_connections(Cs, thresh, IND)
% -------------------------------------------------------
% Return indices of connections that have subspace 
% correlations are above a relative threshold
% -------------------------------------------------------
% FORMAT:
%   con_inds = threshold_connections(Cs, thresh, IND) 
% INPUTS:
%   Cs        -
%   thresh
%   IND
% OUTPUTS:
%   con_inds
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
        [val, key] = sort(Cs, 'descend');
        ind_threshold = key(1:thresh);
    end


        
    pair_max = IND(ind_threshold,:);

    i = IND(ind_threshold, 1); 
    j = IND(ind_threshold, 2);

    con_inds(:,1) = i;
    con_inds(:,2) = j;
end
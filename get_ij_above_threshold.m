function ij = get_ij_above_threshold(Cs, threshold, IND)
% -------------------------------------------------------
% Get indices for correlations above threshold in 
% vectorized upper diagonal matrix of correlations
% between topographies and forward model operator
% -------------------------------------------------------
% FORMAT:
%   ij = get_ij_above_threshold(Cs, threshold, IND)
% INPUTS:
%   Cs        -
%   threshold
%   IND
% OUTPUTS:
%   ij
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    corr_min  = min(Cs);
    corr_max = max(Cs);
    corr_delta = corr_max - corr_min;
    corr_threshold = corr_min + corr_delta * threshold;

    ind_threshold = find(Cs > corr_threshold);
    pair_max = IND(ind_threshold,:);

    ij = IND(ind_threshold,:);
end
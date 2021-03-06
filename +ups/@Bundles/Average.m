function obj = Average(obj, is_adjust_size)
% ------------------------------------------
% Spatially average clusters of connections
% ------------------------------------------
% INPUTS:
%   NONE
% OUTPUTS:
%   C     - Bundles instance
% __________________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru

    import ups.ClustAverage

    if nargin < 2
        is_adjust_size = true;
    end

    clustCenters = ClustAverage(obj.conInds, obj.headModel.GridLoc);
    for iCent = 1:size(clustCenters, 1)
        if is_adjust_size
            n_clust_conn = size(obj.conInds{iCent},1);
            obj.lwidth(iCent) = floor(2 * log(n_clust_conn)) + 1;
            obj.m_rad(iCent) = 0.001 * (1 + 0.8 * log(n_clust_conn));
            alpha = 0.2 + n_clust_conn / 20;
            if alpha > 1
                alpha = 1;
            end
            obj.alpha(iCent) = alpha;
        end
        obj.conInds{iCent} = clustCenters(iCent,:) ;
    end
end

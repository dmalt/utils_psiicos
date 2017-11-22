function obj = Get(obj, ind)
% --------------------------------
% Return clusters specified by ind
% --------------------------------
% INPUT:
%   ind    - vector of indices
% OUTPUT:
%   C      - Connections instance
% ________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru
% TODO:
%   handle case where ind is empty

    obj.conInds = obj.conInds(ind);
    if ~isscalar(obj.clust_lwidth)
        obj.clust_lwidth = obj.clust_lwidth(ind);
    else
        obj.clust_lwidth = obj.clust_lwidth;
    end
    if ~isscalar(obj.clust_m_rad)
        obj.clust_m_rad = obj.clust_m_rad(ind);
    else
        obj.clust_m_rad = obj.clust_m_rad;
    end
    if ~isscalar(obj.clust_icol)
        obj.clust_icol = obj.clust_icol(ind);
    else
        obj.clust_icol = obj.clust_icol;
    end
    if ~isscalar(obj.clust_alpha)
        obj.clust_alpha = obj.clust_alpha(ind);
    else
        obj.clust_alpha = obj.clust_alpha;
    end
end

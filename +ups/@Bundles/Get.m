function obj = Get(obj, ind)
% --------------------------------
% Return clusters specified by ind
% --------------------------------
% INPUT:
%   ind    - vector of indices
% OUTPUT:
%   C      - Bundles instance
% ________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru
% TODO:
%   handle case where ind is empty

    obj.conInds = obj.conInds(ind);
    if ~isscalar(obj.lwidth)
        obj.lwidth = obj.lwidth(ind);
    else
        obj.lwidth = obj.lwidth;
    end
    if ~isscalar(obj.m_rad)
        obj.m_rad = obj.m_rad(ind);
    else
        obj.m_rad = obj.m_rad;
    end
    if ~isscalar(obj.icol)
        obj.icol = obj.icol(ind);
    else
        obj.icol = obj.icol;
    end
    if ~isscalar(obj.alpha)
        obj.alpha = obj.alpha(ind);
    else
        obj.alpha = obj.alpha;
    end
end

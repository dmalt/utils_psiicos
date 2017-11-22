function obj = Merge(obj)
% ---------------------------------
% Merge all sticks into one cluster
% ---------------------------------
% INPUT:
%   NONE
% OUTPUT:
%   C    - Connections instance
% _________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru

    DipInd = [];
    for i = 1:length(obj.conInds)
        DipInd = [DipInd; obj.conInds{i}];
    end
    obj.conInds = {DipInd};
    obj.clust_lwidth = 1;
    obj.clust_m_rad = 0.002;
    obj.clust_icol =  1;
    obj.clust_alpha = 1;
end

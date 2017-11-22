function obj = Merge(obj)
% ---------------------------------
% Merge all sticks into one cluster
% ---------------------------------
% INPUT:
%   NONE
% OUTPUT:
%   C    - Bundles instance
% _________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru

    DipInd = [];
    for i = 1:length(obj.conInds)
        DipInd = [DipInd; obj.conInds{i}];
    end
    obj.conInds = {DipInd};
    obj.lwidth = 1;
    obj.m_rad = 0.002;
    obj.icol =  1;
    obj.alpha = 1;
end

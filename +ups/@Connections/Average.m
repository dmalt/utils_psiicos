function obj = Average(obj)
% ------------------------------------------
% Spatially average clusters of connections
% ------------------------------------------
% INPUTS:
%   NONE
% OUTPUTS:
%   C     - Connections instance
% __________________________________________
% AUTHOR: dmalt, dm.altukhov@ya.ru

    import ups.ClustAverage

    clustCenters = ClustAverage(obj.conInds, obj.headModel.GridLoc);
    for iCent = 1:size(clustCenters, 1)
        obj.conInds{iCent} = clustCenters(iCent,:) ;
    end
end

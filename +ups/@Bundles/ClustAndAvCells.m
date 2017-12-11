function obj = ClustAndAvCells(obj, clustSize, dPair)
% -------------------------------------------------------
% Custerize connections within each cell, average clusters
% and save averaged connections in cells
% -------------------------------------------------------
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.PairwiseClust
        
    dPair = 0.02;
    clustSize = 2;
    con_cel_clust = obj;    
    for iCell = 1:length(obj.conInds) 
        con_cel_clust.conInds = PairwiseClust(obj.conInds{iCell}, obj.headModel.GridLoc,
                                              dPair, clustSize);
        con_cel_av = con_cel_clust.Average();
        con_cel_merge = con_cel_av.Merge();
        obj.conInds(iCell) = con_cel_merge.conInds();
    end
end

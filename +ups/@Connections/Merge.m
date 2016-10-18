function obj = Merge(obj)
    DipInd = [];
    for i = 1:length(obj.conInds)
    	DipInd = [DipInd; obj.conInds{i}];
    end
    obj.conInds = {DipInd};
end
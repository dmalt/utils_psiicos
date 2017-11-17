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

    obj.conInds = obj.conInds{ind};
end

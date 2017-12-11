function [sim_mean, sim_std, CS] = ConnSimMetrics(conInds, ChLoc, NOrder)
% -------------------------------------------------------
% Compute mean connectivity similarity and its std for
% a group of subjects
% -------------------------------------------------------
% FORMAT:
%   [sim_mean, sim_std, CS] = ConnSimMetrics(conInds, ChLoc, NOrder)
% INPUTS:
%   conInds        -
%   ChLoc
%   NOrder
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    
    if nargin < 3
        NOrder = 4;
    end
    import ups.conn.ConnectivitySimilarity

    nSubj = length(conInds);
    count = 1;
    for s1 = 1:nSubj
       for s2 = s1+1:nSubj
           if(s1~=s2)
               CS(count) = ConnectivitySimilarity(conInds{s1}, conInds{s2},...
                                                  ChLoc, NOrder, 0.05, 'O');
               count = count + 1;
           end
       end
    end

    sim_mean = mean(CS);
    sim_std = std(CS) / sqrt(length(CS));
end

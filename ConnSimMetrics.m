function [sim_mean, sim_std, CS] = ConnSimMetrics(conInds, ChLoc)
% -------------------------------------------------------
% Compute mean connectivity similarity and its std for
% a group of subjects
% -------------------------------------------------------
% FORMAT:
%   [sim_mean, sim_std, CS] = ConnSimMetrics(conInds, ChLoc)
% INPUTS:
%   conInds        -
%   ChLoc
% OUTPUTS:
%   sim_mean
%   sim_std
%   CS
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	nSubj = length(conInds);
	count = 1;
	for s1 = 1:nSubj
	   for s2 = s1+1:nSubj
	       if(s1~=s2)
	           CS(count) = ConnectivitySimilarity(conInds{s1}, conInds{s2}, ChLoc, 4, 0.05, 'O');
	           count = count + 1;
	       end
	   end;
	end;

	sim_mean = mean(CS);
	sim_std = std(CS) / sqrt(length(CS));
end
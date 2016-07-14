function [sim_mean, sim_std, CS] = ConnSimMetrics(conInds, ChLoc)
% -------------------------------------------------------
% Compute mean connectivity similarity and its std for
% a group of subjects
% -------------------------------------------------------
% FORMAT:
%   format 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	nSubj = length(conInds);
	count = 1;
	for s1 = 1:10
	   for s2 = s1+1:10
	       if(s1~=s2)
	           CS(count) = ConnectivitySimilarity(conInds{s1}, conInds{s2}, ChLoc);
	           count = count + 1;
	       end
	   end;
	end;

	sim_mean = mean(CS);
	sim_std = std(CS) / sqrt(length(CS));
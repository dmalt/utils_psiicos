function restoredTrials = RestoreTrDim(trials, UP)
% -------------------------------------------------------
% description
% -------------------------------------------------------
% FORMAT:
%   restoredTrials = RestoreTrDim(trials, UP) 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	[~, nTimes, nTr] = size(trials);
	nSen = size(UP, 2);
	restoredTrials = zeros(nSen, nTimes, nTr);
	for iTr = 1:nTr
		restoredTrials(:,:,iTr) = UP' * squeeze(trials(:,:,iTr));
	end
end
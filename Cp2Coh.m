function CohTS = Cp2Coh(CT)
% ---------------------------------------------------------
% Convert cross-spectral timeseries to coherence timeseries
% ---------------------------------------------------------
% FORMAT:
%   CohTS = Cp2Coh(CT) 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	[nSen_sq, nTimes] = size(CT);
	nSen = sqrt(nSen_sq);
	CohTS = zeros(nSen_sq, nTimes);
	for iTime = 1:nTimes
		Cp = reshape(CT(:,iTime), nSen, nSen);
		D = diag(sqrt(1 ./ diag(Cp)));
		Coh = D * Cp * D;
		CohTS(:,iTime) = Coh(:);
	end
end
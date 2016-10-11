function conInds = GetSensorConnectivity(CT, threshold)
% -------------------------------------------------------
% description
% -------------------------------------------------------
% FORMAT:
%   conInds = GetSensorConnectivity(CT, threshold) 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	% conInds = rand(3,2);
	[nSen_sq, ~] = size(CT);
	nSen = sqrt(nSen_sq);
	abs_av_CT = abs(sum(CT, 2));

	% --------- zero out the diagonal ------------ %
	abs_av_CT = reshape(abs_av_CT, nSen, nSen);
	abs_av_CT = abs_av_CT - diag(diag(abs_av_CT));
	abs_av_CT = abs_av_CT(:);
	% -------------------------------------------- %
	if threshold < 1
		val_range = max(abs_av_CT) - min(abs_av_CT);
		lin_inds = find(abs_av_CT > threshold * val_range + min(abs_av_CT));
	elseif threshold >= 1 && floor(threshold) == threshold
		[~,sort_inds] = sort(abs_av_CT, 'descend');
		lin_inds = 	sort_inds(1:threshold);
	end
	nCon = length(lin_inds);
	conInds = zeros(nCon, 2);

	for iCon = 1:nCon
		conInds(iCon,:) = indVec2mat(lin_inds(iCon), nSen);
	end
	% conInds(1,:) = [200, 20];
end

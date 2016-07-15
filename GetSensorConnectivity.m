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
	av_abs_CT = abs(sum(CT, 2));

	% --------- zero out the diagonal ------------ %
	av_abs_CT = reshape(av_abs_CT, nSen, nSen);
	av_abs_CT = av_abs_CT - diag(diag(av_abs_CT));
	av_abs_CT = av_abs_CT(:);
	% -------------------------------------------- %
	if threshold < 1
		val_range = max(av_abs_CT) - min(av_abs_CT);
		lin_inds = find(av_abs_CT > threshold * val_range + min(av_abs_CT));
	elseif threshold >= 1 && floor(threshold) == threshold
		[~,sort_inds] = sort(av_abs_CT, 'descend');
		lin_inds = 	sort_inds(1:threshold);
	end
	nCon = length(lin_inds);
	conInds = zeros(nCon, 2);

	for iCon = 1:nCon
		conInds(iCon,:) = indVec2mat(lin_inds(iCon), nSen);
	end
	% conInds(1,:) = [200, 20];
end

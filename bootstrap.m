function [BootsIND, maxes, resamples] = bootstrap(Trials, G, nResamp, Rnk, threshold, CTpart, bInducedOnly)
% -------------------------------------------------------
% bootstrap: make bootstrapped cross-spectra, apply
% T_PSIICOS for each and then apply pairwise clustering. 
% -------------------------------------------------------
% FORMAT:
%   [BootsIND, maxes, resamples] = bootstrap(Trials, G, nResamp,
%                           Rnk, threshold, CTpart, bInducedOnly) 
% INPUTS:
%   Trials        - {nSensors x nTimes x nTrials} matrix of trials
%                   on sensors 
%   G             - {nSensors x nSourses} forward model matrix
%   nResamp       - scalar; number of bootstrap iterations
%   Rnk           - scalar; rank of VC-projection
%   threshold
%   CTpart
%   bInducedOnly
% OUTPUTS:
%   BootsIND
%   maxes
%   resamples
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
BootsIND = cell(nResamp,1);
% Rnk = 500;

for it=1:nResamp
    nTrials = size(Trials,3);
    resample = randi(nTrials, 1, nTrials);
    for iTrial = 1:nTrials
        BootsTrials(:,:,iTrial) =  Trials(:,:,resample(iTrial));
    end

    CT = CrossSpectralTimeseries(BootsTrials, bInducedOnly);
    if strcmp(CTpart, 'real')
        BootsCT = real(CT);
    elseif strcmp(CTpart, 'imag')
        BootsCT = imag(CT);
    elseif strcmp(CTpart, 'full')
        BootsCT = CT;
    else
        disp(['ERROR: bootstrap: Unknown option "', num2str(CTpart), '" for CTpart'])
    end
    % size(BootsCT)
	[BootsIND{it}, Cp, Upwr, Cs] = T_PSIICOS(BootsCT, G, threshold, Rnk, 0);
	maxes{it} = max(Cs);
	resamples{it} = resample;
end

save('BootsIND.mat', 'BootsIND', '-v7.3');
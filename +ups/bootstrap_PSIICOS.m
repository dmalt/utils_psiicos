function [BootsIND, maxes, resamples] = bootstrap_PSIICOS(Trials, G, nResamp, Rnk, threshold, CTpart, bInducedOnly)
% -------------------------------------------------------
% Make bootstrapped cross-spectra, apply
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
%   threshold     - scalar;  
%   CTpart        - string; 
%   bInducedOnly  - boolean;
% OUTPUTS:
%   BootsIND
%   maxes
%   resamples
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    BootsIND = cell(nResamp,1);
    % Rnk = 500;
    Upwr = [];
    fprintf('Bootstraping PSIICOS:');
    for it=1:nResamp
        nTrials = size(Trials,3);
        resample = randi(nTrials, 1, nTrials);
        for iTrial = 1:nTrials
            BootsTrials(:,:,iTrial) =  Trials(:,:,resample(iTrial));
        end

        CT = ups.CrossSpectralTimeseries(BootsTrials, bInducedOnly);
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
    	[BootsIND{it}, Cp, Upwr, Cs] = ps.T_PSIICOS(BootsCT, G, threshold, Rnk, 0, Upwr);
    	maxes{it} = max(Cs);
    	resamples{it} = resample;
        if it > 1
           for j=0:log10(i - 1)
                fprintf('\b'); % delete previous counter display
           end
        end
        fprintf('%d', it);
    end

    % save('BootsIND.mat', 'BootsIND', '-v7.3');
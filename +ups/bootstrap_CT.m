function [CT, resamples] = bootstrap_CT(trials, n_resamp, is_induced_only, n_trials_used)
% -----------------------------------------------------------
% Make bootstrapped cross-spectra with fixed number of trials 
% -----------------------------------------------------------
% FORMAT:
%   [BootsIND, maxes, resamples] = bootstrap(trials, n_resamp,
%                            is_induced_only) 
% INPUTS:
%   trials        - {nSensors x nTimes x nTrials} matrix of trials
%                   on sensors 
%   n_resamp       - scalar; number of bootstrap iterations
%   is_induced_only  - boolean;
%   n_trials_used  - int scalar; 
% OUTPUTS:
%   CT            - {n_resamp x 1} cell array; each cell is 
%                   {n_sensors x n_sensors} cross-spectral 
%                   density matrix
%   resamples     - {n_resamp x 1} cell array; each cell is
%                   {n_trials_used x 1} int vector with resampling
%                   indices
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.CrossSpectralTimeseries

    if nargin < 4 
        ntrials_used = size(trials, 3);
    end

    BootsIND = cell(n_resamp, 1);
    fprintf('Creating bootstrapped cross-spectra...');
    n_trials = size(trials, 3);

    for it = 1:n_resamp
        resample = randi(n_trials, 1, n_trials_used);

        for i_trial = 1:n_trials_used
            BootsTrials(:,:,i_trial) = trials(:,:,resample(i_trial));
        end

        CT{it} = CrossSpectralTimeseries(BootsTrials, is_induced_only);
        resamples{it} = resample;
    end
    % save('BootsIND.mat', 'BootsIND', '-v7.3');
end

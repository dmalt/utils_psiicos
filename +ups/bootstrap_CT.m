function [CT, resamples] = bootstrap_CT(trials, n_resamp, is_induced_only, n_trials_used)
% -----------------------------------------------------------------------
% Make bootstrapped cross-spectrum timeseries with fixed number of trials 
% -----------------------------------------------------------------------
% FORMAT:
%   [CT, resamples] = bootstrap(trials, n_resamp, is_induced_only,...
%                               n_trials_used) 
% INPUTS:
%   trials        - {nSensors x nTimes x nTrials} matrix of trials
%                   on sensors 
%   n_resamp      - scalar; number of bootstrap iterations
%   is_induced_only  - boolean;
%   n_trials_used  - int scalar; number of trials to use for
%                    each bootstrap iteration
% OUTPUTS:
%   CT            - {n_resamp x 1} cell array; each cell is 
%                   {n_sensors ^ 2 x n_time} cross-spectral 
%                   timeseries matrix
%   resamples     - {n_resamp x 1} cell array; each cell is
%                   {n_trials_used x 1} int vector with resampling
%                   indices
% _______________________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    import ups.conn.CrossSpectralTimeseries

    if nargin < 4 
        n_trials_used = size(trials, 3);
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

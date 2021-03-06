function CT = GenerateFakeCT(nSen, nTimes)
% --------------------------------------------------------------------------- %
% Generate random complex matrix with cross-spectrum-timeseries-like structure
% 
% real and imag parts of complex timeseries for CT generation are drawn from
% standard normal distribution.
% --------------------------------------------------------------------------- %
% FORMAT:
%   CT = GenerateFakeCT(nSen, nTimes) 
% INPUTS:
%   nSen        - scalar; number of sensors
%   nTimes      - scalar; number of time steps
% OUTPUTS:
%   CT    - {nSen ^ 2 x nTimes} matrix; 
%           timeseries of vectorized PSD hermitian matrices
% ___________________________________________________________________________ %
% Dmitrii Altukhov, dm.altukhov@ya.ru

    CT = zeros(nSen ^ 2, nTimes);
    fakeTs = randn(nSen, nTimes) + 1i * randn(nSen,nTimes);

    for iTime = 1:nTimes
        timeSlice = fakeTs(:, iTime);
        Cp = timeSlice * timeSlice';
        CT(:,iTime) = Cp(:);
    end
end

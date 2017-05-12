function [CrossSpecTime, Trials, XYZGenOut] = SimulateDataSquid(PhaseLag, nTr, InducedScale, EvokedScale, isUseCache, G_HR, R_HR, UP) 
% --------------------------------------------------------------------------
% Generate forward model and cross-spectrum on sensors for simulations
% --------------------------------------------------------------------------
% FORMAT:
%   [HM, CrossSpecTime, Trials, Ctx] = SimulateData(PhaseLag, InducedScale, EvokedScale)
% INPUTS:
%   PhaseLag          - phase lag for simulations
%   nTr               - scalar; number of trials
%   GainSVDTh
%   InducedScale      - coefficient for induced activity (default = 0.35)
%   EvokedScale       - coefficient for evoked activity (default = 0)
%   isUseCache
% OUTPUTS:
%   HM_ps             - structure; forward model operator 
%                       for reduced sensor space and additional
%                       info.
% -----------
%   HM.gain        - {nSenReduced x nSrc * 2} matrix of 
%                       topographies for reduced sensor space
%   HM.UP          - {nSenReduced x nGradiometers} matrix
%                       of transformation between reduced and
%                       normal sensors
%   HM.subjID      - string; subject name
%   HM.path        - string; path to  
%   HM.svdThresh   - float; PVU threshold for PCA-driven 
%                       sensor space reduction
% ------------
%   CrossSpecTime     - {nSensors ^ 2 x nTimes} matrix of cross-spectrum on sensors
%   Trials            - {nSensors_reduced x nTimes x nTrials} matrix of trials
%                       timeseries
% ______________________________________________________________________________
% Alex Ossadtchi, ossadtchi@gmail; Dmitrii Altukhov, dm.altukhov@ya.ru


    % --------- set up defaults --------- %
    % if nargin < 6    
    %     isUseCache = true;
    % end
    % if nargin < 5
    %     EvokedScale = 0.;
    % end   
    % if nargin < 5 - 1;
    %        InducedScale = 0.35;
    %        EvokedScale = 0;
    % end
    % if nargin < 5 -2
    % % 0.05 results into 47 eigensensors and makes it run faster 
    % % but produces less contrasting subcorr scans
    % % for a more reliable preformance use 0.01
    % % to get all the sensor on board but be ready to wait;
    %    GainSVDTh = 0.001 ;
    % end

    % if nargin < 5 - 3
    %     nTr = 100;
    % end

    % --------------------------------------- %
    % ---- check if cache folder is there --- %
    % ----------if no - create one ---------- %

    fname = mfilename('fullpath');
    mpath = fileparts(fname);

    % cache_fold =  [mpath, '/../Simulations_cache'];
    % if ~exist(cache_fold, 'dir')
    %     mkdir(cache_fold);
    % end

    % cache_fname = ...
    % [
    %    'pl_',      num2str(PhaseLag),     ...
    %    '_ntr_',    num2str(nTr),          ...
    %    % '_gsvdth_', num2str(GainSVDTh),    ...
    %    '_is_',     num2str(InducedScale), ...
    %    '_es_',     num2str(EvokedScale)
   % ];
   % cache_fname = [cache_fold, '/', cache_fname, '.mat'];

    % --------------------------------------- %


    % if exist(cache_fname, 'file') && isUseCache
        % load(cache_fname);
    % else
        [CrossSpecTime, Trials, XYZGenOut] = GenerElecta(PhaseLag, nTr,...
                                                       InducedScale,...
                                                       EvokedScale, G_HR, R_HR, UP);

        % save(cache_fname, 'HM', 'CrossSpecTime', 'Trials', '-v7.3');
    % end
end


function [CrossSpecTime, Trials, XYZGenAct] = GenerElecta(PhaseLag, nTr,...
                                                        InducedScale,...
                                                        EvokedScale, G_HR, R_HR, UP)

    import ups.PickChannels
    import ups.ReduceToTangentSpace
    import ups.CrossSpectralTimeseries
    import ups.spm_svd
    phi = PhaseLag;
    % GainSVDTh = 0.001; /
    NetworkPairIndex{1} = [1, 2];
    NetworkPairIndex{2} = [1, 2, 3];
    % Load forward model and reduce it  
    % load reduced forward model (GLowRes)


    % get grid node locations
    % Rloc = GLowRes.GridLoc;
    % set to use gradiometers only
    % ChUsed = PickChannels('grad');
    % calculate tangential plane dipoles
    % [~, nSites] = size(GLowRes.Gain(ChUsed, 1:3:end));

    % ---------------------------------------------------- %
    Dmax = 0.02;
    NPI = NetworkPairIndex{2};

    XYZGen = 1.3 * [ 0.05,  0.04, 0.05;
                     0.05, -0.04, 0.05;
                    -0.05,  0.04, 0.05;
                    -0.05, -0.04, 0.05;
                     0.00,  0.05, 0.06;
                     0.00, -0.05, 0.06];

    % [allnw, nw1, nw2, nw3] = FindEffSources(Dmax, Rloc, XYZGen, NPI);
    % ----------------------------------------------------- %

    % ------------------------------------------ %
    [Ggen, XYZGenAct] = GenForward(XYZGen, G_HR, R_HR);

    T = 500;
    Fs = 500;
    % ISD = load('InputData4Simulations.mat');

    % G_HR = ReduceToTangentSpace(ISD.G.Gain, 'grad');
    %
    [BrainNoise, SensorNoise] = GenerateNoise(G_HR, T, 500, 1000, Fs, 100, true);

    [Evoked, Induced] =  SimulateDataPhase(nTr, NetworkPairIndex{2}, phi, 1, Ggen, Fs);
    % mix noise and data 
    % in order to control SNR we first normalize norm(BrainNoise(:)) = 1 and 
    % norm(Induced(:)) = 1 and then mix the two with the coefficient
    Data0 = InducedScale * Induced + EvokedScale * Evoked + BrainNoise;
    clear Induced;
    clear Evoked;

    [bf, af] = butter(5, [2, 20] / (0.5 * 500));
    % Filter in the band of interest
    Data = filtfilt(bf, af, Data0')';
    size(Data)
    clear Data0;
    % Noise = filtfilt(bf, af, BrainNoise')';
    % Data_clear = filtfilt(bf, af, InducedScale * Induced')';
    %% Reshape the data in a 3D structure(Space x Time x Epochs)
    [~, Tcnt] = size(Data);
    T = fix(Tcnt / nTr);
    nCh = size(UP, 1);
    %reshape Data and store in a 3D array X
    X1 = zeros(nCh, T, nTr);
    % N1 = zeros(nCh, T, nTr);
    % N2 = zeros(nCh, T, nTr);
    range = 1:T;
    for i = 1:nTr
        X1(:,:,i) = UP * Data(:,range);
        range = range + T;
    end;
    Trials = X1;
    %% Calculate band cross-spectral matrix 
    CrossSpecTime = CrossSpectralTimeseries(X1);
end



function [BrainNoise, SensorNoise] = GenerateNoise(G, T, Tw, N, Fs, nTr, bNewBrainNoise)
%-------------------------------------------------------
% Generate brain and sensor noise
%-------------------------------------------------------
%
    nCh = size(G, 1);
    SensorNoise  = zeros(nCh, nTr * T);
    BrainNoise   = zeros(nCh, nTr * T);

    range = 1:T;

    if(~bNewBrainNoise)
        BN = load('BrainNoiseBiomag2014.mat');
    end;

    for i_tr = 1:nTr
        if(bNewBrainNoise)
            brainnoise = GenerateBrainNoise1Tr(G, T, 500, 1000, Fs);
        else
            brainnoise = BN.BrainNoise(:, range);
        end;

        brainnoise = brainnoise / sqrt(sum((brainnoise(:) .^ 2)));

        BrainNoise(:, range) = brainnoise;

        sensornoise = randn(size(brainnoise));
        sensornoise = sensornoise / sqrt(sum((sensornoise(:) .^ 2)));
        SensorNoise(:, range) = sensornoise;

        range = range + T;
    end

    if(bNewBrainNoise)
        save('BrainNoiseBiomag2014.mat', 'BrainNoise');
    end;
end


function [BrainNoise] = GenerateBrainNoise1Tr(G, T, Tw, N, Fs)
% ---------------------------------------------------------------
% Generate brain noise for one trial
% ---------------------------------------------------------------
% INPUTS:
%   G        - {n_sensors x n_sources} matrix of forward operator
%   T        -
%   Tw       -
%   N        -
%   Fs       - scalar; sampling frequency
%
% OUTPUTS:
%   BrainNoise  -
% _______________________________________________________________

    Nsrc = size(G, 2);
    SrcIndex = fix(rand(1, N) * Nsrc + 1);

    q = randn(N, T + 2 * Tw);

    alpha_band  = [8,  12] / (Fs / 2);
    beta_band   = [15, 30] / (Fs / 2);
    gamma1_band = [30, 50] / (Fs / 2);
    gamma2_band = [50, 70] / (Fs / 2);


    [b_alpha, a_alpha]   = butter(4, alpha_band);
    [b_beta, a_beta]     = butter(4, beta_band);
    [b_gamma1, a_gamma1] = butter(4, gamma1_band);
    [b_gamma2, a_gamma2] = butter(4, gamma2_band);

    SourceNoise = 1 / mean(alpha_band)  * filtfilt(b_alpha,  a_alpha,  q')' + ...
                  1 / mean(beta_band)   * filtfilt(b_beta,   a_beta,   q')' + ...
                  1 / mean(gamma1_band) * filtfilt(b_gamma1, a_gamma1, q')' + ...
                  1 / mean(gamma2_band) * filtfilt(b_gamma2, a_gamma2, q')';

    BrainNoise = G(:, SrcIndex) * SourceNoise(:, Tw + 1 : Tw + T) / N;
end


function [ans_idx, nw1, nw2, nw3] = FindEffSources(Dmax, R, XYZGen, NPI)
%------------------------------------------------------------------------
% Find sources in Dmax-ball of XYZGen locations
% -----------------------------------------------------------------------

    % create binary arrays indicators for each network from NPI 
    nSites = size(R, 1);
    IND(nSites * (nSites - 1) / 2, 2) = 0; % Memory allocation; faster then zeroes(...) 
    s = 1;
    for k = 1:nSites
        for l = k:nSites
            IND(s,1) = k;
            IND(s,2) = l;
            s = s + 1;
        end
    end
    R1 = R(IND(:,1),:);
    R2 = R(IND(:,2),:);
    k = 1;

    for nw = NPI
        i1 = nw * 2 - 1;
        i2 = nw * 2;
        d11 = bsxfun(@minus, R1, XYZGen(i1,:));
        d12 = bsxfun(@minus, R1, XYZGen(i2,:));
        d21 = bsxfun(@minus, R2, XYZGen(i1,:));
        d22 = bsxfun(@minus, R2, XYZGen(i2,:));

        D11 = sqrt(sum(d11 .^ 2, 2));
        D12 = sqrt(sum(d12 .^ 2, 2));
        D21 = sqrt(sum(d21 .^ 2, 2));
        D22 = sqrt(sum(d22 .^ 2, 2));

        Nw(:,k) = ( (D11 < Dmax) & (D22 < Dmax) ) | ( (D12 < Dmax) & (D21 < Dmax) );
        k = k + 1;
    end;

    AllNw = (sum(Nw, 2) > 0);
    ans_idx_lin = find(AllNw); % We`ve obtained indices that lay near generator coordinates.
    ans_idx = IND(ans_idx_lin,:); 
    nw1 = IND(find(Nw(:,1)),:);
    nw2 = IND(find(Nw(:,2)),:);
    nw3 = IND(find(Nw(:,3)),:);
end


function [Ggen, XYZGenAct] = GenForward(XYZGen, G2d, R)
    % import ups.PickChannels
    % import ups.ReduceToTangentSpace

    % ISD = load('InputData4Simulations.mat');
    % ChUsed = PickChannels('grad');

    % [~, G2d] = ReduceToTangentSpace(ISD.G.Gain, 'grad'); 
    
    % Assign topographies to generator coordinates(do not recompute, just find the closest one)
    % R = ISD.G.GridLoc;
    for i=1:size(XYZGen, 1)
        d = repmat(XYZGen(i,:), size(R,1), 1) - R;
        d = sum(d .* d, 2);
        [~, ind] = min(d);
        XYZGenAct(i,:) = R(ind,:);
        Ggen(:, i) = G2d(:, ind * 2 - 1); % take the first dipole in the tangent plane
        GenInd(i) = ind; 
    end;
end


function [evo, ind, PhaseShiftsOut] = SimulateDataPhase(nTr, NetworkPairIndex,...
                                                        dPhi, alpha_in, Ggen, Fs)
% -------------------------------------------------------
% Generate evoked and induced activity and project it on
% sensors with forward operator Ggen
% -------------------------------------------------------
% FORMAT:
%   format 
% INPUTS:
%   Ggen        - {n_sensors x n_networks * 2} matrix;
%                 topographies of network nodes
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

    if(nargin < 4)
        alpha = 0.25;
    else
        alpha = alpha_in;
    end;


    % specify pairing nodes for each network
    nwp{1} = [1,2];
    nwp{2} = [3,4];
    nwp{3} = [5,6];
    nwp{4} = [1,3];
    % Specify all networks  

    nw = [nwp{NetworkPairIndex}]; % If you want to simulate all four networks use
    %nw = [nw1 nw2 nw3 nw4]; see also line 87

    % Ngen = 6; % total number of generators
    sp = zeros(2, 500); 
    T = 500;   % number of timeslices per trial
    t = 1:T;

    % synchrony profiles of networks, one of each  as specified in lines 34-37
    sp(1,:) = exp(-1e-8   * (abs(t - 100)) .^ 4);
    sp(2,:) = exp(-1e-8   * (abs(t - 350)) .^ 4);
    sp(3,:) = exp(-0.2e-8 * (abs(t - 225)) .^ 4);
    sp(4,:) = 0.5 * (sin(10 * t / 500) + 1);

    range = 1:T;

    nCh = size(Ggen, 1);

    ind = zeros(nCh, nTr * T);
    evo  = zeros(nCh, nTr * T);

    F1 = 10; % Hz;
    t = linspace(0, 1, Fs);

    fprintf('Simulating trial data ...\n');
    fprintf('Current trial number (Max %d):', nTr);

    PhaseShiftsOut = zeros(nTr, 8);
    bUsePhases = false;
    for tr = 1:nTr
        if(bUsePhases)
            phi1 = PhaseShiftsIn(tr, 1);
            phi_alpha = PhaseShiftsIn(tr, 2);
        else
            phi1 = 2 * (rand - 0.5) * pi;
            phi_alpha = alpha * (rand - 0.5) * pi;
        end;

        PhaseShiftsOut(tr, 1:2) = [phi1, phi_alpha];
        rnd_phi12 = phi_alpha + dPhi;
        s{1}(1,:) = sin(2 * pi * F1 * t + phi1) .* sp(1,:);
        s{1}(2,:) = sin(2 * pi * F1 * t + phi1 + rnd_phi12) .* sp(1,:);

        if(bUsePhases)
            phi2 = PhaseShiftsIn(tr, 3);
            phi_alpha = PhaseShiftsIn(tr, 4);
        else
            phi2 = 2 * (rand - 0.5) * pi;
            phi_alpha = alpha * (rand - 0.5) * pi;
        end;

        PhaseShiftsOut(tr, 3:4) = [phi2, phi_alpha];
        rnd_phi34 = phi_alpha + dPhi;
        s{2}(1,:) =  sin(2 * pi * F1 * t + phi2) .* sp(2,:); 
        s{2}(2,:) =  sin(2 * pi * F1 * t + phi2 + rnd_phi34) .* sp(2,:); 

        if(bUsePhases)
            phi3 = PhaseShiftsIn(tr, 5);        
            phi_alpha = PhaseShiftsIn(tr, 6);
        else
            phi3 = 2 * (rand - 0.5) * pi;
            phi_alpha = alpha * (rand - 0.5) * pi;
        end;

        PhaseShiftsOut(tr, 5:6) = [phi3, phi_alpha];
        rnd_phi56 =  phi_alpha + dPhi;
        s{3}(1,:) =  sin(2 * pi * F1 * t + phi3) .* sp(3,:); 
        s{3}(2,:) =  sin(2 * pi * F1 * t + phi3 + rnd_phi56) .* sp(3,:); 

        if(bUsePhases)
            phi4 = PhaseShiftsIn(tr, 7);
            phi_alpha = PhaseShiftsIn(tr, 8);
        else
            phi4 = 2 * (rand - 0.5) * pi;
            phi_alpha = alpha * (rand - 0.5) * pi;
        end;

        PhaseShiftsOut(tr, 7:8) = [phi4, phi_alpha];
        rnd_phi78 = phi_alpha + dPhi;
        s{4}(1,:) =  sin(2 * pi * F1 * t + phi3) .* sp(4,:); 
        s{4}(2,:) =  sin(2 * pi * F1 * t + phi3 + rnd_phi56) .* sp(4,:); 

        % generate evoked activity
        e(1,:) = exp(-15 * (t - 0.2) .^ 2) .* sin(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);
        e(2,:) = exp(-15 * (t - 0.2) .^ 2) .* cos(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);

        % collect activity from the selected networks
        induced = zeros(nCh, T);
        for n = NetworkPairIndex
             a = Ggen(:, nwp{n}) * s{n};
             a = a / norm(a(:));   
            induced = induced + a;
        end;

        induced = induced / sqrt(sum((induced(:) .^ 2)));
        ind(:, range) = induced;

        evoked = zeros(nCh, T);
        evoked = Ggen(:, [2,4]) * e;
        evoked = evoked / sqrt(sum(evoked(:) .^ 2));
        evo(:, range) = evoked;

        range = range + T;

        if tr > 1
          for j = 0 : log10(tr - 1)
              fprintf('\b'); % delete previous counter display
          end
         end
         fprintf('%d', tr);
    end
    fprintf('\nDone.\n');
end

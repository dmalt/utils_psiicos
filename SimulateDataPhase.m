function [ Evoked, Induced, BrainNoise, SensorNoise, G2d, R, Fs,Ntr,XYZGenOut,Ggen, PhaseShiftsOut] = SimulateDataPhase(NetworkPairIndex, dPhi, bNewBrainNoise,PhaseShiftsIn,alpha_in)

bUsePhases = ~isempty(PhaseShiftsIn);

if(nargin < 5)
    alpha = 1.;
else
    alpha = alpha_in;
end;

ISD = load('InputData4Simulations.mat');
% load reduced forward model (GLowRes)
 % load('GLowRes.mat'); 
 % ISD.G = GLowRes;
% clear GLowRes;
% set to use gradiometers only

ISD.Channels = load('channel_vectorview306.mat');

SSPVE = 0.98;
RAP = 1;% number of RAP-MUSIC iterations

if(nargin == 0)
    bNewBrainNoise = true; % whether or not to generate new brain noise
end;
% specify locations of the generators
XYZGen = 1.3*[0.05,0.04,0.05; 0.05,-0.04,0.05;-0.05,0.04,0.05; -0.05,-0.04,0.05; 0.00,0.05,0.06; 0.00,-0.05,0.06];

%We will use only gradiometers
ChUsed = 1:306; 
ChUsed(3:3:end) = [];

% create normalized forward matrix, leaving only two components in the tangential plane 
[Ns, Nsites] = size(ISD.G.Gain(ChUsed,1:3:end));
G2d = zeros(Ns,Nsites*2);
G2dn = zeros(Ns,Nsites*2);
range = 1:2;
for i=1:Nsites
    g = [ISD.G.Gain(ChUsed,1+3*(i-1)) ISD.G.Gain(ChUsed,2+3*(i-1)) ISD.G.Gain(ChUsed,3+3*(i-1))];
    [dummy, dummy, v] = svd(g);
    G2d(:,range) = g * v(:,1:2);
    G2dn(:,range) = G2d(:,range) * diag(1 ./ sqrt(sum(G2d(:,range) .^ 2, 1)));
    range = range + 2;
end;

% Assign topographies to generator coordinates(do not recompute, just find the closest one)
R = ISD.G.GridLoc;
for i=1:size(XYZGen,1)
    d = repmat(XYZGen(i,:),size(R,1),1) - R;
    d = sum(d.*d,2);
    [dummy, ind] = min(d);
    XYZGenAct(i,:) = R(ind,:);
    Ggen(:,i) = G2d(:,ind * 2 - 1); % take the first dipole in the tangent plane
    GenInd(i) = ind; 
end;

% specify pairing nodes for each network
nwp{1} = [1,2];
nwp{2} = [3,4];
nwp{3} = [5,6];
nwp{4} = [1,3];
% Specify all networks  

nw = [nwp{NetworkPairIndex}]; % If you want to simulate all four networks use
%nw = [nw1 nw2 nw3 nw4]; see also line 87

Ngen = 6; % total number of generators
sp = zeros(2,500); 
T = 500;   % number of timeslices per trial
t = 1:T;

% synchrony profiles of networks, one of each  as specified in lines 34-37
sp(1,:) = exp(-1e-8 * (abs(t - 100)) .^ 4) ;
sp(2,:) = exp(-1e-8 * (abs(t - 350)) .^ 4) ;
sp(3,:) = exp(-0.2e-8 * (abs(t - 225)) .^ 4) ;
sp(4,:) = 0.5*(sin(10*t/500)+1);

Ntr = 100; %  number of trials
range = 1:T;
clear Data;
Fs = 500; % sampling rate
BrainNoise  = zeros(Ns,Ntr*T);
SensorNoise  = zeros(Ns,Ntr*T);
Induced     = zeros(Ns,Ntr*T);
Evoked     = zeros(Ns,Ntr*T);
F1 = 10; % Hz;
t = linspace(0,1,Fs);
clear s;
if(~bNewBrainNoise)
    BN = load('BrainNoiseBiomag2014.mat');
end;
fprintf('Simulating trial data ...\n');
fprintf('Current trial number (Max %d):', Ntr);
PhaseShiftsOut = zeros(Ntr,8);
for tr = 1:Ntr
    
    if(bUsePhases)
        phi1 = PhaseShiftsIn(tr,1);
        phi_alpha = PhaseShiftsIn(tr,2);
    else
        phi1= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,1:2) = [phi1 phi_alpha];
    rnd_phi12 = phi_alpha + dPhi;
    s{1}(1,:) = sin(2 * pi * F1 * t + phi1) .* sp(1,:);
    s{1}(2,:) = sin(2 * pi * F1 * t + phi1 + rnd_phi12) .* sp(1,:);

    if(bUsePhases)
        phi2 = PhaseShiftsIn(tr, 3);
        phi_alpha = PhaseShiftsIn(tr, 4);
    else
        phi2= 2 * (rand - 0.5) * pi;
        phi_alpha = alpha * (rand - 0.5) * pi;
    end;
    PhaseShiftsOut(tr,3:4) = [phi2 phi_alpha];
    rnd_phi34 = phi_alpha + dPhi;
    s{2}(1,:) =  sin(2*pi*F1*t+phi2).*sp(2,:); 
    s{2}(2,:) =  sin(2*pi*F1*t+phi2+rnd_phi34).*sp(2,:); 

    if(bUsePhases)
        phi3 = PhaseShiftsIn(tr,5);        
        phi_alpha = PhaseShiftsIn(tr,6);
    else
        phi3= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,5:6) = [phi3 phi_alpha];
    rnd_phi56 =  phi_alpha + dPhi;
    s{3}(1,:) =  sin(2*pi*F1*t+phi3).*sp(3,:); 
    s{3}(2,:) =  sin(2*pi*F1*t+phi3+rnd_phi56).*sp(3,:); 

    if(bUsePhases)
        phi4 = PhaseShiftsIn(tr,7);
        phi_alpha = PhaseShiftsIn(tr,8);
    else
        phi4= 2*(rand-0.5)*pi;
        phi_alpha = alpha*(rand-0.5)*pi;
    end;
    PhaseShiftsOut(tr,7:8) = [phi4 phi_alpha];
    rnd_phi78 = phi_alpha + dPhi;
    s{4}(1,:) =  sin(2*pi*F1*t+phi3).*sp(4,:); 
    s{4}(2,:) =  sin(2*pi*F1*t+phi3+rnd_phi56).*sp(4,:); 

    % generate evoked activity
    e(1,:) = exp(-15 * (t - 0.2) .^ 2) .* sin(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);
    e(2,:) = exp(-15 * (t - 0.2) .^ 2) .* cos(2 * pi * 8 * t + 0.8 * (rand - 0.5) * pi);
    
    % collect activity from the selected networks
    induced = zeros(Ns,T);
    for n=NetworkPairIndex
         a = Ggen(:,nwp{n}) * s{n};
         a = a / norm(a(:));   
        induced = induced + a;
    end;
    induced = induced/sqrt(sum((induced(:).^2)));
    Induced(:,range) = induced;
    
    evoked = zeros(Ns,T);
    evoked = Ggen(:,[2,4])*e;
    evoked = evoked/sqrt(sum(evoked(:).^2));
    Evoked(:,range) = evoked;
    
    if(bNewBrainNoise)
        brainnoise = GenerateBrainNoise(G2d,T,500,1000,Fs);
    else
        brainnoise = BN.BrainNoise(:,range);
    end;
    
    brainnoise = brainnoise/sqrt(sum((brainnoise(:).^2)));
    BrainNoise(:,range) = brainnoise;
    
    sensornoise = randn(size(brainnoise));
    sensornoise = sensornoise/sqrt(sum((sensornoise(:).^2)));
    SensorNoise(:,range) = sensornoise;
    range = range+T;
    if tr>1
      for j=0:log10(tr-1)
          fprintf('\b'); % delete previous counter display
      end
     end
     fprintf('%d', tr);
end

if(bNewBrainNoise)
    save('BrainNoiseBiomag2014.mat','BrainNoise');
end;

fprintf('\nDone.\n');

XYZGenOut = XYZGenAct(nw,:);
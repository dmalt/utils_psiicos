function [wPLI] = wPLIMatrix(X,band,Fs, bInducedOnly)
if(nargin<4)
    bInducedOnly = false;
end;
[Nch, Ns,  Ntr] = size(X);

T = Fs/Ns;

f = [0:1:Ns-1]*T;

ind_band = find(f>=band(1) & f<=band(2));

if(bInducedOnly)
    X = X-repmat(mean(X,3),[1,1,Ntr]);
end;

Xfft = fft(X,[],2);

Xfft_band = Xfft(:,ind_band,:);

wPLI = zeros(Nch,Nch);
abswPLI = zeros(Nch,Nch);

for tr=1:Ntr
    wPLI = wPLI + (imag(Xfft_band(:,:,tr)*(Xfft_band(:,:,tr))'));
    abswPLI = abswPLI + abs(imag(Xfft_band(:,:,tr)*(Xfft_band(:,:,tr))'));
end

wPLI = abs(wPLI)./abswPLI;
for i=1:size(wPLI,1)
    wPLI(i,i) = 0;
end;
    
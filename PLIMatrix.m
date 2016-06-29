function [PLI] = PLIMatrix(X,band,Fs, bInducedOnly)
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

PLI = zeros(Nch,Nch);

for tr=1:Ntr
    PLI = PLI + sign(imag(Xfft_band(:,:,tr)*(Xfft_band(:,:,tr))'));
end
PLI = abs(PLI/Ntr);


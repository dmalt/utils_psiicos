function [PLV] = PLVMatrix(X,band,Fs, bInducedOnly)
% -------------------------------------------------------
% description
% -------------------------------------------------------
% FORMAT:
%   [PLV] = PLVMatrix(X, band,Fs, bInducedOnly) 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

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
Xfft_band = Xfft_band./sqrt(Xfft_band.*conj(Xfft_band));


PLV = zeros(Nch,Nch);

for tr=1:Ntr
    PLV = PLV+ (Xfft_band(:,:,tr))*(Xfft_band(:,:,tr))';
end
PLV = abs(PLV/Ntr);
for i=1:size(PLV,1)
    PLV(i,i) = 0;
end;


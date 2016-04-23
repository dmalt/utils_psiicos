function [C] = CrossSpectralMatrix(X,band,Fs)

[Nch, Ns,  Ntr] = size(X);

T = Fs/Ns;

f = [0:1:Ns-1]*T;

ind_band = find(f>=band(1) & f<=band(2));

Xfft = fft(X,[],2);

Xfft_band = Xfft(:,ind_band,:);


if( 2*fix(Ntr/2) ==Ntr)
    trs_odd = 1:2:Ntr;
    trs_even = 2:2:Ntr;
else
    trs_odd = 1:2:Ntr-1;
    trs_even = 2:2:Ntr;
end


C = zeros(Nch,Nch);

for tr=1:length(trs_odd)
    C = C+ (Xfft_band(:,:,trs_odd(tr))-Xfft_band(:,:,trs_even(tr)))*(Xfft_band(:,:,trs_odd(tr))-Xfft_band(:,:,trs_even(tr)))';
end
C = C/Ntr;

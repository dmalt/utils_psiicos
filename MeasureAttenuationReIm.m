function [AttRe, AttIm] = MeasureAttenuationReIm(Upwr, G, N, SourcePairs)
% -----------------------------------------------------------------------
% description
% -----------------------------------------------------------------------
% FORMAT:
%   [AttRe, AttIm] = MeasureAttenuationReIm(Upwr, G, N, SourcePairs) 
% INPUTS:
%  Upwr
%  G
%  N 
%  SourcePairs       -
% OUTPUTS:
%  AttRe
%  AttIm
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    if(nargin==4)
        Np = size(SourcePairs,1);
    else
        Nsrc = size(G,2)/2;
        FirstSrcInds = randperm(Nsrc);
        FirstSrcInds = FirstSrcInds(1:N);
        SecondSrcInds = FirstSrcInds+Nsrc;
        SourcePairs = [FirstSrcInds(:) SecondSrcInds(:)];
        Np = size(SourcePairs,1);
    end;

    Nch  = size(G,1);
    Are = zeros(Nch*Nch,size(SourcePairs,1));
    Aim = zeros(Nch*Nch,size(SourcePairs,1));
    for p=1:Np
        tmp1 = G(:,SourcePairs(p,1))*G(:,SourcePairs(p,2))';
        tmp2 = tmp1+tmp1';
        Are(:,p) = tmp2(:);
        tmp2 = tmp1-tmp1';
        Aim(:,p) = tmp2(:);
    end;

    Arep  = Are-Upwr*(Upwr'*Are);
    AttRe = norm(Arep(:))/norm(Are(:));

    Aimp  = Aim-Upwr*(Upwr'*Aim);
    AttIm = norm(Aimp(:))/norm(Aim(:));
end

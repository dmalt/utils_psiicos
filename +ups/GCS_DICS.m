function [Cs, IND] = GCS_DICS(C,G)
% -------------------------------------------------------
% Apply geometric correction scheme + DICS beamformer
% -------------------------------------------------------
% FORMAT:
%   [Cs, Ps, IND] = GCS_DICS(C,G) 
% INPUTS:
%   C
%   G
% OUTPUTS:
%   Cs
%   Ps
%   IND
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru
    import ups.GCS_ScanFast
    import ups.DICS

    Ns = fix(0.5 * size(G,2)); % assume tangent space dimension of 2 

    A = DICS(C,G,10);

    Cs  = zeros(Ns * (Ns - 1) / 2, 1);
    IND = zeros(Ns * (Ns - 1) / 2, 2);

    [Cs,IND] = GCS_ScanFast(C,G,A);
end
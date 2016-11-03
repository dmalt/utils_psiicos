function [Cs, IND] = PSIICOS_DICS(C, G)
% -------------------------------------------------------
% PSIICOS scan with DICS inverse operator
% -------------------------------------------------------
% FORMAT:
%   format 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import ps.PSIICOS_ScanFast
    import ups.DICS

    Ns = fix(0.5 * size(G,2)); % assume tangent space dimension of 2 

    A = DICS(C,G,10);
    Cs  = zeros(Ns * (Ns - 1) / 2, 1);
    IND = zeros(Ns * (Ns - 1) / 2, 2);

    [Cs,IND] = PSIICOS_ScanFast(A',C(:));

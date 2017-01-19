function [Cs, IND, Upwr] = PSIICOS_DICS(C, G, lambda, rnk, Upwr)
% -------------------------------------------------------
% PSIICOS scan with DICS inverse operator
% -------------------------------------------------------
% FORMAT:
%   [Cs, IND] = PSIICOS_DICS(C, G, lambda) 
% INPUTS:
%   C        -
%   G
%   lambda 
% OUTPUTS:
%   Cs
%   IND
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import ps.PSIICOS_ScanFast
    import ups.DICS
    import ps.ProjectAwayFromPowerComplete

    if nargin < 5
    	Upwr = [];
    end
    if isempty(Upwr)
	    [C_proj, Upwr] = ProjectAwayFromPowerComplete(C, G, rnk);
	else
		temp = Upwr' * C;
		C_proj = C - Upwr * temp;
    end
    Ns = fix(0.5 * size(G,2)); % assume tangent space dimension of 2 

    Nch = sqrt(size(C,1));
    C_sq = reshape(C, Nch, Nch);

    A = DICS(C_sq,G,lambda);

    Cs  = zeros(Ns * (Ns - 1) / 2, 1);
    IND = zeros(Ns * (Ns - 1) / 2, 2);

    [Cs,IND] = PSIICOS_ScanFast(A',C_proj);
end
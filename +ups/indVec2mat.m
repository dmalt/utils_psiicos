function ij = indVec2mat(s, N)
% ---------------------------------------------
% Given linear index s and liner dimension N,
% return i and j such that: s = i + N * (j - 1)
% ---------------------------------------------
% FORMAT:
% 	ij = indVec2mat(s, N) 
% INPUTS:
% 	s      - linear index 
% 	N      - linear dimension 
% OUTPUTS:
% 	ij     - {1 x 2} array; matrix-like indices
% ---------------------------------------------
% EXAMPLE:
% 
% >> A  = magic(3);
% >> B = A(:);
% >> B(6)
% 
% ans =
% 
%      9
% 
% >> [i,j] = indVec2mat(6,3);
% >> A(i,j)
% 
% ans =
% 
%      9
% 
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	i = mod(s, N);
	if i == 0 
		i = N;
	end
	j = (s - i) / N + 1;
	ij = [i,j];
end
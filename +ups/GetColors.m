function colors = GetColors(mode)
% ------------------------------------------
% Define and return nice colorscheme
% ------------------------------------------
% FORMAT:
%   colors = GetColors() 
% OUTPUTS:
%   colors   - {1 x nColors} array struct;
% ----------
%   colors.RGB  - {1 x 3} rbg code for color;
%   colors.name - string; name of color;
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	if nargin < 1
		mode = 1;
	end
	switch mode
		case 1
			color_scheme = {
			    [112,127,127] / 256, % black
				[255 141 0]   / 256, % orange
				[12 232 126]  / 256, % green
				[0 35 255]    / 256, % blue
				[174 12 232]  / 256, % violet
				[255 248 13]  / 256, % yellow
				[232 12 143]  / 256  % red
			};
		case 2
			color_scheme = {
				[242,237,217]    / 256,
				[241, 169, 78]   / 256,
				[68, 179, 194]   / 256,
				[123, 141, 142]  / 256,
				[93, 76, 70]     / 256,
				[ 228, 86, 65]   / 256,
				[232, 12, 143]   / 256
			};
		case 3
			color_scheme = {
				[242, 242, 242]  / 256,
				[129, 67, 116]   / 256,
				[81, 163, 157 ]  / 256,
				[183, 105, 92]   / 256,
				[205, 187, 121]  / 256,
				[ 6, 66, 92]     / 256,
				[232 12 143]     / 256
			};
	end
	colors = struct('RGB', color_scheme);
	% colors.names = {};
end
 

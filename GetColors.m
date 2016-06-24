function colors = GetColors()
% -------------------------------------------------------
% Define and return nice colorscheme
% -------------------------------------------------------
% FORMAT:
%   colors = GetColors() 
% OUTPUTS:
%   colors   - {1 x nColors} array struct;
% ----------
%   colors.RGB  - {1 x 3} rbg code for color;
%   colors.name - string; name of color;
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	grey   = [112,127,127] / 256;
	orange = [255 141 0]   / 256;
	green  = [12 232 126]  / 256;
	blue   = [0 35 255]    / 256;
	violet = [174 12 232]  / 256;
	yellow = [255 248 13]  / 256;
	red    = [232 12 143]  / 256;
	colors = struct('RGB',   {grey, orange, green, blue, violet, yellow, red}, ...
					'name', {'grey' 'orange' 'green' 'blue' 'violet' 'yellow' 'red'});
	% colors.names = {};
end
 
function chUsed = PickChannels(chName)
% -------------------------------------------------------
% Pick channel indices for electa recordings
% -------------------------------------------------------
% FORMAT:
%   format 
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
	chUsed = 1:306;
	if strcmp(chName, 'grad')
		chUsed(3:3:end) = [];
	elseif strcmp(chName, 'mag')
		chUsed = 3:3:306;
	elseif strcmp(chName, 'meg')
		% do nothing
	else
		error('InputError:UnknowOption', 'Unknown option')
	end
end
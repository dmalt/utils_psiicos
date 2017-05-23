function ch_used = PickElectaChannels(ch_type)
% -------------------------------------------------------
% Pick MEG channel indices for electa neuromag recordings
% -------------------------------------------------------
% FORMAT:
%   ch_used = PickElectaChannels(ch_type)
% INPUTS:
%   ch_type   - string; possible values are 'grad',
%               'grad1', 'grad2', 'mag', 'meg'
% OUTPUTS:
%   ch_used   - {1 x n_ch_used} integer array; indices of
%               channels with type specified by <ch_type>
%               argument
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    ch_used = 1:306;
    if strcmp(ch_type, 'grad')
        ch_used(3:3:end) = [];
    elseif strcmp(ch_type, 'grad1')
        ch_used = 1:3:306;
    elseif strcmp(ch_type, 'grad2')
        ch_used = 2:3:306;
    elseif strcmp(ch_type, 'mag')
        ch_used = 3:3:306;
    elseif strcmp(ch_type, 'meg')
        % do nothing
    else
        error('InputError:UnknowOption', 'Unknown option')
    end
end

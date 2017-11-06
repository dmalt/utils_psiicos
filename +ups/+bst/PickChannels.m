function ch_used = PickChannels(channels, ch_type)
% -------------------------------------------------------
% Select indices of channels which have the type specified
% by ch_type
% -------------------------------------------------------
% FORMAT:
% ch_used = PickChannels(channels, ch_type)
% INPUTS:
%   channels      - struct; brainstorm-extracted channels
%   ch_type       - string; type of channels to use
% OUTPUTS:
% ch_used         - int array; indices of selected channels
% ________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    ch_types = {channels.Type};
    ch_used = [];
    for i_ch = 1:length(ch_types)
        if strcmp(ch_types{i_ch}, ch_type)
            ch_used = [ch_used, i_ch];
        end
    end
end

function ChLoc = ReadChannelLocations(MEG_sensors_file, ChUsed)
% -------------------------------------------------------------------
% ReadChannelLocations: read locations of MEG channels from .mat file,
% pick channels with indices from ChUsed and store the result in ChLoc
% -------------------------------------------------------------------
% FORMAT:
%   ChLoc = ReadChannelLocations(MEG_sensors_file, ChUsed) 
% INPUTS:
%   MEG_sensors_file     - string; path to a file with 
%                          MEG sensor locations
%   ChUsed               - {1 x NumOfChannelsUsed} array of indeces of
%                          channels that are left for analysis; 
%                          to use gradiometers only go for
%                          ChUsed = 1:306; ChUsed(3:3:end) = [];
% OUTPUTS:
%   ChLoc                - {3 x NumOfChannelsUsed} matrix with sensor
%                          coordinates in 3D-space
% ________________________________________________________________________
% Alex Ossadtchii ossadtchi@gmail.com, Dmitrii Altukhov, dm.altukhov@ya.ru

    MEGSensors = load(MEG_sensors_file);
    nChUsed = length(ChUsed);
    ChLoc = zeros(3, nChUsed);
    for i = 1:nChUsed
        ChLoc(:,i) = mean(MEGSensors.Channel(ChUsed(i)).Loc(:,:), 2);
    end
end

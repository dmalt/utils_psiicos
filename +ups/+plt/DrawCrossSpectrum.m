function CT_restored = DrawCrossSpectrum(CTimeseries, UP, ChLoc, ifSort)
% ------------------------------------------------------------
% DrawCrossSpectrum: get cross-spectrum timeseries on
% reduced sensors, restore it back to real sensors,
% if ifSort = true sort the rows of the resulting cross-
% spectrum in order of ascendance of the distance between
% two locations corresponding to this row and then plot
% the resulting matrix
% -------------------------------------------------------------
% FORMAT:
%   CT_restored = DrawCrossSpectrum(CTimeseries, UP, ChLoc, ifSort)
% INPUTS:
%   CTimeseries     - {N_sensors_reduced ^ 2 x Ntimes}
%                     cross-spectrum matrix on reduced
%                     sensors
%   UP              - {N_sensors x N_sensors_reduced} matrix;
%                     its columns are first N_sensors_reduced
%                     left singular vectors of gain matrix.
%   ChLoc           - {3 x NumOfChannelsUsed} matrix with sensors
%                     coordinates in 3D-space
%   ifSort          - boolean; if true perform sorting of the
%                     cross-spectrum on real sensors in order
%                     of ascendance of a distance between
%                     interacting locations corresponding
%                     to a row.
% OUTPUTS:
%   CT_restored     - {N_sensors ^ 2 Ntimes} cross-spectrum
%                     matrix on real sensors
% _____________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import ups.RestoreCTdim

    Nsensors = size(UP, 2);
    Ntimes = size(CTimeseries, 2);
    CTimeseriesRestored = zeros(Nsensors ^ 2, Ntimes);
    for t = 1:size(CTimeseries, 2)
        CT_restored = RestoreCTdim(CTimeseries(:,t), UP);
        CTimeseriesRestored(:,t) = CT_restored(:);
    end

    if ifSort
        sort_aux = zeros(Nsensors ^ 2, 1);
        for iPair = 1:length(sort_aux)
            [i,j] = ind2sub(Nsensors, iPair);
            sort_aux(iPair) = sqrt((ChLoc(i,1) - ChLoc(j,1)) ^ 2 + ...
                                   (ChLoc(i,2) - ChLoc(j,2)) ^ 2 + ...
                                   (ChLoc(i,3) - ChLoc(j,3)) ^ 2);
        end
        [~, key] = sort(sort_aux);
        CTimeseriesRestored = CTimeseriesRestored(key,:);
    end
    imagesc(abs(CTimeseriesRestored));
end

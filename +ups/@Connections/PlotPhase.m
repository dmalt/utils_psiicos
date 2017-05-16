function PlotPhase(obj, src, ~)
% -------------------------------------------------------
% Plot amplitude and phase spectrum in a popup window 
% for a clicked connection 
% -------------------------------------------------------
% FORMAT:
%   PlotPhase(obj, src, event)
% INPUTS:
%   obj        - Connections instance;
%   src        - handle to clicked line
%   ~          - click event; requied by matlab 
%                during function call
% NOTE:
%   obj.CT must be defined
% _______________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru
    import ups.FindXYZonGrid
    import ups.FindOr

    assert(~isempty(obj.CT), 'Cross-spectrum timeseries is undefined');

    xyz_i = [src.XData(1), src.YData(1), src.ZData(1)];
    xyz_j = [src.XData(2), src.YData(2), src.ZData(2)];

    ind_i = FindXYZonGrid(xyz_i, obj.headModel.GridLoc);
    ind_j = FindXYZonGrid(xyz_j, obj.headModel.GridLoc);

    G_ind_i = [ind_i * 2 - 1, ind_i * 2];
    G_ind_j = [ind_j * 2 - 1, ind_j * 2];

    g_i = obj.headModel.gain(:,G_ind_i);
    g_j = obj.headModel.gain(:,G_ind_j);

    nTimes = size(obj.CT, 2);
    nSensors = sqrt(size(obj.CT, 1));

    u = zeros(2, nTimes);
    v = zeros(2, nTimes);

    % obj.CT = ProjectAwayFromPowerComplete( obj.CT, obj.headModel.gain);

    tseries = complex(zeros(nTimes, 1));
    for i = 1:nTimes
        C = reshape(obj.CT(:,i), nSensors, nSensors);
        [u(:,i), v(:,i), ~] = FindOr(C, g_i, g_j);
        g_i_or = g_i * [1;0];%u(:,i);
        g_j_or = g_j * [1;0];%v(:,i);
        g = kron(g_i_or, g_j_or);
        tseries(i) = g' * obj.CT(:,i);
    end

    figure;
    subplot(4, 1, 1)
    plot(1:nTimes, abs(tseries), 'Color', src.Color, 'linewidth', 2);
    title('Network activation profile');
    subplot(4, 1, 2)
    plot(1:nTimes, unwrap(angle(tseries(:,:)), pi / 2), 'Color', src.Color, 'linewidth', 2);
    title('Phase shift');
    subplot(4, 1, 3)
    plot(1:nTimes, acos(u(1,:)), 'Color', src.Color, 'linewidth', 2)
    title('First dipole orientation');
    subplot(4, 1, 4)
    plot(1:nTimes, acos(v(1,:)), 'Color', src.Color, 'linewidth', 2)
    title('Second dipole orientation');
end

function DisplayTopographyCTF(v,Channel)

    % The function displays the topography vector on a hemisphere. The electrode locations
    % are also displayed.

    % Get Channel positions
    for i = 1:length(Channel)
        position(i,:)=mean(Channel(i).Loc, 2)';
    end;

    % Convert cartesian sensor coordinates into spherical ones
    center = [0 0 0]; % default head center location
    nmes = size(position,1);
    [teta, phi, R] = cart2sph(position(:,1) - center(1), position(:,2) - center(2), position(:,3) - center(3));
    angles = [teta, phi];

    teta = angles(:,1);
    phi = angles(:,2);
    %Set the fixed R i.e. project the sensors onto the sphere with R = 0.15
    R = 0.15;
    % Visualisation of electrodes.
    phimin = min(phi);
    phimax = max(phi);
    tetamin = min(teta);
    tetamax = max(teta);
    [x y z] = sph2cart(teta, phi, R * ones(size(phi)));
    % set the electordes to be on a sphere with the radius R * 1.05
    [xt yt zt] = sph2cart(teta, phi, R * 1.05 * ones(size(phi)));
    % create node points on the sphere to be used for creation of hemispheric surface
    % make a regular angular grid
    N = 69;
    phi = (phimin:(pi / 2 - phimin) / N:pi / 2)' * ones(1, N + 1);
    teta= (0: 2 * pi / N : 2 * pi )' * ones(1, N + 1);
    % find the corresponding cartesion coordinates
    xs = R * cos(teta') .* cos(phi);
    ys = R * sin(teta') .* cos(phi);
    zs = R * sin(phi);
    % set coordinates of the vertices to compute the interpolated values
    InterpChanPos = {xs, ys, zs};
    % visualize electrodes 
    ax_topo = gca;
    set(ax_topo, 'NextPlot', 'add');
    for i=1:nmes
       plot3(xt(i), yt(i), zt(i),  'o', 'markerfacecolor', [0.2 1 .2], 'markersize', 3, 'Tag', 'sensor', 'Parent', ax_topo);
   end
    %create spherical surface
    toposurf = surface(xs,ys,zs,'edgecolor','none','Parent',ax_topo,'FaceAlpha', 0.92);
    % create nice colormap 
    C = [flipud(fliplr(hot(128)));hot(128)];
    OrigChanPos = [x(:) y(:) z(:)];

    
    % Get the values in the interpolated locations
    Vp = griddata(OrigChanPos(:, 1), OrigChanPos(:, 2), v, InterpChanPos{1}, InterpChanPos{2}, 'v4');
    % Scale and turn into colormap indices
    minVp = min(Vp(:));
    maxVp = max(Vp(:));
    maxmax = max(abs(Vp(:)));
    % scale teh topography to fit into 0:255 range
    Vp = fix(127 + 127 * Vp ./ maxmax);
    set(toposurf,'CData',Vp,'Visible','on','facecolor','interp','CDataMapping','direct');
    %impose the colormap
    colormap(C);
    set(ax_topo,'NextPlot','Replace');


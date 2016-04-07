Dpair = 0.01;
clustSize = 20;
[clusters] = PairwiseClust(BootsIND, R, Dpair, clustSize); % clusters is a matrix {nClusters x nConnections}

linewidth = 1;
Markersize = 40;
orange = [255 141 0] / 256;
% curSubj = SubjBootstr{1};


nClust = length(clusters);

CT = CrossSpectralTimeseries(curSubj.Trials, true);
nSensors = sqrt(size(CT, 1));
% C = reshape(mean(CT,2), nSensors, nSensors);
C = reshape(CT(:,150), nSensors, nSensors); % need this to find dipoles orientation


% figure;
t = [subj_name, ', ', CTpart,', ', induced_str ', cond ', Cond_str,', ', num2str(band(1)), '-', num2str(band(2)), 'Hz'];

figure('Name', t,'NumberTitle','off')

for iClust = 1:nClust
% for iClust = 3:6
	clust = clusters{iClust};
	lefts = R(clust(:,1), :);
	rights = R(clust(:,2), :);

	% for i = 1:size(lefts,1)
	%         plot3( lefts(i,1), lefts(i,2), lefts(i,3),'.', 'Color', 'y', 'Markersize', Markersize );
	% end
	% for i = 1:size(rights,1)
	%         plot3( rights(i,1), rights(i,2), rights(i,3),'.', 'Color', 'm', 'Markersize', Markersize );
	% end
	% ----- Find coords of left and right centers of a cluster ---- %
	lefts_average = mean(lefts, 1);
	rights_average = mean(rights, 1);
	% plot3( lefts_average(1), lefts_average(2), lefts_average(3),'.', 'Color', 'c', 'Markersize', Markersize);
	% plot3( rights_average(1), rights_average(2), rights_average(3),'.', 'Color', 'k', 'Markersize', Markersize);
	xyz_i = lefts_average;
	xyz_j = rights_average;

	temp_i_Loc = sum(  ( R - repmat(xyz_i, [size(R, 1), 1]) ) .^ 2, 2  );
	temp_j_Loc = sum(  ( R - repmat(xyz_j, [size(R, 1), 1]) ) .^ 2, 2  );
	% ------------------------------------------------------------- %

	% --- Find the closest to the cluster center grid node --------- % 
	[i_sorted, i_key] = sort(temp_i_Loc);	
	[j_sorted, j_key] = sort(temp_j_Loc);
	i_key = i_key(1);	
	j_key = j_key(1);	

	IND_i = [i_key * 2 - 1, i_key * 2];
	IND_j = [j_key * 2 - 1, j_key * 2];
	% -------------------------------------------------------------- %

	g_i = curSubj.G(:,IND_i);
	g_j = curSubj.G(:,IND_j);
	% g = [kron(g_i, g_j), kron(g_j, g_i)];
	[u, v, f] = FindOr(C, g_i, g_j); % find dipole orientation
	g_i_or = g_i * u;
	g_j_or = g_j * v;
	g = kron(g_i_or, g_j_or);
	tseries = g' * CT;
	
	subplot(3, nClust, iClust)
	hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[112,127,127] / 256, 'EdgeColor','none','FaceAlpha', 0.4);
	grid off;
	axis off;
	camlight left; lighting phong
	camlight right; 
	hold on;
	L1 = line( R([i_key, j_key], 1), R([i_key, j_key],2), R([i_key, j_key],3) );
	plot3( R(i_key, 1), R(i_key,2), R(i_key,3),'.', 'Color', orange, 'Markersize', Markersize );
	plot3( R(j_key, 1), R(j_key,2), R(j_key,3),'.', 'Color', orange, 'Markersize', Markersize );
	set(L1, 'Color', orange, 'linewidth', linewidth);
	% figure;
	subplot(3 , nClust, nClust + iClust )
	plot(1:351, abs(tseries));
	% figure;
	subplot(3, nClust,  2 * nClust +  (iClust))
	plot(1:351,angle(tseries(:,:)));
end
% set(t,'Interpreter','none');
nTimes = size(CT,2);
u = zeros(2,nTimes);
v = zeros(2,nTimes);
for i = 1:size(CT,2)
	C = reshape(CT(:,i), nSensors, nSensors);
	[u(:,i), v(:,i), f] = FindOr(C, g_i, g_j);
end




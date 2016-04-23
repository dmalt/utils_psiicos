function  ClustCenters = ClustAverage(SetInd, R, clustDistance, clustSize)
% -------------------------------------------------------------
% Given indices of connected sites calculate average connection
% and map it onto the grid nodes. Return indices of these nodes.
% -------------------------------------------------------------
% FORMAT:
%   ClustCenters = ClustAverage(SetInd, R, clustRadius, clustSize) 
% INPUTS:
%   SetInd       - {nConnections x 2} matrix of indices of 
%                  connected pairs
%   R            - {nSources x 3} matrix of grid nodes 
%                  coordinates
%   clustDist    - scalar; assign connections to the same
%                  cluster if their ends are closer then
%                  clustDist 
%   clustSize    - scalar; minimal number of connections
%                  in cluster. Smaller clusters are dropped out
% OUTPUTS:
%   ClustCenters - {nClusters x 2} matrix of indices of 
%                  cluster centers.
% _____________________________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	[clusters] = PairwiseClust(SetInd, R, clustDistance, clustSize); % clusters is a matrix {nClusters x nConnections}

	nClust = length(clusters);
	ClustCenters = zeros(nClust, 2);

	for iClust = 1:nClust
		clust = clusters{iClust};

		lefts = R(clust(:, 1), :);
		rights = R(clust(:, 2), :);

		% ----- Find coords of left and right centers of a cluster -------- %
		lefts_average = mean(lefts, 1);
		rights_average = mean(rights, 1);

		xyz_i = lefts_average;
		xyz_j = rights_average;
		% ----------------------------------------------------------------- %
		% ------- Find closest to the cluster center grid node ------------ % 
		temp_i_Loc = sum(  ( R - repmat(xyz_i, [size(R, 1), 1]) ) .^ 2, 2  );
		temp_j_Loc = sum(  ( R - repmat(xyz_j, [size(R, 1), 1]) ) .^ 2, 2  );

		[~, ind_i] = sort(temp_i_Loc);	
		[~, ind_j] = sort(temp_j_Loc);

		ClustCenters(iClust,:) = [ind_i(1), ind_j(1)];
		% ----------------------------------------------------------------- %
	end
		% g_i = curSubj.G(:,IND_i);
		% G_IND_i = [ind_i * 2 - 1, ind_i * 2];
		% G_IND_j = [ind_j * 2 - 1, ind_j * 2];
		% g_j = curSubj.G(:,IND_j);
		% topos{iClust}.g_i = g_i;
		% topos{iClust}.g_j = g_j;
		% nTimes = size(CT, 2);
		% u = zeros(2, nTimes);
		% v = zeros(2, nTimes);
		% for i = 1:nTimes
		% 	C = reshape(CT(:,i), nSensors, nSensors);
		% 	[u(:,i), v(:,i), f] = FindOr(C, g_i, g_j);
		% 	g_i_or = g_i * u(:,i);
		% 	g_j_or = g_j * v(:,i);
		% 	g = kron(g_i_or, g_j_or);
		% 	tseries(i) = g' * CT(:,i);
		% 	nTrials = size(curSubj.Trials,3);
		% 	for iTrial = 1:nTrials
		% 		temp1 = g_i_or' * curSubj.Trials(:,i, iTrial);
		% 		temp2 = g_j_or' * curSubj.Trials(:,i, iTrial);
		% 		Trials_proj_i(i, iTrial) = temp1;
		% 		Trials_proj_j(i, iTrial) = temp2;
		% 	end
		% end
		% Tr_i = Trials_proj_i';
		% Tr_j = Trials_proj_j';
		% Tr_i_phase(:,:,iClust) = angle(hilbert(Tr_i));
		% Tr_j_phase(:,:,iClust) = angle(hilbert(Tr_j));
		% disp('\n')
		% % g = [kron(g_i, g_j), kron(g_j, g_i)];
		% % [u, v, f] = FindOr(C, g_i, g_j); % find dipole orientation
		% % g_i_or = g_i * u;
		% % g_j_or = g_j * v;
		% % g = kron(g_i_or, g_j_or);
		% % tseries = g' * CT;
		
		% subplot(3, nClust, iClust)
		% hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[112,127,127] / 256, 'EdgeColor','none','FaceAlpha', 0.4);
		% grid off;
		% axis off;
		% camlight left; lighting phong
		% camlight right; 
		% hold on;
		% L1 = line( R([i_key, j_key], 1), R([i_key, j_key],2), R([i_key, j_key],3) );
		% plot3( R(i_key, 1), R(i_key,2), R(i_key,3),'.', 'Color', orange, 'Markersize', Markersize );
		% plot3( R(j_key, 1), R(j_key,2), R(j_key,3),'.', 'Color', orange, 'Markersize', Markersize );
		% set(L1, 'Color', orange, 'linewidth', linewidth);
		% % figure;
		% subplot(3 , nClust, nClust + iClust )
		% plot(1:MaxTimeStep, abs(tseries));
		% % figure;
		% subplot(3, nClust,  2 * nClust +  (iClust))
		% plot(1:MaxTimeStep, angle(tseries(:,:)));
	% end
	% % set(t,'Interpreter','none');
	% nTimes = size(CT, 2);
	% u = zeros(2, nTimes);
	% v = zeros(2, nTimes);
	% for i = 1:nTimes
	% 	C = reshape(CT(:,i), nSensors, nSensors);
	% 	[u(:,i), v(:,i), f] = FindOr(C, topos{2}.g_i, topos{2}.g_j);
	% end

% figure; plot(1:MaxTimeStep, acos(u(1,:)))
% figure; plot(1:MaxTimeStep, acos(v(1,:)))



% DipInd = [];
% for i = 1:size(BootsIND,1)
% 	DipInd = [DipInd; BootsIND{i}];
% end

%  % plot3(XYZGen(:,1), XYZGen(:,2),XYZGen(:,3),'r');


% % ----------- Pairwise clustering ------------------------------ %
% [Npairs, dummy] = size(DipInd);
% adjMat = zeros(Npairs, Npairs);
% Dpair = 0.01; % Pairwise clustering distance threshold
% clustSize = 20; % Clulstersize threshold 
% for p1 = 1:Npairs
%     for p2 = p1:Npairs
%         if norm(R(DipInd(p1, 1),:) - R(DipInd(p2,1),:)) < Dpair ...
% && norm(R(DipInd(p1,2),:) - R(DipInd(p2,2),:)) < Dpair
%             adjMat(p1,p2) = 1;
%             adjMat(p2,p1) = 1;
%         end
%     end
% end

% N = size(DipInd, 1);
% i = 1; % Number of column in adjacence martrix
% clustNum = 0;
% % clusters = cell(1, 20);
% restPairs = DipInd;
% while(~isempty(restPairs))
%     if length(nonzeros(bfs(adjMat,i) > 0)) > clustSize;
%         % restPairs(i,:)
%         clust = restPairs(bfs(adjMat,i) > -1,:);
%         clustNum = clustNum + 1;
%         % drawset(clust, R, cols(clustNum,:));
%         clusters{clustNum} = clust;
%         restPairs = restPairs(bfs(adjMat, i) == -1,:);
%         adjMat = adjMat(bfs(adjMat, i) == -1, bfs(adjMat, i) == -1);
%     	% L1 = line( R(restPairs(i,:), 1), R(restPairs(i,:),2), R(restPairs(i,:),3) );
%     	% plot3( R(restPairs(i,1), 1), R(restPairs(i,1),2), R(restPairs(i,1),3), 'c.', 'Markersize', 40 );
%    		% plot3( R(restPairs(i,2), 1), R(restPairs(i,2),2), R(restPairs(i,2),3), 'c.', 'Markersize', 40 );
%     	% set(L1, 'Color', 'c', 'linewidth',2);
%         % i = 1;
%     else
%         restPairs = restPairs(2:end,:);
%         adjMat = adjMat(2:end,2:end);
%         % i = i + 1;
%     end
% end
% -------------------------- end of pairwise clustering ------------------------ %

Dpair = 0.01;
clustSize = 20;

[clusters] = PairwiseClust(BootsIND, R, Dpair, clustSize);


% --------------------------- Drawing ----------------------------------------- %

% ------ Colors definition --------------------------------------------- %
orange = [255 141 0] / 256;
green = [12 232 126] / 256;
blue = [0 35 255] / 256;
violet = [174 12 232] / 256;
yellow = [255 248 13] / 256;
red = [232 12 143] / 256;
cols = [ orange; green; blue; violet; yellow;
         orange; green; blue; violet; yellow;
         orange; green; blue; violet; yellow; ];
% ---------------------------------------------------------------------- %

figure;
hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[112,127,127] / 256, 'EdgeColor','none','FaceAlpha', 0.4);
grid off;
axis off;
hold on;

camlight left; lighting phong
camlight right; 
hold on;

nClust = length(clusters);
for iClust = 1:nClust
    % clust = clusters(iClust);
    drawset(clusters{iClust}, R, cols(iClust,:));
end
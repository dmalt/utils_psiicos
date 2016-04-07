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
hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[112,127,127] / 256, 'EdgeColor','none','FaceAlpha', 0.6);
grid off;
axis off;
hold on;
% filename = [data_folder, subj_name,'_', CTpart,'_induced', '_cond_', Cond_str, '/', 'SubjBootstr_', num2str(band(1)), '_', ...
%  num2str(band(2)), '_', subj_name, '_', CTpart, '_', num2str(rnk), '_cond_', Cond_str];
t = title([subj_name, ', ', CTpart,', ', induced_str ', cond ', Cond_str,', ', num2str(band(1)), '-', num2str(band(2)), 'Hz']);
set(t,'Interpreter','none');
camlight left; lighting phong
camlight right; 
hold on;

nClust = length(clusters);
for iClust = 1:nClust
    % clust = clusters(iClust);
    drawset(clusters{iClust}, R, cols(iClust,:));
end
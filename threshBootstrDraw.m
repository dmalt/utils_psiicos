Dpair = 0.01;
clustSize = 20;

DipInd = [];
    for i = 1:size(DipInd,1)
      DipInd = [DipInd; DipInd{i}];
    end
[clusters] = PairwiseClust(DipInd, R, Dpair, clustSize);
% --------------------------- Drawing ----------------------------------------- %

% ------ Colors definition --------------------------------------------- %
orange = [255 141 0] / 256;
green = [12 232 126] / 256;
blue = [0 35 255] / 256;
violet = [174 12 232] / 256;
yellow = [255 248 13] / 256;
red = [232 12 143] / 256;
colors = [ orange; green; blue; violet; yellow;
         orange; green; blue; violet; yellow;
         orange; green; blue; violet; yellow;
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
titleStr = title([subj_name, ', ',...
           CTpart,', ',...
           induced_str ',',...
           ' cond ', Cond_str,', ',...
           num2str(band(1)), '-', num2str(band(2)), ' Hz, ', ...
           num2str(TimeRange(1)), '-', num2str(TimeRange(2)), ' sec']);

set(titleStr,'Interpreter','none');
camlight left; lighting phong
camlight right; 
hold on;

nClust = length(clusters);
for iClust = 1:nClust
    drawset(clusters{iClust}, R, colors(iClust,:));
end
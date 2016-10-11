% [HM, CT, Tr, Ctx] = GenerData(pi/3);
% grey = [247,247,247] / 256;
% grey = [0.99, 0.99, 0.99];

% --------------------------------------------------------->
% Picture with activation envelopes and network topographies 
% for simulations
% <---------------------------------------------------------

T = 500;   % number of timeslices per trial
t = 1:T;

sp(1,:) = exp(-1e-8 * (abs(t - 150)) .^ 4) ;
sp(2,:) = exp(-1e-8 * (abs(t - 300)) .^ 4) ;
sp(3,:) = exp(-0.2e-8 * (abs(t - 225)) .^ 4) ;

subplot(1,3,[1,2]);
plot(t * 2, sp(1,:), 'Color', 'b', 'LineWidth', 2)
hold on;
plot(t * 2, sp(2,:), 'Color', 'g', 'LineWidth', 2)
hold on;
plot(t * 2, sp(3,:), 'Color', 'r', 'LineWidth', 2)
grid on;
daspect([1000,2,1]);
xlabel('Time, ms');
ylim([0,1.1]);
legend('Network 1','Network 2', 'Network 3');
set(gca,'fontsize', 20)
t = title('a)', 'position', [500,-0.35]);
% set(t, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');



grey = [112,127,127] / 256;
% figure;
subplot(1,3,3);


% load('infl_ctx.mat');
% load('hr_def_ctx.mat');
load('hr_df_infl_ctx.mat');

Ctx = hr_df_infl_ctx;
% Ctx = hr_def_ctx;
% Ctx = infl_ctx;
hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),...
        'FaceColor', grey, 'EdgeColor','none','FaceAlpha', 0.6); 
lighting gouraud;
% set(gcf,'color','k');
grid off;
axis equal;
view(-90,90);
camlight(-90,90);
axis off;
% camlight right;

hold on;

XYZGen = 1.2 * [ 0.05,  0.04, 0.05;                     
                 0.05, -0.04, 0.05;                    
                -0.05,  0.04, 0.05;                    
                -0.05, -0.04, 0.05;
                 0.00,  0.05, 0.06;
                 0.00, -0.05, 0.06];
% HM = LoadHeadModel('0003_pran', '2');
for iPoint = 1:size(XYZGen, 1)
  % ind(iPoint) = FindXYZonGrid(XYZGen(iPoint,:), HM.GridLoc);
  ind(iPoint) = FindXYZonGrid(XYZGen(iPoint,:), Ctx.Vertices);
end

title('b)', 'position', [-0.130,0]);
conInds = reshape(ind, 2, 3)';

colorScheme = GetColors();
bg_color = colorScheme(1).RGB;
colors = {colorScheme(2:end).RGB};

% drawConnectionsOnBrain(conInds, Ctx.Vertices, 1, Ctx)
  drawset(conInds(1,:), Ctx.Vertices,  'b', 6, 80);
  drawset(conInds(2,:), Ctx.Vertices, 'r', 6, 80);
  drawset(conInds(3,:), Ctx.Vertices, 'g', 6, 80);


Box_posterior = uicontrol('style','text');
set(Box_posterior,'Units','characters')
set(Box_posterior,'String','Posterior', 'Position', [145, 33, 20, 2], 'fontsize', 18, 'BackgroundColor', 'w');

Box_anterior = uicontrol('style','text');
set(Box_anterior,'Units','characters')
set(Box_anterior,'String','Anterior', 'Position', [145, 7, 20, 2], 'fontsize', 18, 'BackgroundColor', 'w');

set(gca,'fontsize', 20)
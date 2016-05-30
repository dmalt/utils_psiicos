data_full_path = ['~/ps/Data/0003_pran/' ... 
				  '0003_pran_full_induced_cond_2_0.4_0.7_s_thresh_0.6/'...
				  'SubjBootstr_19_23_0003_pran_full_350_cond_2.mat'];
data_imag_path = ['~/ps/Data/0003_pran/'...
				  '0003_pran_imag_induced_cond_2_0.4_0.7_s_thresh_0.6/'...
				  'SubjBootstr_19_23_0003_pran_imag_350_cond_2.mat'];
clustDistance = 0.014;
clustSize = 2;

data_full = load(data_full_path);
data_imag = load(data_imag_path);
Ctx = data_full.curSubj.CtxHR;
BootsIND_full = data_full.curSubj.BootsIND;
BootsIND_imag = data_imag.curSubj.BootsIND;
IND_full = [];
IND_imag = [];


nBootstr_full = length(BootsIND_full);
nBootstr_imag = length(BootsIND_imag);

bootsCentersFull = cell(nBootstr_full, 1);
ClustCenters_imag = cell(nBootstr_imag, 1);
bootsCentersFull_ind = cell(nBootstr_full, 1);
ClustCentersInd_imag = cell(nBootstr_imag, 1);
con_full = cell(nBootstr_full, 1);
conn_imag = cell(nBootstr_imag, 1);
% boots_clusters_full = cell(nBootstr_full, 1);
% boots_clusters_imag = cell(nBootstr_imag, 1);




% fprintf('Full spectrum iterations:');
for i  = 1:nBootstr_full
	IND_full = BootsIND_full{i};
	con_full{i} = pran.sConnections(BootsIND_full{i});
end
% return
boots_con_full = BootsConnections(con_full);
boots_clusters_full = boots_con_full.clusterize(clustDistance, clustSize);
boots_clusters_full.average();
centers_full = boots_clusters_full.mergeCenters();
clusters = PairwiseClust(centers_full, 0.014, 5);

for i  = 1:nBootstr_imag
	IND_imag = BootsIND_imag{i};
	con_imag{i} = pran.sConnections(BootsIND_imag{i});
end

boots_con_imag = BootsConnections(con_imag);
boots_clusters_imag = boots_con_imag.clusterize(clustDistance, clustSize);
boots_clusters_imag.average();
centers_imag = boots_clusters_imag.mergeCenters();
clusters_imag = PairwiseClust(centers_imag, 0.014, 5);
return;
% fprintf('Imag spectrum iterations:');
% for i  = 1:nBootstr_imag
% 	IND_imag = BootsIND_imag{i};
% 	ClustCenters_imag{i} = ClustAverage(IND_imag, R_imag, clustDistance, clustSize);
% 	CounterDisplay(i);
% end
% fprintf('\n')
% return
% networks_imag = PairwiseClust(bootsCentersFull, 0.013, 1);
% net_ind = [];
% for i = 1:1; %length(networks_full)
% 	net_ind = [net_ind; networks_full{i}];
% end
% % DipInd = net_ind;
% drawConnectionsOnBrain(net_ind, R_full, 2, Ctx);
% networks_imag = PairwiseClust(ClustCenters_imag, R_imag, 0.013, 1);





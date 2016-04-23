data_full_path = ['~/ps/Data/0003_pran/' ... 
				  '0003_pran_full_induced_cond_2_0.4_0.7_s_thresh_0.6/'...
				  'SubjBootstr_19_23_0003_pran_full_350_cond_2.mat'];
data_imag_path = ['~/ps/Data/0003_pran/'...
				  '0003_pran_imag_induced_cond_2_0.4_0.7_s_thresh_0.6/'...
				  'SubjBootstr_19_23_0003_pran_imag_350_cond_2.mat'];
clustDistance = 0.013;
clustSize = 20;

data_full = load(data_full_path);
data_imag = load(data_imag_path);
Ctx = data_full.curSubj.Ctx;
BootsIND_full = data_full.curSubj.BootsIND;
BootsIND_imag = data_imag.curSubj.BootsIND;
IND_full = [];
IND_imag = [];


nBootstr_full = length(BootsIND_full);
nBootstr_imag = length(BootsIND_imag);

ClustCenters_full = cell(nBootstr_full, 1);
ClustCenters_imag = cell(nBootstr_imag, 1);

R_full = data_full.curSubj.R;
R_imag = data_imag.curSubj.R;

fprintf('Full spectrum iterations:');
for i  = 1:nBootstr_full
	IND_full = BootsIND_full{i};
	ClustCenters_full{i} = ClustAverage(IND_full, R_full, clustDistance, clustSize);
	CounterDisplay(i);
end
fprintf('\n');
fprintf('Imag spectrum iterations:');
for i  = 1:nBootstr_imag
	IND_imag = BootsIND_imag{i};
	ClustCenters_imag{i} = ClustAverage(IND_imag, R_imag, clustDistance, clustSize);
	CounterDisplay(i);
end

return
networks_full = PairwiseClust(ClustCenters_full, R_full, 0.013, 1);
net_ind = [];
for i = 1:1; %length(networks_full)
	net_ind = [net_ind; networks_full{i}];
end
% DipInd = net_ind;
drawConnectionsOnBrain(net_ind, R_full, 'y', Ctx);
networks_imag = PairwiseClust(ClustCenters_imag, R_imag, 0.013, 1);





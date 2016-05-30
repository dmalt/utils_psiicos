data_full_path = ['~/ps/Data/0003_pran/' ... 
				  '0003_pran_full_induced_cond_2_0.4_0.7_s_thresh_0.9/'...
				  'SubjBootstr_19_23_0003_pran_full_350_cond_2.mat'];
data = load(data_full_path);
% Ctx = data.curSubj.Ctx;
% CtxHR = data.curSubj.CtxHR;
BootsIND = data.curSubj.BootsIND{1};
R = data.curSubj.R;
subjID = '0003_pran';
freqBand = [10,14];
timeRange = [0, 0.7];
b1 = Connections(subjID, BootsIND, freqBand, timeRange);


isInducedOnly = true;
protocolName = 'PSIICOS';
protocolPath = '~/PSIICOS_osadtchii';
condition = '2';

[conData] = ...
    ImportBrainstormTrials(subjID, freqBand, isInducedOnly,...
                           timeRange, protocolName, protocolPath, condition)
%  boots1.plot()
% clusters = PairwiseClust(boots1, 0.009, 10);

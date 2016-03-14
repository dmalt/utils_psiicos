path(path, '~/gops/gopsiicos_source/source/drawscripts')
path(path, '~/gops/gopsiicos_source/input')
path(path, '~/ps/')
data_folder = '~/ps/';
subj_name = '0003_pran';
low_fr = 16;
high_fr = low_fr + 4;
band = [low_fr, high_fr];
CTpart = 'full';
Cond = 2;
Cond_str = num2str(Cond);
rnk = 350;
filename = [data_folder, subj_name,'_', CTpart, '_cond_', Cond_str, '/', 'SubjBootstr_', num2str(band(1)), '_', ...
 num2str(band(2)), '_', subj_name, '_', CTpart, '_', num2str(rnk), '_cond_', Cond_str];
load(filename);

iSubj = 1;
% Subjects = {'0003_pran', '0019_shev', '0030_koal',...
%              '0108_bami', '0062_peek', '0074_kuni',...
%              '0100_kase', '0106_supo', '0109zvma', '0130_hagr'}
R = SubjBootstr{iSubj}.R;
Ctx = SubjBootstr{iSubj}.Ctx;
BootsIND = SubjBootstr{iSubj}.BootsIND;

% R = curSubj.R;
% Ctx = curSubj.Ctx;
% BootsIND = curSubj.BootsIND;

threshBootstrDraw;















% load('./zvma/SubjBootstr_2_6_zvma_full_350')
% load('./zvma/SubjBootstr_3_7_zvma_full_350')
% load('./zvma/SubjBootstr_4_8_zvma_full_350')
% load('./zvma/SubjBootstr_5_9_zvma_full_350')
% load('./zvma/SubjBootstr_6_10_zvma_full_350')
% load('./zvma/SubjBootstr_7_11_zvma_full_350')
% load('./zvma/SubjBootstr_8_12_zvma_full_350')
% load('./zvma/SubjBootstr_9_13_zvma_full_350')
% load('./zvma/SubjBootstr_10_14_zvma_full_350')
% load('./zvma/SubjBootstr_11_15_zvma_full_350')
% load('./zvma/SubjBootstr_12_16_zvma_full_350')
% load('./zvma/SubjBootstr_13_17_zvma_full_350')
% load('./zvma/SubjBootstr_14_18_zvma_full_350')
% load('./zvma/SubjBootstr_16_20_zvma_full_350')
% load('./zvma/SubjBootstr_17_21_zvma_full_350')
% load('./zvma/SubjBootstr_18_22_zvma_full_350')
% load('./zvma/SubjBootstr_19_23_zvma_full_350')
% load('./zvma/SubjBootstr_20_24_zvma_full_350')
% load('./zvma/SubjBootstr_21_25_zvma_full_350')
% load('./zvma/SubjBootstr_22_26_zvma_full_350')
% load('./zvma/SubjBootstr_23_27_zvma_full_350')
% load('./zvma/SubjBootstr_24_28_zvma_full_350')
% load('./zvma/SubjBootstr_25_29_zvma_full_350')

% load('./kase/SubjBootstr_2_6_kase_full_350')
% load('./kase/SubjBootstr_3_7_kase_full_350')
% load('./kase/SubjBootstr_4_8_kase_full_350')
% load('./kase/SubjBootstr_5_9_kase_full_350')
% load('./kase/SubjBootstr_6_10_kase_full_350')
% load('./kase/SubjBootstr_7_11_kase_full_350')
% load('./kase/SubjBootstr_8_12_kase_full_350')
% load('./kase/SubjBootstr_9_13_kase_full_350')
% load('./kase/SubjBootstr_10_14_kase_full_350')
% load('./kase/SubjBootstr_11_15_kase_full_350')
% load('./kase/SubjBootstr_12_16_kase_full_350')
% load('./kase/SubjBootstr_13_17_kase_full_350')
% load('./kase/SubjBootstr_14_18_kase_full_350')
% load('./kase/SubjBootstr_15_19_kase_full_350')
% load('./kase/SubjBootstr_16_20_kase_full_350')
% load('./kase/SubjBootstr_17_21_kase_full_350')
% load('./kase/SubjBootstr_18_22_kase_full_350')
% load('./kase/SubjBootstr_19_23_kase_full_350')
% load('./kase/SubjBootstr_20_24_kase_full_350')
% load('./kase/SubjBootstr_21_25_kase_full_350')
% load('./kase/SubjBootstr_22_26_kase_full_350')
% load('./kase/SubjBootstr_23_27_kase_full_350')
% load('./kase/SubjBootstr_24_28_kase_full_350')
% load('./kase/SubjBootstr_25_29_kase_full_350')

% load('./pran/SubjBootstr_2_6_pran_full_350')
% load('./pran/SubjBootstr_3_7_pran_full_350')
% load('./pran/SubjBootstr_4_8_pran_full_350')
% load('./pran/SubjBootstr_5_9_pran_full_350')
% load('./pran/SubjBootstr_6_10_pran_full_350')
% load('./pran/SubjBootstr_7_11_pran_full_350')
% load('./pran/SubjBootstr_8_12_pran_full_350')
% load('./pran/SubjBootstr_9_13_pran_full_350')
% load('./pran/SubjBootstr_10_14_pran_full_350')
% load('./pran/SubjBootstr_11_15_pran_full_350')
% load('./pran/SubjBootstr_12_16_pran_full_350')
% load('./pran/SubjBootstr_13_17_pran_full_350')
% load('./pran/SubjBootstr_14_18_pran_full_350')

% load('./pran/SubjBootstr_15_19_pran_full_350')
% load('./pran/SubjBootstr_16_20_pran_full_350')

% load('./pran/SubjBootstr_17_21_pran_full_350')
% load('./pran/SubjBootstr_18_22_pran_full_350')
% load('./pran/SubjBootstr_19_23_pran_full_350')
% load('./pran/SubjBootstr_20_24_pran_full_350')
% load('./pran/SubjBootstr_21_25_pran_full_350')
% load('./pran/SubjBootstr_22_26_pran_full_350')
% load('./pran/SubjBootstr_23_27_pran_full_350')
% load('./pran/SubjBootstr_24_28_pran_full_350')
% load('./pran/SubjBootstr_25_29_pran_full_350')
% load('./pran/SubjBootstr_26_30_pran_full_350')	





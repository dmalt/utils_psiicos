
% Help
path(path, '/home/dmalt/gops/gopsiicos_source/source/drawscripts')
path(path, '/home/dmalt/gops/gopsiicos_source/input')
path(path, '/home/dmalt/ps/')
base_folder = '/home/dmalt/ps/';
data_folder = [base_folder, 'Data/'];
pics_folder = [base_folder, 'Pictures/'];
clear curSubj;
subj_name = '0003_pran';
% subj_name = '0109_zvma';
% subj_name = '0100_kase';
% subj_name = '0109_zvma';
% subj_name = '0062_peek';
% subj_name = '0030_koal';
% subj_name = '0108_bami';
% subj_name = '0019_shev';
% subj_name = '0003_pran';
TimeRange = [0.4, 0.7];
% TimeRange = [0.26, 0.8];
% isSave = true;
isSave = false;
low_fr = 19;
high_fr = low_fr + 4;
band = [low_fr, high_fr];
CTpart = 'imag';
% CTpart = 'full';
induced_str = 'induced';
% induced_str = 'total';
Cond = 2;
Cond_str = num2str(Cond);
rnk = 350;
path_postfix = [subj_name, '/', ...
                subj_name,'_', CTpart,'_', ...
                induced_str, ...
                '_cond_', Cond_str, '_', ...
                num2str(TimeRange(1)), '_', num2str(TimeRange(2)), '_s_','thresh_', num2str(threshold),   '/'];

file_path = [data_folder, path_postfix];
filename = [file_path, 'SubjBootstr_', ...
            num2str(band(1)), '_', num2str(band(2)), '_', ...
            subj_name, '_', CTpart, '_', ...
            num2str(rnk), '_cond_', Cond_str,  '.mat']; 
load(filename);

iSubj = 1;


% R = SubjBootstr{iSubj}.R;
% Ctx = SubjBootstr{iSubj}.Ctx;
% BootsIND = SubjBootstr{iSubj}.BootsIND;

% curSubj = SubjBootstr{1};

R = curSubj.R;
if isfield(curSubj, 'CtxHR')
	Ctx = curSubj.CtxHR;
else
	anatPathHR = strcat('/home/dmalt/PSIICOS_osadtchii/anat/', subj_name,'/tess_cortex_concat.mat');
	% anatPathHR = strcat('/home/dmalt/PSIICOS_osadtchii/anat/', subj_name,'/tess_cortex_pial_low.mat');
	curSubj.CtxHR = load(anatPathHR);
	Ctx = curSubj.CtxHR;
	save(filename, 'curSubj', '-v7.3');
end
BootsIND = curSubj.BootsIND;

threshBootstrDraw;
figSaveDir = [pics_folder, path_postfix];
if ~exist(figSaveDir, 'dir')
	mkdir(figSaveDir);
end
savename = [figSaveDir, subj_name, '_', ...
			num2str(band(1)), '_', num2str(band(2))];
if isSave
	saveas(gcf, savename, 'fig')
end
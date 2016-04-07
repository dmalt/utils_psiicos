path(path, '/home/dmalt/gops/gopsiicos_source/source/drawscripts')
path(path, '/home/dmalt/gops/gopsiicos_source/input')
% Subj = '0003_pran';
% Subj = '0019_shev';
% Subj = '0030_koal';
% Subj = '0108_bami';
% Subj = '0062_peek';
% Subj = '0074_kuni';
% Subj = '0100_kase';
% Subj = '0106_supo';
% Subj = '0109zvma';
% Subj = '0130_hagr';

Rnk = 350;
threshold = 0.97;
bInducedOnly = false;

CTpart = 'full';
% CTpart = 'imag';
 % Subjects = {'0003_pran', '0019_shev', '0030_koal',...
 %             '0108_bami', '0062_peek', '0074_kuni',...
 %             '0100_kase', '0106_supo', '0109zvma', '0130_hagr'}
 % Subjects = {'0003_pran', '0019_shev', '0100_kase', '0109zvma'}
 Subjects = {'0003_pran'}%, '0019_shev', '0100_kase', '0109zvma'}
 % Subjects = {'0109zvma'}; %, '0100_kase', '0109zvma'}
 % Subjects = {'0003_pran', '0019_shev', '0100_kase', '0109_zvma'};
 % Subjects = {'0019_shev', '0100_kase', '0109_zvma'};
 % Subjects = {'0030_koal', '0108_bami', '0062_peek'};
 % Subjects = {'0109_zvma', '0030_koal', '0108_bami', '0062_peek'};
 % Subjects = {'0100_kase'}; %, '0109zvma'}
 % Subjects = {'0019_shev'}; %, '0109zvma'}

nSubjects = length(Subjects);
SubjBootstr = cell(nSubjects, 1);
% Condition = 2; 
Condition = 2;

if bInducedOnly
	IndStr = '_induced_';
else
	IndStr = '_total_';
end

for iSubj = 1:nSubjects
	Band = [2,6];
	for i = 1:24	
		[ConData, G] = PrepRealData(Subjects{iSubj}, Band, bInducedOnly);
		SubjBootstr{iSubj}.G = G;
		% InducedScale = 0.35;
		% EvokedScale = 0;
		% [G, CrossSpecTime, UP, Trials] = GenerData(pi / 4, InducedScale, EvokedScale); 
		% sim = load('Sim.mat');
		SubjBootstr{iSubj}.R = ConData{Condition}.HM_LR.GridLoc;
		SubjBootstr{iSubj}.Trials = ConData{Condition}.Trials;
		% R = sim.GridLocLR;
		% Ctx = sim.Ctx;
		% [BootsIND, maxes] = bootstrap(Trials, sim.GLR, 100);
		[SubjBootstr{iSubj}.BootsIND, SubjBootstr{iSubj}.maxes] = ...
		 bootstrap(SubjBootstr{iSubj}.Trials, G, 100, Rnk, threshold, CTpart, bInducedOnly);

		% Rnk = 350;
		% [IND, Cp, Upwr, Cs] = T_PSIICOS(ConData{Condition}.CrossSpecTime, G, 0.9, Rnk, 3);
		if strcmp(Subjects{iSubj}, '0003_pran')
			SubjBootstr{iSubj}.anatPath =...
			 strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_concat_2000V.mat');
			 SubjBootstr{iSubj}.anatPathHR =...
			  strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_concat.mat');

		elseif strcmp(Subjects{iSubj},'0108_bami')
			SubjBootstr{iSubj}.anatPath =...
			 strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_pial_low_2003V.mat');
			 SubjBootstr{iSubj}.anatPathHR =...
			  strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_pial_low.mat');
		else
			SubjBootstr{iSubj}.anatPath =...
			 strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_pial_low_2000V.mat');
			 SubjBootstr{iSubj}.anatPathHR =...
			  strcat('/home/dmalt/PSIICOS_osadtchii/anat/', Subjects{iSubj},'/tess_cortex_pial_low.mat');

		end
		SubjBootstr{iSubj}.Ctx = load(SubjBootstr{iSubj}.anatPath);
		SubjBootstr{iSubj}.CtxHR = load(SubjBootstr{iSubj}.anatPathHR);

		%---------- SAVE RESULTS --------- %
		strBand1 = num2str(Band(1));
		strBand2 = num2str(Band(2));
		base_dir = '~/ps/Data/';
		folder_name = [base_dir, Subjects{iSubj}, '/', Subjects{iSubj}, '_', ...
					   CTpart, IndStr, 'cond_', num2str(Condition), '_400ms'];
		if ~exist(folder_name, 'file')
			mkdir(folder_name);
		end
		save_fname = [folder_name, '/SubjBootstr_', strBand1,'_', strBand2,...
					 '_', Subjects{iSubj},'_', CTpart,'_', num2str(Rnk), '_cond_', num2str(Condition), '.mat'];
		curSubj = SubjBootstr{iSubj};
		save(save_fname, 'curSubj', '-v7.3');
		Band = Band + 1;
		% -------------------------------- %
	end

end
% figure;

% hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[0.1,0.51,1], 'EdgeColor','none','FaceAlpha', 0.1);
% hold on;
% drawset(IND, R, 'm');

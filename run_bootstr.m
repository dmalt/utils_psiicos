path(path, '/home/dmalt/gops/gopsiicos_source/source/drawscripts')
path(path, '/home/dmalt/gops/gopsiicos_source/input')
path(path, '/home/dmalt/ps/Src')
% clear all;
AllSubjects = { '0003_pran', ... % 1
				'0019_shev', ... % 2
				'0030_koal', ... % 3
				'0108_bami', ... % 3
				'0062_peek', ... % 5
				'0074_kuni', ... % 6
				'0100_kase', ... % 7
				'0106_supo', ... % 8
				'0109_zvma', ... % 9
				'0130_hagr'};    % 10


% ---------- Params ------------ %
% Subjects = AllSubjects([1, 2, 9]);
Subjects = AllSubjects(1);
TimeRange = [0.4, 0.7];
% TimeRange = [0.26, 0.8];
Rnk = 350;
threshold = 0.97;
% threshold = 0.9;
% bInducedOnly = false;
bInducedOnly = true;

% CTpart = 'full';
CTpart = 'imag';
% Condition = 2; 
Condition = 2;
Band = [19,23];	
% Band = [19,23];
BandDelta = 4;
% ------------------------------ %
if bInducedOnly
	IndStr = '_induced_';
else
	IndStr = '_total_';
end

nSubjects = length(Subjects);
SubjBootstr = cell(nSubjects, 1);

for iSubj = 1:nSubjects
	CurBand = [Band(1), Band(1) + BandDelta];
	while CurBand <= Band(2)	
		% [ConData, G] = PrepRealData(Subjects{iSubj}, CurBand, bInducedOnly, TimeRange);
		HM = LoadHeadModel(Subjects{iSubj});
		SubjBootstr{iSubj}.G = HM.gain;
		% SubjBootstr{iSubj}.G = G;
		% InducedScale = 0.35;
		% EvokedScale = 0;
		% [G, CrossSpecTime, UP, Trials] = GenerData(pi / 4, InducedScale, EvokedScale); 
		% sim = load('Sim.mat');
		SubjBootstr{iSubj}.R = HM.gridLoc;
		% SubjBootstr{iSubj}.Trials = ConData{Condition}.Trials;
		trials = LoadTrials(Subjects{iSubj}, num2str(Condition), CurBand, TimeRange);
		SubjBootstr{iSubj}.Trials = trials.data;

		% R = sim.GridLocLR;
		% Ctx = sim.Ctx;
		% [BootsIND, maxes] = bootstrap(Trials, sim.GLR, 100);
		[SubjBootstr{iSubj}.BootsIND, SubjBootstr{iSubj}.maxes] = ...
		 bootstrap(SubjBootstr{iSubj}.Trials, SubjBootstr{iSubj}.G, 100, Rnk, threshold, CTpart, bInducedOnly);

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
		strCurBand1 = num2str(CurBand(1));
		strCurBand2 = num2str(CurBand(2));
		base_dir = '~/ps/Data/';
		folder_name = [base_dir, Subjects{iSubj}, '/', ...
					   Subjects{iSubj}, '_', ...
					   CTpart, IndStr, ...
					   'cond_', num2str(Condition), '_', ...
					   num2str(TimeRange(1)), '_', num2str(TimeRange(2)), '_s_', 'thresh_', num2str(threshold),];

		if ~exist(folder_name, 'file')
			mkdir(folder_name);
		end
		save_fname = [folder_name, '/SubjBootstr_',...
		              strCurBand1,'_', strCurBand2, '_', ...
		              Subjects{iSubj}, '_', CTpart,'_', ...
		              num2str(Rnk), ...
		              '_cond_', num2str(Condition), '.mat'];

		curSubj = SubjBootstr{iSubj};
		save(save_fname, 'curSubj', '-v7.3');
		CurBand = CurBand + 1;
		% -------------------------------- %
	end

end
% figure;

% hctx  = trisurf(Ctx.Faces,Ctx.Vertices(:,1),Ctx.Vertices(:,2),Ctx.Vertices(:,3),'FaceColor',[0.1,0.51,1], 'EdgeColor','none','FaceAlpha', 0.1);
% hold on;
% drawset(IND, R, 'm');

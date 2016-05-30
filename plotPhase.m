CT = CrossSpectralTimeseries(curSubj.Trials, true);
C = reshape((CT(:,80)), nSensors, nSensors); % need this to find dipoles orientation
	C = ProjectAwayFromPowerComplete(C, curSubj.G, 350);
	clear Trials_proj_i 
	clear Trials_proj_j 
	clear Tr_i 
	clear Tr_j
	clear Tr_i_phase
	clear Tr_j_phase
	t = [subj_name, ', ', CTpart,', ', induced_str ', cond ', Cond_str,', ', num2str(band(1)), '-', num2str(band(2)), 'Hz'];

	figure('Name', t, 'NumberTitle', 'off')
	topos = {};

	linewidth = 1;
	Markersize = 40;
	orange = [255 141 0] / 256;
	
	nSensors = sqrt(size(CT, 1));
	
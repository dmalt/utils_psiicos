function ERP = CalcERP(trials)
% Compute event-related potential
	ERP = mean(trials, 3);

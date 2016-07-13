%% CalcERP: function description
function ERP = CalcERP(trials)
	ERP = mean(trials, 3);

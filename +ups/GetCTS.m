function CT = GetCTS(subjID, condition, freqBand, timeRange, GainSVDTh, protocolPath, isInducedOnly, isUseCache)
% -------------------------------------------------------
% Get cross-spectrum timeseries using caching function.
% -------------------------------------------------------
% FORMAT:
%   CT = GetCTS(subjID, condition, freqBand, timeRange, GainSVDTh, protocolPath, isInducedOnly)
% INPUTS:
%   inputs        -
% OUTPUTS:
%   outputs
% ________________________________________
% Dmitrii Altukhov, dm.altukhov@ya.ru

	import ups.CrossSpectralTimeseries
	import ups.LoadTrials

	if nargin < 8
		isUseCache = true;
	end

	if nargin < 7
		isInducedOnly = false;
	end
	if nargin < 6 
		protocolPath = '/home/dmalt/PSIICOS_osadtchii';
	end
	if nargin < 5
		GainSVDTh = 0.01;
	end

	fname = mfilename('fullpath');
	mpath = fileparts(fname);
	cache_fold =  [mpath, '/../CT_cache'];
	if ~exist(cache_fold, 'dir')
	    mkdir(cache_fold);
	end
	cache_fname = ...
	[
	   'sid_',    num2str(subjID),...
	   '_cond_',  condition,...
	   '_fb_',    num2str(freqBand(1)), num2str(freqBand(2)),...
	   '_tr_',    num2str(timeRange(1)), num2str(timeRange(2)),...
	   '_gsvd_',  num2str(GainSVDTh),...
	   '_isind_',  num2str(isInducedOnly)
	];
   
	cache_fname = [cache_fold, '/', cache_fname, '.mat'];

	if exist(cache_fname, 'file') && isUseCache
        load(cache_fname);
    else
		trials = LoadTrials(subjID, condition, freqBand, timeRange, GainSVDTh, protocolPath);
		CT  = CrossSpectralTimeseries(trials.data, isInducedOnly);
		save(cache_fname, 'CT', '-v7.3');
	end
end
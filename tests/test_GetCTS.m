classdef test_GetCTS < matlab.unittest.TestCase
	properties
		subjID = '0019_shev'
		condition = '2'
		freqBand = [18,22];
		timeRange = [0, 0.7];
		GainSVDTh = 0.01;
		protocolPath = '~/PSIICOS_osadtchii'
		isInducedOnly = false;
		sFreq = 500;
		CT
	end

	methods(TestMethodSetup)
		function run_GetCTS(obj)
			obj.CT = ups.GetCTS(obj.subjID, obj.condition,...
									obj.freqBand, obj.timeRange,...
								obj.GainSVDTh, obj.protocolPath,...
								obj.isInducedOnly);
		end
	end

	methods(Test)
		function test_saves_cache(obj)
			cache_fname = ...
			[
			   'sid_',    num2str(obj.subjID),...
			   '_cond_',  obj.condition,...
			   '_fb_',    num2str(obj.freqBand(1)), num2str(obj.freqBand(2)),...
			   '_tr_',    num2str(obj.timeRange(1)), num2str(obj.timeRange(2)),...
			   '_gsvd_',  num2str(obj.GainSVDTh),...
			   '_isind_',  num2str(obj.isInducedOnly)
			];

            this_test_fname = mfilename('fullpath');
            tests_path = fileparts(this_test_fname);
            cache_fold =  [tests_path, '/../CT_cache'];
            cache_fname = [cache_fold, '/', cache_fname, '.mat'];
            obj.assertTrue(boolean(exist(cache_fname, 'file')), ...
            					   ['No cache_file ', cache_fname]);
		end

		% function test_out_size_is_valid(obj)
		% end
	end
end
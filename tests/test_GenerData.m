classdef test_GenerData < matlab.unittest.TestCase
	properties
		HM
		Cp
		trials
		phaseLag = pi / 20;
		GainSVDTh = 0.05; % results into 38 components
		inducedScale = 0.35;
		evokedScale = 0;
		nTr = 2;
		Ctx;
		isUseCache = false;
	end

	methods(TestMethodSetup)
		function run_GenerData(obj)
			[obj.HM, obj.Cp, obj.trials, obj.Ctx] = ...
			 GenerData(obj.phaseLag, obj.nTr, obj.GainSVDTh, obj.inducedScale, obj.evokedScale, obj.isUseCache);
		end
	end

	methods(Test)
		function test_number_of_outputs(obj) 
			obj.assertNotEmpty(obj.HM)
			obj.assertNotEmpty(obj.Cp)
			obj.assertNotEmpty(obj.trials)
			obj.assertNotEmpty(obj.Ctx)
		end

		% function test_accepts_GainSVDTh_as_arg(obj)
		% 	nCh = size(obj.HM.gain, 1);
		% 	obj.assertLessThan(nCh, 50)
		% end

		function test_saves_cache(obj)
			cache_fname = ...
			[
			   'pl_',      num2str(obj.phaseLag),     ... 
			   '_ntr_',    num2str(obj.nTr)           ...
               '_gsvdth_', num2str(obj.GainSVDTh),    ...
               '_is_',     num2str(obj.inducedScale), ...
               '_es_',     num2str(obj.evokedScale)
            ];

            this_test_fname = mfilename('fullpath');
            tests_path = fileparts(this_test_fname);
            cache_fold =  [tests_path, '/../Simulations_cache'];
            cache_fname = [cache_fold, '/', cache_fname, '.mat'];
            obj.assertTrue(boolean(exist(cache_fname, 'file')), ...
            					   ['No cache_file ', cache_fname]);
		end


	end	
end
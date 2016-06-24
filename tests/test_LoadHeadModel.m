classdef test_LoadHeadModel < matlab.unittest.TestCase
	properties
		% subjID = '0019_shev'
		subjID = '0003_pran'
		condName = '2'
		HM
	end

	methods(TestMethodSetup)
		function run_LoadHeadModel(obj)
			obj.HM = LoadHeadModel(obj.subjID, 'raw');
		end
	end

	methods(Test)

		function test_loads_from_cond_folder(obj)
			cond_name = '2';
			HM = LoadHeadModel(obj.subjID, cond_name);
		end

		function test_returns_GridLoc(obj)
			obj.assertTrue(isfield(obj.HM, 'GridLoc'))
		end
		
		function test_returns_condName(obj)
			obj.assertTrue(isfield(obj.HM, 'condName'))
		end

		function test_gridLoc_has_proper_size(obj)
			[~, nSrc] = size(obj.HM.gain);
			nSrc = nSrc / 2; % have two topographies per loc. site
			obj.assertSize(obj.HM.GridLoc, [nSrc, 3]) 
		end

		function test_errors_when_subj_doesnt_exist(obj)
			obj.assertError(@()LoadHeadModel('nonexistentSubj', 'someCond'), 'LoadError:noSubj')
		end

		function test_errors_when_no_head_models(obj)
			subjID = '0019_shev';
			condName = 'raw'
			obj.assertError(@()LoadHeadModel(subjID, condName), 'LoadError:noFile')
		end
	end
end
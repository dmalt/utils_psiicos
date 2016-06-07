classdef test_LoadHeadModel < matlab.unittest.TestCase
	properties
		% subjID = '0019_shev'
		subjID = '0003_pran'
		HM
	end

	methods(TestMethodSetup)
		function run_LoadHeadModel(testCase)
			testCase.HM = LoadHeadModel(testCase.subjID, 'raw');
		end
	end

	methods(Test)

		function test_loads_from_cond_folder(testCase)
			cond_name = '2';
			HM = LoadHeadModel(testCase.subjID, cond_name);
		end

		function test_returns_GridLoc(testCase)
			testCase.assertTrue(isfield(testCase.HM, 'GridLoc'))
		end

		function test_gridLoc_has_proper_size(testCase)
			[~, nSrc] = size(testCase.HM.gain);
			nSrc = nSrc / 2; % have two topographies per loc. site
			testCase.assertSize(testCase.HM.GridLoc, [nSrc, 3]) 
		end

	end
end
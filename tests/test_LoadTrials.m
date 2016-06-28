classdef test_LoadTrials < matlab.unittest.TestCase
	% properties
	% 	protocolName = 'PSIICOS';
	% 	condition = '2';
	% 	subjID = '0003_pran';
	% 	freqBand = [19,23];
	% 	timeRange = [0.4, 0.7];
	% 	protocolPath = '~/PSIICOS_osadtchii';
	% 	protocolName = 'PSIICOS';
	% end
	methods(Test)
		% function test_LoadTrials_fails_if_condition_not_string(testCase)
			% NEED TO LEARN HOW TO TEST FOR FAILURE
			% condition = 1;
			% subjID = '0003_pran';
			% freqBand = [19,23];
			% timeRange = [0.4, 0.7];
			% protocolPath = '~/PSIICOS_osadtchii';
			% testCase.assertFail(LoadTrials(subjID, condition, freqBand, timeRange, protocolPath))
		% end

		function test_it_runs(testCase)
			protocolName = 'PSIICOS';
			condition = '2';
			subjID = '0003_pran';
			freqBand = [19,23];
			timeRange = [0.4, 0.7];
			protocolPath = '~/PSIICOS_osadtchii';
			protocolName = 'PSIICOS';
			GainSVDTh = 0.01;
			LoadTrials(subjID, condition, freqBand, timeRange, GainSVDTh, protocolPath)
		end
	end
end
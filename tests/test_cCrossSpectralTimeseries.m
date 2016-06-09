classdef test_cCrossSpectralTimeseries < matlab.unittest.TestCase
	properties
		testTrials
		isInducedOnly
		nTimes
		nChannels
		nTrials
		c_CT
		key
	end

	methods(TestMethodSetup)
		function makeTestTrials(testCase)
			testCase.nTimes = 100;
			testCase.nChannels = 10;
			testCase.nTrials = 20;
			trials.data = rand(testCase.nChannels, testCase.nTimes, testCase.nTrials);
			trials.subjID = '0000_test';
			trials.sFreq = '100';
			trials.freqBand = [10 12];
			trials.timeRange = [0.4, 0.7];
			testCase.testTrials = trials;
			[testCase.c_CT, testCase.key] = cCrossSpectralTimeseries(testCase.testTrials, testCase.isInducedOnly);
			testCase.isInducedOnly = false;
		end
	end

	methods(Test)
		function test_CT_is_proper_struct(testCase)
			testCase.assertTrue(isfield(testCase.c_CT, 'subjID'), 'No subjID field')
			testCase.assertTrue(isfield(testCase.c_CT, 'data'), 'No data field')
			testCase.assertTrue(isfield(testCase.c_CT, 'sFreq'), 'No sFreq field')
			testCase.assertTrue(isfield(testCase.c_CT, 'freqBand'), 'No freqBand field')
			testCase.assertTrue(isfield(testCase.c_CT, 'timeRange'), 'No timeRange field')
		end

		function test_cCT_inherits_fields_from_trials(testCase)
			testCase.assertEqual(testCase.c_CT.subjID, testCase.testTrials.subjID, 'subjID fields differ')
			testCase.assertEqual(testCase.c_CT.sFreq, testCase.testTrials.sFreq, 'sFreq fields differ')
			testCase.assertEqual(testCase.c_CT.freqBand, testCase.testTrials.freqBand, 'freqBand fields differ')
			testCase.assertEqual(testCase.c_CT.timeRange, testCase.testTrials.timeRange, 'timeRange fields differ')
		end
	end
end
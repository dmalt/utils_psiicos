classdef testCrossSpectralTimeseries < matlab.unittest.TestCase
	properties
		testTrials
		isInducedOnly
		nTimes
		nChannels
		nTrials
		CT
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
			[testCase.CT, testCase.key] = CrossSpectralTimeseries(testCase.testTrials, testCase.isInducedOnly);
			testCase.isInducedOnly = false;
		end
	end

	methods(Test)
		function test_CT_size(testCase)
			testCase.assertSize(testCase.CT.data,...
								[testCase.nChannels ^ 2, testCase.nTimes]);
		end

		function test_CT_is_complex(testCase)
			testCase.assertFalse(isreal(testCase.CT.data))
		end

		function test_CT_is_proper_struct(testCase)
			testCase.assertTrue(isfield(testCase.CT, 'subjID'), 'No subjID field')
			testCase.assertTrue(isfield(testCase.CT, 'data'), 'No data field')
			testCase.assertTrue(isfield(testCase.CT, 'sFreq'), 'No sFreq field')
			testCase.assertTrue(isfield(testCase.CT, 'freqBand'), 'No freqBand field')
			testCase.assertTrue(isfield(testCase.CT, 'timeRange'), 'No timeRange field')
		end

		function test_CT_time_slices_are_symmetrical(testCase)

			for iTime = 1:testCase.nTimes
				Cp_vec = testCase.CT.data(:,iTime);
				Cp = reshape(Cp_vec, testCase.nChannels, testCase.nChannels);
				testCase.assertEqual(Cp, Cp')
			end
		end

		function test_CT_inherits_fields_from_trials(testCase)
			testCase.assertEqual(testCase.CT.subjID, testCase.testTrials.subjID, 'subjID fields differ')
			testCase.assertEqual(testCase.CT.sFreq, testCase.testTrials.sFreq, 'sFreq fields differ')
			testCase.assertEqual(testCase.CT.freqBand, testCase.testTrials.freqBand, 'freqBand fields differ')
			testCase.assertEqual(testCase.CT.timeRange, testCase.testTrials.timeRange, 'timeRange fields differ')
		end
	end
end
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
			trials= rand(testCase.nChannels, testCase.nTimes, testCase.nTrials);
			testCase.testTrials = trials;
			[testCase.CT, testCase.key] = CrossSpectralTimeseries(testCase.testTrials, testCase.isInducedOnly);
			testCase.isInducedOnly = false;
		end
	end

	methods(Test)
		function test_CT_size(testCase)
			testCase.assertSize(testCase.CT,...
								[testCase.nChannels ^ 2, testCase.nTimes]);
		end

		function test_CT_is_complex(testCase)
			testCase.assertFalse(isreal(testCase.CT))
		end

		function test_CT_time_slices_are_symmetrical(testCase)
			for iTime = 1:testCase.nTimes
				Cp_vec = testCase.CT(:,iTime);
				Cp = reshape(Cp_vec, testCase.nChannels, testCase.nChannels);
				testCase.assertEqual(Cp, Cp')
			end
		end
	end
end
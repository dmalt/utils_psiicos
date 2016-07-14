classdef test_ConnSimMetrics < matlab.unittest.TestCase
	properties
	end

	methods(TestMethodSetup)
	end

	methods(Test)
		function test_returns_positive_vals(obj)
			sensors_file = '/home/dmalt/ups/channel_vectorview306.mat';
			ChUsed = PickChannels('grad');
			ChLoc = ReadChannelLocations(sensors_file, ChUsed);

			conInds =  cell(1,10);
			for iSubj = 1:length(conInds)
				conInds{iSubj} = randi(204,20,2);
			end
			[m,s] = ConnSimMetrics(conInds, ChLoc);
			obj.assertGreaterThan(m,0);
			obj.assertGreaterThan(s,0)
		end
	end
end
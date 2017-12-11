classdef test_ConnSimMetrics < matlab.unittest.TestCase
    properties
    end

    methods(TestMethodSetup)
    end

    methods(Test)
        function test_returns_positive_vals(obj)
            % sensors_file = 'channel_vectorview306.mat';
            sensors_file = '../test_data/channel_ctf_acc1.mat';
            % ChUsed = ups.PickElectaChannels('grad');
            ch = load(sensors_file);
            ChUsed = ups.bst.PickChannels(ch.Channel, 'MEG');
            ChLoc = ups.ReadChannelLocations(sensors_file, ChUsed);

            conInds =  cell(1,10);
            for iSubj = 1:length(conInds)
                conInds{iSubj} = randi(length(ChLoc),20,2);
            end
            [m,s] = ups.conn.ConnSimMetrics(conInds, ChLoc);
            obj.assertGreaterThan(m,0);
            obj.assertGreaterThan(s,0)
        end
    end
end

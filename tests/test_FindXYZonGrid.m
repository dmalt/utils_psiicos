classdef test_FindXYZonGrid < matlab.unittest.TestCase
    properties
    end

    methods(TestMethodSetup)
    end

    methods(Test)
        function test_errors_when_bad_GridLoc_size(obj) 
            sensors_file = '../test_data/channel_ctf_acc1.mat';
            ch = load(sensors_file);
            ChUsed = ups.bst.PickChannels(ch.Channel, 'MEG');
            ChLoc = ups.ReadChannelLocations(sensors_file, ChUsed);

            left_motor_xyz = [0.02, 0.12, 0.1];
            left_motor_ind = ups.FindXYZonGrid(left_motor_xyz, ChLoc');
            obj.assertError(@()ups.FindXYZonGrid('left_motor_xyz', 'ChLoc'), 'SizeError:GridLoc')
        end
    end
end

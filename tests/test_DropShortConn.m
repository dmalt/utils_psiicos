classdef test_DropShortConn < matlab.unittest.TestCase
    properties
        ChLoc
        min_length = 0.05;
        n_conn = 200
        ChUsed
        conInds
    end

    methods(TestMethodSetup)
        function setup_ChLoc(obj)
            sensors_file = '../test_data/channel_ctf_acc1.mat';
            % ChUsed = ups.PickElectaChannels('grad');
            ch = load(sensors_file);
            obj.ChUsed = ups.bst.PickChannels(ch.Channel, 'MEG');
            obj.ChLoc = ups.ReadChannelLocations(sensors_file, obj.ChUsed);
        end

        function setup_conInds(obj)
            obj.conInds = randi(length(obj.ChUsed), obj.n_conn, 2);
        end
    end

    methods(Test)
        function test_returns_Nx2_matrix(obj)
            conInds_long = ups.DropShortConn(obj.conInds, obj.ChLoc, obj.min_length);
            [~, S] = size(conInds_long);
            obj.assertEqual(S,2)
        end

        function returns_defined_num_of_connections(obj)
            n_conn = 20;
            conInds_long = ups.DropShortConn(obj.conInds, obj.ChLoc, obj.min_length, n_conn);
            obj.assertSize(conInds_long, [n_conn,2])
        end

        function test_errors_when_subj_doesnt_exist(obj)
            n_conn = obj.n_conn;
            obj.assertError(@()ups.DropShortConn(obj.conInds, obj.ChLoc, obj.min_length, n_conn), 'PS_UTILS:SizeError')
        end 
    end
end

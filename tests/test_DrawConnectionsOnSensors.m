classdef test_DrawConnectionsOnSensors < matlab.unittest.TestCase
    properties
        channels_path = '../test_data/channel_ctf_acc1.mat'
    end
    methods(TestMethodTeardown)
        function CloseFigs(obj)
            % close all;
        end
    end
    methods(Test)
        function test_returns_valid_handles(obj)
            % class(obj.channels_path)
            ch = load(obj.channels_path);
            ChUsed = ups.bst.PickChannels(ch.Channel, 'MEG');
            conInds = randi(length(ChUsed), 10, 2);
            fig_handle = figure;
            axes_handle = ups.plt.DrawConnectionsOnSensors(conInds, obj.channels_path, true);
            obj.assertTrue(isa((fig_handle), 'matlab.ui.Figure'))
            obj.assertTrue(isa((axes_handle), 'matlab.graphics.axis.Axes'))
            set(fig_handle,'name','TestFigure','numbertitle','off')
            title(axes_handle, 'My awesome title')
            view(axes_handle, [0,90])
            close;
        end
    end

end

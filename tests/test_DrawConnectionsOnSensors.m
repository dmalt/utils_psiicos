classdef test_DrawConnectionsOnSensors < matlab.unittest.TestCase
	properties
		channels_path = 'channel_vectorview306.mat'
	end
	methods(TestMethodTeardown)
		function CloseFigs(obj)
			% close all;
		end
	end
	methods(Test)
		function test_returns_valid_handles(obj)
			% class(obj.channels_path)
			conInds = randi(204, 10, 2);
			fig_handle = figure;
			axes_handle = DrawConnectionsOnSensors(conInds, obj.channels_path, true);
			obj.assertTrue(strcmp(class(fig_handle), 'matlab.ui.Figure'))
			obj.assertTrue(strcmp(class(axes_handle), 'matlab.graphics.axis.Axes'))
			set(fig_handle,'name','TestFigure','numbertitle','off')
			title(axes_handle, 'My awesome title')
			view(axes_handle, [0,90])
		end
	end

end

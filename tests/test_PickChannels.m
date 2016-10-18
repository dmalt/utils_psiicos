classdef test_PickChannels < matlab.unittest.TestCase
	methods(Test)
		function test_output_size(obj)
			import ups.PickChannels
			
			gradiometers = PickChannels('grad');
			magnetometers = PickChannels('mag');
			meg_channels = PickChannels('meg');
			nGrad = 204;
			nMag = 102;
			nMeg = 306;
			obj.assertSize(gradiometers, [1,nGrad], 'Gradiometers size is bad')
			obj.assertSize(magnetometers, [1,nMag], 'Magnetometers size is bad')
			obj.assertSize(meg_channels, [1,nMeg], 'meg_channels size is bad')
		end
	end
end
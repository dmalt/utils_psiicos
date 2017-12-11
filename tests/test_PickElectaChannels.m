classdef test_PickElectaChannels < matlab.unittest.TestCase
    methods(Test)
        function test_output_size(obj)
            import ups.PickElectaChannels
            
            gradiometers = PickElectaChannels('grad');
            magnetometers = PickElectaChannels('mag');
            meg_channels = PickElectaChannels('meg');
            nGrad = 204;
            nMag = 102;
            nMeg = 306;
            obj.assertSize(gradiometers, [1,nGrad], 'Gradiometers size is bad')
            obj.assertSize(magnetometers, [1,nMag], 'Magnetometers size is bad')
            obj.assertSize(meg_channels, [1,nMeg], 'meg_channels size is bad')
        end
    end
end

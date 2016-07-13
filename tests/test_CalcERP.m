classdef test_CalcERP < matlab.unittest.TestCase
	properties
	end

	methods(TestMethodSetup)
	end

	methods(Test)
		function test_output_size(obj) 
			trials = rand(43,350,120);
			out = CalcERP(trials);
			obj.assertSize(out, [43,350])
		end
	end
end
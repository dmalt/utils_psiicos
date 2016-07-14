classdef test_Cp2Coh < matlab.unittest.TestCase
	properties
		CohTS
		nSen = 40
		nTimes = 10
	end

	methods(TestMethodSetup)
		function run_method(obj)
			CT = GetFakeCT(obj.nSen, obj.nTimes);
			obj.CohTS = Cp2Coh(CT);
		end
	end

	methods(Test)
		function test_output_has_same_size(obj) 
			obj.assertSize(obj.CohTS, [obj.nSen ^ 2, obj.nTimes])
		end

		function test_output_has_ones_on_diagonal(obj)
			D = zeros(obj.nSen, obj.nTimes);
			I = complex(ones(obj.nSen, obj.nTimes));
			for iTime = 1:obj.nTimes
				Coh = reshape(obj.CohTS(:, iTime), obj.nSen, obj.nSen);
				D(:, iTime) = diag(Coh);
			end
			obj.assertEqual(D,I, 'AbsTol', 1e-10)
		end
	end
end
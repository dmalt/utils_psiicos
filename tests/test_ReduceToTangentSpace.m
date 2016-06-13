classdef test_ReduceToTangentSpace < matlab.unittest.TestCase
	properties
		Gain = rand(100, 600);
		ChUsed = 'grad';
	end
	methods(Test)
		function test_Gain_normalized_is_a_normalized_Gain(obj)
			chSelect = 'all';
			[G_norm, G] = ReduceToTangentSpace(obj.Gain, chSelect);
			G = G * diag((1 ./ sqrt(sum(G .^ 2, 1))));
			obj.assertEqual(G_norm, G, 'AbsTol', 1e-12)
		end
	end
end
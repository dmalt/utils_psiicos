classdef test_ReduceToTangentSpace < matlab.unittest.TestCase
    properties
        Gain = rand(100, 600);
    end
    methods(Test)
        function test_Gain_normalized_is_a_normalized_Gain(obj)
            [G_norm, G] = ups.ReduceToTangentSpace(obj.Gain);
            G = G * diag((1 ./ sqrt(sum(G .^ 2, 1))));
            obj.assertEqual(G_norm, G, 'AbsTol', 1e-12)
        end
    end
end

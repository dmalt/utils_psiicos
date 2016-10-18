classdef test_GetColors < matlab.unittest.TestCase
	methods(Test)
		function test_returns_valid_struct(obj)
			colors = ups.GetColors();
			obj.assertTrue(isstruct(colors))
			obj.assertTrue(isfield(colors, 'RGB'), 'No "RGB" field')
			obj.assertTrue(isfield(colors, 'name'), 'No "name" field')
		end

		function test_rgb_codes_valid(obj)
			colors = ups.GetColors();
			rgb = {colors.RGB};
			for i = 1:length(rgb)
				obj.assertSize(rgb{i}, [1,3])
				for j = 1:3
					obj.assertLessThan(rgb{i}(j), 1)
				end
			end
		end
	end
end
classdef test_GetCtx < matlab.unittest.TestCase
	properties
		CtxHR
		Ctx
	end
	methods(TestMethodSetup)
		function run_GetCtx(obj)
			subjID = '0019_shev';
			[obj.Ctx, obj.CtxHR] = ups.GetCtx(subjID);
		end
	end
	methods(Test)
		function test_returns_structures(obj)
			obj.assertTrue(isstruct(obj.Ctx), 'Ctx is not a structure')
			obj.assertTrue(isstruct(obj.CtxHR), 'CtxHR is not a structure')
		end
		function test_Ctx_has_Faces_field(obj)
			obj.assertTrue(isfield(obj.Ctx, 'Faces'), 'Ctx')
			obj.assertTrue(isfield(obj.CtxHR, 'Faces'), 'CtxHR')
		end
	end
end
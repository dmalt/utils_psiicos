classdef test_Connections < matlab.unittest.TestCase
	properties
		ConnInst
	end
	methods(TestMethodSetup)
		function create_connections_inst(obj)
			subjID = '0019_shev';
			IND = [1,2];
			CurBand = [19,23];
			TimeRange = [0,0.7];
			CT = rand(43 ^ 2, 151);
			condName = '2';
			[~, CtxHR] = GetCtx(subjID);
			HM = LoadHeadModel(subjID, '2');
			obj.ConnInst = Connections('test', IND, CurBand, TimeRange, CT, condName, HM, CtxHR);
		end
	end
	methods(Test)
		% function test_connections_PlotCon_works(obj)
		% 	obj.ConnInst.PlotCon();
		% end
	end
end
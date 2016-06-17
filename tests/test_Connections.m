classdef test_Connections < matlab.unittest.TestCase
	properties
		ConnInst
		subjID = '0019_shev';
		CurBand = [19,23];
		TimeRange = [0,0.7];
		CT = rand(43 ^ 2, 151) + 1i * rand(43 ^ 2, 151);
		condName = '2';
		CtxHR;
		HM;
	end
	methods(TestMethodSetup)
		function create_connections_inst(obj)
			[~, obj.CtxHR] = GetCtx(obj.subjID);
			obj.HM = LoadHeadModel(obj.subjID, '2');
		end
	end

	methods(TestMethodTeardown, Static)
		function CloseFigs()
			close all;
		end
	end
	methods(Test)
		% function test_connections_Plot_works(obj)
		% 	obj.ConnInst.Plot();
		% end
		function test_init_with_cell_array(obj)
		% Test initialization with cell array 
		% of connection indices. 
			IND{1} = [1,2];
			IND{2}  = [3, 4; 5, 6];
			obj.ConnInst = Connections('test', IND, obj.CurBand, obj.TimeRange, obj.CT, obj.condName, obj.HM, obj.CtxHR);
			obj.ConnInst.Plot()
		end

		function test_init_with_set_of_pairs(obj)
		% Test initialization with cell array 
		% of connection indices. 
			IND = [1,2; 3, 4; 5, 6];
			obj.ConnInst = Connections('test', IND, obj.CurBand, obj.TimeRange, obj.CT, obj.condName, obj.HM, obj.CtxHR);
			obj.ConnInst.Plot()
		end

		function test_Plot_works_for_big_number_of_clusters(obj)
			nSrc = size(obj.HM.GridLoc, 1);
			IND = cell(20,1);

			for i = 1:20;
				IND{i} = randi(nSrc, 3, 2);
			end

			obj.ConnInst = Connections('test', IND, obj.CurBand, obj.TimeRange, obj.CT, obj.condName, obj.HM, obj.CtxHR);
			obj.ConnInst.Plot()
		end

		function test_PairwiseClustering_and_Average(obj)
			nSrc = size(obj.HM.GridLoc, 1);
			ncon = 1100;
			IND = randi(nSrc, ncon, 2);
			dPair = 0.02;
			clustSize = 10;			
			obj.ConnInst = Connections('test', IND, obj.CurBand, obj.TimeRange, obj.CT, obj.condName, obj.HM, obj.CtxHR);
			obj.ConnInst = obj.ConnInst.Clusterize(clustSize, dPair);
			obj.ConnInst.Plot()
			obj.assertGreaterThan(length(obj.ConnInst.conInds), 1) 

			obj.ConnInst = obj.ConnInst.Average();
			for iSet = 1:length(obj.ConnInst.conInds)
				obj.assertSize(obj.ConnInst.conInds{iSet}, [1,2])
			end
			obj.ConnInst.Plot(0.2);
		end

		function test_merging(obj)
			nSrc = size(obj.HM.GridLoc, 1);
			IND = cell(20,1);

			for i = 1:20;
				IND{i} = randi(nSrc, 3, 2);
			end
			obj.ConnInst = Connections('test', IND, obj.CurBand, obj.TimeRange, obj.CT, obj.condName, obj.HM, obj.CtxHR);
			obj.ConnInst = obj.ConnInst.Merge();
			obj.assertEqual(length(obj.ConnInst.conInds), 1) 
		end

	end
end
classdef test_GetSensorConnectivity < matlab.unittest.TestCase
	properties
		nSen = 204;
		nTimes = 10;
		CT
		conInds
		nOutputRows
		nOutputCols
		threshold = 2;
	end

	methods(TestMethodSetup)
		function setup(obj)
			obj.CT = ups.GetFakeCT(obj.nSen, obj.nTimes);
			obj.conInds = ups.GetSensorConnectivity(obj.CT, obj.threshold);
			[obj.nOutputRows, obj.nOutputCols] = size(obj.conInds);
		end
	end

	methods(Test)
		function test_output_has_2_columns(obj)
			obj.assertEqual(obj.nOutputCols, 2);
		end

		function test_output_val_less_than_nSen(obj)
			for iRow = 1:obj.nOutputRows
				obj.assertLessThanOrEqual(obj.conInds(iRow,1), obj.nSen,...
										 ['Bad for row ', num2str(iRow)]);
				obj.assertLessThanOrEqual(obj.conInds(iRow,2), obj.nSen,...
										 ['Bad for row ', num2str(iRow)]);
			end
		end 

		function test_conInds_are_integers(obj)
			for iRow = 1:obj.nOutputRows
				indRow = obj.conInds(iRow,:);
				obj.assertTrue( indRow(1) == floor(indRow(1)))
				obj.assertTrue( indRow(2) == floor(indRow(2)))
			end
		end

		function test_max_of_abs_CT_in_output(obj)
			abs_av_CT = abs(sum(obj.CT, 2));
			abs_av_CT = reshape(abs_av_CT, obj.nSen, obj.nSen);
			abs_av_CT = abs_av_CT - diag(diag(abs_av_CT));
			abs_av_CT = abs_av_CT(:);
			[~, m_ind] = max(abs_av_CT);
			m_ij = ups.indVec2mat(m_ind, obj.nSen);
			con1 = m_ij;
			con2 = [m_ij(2), m_ij(1)];
			isMaxInConInds = ismember(con1, obj.conInds, 'rows') || ...
							 ismember(con2, obj.conInds, 'rows');

			obj.assertTrue(isMaxInConInds, [num2str(m_ij), num2str(obj.conInds(1,:))])
		end

		function test_returns_nondiag_inds(obj)
			nCon = size(obj.conInds,1);
			for iCon = 1:nCon
				obj.assertNotEqual(obj.conInds(iCon,1), obj.conInds(iCon,2))
			end
		end
	end
end
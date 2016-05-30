classdef (Abstract) sInits < handle & Inits
	properties(Constant)
		subj_name = '0003_pran'
		CtxHR = load('/home/dmalt/PSIICOS_osadtchii/anat/0003_pran/tess_cortex_concat.mat')
		Ctx = load('/home/dmalt/PSIICOS_osadtchii/anat/0003_pran/tess_cortex_concat_2000V.mat')
		ConData = GetTrials('0003_pran')
		
		HeadModel = GetHeadModel('0003_pran')
	end
	properties(Constant, Access = protected)
		ImportStr = '0003_pran.*'
	end
end
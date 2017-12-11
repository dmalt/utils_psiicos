classdef test_LoadHeadModel < matlab.unittest.TestCase
    properties
        % subjID = '0019_shev'
        subjID = 'test_subj'
        condName = 'raw'
        protocol_path = '../test_data';
        HM
    end

    methods(TestMethodSetup)
        function run_LoadHeadModel(obj)
            obj.HM = ups.bst.LoadHeadModel(obj.subjID, obj.condName, obj.protocol_path);
        end
    end

    methods(Test)

        function test_loads_from_cond_folder(obj)
            HM = ups.bst.LoadHeadModel(obj.subjID, obj.condName, obj.protocol_path);
        end

        function test_returns_GridLoc(obj)
            obj.assertTrue(isfield(obj.HM, 'GridLoc'))
        end
        
        function test_returns_condName(obj)
            obj.assertTrue(isfield(obj.HM, 'condName'))
        end

        function test_gridLoc_has_proper_size(obj)
            [~, nSrc] = size(obj.HM.gain);
            nSrc = nSrc / 2; % have two topographies per loc. site
            obj.assertSize(obj.HM.GridLoc, [nSrc, 3]) 
        end

        function test_errors_when_subj_doesnt_exist(obj)
            obj.assertError(@()ups.bst.LoadHeadModel('nonexistentSubj', 'someCond', 'fakePath'),...
                            'LoadError:noSubj')
        end

        function test_errors_when_no_head_models(obj)
            empty_cond = 'test_empty';
            obj.assertError(@()ups.bst.LoadHeadModel(obj.subjID, empty_cond, obj.protocol_path),...
                            'LoadError:noFile')
        end
    end
end

import  matlab.unittest.TestSuite
abs_fname = mfilename('fullpath');
cur_path = fileparts(wd);
run(TestSuite.fromFolder([cur_path, '/tests']));

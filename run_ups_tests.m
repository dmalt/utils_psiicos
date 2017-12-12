import  matlab.unittest.TestSuite
abs_fname = mfilename('fullpath');
cur_path = fileparts(abs_fname);
run(TestSuite.fromFolder([cur_path, '/tests']));

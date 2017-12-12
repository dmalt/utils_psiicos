# utils_psiicos

Collection of tools for matlab connectivity analyses and visualization

Getting Started
---------------

### Prerequisites

#### OS
Installation script works only on LINUX. The only thing it does is
adding utils_psiicos folder location to the MATLAB path. It can be easily done manually.

The rest is cross-platform

#### Packages
Some functions load data files from [brainstorm](http://neuroimage.usc.edu/brainstorm/) protocols.
No other packages are required

### Installing

In LINUX run in terminal:

```bash
git clone https://github.com/dmalt/utils_psiicos.git && cd utils_psiicos && ./install.sh && cd ..
```

In WINDOWS get the package by downloading .zip archive from github,
extract the files and add path to package folder from inside MATLAB.

To test the installation open matlab and run

```matlab
run_ups_tests
```

It will list the functions being tested and report if there were some  errors.

If the installation was succesful all the tests should pass.

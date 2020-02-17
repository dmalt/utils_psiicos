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

### Installation

#### Linux
Installation effectively takes 2 steps:
1. add utils_psiicos to MATLAB path
2. download testing and simulations data

Make sure you have cURL and run
(it will download ~170M of data for testing and simulations):

```bash
git clone https://github.com/dmalt/utils_psiicos.git && cd utils_psiicos && ./install.sh --sim-data --test-data && cd ..
```

If you don't have cURL or don't want to download the data right now, run

```bash
git clone https://github.com/dmalt/utils_psiicos.git && cd utils_psiicos && ./install.sh && cd ..
```

The data can be downloaded manually.
To enable simulation download the following and move into utils_psiicos folder
[GLowRes.mat](https://yadi.sk/d/xt_T5MPX3QYsXX)
[InputData4Simul.mat](https://yadi.sk/d/ifjPqQeX3QYsok)
[channel_vectorview306.mat](https://yadi.sk/d/SP-vT_wR3QYtAp)

For tests download the archive [test_data.tar](https://yadi.sk/d/E5KggBOE3QYwc7)
and unpack it into utils_psiicos


#### Windows
Get the package by downloading .zip archive from github,
extract the files and add path to package folder from inside MATLAB.

Testing and simulations data can be downloaded manually by the links above.

#### Testing the installation
To test the installation open matlab and run

```matlab
run_ups_tests
```

It will list the functions being tested and report if there were some errors.

If the installation was succesful all the tests should pass.

# README #

Cardiet et al., 4D Self-gated Cardiac Magnetic Resonance Imaging in mice including respiratory motion intervals: a method of data interpolation reducing acquisition time


### What is this repository for? ###
This repository includes code to download input data, reconstruct, analyze, and generate figures for a magnetic resonance cardiac sequence as published under "4D Self-gated Cardiac Magnetic Resonance Imaging in mice including respiratory motion intervals: a method of data interpolation reducing acquisition time" in NMR in Biomedicine.

Requirements:
-------------
* MATLAB  - for reconstruction, processing, and figure generation
* gpuNUFFT 2.0.8 - find more information at https://github.com/andyschwarzl/gpuNUFFT 
* BruKitchen - compile this file to run the sequence, find more information at https://github.com/tesch1/BruKitchen

Tested Configuration:
---------------------
* Mac OS X 10511.5 (El Capitan)
* MATLAB R2015a
* Python 2.7.13

Installation Options:
---------------------
* Click the `Download ZIP` button on the lower right hand side of the repository to download the code to your local machine
* OR clone the git repository to your local machine
* OR fork to your own repository and then clone the git repository to your local machine

Data:
------
* Mice datasets used in the paper are available here : https://data.mendeley.com/datasets/vhnvp57b6f/draft?a=e004f3c0-78a9-4d2a-8de3-ff90b32791a6

Usage:
------
* 1 - Download one or many dataset(s) and place them `Cardiet_4DCardiac/data_in`
* 2 - Go to `./code/` and run `UTE_3D_SG_reco.m`
* 3 - A first window will appear to choose the mouse you want to study (1 : Mouse 1, 2 : Mouse 2, ..)
* 4 - A second window will appear, to choose the reconstruction you want (Respiratory, Original Cardiac or Whole Cardiac)
* 5 - The corresponding images will be reconstructed, as different graphs explaining experiment parameters and interpolation steps
* 6 - Image matrix will be saved in the file `Cardiet_4DCardiac/data_out`

Folder Structure:
--------

`./code/` - (with downloaded contributors) contains all code necessary to reconstruct, process, and generate figures
`./data_in/` - the data input directory
`./data_out/` - the reconstruction and processing output directory

### License ###

See LICENSE

### Contributors ###

See contributors.txt



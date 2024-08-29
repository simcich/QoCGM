# QoCGM

QoCGM (Quantification of Continuous Glucose Monitoring) is a toolbox to analyse CGM glucose data. 

## Citing

If you are using QoCGM in your research, please cite it:  
```
No citation available yet
```

Link to the paper --> [here](https://doi.org/)

## Getting started

### Step 1: Install 

Installation of QoCGM can be performed by including the QoCGM folder in the MATLAB® *PATH*: 

1. Download the latest release from Github --> [here](https://github.com/simcich/QoCGM/releases);

2. Unzip the downloaded archive and move the folder to the desired location.;
3. Open MATLAB®;
4. To use the QoCGM functions in the current MATLAB® session (or within a specific script), add source folder and subfolders to the current MATLAB® *PATH* by executing in the command window 
```MATLAB
addpath(genpath('~/MATLAB/QoCGM/src'))
```
## Usage

Here is an example of how to use the `QoCGM` function:

```matlab
% Assuming 'cgmData' is a table with columns 'time' and 'cgmval'

% Input parameters:
% - cgmData: The CGM data table with datetime and glucose values.
% - sampling_f: Expected sampling frequency in minutes (e.g., 5 minutes).
% - sampling_variation: Acceptable variation in sampling intervals (e.g., 0.02 for 2%).
% - morning_start_h: Hour marking the start of the morning period (e.g., 6 for 6 AM).
% - convertToMgdL: Set to 1 to convert glucose values from mmol/L to mg/dL.
% - ploton: Set to 1 to enable plotting.

% Example usage:
metrics = QoCGM(cgmData, 5, 0.02, 6, 1, 1);

% This will process the 'cgmData' with an expected sampling frequency of 5 minutes,
% allowing for a 2% variation in sampling intervals, defining morning as starting at 6 AM,
% and converting glucose values from mmol/L to mg/dL.

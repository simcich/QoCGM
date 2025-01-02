%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example Script: CGM Data Processing with QoCGM for one file
%
% DESCRIPTION:
% This script demonstrates how to initialize parameters, load CGM data from a CSV file,
% and compute a set of glucose metrics using the `QoCGM` function. The script covers the
% basic steps required to prepare the input data, set the necessary parameters, and 
% extract the desired features from the Continuous Glucose Monitoring (CGM) data.
%
% SECTIONS:
% 1. Parameter Initialization
% 2. Data Loading
% 3. Feature Extraction
%
% USAGE:
% Simply run the script in MATLAB after ensuring that the required input data (CSV file)
% and the `QoCGM` function are available in your workspace or added to the MATLAB path.
%
% OUTPUT:
% The script outputs a structured array `features`, which contains the calculated CGM metrics.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Parameter Initialization
% Initialize the parameters required for CGM data processing.

samling_f = 5;                 % Sampling frequency in minutes.
                               % This indicates that CGM readings are expected every 5 minutes.
                               
sampling_variation = 0.05;      % Threshold for sampling variation in minutes.
                               % Acceptable deviation in sampling intervals from the expected 
                               % frequency, here set to allow a 5% (15 seconds) deviation.
                               
morning_start_h = 8;            % Hour at which the morning period starts, marking the end of night.
                               % Set to 8, which means the morning is considered to start at 8:00 AM.
                               
convertToMgdL = 0;              % Conversion flag for CGM measurements.
                               % Set to 1 to convert glucose values from mmol/L to mg/dL.
                               % Set to 0 if conversion is not required (i.e., data already in mg/dL).

ploton = 1;                    % plot flag, set to 1 for plotting

handleMissing = 'interpolate';  % 'interpolate' or 'remove' to handle missing data.

%% 2. Data Loading
% Load the CGM data from a CSV file into a table.

cgm = readtable(['C:\Users\Basis User\Desktop\QoCGM\matlab\data\cgmTest2.csv']);
% The CSV file is expected to contain at least two columns: 'time' (datetime format) 
% and 'cgmval' (glucose measurements in either mg/dL or mmol/L).


%% 3. Feature Extraction
% Compute the CGM metrics using the qCGM function and store them in the 'features' structure.

features = QoCGM(cgm, samling_f, sampling_variation, morning_start_h, convertToMgdL, ploton, handleMissing);
% The 'features' variable will now contain a structured array with various calculated metrics 
% relevant to glucose monitoring, based on the input parameters and data provided.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF SCRIPT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

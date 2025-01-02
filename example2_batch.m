%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script: Batch Processing of CGM Data from Multiple CSV Files
%
% DESCRIPTION:
% This script processes all `.csv` files in a given directory, computes CGM metrics
% for each file using the `QoCGM` function, and stores the results in a consolidated 
% table. Each row in the resulting table corresponds to the metrics calculated from 
% one file.
%
% INPUT:
% - Directory containing `.csv` files with CGM data.
%
% OUTPUT:
% - A MATLAB table containing the computed metrics for all files.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Parameter Initialization
% Initialize the parameters required for CGM data processing.

samling_f = 5;                 % Sampling frequency in minutes.
sampling_variation = 0.05;      % Threshold for sampling variation in minutes.
morning_start_h = 8;            % Hour at which the morning period starts, marking the end of night.
convertToMgdL = 0;              % Conversion flag for CGM measurements (1=convert mmol/L to mg/dL).
ploton = 0;                     % plotting flag (0= not plots)
handleMissing = 'interpolate';  % 'interpolate' or 'remove' to handle missing data.

%% 2. Directory and File Handling
% Specify the directory containing the CSV files.

dataDir = 'C:\Users\Basis User\Desktop\QoCGM\matlab\data\';  % Path to the directory containing the CSV files.
csvFiles = dir(fullfile(dataDir, '*.csv'));  % List of all CSV files in the directory.

% Initialize an empty table to store the results.
allMetrics = table();

%% 3. Process Each File
% Loop through each CSV file in the directory and calculate the metrics.

for i = 1:length(csvFiles)
    % Get the full path of the current file.
    filePath = fullfile(csvFiles(i).folder, csvFiles(i).name);
    
    % Load the CGM data from the current CSV file.
    cgm = readtable(filePath);
    
    % Compute the CGM metrics using the QoCGM function.
    metrics = QoCGM(cgm, samling_f, sampling_variation, morning_start_h, convertToMgdL, ploton, handleMissing);
    
    % Convert the structure 'metrics' to a table, if necessary.
    % Assuming 'metrics' is a structure with scalar fields, we convert it to a table row.
    metricsTable = struct2table(metrics, 'AsArray', true);
    
    % Add a column for the filename and place it as the first column.
    FileNameColumn = table({csvFiles(i).name}, 'VariableNames', {'FileName'});
    metricsTable = [FileNameColumn, metricsTable];  % Concatenate tables, with FileName first.
    
    % Append the results to the consolidated table.
    allMetrics = [allMetrics; metricsTable]; %#ok<AGROW>
end

%% 4. Save or Display the Results
% The 'allMetrics' table now contains the calculated metrics for all processed files.

% Display the table in the command window (optional).
disp(allMetrics);

% % Save the results to a .mat file (optional).
% save('CGM_metrics_results.mat', 'allMetrics');
% 
% % Save the results to a CSV file (optional).
% writetable(allMetrics, 'CGM_metrics_results.csv');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF SCRIPT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

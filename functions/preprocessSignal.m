function [cgm, interpTime, interpCgmVal, missingDataIdx, uniqueDays]= preprocessSignal(cgm, samling_f, sampling_variation)

% Remove duplicate entries based on the 'time' column
[~, uniqueIdx] = unique(cgm.time, 'stable'); % 'stable' keeps the first occurrence
cgm = cgm(uniqueIdx, :);

%% identify missing periods
% Define the expected sampling interval (5 minutes)
expectedInterval = minutes(samling_f);

minInterval = expectedInterval * (1 - sampling_variation);
maxInterval = expectedInterval * (1 + sampling_variation);

% Calculate the time differences between consecutive samples
timeDiff = diff(cgm.time);

% Identify indices where the time difference is outside the allowable range
missingDataIdx = find(timeDiff < minInterval | timeDiff > maxInterval);

% Generate a time vector with regular intervals for interpolation
interpTime = (cgm.time(1):expectedInterval:cgm.time(end))';

% Perform interpolation
interpCgmVal = interp1(cgm.time, cgm.cgmval, interpTime, 'pchip'); 

%% Unique days with cgm
% Extract the day part of the datetime values
dayPart = dateshift(cgm.time, 'start', 'day');
% Identify unique days
uniqueDays = unique(dayPart);


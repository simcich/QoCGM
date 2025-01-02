%%%%%%%%%%%%%%%%%%%%%
%completeness
% calculate the number of days monitored and completeness 
function [monitoringDays, completenessRate]=completeness(cgm, samling_f)


% Calculate the total time span in minutes
totalTime = minutes(max(cgm.time) - min(cgm.time));

% Calculate the expected number of samples
expectedSamples = floor(totalTime / samling_f) + 1;

% Get the actual number of samples
actualSamples = length(cgm.time);

% Calculate the completeness rate
completenessRate = round((actualSamples / expectedSamples) * 100,2);


% Extract the date part of the datetime array
dateOnlyArray = dateshift(cgm.time, 'start', 'day');

% Find the unique days
uniqueDays = unique(dateOnlyArray);

% Count the number of unique days
numUniqueDays = numel(uniqueDays);


monitoringDays = numUniqueDays;


end
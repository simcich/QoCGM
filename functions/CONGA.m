%%%%%%%%%%%%%%%%%%%%%
%CONGA calc
% Continuous overall net glycemic action is a measure of glycemic variability specifically developed
% for use on continuous glucose monitoring data. It is calculated as the standard deviation of the sum
% of the differences between a current observation and an observation n hours previously
function [conga]=CONGA(GluData, Hours, samplingFs)


    % Define the time window for CONGA calculation (e.g., 1 hour)
    timeWindow = hours(Hours); % Time window for CONGA
    samplingInterval = minutes(samplingFs); % Sampling interval
    
    % Convert time window to the number of samples
    numSamples = round(timeWindow / samplingInterval);
    
    % Initialize the array to store CONGA differences
    numPoints = height(GluData);
    congaDifferences = NaN(numPoints - numSamples, 1);
    
    % Calculate the differences for CONGA
    for i = 1:numPoints - numSamples
        % Calculate the difference between current value and value numSamples ago
        congaDifferences(i) = abs(GluData(i + numSamples) - GluData(i) );
    end
    
    
    Mean_conga = mean(congaDifferences);
    conga = sqrt(sum((Mean_conga - congaDifferences).^2)/length(congaDifferences) - 1);




end
%multiscaleEntropy
function mse = multiscaleEntropy(tmpCGMvalues, m, r, scales)
    % Parameters:
    % tmpCGMvalues - The CGM timeseries data
    % m - Embedding dimension
    % r - Tolerance (usually 0.1 to 0.25 of the standard deviation of the data)
    % scales - Number of scales

    % Initialize the MSE array
    mse = zeros(1, scales);
    
    % Loop over each scale
    for scale = 1:scales
        % Coarse-grain the time series
        coarse_grained_series = coarseGrain(tmpCGMvalues, scale);
        
        % Calculate sample entropy of the coarse-grained time series
        mse(scale) = sampleEntropy(coarse_grained_series, m, r);
    end
end
function coarse_grained_series = coarseGrain(data, scale)
    % Coarse-grain the data by averaging over non-overlapping windows of given scale
    len = length(data);
    num_coarse_grained_points = floor(len / scale);
    coarse_grained_series = zeros(1, num_coarse_grained_points);
    
    for i = 1:num_coarse_grained_points
        start_index = (i-1) * scale + 1;
        end_index = i * scale;
        coarse_grained_series(i) = mean(data(start_index:end_index));
    end
end
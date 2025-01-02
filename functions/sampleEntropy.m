function se = sampleEntropy(data, m, r)
    % Calculate the sample entropy of the data
    N = length(data);
    A = 0;  % Count of matches of length m+1
    B = 0;  % Count of matches of length m
    
    % Compute standard deviation of the data
    sd = std(data);
    
    % Compare data points
    for i = 1:N-m
        for j = i+1:N-m
            if max(abs(data(i:i+m-1) - data(j:j+m-1))) < r*sd
                B = B + 1;
                if abs(data(i+m) - data(j+m)) < r*sd
                    A = A + 1;
                end
            end
        end
    end
    
    % Calculate sample entropy
    if B == 0
        se = -log(1 / (N * (N - 1) / 2));
    else
        se = -log(A / B);
    end
end


function num_hypo_episodes = detect_hypo_episodes(time,cgmval,ploton)
    % Define hypoglycemic threshold and duration
    hypo_threshold = 70; % Hypoglycemia threshold in mg/dL
    hypo_duration = minutes(15); % Hypoglycemia duration in minutes

    % Find indices where CGM values are below the hypoglycemia threshold
    hypo_indices = cgmval < hypo_threshold;

    % Initialize variables to store hypoglycemic episodes
    num_hypo_episodes = 0;
    hypo_start = [];
    hypo_end = [];

    % Detect episodes of hypoglycemia
    i = 1;
    while i <= length(hypo_indices)
        if hypo_indices(i)
            % Hypo episode starts
            start_idx = i;
            while i <= length(hypo_indices) && hypo_indices(i)
                i = i + 1;
            end
            % Hypo episode ends
            end_idx = i - 1;

            % Check if the duration of hypo episode meets the minimum requirement
            if time(end_idx) - time(start_idx) >= hypo_duration
                num_hypo_episodes = num_hypo_episodes + 1;
                hypo_start = [hypo_start; time(start_idx)];
                hypo_end = [hypo_end; time(end_idx)];
            end
        end
        i = i + 1;
    end

    if ploton
        % Plot the CGM signal
        figure('Renderer', 'painters', 'Position', [50 50 900 400]);
        plot(time, cgmval, '-', 'LineWidth', 1, 'Color' , '#575555'); 
        hold on;
    
        % Highlight hypoglycemic episodes
        for j = 1:length(hypo_start)
            hypo_time_range = time >= hypo_start(j) & time <= hypo_end(j);
            plot(time(hypo_time_range), cgmval(hypo_time_range), '-', 'LineWidth', 2, 'Color' , '#d16464');
        end
    
        % Add labels and title to the plot
        xlabel('Time');
        ylabel('CGM Value (mg/dL)');
        title('CGM Signal with Hypoglycemic Episodes Highlighted');
        legend('CGM Signal', 'Hypoglycemic Episode');
        hold off;
    end
end
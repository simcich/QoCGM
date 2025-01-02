function  preprocessPlot(cgm, interpTime, interpCgmVal, missingDataIdx, uniqueDays)

%% Plot data
% Plot the CGM signal
figure('Renderer', 'painters', 'Position', [50 50 900 400]);
plot(cgm.time, cgm.cgmval, '-','Color' , '#575555' ,'LineWidth',1.3);
hold on;

% Plot the interpolated CGM signal
plot(interpTime, interpCgmVal, '--', 'DisplayName','Interpolated Data','LineWidth', 0.75,'Color' , '#73a2c6');


% Highlight missing data periods
for i = 1:length(missingDataIdx)
    % Start and end of the missing data period
    startTime = cgm.time(missingDataIdx(i));
    endTime = cgm.time(missingDataIdx(i) + 1);

    % Highlight the missing data period using a shaded area
    fill([startTime endTime endTime startTime], [min(cgm.cgmval) min(cgm.cgmval) max(cgm.cgmval) max(cgm.cgmval)], ...
        'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Light grey shaded area
end

% Highlight each day with vertical lines
for i = 1:length(uniqueDays)
    xline(uniqueDays(i), '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.75); % red dashed line
end

% Customize the plot
xlabel('Time');
ylabel('CGM Value (mg/dL)');
title('CGM Signal with Missing Periods');
legend('raw signal','interpolated signal','missing periods')
hold off;
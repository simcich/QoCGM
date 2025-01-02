%%%%%%%%%%%%%%%
% Fasting glucose proxy (FGxP)
%ref: https://academic.oup.com/ije/article/49/3/744/5735553?login=true
function [FGxP] = fastingProxy(interpCgmVal,interpTime, morning_start_h, uniqueDays, ploton)

    %% Night extract
    FGxP_arr = [];
    if ploton
        % Plot the CGM signal
        figure('Renderer', 'painters', 'Position', [50 50 900 400]);
        plot(interpTime, interpCgmVal, '-','Color' , '#575555' ,'LineWidth',1.3);
        hold on;
    end
    
    for i=1:size(uniqueDays,1)
    
        tmpIdx = (interpTime> uniqueDays(i) & interpTime< uniqueDays(i)+ (morning_start_h/24) );
        tmpTime = interpTime(tmpIdx);
        tmpCGM = interpCgmVal(tmpIdx);
        runCnt = 1;
    
        if  size(tmpTime,1)>0
            nightStart = tmpTime(1);
            nightEnd = tmpTime(end);

            [minVal idx] = min(tmpCGM);
            % Calculate absolute differences
            differences = abs(tmpTime - tmpTime(idx));
            
            % Sort differences and get indices of the 6 smallest
            [~, sortedIndices] = sort(differences);
            closestIndices = sortedIndices(1:6);
            
            if ploton
                plot(tmpTime(closestIndices), tmpCGM(closestIndices),'o','Color' , '#73a2c6' ,'MarkerFaceColor', '#73a2c6','MarkerSize',5)
            end

            FGxP_arr = [FGxP_arr; nanmean(tmpCGM(closestIndices))];


            %plot(tmpTime(idx), minVal,'o', 'Color', [0.5 0.5 0.5])
    
            
            if ploton
                % Highlight the night period using a shaded area
                fill([nightStart nightEnd nightEnd nightStart], [min(interpCgmVal) min(interpCgmVal) max(interpCgmVal) max(interpCgmVal)], ...
                    'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Light green shaded area
    
                plot(tmpTime, tmpCGM, 'b-','LineWidth', 1, 'Color', [0.5 0.5 0.5]);
    
                if runCnt==1
                    title('Fasting Approximation');
                    L= legend('signal','nadirs','night periods');
                    L.AutoUpdate = 'off';
                    xlabel('time')
                    ylabel('mg/dL')
    
                    runCnt=2;
                end
            end
        end


        FGxP = median(FGxP_arr); %function output


    end




end
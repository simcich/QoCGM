%%%%%%%%%%%%%%%
% SD of day 2 day
function [SD_d2d_mean SD_d2d_TIR] = d2d(interpCgmVal,interpTime,uniqueDays)

% DAY TO DAY VARIATION
arrD2D_mean = [];
arrD2D_TIR = [];
for i=1:size(uniqueDays,1)

    tmpIdx = (interpTime> uniqueDays(i) & interpTime< uniqueDays(i)+1 );
    tmpTime = interpTime(tmpIdx);
    tmpCGM = interpCgmVal(tmpIdx);

    arrD2D_mean = [arrD2D_mean;nanmean(tmpCGM)];
    arrD2D_TIR = [arrD2D_TIR; round(size(tmpCGM(tmpCGM>=70 & tmpCGM<=180),1)/size(tmpCGM,1)*100, 2)];
    

    %     figure
    %     plot(tmpTime,tmpCGM);


end

SD_d2d_mean = std(arrD2D_mean);
SD_d2d_TIR = std(arrD2D_TIR);


end

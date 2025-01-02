%%%%%%%%%%%%%%%%%%%%%%%%%%% QoCGM Function Documentation %%%%%%%%%%%%%%%%%%%%%%%%%%%
% QoCGM: Computes a set of quantitative metrics from Continuous Glucose Monitoring (CGM) data.
%
% DESCRIPTION:
% The QoCGM function processes a given CGM signal and returns a structured array containing 
% various calculated metrics. The input CGM data should include a time series of glucose 
% measurements. The function accounts for variations in sampling frequency, converts glucose 
% values if necessary, and delineates specific time periods (e.g., day/nigth).
%
% USAGE:
% metrics = QoCGM(cgm, sampling_f, sampling_variation, morning_start_h, convertToMgdL, ploton, handleMissing)
%
% INPUTS:
%   cgm                - A table with two columns: "time" and "cgmval".
%                        - "time": A datetime array representing the timestamps of CGM readings.
%                        - "cgmval": A numeric array containing CGM measurements. 
%                          Units can be either mg/dL or mmol/L, depending on the setting of 
%                          'convertToMgdL'. If values are in mmol/L,
%                          'convertToMgdL' needs to be set to 1
%
%   sampling_f         - A numeric value representing the expected sampling frequency in minutes.
%                        For example, if measurements are expected every 5 minutes, set this to 5.
%
%   sampling_variation - A numeric threshold (in minutes) that defines the acceptable variation in 
%                        sampling times. Measurements falling outside this threshold may be flagged 
%                        or corrected.
%
%   morning_start_h    - An integer (0-24) specifying the hour at which the 'morning' period begins, 
%                        marking the end of the 'night'. For instance, set to 6 for a 6 AM start.
%
%   convertToMgdL      - A binary flag (1 or 0) indicating whether to convert CGM values from 
%                        mmol/L to mg/dL. 
%                        - Set to 1 to convert from mmol/L to mg/dL.
%                        - Set to 0 if CGM values are already in mg/dL or conversion is not needed.
%
%    ploton = 1;          % plot flag, set to 1 for plotting
%
%    handleMissing     - 'interpolate' (default) or 'remove' to handle missing data.
%
% OUTPUT:
%   metrics            - A structured array containing the calculated metrics from the CGM data. 
%                        The structure fields will include various derived metrics relevant to 
%                        glucose monitoring.
%
% EXAMPLE:
%   % Assuming 'cgmData' is a table with columns 'time' and 'cgmval'
%   metrics = QoCGM(cgmData, 5, 0.02, 6, 1, 1, 'interpolate');
%
%   % This will process the 'cgmData' with an expected sampling frequency of 5 minutes, 
%   % allowing for a 2% variation in sampling intervals is accepted, defining morning as starting 
%   % at 6 AM, and converting glucose values from mmol/L to mg/dL.
%
% NOTE:
% - Ensure that the 'cgm' table is properly formatted with 'time' as a datetime array and 'cgmval' 
%   as a numeric array before calling this function.
% - The 'convertToMgdL' option should be carefully set depending on the units of the input data.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function features = QoCGM(cgm, samling_f, sampling_variation, morning_start_h, convertToMgdL, ploton, handleMissing)

%% CHECKS %%%%%%%%%%%%%%%%%%%%
% Check if ploton is 1 or 0
if ploton ~= 1 && ploton ~= 0
    ploton = 0;
    disp('The variable "ploton" was set to 0.');
end

% Check if convertToMgdL is 1 or 0
if ploton ~= 1 && ploton ~= 0
    ploton = 0;
    disp('The variable "convertToMgdL" was set to 0.');
end

% Check if cgm is a table with two columns: cgm.time and cgm.cgmval
if ~istable(cgm) || ~all(ismember({'time', 'cgmval'}, cgm.Properties.VariableNames)) || width(cgm) ~= 2
    error('Error: The input "cgm" must be a table with two columns: "cgm.time" and "cgm.cgmval".');
end

% Check if cgm.time contains timestamps
if ~all(isdatetime(cgm.time))
    error('Error: The column "cgm.time" must contain datetime values.');
end

% Check if morning_start_h is between 1 and 24
if morning_start_h < 1 || morning_start_h > 24
    morning_start_h = 8; % Set default value to 8 if out of bounds
    disp('The variable "morning_start_h" was set to 8.');
end

% Check if sampling_variation is between 1 and 24
if sampling_variation < 0 || sampling_variation > 1
    sampling_variation = 0.02; % Set default value to 8 if out of bounds
    disp('The variable "sampling_variation" was set to 0.02.');
end

% Check if samling_f is > 0 
if samling_f < 0 || isnan(samling_f)
    error('Error: samling_f needs to be a number');
end
%% CHECKS ENDS %%%%%%%%%%%%%%%%%%%%

%% Convert to mg/dL
if convertToMgdL==1
    cgm.cgmval= cgm.cgmval*18.0182; % convert from mmol/l to mg/dL
end

%% preprocess signal and interporlate missing periods
[cgm, interpTime, interpCgmVal, missingDataIdx, uniqueDays]= preprocessSignal(cgm, samling_f, sampling_variation, handleMissing);
%plot raw and interporlation
if ploton
    preprocessPlot(cgm, interpTime, interpCgmVal, missingDataIdx, uniqueDays);
end


%% Calc metrics

% calculate number of monitoring days and completeness
[monitoringDays, completenessRate]=completeness(cgm, samling_f);

feats.monitoringDays = monitoringDays;
feats.completenessRate = completenessRate;

% calculate metrics for wholeday, night and day periods
for i=1:3
    switch i
        case 1 % whole days
            fix = '';
            tmpData = interpCgmVal;
        case 2 % nighs
            fix = '_nighttime';
            idx_night = hour(interpTime)<morning_start_h;
            tmpData = interpCgmVal(idx_night);
        case 3 % daytime
            fix = '_daytime';
            idx_day = hour(interpTime)>=morning_start_h;
            tmpData = interpCgmVal(idx_day);
    end


    feats.(['sample_n' fix])=  length(tmpData);

    % Statistical
    feats.(['Mean' fix]) = round(mean(tmpData), 2);
    feats.(['Median' fix]) = round(median(tmpData), 2);
    feats.(['Std' fix]) = round(std(tmpData), 2);
    feats.(['CV' fix]) = round(std(tmpData)/mean(tmpData)*100, 2);
    feats.(['IQR' fix]) = round(iqr(tmpData), 2);
    feats.(['Pctile75' fix]) =  round(prctile(tmpData,75), 2);
    feats.(['Pctile25' fix])=  round(prctile(tmpData,25), 2);

    % Calculate clinical features
    feats.(['TIR' fix]) = round(size(tmpData(tmpData>=70 & tmpData<=180),1)/size(tmpData,1)*100, 2); % time in range 70-180 mg/
    feats.(['TITR' fix])  = round(size(tmpData(tmpData>=70 & tmpData<=140),1)/size(tmpData,1)*100, 2); % time in range 70-140 mg/dl
    feats.(['TBR1' fix]) = round(size(tmpData(tmpData<70 & tmpData>=54),1)/size(tmpData,1)*100, 2); % time below range 54-70 mg/dl
    feats.(['TBR2' fix]) = round(size(tmpData(tmpData<54),1)/size(tmpData,1)*100, 2);% time below range 54 mg/dl
    feats.(['TBR' fix]) = feats.(['TBR1' fix]) + feats.(['TBR2' fix]);
    feats.(['TAR1' fix]) = round(size(tmpData(tmpData>180 & tmpData<=250),1)/size(tmpData,1)*100, 2); % time above 180-250
    feats.(['TAR2' fix]) = round(size(tmpData(tmpData>250),1)/size(tmpData,1)*100, 2); % time above 250
    feats.(['TAR' fix]) = feats.(['TAR1' fix]) + feats.(['TAR2' fix]);

end

%% calc specialized metrics
tmpData = interpCgmVal;
tmpDataTime = interpTime;

% Hypo events 
feats.Hypo_episodes_n = detect_hypo_episodes(interpTime,interpCgmVal, ploton);


% GRI
feats.GRI_Hypo = round(GRI_hypo(tmpData), 2);
feats.GRI_Hyper = round(GRI_hyper(tmpData), 2);
feats.GRI = round( (3*feats.GRI_Hypo)+(1.6*feats.GRI_Hyper), 2);

% CONGA
feats.CONGA_1H = CONGA(tmpData, 1, samling_f);
feats.CONGA_2H = CONGA(tmpData, 2, samling_f);
feats.CONGA_6H = CONGA(tmpData, 6, samling_f);
feats.CONGA_24H = CONGA(tmpData, 24, samling_f);

% MAGE
[mage mage_increas mage_decrease]=MAGE(tmpData, ploton);
feats.MAGE= mage;

% Signal mobility
feats.Mobility = (var(diff(tmpData))/var(tmpData))^0.5;

% Distance traveled per minute (DTpM)
feats.DTpM = sum(abs(diff(tmpData))) / (size(tmpData,1)*samling_f);

% Fasting glucose proxy (FGxP)
feats.FGxP = fastingProxy(tmpData,tmpDataTime, morning_start_h, uniqueDays, ploton);

% Glucose Management Indicator (GMI)
%https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6196826/
feats.GMI =  3.31 + 0.02392 * mean(tmpData);

% LBGI /  HBGI
[LBGI HBGI] = calculateBGI(tmpData);
feats.LBGI =LBGI;
feats.HBGI = HBGI;

% MSE
m = 2;  % Embedding dimension
r = 0.15;  % Tolerance (15% of the standard deviation)
scales = 7;  % Number of scales to compute
mse = multiscaleEntropy(tmpData, m, r, scales);
feats.MCI= sum(mse);

% GRADE
[GRADE GRADE_hypo GRADE_eu GRADE_hyper] = GRAD(tmpData);
feats.GRAD = GRADE;
feats.GRADE_hypo = GRADE_hypo;
feats.GRADE_eu = GRADE_eu;
feats.GRADE_hyper = GRADE_hyper;

% SD day to day
[SD_d2d_mean SD_d2d_TIR] = d2d(interpCgmVal,interpTime,uniqueDays);
feats.D2d_mean = SD_d2d_mean;
feats.D2d_TIR = SD_d2d_TIR




% output
features = feats;

end
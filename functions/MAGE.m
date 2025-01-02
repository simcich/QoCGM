%MAGE calc
function [mage mage_increas mage_decrease]=MAGE(GluData, ploton)



tempdata = GluData;

[maxtab, mintab] = peakdet(tempdata, nanstd(tempdata)); 

if ploton
    figure('Renderer', 'painters', 'Position', [50 50 900 400]);
    plot(tempdata,'Color' , '#575555' ,'LineWidth',1.3); hold on;
    plot(maxtab(:,1),maxtab(:,2), 'o','Color' , '#73a2c6' ,'MarkerFaceColor', '#73a2c6');
    plot(mintab(:,1),mintab(:,2), 'o', 'Color' , '#f4777f', 'MarkerFaceColor', '#f4777f');

    %labels
    title('MAGE Peak and Nadir detection');
    L= legend('signal','peaks','nadirs');
    L.AutoUpdate = 'off';
    xlabel('samples')
    ylabel('mg/dL')
end

GE = [];
GE_decrease = [];
GE_increas = [];
% loop from vally
for i=1: length(mintab(:,1))

    try
        min_x = mintab(i,1);
        min_y = mintab(i,2);

        relativ_to_x = maxtab(:,1)-min_x;
        relativ_to_x(relativ_to_x<0) =[];
        closes_loc = relativ_to_x(1);
        next_loc = find(maxtab(:,1)==closes_loc+min_x);

        max_x = maxtab(next_loc,1);
        max_y = maxtab(next_loc,2);

        if ploton
            plot([min_x max_x], [min_y max_y],'-', 'Color' , '#73a2c6','LineWidth',1.3); hold on;
        end


        GE = [GE; max_y - min_y];
        GE_increas = [GE_increas; (max_y - min_y)/(max_x-min_x)];
    end

end

% loop from peak
for i=1: length(maxtab(:,1))

    try
        min_x = maxtab(i,1);
        min_y = maxtab(i,2);

        relativ_to_x = mintab(:,1)-min_x;
        relativ_to_x(relativ_to_x<0) =[];
        closes_loc = relativ_to_x(1);
        next_loc = find(mintab(:,1)==closes_loc+min_x);

        max_x = mintab(next_loc,1);
        max_y = mintab(next_loc,2);

        if ploton
            plot([min_x max_x], [min_y max_y],'-','Color' , '#f4777f','LineWidth',1.3); hold on;

        end

        GE = [GE; min_y-max_y];
        GE_decrease = [GE_decrease; (min_y-max_y)/(max_x-min_x)];
    end

end




mage = mean(abs(GE));
mage_increas = median(abs(GE_increas));
mage_decrease= median(abs(GE_decrease));

end

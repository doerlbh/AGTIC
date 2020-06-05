function [opt1, stat_dCorMax] = simple_helper_rpADGTIC(X,Y,nThreshs,method)

% adaptive distance-based geo-topological independence criterion (ADGTIC)
% a general robust test for mutual information between X and Y


%% define thresholds

Xthreshs = linspace(0,1,nThreshs);
Ythreshs = linspace(0,1,nThreshs);

nXthreshs=numel(Xthreshs);
nYthreshs=numel(Ythreshs);


%% compute actual dCorMapThreshs as a function of the two thresholds

[dCorMapThreshs] = simple_helper_pfindDCorMapThreshs(X,Y,Xthreshs,Ythreshs,method);

stat_dCorMax = max(dCorMapThreshs(:));

indexX = zeros(numel(Xthreshs));
indexY = zeros(numel(Ythreshs));

count = 1;
for uXThreshI=2:nXthreshs
    for lXThreshI=1:uXThreshI-1
        indexX(lXThreshI, uXThreshI) = count;
        count = count + 1;
    end
end

count = 1;
for uYThreshI=2:nYthreshs
    for lYThreshI=1:uYThreshI-1
        indexY(lYThreshI, uYThreshI) = count;
        count = count + 1;
    end
end


[opt1_x,opt1_y] = find(dCorMapThreshs==stat_dCorMax,1);
[opt1_lx, opt1_ux] = find(indexX==opt1_x,1);
[opt1_ly, opt1_uy] = find(indexY==opt1_y,1);
opt1.lx = Xthreshs(opt1_lx);
opt1.ux = Xthreshs(opt1_ux);
opt1.ly = Ythreshs(opt1_ly);
opt1.uy = Ythreshs(opt1_uy);



% run power calculation

function run_pure_record(loc,type)

% clear all
% close all
% clc


switch loc
    case 'amath',
        cd '/home/sunnylin/Dropbox/Git/GTMI'
        
    case 'doerlbh',
        cd '/Users/DoerLBH/Dropbox/git/GTMI'
        
    case 'habanero',
        cd '/rigel/theory/users/bl2681/GTMI'
        
    otherwise,
        disp('PROBLEM!')
end


%% general variables

noise = 0;
nRandomisations = 10;
% upperObs = 20;
% num_statsnames = 22;
alpha = 0.05;
N = 500;

switch type
    case 'l',
        relationship = 'linear';
    case 'p',
        relationship = 'parabolic';
    case 's',
        relationship = 'sinusoidal';
    case 'c',
        relationship = 'circular';
    case 'k',
        relationship = 'checkerboard';
    otherwise,
        disp('PROBLEM!')
end


disp('___________________');

switch relationship
    case 'linear',
        xs = randn(N,1);
        ys = (2/3)*xs + noise*randn(N,1);
        
    case 'parabolic',
        xs = randn(N,1);
        ys = (2/3)*(xs.^2) + noise*randn(N,1);
        
    case 'sinusoidal',
        xs = 5*pi*rand(N,1);
        ys = 2*sin(xs) + noise*randn(N,1);
        
    case 'circular',
        thetas = 2*pi*rand(N,1);
        xs = 10*cos(thetas) + noise*randn(N,1);
        ys = 10*sin(thetas) + noise*randn(N,1);
        
    case 'checkerboard',
        xcs = helper_randint(5,N);
        ycs = 2*helper_randint(2,N) + mod(xcs,2);
        xs = 10*(xcs + rand(N,1)) + noise*randn(N,1);
        ys = 10*(ycs + rand(N,1)) + noise*randn(N,1);
        
    otherwise,
        disp('PROBLEM!')
end

num_trials = nRandomisations;

ADGTIC1 = zeros(num_trials*2,12);
ADGTIC2 = zeros(num_trials*2,12);
ADGTIC3 = zeros(num_trials*2,12);
pADGTIC1 = zeros(num_trials*2,12);
pADGTIC2 = zeros(num_trials*2,12);
pADGTIC3 = zeros(num_trials*2,12);
ADsnpIC = zeros(num_trials*2,2);
ADdsnpIC = zeros(num_trials*2,4);
AKIC = zeros(num_trials*2,2);
mikMax = zeros(num_trials*2,1);
mikInfMax = zeros(num_trials*2,1);

for m = 1:num_trials
    
    disp(['__linear run ' num2str(m)])
    
    [pos_optimals, pos_stats(:,m), ~] = helper_r_fine_evaluate_statistics(xs,ys,nRandomisations,loc);
    
    ADGTIC1(m,:) = [pos_optimals.ADGTIC1dCorMax.lx, pos_optimals.ADGTIC1dCorMax.ux, pos_optimals.ADGTIC1dCorMax.ly, pos_optimals.ADGTIC1dCorMax.uy, pos_optimals.ADGTIC1dCorInfMax.lx, pos_optimals.ADGTIC1dCorInfMax.ux, pos_optimals.ADGTIC1dCorInfMax.ly, pos_optimals.ADGTIC1dCorInfMax.uy, pos_optimals.ADGTIC1nndCorInfMax.lx, pos_optimals.ADGTIC1nndCorInfMax.ux, pos_optimals.ADGTIC1nndCorInfMax.ly, pos_optimals.ADGTIC1nndCorInfMax.uy];
    ADGTIC2(m,:) = [pos_optimals.ADGTIC2dCorMax.lx, pos_optimals.ADGTIC2dCorMax.ux, pos_optimals.ADGTIC2dCorMax.ly, pos_optimals.ADGTIC2dCorMax.uy, pos_optimals.ADGTIC2dCorInfMax.lx, pos_optimals.ADGTIC2dCorInfMax.ux, pos_optimals.ADGTIC2dCorInfMax.ly, pos_optimals.ADGTIC2dCorInfMax.uy, pos_optimals.ADGTIC2nndCorInfMax.lx, pos_optimals.ADGTIC2nndCorInfMax.ux, pos_optimals.ADGTIC2nndCorInfMax.ly, pos_optimals.ADGTIC2nndCorInfMax.uy];
    ADGTIC3(m,:) = [pos_optimals.ADGTIC3dCorMax.lx, pos_optimals.ADGTIC3dCorMax.ux, pos_optimals.ADGTIC3dCorMax.ly, pos_optimals.ADGTIC3dCorMax.uy, pos_optimals.ADGTIC3dCorInfMax.lx, pos_optimals.ADGTIC3dCorInfMax.ux, pos_optimals.ADGTIC3dCorInfMax.ly, pos_optimals.ADGTIC3dCorInfMax.uy, pos_optimals.ADGTIC3nndCorInfMax.lx, pos_optimals.ADGTIC3nndCorInfMax.ux, pos_optimals.ADGTIC3nndCorInfMax.ly, pos_optimals.ADGTIC3nndCorInfMax.uy];
    
    pADGTIC1(m,:) = [pos_optimals.pADGTIC1dCorMax.lx, pos_optimals.pADGTIC1dCorMax.ux, pos_optimals.pADGTIC1dCorMax.ly, pos_optimals.pADGTIC1dCorMax.uy, pos_optimals.pADGTIC1dCorInfMax.lx, pos_optimals.pADGTIC1dCorInfMax.ux, pos_optimals.pADGTIC1dCorInfMax.ly, pos_optimals.pADGTIC1dCorInfMax.uy, pos_optimals.pADGTIC1nndCorInfMax.lx, pos_optimals.pADGTIC1nndCorInfMax.ux, pos_optimals.pADGTIC1nndCorInfMax.ly, pos_optimals.pADGTIC1nndCorInfMax.uy];
    pADGTIC2(m,:) = [pos_optimals.pADGTIC2dCorMax.lx, pos_optimals.pADGTIC2dCorMax.ux, pos_optimals.pADGTIC2dCorMax.ly, pos_optimals.pADGTIC2dCorMax.uy, pos_optimals.pADGTIC2dCorInfMax.lx, pos_optimals.pADGTIC2dCorInfMax.ux, pos_optimals.pADGTIC2dCorInfMax.ly, pos_optimals.pADGTIC2dCorInfMax.uy, pos_optimals.pADGTIC2nndCorInfMax.lx, pos_optimals.pADGTIC2nndCorInfMax.ux, pos_optimals.pADGTIC2nndCorInfMax.ly, pos_optimals.pADGTIC2nndCorInfMax.uy];
    pADGTIC3(m,:) = [pos_optimals.pADGTIC3dCorMax.lx, pos_optimals.pADGTIC3dCorMax.ux, pos_optimals.pADGTIC3dCorMax.ly, pos_optimals.pADGTIC3dCorMax.uy, pos_optimals.pADGTIC3dCorInfMax.lx, pos_optimals.pADGTIC3dCorInfMax.ux, pos_optimals.pADGTIC3dCorInfMax.ly, pos_optimals.pADGTIC3dCorInfMax.uy, pos_optimals.pADGTIC3nndCorInfMax.lx, pos_optimals.pADGTIC3nndCorInfMax.ux, pos_optimals.pADGTIC3nndCorInfMax.ly, pos_optimals.pADGTIC3nndCorInfMax.uy];
    
    ADsnpIC(m,:) = [pos_optimals.ADsnpIC.x, pos_optimals.ADsnpIC.y];
    ADdsnpIC(m,:) = [pos_optimals.ADdsnpIC.lx, pos_optimals.ADdsnpIC.ux, pos_optimals.ADdsnpIC.ly, pos_optimals.ADdsnpIC.uy];
    AKIC(m,:) = [pos_optimals.AKIC.x,pos_optimals.AKIC.y];
    
    mikMax(m) = pos_optimals.mikMax;
    mikInfMax(m) = pos_optimals.mikInfMax;
    
    [null_optimals, null_stats(:,m), ~] = helper_r_fine_evaluate_statistics(xs,ys(randperm(N)),nRandomisations,loc);
    
    ADGTIC1(num_trials+m,:) = [null_optimals.ADGTIC1dCorMax.lx, null_optimals.ADGTIC1dCorMax.ux, null_optimals.ADGTIC1dCorMax.ly, null_optimals.ADGTIC1dCorMax.uy, null_optimals.ADGTIC1dCorInfMax.lx, null_optimals.ADGTIC1dCorInfMax.ux, null_optimals.ADGTIC1dCorInfMax.ly, null_optimals.ADGTIC1dCorInfMax.uy, null_optimals.ADGTIC1nndCorInfMax.lx, null_optimals.ADGTIC1nndCorInfMax.ux, null_optimals.ADGTIC1nndCorInfMax.ly, null_optimals.ADGTIC1nndCorInfMax.uy,];
    ADGTIC2(num_trials+m,:) = [null_optimals.ADGTIC2dCorMax.lx, null_optimals.ADGTIC2dCorMax.ux, null_optimals.ADGTIC2dCorMax.ly, null_optimals.ADGTIC2dCorMax.uy, null_optimals.ADGTIC2dCorInfMax.lx, null_optimals.ADGTIC2dCorInfMax.ux, null_optimals.ADGTIC2dCorInfMax.ly, null_optimals.ADGTIC2dCorInfMax.uy, null_optimals.ADGTIC2nndCorInfMax.lx, null_optimals.ADGTIC2nndCorInfMax.ux, null_optimals.ADGTIC2nndCorInfMax.ly, null_optimals.ADGTIC2nndCorInfMax.uy,];
    ADGTIC3(num_trials+m,:) = [null_optimals.ADGTIC3dCorMax.lx, null_optimals.ADGTIC3dCorMax.ux, null_optimals.ADGTIC3dCorMax.ly, null_optimals.ADGTIC3dCorMax.uy, null_optimals.ADGTIC3dCorInfMax.lx, null_optimals.ADGTIC3dCorInfMax.ux, null_optimals.ADGTIC3dCorInfMax.ly, null_optimals.ADGTIC3dCorInfMax.uy, null_optimals.ADGTIC3nndCorInfMax.lx, null_optimals.ADGTIC3nndCorInfMax.ux, null_optimals.ADGTIC3nndCorInfMax.ly, null_optimals.ADGTIC3nndCorInfMax.uy,];
    
    pADGTIC1(num_trials+m,:) = [null_optimals.pADGTIC1dCorMax.lx, null_optimals.pADGTIC1dCorMax.ux, null_optimals.pADGTIC1dCorMax.ly, null_optimals.pADGTIC1dCorMax.uy, null_optimals.pADGTIC1dCorInfMax.lx, null_optimals.pADGTIC1dCorInfMax.ux, null_optimals.pADGTIC1dCorInfMax.ly, null_optimals.pADGTIC1dCorInfMax.uy, null_optimals.pADGTIC1nndCorInfMax.lx, null_optimals.pADGTIC1nndCorInfMax.ux, null_optimals.pADGTIC1nndCorInfMax.ly, null_optimals.pADGTIC1nndCorInfMax.uy,];
    pADGTIC2(num_trials+m,:) = [null_optimals.pADGTIC2dCorMax.lx, null_optimals.pADGTIC2dCorMax.ux, null_optimals.pADGTIC2dCorMax.ly, null_optimals.pADGTIC2dCorMax.uy, null_optimals.pADGTIC2dCorInfMax.lx, null_optimals.pADGTIC2dCorInfMax.ux, null_optimals.pADGTIC2dCorInfMax.ly, null_optimals.pADGTIC2dCorInfMax.uy, null_optimals.pADGTIC2nndCorInfMax.lx, null_optimals.pADGTIC2nndCorInfMax.ux, null_optimals.pADGTIC2nndCorInfMax.ly, null_optimals.pADGTIC2nndCorInfMax.uy,];
    pADGTIC3(num_trials+m,:) = [null_optimals.pADGTIC3dCorMax.lx, null_optimals.pADGTIC3dCorMax.ux, null_optimals.pADGTIC3dCorMax.ly, null_optimals.pADGTIC3dCorMax.uy, null_optimals.pADGTIC3dCorInfMax.lx, null_optimals.pADGTIC3dCorInfMax.ux, null_optimals.pADGTIC3dCorInfMax.ly, null_optimals.pADGTIC3dCorInfMax.uy, null_optimals.pADGTIC3nndCorInfMax.lx, null_optimals.pADGTIC3nndCorInfMax.ux, null_optimals.pADGTIC3nndCorInfMax.ly, null_optimals.pADGTIC3nndCorInfMax.uy,];
    
    ADsnpIC(num_trials+m,:) = [null_optimals.ADsnpIC.x, null_optimals.ADsnpIC.y];
    ADdsnpIC(num_trials+m,:) = [null_optimals.ADdsnpIC.lx, null_optimals.ADdsnpIC.ux, null_optimals.ADdsnpIC.ly, null_optimals.ADdsnpIC.uy];
    AKIC(num_trials+m,:) = [null_optimals.AKIC.x,null_optimals.AKIC.y];
    
    mikMax(num_trials+m) = null_optimals.mikMax;
    mikInfMax(num_trials+m) = null_optimals.mikInfMax;
    
end


pos_opt.ADGTIC1 = ADGTIC1(1:num_trials,:);
pos_opt.ADGTIC2 = ADGTIC2(1:num_trials,:);
pos_opt.ADGTIC3 = ADGTIC3(1:num_trials,:);
pos_opt.pADGTIC1 = pADGTIC1(1:num_trials,:);
pos_opt.pADGTIC2 = pADGTIC2(1:num_trials,:);
pos_opt.pADGTIC3 = pADGTIC3(1:num_trials,:);
pos_opt.ADsnpIC = ADsnpIC(1:num_trials,:);
pos_opt.ADdsnpIC = ADdsnpIC(1:num_trials,:);
pos_opt.AKIC = AKIC(1:num_trials,:);
pos_opt.mikMax = mikMax(1:num_trials);
pos_opt.mikInfMax = mikInfMax(1:num_trials);

null_opt.ADGTIC1 = ADGTIC1(1+num_trials:2*num_trials,:);
null_opt.ADGTIC2 = ADGTIC2(1+num_trials:2*num_trials,:);
null_opt.ADGTIC3 = ADGTIC3(1+num_trials:2*num_trials,:);
null_opt.pADGTIC1 = pADGTIC1(1+num_trials:2*num_trials,:);
null_opt.pADGTIC2 = pADGTIC2(1+num_trials:2*num_trials,:);
null_opt.pADGTIC3 = pADGTIC3(1+num_trials:2*num_trials,:);
null_opt.ADsnpIC = ADsnpIC(1+num_trials:2*num_trials,:);
null_opt.ADdsnpIC = ADdsnpIC(1+num_trials:2*num_trials,:);
null_opt.AKIC = AKIC(1+num_trials:2*num_trials,:);
null_opt.mikMax = mikMax(1+num_trials:2*num_trials);
null_opt.mikInfMax = mikInfMax(1+num_trials:2*num_trials);

% Compute empirical power of all statistics tested
%  num_trials = nRandomisations;
thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
successes = sum((pos_stats > thresholds),2);
power = successes/num_trials;
dpower = sqrt(power.*(1-power)./num_trials);

% l_power(n,:) = power(:)';
% l_dpower(n,:) = dpower(:)';
% l_pos_stats(n,:,:) = pos_stats;
% l_null_stats(n,:,:) = null_stats;

switch type
    case 'l',
        save new_results/power_fdr/opts_linear_power.mat pos_stats null_stats power dpower pos_opt null_opt
    case 'p',
        save new_results/power_fdr/opts_parabolic_power.mat pos_stats null_stats power dpower pos_opt null_opt
    case 's',
        save new_results/power_fdr/opts_sinusoidal_power.mat pos_stats null_stats power dpower pos_opt null_opt
    case 'c',
        save new_results/power_fdr/opts_circular_power.mat pos_stats null_stats power dpower pos_opt null_opt
    case 'k',
        save new_results/power_fdr/opts_checkerboard_power.mat pos_stats null_stats power dpower pos_opt null_opt
    otherwise,
        disp('PROBLEM!')
end

end
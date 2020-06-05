% run power and fdr calculation

clear all
close all
clc

cd '/Users/DoerLBH/Dropbox/git/GTMI'

%% general variables

noise = 0;
nRandomisations = 100;
upperObs = 20;


%% linear case

relationship = 'linear';

for n = 1:upperObs
    
    N = n*20;
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
    
    [pos_stats, stat_names] = helper_evaluate_statistics(xs,ys,nRandomisations);
    
    for run_num = 1:nRandomisations
        
        disp(['__linear obs ' num2str(N) ' run ' num2str(run_num)])
        [null_stats(:,run_num), ~] = helper_evaluate_statistics(xs,ys(randperm(N)),nRandomisations);
        
    end
    
    for c = 1:numel(stat_names)
        
        linear_fdr(n,c) = (sum(null_stats(c,:) > pos_stats(c))) / nRandomisations;
        
    end
    
end

save results/power_fdr/linear_fdr.mat linear_fdr

%% parabolic case

relationship = 'parabolic';

for n = 1:upperObs
    
    N = n*20;
    disp('___________________')
    
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
    
    [pos_stats, stat_names] = helper_evaluate_statistics(xs,ys,nRandomisations);
    
    for run_num = 1:nRandomisations
        
        disp(['__parabolic obs ' num2str(N) ' run ' num2str(run_num)])
        [null_stats(:,run_num), ~] = helper_evaluate_statistics(xs,ys(randperm(N)),nRandomisations);
        
    end
    
    for c = 1:numel(stat_names)
        
        parabolic_fdr(n,c) = (sum(null_stats(c,:) > pos_stats(c))) / nRandomisations;
        
    end
    
end

save results/power_fdr/parabolic_fdr.mat parabolic_fdr

%% sinusoidal case

relationship = 'sinusoidal';

for n = 1:upperObs
    
    N = n*20;
    disp('___________________')
    
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
    
    [pos_stats, stat_names] = helper_evaluate_statistics(xs,ys,nRandomisations);
    
    for run_num = 1:nRandomisations
        
        disp(['__sinusoidal obs ' num2str(N) ' run ' num2str(run_num)])
        [null_stats(:,run_num), ~] = helper_evaluate_statistics(xs,ys(randperm(N)),nRandomisations);
        
    end
    
    for c = 1:numel(stat_names)
        
        sinusoidal_fdr(n,c) = (sum(null_stats(c,:) > pos_stats(c))) / nRandomisations;
        
    end
    
end

save results/power_fdr/sinusoidal_fdr.mat sinusoidal_fdr

%% circular case

relationship = 'circular';

for n = 1:upperObs
    
    N = n*20;
    disp('___________________')
    
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
    
    [pos_stats, stat_names] = helper_evaluate_statistics(xs,ys,nRandomisations);
    
    for run_num = 1:nRandomisations
        
        disp(['__circular obs ' num2str(N) ' run ' num2str(run_num)])
        [null_stats(:,run_num), ~] = helper_evaluate_statistics(xs,ys(randperm(N)),nRandomisations);
        
    end
    
    for c = 1:numel(stat_names)
        
        circular_fdr(n,c) = (sum(null_stats(c,:) > pos_stats(c))) / nRandomisations;
        
    end
    
end

save results/power_fdr/circular_fdr.mat circular_fdr 

%% checkerboard case

relationship = 'checkerboard';

for n = 1:upperObs
    
    N = n*20;
    disp('___________________')
    
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
    
    [pos_stats, stat_names] = helper_evaluate_statistics(xs,ys,nRandomisations);
    
    for run_num = 1:nRandomisations
        
        disp(['__checkerboard obs ' num2str(N) ' run ' num2str(run_num)])
        [null_stats(:,run_num), ~] = helper_evaluate_statistics(xs,ys(randperm(N)),nRandomisations);
        
    end
    
    for c = 1:numel(stat_names)
        
        checkerboard_fdr(n,c) = (sum(null_stats(c,:) > pos_stats(c))) / nRandomisations;
        
    end
    
end

save results/power_fdr/checkerboard_fdr.mat checkerboard_fdr

% run power calculation

loc = 'amath';

relationship1 = 'sinusoidal';
relationship2 = 'checkerboard';

% general variables
noise = 0;
% num_statsnames = 22;
alpha = 0.05;

nRandomisations = 50;
N = 50;

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


switch relationship1
    
    case 'linear',
        xs = randn(N,1);
        ys = (2/3)*xs + noise*randn(N,1);
        x1 = [xs ys];
        
    case 'parabolic',
        xs = randn(N,1);
        ys = (2/3)*(xs.^2) + noise*randn(N,1);
        x1 = [xs ys];
        
    case 'sinusoidal',
        xs = 5*pi*rand(N,1);
        ys = 2*sin(xs) + noise*randn(N,1);
        x1 = [xs ys];
        
    case 'circular',
        thetas = 2*pi*rand(N,1);
        xs = 10*cos(thetas) + noise*randn(N,1);
        ys = 10*sin(thetas) + noise*randn(N,1);
        x1 = [xs ys];
        
    case 'checkerboard',
        xcs = helper_randint(5,N);
        ycs = 2*helper_randint(2,N) + mod(xcs,2);
        xs = 10*(xcs + rand(N,1)) + noise*randn(N,1);
        ys = 10*(ycs + rand(N,1)) + noise*randn(N,1);
        x1 = [xs ys];
         
    case 'random',
        xs = 10*randn(N,1);
        ys = 10*randn(N,1);
        x1 = [xs ys];   
        
    otherwise,
        disp('PROBLEM!')
end


switch relationship2
    
    case 'linear',
        xs = randn(N,1);
        ys = (2/3)*xs + noise*randn(N,1);
        x2 = [xs ys];
        
    case 'parabolic',
        xs = randn(N,1);
        ys = (2/3)*(xs.^2) + noise*randn(N,1);
        x2 = [xs ys];
        
    case 'sinusoidal',
        xs = 5*pi*rand(N,1);
        ys = 2*sin(xs) + noise*randn(N,1);
        x2 = [xs ys];
        
    case 'circular',
        thetas = 2*pi*rand(N,1);
        xs = 10*cos(thetas) + noise*randn(N,1);
        ys = 10*sin(thetas) + noise*randn(N,1);
        x2 = [xs ys];
        
    case 'checkerboard',
        xcs = helper_randint(5,N);
        ycs = 2*helper_randint(2,N) + mod(xcs,2);
        xs = 10*(xcs + rand(N,1)) + noise*randn(N,1);
        ys = 10*(ycs + rand(N,1)) + noise*randn(N,1);
        x2 = [xs ys];
         
    case 'random',
        xs = 10*randn(N,1);
        ys = 10*randn(N,1);
        x2 = [xs ys];   
        
    otherwise,
        disp('PROBLEM!')
end


x = [x1(:,1) x2(:,1)];
y = [x1(:,2) x2(:,2)];

parfor run_num = 1:nRandomisations
    
    disp(['obs ' num2str(N) ' run ' num2str(run_num)])
    [pos_stats(:,run_num), ~] = helper_evaluate_statistics(x,y,nRandomisations,loc);
    [null_stats(:,run_num), ~] = helper_evaluate_statistics(x,y(randperm(N),:),nRandomisations,loc);
    
end

% Compute empirical power of all statistics tested
num_trials = nRandomisations;
thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
successes = sum((pos_stats > thresholds),2);
power_n = successes/num_trials;
dpower = sqrt(power_n.*(1-power_n)./num_trials);

save results/power_fdr/power_s_k.mat pos_stats null_stats power_n dpower

exit


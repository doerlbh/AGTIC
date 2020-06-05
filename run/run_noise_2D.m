% run noise calculation

function run_noise_2D(loc, Q, num_trials,nRandomisations,first_relationship)

% clear all
% close all
% clc
%
% loc = 'amath';

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

% cd '/Users/DoerLBH/Dropbox/git/GTMI'

%%

% USE Q = 5, c.num_trials = 20 FOR TESTING
% USE Q = 25, c.num_trials = 500 FOR PUBLICATION

alpha = 0.05;

relationships = {...
    'linear';
    'parabolic';
    'sinusoidal';
    'circular';
    'checkerboard'};

% Q = 25; % FOR PUBLICATION
% Q = 10; % FOR TESTING
% Q = 3;

% num_trials = 100;

noises =  logspace(1,0,Q);

run_num = 1;
for r = 1:numel(relationships)
    
    for q = 1:Q
        
        c.N = 200;
        
        %c.num_trials = 500; % FOR PUBLICATION
        c.num_trials = num_trials; % FOR TESTING
        %         c.num_trials = 5; % FOR TESTING
        
        c.relationship = relationships{r};
        c.noise = noises(q);
        computations(run_num) = c;
        run_num = run_num + 1;
    end
end
num_runs = numel(computations);
disp(['needs ' num2str(num_runs) ' runs.'])

% nRandomisations = 100;
% nRandomisations = 50;

% Save computation specifications
save results/power_fdr/computations.mat computations relationships noises

% Do computations serially
for run_num = 1:num_runs
    
    disp('___________________')
    disp(['run ' num2str(run_num)])
    
    % Read in computation number
    computation = computations(run_num);
    N = computation.N;
    relationship = computation.relationship;
    noise = computation.noise;
    num_trials = computation.num_trials;
    
    % Iterate over trial
    is = randperm(N);
    %     xs = nan(N,1);
    %     ys = nan(N,1);
    
    parfor m=1:num_trials
        
        disp(['__trial ' num2str(m)])
        
        if mod(m,10) == 0
            disp(['run ' num2str(run_num) ' on trial ' num2str(m)])
        end
        
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
                %                 break;
                
        end
        ys_null = ys(is);
        
        % Evaluate statistics on both positive and null data sets
        pos_stats(:,m) = helper_evaluate_statistics(xs,ys,nRandomisations,loc);
        [null_stats(:,m), stat_names] = helper_evaluate_statistics(xs,ys_null,nRandomisations,loc);
    end
    
    % Compute empirical power of all statistics tested
    thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
    successes = sum((pos_stats > thresholds),2);
    power = successes/num_trials;
    dpower = sqrt(power.*(1-power)./num_trials);  
    
    switch relationship
        case 'linear',
            xs_regenerated = randn(N,1);
            ys_regenerated = (2/3)*xs_regenerated + noise*randn(N,1);
            
        case 'parabolic',
            xs_regenerated = randn(N,1);
            ys_regenerated = (2/3)*(xs_regenerated.^2) + noise*randn(N,1);
            
        case 'sinusoidal',
            xs_regenerated = 5*pi*rand(N,1);
            ys_regenerated = 2*sin(xs_regenerated) + noise*randn(N,1);
            
        case 'circular',
            thetas = 2*pi*rand(N,1);
            xs_regenerated = 10*cos(thetas) + noise*randn(N,1);
            ys_regenerated = 10*sin(thetas) + noise*randn(N,1);
            
        case 'checkerboard',
            xcs = helper_randint(5,N);
            ycs = 2*helper_randint(2,N) + mod(xcs,2);
            xs_regenerated = 10*(xcs + rand(N,1)) + noise*randn(N,1);
            ys_regenerated = 10*(ycs + rand(N,1)) + noise*randn(N,1);
            
        otherwise,
            disp('PROBLEM!')
            %                 break;
            
    end
    
    statnames = {};
    statnames{1} = 'MIC (Reshef)';
    % statnames{2} = 'MIC (Albanese)';
    % statnames{3} = 'MI (MIC Albanese)';
    statnames{2} = 'MI (Kraskov k=1)';
    statnames{3} = 'MI (Kraskov k=6)';
    statnames{4} = 'MI (Kraskov k=20)';
    statnames{5} = 'R^2';
    statnames{6} = 'dCor';
    statnames{7} = ['Hoeffding''', 's D'];
    statnames{8} = 'ADGTIC1 - dCorMax';
    statnames{9} = 'ADGTIC1 - dCorInfMax';
    statnames{10} = 'ADGTIC1 - nndCorInfMax';
    statnames{11} = 'ADGTIC2 - dCorMax';
    statnames{12} = 'ADGTIC2 - dCorInfMax';
    statnames{13} = 'ADGTIC2 - nndCorInfMax';
    statnames{14} = 'ADGTIC3 - dCorMax';
    statnames{15} = 'ADGTIC3 - dCorInfMax';
    statnames{16} = 'ADGTIC3 - nndCorInfMax';
    statnames{17} = 'ADIC - snpInf';
    statnames{18} = 'ADIC - dsnpInf';
    statnames{19} = 'HSIC';
    statnames{20} = 'AKIC';
    statnames{21} = 'rdmCor';
    statnames{22} = 'CD3';
    
    % Record power calculations
    results.computation = computation;
    results.power = power;
    results.dpower = dpower;
    results.thresholds = thresholds;
    results.pos_stats = pos_stats;
    results.null_stats = null_stats;
    results.xs_sample = xs_regenerated;
    results.ys_sample = ys_regenerated;
    results.stat_names = statnames;
    
    % Save results for given relationship and noise level.
    save(['results/power_fdr/results_' num2str(run_num) '.mat'], 'results')
    
end

exit

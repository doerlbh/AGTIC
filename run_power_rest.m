% run power calculation

function run_power_rest(loc,type)

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
nRandomisations = 100;
upperObs = 20;
num_statsnames = 22;
alpha = 0.05;

switch type
    case 'l',
        
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
            
            
            parfor run_num = 1:nRandomisations
                
                disp(['__linear obs ' num2str(N) ' run ' num2str(run_num)])
                [pos_optimals, pos_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
                [null_optimals, null_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys(randperm(N)),nRandomisations,loc);
                
            end
            
            % Compute empirical power of all statistics tested
            num_trials = nRandomisations;
            thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
            successes = sum((pos_stats > thresholds),2);
            power = successes/num_trials;
            l_power(n,:) = power(:)';
            dpower = sqrt(power.*(1-power)./num_trials);
            l_dpower(n,:) = dpower(:)';
            l_pos_stats(n,:,:) = pos_stats;
            l_null_stats(n,:,:) = null_stats;
            
        end
        
        save new_results/power_fdr/linear_power.mat l_pos_stats l_null_stats l_power l_dpower
        
        
        
    case 'p',
        
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
            
            
            parfor run_num = 1:nRandomisations
                
                disp(['__parabolic obs ' num2str(N) ' run ' num2str(run_num)])
                [pos_optimals, pos_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
                [null_optimals, null_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys(randperm(N)),nRandomisations,loc);
                
            end
            
            % Compute empirical power of all statistics tested
            num_trials = nRandomisations;
            thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
            successes = sum((pos_stats > thresholds),2);
            power = successes/num_trials;
            p_power(n,:) = power(:)';
            dpower = sqrt(power.*(1-power)./num_trials);
            p_dpower(n,:) = dpower(:)';
            p_pos_stats(n,:,:) = pos_stats;
            p_null_stats(n,:,:) = null_stats;
            
        end
        
        save new_results/power_fdr/parabolic_power.mat p_pos_stats p_null_stats p_power p_dpower
        
        
        
    case 's',
        
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
            
            
            parfor run_num = 1:nRandomisations
                
                disp(['__sinusoidal obs ' num2str(N) ' run ' num2str(run_num)])
                [pos_optimals, pos_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
                [null_optimals, null_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys(randperm(N)),nRandomisations,loc);
                
            end
            
            % Compute empirical power of all statistics tested
            num_trials = nRandomisations;
            thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
            successes = sum((pos_stats > thresholds),2);
            power = successes/num_trials;
            s_power(n,:) = power(:)';
            dpower = sqrt(power.*(1-power)./num_trials);
            s_dpower(n,:) = dpower(:)';
            s_pos_stats(n,:,:) = pos_stats;
            s_null_stats(n,:,:) = null_stats;
            
        end
        
        save new_results/power_fdr/sinusoidal_power.mat s_pos_stats s_null_stats s_power s_dpower
        
        
        
    case 'c',
        
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
            
            
            parfor run_num = 1:nRandomisations
                
                disp(['__circular obs ' num2str(N) ' run ' num2str(run_num)])
                [pos_optimals, pos_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
                [null_optimals, null_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys(randperm(N)),nRandomisations,loc);
                
            end
            
            % Compute empirical power of all statistics tested
            num_trials = nRandomisations;
            thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
            successes = sum((pos_stats > thresholds),2);
            power = successes/num_trials;
            c_power(n,:) = power(:)';
            dpower = sqrt(power.*(1-power)./num_trials);
            c_dpower(n,:) = dpower(:)';
            c_pos_stats(n,:,:) = pos_stats;
            c_null_stats(n,:,:) = null_stats;
            
        end
        
        save new_results/power_fdr/circular_power.mat c_pos_stats c_null_stats c_power c_dpower
        
        
    case 'k',
        
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
            
            
            parfor run_num = 1:nRandomisations
                
                disp(['__checkerboard obs ' num2str(N) ' run ' num2str(run_num)])
                [pos_optimals, pos_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
                [null_optimals, null_stats(:,run_num), ~] = helper_r_evaluate_statistics_rest(xs,ys(randperm(N)),nRandomisations,loc);
                
            end
            
            % Compute empirical power of all statistics tested
            num_trials = nRandomisations;
            thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
            successes = sum((pos_stats > thresholds),2);
            power = successes/num_trials;
            k_power(n,:) = power(:)';
            dpower = sqrt(power.*(1-power)./num_trials);
            k_dpower(n,:) = dpower(:)';
            k_pos_stats(n,:,:) = pos_stats;
            k_null_stats(n,:,:) = null_stats;
            
        end
        
        save new_results/power_fdr/checkerboard_power.mat k_pos_stats k_null_stats k_power k_dpower
        
    otherwise,
        
        disp('PROBLEM!')
        
end


end

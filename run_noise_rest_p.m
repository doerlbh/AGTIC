% run noise calculation

function run_noise_rest_p(loc, Q, num_trials,nRandomisations,start)

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
save new_results/power_fdr/computations.mat computations relationships noises

ADGTIC1 = zeros(num_trials,12);
ADGTIC2 = zeros(num_trials,12);
ADGTIC3 = zeros(num_trials,12);
pADGTIC1 = zeros(num_trials,12);
pADGTIC2 = zeros(num_trials,12);
pADGTIC3 = zeros(num_trials,12);
ADsnpIC = zeros(num_trials,2);
ADdsnpIC = zeros(num_trials,4);
AKIC = zeros(num_trials,2);
mikMax = zeros(num_trials,1);
mikInfMax = zeros(num_trials,1);

% Do computations serially
for run_num = start:num_runs
    
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
    
    for m=1:num_trials
        
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
                
            case 'multigaussian',
                
                nCluster = 8;
                centroids = randi(500,nCluster,4);
                variances = randi(10,nCluster,4);
                remains = zeros(nCluster,1);
                remains(1) = mod(N,nCluster);
                samples = floor(N/nCluster)* ones(nCluster,1) + remains;
                
                count = 1;
                xy = zeros(N,4);
                for c = 1:nCluster
                    for d = 1:4
                        xy(count:count+samples(c)-1,d) = normrnd(centroids(c,d),variances(c,d),[samples(c), 1]);
                    end
                    count = count + samples(c);
                end
                
                xs = xy(:,1:2) + noise*randn(N,2);
                ys = xy(:,3:4) + noise*randn(N,2);
                
            otherwise,
                disp('PROBLEM!')
                %                 break;
                
        end
        ys_null = ys(is,:);
        
        % Evaluate statistics on both positive and null data sets
        %         pos_stats(:,m) = helper_evaluate_statistics(xs,ys,nRandomisations,loc);
        %         [null_stats(:,m), stat_names] = helper_evaluate_statistics(xs,ys_null,nRandomisations,loc);
        
        [pos_optimals, pos_stats(:,m), ~] = helper_r_evaluate_statistics_rest(xs,ys,nRandomisations,loc);
        %
        %         ADGTIC1(m,:) = [pos_optimals.ADGTIC1dCorMax.lx, pos_optimals.ADGTIC1dCorMax.ux, pos_optimals.ADGTIC1dCorMax.ly, pos_optimals.ADGTIC1dCorMax.uy, pos_optimals.ADGTIC1dCorInfMax.lx, pos_optimals.ADGTIC1dCorInfMax.ux, pos_optimals.ADGTIC1dCorInfMax.ly, pos_optimals.ADGTIC1dCorInfMax.uy, pos_optimals.ADGTIC1nndCorInfMax.lx, pos_optimals.ADGTIC1nndCorInfMax.ux, pos_optimals.ADGTIC1nndCorInfMax.ly, pos_optimals.ADGTIC1nndCorInfMax.uy];
        %         ADGTIC2(m,:) = [pos_optimals.ADGTIC2dCorMax.lx, pos_optimals.ADGTIC2dCorMax.ux, pos_optimals.ADGTIC2dCorMax.ly, pos_optimals.ADGTIC2dCorMax.uy, pos_optimals.ADGTIC2dCorInfMax.lx, pos_optimals.ADGTIC2dCorInfMax.ux, pos_optimals.ADGTIC2dCorInfMax.ly, pos_optimals.ADGTIC2dCorInfMax.uy, pos_optimals.ADGTIC2nndCorInfMax.lx, pos_optimals.ADGTIC2nndCorInfMax.ux, pos_optimals.ADGTIC2nndCorInfMax.ly, pos_optimals.ADGTIC2nndCorInfMax.uy];
        %         ADGTIC3(m,:) = [pos_optimals.ADGTIC3dCorMax.lx, pos_optimals.ADGTIC3dCorMax.ux, pos_optimals.ADGTIC3dCorMax.ly, pos_optimals.ADGTIC3dCorMax.uy, pos_optimals.ADGTIC3dCorInfMax.lx, pos_optimals.ADGTIC3dCorInfMax.ux, pos_optimals.ADGTIC3dCorInfMax.ly, pos_optimals.ADGTIC3dCorInfMax.uy, pos_optimals.ADGTIC3nndCorInfMax.lx, pos_optimals.ADGTIC3nndCorInfMax.ux, pos_optimals.ADGTIC3nndCorInfMax.ly, pos_optimals.ADGTIC3nndCorInfMax.uy];
        %
        %         pADGTIC1(m,:) = [pos_optimals.pADGTIC1dCorMax.lx, pos_optimals.pADGTIC1dCorMax.ux, pos_optimals.pADGTIC1dCorMax.ly, pos_optimals.pADGTIC1dCorMax.uy, pos_optimals.pADGTIC1dCorInfMax.lx, pos_optimals.pADGTIC1dCorInfMax.ux, pos_optimals.pADGTIC1dCorInfMax.ly, pos_optimals.pADGTIC1dCorInfMax.uy, pos_optimals.pADGTIC1nndCorInfMax.lx, pos_optimals.pADGTIC1nndCorInfMax.ux, pos_optimals.pADGTIC1nndCorInfMax.ly, pos_optimals.pADGTIC1nndCorInfMax.uy];
        %         pADGTIC2(m,:) = [pos_optimals.pADGTIC2dCorMax.lx, pos_optimals.pADGTIC2dCorMax.ux, pos_optimals.pADGTIC2dCorMax.ly, pos_optimals.pADGTIC2dCorMax.uy, pos_optimals.pADGTIC2dCorInfMax.lx, pos_optimals.pADGTIC2dCorInfMax.ux, pos_optimals.pADGTIC2dCorInfMax.ly, pos_optimals.pADGTIC2dCorInfMax.uy, pos_optimals.pADGTIC2nndCorInfMax.lx, pos_optimals.pADGTIC2nndCorInfMax.ux, pos_optimals.pADGTIC2nndCorInfMax.ly, pos_optimals.pADGTIC2nndCorInfMax.uy];
        %         pADGTIC3(m,:) = [pos_optimals.pADGTIC3dCorMax.lx, pos_optimals.pADGTIC3dCorMax.ux, pos_optimals.pADGTIC3dCorMax.ly, pos_optimals.pADGTIC3dCorMax.uy, pos_optimals.pADGTIC3dCorInfMax.lx, pos_optimals.pADGTIC3dCorInfMax.ux, pos_optimals.pADGTIC3dCorInfMax.ly, pos_optimals.pADGTIC3dCorInfMax.uy, pos_optimals.pADGTIC3nndCorInfMax.lx, pos_optimals.pADGTIC3nndCorInfMax.ux, pos_optimals.pADGTIC3nndCorInfMax.ly, pos_optimals.pADGTIC3nndCorInfMax.uy];
        %
        %         ADsnpIC(m,:) = [pos_optimals.ADsnpIC.x, pos_optimals.ADsnpIC.y];
        %         ADdsnpIC(m,:) = [pos_optimals.ADdsnpIC.lx, pos_optimals.ADdsnpIC.ux, pos_optimals.ADdsnpIC.ly, pos_optimals.ADdsnpIC.uy];
        %         AKIC(m,:) = [pos_optimals.AKIC.x,pos_optimals.AKIC.y];
        %
        %         mikMax(m) = pos_optimals.mikMax;
        %         mikInfMax(m) = pos_optimals.mikInfMax;
        %
        %         pos_opt.ADGTIC1 = ADGTIC1;
        %         pos_opt.ADGTIC2 = ADGTIC2;
        %         pos_opt.ADGTIC3 = ADGTIC3;
        %         pos_opt.pADGTIC1 = pADGTIC1;
        %         pos_opt.pADGTIC2 = pADGTIC2;
        %         pos_opt.pADGTIC3 = pADGTIC3;
        %         pos_opt.ADsnpIC = ADsnpIC;
        %         pos_opt.ADdsnpIC = ADdsnpIC;
        %         pos_opt.AKIC = AKIC;
        %         pos_opt.mikMax = mikMax;
        %         pos_opt.mikInfMax = mikInfMax;
        %
        [null_optimals, null_stats(:,m), ~] = helper_r_evaluate_statistics_rest(xs,ys_null,nRandomisations,loc);
        %
        %         ADGTIC1(m,:) = [null_optimals.ADGTIC1dCorMax.lx, null_optimals.ADGTIC1dCorMax.ux, null_optimals.ADGTIC1dCorMax.ly, null_optimals.ADGTIC1dCorMax.uy, null_optimals.ADGTIC1dCorInfMax.lx, null_optimals.ADGTIC1dCorInfMax.ux, null_optimals.ADGTIC1dCorInfMax.ly, null_optimals.ADGTIC1dCorInfMax.uy, null_optimals.ADGTIC1nndCorInfMax.lx, null_optimals.ADGTIC1nndCorInfMax.ux, null_optimals.ADGTIC1nndCorInfMax.ly, null_optimals.ADGTIC1nndCorInfMax.uy,];
        %         ADGTIC2(m,:) = [null_optimals.ADGTIC2dCorMax.lx, null_optimals.ADGTIC2dCorMax.ux, null_optimals.ADGTIC2dCorMax.ly, null_optimals.ADGTIC2dCorMax.uy, null_optimals.ADGTIC2dCorInfMax.lx, null_optimals.ADGTIC2dCorInfMax.ux, null_optimals.ADGTIC2dCorInfMax.ly, null_optimals.ADGTIC2dCorInfMax.uy, null_optimals.ADGTIC2nndCorInfMax.lx, null_optimals.ADGTIC2nndCorInfMax.ux, null_optimals.ADGTIC2nndCorInfMax.ly, null_optimals.ADGTIC2nndCorInfMax.uy,];
        %         ADGTIC3(m,:) = [null_optimals.ADGTIC3dCorMax.lx, null_optimals.ADGTIC3dCorMax.ux, null_optimals.ADGTIC3dCorMax.ly, null_optimals.ADGTIC3dCorMax.uy, null_optimals.ADGTIC3dCorInfMax.lx, null_optimals.ADGTIC3dCorInfMax.ux, null_optimals.ADGTIC3dCorInfMax.ly, null_optimals.ADGTIC3dCorInfMax.uy, null_optimals.ADGTIC3nndCorInfMax.lx, null_optimals.ADGTIC3nndCorInfMax.ux, null_optimals.ADGTIC3nndCorInfMax.ly, null_optimals.ADGTIC3nndCorInfMax.uy,];
        %
        %         pADGTIC1(m,:) = [null_optimals.pADGTIC1dCorMax.lx, null_optimals.pADGTIC1dCorMax.ux, null_optimals.pADGTIC1dCorMax.ly, null_optimals.pADGTIC1dCorMax.uy, null_optimals.pADGTIC1dCorInfMax.lx, null_optimals.pADGTIC1dCorInfMax.ux, null_optimals.pADGTIC1dCorInfMax.ly, null_optimals.pADGTIC1dCorInfMax.uy, null_optimals.pADGTIC1nndCorInfMax.lx, null_optimals.pADGTIC1nndCorInfMax.ux, null_optimals.pADGTIC1nndCorInfMax.ly, null_optimals.pADGTIC1nndCorInfMax.uy,];
        %         pADGTIC2(m,:) = [null_optimals.pADGTIC2dCorMax.lx, null_optimals.pADGTIC2dCorMax.ux, null_optimals.pADGTIC2dCorMax.ly, null_optimals.pADGTIC2dCorMax.uy, null_optimals.pADGTIC2dCorInfMax.lx, null_optimals.pADGTIC2dCorInfMax.ux, null_optimals.pADGTIC2dCorInfMax.ly, null_optimals.pADGTIC2dCorInfMax.uy, null_optimals.pADGTIC2nndCorInfMax.lx, null_optimals.pADGTIC2nndCorInfMax.ux, null_optimals.pADGTIC2nndCorInfMax.ly, null_optimals.pADGTIC2nndCorInfMax.uy,];
        %         pADGTIC3(m,:) = [null_optimals.pADGTIC3dCorMax.lx, null_optimals.pADGTIC3dCorMax.ux, null_optimals.pADGTIC3dCorMax.ly, null_optimals.pADGTIC3dCorMax.uy, null_optimals.pADGTIC3dCorInfMax.lx, null_optimals.pADGTIC3dCorInfMax.ux, null_optimals.pADGTIC3dCorInfMax.ly, null_optimals.pADGTIC3dCorInfMax.uy, null_optimals.pADGTIC3nndCorInfMax.lx, null_optimals.pADGTIC3nndCorInfMax.ux, null_optimals.pADGTIC3nndCorInfMax.ly, null_optimals.pADGTIC3nndCorInfMax.uy,];
        %
        %         ADsnpIC(m,:) = [null_optimals.ADsnpIC.x, null_optimals.ADsnpIC.y];
        %         ADdsnpIC(m,:) = [null_optimals.ADdsnpIC.lx, null_optimals.ADdsnpIC.ux, null_optimals.ADdsnpIC.ly, null_optimals.ADdsnpIC.uy];
        %         AKIC(m,:) = [null_optimals.AKIC.x,null_optimals.AKIC.y];
        %
        %         mikMax(m) = null_optimals.mikMax;
        %         mikInfMax(m) = null_optimals.mikInfMax;
        %
        %         null_opt.ADGTIC1 = ADGTIC1;
        %         null_opt.ADGTIC2 = ADGTIC2;
        %         null_opt.ADGTIC3 = ADGTIC3;
        %         null_opt.pADGTIC1 = pADGTIC1;
        %         null_opt.pADGTIC2 = pADGTIC2;
        %         null_opt.pADGTIC3 = pADGTIC3;
        %         null_opt.ADsnpIC = ADsnpIC;
        %         null_opt.ADdsnpIC = ADdsnpIC;
        %         null_opt.AKIC = AKIC;
        %         null_opt.mikMax = mikMax;
        %         null_opt.mikInfMax = mikInfMax;
        
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
            
        case 'multigaussian',
            
            nCluster = 8;
            centroids = randi(500,nCluster,4);
            variances = randi(10,nCluster,4);
            remains = zeros(nCluster,1);
            remains(1) = mod(N,nCluster);
            samples = floor(N/nCluster)* ones(nCluster,1) + remains;
            
            count = 1;
            xy = zeros(N,4);
            for c = 1:nCluster
                for d = 1:4
                    xy(count:count+samples(c)-1,d) = normrnd(centroids(c,d),variances(c,d),[samples(c), 1]);
                end
                count = count + samples(c);
            end
            
            xs_regenerated = xy(:,1:2) + noise*randn(N,2);
            ys_regenerated = xy(:,3:4) + noise*randn(N,2);
            
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
    statnames{23} = 'AI - kMax';
    statnames{24} = 'AI - kInfMax';
    statnames{25} = 'pADGTIC1 - dCorMax';
    statnames{26} = 'pADGTIC1 - dCorInfMax';
    statnames{27} = 'pADGTIC1 - nndCorInfMax';
    statnames{28} = 'pADGTIC2 - dCorMax';
    statnames{29} = 'pADGTIC2 - dCorInfMax';
    statnames{30} = 'pADGTIC2 - nndCorInfMax';
    statnames{31} = 'pADGTIC3 - dCorMax';
    statnames{32} = 'pADGTIC3 - dCorInfMax';
    statnames{33} = 'pADGTIC3 - nndCorInfMax';
    
    % Record power calculations
    results.computation = computation;
    results.relationship = relationship;
    results.noise = noise;
    results.power = power;
    results.dpower = dpower;
    results.thresholds = thresholds;
    results.pos_stats = pos_stats;
    results.null_stats = null_stats;
    results.xs_sample = xs_regenerated;
    results.ys_sample = ys_regenerated;
    results.stat_names = statnames;
    %     results.pos_opt = pos_opt;
    %     results.null_opt = null_opt;
    
    % Save results for given relationship and noise level.
    save(['new_results/power_fdr/results_' num2str(run_num) '.mat'], 'results')
    
end

exit

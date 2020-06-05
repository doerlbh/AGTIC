% run noise calculation

% function run_noise_multiGaussian(loc,num_trials,nRandomisations)

% clear all
% close all
% clc
%
loc = 'doerlbh';
num_trials = 10;
nRandomisations = 10;
dim1 = 2;
dim2 = 5;

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

alpha = 0.05;
N = 50;
noise = 10;

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

%%
for m=1:num_trials
    
    % m = 1;
    
    is = randperm(N);
    disp(['__trial ' num2str(m)])
    
    nCluster = 5;
    centroids = randi(500,nCluster,dim1+dim2);
    variances = randi(10,nCluster,dim1+dim2);
    remains = zeros(nCluster,1);
    remains(1) = mod(N,nCluster);
    samples = floor(N/nCluster)* ones(nCluster,1) + remains;
    
    count = 1;
    xy = zeros(N,dim1+dim2);
    for c = 1:nCluster
        for d = 1:dim1+dim2
            xy(count:count+samples(c)-1,d) = normrnd(centroids(c,d),variances(c,d),[samples(c), 1]);
        end
        count = count + samples(c);
    end
    
    xs = xy(:,1:dim1) + noise*randn(N,dim1);
    ys = xy(:,dim1+1:dim1+dim2) + noise*randn(N,dim2);
    
    ys_null = ys(is,:);
    %%
    % Evaluate statistics on both positive and null data sets
    %         pos_stats(:,m) = helper_evaluate_statistics(xs,ys,nRandomisations,loc);
    %         [null_stats(:,m), stat_names] = helper_evaluate_statistics(xs,ys_null,nRandomisations,loc);
    
    [pos_optimals, pos_stats(:,m), ~] = helper_r_evaluate_statistics_arbDim(xs,ys,nRandomisations,loc);
    
    ADGTIC1(m,:) = [pos_optimals.ADGTIC1dCorMax.lx, pos_optimals.ADGTIC1dCorMax.ux, pos_optimals.ADGTIC1dCorMax.ly, pos_optimals.ADGTIC1dCorMax.uy, pos_optimals.ADGTIC1dCorInfMax.lx, pos_optimals.ADGTIC1dCorInfMax.ux, pos_optimals.ADGTIC1dCorInfMax.ly, pos_optimals.ADGTIC1dCorInfMax.uy, pos_optimals.ADGTIC1nndCorInfMax.lx, pos_optimals.ADGTIC1nndCorInfMax.ux, pos_optimals.ADGTIC1nndCorInfMax.ly, pos_optimals.ADGTIC1nndCorInfMax.uy];
    ADGTIC2(m,:) = [pos_optimals.ADGTIC2dCorMax.lx, pos_optimals.ADGTIC2dCorMax.ux, pos_optimals.ADGTIC2dCorMax.ly, pos_optimals.ADGTIC2dCorMax.uy, pos_optimals.ADGTIC2dCorInfMax.lx, pos_optimals.ADGTIC2dCorInfMax.ux, pos_optimals.ADGTIC2dCorInfMax.ly, pos_optimals.ADGTIC2dCorInfMax.uy, pos_optimals.ADGTIC2nndCorInfMax.lx, pos_optimals.ADGTIC2nndCorInfMax.ux, pos_optimals.ADGTIC2nndCorInfMax.ly, pos_optimals.ADGTIC2nndCorInfMax.uy];
    ADGTIC3(m,:) = [pos_optimals.ADGTIC3dCorMax.lx, pos_optimals.ADGTIC3dCorMax.ux, pos_optimals.ADGTIC3dCorMax.ly, pos_optimals.ADGTIC3dCorMax.uy, pos_optimals.ADGTIC3dCorInfMax.lx, pos_optimals.ADGTIC3dCorInfMax.ux, pos_optimals.ADGTIC3dCorInfMax.ly, pos_optimals.ADGTIC3dCorInfMax.uy, pos_optimals.ADGTIC3nndCorInfMax.lx, pos_optimals.ADGTIC3nndCorInfMax.ux, pos_optimals.ADGTIC3nndCorInfMax.ly, pos_optimals.ADGTIC3nndCorInfMax.uy];
    
    pADGTIC1(m,:) = [pos_optimals.pADGTIC1dCorMax.lx, pos_optimals.pADGTIC1dCorMax.ux, pos_optimals.pADGTIC1dCorMax.ly, pos_optimals.pADGTIC1dCorMax.uy, pos_optimals.pADGTIC1dCorInfMax.lx, pos_optimals.pADGTIC1dCorInfMax.ux, pos_optimals.pADGTIC1dCorInfMax.ly, pos_optimals.pADGTIC1dCorInfMax.uy, pos_optimals.pADGTIC1nndCorInfMax.lx, pos_optimals.pADGTIC1nndCorInfMax.ux, pos_optimals.pADGTIC1nndCorInfMax.ly, pos_optimals.pADGTIC1nndCorInfMax.uy];
    pADGTIC2(m,:) = [pos_optimals.pADGTIC2dCorMax.lx, pos_optimals.pADGTIC2dCorMax.ux, pos_optimals.pADGTIC2dCorMax.ly, pos_optimals.pADGTIC2dCorMax.uy, pos_optimals.pADGTIC2dCorInfMax.lx, pos_optimals.pADGTIC2dCorInfMax.ux, pos_optimals.pADGTIC2dCorInfMax.ly, pos_optimals.pADGTIC2dCorInfMax.uy, pos_optimals.pADGTIC2nndCorInfMax.lx, pos_optimals.pADGTIC2nndCorInfMax.ux, pos_optimals.pADGTIC2nndCorInfMax.ly, pos_optimals.pADGTIC2nndCorInfMax.uy];
    pADGTIC3(m,:) = [pos_optimals.pADGTIC3dCorMax.lx, pos_optimals.pADGTIC3dCorMax.ux, pos_optimals.pADGTIC3dCorMax.ly, pos_optimals.pADGTIC3dCorMax.uy, pos_optimals.pADGTIC3dCorInfMax.lx, pos_optimals.pADGTIC3dCorInfMax.ux, pos_optimals.pADGTIC3dCorInfMax.ly, pos_optimals.pADGTIC3dCorInfMax.uy, pos_optimals.pADGTIC3nndCorInfMax.lx, pos_optimals.pADGTIC3nndCorInfMax.ux, pos_optimals.pADGTIC3nndCorInfMax.ly, pos_optimals.pADGTIC3nndCorInfMax.uy];
    
    ADsnpIC(m,:) = [pos_optimals.ADsnpIC.x, pos_optimals.ADsnpIC.y];
    ADdsnpIC(m,:) = [pos_optimals.ADdsnpIC.lx, pos_optimals.ADdsnpIC.ux, pos_optimals.ADdsnpIC.ly, pos_optimals.ADdsnpIC.uy];
    AKIC(m,:) = [pos_optimals.AKIC.x,pos_optimals.AKIC.y];
    
%     mikMax(m) = pos_optimals.mikMax;
%     mikInfMax(m) = pos_optimals.mikInfMax;
    
    pos_opt.ADGTIC1 = ADGTIC1;
    pos_opt.ADGTIC2 = ADGTIC2;
    pos_opt.ADGTIC3 = ADGTIC3;
    pos_opt.pADGTIC1 = pADGTIC1;
    pos_opt.pADGTIC2 = pADGTIC2;
    pos_opt.pADGTIC3 = pADGTIC3;
    pos_opt.ADsnpIC = ADsnpIC;
    pos_opt.ADdsnpIC = ADdsnpIC;
    pos_opt.AKIC = AKIC;
%     pos_opt.mikMax = mikMax;
%     pos_opt.mikInfMax = mikInfMax;
    
    [null_optimals, null_stats(:,m), ~] = helper_r_evaluate_statistics_arbDim(xs,ys_null,nRandomisations,loc);
    
    ADGTIC1(m,:) = [null_optimals.ADGTIC1dCorMax.lx, null_optimals.ADGTIC1dCorMax.ux, null_optimals.ADGTIC1dCorMax.ly, null_optimals.ADGTIC1dCorMax.uy, null_optimals.ADGTIC1dCorInfMax.lx, null_optimals.ADGTIC1dCorInfMax.ux, null_optimals.ADGTIC1dCorInfMax.ly, null_optimals.ADGTIC1dCorInfMax.uy, null_optimals.ADGTIC1nndCorInfMax.lx, null_optimals.ADGTIC1nndCorInfMax.ux, null_optimals.ADGTIC1nndCorInfMax.ly, null_optimals.ADGTIC1nndCorInfMax.uy,];
    ADGTIC2(m,:) = [null_optimals.ADGTIC2dCorMax.lx, null_optimals.ADGTIC2dCorMax.ux, null_optimals.ADGTIC2dCorMax.ly, null_optimals.ADGTIC2dCorMax.uy, null_optimals.ADGTIC2dCorInfMax.lx, null_optimals.ADGTIC2dCorInfMax.ux, null_optimals.ADGTIC2dCorInfMax.ly, null_optimals.ADGTIC2dCorInfMax.uy, null_optimals.ADGTIC2nndCorInfMax.lx, null_optimals.ADGTIC2nndCorInfMax.ux, null_optimals.ADGTIC2nndCorInfMax.ly, null_optimals.ADGTIC2nndCorInfMax.uy,];
    ADGTIC3(m,:) = [null_optimals.ADGTIC3dCorMax.lx, null_optimals.ADGTIC3dCorMax.ux, null_optimals.ADGTIC3dCorMax.ly, null_optimals.ADGTIC3dCorMax.uy, null_optimals.ADGTIC3dCorInfMax.lx, null_optimals.ADGTIC3dCorInfMax.ux, null_optimals.ADGTIC3dCorInfMax.ly, null_optimals.ADGTIC3dCorInfMax.uy, null_optimals.ADGTIC3nndCorInfMax.lx, null_optimals.ADGTIC3nndCorInfMax.ux, null_optimals.ADGTIC3nndCorInfMax.ly, null_optimals.ADGTIC3nndCorInfMax.uy,];
    
    pADGTIC1(m,:) = [null_optimals.pADGTIC1dCorMax.lx, null_optimals.pADGTIC1dCorMax.ux, null_optimals.pADGTIC1dCorMax.ly, null_optimals.pADGTIC1dCorMax.uy, null_optimals.pADGTIC1dCorInfMax.lx, null_optimals.pADGTIC1dCorInfMax.ux, null_optimals.pADGTIC1dCorInfMax.ly, null_optimals.pADGTIC1dCorInfMax.uy, null_optimals.pADGTIC1nndCorInfMax.lx, null_optimals.pADGTIC1nndCorInfMax.ux, null_optimals.pADGTIC1nndCorInfMax.ly, null_optimals.pADGTIC1nndCorInfMax.uy,];
    pADGTIC2(m,:) = [null_optimals.pADGTIC2dCorMax.lx, null_optimals.pADGTIC2dCorMax.ux, null_optimals.pADGTIC2dCorMax.ly, null_optimals.pADGTIC2dCorMax.uy, null_optimals.pADGTIC2dCorInfMax.lx, null_optimals.pADGTIC2dCorInfMax.ux, null_optimals.pADGTIC2dCorInfMax.ly, null_optimals.pADGTIC2dCorInfMax.uy, null_optimals.pADGTIC2nndCorInfMax.lx, null_optimals.pADGTIC2nndCorInfMax.ux, null_optimals.pADGTIC2nndCorInfMax.ly, null_optimals.pADGTIC2nndCorInfMax.uy,];
    pADGTIC3(m,:) = [null_optimals.pADGTIC3dCorMax.lx, null_optimals.pADGTIC3dCorMax.ux, null_optimals.pADGTIC3dCorMax.ly, null_optimals.pADGTIC3dCorMax.uy, null_optimals.pADGTIC3dCorInfMax.lx, null_optimals.pADGTIC3dCorInfMax.ux, null_optimals.pADGTIC3dCorInfMax.ly, null_optimals.pADGTIC3dCorInfMax.uy, null_optimals.pADGTIC3nndCorInfMax.lx, null_optimals.pADGTIC3nndCorInfMax.ux, null_optimals.pADGTIC3nndCorInfMax.ly, null_optimals.pADGTIC3nndCorInfMax.uy,];
    
    ADsnpIC(m,:) = [null_optimals.ADsnpIC.x, null_optimals.ADsnpIC.y];
    ADdsnpIC(m,:) = [null_optimals.ADdsnpIC.lx, null_optimals.ADdsnpIC.ux, null_optimals.ADdsnpIC.ly, null_optimals.ADdsnpIC.uy];
    AKIC(m,:) = [null_optimals.AKIC.x,null_optimals.AKIC.y];
    
%     mikMax(m) = null_optimals.mikMax;
%     mikInfMax(m) = null_optimals.mikInfMax;
     
    null_opt.ADGTIC1 = ADGTIC1;
    null_opt.ADGTIC2 = ADGTIC2;
    null_opt.ADGTIC3 = ADGTIC3;
    null_opt.pADGTIC1 = pADGTIC1;
    null_opt.pADGTIC2 = pADGTIC2;
    null_opt.pADGTIC3 = pADGTIC3;
    null_opt.ADsnpIC = ADsnpIC;
    null_opt.ADdsnpIC = ADdsnpIC;
    null_opt.AKIC = AKIC;
%     null_opt.mikMax = mikMax;
%     null_opt.mikInfMax = mikInfMax;
    
end

%%

% Compute empirical power of all statistics tested
thresholds = repmat(helper_quantile(null_stats(:,1:10),1-alpha,2),1,num_trials);
successes = sum((pos_stats(:,1:10) > thresholds),2);
power = successes/num_trials;
dpower = sqrt(power.*(1-power)./num_trials);

nCluster = 5;
centroids = randi(500,nCluster,dim1+dim2);
variances = randi(10,nCluster,dim1+dim2);
remains = zeros(nCluster,1);
remains(1) = mod(N,nCluster);
samples = floor(N/nCluster)* ones(nCluster,1) + remains;

count = 1;
xy = zeros(N,dim1+dim2);
for c = 1:nCluster
    for d = 1:dim1+dim2
        xy(count:count+samples(c)-1,d) = normrnd(centroids(c,d),variances(c,d),[samples(c), 1]);
    end
    count = count + samples(c);
end

xs_regenerated = xy(:,1:dim1) + noise*randn(N,dim1);
ys_regenerated = xy(:,dim1+1:dim1+dim2) + noise*randn(N,dim2);

statnames = {};
statnames{1} = 'dCor';
statnames{2} = 'ADGTIC1 - dCorMax';
statnames{3} = 'ADGTIC1 - dCorInfMax';
statnames{4} = 'ADGTIC1 - nndCorInfMax';
statnames{5} = 'ADGTIC2 - dCorMax';
statnames{6} = 'ADGTIC2 - dCorInfMax';
statnames{7} = 'ADGTIC2 - nndCorInfMax';
statnames{8} = 'ADGTIC3 - dCorMax';
statnames{9} = 'ADGTIC3 - dCorInfMax';
statnames{10} = 'ADGTIC3 - nndCorInfMax';
statnames{11} = 'ADIC - snpInf';
statnames{12} = 'ADIC - dsnpInf';
statnames{13} = 'HSIC';
statnames{14} = 'AKIC';
statnames{15} = 'rdmCor';
statnames{16} = 'CD3';
statnames{17} = 'pADGTIC1 - dCorMax';
statnames{18} = 'pADGTIC1 - dCorInfMax';
statnames{19} = 'pADGTIC1 - nndCorInfMax';
statnames{20} = 'pADGTIC2 - dCorMax';
statnames{21} = 'pADGTIC2 - dCorInfMax';
statnames{22} = 'pADGTIC2 - nndCorInfMax';
statnames{23} = 'pADGTIC3 - dCorMax';
statnames{24} = 'pADGTIC3 - dCorInfMax';
statnames{25} = 'pADGTIC3 - nndCorInfMax';

% Record power calculations
results.noise = noise;
results.power = power;
results.dpower = dpower;
results.thresholds = thresholds;
results.pos_stats = pos_stats;
results.null_stats = null_stats;
results.xs_sample = xs_regenerated;
results.ys_sample = ys_regenerated;
results.stat_names = statnames;
results.pos_opt = pos_opt;
results.null_opt = null_opt;

% Save results for given relationship and noise level.
save('new_results/power_fdr/multiGaussian.mat', 'results')

% exit

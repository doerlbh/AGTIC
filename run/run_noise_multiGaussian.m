% run noise calculation

% function run_noise_multiGaussian(loc,num_trials,nRandomisations)

% clear all
% close all
% clc
%

% loc = 'doerlbh';
loc = 'amath';
num_trials = 50;
nRandomisations = 5;

dim1 = 5;
dim2 = 25;

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
N = 200;
noise = 5;

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
    
    ADGTIC1(m,:) = [pos_optimals.ADGTIC1dCorMax.lx(1), pos_optimals.ADGTIC1dCorMax.ux(1), pos_optimals.ADGTIC1dCorMax.ly(1), pos_optimals.ADGTIC1dCorMax.uy(1), pos_optimals.ADGTIC1dCorInfMax.lx(1), pos_optimals.ADGTIC1dCorInfMax.ux(1), pos_optimals.ADGTIC1dCorInfMax.ly(1), pos_optimals.ADGTIC1dCorInfMax.uy(1), pos_optimals.ADGTIC1nndCorInfMax.lx(1), pos_optimals.ADGTIC1nndCorInfMax.ux(1), pos_optimals.ADGTIC1nndCorInfMax.ly(1), pos_optimals.ADGTIC1nndCorInfMax.uy(1)];
    ADGTIC2(m,:) = [pos_optimals.ADGTIC2dCorMax.lx(1), pos_optimals.ADGTIC2dCorMax.ux(1), pos_optimals.ADGTIC2dCorMax.ly(1), pos_optimals.ADGTIC2dCorMax.uy(1), pos_optimals.ADGTIC2dCorInfMax.lx(1), pos_optimals.ADGTIC2dCorInfMax.ux(1), pos_optimals.ADGTIC2dCorInfMax.ly(1), pos_optimals.ADGTIC2dCorInfMax.uy(1), pos_optimals.ADGTIC2nndCorInfMax.lx(1), pos_optimals.ADGTIC2nndCorInfMax.ux(1), pos_optimals.ADGTIC2nndCorInfMax.ly(1), pos_optimals.ADGTIC2nndCorInfMax.uy(1)];
    ADGTIC3(m,:) = [pos_optimals.ADGTIC3dCorMax.lx(1), pos_optimals.ADGTIC3dCorMax.ux(1), pos_optimals.ADGTIC3dCorMax.ly(1), pos_optimals.ADGTIC3dCorMax.uy(1), pos_optimals.ADGTIC3dCorInfMax.lx(1), pos_optimals.ADGTIC3dCorInfMax.ux(1), pos_optimals.ADGTIC3dCorInfMax.ly(1), pos_optimals.ADGTIC3dCorInfMax.uy(1), pos_optimals.ADGTIC3nndCorInfMax.lx(1), pos_optimals.ADGTIC3nndCorInfMax.ux(1), pos_optimals.ADGTIC3nndCorInfMax.ly(1), pos_optimals.ADGTIC3nndCorInfMax.uy(1)];
    
    pADGTIC1(m,:) = [pos_optimals.pADGTIC1dCorMax.lx(1), pos_optimals.pADGTIC1dCorMax.ux(1), pos_optimals.pADGTIC1dCorMax.ly(1), pos_optimals.pADGTIC1dCorMax.uy(1), pos_optimals.pADGTIC1dCorInfMax.lx(1), pos_optimals.pADGTIC1dCorInfMax.ux(1), pos_optimals.pADGTIC1dCorInfMax.ly(1), pos_optimals.pADGTIC1dCorInfMax.uy(1), pos_optimals.pADGTIC1nndCorInfMax.lx(1), pos_optimals.pADGTIC1nndCorInfMax.ux(1), pos_optimals.pADGTIC1nndCorInfMax.ly(1), pos_optimals.pADGTIC1nndCorInfMax.uy(1)];
    pADGTIC2(m,:) = [pos_optimals.pADGTIC2dCorMax.lx(1), pos_optimals.pADGTIC2dCorMax.ux(1), pos_optimals.pADGTIC2dCorMax.ly(1), pos_optimals.pADGTIC2dCorMax.uy(1), pos_optimals.pADGTIC2dCorInfMax.lx(1), pos_optimals.pADGTIC2dCorInfMax.ux(1), pos_optimals.pADGTIC2dCorInfMax.ly(1), pos_optimals.pADGTIC2dCorInfMax.uy(1), pos_optimals.pADGTIC2nndCorInfMax.lx(1), pos_optimals.pADGTIC2nndCorInfMax.ux(1), pos_optimals.pADGTIC2nndCorInfMax.ly(1), pos_optimals.pADGTIC2nndCorInfMax.uy(1)];
    pADGTIC3(m,:) = [pos_optimals.pADGTIC3dCorMax.lx(1), pos_optimals.pADGTIC3dCorMax.ux(1), pos_optimals.pADGTIC3dCorMax.ly(1), pos_optimals.pADGTIC3dCorMax.uy(1), pos_optimals.pADGTIC3dCorInfMax.lx(1), pos_optimals.pADGTIC3dCorInfMax.ux(1), pos_optimals.pADGTIC3dCorInfMax.ly(1), pos_optimals.pADGTIC3dCorInfMax.uy(1), pos_optimals.pADGTIC3nndCorInfMax.lx(1), pos_optimals.pADGTIC3nndCorInfMax.ux(1), pos_optimals.pADGTIC3nndCorInfMax.ly(1), pos_optimals.pADGTIC3nndCorInfMax.uy(1)];
    
%     size(ADsnpIC(m,:))
%     size([pos_optimals.ADsnpIC.x, pos_optimals.ADsnpIC.y])
    
    ADsnpIC(m,:) = [pos_optimals.ADsnpIC.x(1), pos_optimals.ADsnpIC.y(1)];
    
%     size(ADdsnpIC(m,:))
%     size([pos_optimals.ADdsnpIC.lx, pos_optimals.ADdsnpIC.ux, pos_optimals.ADdsnpIC.ly, pos_optimals.ADdsnpIC.uy])
    
    ADdsnpIC(m,:) = [pos_optimals.ADdsnpIC.lx(1), pos_optimals.ADdsnpIC.ux(1), pos_optimals.ADdsnpIC.ly(1), pos_optimals.ADdsnpIC.uy(1)];
    AKIC(m,:) = [pos_optimals.AKIC.x(1),pos_optimals.AKIC.y(1)];
    
%     mikMax(m) = pos_optimals.mikMax;
%     mikInfMax(m) = pos_optimals.mikInfMax;
    
    [null_optimals, null_stats(:,m), ~] = helper_r_evaluate_statistics_arbDim(xs,ys_null,nRandomisations,loc);
    
    ADGTIC1(num_trials+m,:) = [null_optimals.ADGTIC1dCorMax.lx(1), null_optimals.ADGTIC1dCorMax.ux(1), null_optimals.ADGTIC1dCorMax.ly(1), null_optimals.ADGTIC1dCorMax.uy(1), null_optimals.ADGTIC1dCorInfMax.lx(1), null_optimals.ADGTIC1dCorInfMax.ux(1), null_optimals.ADGTIC1dCorInfMax.ly(1), null_optimals.ADGTIC1dCorInfMax.uy(1), null_optimals.ADGTIC1nndCorInfMax.lx(1), null_optimals.ADGTIC1nndCorInfMax.ux(1), null_optimals.ADGTIC1nndCorInfMax.ly(1), null_optimals.ADGTIC1nndCorInfMax.uy(1)];
    ADGTIC2(num_trials+m,:) = [null_optimals.ADGTIC2dCorMax.lx(1), null_optimals.ADGTIC2dCorMax.ux(1), null_optimals.ADGTIC2dCorMax.ly(1), null_optimals.ADGTIC2dCorMax.uy(1), null_optimals.ADGTIC2dCorInfMax.lx(1), null_optimals.ADGTIC2dCorInfMax.ux(1), null_optimals.ADGTIC2dCorInfMax.ly(1), null_optimals.ADGTIC2dCorInfMax.uy(1), null_optimals.ADGTIC2nndCorInfMax.lx(1), null_optimals.ADGTIC2nndCorInfMax.ux(1), null_optimals.ADGTIC2nndCorInfMax.ly(1), null_optimals.ADGTIC2nndCorInfMax.uy(1)];
    ADGTIC3(num_trials+m,:) = [null_optimals.ADGTIC3dCorMax.lx(1), null_optimals.ADGTIC3dCorMax.ux(1), null_optimals.ADGTIC3dCorMax.ly(1), null_optimals.ADGTIC3dCorMax.uy(1), null_optimals.ADGTIC3dCorInfMax.lx(1), null_optimals.ADGTIC3dCorInfMax.ux(1), null_optimals.ADGTIC3dCorInfMax.ly(1), null_optimals.ADGTIC3dCorInfMax.uy(1), null_optimals.ADGTIC3nndCorInfMax.lx(1), null_optimals.ADGTIC3nndCorInfMax.ux(1), null_optimals.ADGTIC3nndCorInfMax.ly(1), null_optimals.ADGTIC3nndCorInfMax.uy(1)];
    
    pADGTIC1(num_trials+m,:) = [null_optimals.pADGTIC1dCorMax.lx(1), null_optimals.pADGTIC1dCorMax.ux(1), null_optimals.pADGTIC1dCorMax.ly(1), null_optimals.pADGTIC1dCorMax.uy(1), null_optimals.pADGTIC1dCorInfMax.lx(1), null_optimals.pADGTIC1dCorInfMax.ux(1), null_optimals.pADGTIC1dCorInfMax.ly(1), null_optimals.pADGTIC1dCorInfMax.uy(1), null_optimals.pADGTIC1nndCorInfMax.lx(1), null_optimals.pADGTIC1nndCorInfMax.ux(1), null_optimals.pADGTIC1nndCorInfMax.ly(1), null_optimals.pADGTIC1nndCorInfMax.uy(1)];
    pADGTIC2(num_trials+m,:) = [null_optimals.pADGTIC2dCorMax.lx(1), null_optimals.pADGTIC2dCorMax.ux(1), null_optimals.pADGTIC2dCorMax.ly(1), null_optimals.pADGTIC2dCorMax.uy(1), null_optimals.pADGTIC2dCorInfMax.lx(1), null_optimals.pADGTIC2dCorInfMax.ux(1), null_optimals.pADGTIC2dCorInfMax.ly(1), null_optimals.pADGTIC2dCorInfMax.uy(1), null_optimals.pADGTIC2nndCorInfMax.lx(1), null_optimals.pADGTIC2nndCorInfMax.ux(1), null_optimals.pADGTIC2nndCorInfMax.ly(1), null_optimals.pADGTIC2nndCorInfMax.uy(1)];
    pADGTIC3(num_trials+m,:) = [null_optimals.pADGTIC3dCorMax.lx(1), null_optimals.pADGTIC3dCorMax.ux(1), null_optimals.pADGTIC3dCorMax.ly(1), null_optimals.pADGTIC3dCorMax.uy(1), null_optimals.pADGTIC3dCorInfMax.lx(1), null_optimals.pADGTIC3dCorInfMax.ux(1), null_optimals.pADGTIC3dCorInfMax.ly(1), null_optimals.pADGTIC3dCorInfMax.uy(1), null_optimals.pADGTIC3nndCorInfMax.lx(1), null_optimals.pADGTIC3nndCorInfMax.ux(1), null_optimals.pADGTIC3nndCorInfMax.ly(1), null_optimals.pADGTIC3nndCorInfMax.uy(1)];
    
%     size(ADsnpIC(num_trials+m,:))
%     size([null_optimals.ADsnpIC.x, null_optimals.ADsnpIC.y])
    
    ADsnpIC(num_trials+m,:) = [null_optimals.ADsnpIC.x(1), null_optimals.ADsnpIC.y(1)];
    
%     size(ADdsnpIC(num_trials+m,:))
%     size([null_optimals.ADdsnpIC.lx, null_optimals.ADdsnpIC.ux, null_optimals.ADdsnpIC.ly, null_optimals.ADdsnpIC.uy])
    
    ADdsnpIC(num_trials+m,:) = [null_optimals.ADdsnpIC.lx(1), null_optimals.ADdsnpIC.ux(1), null_optimals.ADdsnpIC.ly(1), null_optimals.ADdsnpIC.uy(1)];
    AKIC(num_trials+m,:) = [null_optimals.AKIC.x(1),null_optimals.AKIC.y(1)];
    
%     mikMax(num_trials+m) = null_optimals.mikMax;
%     mikInfMax(num_trials+m) = null_optimals.mikInfMax;
     
 
    
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
%     pos_opt.mikMax = mikMax(1:num_trials);
%     pos_opt.mikInfMax = mikInfMax(1:num_trials);

   null_opt.ADGTIC1 = ADGTIC1(1+num_trials:num_trials*2,:);
    null_opt.ADGTIC2 = ADGTIC2(1+num_trials:num_trials*2,:);
    null_opt.ADGTIC3 = ADGTIC3(1+num_trials:num_trials*2,:);
    null_opt.pADGTIC1 = pADGTIC1(1+num_trials:num_trials*2,:);
    null_opt.pADGTIC2 = pADGTIC2(1+num_trials:num_trials*2,:);
    null_opt.pADGTIC3 = pADGTIC3(1+num_trials:num_trials*2,:);
    null_opt.ADsnpIC = ADsnpIC(1+num_trials:num_trials*2,:);
    null_opt.ADdsnpIC = ADdsnpIC(1+num_trials:num_trials*2,:);
    null_opt.AKIC = AKIC(1+num_trials:num_trials*2,:);
%     null_opt.mikMax = mikMax(1+num_trials:num_trials*2);
%     null_opt.mikInfMax = mikInfMax(1+num_trials:num_trials*2);

% Compute empirical power of all statistics tested
thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
successes = sum((pos_stats > thresholds),2);
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
save('new_results/power_fdr/new_multiGaussian.mat', 'results')

% exit

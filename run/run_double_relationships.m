% run power calculation

function run_double_relationships(loc,type)

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

nRandomisations = 100;
alpha = 0.05;

%%

N = 50000;
noisec = 0;
noise = 30;

% checkerboards
xcs = helper_randint(20,N);
ycs = 2*helper_randint(10,N) + mod(xcs,2);
xs = 10*(xcs + rand(N,1)) + noisec*randn(N,1);
ys = 10*(ycs + rand(N,1)) + noisec*randn(N,1);

% linear
islinear = [ys < xs + noise] .* [ys > xs - noise];
xsl = xs(islinear == 1);
ysl = ys(islinear == 1);
perm = randperm(sum(islinear), 5000);
xsl = xsl(perm);
ysl = ysl(perm);

% parabolic
isparabolic = [ys < 30 + (1/10)*((xs - 100).^2) + noise] .* [ys > 30 + (1/10)*((xs - 100).^2) - noise];
xsp = xs(isparabolic == 1);
ysp = ys(isparabolic == 1);
perm = randperm(sum(isparabolic), 5000);
xsp = xsp(perm);
ysp = ysp(perm);

% sinusoidal
issinusoidal = [ys < 100 + 40 * sin(xs/10 - 20) + noise] .* [ys > 100 + 40 * sin(xs/10 - 20) - noise];
xss = xs(issinusoidal == 1);
yss = ys(issinusoidal == 1);
perm = randperm(sum(issinusoidal), 5000);
xss = xss(perm);
yss = yss(perm);

% circular
iscircular = [(xs-100).^2 + (ys-100).^2 > 50^2] .* [(xs-100).^2 + (ys-100).^2 < 70^2];
xsc = xs(iscircular == 1);
ysc = ys(iscircular == 1);
perm = randperm(sum(iscircular), 5000);
xsc = xsc(perm);
ysc = ysc(perm);

%% plot sampling

isPlot = 0;

if isPlot
    
    nSamp = 5;
    ms = 10;
    nObsLog = logspace(1,0,nSamp)*100;
    
    for ns = 1:nSamp
        
        %     nObs = ns*200;
        nObs = ceil(nObsLog(ns));
        perm = randperm(5000, nObs);
        
        subplot(nSamp,4,(ns-1)*4+1)
        plot(xsl(perm),ysl(perm),'.','MarkerSize',ms);
        title(['l on k, n = ' num2str(nObs)]);
        
        subplot(nSamp,4,(ns-1)*4+2)
        plot(xsp(perm),ysp(perm),'.','MarkerSize',ms);
        title(['p on k, n = ' num2str(nObs)]);
        
        subplot(nSamp,4,(ns-1)*4+3)
        plot(xss(perm),yss(perm),'.','MarkerSize',ms);
        title(['s on k, n = ' num2str(nObs)]);
        
        subplot(nSamp,4,(ns-1)*4+4)
        plot(xsc(perm),ysc(perm),'.','MarkerSize',ms);
        title(['c on k, n = ' num2str(nObs)]);
        
    end
    
end

%% general variables

nSamp = 10;
% ms = 10;
% nObsLog = logspace(1,0,nSamp)*100;

disp('start...')
num_trials = nRandomisations;

ADGTIC1 = zeros(nSamp,num_trials*2,12);
ADGTIC2 = zeros(nSamp,num_trials*2,12);
ADGTIC3 = zeros(nSamp,num_trials*2,12);
pADGTIC1 = zeros(nSamp,num_trials*2,12);
pADGTIC2 = zeros(nSamp,num_trials*2,12);
pADGTIC3 = zeros(nSamp,num_trials*2,12);
ADsnpIC = zeros(nSamp,num_trials*2,2);
ADdsnpIC = zeros(nSamp,num_trials*2,4);
AKIC = zeros(nSamp,num_trials*2,2);
mikMax = zeros(nSamp,num_trials*2,1);
mikInfMax = zeros(nSamp,num_trials*2,1);

for n = 1:nSamp
    
    nObs = n*100;
%     N = nObs;
    %     nObs = ceil(nObsLog(ns));
    perm = randperm(5000, nObs);
    
    switch type
        case 'l',
            xs = xsl(perm);
            ys = ysl(perm);
        case 'p',
            xs = xsp(perm);
            ys = ysp(perm);
        case 's',
            xs = xss(perm);
            ys = yss(perm);
        case 'c',
            xs = xsc(perm);
            ys = ysc(perm);
        otherwise,
            disp('PROBLEM!')
    end
    
    
    for m = 1:num_trials
        
        disp(['___nObs:' num2str(n) '*100 run ' num2str(m)])
        
        [pos_optimals, pos_stats(:,m), ~] = helper_r_fine_evaluate_statistics(xs,ys,nRandomisations,loc);
        
        ADGTIC1(n,m,:) = [pos_optimals.ADGTIC1dCorMax.lx, pos_optimals.ADGTIC1dCorMax.ux, pos_optimals.ADGTIC1dCorMax.ly, pos_optimals.ADGTIC1dCorMax.uy, pos_optimals.ADGTIC1dCorInfMax.lx, pos_optimals.ADGTIC1dCorInfMax.ux, pos_optimals.ADGTIC1dCorInfMax.ly, pos_optimals.ADGTIC1dCorInfMax.uy, pos_optimals.ADGTIC1nndCorInfMax.lx, pos_optimals.ADGTIC1nndCorInfMax.ux, pos_optimals.ADGTIC1nndCorInfMax.ly, pos_optimals.ADGTIC1nndCorInfMax.uy];
        ADGTIC2(n,m,:) = [pos_optimals.ADGTIC2dCorMax.lx, pos_optimals.ADGTIC2dCorMax.ux, pos_optimals.ADGTIC2dCorMax.ly, pos_optimals.ADGTIC2dCorMax.uy, pos_optimals.ADGTIC2dCorInfMax.lx, pos_optimals.ADGTIC2dCorInfMax.ux, pos_optimals.ADGTIC2dCorInfMax.ly, pos_optimals.ADGTIC2dCorInfMax.uy, pos_optimals.ADGTIC2nndCorInfMax.lx, pos_optimals.ADGTIC2nndCorInfMax.ux, pos_optimals.ADGTIC2nndCorInfMax.ly, pos_optimals.ADGTIC2nndCorInfMax.uy];
        ADGTIC3(n,m,:) = [pos_optimals.ADGTIC3dCorMax.lx, pos_optimals.ADGTIC3dCorMax.ux, pos_optimals.ADGTIC3dCorMax.ly, pos_optimals.ADGTIC3dCorMax.uy, pos_optimals.ADGTIC3dCorInfMax.lx, pos_optimals.ADGTIC3dCorInfMax.ux, pos_optimals.ADGTIC3dCorInfMax.ly, pos_optimals.ADGTIC3dCorInfMax.uy, pos_optimals.ADGTIC3nndCorInfMax.lx, pos_optimals.ADGTIC3nndCorInfMax.ux, pos_optimals.ADGTIC3nndCorInfMax.ly, pos_optimals.ADGTIC3nndCorInfMax.uy];
        
        pADGTIC1(n,m,:) = [pos_optimals.pADGTIC1dCorMax.lx, pos_optimals.pADGTIC1dCorMax.ux, pos_optimals.pADGTIC1dCorMax.ly, pos_optimals.pADGTIC1dCorMax.uy, pos_optimals.pADGTIC1dCorInfMax.lx, pos_optimals.pADGTIC1dCorInfMax.ux, pos_optimals.pADGTIC1dCorInfMax.ly, pos_optimals.pADGTIC1dCorInfMax.uy, pos_optimals.pADGTIC1nndCorInfMax.lx, pos_optimals.pADGTIC1nndCorInfMax.ux, pos_optimals.pADGTIC1nndCorInfMax.ly, pos_optimals.pADGTIC1nndCorInfMax.uy];
        pADGTIC2(n,m,:) = [pos_optimals.pADGTIC2dCorMax.lx, pos_optimals.pADGTIC2dCorMax.ux, pos_optimals.pADGTIC2dCorMax.ly, pos_optimals.pADGTIC2dCorMax.uy, pos_optimals.pADGTIC2dCorInfMax.lx, pos_optimals.pADGTIC2dCorInfMax.ux, pos_optimals.pADGTIC2dCorInfMax.ly, pos_optimals.pADGTIC2dCorInfMax.uy, pos_optimals.pADGTIC2nndCorInfMax.lx, pos_optimals.pADGTIC2nndCorInfMax.ux, pos_optimals.pADGTIC2nndCorInfMax.ly, pos_optimals.pADGTIC2nndCorInfMax.uy];
        pADGTIC3(n,m,:) = [pos_optimals.pADGTIC3dCorMax.lx, pos_optimals.pADGTIC3dCorMax.ux, pos_optimals.pADGTIC3dCorMax.ly, pos_optimals.pADGTIC3dCorMax.uy, pos_optimals.pADGTIC3dCorInfMax.lx, pos_optimals.pADGTIC3dCorInfMax.ux, pos_optimals.pADGTIC3dCorInfMax.ly, pos_optimals.pADGTIC3dCorInfMax.uy, pos_optimals.pADGTIC3nndCorInfMax.lx, pos_optimals.pADGTIC3nndCorInfMax.ux, pos_optimals.pADGTIC3nndCorInfMax.ly, pos_optimals.pADGTIC3nndCorInfMax.uy];
        
        ADsnpIC(n,m,:) = [pos_optimals.ADsnpIC.x, pos_optimals.ADsnpIC.y];
        ADdsnpIC(n,m,:) = [pos_optimals.ADdsnpIC.lx, pos_optimals.ADdsnpIC.ux, pos_optimals.ADdsnpIC.ly, pos_optimals.ADdsnpIC.uy];
        AKIC(n,m,:) = [pos_optimals.AKIC.x,pos_optimals.AKIC.y];
        
        mikMax(n,m) = pos_optimals.mikMax;
        mikInfMax(n,m) = pos_optimals.mikInfMax;
        
        [null_optimals, null_stats(:,m), ~] = helper_r_fine_evaluate_statistics(xs,ys(randperm(nObs)),nRandomisations,loc);
        
        ADGTIC1(n,num_trials+m,:) = [null_optimals.ADGTIC1dCorMax.lx, null_optimals.ADGTIC1dCorMax.ux, null_optimals.ADGTIC1dCorMax.ly, null_optimals.ADGTIC1dCorMax.uy, null_optimals.ADGTIC1dCorInfMax.lx, null_optimals.ADGTIC1dCorInfMax.ux, null_optimals.ADGTIC1dCorInfMax.ly, null_optimals.ADGTIC1dCorInfMax.uy, null_optimals.ADGTIC1nndCorInfMax.lx, null_optimals.ADGTIC1nndCorInfMax.ux, null_optimals.ADGTIC1nndCorInfMax.ly, null_optimals.ADGTIC1nndCorInfMax.uy,];
        ADGTIC2(n,num_trials+m,:) = [null_optimals.ADGTIC2dCorMax.lx, null_optimals.ADGTIC2dCorMax.ux, null_optimals.ADGTIC2dCorMax.ly, null_optimals.ADGTIC2dCorMax.uy, null_optimals.ADGTIC2dCorInfMax.lx, null_optimals.ADGTIC2dCorInfMax.ux, null_optimals.ADGTIC2dCorInfMax.ly, null_optimals.ADGTIC2dCorInfMax.uy, null_optimals.ADGTIC2nndCorInfMax.lx, null_optimals.ADGTIC2nndCorInfMax.ux, null_optimals.ADGTIC2nndCorInfMax.ly, null_optimals.ADGTIC2nndCorInfMax.uy,];
        ADGTIC3(n,num_trials+m,:) = [null_optimals.ADGTIC3dCorMax.lx, null_optimals.ADGTIC3dCorMax.ux, null_optimals.ADGTIC3dCorMax.ly, null_optimals.ADGTIC3dCorMax.uy, null_optimals.ADGTIC3dCorInfMax.lx, null_optimals.ADGTIC3dCorInfMax.ux, null_optimals.ADGTIC3dCorInfMax.ly, null_optimals.ADGTIC3dCorInfMax.uy, null_optimals.ADGTIC3nndCorInfMax.lx, null_optimals.ADGTIC3nndCorInfMax.ux, null_optimals.ADGTIC3nndCorInfMax.ly, null_optimals.ADGTIC3nndCorInfMax.uy,];
        
        pADGTIC1(n,num_trials+m,:) = [null_optimals.pADGTIC1dCorMax.lx, null_optimals.pADGTIC1dCorMax.ux, null_optimals.pADGTIC1dCorMax.ly, null_optimals.pADGTIC1dCorMax.uy, null_optimals.pADGTIC1dCorInfMax.lx, null_optimals.pADGTIC1dCorInfMax.ux, null_optimals.pADGTIC1dCorInfMax.ly, null_optimals.pADGTIC1dCorInfMax.uy, null_optimals.pADGTIC1nndCorInfMax.lx, null_optimals.pADGTIC1nndCorInfMax.ux, null_optimals.pADGTIC1nndCorInfMax.ly, null_optimals.pADGTIC1nndCorInfMax.uy,];
        pADGTIC2(n,num_trials+m,:) = [null_optimals.pADGTIC2dCorMax.lx, null_optimals.pADGTIC2dCorMax.ux, null_optimals.pADGTIC2dCorMax.ly, null_optimals.pADGTIC2dCorMax.uy, null_optimals.pADGTIC2dCorInfMax.lx, null_optimals.pADGTIC2dCorInfMax.ux, null_optimals.pADGTIC2dCorInfMax.ly, null_optimals.pADGTIC2dCorInfMax.uy, null_optimals.pADGTIC2nndCorInfMax.lx, null_optimals.pADGTIC2nndCorInfMax.ux, null_optimals.pADGTIC2nndCorInfMax.ly, null_optimals.pADGTIC2nndCorInfMax.uy,];
        pADGTIC3(n,num_trials+m,:) = [null_optimals.pADGTIC3dCorMax.lx, null_optimals.pADGTIC3dCorMax.ux, null_optimals.pADGTIC3dCorMax.ly, null_optimals.pADGTIC3dCorMax.uy, null_optimals.pADGTIC3dCorInfMax.lx, null_optimals.pADGTIC3dCorInfMax.ux, null_optimals.pADGTIC3dCorInfMax.ly, null_optimals.pADGTIC3dCorInfMax.uy, null_optimals.pADGTIC3nndCorInfMax.lx, null_optimals.pADGTIC3nndCorInfMax.ux, null_optimals.pADGTIC3nndCorInfMax.ly, null_optimals.pADGTIC3nndCorInfMax.uy,];
        
        ADsnpIC(n,num_trials+m,:) = [null_optimals.ADsnpIC.x, null_optimals.ADsnpIC.y];
        ADdsnpIC(n,num_trials+m,:) = [null_optimals.ADdsnpIC.lx, null_optimals.ADdsnpIC.ux, null_optimals.ADdsnpIC.ly, null_optimals.ADdsnpIC.uy];
        AKIC(n,num_trials+m,:) = [null_optimals.AKIC.x,null_optimals.AKIC.y];
        
        mikMax(n,num_trials+m) = null_optimals.mikMax;
        mikInfMax(n,num_trials+m) = null_optimals.mikInfMax;
        
    end
    
    % Compute empirical power of all statistics tested
    %  num_trials = nRandomisations;
    thresholds = repmat(helper_quantile(null_stats,1-alpha,2),1,num_trials);
    successes = sum((pos_stats > thresholds),2);
    power = successes/num_trials;
    dpower = sqrt(power.*(1-power)./num_trials);
    
    n_power(n,:) = power(:)';
    n_dpower(n,:) = dpower(:)';
    n_pos_stats(n,:,:) = pos_stats;
    n_null_stats(n,:,:) = null_stats;
    
end

pos_opt.ADGTIC1 = ADGTIC1(:,1:num_trials,:);
pos_opt.ADGTIC2 = ADGTIC2(:,1:num_trials,:);
pos_opt.ADGTIC3 = ADGTIC3(:,1:num_trials,:);
pos_opt.pADGTIC1 = pADGTIC1(:,1:num_trials,:);
pos_opt.pADGTIC2 = pADGTIC2(:,1:num_trials,:);
pos_opt.pADGTIC3 = pADGTIC3(:,1:num_trials,:);
pos_opt.ADsnpIC = ADsnpIC(:,1:num_trials,:);
pos_opt.ADdsnpIC = ADdsnpIC(:,1:num_trials,:);
pos_opt.AKIC = AKIC(:,1:num_trials,:);
pos_opt.mikMax = mikMax(:,1:num_trials);
pos_opt.mikInfMax = mikInfMax(:,1:num_trials);

null_opt.ADGTIC1 = ADGTIC1(:,1+num_trials:2*num_trials,:);
null_opt.ADGTIC2 = ADGTIC2(:,1+num_trials:2*num_trials,:);
null_opt.ADGTIC3 = ADGTIC3(:,1+num_trials:2*num_trials,:);
null_opt.pADGTIC1 = pADGTIC1(:,1+num_trials:2*num_trials,:);
null_opt.pADGTIC2 = pADGTIC2(:,1+num_trials:2*num_trials,:);
null_opt.pADGTIC3 = pADGTIC3(:,1+num_trials:2*num_trials,:);
null_opt.ADsnpIC = ADsnpIC(:,1+num_trials:2*num_trials,:);
null_opt.ADdsnpIC = ADdsnpIC(:,1+num_trials:2*num_trials,:);
null_opt.AKIC = AKIC(:,1+num_trials:2*num_trials,:);
null_opt.mikMax = mikMax(:,1+num_trials:2*num_trials);
null_opt.mikInfMax = mikInfMax(:,1+num_trials:2*num_trials);

switch type
    case 'l',
        save new_results/power_fdr/double_l.mat n_pos_stats n_null_stats n_power n_dpower pos_opt null_opt
    case 'p',
        save new_results/power_fdr/double_p.mat n_pos_stats n_null_stats n_power n_dpower pos_opt null_opt
    case 's',
        save new_results/power_fdr/double_s.mat n_pos_stats n_null_stats n_power n_dpower pos_opt null_opt
    case 'c',
        save new_results/power_fdr/double_c.mat n_pos_stats n_null_stats n_power n_dpower pos_opt null_opt
    otherwise,
        disp('PROBLEM!')
end

end

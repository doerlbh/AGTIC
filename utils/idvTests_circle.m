% individual tests

clear all; close all;

%% control variables

nObs=200;
nTrials = 1;

addpath('/Users/DoerLBH/Dropbox/git/GTMI')

rad=300;
noise = 20;
X = rad*sin(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);
Y = rad*cos(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);

set(0,'DefaultFigureVisible','on')
set(groot,'defaultFigureVisible','on')

%% plot data
figw(10); clf; hold on;
subplot(2,1,1); plot(X,Y,'.k'); axis equal;
xlabel('X'); ylabel('Y');
title('\bfsimulated data set (dependent)');

subplot(2,1,2); plot(X,Y(randperm(nObs)),'.k'); axis equal;
xlabel('X'); ylabel('Y');
title('\bfrandomised (independent)');


%% deep distance
deepDistance(X,Y);


%% model parameters

% for HSIC
params.shuff=500;
params.sigx=-1;
params.sigy=-1;
params.bootForce=1;

% for other p-value based methods
alpha=0.05;
nThreshs = 10;
nSearchRandomisations = 10;
nRandomisations = 10;

%% test for mutual information - positive cases


%% adaptive Gaussian-kernel independence criterion test
p=AKIC1test(X,Y);
if p<alpha,
    disp(any2str('AKIC1 test positive: p=',p));
else
    disp(any2str('AKIC1 test negative: p=',p));
end

%% HSIC test
[thresh,testStat] = hsicTestBoot(X,Y,alpha,params);
if testStat>thresh,
    disp('HSIC test positive');
else
    disp('HSIC test negative');
end


    %% dist-based AKIC
    dX = pdist(X,'Euclidean')';
    dY = pdist(Y,'Euclidean')';
    p=AKIC1test(dX,dY);
    if p<alpha,
        disp(any2str('dist-based AKIC1 test positive: p=',p));
    else
        disp(any2str('dist-based AKIC1 test negative: p=',p));
    end


%% adaptive distance one-threshold shared neighbor test
p=ADsnpICtest(X,Y);
if p<alpha,
    disp(any2str('ADsnpIC test positive: p=',p));
else
    disp(any2str('ADsnpIC test negative: p=',p));
end

%% distance-correlation permutation test
p = dCorTest(X,Y);
if p<alpha,
    disp(any2str('dCor test positive: p=',p));
else
    disp(any2str('dCor test negative: p=',p));
end

%% RDM-correlation permutation test
p = rdmCorrTest(X,Y);
if p<alpha,
    disp(any2str('rdmCorrTest positive: p=',p));
else
    disp(any2str('rdmCorrTest negative: p=',p));
end

%% Geo-topological adaptive distance-threshold test 1
% [nn_p_idv, nn_p_max, nn_p_nnmax, p_idv, p_max, p_nnmax] =ADGTICtest(X,Y,1);

[stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_ADGTIC(X,Y,nThreshs,nRandomisations,nSearchRandomisations,1);

% p = nn_p_idv;
% disp(any2str('ADGTIC1 test positive: p=',p));
% else
%     disp(any2str('ADGTIC1 test negative: p=',p));
% end

%% Geo-topological adaptive distance-threshold test 2
[nn_p_idv, nn_p_max, nn_p_nnmax, p_idv, p_max, p_nnmax] =ADGTICtest(X,Y,2);
if p<alpha,
    disp(any2str('ADGTIC2 test positive: p=',p));
else
    disp(any2str('ADGTIC2 test negative: p=',p));
end

%% Geo-topological adaptive distance-threshold test 3
[nn_p_idv, nn_p_max, nn_p_nnmax, p_idv, p_max, p_nnmax] =ADGTICtest(X,Y,3);
if p<alpha,
    disp(any2str('ADGTIC3 test positive: p=',p));
else
    disp(any2str('ADGTIC3 test negative: p=',p));
end

% run power calculation

clear all
close all
clc

loc = 'doerlbh';
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

%% double relationships

%%

N = 50000;
noisec = 0;
noise = 30;

% checkerboards
xcs = helper_randint(20,N);
ycs = 2*helper_randint(10,N) + mod(xcs,2);
x_space = 10;
y_space = 10;
xs = x_space*(xcs + rand(N,1)) + noisec*randn(N,1);
ys = y_space*(ycs + rand(N,1)) + noisec*randn(N,1);

% xs = 200*rand(N,1);
% ys = 200*rand(N,1);

% linear
slope = 1;
islinear = [ys < slope*xs + noise] .* [ys > slope*xs - noise];
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
radius_a = 100;
radius_b = 50;
iscircular = [(xs-100).^2 + (ys-100).^2 > radius_b^2] .* [(xs-100).^2 + (ys-100).^2 < radius_a^2];
xsc = xs(iscircular == 1);
ysc = ys(iscircular == 1);
perm = randperm(sum(iscircular), 5000);
xsc = xsc(perm);
ysc = ysc(perm);

%% general variables

noise = 0;
alpha = 0.05;
N = 500;
perm = randperm(5000, N);


rng(1);
num_trials = 5;
   
ops = [];
for i = 1:num_trials
    disp(i)
    
%     %     case 'linear',
    slope = 1/10;
    xs = 100 * rand(N,1);
    ys = slope *xs + noise*randn(N,1);
%     
    % %     case 'parabolic',
%             a = 10;
%             xs = randn(N,1);
%             ys = a*(xs.^2) + noise*randn(N,1);
    %
    %     case 'sinusoidal',
%             amp = 100;
%             period = 1/10;
%             xs = 30*pi*rand(N,1);
%             ys = amp*sin(period*xs) + noise*randn(N,1);
    %
    %     case 'circular',
%             thetas = 2*pi*rand(N,1);
%             radius = 10;
%             xs = radius*cos(thetas) + noise*randn(N,1);
%             ys = radius*sin(thetas) + noise*randn(N,1);
    %
    %     case 'checkerboard',
%             xcs = helper_randint(4,N);
%             ycs = 2*helper_randint(2,N) + mod(xcs,2);
%             x_space = 10;
%             y_space = 50;
%             xs = x_space*(xcs + rand(N,1)) + noise*randn(N,1);
%             ys = y_space*(ycs + rand(N,1)) + noise*randn(N,1);
    
    plot(xs,ys,'o')
    nThreshs = 11;
    tic;
    [pADGTIC3dCorMax, stat] = simple_rpADGTIC3(xs,ys,nThreshs);
    disp(pADGTIC3dCorMax);
    toc;
    
    ops = [ops; pADGTIC3dCorMax.lx, pADGTIC3dCorMax.ux, pADGTIC3dCorMax.ly, pADGTIC3dCorMax.uy]
    
end

opts = mean(ops);
disp(opts(1:2))
disp(opts(3:4))

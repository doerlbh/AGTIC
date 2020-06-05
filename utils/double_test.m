N = 50000;
noisec = 0;
noise = 30;

% checkerboards
xcs = helper_randint(20,N);
ycs = 2*helper_randint(10,N) + mod(xcs,2);
xs = 10*(xcs + rand(N,1)) + noisec*randn(N,1);
ys = 10*(ycs + rand(N,1)) + noisec*randn(N,1);
plot(xs,ys,'p'); hold on

% linear

% xs = 100 + 18 * randn(N,1);
% ys = xs + noise*randn(N,1);

islinear = [ys < xs + noise] .* [ys > xs - noise];
% plot(xs(islinear == 1),ys(islinear == 1),'p'); hold on
xsl = xs(islinear == 1);
ysl = ys(islinear == 1);
 
% % parabolic 
% xs = 100 + 10*randn(N,1);
% ys = 30 + (1/10)*((xs - 100).^2) + noise*randn(N,1);
% plot(xs,ys,'p'); hold on

isparabolic = [ys < 30 + (1/10)*((xs - 100).^2) + noise] .* [ys > 30 + (1/10)*((xs - 100).^2) - noise];
% plot(xs(isparabolic == 1),ys(isparabolic == 1),'p'); hold on
xsp = xs(isparabolic == 1);
ysp = ys(isparabolic == 1);

% 
% % sinusoidal
% xs = 10 + 50*pi*rand(N,1);
% ys = 100 + 40 * sin(xs/10 - 20) + noise*randn(N,1);
% plot(xs,ys,'p'); hold on
% 
issinusoidal = [ys < 100 + 40 * sin(xs/10 - 20) + noise] .* [ys > 100 + 40 * sin(xs/10 - 20) - noise];
% plot(xs(issinusoidal == 1),ys(issinusoidal == 1),'p'); hold on
xss = xs(issinusoidal == 1);
yss = ys(issinusoidal == 1);

% % circular
% thetas = 2*pi*rand(N,1);
% xs = 100 + 60*cos(thetas) + noise*randn(N,1);
% ys = 100 + 60*sin(thetas) + noise*randn(N,1);
% plot(xs,ys,'p')
% 
iscircular = [(xs-100).^2 + (ys-100).^2 > 50^2] .* [(xs-100).^2 + (ys-100).^2 < 70^2];
plot(xs(iscircular == 1),ys(iscircular == 1),'p'); hold on
xsc = xs(iscircular == 1);
ysc = ys(iscircular == 1);

% xlim([0,200]);
% ylim([0,200]);


%% full image

% N = 50000;
% noisec = 0;
% noise = 0;
% 
% % checkerboards
% xcs = helper_randint(20,N);
% ycs = 2*helper_randint(10,N) + mod(xcs,2);
% xs = 10*(xcs + rand(N,1)) + noisec*randn(N,1);
% ys = 10*(ycs + rand(N,1)) + noisec*randn(N,1);
% plot(xs,ys,'p'); hold on
% 
% % linear
% xs = 100 + 18 * randn(N,1);
% ys = xs + noise*randn(N,1);
% plot(xs,ys,'p'); hold on
% 
% % parabolic 
% xs = 100 + 10*randn(N,1);
% ys = 30 + (1/10)*((xs - 100).^2) + noise*randn(N,1);
% plot(xs,ys,'p'); hold on
% 
% % sinusoidal
% xs = 10 + 50*pi*rand(N,1);
% ys = 100 + 40 * sin(xs/10 - 20) + noise*randn(N,1);
% plot(xs,ys,'p'); hold on
% 
% % circular
% thetas = 2*pi*rand(N,1);
% xs = 100 + 60*cos(thetas) + noise*randn(N,1);
% ys = 100 + 60*sin(thetas) + noise*randn(N,1);
% plot(xs,ys,'p')
% 
% xlim([0,200]);
% ylim([0,200]);
% 


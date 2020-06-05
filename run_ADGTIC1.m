cd '/home/sunnylin/Dropbox/Git/GTMI'

nObs=200;
rad=300;
noise = 20;
X = rad*sin(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);
Y = rad*cos(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);

nThreshs = 10;
nRandomisations = 50
nSearchRandomisations = 20

[stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_ADGTIC(X,Y,nThreshs,nRandomisations,nSearchRandomisations,1);

exit

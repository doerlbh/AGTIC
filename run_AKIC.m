cd '/home/sunnylin/Dropbox/Git/GTMI'

nObs=200;
rad=300;
noise = 20;
X = rad*sin(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);
Y = rad*cos(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);

nThreshs = 10;
nRandomisations = 50
nSearchRandomisations = 20

nKernelWidths = 6;
mxFwhmFac=0.5;

stat = helper_AKIC(X,Y,nKernelWidths,mxFwhmFac)

exit

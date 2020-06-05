cd '/home/sunnylin/Dropbox/Git/GTMI'

nObs=200;
rad=300;
noise = 20;
X = rad*sin(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);
Y = rad*cos(linspace(-pi,pi,nObs)')+noise*randn(nObs,1);

nThreshs = 20;
nRandomisations = 50
nSearchRandomisations = 50

stat = helper_ADsnpIC(X,Y, nThreshs, nRandomisations);

exit

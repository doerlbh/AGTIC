function stat = helper_CD3(X,Y,nRandomisationsForCalibration,nBins)

% Cumulative density difference of distances (CD3) test
% Short-distance-inflation (SDI) test
%
% Idea: look at the distribution of distances in the joint
% space before and after randomisation (pdf, cdf). Is there a greater
% prevalence of short distances without randomisation? This would indicate
% greater concentration of the joint (thus smaller entropy) without
% randomisation.



%% control variables

nRandomisations = 50;
nRandomisationsForCalibration = 50;
monitor = false;
nBins = 50;


%% preparations

[~ , ~] = size(X);
[nObs, ~] = size(Y);


%% compute distances
dX = pdist(X,'Euclidean');
dY = pdist(Y,'Euclidean');
dX_sq = squareform(dX);

dists = sqrt(dX.^2+dY.^2);
edges = linspace(0,max(dists(:))*1.1,nBins);
centers = (edges(1:end-1)+edges(2:end))/2;

if monitor
    h = figure(150); set(h,'Color','w'); clf;
    subplot(3,2,1); plot(dX,dY,'.k');
    xlabel('distances between X obs.');
    ylabel('distances between Y obs.');
    title({'\bfdistance scatterplot',['\rm(r=',num2str(corr(dX(:),dY(:))),')']});
end


%% H0 simulations for calibration
helper_cdfJointDists_H0 = nan(nRandomisationsForCalibration,numel(edges));

for randomisationI = 1:nRandomisationsForCalibration
    rndPerm = randperm(nObs);
    dX_rnd = squareform(dX_sq(rndPerm,rndPerm));
    
    [helper_cdfJointDists_H0(randomisationI,:), counts_H0] = helper_cdfJointDists(dX_rnd,dY,edges);
    
    if monitor && mod(randomisationI,5)==0
        figure(150); subplot(3,2,2); plot(dX_rnd(:),dY(:),'.k');
        xlabel('distances between X obs.'); ylabel('distances between Y obs.');
        title({'\bfrandomised observations: distance scatterplot',['\rm(r=',num2str(corr(dX_rnd(:),dY(:))),')']});
        subplot(3,2,4); bar(centers,counts_H0(1:end-1)); title('\bfrandomised observations: distance histogram');
        % bar(centers,[counts_H0(1:end-1), counts_H1(1:end-1)]');
        subplot(3,1,3); hold on; plot(centers,helper_cdfJointDists_H0(randomisationI,1:end-1),'Color',[0.5 0.5 0.5]);
    end
end
helper_cdfJointDists_H0_calibration = mean(helper_cdfJointDists_H0,1);


%% compute actual test statistic

[SDI, endOfDominanceIndex] = helper_jointSpaceShortDistanceInflation(dX,dY,edges,helper_cdfJointDists_H0_calibration);
stat = SDI;


if monitor
    [helper_cdfJointDists_H1 counts_H1] = helper_cdfJointDists(dX,dY,edges);
    subplot(3,2,3); bar(centers,counts_H1(1:end-1)); title('\bfdistance histogram');
    subplot(3,1,3); plot(centers,helper_cdfJointDists_H1(1:end-1),'Color','r','LineWidth',3);
    axis([centers(1) centers(endOfDominanceIndex+3) 0 helper_cdfJointDists_H1(endOfDominanceIndex+3)]);
    xlabel('distance in [X,Y] joint space');
    ylabel('cumulative count');
    title('\bfcumulative density of distances');
end


%% compute the independent model's (H0) distribution of maximised likelihoods
SDIs_H0 = nan(nRandomisations+1,1);
SDIs_H0(nRandomisations+1) = SDI;

for randomisationI = 1:nRandomisations
    rndPerm = randperm(nObs);
    dX_rnd = squareform(dX_sq(rndPerm,rndPerm));
    
    SDIs_H0(randomisationI) = helper_jointSpaceShortDistanceInflation(dX_rnd,dY,edges,helper_cdfJointDists_H0_calibration); 
end

p=sum(SDIs_H0>=SDI)/(nRandomisations+1);




%% compute joint-space short-distance inflation (test statistic)
function [SDI, endOfDominanceIndex] = helper_jointSpaceShortDistanceInflation(dX,dY,edges,cdfJointDists_H0_calibration)

cdfJointDists = helper_cdfJointDists(dX,dY,edges);
dominance_dXY = cdfJointDists'-cdfJointDists_H0_calibration;
beginningOfDominanceIndex = find(dominance_dXY>0,1);
if beginningOfDominanceIndex>1
    dominance_dXY(1:beginningOfDominanceIndex-1)=0;
end
endOfDominanceIndex = find(dominance_dXY<0,1);
endOfDominanceIndex = max(1,endOfDominanceIndex-1);
SDI = sum(dominance_dXY(beginningOfDominanceIndex:endOfDominanceIndex)); % integral of cumulative density within short-distance dominance range


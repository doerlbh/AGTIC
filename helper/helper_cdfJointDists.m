%% compute cumulative density of distances
function [cdf, counts] = helper_cdfJointDists(distX,distY,edges)

dists = sqrt(distX.^2+distY.^2);
counts = histc(dists(:),edges);
cdf = cumsum(counts);

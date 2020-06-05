%% compute log likelihood for Gaussian-kernel model using leave-one-out crossvalidation 
function logL = helper_looLogLikelihood(d2X,d2Y,fwhmX,fwhmY,nObs,dX,dY)

c = sqrt(4*log(2));
wfX = c/fwhmX;
wfY = c/fwhmY;

logKernelDensities = squareform(-(d2X*(wfX^2)-log(sqrt(pi)*wfX^dX*(nObs-1))+d2Y*(wfY^2)-log(sqrt(pi)*wfY^dY*(nObs-1))));
logKernelDensities(logical(eye(nObs))) = NaN;
maxLogVals = max(logKernelDensities,[],2);

logOfKernelDensitySum = log(nansum(exp(logKernelDensities-repmat(maxLogVals,[1 nObs])),2))+maxLogVals;

logL = sum(logOfKernelDensitySum); % likelihood(data) = prod(likelihoods(points))




%% compute the maximum likelihood (optimising the combination of kernel widths for X and Y) 

function [maxLogL, logLs] = helper_maxLogLikelihood(d2X,d2Y,fwhmsX,fwhmsY,nObs,dX,dY)

maxLogL = -inf;

if nargout>1,
    i = 1;
    j = 1; 
    logLs = nan(numel(fwhmsY),numel(fwhmsX));
end

for fwhmX = fwhmsX
    for fwhmY = fwhmsY
        logL = helper_looLogLikelihood(d2X,d2Y,fwhmX,fwhmY,nObs,dX,dY);
        maxLogL = max(maxLogL,logL);
        
        if nargout>1
            logLs(i,j)=logL;
            i=i+1;
        end
    end
    if nargout>1, 
        j=j+1;
        i=1;
    end
end


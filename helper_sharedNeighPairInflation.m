function snpInf = helper_sharedNeighPairInflation(distX,distY,distXthreshs,distYthreshs)

nPairs=numel(distX);
nDistXthreshs=numel(distXthreshs);
nDistYthreshs=numel(distYthreshs);

snpInf=nan(nDistYthreshs,nDistXthreshs);

for distXthreshI=1:nDistXthreshs
    distXthresh=distXthreshs(distXthreshI);
    
    for distYthreshI=1:nDistYthreshs
        distYthresh=distYthreshs(distYthreshI);

        XneighPairsLOG = distX<distXthresh;
        YneighPairsLOG = distY<distYthresh;
        
        sharedNeighPairsLOG = XneighPairsLOG & YneighPairsLOG;
        
        expNsharedNeighPairs_H0 = (sum(XneighPairsLOG)/nPairs * sum(YneighPairsLOG)/nPairs) * nPairs;
        
        snpInf(distYthreshI,distXthreshI) = sum(sharedNeighPairsLOG) / expNsharedNeighPairs_H0;
        
    end
end
    
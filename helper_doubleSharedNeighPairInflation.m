function snpInf = helper_doubleSharedNeighPairInflation(distX,distY,distXthreshs,distYthreshs)

nPairs=numel(distX);
nDistXthreshs=numel(distXthreshs);
nDistYthreshs=numel(distYthreshs);

snpInf=nan(nchoosek(nDistYthreshs,2),nchoosek(nDistXthreshs,2));

indexX = zeros(nDistXthreshs);
indexY = zeros(nDistYthreshs);

count = 1;
for distXrightthreshI=2:nDistXthreshs
    for distXleftthreshI=1:distXrightthreshI-1
        indexX(distXleftthreshI, distXrightthreshI) = count;
        count = count + 1;
    end
end

count = 1;
for distYrightthreshI=2:nDistYthreshs
    for distYleftthreshI=1:distYrightthreshI-1
        indexY(distYleftthreshI, distYrightthreshI) = count;
        count = count + 1;
    end
end

for distXrightthreshI=2:nDistXthreshs
    distXrightthresh=distXthreshs(distXrightthreshI);
    
    for distXleftthreshI=1:distXrightthreshI-1
        distXleftthresh=distXthreshs(distXleftthreshI);
        
        for distYrightthreshI=2:nDistYthreshs
            distYrightthresh=distYthreshs(distYrightthreshI);
            
            
            for distYleftthreshI=1:distYrightthreshI-1
                distYleftthresh=distYthreshs(distYleftthreshI);
                
                XneighPairsLOG = distX>distXleftthresh & distX<distXrightthresh;
                YneighPairsLOG = distY>distYleftthresh & distY<distYrightthresh;
                
                sharedNeighPairsLOG = XneighPairsLOG & YneighPairsLOG;
                
                expNsharedNeighPairs_H0 = (sum(XneighPairsLOG)/nPairs * sum(YneighPairsLOG)/nPairs) * nPairs;
                
                snpInf(indexX(distXleftthreshI, distXrightthreshI),indexY(distYleftthreshI, distYrightthreshI) ) = sum(sharedNeighPairsLOG) / expNsharedNeighPairs_H0;               
              
            end
        end
    end
end


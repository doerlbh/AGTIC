
function [dCorMapThreshs] = simple_helper_pfindDCorMapThreshs(X, Y, Xthreshs, Ythreshs, method)

nXthreshs=numel(Xthreshs);
nYthreshs=numel(Ythreshs);

dCorMapThreshs=nan(nchoosek(nYthreshs,2),nchoosek(nXthreshs,2));

indexX = zeros(nXthreshs);
indexY = zeros(nYthreshs);

count = 1;
for uXThreshI=2:nXthreshs
    for lXThreshI=1:uXThreshI-1
        indexX(lXThreshI, uXThreshI) = count;
        count = count + 1;
    end
end

count = 1;
for uYThreshI=2:nYthreshs
    for lYThreshI=1:uYThreshI-1
        indexY(lYThreshI, uYThreshI) = count;
        count = count + 1;
    end
end

for uXThreshI=2:nXthreshs
    uXThresh=Xthreshs(uXThreshI);
    
    for lXThreshI=1:uXThreshI-1
        lXThresh=Xthreshs(lXThreshI);
        
        for uYThreshI=2:nYthreshs
            uYThresh=Ythreshs(uYThreshI);
            
            for lYThreshI=1:uYThreshI-1
                lYThresh=Ythreshs(lYThreshI);
                
                H1_dCor = helper_pdCorLU(X,Y,lXThresh,uXThresh,lYThresh,uYThresh,method);
                dCorMapThreshs(indexX(lXThreshI, uXThreshI),...
                    indexY(lYThreshI, uYThreshI)) = H1_dCor;
                                
            end
        end
    end
end

end
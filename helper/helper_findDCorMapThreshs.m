
function [dCorMapThreshsInf, dCorMapThreshs] = helper_findDCorMapThreshs(X, Y, Xthreshs, Ythreshs, nSearchRandomisations, method)

% nSearchRandomisations = 20;

% nObs =numel(Y);

[nObs, nDimY]=size(Y);

nXthreshs=numel(Xthreshs);
nYthreshs=numel(Ythreshs);

dCorMapThreshs=nan(nchoosek(nYthreshs,2),nchoosek(nXthreshs,2));
dCorMapThreshsInf=nan(nchoosek(nYthreshs,2),nchoosek(nXthreshs,2));
% dCorMapThreshs_rnd=nan(nchoosek(nYthreshs,2),nchoosek(nXthreshs,2),nSearchRandomisations);

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
                
                H1_dCor = helper_dCorLU(X,Y,lXThresh,uXThresh,lYThresh,uYThresh,method);
                dCorMapThreshs(indexX(lXThreshI, uXThreshI),...
                    indexY(lYThreshI, uYThreshI)) = H1_dCor;
                
                dCorMapThreshs_rnd = nan(nSearchRandomisations,1);
                parfor randomisationI=1:nSearchRandomisations
                    dCorMapThreshs_rnd(randomisationI) = ...
                        helper_dCorLU(X,Y(randperm(nObs),:),lXThresh,uXThresh,lYThresh,uYThresh,method);
                end
                
                H0_mean = mean(dCorMapThreshs_rnd);
                
                dCorMapThreshsInf(indexX(lXThreshI, uXThreshI),...
                    indexY(lYThreshI, uYThreshI)) = H1_dCor / H0_mean;
                
%                 disp(['case ' num2str(indexX(lXThreshI, uXThreshI)) '-' num2str(indexY(lYThreshI, uYThreshI))])
%                 
            end
        end
    end
end

% disp(mean(dCorMapThreshsInf))
% disp(mean(dCorMapThreshs))

end
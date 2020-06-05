function stat = helper_rdmCor(X,Y)

%% control variables

nRandomisations = 50;
monitor = true;
pr = 3; % digits after decimal point in output

%% compute distances

distX = pdist(X,'euclidean');
distY = pdist(Y,'euclidean');

distX_sq = squareform(distX);
[n, n] = size(distX_sq);

rdmCorr = corr(distX',distY');
stat = rdmCorr;

% rdmCorr_H0 = nan(nRandomisations+1,1);
% rdmCorr_H0(nRandomisations+1) = rdmCorr;
% 
% 
% %% show distance distributions
% % 
% if monitor
%     h = figure(100); set(h,'Color','w'); clf;
%     subplot(2,1,1); plot(distX(:),distY(:),'.k');
%     xlabel('distances with 0-diag between X obs.'); ylabel('distances with 0-diag between Y obs.');
%     title({'\bfdistance scatterplot',['\rm(r = ',num2str(corr(distX(:),distY(:)),pr),')']});    
% end
% 
% 
% %% compute randomisation distribution
% 
% for randomisationI=1:nRandomisations
%     rndPerm = randperm(n);
%     distX_rndPerm = squareform(distX_sq(rndPerm,rndPerm));
%     
%     rdmCorr_H0(randomisationI) = corr(distX_rndPerm',distY');
%     
%         if monitor && randomisationI==1
%             h=figure(50); set(h,'Color','w'); clf;
%             subplot(2,2,1); imagesc(squareform(distX)); axis equal tight; colormap('bone'); colorbar; title('distX');
%             subplot(2,2,2); imagesc(squareform(distY)); axis equal tight; colormap('bone'); colorbar; title('distY');
%             subplot(2,2,3); imagesc(squareform(distX_rndPerm)); axis equal tight; colormap('bone'); colorbar; title('distYcc\_rndPerm');
%             
%             figure(100);
%             subplot(2,1,2); plot(distX_rndPerm(:),distY(:),'.k');
%             xlabel('distances with 0-diag between X obs.'); ylabel('distances with 0-diag between Y obs.');
%             title({'\bfrandomised observations: distance scatterplot',['\rm(r = ',num2str(corr(distX_rndPerm(:),distY(:)),pr),')']});
%         end
% end
% 
% 
% %% compute p value
% 
% % p = sum(rdmCorr_H0 >= rdmCorr)/(nRandomisations+1);
% 



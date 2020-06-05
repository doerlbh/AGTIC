function stat = helper_ADsnpIC(X,Y, nThreshs, nRandomisations)

% adaptive distance-based independence criterion (ADIC) test
% a general robust test for mutual information between X and Y


%% control variables

% nThreshs=10;
% nRandomisations=100;


%% preparations

[nObs nDimX]=size(X);
[nObs nDimY]=size(Y);


%% compute distances

distX=pdist(X,'Euclidean');
distY=pdist(Y,'Euclidean');

% h=figure(100); set(h,'Color','w'); clf;
% subplot(1,2,1); plot(distX,distY,'.k');
% xlabel('distances between X obs.');
% ylabel('distances between Y obs.');
% title(['distance scatterplot (r=',num2str(corr(distX',distY')),')']);


%% define thresholds

step=range(distX)/(nThreshs+1); distXthreshs=linspace(min(distX)+step,max(distX)-step,nThreshs);
step=range(distY)/(nThreshs+1); distYthreshs=linspace(min(distY)+step,max(distY)-step,nThreshs);
nDistXthreshs=numel(distXthreshs);
nDistYthreshs=numel(distYthreshs);


%% compute actual shared neigh-pair inflation as a function of the two thresholds

snpInf = helper_sharedNeighPairInflation(distX,distY,distXthreshs,distYthreshs);
% 
% h=figure(110); set(h,'Color','w'); clf;
% subplot(2,2,1); hold on;
% imagesc(snpInf); colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% xlabel('X-dist. threshold');
% ylabel('Y-dist. threshold');
% colorbar; axis equal tight;
% [mx,mxI]=max(snpInf(:));
% [mxY,mxX]=ind2sub([nDistYthreshs nDistXthreshs],mxI);
% plot(mxX,mxY,'.k','MarkerSize',10);
% 
% subplot(2,2,2); hold on;
% surf(snpInf); plot3([mxX mxX],[mxY mxY],[0 mx*2],'Color','k','LineWidth',2);
% xlabel('X-dist. threshold'); ylabel('Y-dist. threshold');
% zlabel('shared-neighpair infl.');
% title('shared-neighpair infl.');
% view(-16,54);

%% compute randomisation distribution of shared neigh-pair inflation maxima

distX_sq=squareform(distX);

snpInf_rnd=nan(nDistYthreshs,nDistXthreshs,nRandomisations+1);

for randomisationI=1:nRandomisations
    rndPerm = randperm(nObs);
    distX_sq_rnd = distX_sq(rndPerm,rndPerm);
    snpInf_rnd(:,:,randomisationI) = helper_sharedNeighPairInflation(squareform(distX_sq_rnd),distY,distXthreshs,distYthreshs);
    
%     if mod(randomisationI,20)==1, figure(110); subplot(2,2,2); hold on; surf(snpInf_rnd(:,:,randomisationI),'FaceColor',[1 1 0],'FaceAlpha',0.2); end
%     if randomisationI==1
%         figure(100); subplot(1,2,2); plot(squareform(distX_sq_rnd),distY,'.k');
%         xlabel('distances between X obs.'); ylabel('distances between Y obs.');
%         title(['randomised observations: distance scatterplot (r=',num2str(corr(squareform(distX_sq_rnd)',distY')),')']);
%     end

end

snpInf_rnd(:,:,nRandomisations+1)=snpInf; % add the actual one (to be treated equally)

divNormFactors=std(snpInf_rnd,1,3);
divNormFactors(divNormFactors<0.00001)=0.00001;
snpInf_rnd_noiseStdUnits=1+(snpInf_rnd-1)./repmat(divNormFactors,[1 1 nRandomisations+1]);

cSnpInf_rnd_noiseStdUnits=snpInf_rnd_noiseStdUnits(:,:,nRandomisations+1);
stat =  max(cSnpInf_rnd_noiseStdUnits(:));
% 
% ADIC_rnd=nan(nRandomisations+1,1);
% % 
% for randomisationI=1:nRandomisations+1
%     cSnpInf_rnd_noiseStdUnits=snpInf_rnd_noiseStdUnits(:,:,randomisationI);
%     ADIC_rnd(randomisationI) = max(cSnpInf_rnd_noiseStdUnits(:));
%     if mod(randomisationI,20)==1, subplot(2,2,4); hold on; surf(cSnpInf_rnd_noiseStdUnits,'FaceColor',[1 1 0],'FaceAlpha',0.2); end
% end
% 
% % plot the actual one after normalisation
% surf(cSnpInf_rnd_noiseStdUnits);
% 
% [mx,mxI]=max(cSnpInf_rnd_noiseStdUnits(:));
% [mxY,mxX]=ind2sub([nDistYthreshs nDistXthreshs],mxI);
% plot3([mxX mxX],[mxY mxY],[0 mx*2],'Color','k','LineWidth',2);
% 
% colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% xlabel('X-dist. threshold'); ylabel('Y-dist. threshold');
% zlabel({'noise-norm.', 'shared-neighpair infl.'});
% title('noise-norm. shared-neighpair infl.');
% view(-16,54);
% 
% subplot(2,2,3); hold on;
% imagesc(cSnpInf_rnd_noiseStdUnits); colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% plot(mxX,mxY,'.k','MarkerSize',10);
% xlabel('X-dist. threshold'); ylabel('Y-dist. threshold');
% colorbar; axis equal tight;
% % 
% % ADIC=ADIC_rnd(end);
% % 
% % p=sum(ADIC_rnd>ADIC)/nRandomisations;
% % 
% subplot(2,2,4); 
% % title(['p = ',num2str(p)]);
% 
% savefig(h,'results/ADsnpIC.fig')
% close(h)
% 

function [stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_pADGTIC(X,Y,nThreshs,nRandomisations,nSearchRandomisations,method)

% adaptive distance-based geo-topological independence criterion (ADGTIC)
% a general robust test for mutual information between X and Y


%% debug

%
% nObs=50;
% nTrials = 1;
% method = 1;
% % addpath('/Users/DoerLBH/Dropbox/git/GTMI')
%
% rad=160;
% noise = randn(nObs,1);
% X = rad*sin(linspace(-pi,pi,nObs)')+noise;
% Y = rad*cos(linspace(-pi,pi,nObs)')+noise;
% % Y = Y(randperm(nObs));


%% control variables

% nThreshs=8;
% nRandomisations=60;

%% parameters for geo-topological transformation

% method = 1;


%% preparations

[nObs nDimX]=size(X);
[nObs nDimY]=size(Y);


%% compute distances

distX=pdist(X,'Euclidean');
distY=pdist(Y,'Euclidean');

%plot
% h=figure(101); set(h,'Color','w'); clf;
% subplot(1,2,1); plot(distX,distY,'.k');
% xlabel('distances between X obs.');
% ylabel('distances between Y obs.');
% title(['distance scatterplot (r=',num2str(corr(distX',distY')),')']);


%% define thresholds

% step=range(distX)/(nThreshs+1);
% Xthreshs=linspace(min(distX)+step,max(distX)-step,nThreshs);
%
% step=range(distY)/(nThreshs+1);
% Ythreshs=linspace(min(distY)+step,max(distY)-step,nThreshs);

Xthreshs = linspace(0,1,nThreshs);
Ythreshs = linspace(0,1,nThreshs);

nXthreshs=numel(Xthreshs);
nYthreshs=numel(Ythreshs);


%% compute actual dCorMapThreshs as a function of the two thresholds

count = 1;
[dCorMapThreshsInf, dCorMapThreshs] = helper_pfindDCorMapThreshs(X,Y,Xthreshs,Ythreshs,nSearchRandomisations,method);

stat_dCorMax = max(dCorMapThreshs(:));
stat_dCorInfMax = max(dCorMapThreshsInf(:));

% %plot
% h=figure(111); set(h,'Color','w'); clf;
% 
% subplot(2,2,1); hold on;
% imagesc(dCorMapThreshsInf);
% colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% xlabel('X threshold space');
% ylabel('Y threshold space');
% colorbar; axis equal tight;
% [mx,mxI]=max(dCorMapThreshsInf(:));
% [mxY,mxX]=ind2sub([nchoosek(nYthreshs,2),nchoosek(nXthreshs,2)],mxI);
% plot(mxX,mxY,'.k','MarkerSize',10);
% 
% subplot(2,2,2); hold on;
% surf(dCorMapThreshsInf);
% plot3([mxX mxX],[mxY mxY],[0 mx*2],'Color','k','LineWidth',2);
% xlabel('X threshold space');
% ylabel('Y threshold space');
% zlabel('dCorMapThreshsInf');
% view(-16,54);
% title('dCorMapThreshsInf');
% 

%% compute randomisation distribution of dCorMapThreshs maxima

dCorMapThreshs_rnd=nan(nchoosek(numel(Ythreshs),2),nchoosek(numel(Xthreshs),2),nRandomisations+1);
dCorMapThreshsInf_rnd=nan(nchoosek(numel(Ythreshs),2),nchoosek(numel(Xthreshs),2),nRandomisations+1);
distX_sq=squareform(distX);

for randomisationI=1:nRandomisations
    rndPerm = randperm(nObs);
        distX_sq_rnd = distX_sq(rndPerm,rndPerm);
    
%     disp(['=========' num2str(count)])
    [dCorMapThreshsInf_rnd(:,:,randomisationI), dCorMapThreshs_rnd(:,:,randomisationI)] = helper_pfindDCorMapThreshs(X(rndPerm),Y,Xthreshs,Ythreshs,nSearchRandomisations,method);
    count = count + 1;
%     % plot
%         if mod(randomisationI,20)==1
%             figure(111);
%             subplot(2,2,2); hold on;
%             surf(dCorMapThreshsInf_rnd(:,:,randomisationI),'FaceColor',[1 1 0],'FaceAlpha',0.2);
%         end
%         if randomisationI==1
%             figure(101);
%             subplot(1,2,2);
%             plot(squareform(distX_sq_rnd),distY,'.k');
%             xlabel('distances between X obs.');
%             ylabel('distances between Y obs.');
%             title(['randomised observations: distance scatterplot (r=',num2str(corr(squareform(distX_sq_rnd)',distY')),')']);
%         end
    
end

% dCorMapThreshs_rnd(:,:,nRandomisations+1)=dCorMapThreshs; % add the actual one (to be treated equally)
dCorMapThreshsInf_rnd(:,:,nRandomisations+1)=dCorMapThreshsInf; % add the actual one (to be treated equally)

divNormFactors=std(dCorMapThreshsInf_rnd,1,3);
divNormFactors(divNormFactors<0.00001)=0.00001;
dCorMapThreshsInf_rnd_noiseStdUnits=1+(dCorMapThreshsInf_rnd-1)./repmat(divNormFactors,[1 1 nRandomisations+1]);

cdCorMapThreshsInf_rnd_noiseStdUnits=dCorMapThreshsInf_rnd_noiseStdUnits(:,:,nRandomisations+1);
stat_nndCorInfMax = max(cdCorMapThreshsInf_rnd_noiseStdUnits(:));

% ADIC_rnd = nan(nRandomisations+1,1);
% nnADIC_rnd = nan(nRandomisations+1,1);
%
% for randomisationI = 1:nRandomisations+1
% %
% %     cdCorMapThreshsInf_rnd_noiseStdUnits=dCorMapThreshsInf_rnd_noiseStdUnits(:,:,randomisationI);
% %     nnADIC_rnd(randomisationI) = max(cdCorMapThreshsInf_rnd_noiseStdUnits(:));
% %
% %     cdCorMapThreshs_rnd = dCorMapThreshs_rnd(:,:,randomisationI);
% %     ADIC_rnd(randomisationI) = max(cdCorMapThreshs_rnd(:));
% %
%     if mod(randomisationI,20)==1
%         subplot(2,2,4); hold on;
%         surf(cdCorMapThreshsInf_rnd_noiseStdUnits,'FaceColor',[1 1 0],'FaceAlpha',0.2);
%     end
% 
% end
% %
% % plot the actual one after normalisation
% surf(cdCorMapThreshsInf_rnd_noiseStdUnits);
% 
% [nnmx,nnmxI]=max(cdCorMapThreshsInf_rnd_noiseStdUnits(:));
% [nnmxY,nnmxX]=ind2sub([nchoosek(nYthreshs,2) nchoosek(nXthreshs,2)],nnmxI);
% plot3([nnmxX nnmxX],[nnmxY nnmxY],[0 nnmx*2],'Color','k','LineWidth',2);
% %
% % nnADIC_max_rnd = dCorMapThreshsInf_rnd_noiseStdUnits(mxY,mxX,:);
% % nnADIC_nnmax_rnd = dCorMapThreshsInf_rnd_noiseStdUnits(nnmxY,nnmxX,:);
% %
% % ADIC_max_rnd = dCorMapThreshs_rnd(mxY,mxX,:);
% % ADIC_nnmax_rnd = dCorMapThreshs_rnd(nnmxY,nnmxX,:);
% %
% colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% xlabel('X threshold space');
% ylabel('Y threshold space');
% zlabel({'noise-norm.', 'dCorMapThreshsInf'});
% view(-16,54);
% title('noise-norm. dCorMapThreshsInf')
% 
% subplot(2,2,3); hold on;
% imagesc(cdCorMapThreshsInf_rnd_noiseStdUnits);
% colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));
% plot(nnmxX,nnmxY,'.k','MarkerSize',10);
% xlabel('X threshold space');
% ylabel('Y threshold space');
% colorbar; axis equal tight;
% %
% % nnADIC = nnADIC_rnd(end);
% % nnADIC_max = nnADIC_max_rnd(end);
% % nnADIC_nnmax = nnADIC_nnmax_rnd(end);
% %
% % ADIC = ADIC_rnd(end);
% % ADIC_max = ADIC_max_rnd(end);
% % ADIC_nnmax = ADIC_nnmax_rnd(end);
% %
% % p_idv = sum(ADIC_rnd>ADIC)/nRandomisations;
% % p_max = sum(ADIC_max_rnd>ADIC_max)/nRandomisations;
% % p_nnmax = sum(ADIC_nnmax_rnd>ADIC_nnmax)/nRandomisations;
% %
% % nn_p_idv = sum(nnADIC_rnd>nnADIC)/nRandomisations;
% % nn_p_max = sum(nnADIC_max_rnd>nnADIC_max)/nRandomisations;
% % nn_p_nnmax = sum(nnADIC_nnmax_rnd>nnADIC_nnmax)/nRandomisations;
% %
% subplot(2,2,4);
% % title({['p-idv = ',num2str(p_idv)],...
% %     ['p-max = ',num2str(p_max)],...
% %     ['p-nnmax = ',num2str(p_nnmax)],...
% %     ['nn-p-idv = ',num2str(nn_p_idv)],...
% %     ['nn-p-max = ',num2str(nn_p_max)],...
% %     ['nn-p-nnmax = ',num2str(nn_p_nnmax)]});
% %
% % p = p_idv;
% 
% switch method
%     case 1
%         savefig(h,'results/ADGTIC1.fig')
%     case 2 
%         savefig(h,'results/ADGTIC2.fig')
%     case 3
%         savefig(h,'results/ADGTIC3.fig')
%     otherwise
% end
% close(h)
% 
% % cmap = helper_power_colormap();
% % colormap(cmap)


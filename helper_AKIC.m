function stat = helper_AKIC(X,Y,nKernelWidths,mxFwhmFac)

% Adaptive Gaussian-Kernel Independence Criterion (AKIC) Test
% Kernel-model maximised-likelihood  (KML) dependence test 
% a general robust test for mutual information between X and Y


%% control variables

% nKernelWidths = 6;
% mxFwhmFac=0.5;
nRandomisations = 100;
monitor = true;


%% preparations

[nObs, dX] = size(X);
[nObs, dY] = size(Y);


%% compute distances

d2X = pdist(X,'Euclidean').^2;
d2Y = pdist(Y,'Euclidean').^2;

% h = figure(100); set(h,'Color','w'); clf;
% subplot(2,1,1); plot(d2X.^.5,d2Y.^.5,'.k');
% xlabel('distances between X obs.');
% ylabel('distances between Y obs.');
% title(['distance scatterplot (r=',num2str(corr(d2X.^.5',d2Y.^.5')),')']);


%% define kernel widths

fwhmPerStd = sqrt(8*log(2));

max_fwhmX = fwhmPerStd * mean(std(X,0,1))*mxFwhmFac;
step = max_fwhmX/nKernelWidths;
fwhmsX = step:step:max_fwhmX;

max_fwhmY = fwhmPerStd * mean(std(Y,0,1))*mxFwhmFac;
step = max_fwhmY/nKernelWidths;
fwhmsY = step:step:max_fwhmY;


%% compute the dependent model's (H1) maximised likelihood (across kernel-width combinations for X and Y)  

[maxLogL_actual, logLs] = helper_maxLogLikelihood(d2X,d2Y,fwhmsX,fwhmsY,nObs,dX,dY);

stat = maxLogL_actual;

% h=figure(110); set(h,'Color','w'); clf;
% subplot(2,1,1); hold on;
% imagesc(logLs); colormap(colorScale([0 0.5 1; 1 0 0],64));
% xlabel('FWHM X');
% ylabel('FWHM Y');
% colorbar; axis equal tight;
% [mx,mxI]=max(logLs(:));
% mn=min(logLs(:));
% [mxY,mxX]=ind2sub([nKernelWidths nKernelWidths],mxI);
% plot(mxX,mxY,'.k','MarkerSize',10);
% 
% subplot(2,1,2); hold on;
% rng = mx-mn;
% surf(logLs); plot3([mxX mxX],[mxY mxY],[mn mx+0.3*rng],'Color','k','LineWidth',2);
% axis tight;
% xlabel('FWHM X'); ylabel('FWHM Y');
% zlabel('log likelihood');
% view(-16,54);
% 
% 
% %% compute the independent model's (H0) distribution of maximised likelihoods
% 
% d2X_sq = squareform(d2X);
% AKIC_rnd = nan(nRandomisations+1,1);
% 
% for randomisationI=1:nRandomisations
%     rndPerm = randperm(nObs);
%     d2X_rnd = squareform(d2X_sq(rndPerm,rndPerm));    
%     
%     if ~monitor
%         maxLogL = helper_maxLogLikelihood(d2X_rnd,d2Y,fwhmsX,fwhmsY,nObs,dX,dY);
%     else % monitor
%         [maxLogL, logLs] = helper_maxLogLikelihood(d2X_rnd,d2Y,fwhmsX,fwhmsY,nObs,dX,dY);
%         
%         if mod(randomisationI,20)==1,
%             figure(110); subplot(2,1,2); hold on;
%             surf(logLs,'FaceColor',[.5 .5 .5],'FaceAlpha',0.2);
%             title(any2str(round(randomisationI/nRandomisations*100),'% done'));
%             axis tight;
%         end
% %         if randomisationI==1
% %             figure(100); subplot(2,1,2); plot(d2X_rnd.^.5,d2Y.^.5,'.k');
% %             xlabel('distances between X obs.'); ylabel('distances between Y obs.');
% %             title(['randomised observations: distance scatterplot (r=',num2str(corr((d2X_rnd.^.5)',d2Y.^.5')),')']);
% %         end
%     end
%     AKIC_rnd(randomisationI) = maxLogL;
%         
% end
% 
% AKIC_rnd(randomisationI+1) = maxLogL_actual;
% 
% p=sum(AKIC_rnd>=maxLogL_actual)/(nRandomisations+1);
% 
% subplot(2,1,2); title(['p = ',num2str(p)]);
% 
% savefig(h,'results/AKIC.fig')
% close(h)
% 

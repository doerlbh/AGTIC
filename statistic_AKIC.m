function stat = statistic_AKIC(xs,ys,nKernelWidths,mxFwhmFac)

stat = helper_AKIC(xs(:),ys(:),nKernelWidths,mxFwhmFac);
%     stat = helper_distcorr(xs(:),ys(:));
end
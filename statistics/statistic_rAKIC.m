function [opt, stat] = statistic_rAKIC(xs,ys,nKernelWidths,mxFwhmFac)

[opt, stat] = helper_rAKIC(xs,ys,nKernelWidths,mxFwhmFac);
%     stat = helper_distcorr(xs(:),ys(:));
end
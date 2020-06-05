function stat = statistic_sqcorr(xs,ys)
    %stat = corr(xs(:),ys(:))^2; % FUCKING THING. This requires the Matlab Statistics Toolbox
    A = cov(xs,ys)/sqrt(var(xs)*var(ys)); stat = A(2,1)^2; % This doesn't.
end

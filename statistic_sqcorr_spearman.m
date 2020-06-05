function stat = statistic_sqcorr_spearman(xs,ys)
    %stat = corr(xs(:),ys(:))^2; % FUCKING THING. This requires the Matlab Statistics Toolbox
    xs_rank = helper_rankorder(xs);
    ys_rank = helper_rankorder(ys);
    A = cov(xs_rank,ys_rank)/sqrt(var(xs_rank)*var(ys_rank)); stat = A(2,1)^2; % This doesn't.
end

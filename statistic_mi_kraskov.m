
function stat = statistic_mi_kraskov(xs,ys,loc,k)
    stat = max(helper_MIhigherdim([xs(:), ys(:)]',loc,k),0)*log2(exp(1));
end
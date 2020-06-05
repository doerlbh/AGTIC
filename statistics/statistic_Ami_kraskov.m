
function [statMax, statInfMax] = statistic_Ami_kraskov(xs,ys,loc,nNorm)

stat = zeros(11,1);
statInf = zeros(11,1);

xs = xs(:);
ys = ys(:);

for k = 1:5:51
    stat(k) = max(helper_MIhigherdim([xs, ys]',loc,k),0)*log2(exp(1));
    stat_nulls = zeros(nNorm,1);
    for n = 1:nNorm
        stat_nulls(n) = max(helper_MIhigherdim([xs, ys(randperm(length(ys)))]',loc,k),0)*log2(exp(1));
    end
    statInf(k) = stat(k) / mean(stat_nulls);
%     disp('----')
%     stat(k)
%     mean(stat_nulls)
end

statMax = max(stat);
statInfMax = max(statInf);
    
end
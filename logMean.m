function logAvg = logMean(logValues)
% returns the log of the mean of the exps of the passed values.
% useful when likelihoods are very small, their logs have high absolute
% values and are negative, and the exps of the log likelihoods are not
% distinct from 0 at double precision. ignores NaNs.

n = numel(logValues)-sum(isnan(logValues));
maxLogVal = max(logValues);
logAvg = -log(n) + log(nansum(exp(logValues-maxLogVal)))+maxLogVal;


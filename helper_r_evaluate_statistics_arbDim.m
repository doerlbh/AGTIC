function [optimals, stats, statnames] = helper_r_evaluate_statistics_arbDim(xs,ys,nRandomisations,env)

% xs = xs(:);
% ys = ys(:);

% num_stats = 33;
% Containers
stats = [];
% stats = nan(num_stats,1);
statnames = {};

% dCor
statnames{1} = 'dCor';
stats(1) = statistic_dcor(xs,ys);
disp(['dCor ' num2str(stats(1))])

% for ADGTIC:
nThreshs = 5;
nSearchRandomisations = 10;
nNormRandomisations = 10;
% nNormRandomisations = nRandomisations;

% ADGTIC1
statnames{2} = 'ADGTIC1 - dCorMax';
statnames{3} = 'ADGTIC1 - dCorInfMax';
statnames{4} = 'ADGTIC1 - nndCorInfMax';
[optimals.ADGTIC1dCorMax, optimals.ADGTIC1dCorInfMax, optimals.ADGTIC1nndCorInfMax, stats(2), stats(3), stats(4)] = statistic_rADGTIC1(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC1 ' num2str(stats(2)) ' ' num2str(stats(3)) ' ' num2str(stats(4))])

% ADGTIC2
statnames{5} = 'ADGTIC2 - dCorMax';
statnames{6} = 'ADGTIC2 - dCorInfMax';
statnames{7} = 'ADGTIC2 - nndCorInfMax';
[optimals.ADGTIC2dCorMax, optimals.ADGTIC2dCorInfMax, optimals.ADGTIC2nndCorInfMax, stats(5), stats(6), stats(7)] = statistic_rADGTIC2(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC2 ' num2str(stats(5)) ' ' num2str(stats(6)) ' ' num2str(stats(7))])

% ADGTIC3
statnames{8} = 'ADGTIC3 - dCorMax';
statnames{9} = 'ADGTIC3 - dCorInfMax';
statnames{10} = 'ADGTIC3 - nndCorInfMax';
[optimals.ADGTIC3dCorMax, optimals.ADGTIC3dCorInfMax, optimals.ADGTIC3nndCorInfMax, stats(8), stats(9), stats(10)] = statistic_rADGTIC3(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC3 ' num2str(stats(8)) ' ' num2str(stats(9)) ' ' num2str(stats(10))])

% ADsnpIC
statnames{11} = 'ADIC - snpInf';
[optimals.ADsnpIC, stats(11)] = statistic_rADsnpIC(xs,ys,nThreshs,nRandomisations);
disp(['ADsnpIC ' num2str(stats(11))])

% ADdsnpIC
statnames{12} = 'ADIC - dsnpInf';
[optimals.ADdsnpIC, stats(12)] = statistic_rADdsnpIC(xs,ys,nThreshs,nRandomisations);
disp(['ADdsnpIC ' num2str(stats(12))])

% HSIC
params.shuff=50;
params.sigx=-1;
params.sigy=-1;
params.bootForce=1;
statnames{13} = 'HSIC';
stats(13) = statistic_HSIC(xs,ys,params);
disp(['HSIC ' num2str(stats(13))])

% AKIC
nKernelWidths = 6;
mxFwhmFac=0.5;
statnames{14} = 'AKIC';
[optimals.AKIC, stats(14)] = statistic_rAKIC(xs,ys,nKernelWidths,mxFwhmFac);
disp(['AKIC ' num2str(stats(14))])

% rdmCor
statnames{15} = 'rdmCor';
stats(15) = statistic_rdmCor(xs,ys);
disp(['rdmCor ' num2str(stats(15))])

% CD3
nRandomisationsForCalibration = 10;
nBins = 10;
statnames{16} = 'CD3';
stats(16) = statistic_CD3(xs,ys,nRandomisationsForCalibration,nBins);
disp(['CD3 ' num2str(stats(16))])

% pADGTIC1
statnames{17} = 'pADGTIC1 - dCorMax';
statnames{18} = 'pADGTIC1 - dCorInfMax';
statnames{19} = 'pADGTIC1 - nndCorInfMax';
[optimals.pADGTIC1dCorMax, optimals.pADGTIC1dCorInfMax, optimals.pADGTIC1nndCorInfMax, stats(17), stats(18), stats(19)] = statistic_rpADGTIC1(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC1 ' num2str(stats(17)) ' ' num2str(stats(18)) ' ' num2str(stats(19))])

% pADGTIC2
statnames{20} = 'pADGTIC2 - dCorMax';
statnames{21} = 'pADGTIC2 - dCorInfMax';
statnames{22} = 'pADGTIC2 - nndCorInfMax';
[optimals.pADGTIC2dCorMax, optimals.pADGTIC2dCorInfMax, optimals.pADGTIC2nndCorInfMax, stats(20), stats(21), stats(22)] = statistic_rpADGTIC2(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC2 ' num2str(stats(20)) ' ' num2str(stats(21)) ' ' num2str(stats(22))])

% pADGTIC3
statnames{23} = 'pADGTIC3 - dCorMax';
statnames{24} = 'pADGTIC3 - dCorInfMax';
statnames{25} = 'pADGTIC3 - nndCorInfMax';
[optimals.pADGTIC3dCorMax, optimals.pADGTIC3dCorInfMax, optimals.pADGTIC3nndCorInfMax, stats(31), stats(32), stats(33)] = statistic_rpADGTIC3(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC3 ' num2str(stats(23)) ' ' num2str(stats(24)) ' ' num2str(stats(25))])

% Make stats a column vector
stats = stats(:);

end
function [stats, statnames] = helper_evaluate_statistics(xs,ys,nRandomisations,env)

xs = xs(:);
ys = ys(:);

% num_stats = 22;
% Containers
stats = [];
% stats = nan(num_stats,1);
statnames = {};

% MIC Reshef
% Need to do this weirdness because MIC glitches a fraction of the time
statnames{1} = 'MIC (Reshef)';
a = statistic_mic_reshef(xs(:),ys(:));
k = 0;
while numel(a) ~= 1;
    k = k+1;
    disp(['MIC glitch number ' num2str(k) '. Trying again...'])
    a = statistic_mic_reshef(xs(:),ys(:));
end
stats(1) = a;
disp(['MIC ' num2str(a)])

% % MIC (and I_MIC) Albanese
% alpha = 0.6;
% c = 15;
% statnames{2} = 'MIC (Albanese)';
% statnames{3} = 'MI (MIC Albanese)';
% [stats(2), stats(3)] = statistic_mic_albanese(xs,ys,alpha,c);

% MI Kraskov with various k
statnames{2} = 'MI (Kraskov k=1)';
stats(2) = statistic_mi_kraskov(xs,ys,env,1);
disp(['MI k=1 ' num2str(stats(2))])

statnames{3} = 'MI (Kraskov k=6)';
stats(3) = statistic_mi_kraskov(xs,ys,env,6);
disp(['MI k=6 ' num2str(stats(3))])

statnames{4} = 'MI (Kraskov k=20)';
stats(4) = statistic_mi_kraskov(xs,ys,env,20);
disp(['MI k=20 ' num2str(stats(4))])

% R^2
statnames{5} = 'R^2';
stats(5) = statistic_sqcorr(xs,ys);
disp(['R^2 ' num2str(stats(5))])

% dCor
statnames{6} = 'dCor';
stats(6) = statistic_dcor(xs,ys);
disp(['dCor ' num2str(stats(6))])

% Hoeffding's D
statnames{7} = ['Hoeffding''', 's D'];
stats(7) = statistic_hoeffding(xs,ys);
disp(['Hoeffding''', 's D ' num2str(stats(7))])

% for ADGTIC:
nThreshs = 5;
nSearchRandomisations = 10;
nNormRandomisations = 10;
% nNormRandomisations = nRandomisations;

% ADGTIC1
statnames{8} = 'ADGTIC1 - dCorMax';
statnames{9} = 'ADGTIC1 - dCorInfMax';
statnames{10} = 'ADGTIC1 - nndCorInfMax';
[stats(8), stats(9), stats(10)] = statistic_ADGTIC1(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC1 ' num2str(stats(8)) ' ' num2str(stats(9)) ' ' num2str(stats(10))])

% ADGTIC2
statnames{11} = 'ADGTIC2 - dCorMax';
statnames{12} = 'ADGTIC2 - dCorInfMax';
statnames{13} = 'ADGTIC2 - nndCorInfMax';
[stats(11), stats(12), stats(13)] = statistic_ADGTIC2(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC2 ' num2str(stats(11)) ' ' num2str(stats(12)) ' ' num2str(stats(13))])

% ADGTIC3
statnames{14} = 'ADGTIC3 - dCorMax';
statnames{15} = 'ADGTIC3 - dCorInfMax';
statnames{16} = 'ADGTIC3 - nndCorInfMax';
[stats(14), stats(15), stats(16)] = statistic_ADGTIC3(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['ADGTIC3 ' num2str(stats(14)) ' ' num2str(stats(15)) ' ' num2str(stats(16))])

% ADsnpIC
statnames{17} = 'ADIC - snpInf';
stats(17) = statistic_ADsnpIC(xs,ys,nThreshs,nRandomisations);
disp(['ADsnpIC ' num2str(stats(17))])

% ADdsnpIC
statnames{18} = 'ADIC - dsnpInf';
stats(18) = statistic_ADdsnpIC(xs,ys,nThreshs,nRandomisations);
disp(['ADdsnpIC ' num2str(stats(17))])

% HSIC
params.shuff=50;
params.sigx=-1;
params.sigy=-1;
params.bootForce=1;
statnames{19} = 'HSIC';
stats(19) = statistic_HSIC(xs,ys,params);
disp(['HSIC ' num2str(stats(19))])

% AKIC
nKernelWidths = 6;
mxFwhmFac=0.5;
statnames{20} = 'AKIC';
stats(20) = statistic_AKIC(xs,ys,nKernelWidths,mxFwhmFac);
disp(['AKIC ' num2str(stats(20))])

% rdmCor
statnames{21} = 'rdmCor';
stats(21) = statistic_rdmCor(xs,ys);
disp(['rdmCor ' num2str(stats(21))])

% CD3
nRandomisationsForCalibration = 10;
nBins = 10;
statnames{22} = 'CD3';
stats(22) = statistic_CD3(xs,ys,nRandomisationsForCalibration,nBins);
disp(['CD3 ' num2str(stats(22))])

% MI - adaptive
statnames{23} = 'I - kMax';
statnames{24} = 'I - kInfMax';
[stats(23), stats(24)] = statistic_Ami_kraskov(xs,ys,env,nNormRandomisations);
disp(['Adaptive MI ' num2str(stats(23)) ' ' num2str(stats(24))]);

% pADGTIC1
statnames{25} = 'pADGTIC1 - dCorMax';
statnames{26} = 'pADGTIC1 - dCorInfMax';
statnames{27} = 'pADGTIC1 - nndCorInfMax';
[stats(25), stats(26), stats(27)] = statistic_pADGTIC1(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC1 ' num2str(stats(25)) ' ' num2str(stats(26)) ' ' num2str(stats(27))])

% pADGTIC2
statnames{28} = 'pADGTIC2 - dCorMax';
statnames{29} = 'pADGTIC2 - dCorInfMax';
statnames{30} = 'pADGTIC2 - nndCorInfMax';
[stats(28), stats(29), stats(30)] = statistic_pADGTIC2(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC2 ' num2str(stats(28)) ' ' num2str(stats(29)) ' ' num2str(stats(30))])

% pADGTIC3
statnames{31} = 'pADGTIC3 - dCorMax';
statnames{32} = 'pADGTIC3 - dCorInfMax';
statnames{33} = 'pADGTIC3 - nndCorInfMax';
[stats(31), stats(32), stats(33)] = statistic_pADGTIC3(xs,ys,nThreshs,nNormRandomisations,nSearchRandomisations);
disp(['pADGTIC3 ' num2str(stats(31)) ' ' num2str(stats(32)) ' ' num2str(stats(33))])

% Make stats a column vector
stats = stats(:);

end
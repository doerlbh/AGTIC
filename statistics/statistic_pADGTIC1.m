function [stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = statistic_pADGTIC1(xs,ys,nThreshs,nRandomisations,nSearchRandomisations)
 
    [stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_pADGTIC(xs,ys,nThreshs,nRandomisations,nSearchRandomisations,1);

end
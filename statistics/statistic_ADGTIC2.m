function [stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = statistic_ADGTIC2(xs,ys,nThreshs,nRandomisations,nSearchRandomisations)
 
    [stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_ADGTIC(xs,ys,nThreshs,nRandomisations,nSearchRandomisations,2);

end
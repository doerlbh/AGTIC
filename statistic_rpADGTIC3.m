function [opt1, opt2, opt3, stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = statistic_rpADGTIC3(xs,ys,nThreshs,nRandomisations,nSearchRandomisations)
 
    [opt1, opt2, opt3, stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_rpADGTIC(xs,ys,nThreshs,nRandomisations,nSearchRandomisations,3);

end
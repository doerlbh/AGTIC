function [opt1, opt2, opt3, stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = statistic_rADGTIC2(xs,ys,nThreshs,nRandomisations,nSearchRandomisations)
 
    [opt1, opt2, opt3, stat_dCorMax, stat_dCorInfMax, stat_nndCorInfMax] = helper_rADGTIC(xs,ys,nThreshs,nRandomisations,nSearchRandomisations,2);

end
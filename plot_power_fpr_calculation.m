%% Draws Fig. 4
clear all
close all
clc

cd '/Users/DoerLBH/Dropbox/git/GTMI'

%%

width = 17.8;
height = 4.5;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces a figure 13.56 x 4.08. Reduce 2x to a width of 6.8 in

cmap = colormap(colorcube);

% Get list of files containing power calculation results
files = dir('results/power_fdr/results*.mat');
num_files = numel(files);

% Read in unordered results
for n=1:num_files
    full_file_name = ['results/power_fdr/' files(n).name];
    load(full_file_name)
    unordered_results(n) = results;
end

% Define order of noisy relationships
relationships = {...
    'linear', 'parabolic', 'sinusoidal', 'circular', ...
    'checkerboard'};
num_relationships = numel(relationships);

% Alter stat names for display purposes
% And set order in which to plot them
stat_names = results.stat_names;
num_stats = numel(stat_names);
stat_is = [];
stat_colors = [];

for n=1:numel(stat_names)
    name = stat_names{n};
    switch stat_names{n}
        case 'R^2'
            stat_names{n} = 'R^2 ';
            stat_is(1) = n;
            stat_colors(1,:) = cmap(1,:);
        case 'dCor'
            stat_names{n} = 'dCor ';
            stat_is(2) = n;
            stat_colors(2,:) = cmap(2,:);
        case ['Hoeffding''', 's D']
            stat_names{n} = ['Hoeffding''', 's D'];
            stat_is(3) = n;
            stat_colors(3,:) = cmap(3,:);
        case 'MI (Kraskov k=1)',
            stat_names{n} = 'I (k = 1) ';
            stat_is(4) = n;
            stat_colors(4,:) = cmap(4,:);
        case 'MI (Kraskov k=6)',
            stat_names{n} = 'I (k = 6) ';
            stat_is(5) = n;
            stat_colors(5,:) = cmap(5,:);
        case 'MI (Kraskov k=20)',
            stat_names{n} = 'I (k = 20) ';
            stat_is(6) = n;
            stat_colors(6,:) = cmap(6,:);
        case 'MIC (Reshef)',
            stat_names{n} = 'MIC ';
            stat_is(7) = n;
            stat_colors(7,:) = cmap(7,:);
        case 'ADGTIC1 - dCorMax'
            stat_names{n} = 'ADGTIC1 - dCorMax ';
            stat_is(8) = n;
            stat_colors(8,:) = cmap(8,:);
        case 'ADGTIC1 - dCorInfMax'
            stat_names{n} = 'ADGTIC1 - dCorInfMax ';
            stat_is(9) = n;
            stat_colors(9,:) = cmap(9,:);
        case 'ADGTIC1 - nndCorInfMax'
            stat_names{n} = 'ADGTIC1 - nndCorInfMax ';
            stat_is(10) = n;
            stat_colors(10,:) = cmap(10,:);
        case 'ADGTIC2 - dCorMax'
            stat_names{n} = 'ADGTIC2 - dCorMax ';
            stat_is(11) = n;
            stat_colors(11,:) = cmap(11,:);
        case 'ADGTIC2 - dCorInfMax'
            stat_names{n} = 'ADGTIC2 - dCorInfMax ';
            stat_is(12) = n;
            stat_colors(12,:) = cmap(12,:);
        case 'ADGTIC2 - nndCorInfMax'
            stat_names{n} = 'ADGTIC2 - nndCorInfMax ';
            stat_is(13) = n;
            stat_colors(13,:) = cmap(13,:);
        case 'ADGTIC3 - dCorMax'
            stat_names{n} = 'ADGTIC3 - dCorMax ';
            stat_is(14) = n;
            stat_colors(14,:) = cmap(14,:);
        case 'ADGTIC3 - dCorInfMax'
            stat_names{n} = 'ADGTIC3 - dCorInfMax ';
            stat_is(15) = n;
            stat_colors(15,:) = cmap(15,:);
        case 'ADGTIC3 - nndCorInfMax'
            stat_names{n} = 'ADGTIC3 - nndCorInfMax ';
            stat_is(16) = n;
            stat_colors(16,:) = cmap(16,:);
        case 'ADIC - snpInf'
            stat_names{n} = 'ADIC - snpInf ';
            stat_is(17) = n;
            stat_colors(17,:) = cmap(17,:);
        case 'ADIC - dsnpInf'
            stat_names{n} = 'ADIC - dsnpInf ';
            stat_is(18) = n;
            stat_colors(18,:) = cmap(18,:);
        case 'HSIC'
            stat_names{n} = 'HSIC ';
            stat_is(19) = n;
            stat_colors(19,:) = cmap(19,:);
        case 'AKIC'
            stat_names{n} = 'AKIC ';
            stat_is(20) = n;
            stat_colors(20,:) = cmap(20,:);
        case 'rdmCor'
            stat_names{n} = 'rdmCor ';
            stat_is(21) = n;
            stat_colors(21,:) = cmap(21,:);
        case 'CD3'
            stat_names{n} = 'CD3 ';
            stat_is(22) = n;
            stat_colors(22,:) = cmap(22,:);
        otherwise,
    end
end


% Order all results by realtionship, then by noise
for r=1:num_relationships
    
    % For each relationship, gather all results that share that relationships
    this_relationship = relationships{r};
    k=1;
    for n=1:num_files
        if strcmp(this_relationship, unordered_results(n).computation.relationship)
            these_results(k) = unordered_results(n);
            these_noises(k) = unordered_results(n).computation.noise;
            k = k+1;
        end
    end
    
    % Order results by ascending noise
    noise_order = helper_rankorder(these_noises);
    these_results(noise_order) = these_results;
    ordered_results{r} = these_results;
end

% Plot results for each relationship
%figure('position', [113         649        1311         509], 'paperpositionmode', 'auto');
for r=1:num_relationships
    
    reseq = [8,9,10,11,12,13,14,15,16,18,17,20,22,2,19,3,4,5,6,7,21,1];
    
    % For each relationship, get results
    these_results = ordered_results{r};
    num_results = numel(these_results);
    
    % For each results (i.e. given noise value), get power of all
    % statistics
    power_mat = [];
    for n=1:numel(these_results)
        pos_stats = abs(these_results(n).pos_stats);
        null_stats = abs(these_results(n).null_stats);
        num_trials = size(null_stats,2);
        stats_thresholds = repmat(helper_quantile(null_stats,.95,2),1,num_trials);
        successes = sum((pos_stats > stats_thresholds),2);
        power_mat(:,n) = successes/num_trials;
    end
    
    stat_names = stat_names(reseq);
    power_mat = power_mat(reseq,:);
%         stat_is = stat_is(reseq);
    
    % Get sample resultionship
    xs_sample = these_results(1).xs_sample;
    ys_sample = these_results(1).ys_sample;
    
    % Make sure number of rows matches number of stats
    assert(size(power_mat,1) == num_stats)
    
    % Plot example relationship with noise = 0.1
    subplot(3,num_relationships,r)
    plot(xs_sample(:), ys_sample(:), '.k', 'markerfacecolor', 'k', 'markersize', 10)
    set(gca, 'box', 'on', 'xtick', [], 'ytick', [])
    title(relationships{r}, 'fontsize', title_font_size)
    axis image
    axis square
    axis off
    
    % Plot resutls of power calculation
    subplot(3,num_relationships,[num_relationships, 2*num_relationships]+r)
    imagesc(power_mat(stat_is,:))
    set(gca, 'clim', [0, 1], 'box', 'on')
    midpoint = 1 + (num_results-1)*log(3)/log(10);
    set(gca, 'xtick', [1 midpoint num_results], 'xticklabel', [1 3 10], 'clim', [0 1], 'fontsize', font_size, 'linewidth', 0.5)
    %title(relationships{r}, 'fontsize', title_font_size)
    hold on
    num_noises = size(power_mat,2);
    
    % Annotate heatmaps
    if r==1     % list of dependence measures
        set(gca, 'ytick', 1:num_stats, 'yticklabel', stat_names(stat_is), 'fontsize', font_size)
        
        % This is totally stupid. Matlab can't use latex on y-ticks, so we
        % have to hack the R^2 label
        %         h3 = ylabel('R^2', 'rot', 0);
        %         set(h3, 'position', [-2.1840    1.3950   17.3205])
    else
        set(gca, 'ytick', 1:num_stats, 'yticklabel', [])
    end
    if r == 3   % x-axis label
        xlabel('noise amplitude', 'fontsize', font_size)
    end
    if r == num_relationships % colorbar
        h = colorbar();
        set(h,'fontsize',font_size, 'ytick',[0, .5, 1], 'yticklabel', {'0%', '50%', '100%'}, 'position', [0.9256    0.2303    0.0125    0.2602], 'linewidth', 0.5);
        ylabel(h,'power')
    end
    
    % Mark columns within 25% of maximum
    % Compute noise
    nearby = .25;
    noise_amplitudes = [];
    for n=1:num_results
        noise_amplitudes(1,n) = 1*these_results(n).computation.noise;
    end
    A = (power_mat > .5).*repmat(noise_amplitudes,num_stats,1);
    max_noises = max(A')';
    ub = max(max_noises);
    lb = ub*(1 - nearby);
    stats_to_star = (max_noises <= ub) & (max_noises > lb);
    ys = find(stats_to_star(stat_is));
    xs = num_results*ones(size(ys))/10;
    hold on
    plot(xs,ys,'*k','markersize', 3, 'linewidth', 0.3)
end

% Set colormap
cmap = helper_power_colormap();
colormap(cmap)

colormap(colorScale([0 0.5 1; 0.5 0.5 0.5; 1 0 0],64));


% Save figure
% saveas(gcf,'figures/power_noise.eps','epsc')


%% Draws line plots

width = 10;
height = 15;
font_size = 7;
letter_size = 10;
title_font_size = 8;

cmap = colormap(colorcube);

figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
%figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [1.3536    1.9177   20.7840   20.1636])
% Produces a figure 13.56 x 4.08. Reduce 2x to a width of 6.8 in

% % Get list of files containing power calculation results
% files = dir('results/power_fdr/results*.mat');
% num_files = numel(files);
%
% % Read in unordered results
% for n=1:num_files
%     full_file_name = ['results/power_fdr/' files(n).name];
%     load(full_file_name)
%     unordered_results(n) = results;
% end
%
% % Define order of noisy relationships
% relationships = {'linear', 'parabolic', 'sinusoidal', 'circular', 'checkerboard'};
% num_relationships = numel(relationships);
%
% % Alter stat names for display purposes
% % And set order in which to plot them
% stat_names = results.stat_names;
% num_stats = numel(stat_names);
% stat_is = [];
% stat_colors = [];
% for n=1:numel(stat_names)
%     name = stat_names{n};
%     switch stat_names{n}
%         case 'R^2'
%             stat_names{n} = 'R^2 ';
%             stat_is(1) = n;
%             stat_colors(1,:) = cmap(1,:);
%         case 'dCor'
%             stat_names{n} = 'dCor ';
%             stat_is(2) = n;
%             stat_colors(2,:) = cmap(2,:);
%         case ['Hoeffding''', 's D']
%             stat_names{n} = 'Hoeffdings D';
%             stat_is(3) = n;
%             stat_colors(3,:) = cmap(3,:);
%         case 'MI (Kraskov k=1)',
%             stat_names{n} = 'I (k = 1) ';
%             stat_is(4) = n;
%             stat_colors(4,:) = cmap(4,:);
%         case 'MI (Kraskov k=6)',
%             stat_names{n} = 'I (k = 6) ';
%             stat_is(5) = n;
%             stat_colors(5,:) = cmap(5,:);
%         case 'MI (Kraskov k=20)',
%             stat_names{n} = 'I (k = 20) ';
%             stat_is(6) = n;
%             stat_colors(6,:) = cmap(6,:);
%         case 'MIC (Reshef)',
%             stat_names{n} = 'MIC ';
%             stat_is(7) = n;
%             stat_colors(7,:) = cmap(7,:);
%         case 'ADGTIC1 - dCorMax'
%             stat_names{n} = 'ADGTIC1 - dCorMax ';
%             stat_is(8) = n;
%             stat_colors(8,:) = cmap(8,:);
%         case 'ADGTIC1 - dCorInfMax'
%             stat_names{n} = 'ADGTIC1 - dCorInfMax ';
%             stat_is(9) = n;
%             stat_colors(9,:) = cmap(9,:);
%         case 'ADGTIC1 - nndCorInfMax'
%             stat_names{n} = 'ADGTIC1 - nndCorInfMax ';
%             stat_is(10) = n;
%             stat_colors(10,:) = cmap(10,:);
%         case 'ADGTIC2 - dCorMax'
%             stat_names{n} = 'ADGTIC2 - dCorMax ';
%             stat_is(11) = n;
%             stat_colors(11,:) = cmap(11,:);
%         case 'ADGTIC2 - dCorInfMax'
%             stat_names{n} = 'ADGTIC2 - dCorInfMax ';
%             stat_is(12) = n;
%             stat_colors(12,:) = cmap(12,:);
%         case 'ADGTIC2 - nndCorInfMax'
%             stat_names{n} = 'ADGTIC2 - nndCorInfMax ';
%             stat_is(13) = n;
%             stat_colors(13,:) = cmap(13,:);
%         case 'ADGTIC3 - dCorMax'
%             stat_names{n} = 'ADGTIC3 - dCorMax ';
%             stat_is(14) = n;
%             stat_colors(14,:) = cmap(14,:);
%         case 'ADGTIC3 - dCorInfMax'
%             stat_names{n} = 'ADGTIC3 - dCorInfMax ';
%             stat_is(15) = n;
%             stat_colors(15,:) = cmap(15,:);
%         case 'ADGTIC3 - nndCorInfMax'
%             stat_names{n} = 'ADGTIC3 - nndCorInfMax ';
%             stat_is(16) = n;
%             stat_colors(16,:) = cmap(16,:);
%         case 'ADIC - snpInf'
%             stat_names{n} = 'ADIC - snpInf ';
%             stat_is(17) = n;
%             stat_colors(17,:) = cmap(17,:);
%         case 'ADIC - dsnpInf'
%             stat_names{n} = 'ADIC - dsnpInf ';
%             stat_is(18) = n;
%             stat_colors(18,:) = cmap(18,:);
%         case 'HSIC'
%             stat_names{n} = 'HSIC ';
%             stat_is(19) = n;
%             stat_colors(19,:) = cmap(19,:);
%         case 'AKIC'
%             stat_names{n} = 'AKIC ';
%             stat_is(20) = n;
%             stat_colors(20,:) = cmap(20,:);
%         case 'rdmCor'
%             stat_names{n} = 'rdmCor ';
%             stat_is(21) = n;
%             stat_colors(21,:) = cmap(21,:);
%         case 'CD3'
%             stat_names{n} = 'CD3 ';
%             stat_is(22) = n;
%             stat_colors(22,:) = cmap(22,:);
%         otherwise,
%     end
% end
%
%
% % Order all results by realtionship, then by noise
% for r=1:num_relationships
%
%     % For each relationship, gather all results that share that relationships
%     this_relationship = relationships{r};
%     k=1;
%     for n=1:num_files
%         if strcmp(this_relationship, unordered_results(n).computation.relationship)
%             these_results(k) = unordered_results(n);
%             these_noises(k) = unordered_results(n).computation.noise;
%             k = k+1;
%         end
%     end
%
%     % Order results by ascending noise
%     noise_order = helper_rankorder(these_noises);
%     these_results(noise_order) = these_results;
%     ordered_results{r} = these_results;
% end

% Plot results for each relationship
%figure('position', [113         649        1311         509], 'paperpositionmode', 'auto');
power_mat_full = [];
for r=1:num_relationships
    
    % For each relationship, get results
    these_results = ordered_results{r};
    num_results = numel(these_results);
    
    % For each results (i.e. given noise value), get power of all
    % statistics
    power_mat = [];
    for n=1:numel(these_results)
        pos_stats = abs(these_results(n).pos_stats);
        null_stats = abs(these_results(n).null_stats);
        num_trials = size(null_stats,2);
        stats_thresholds = repmat(helper_quantile(null_stats,.95,2),1,num_trials);
        successes = sum((pos_stats > stats_thresholds),2);
        power_mat(:,n) = successes/num_trials;
    end
    
    % Get sample resultionship
    xs_sample = these_results(1).xs_sample;
    ys_sample = these_results(1).ys_sample;
    
    % Make sure number of rows matches number of stats
    assert(size(power_mat,1) == num_stats)
    
    % Plot example relationship with nosie = 0.1
    %subplot(num_relationships,3,(r-1)*3+1)
    %plot(xs_sample(:), ys_sample(:), '.k', 'markerfacecolor', 'k', 'markersize', 6)
    %set(gca, 'box', 'on', 'xtick', [], 'ytick', [])
    %axis image
    %axis square
    %axis off
    
    % Compute noise amplitudes
    noise_amplitudes = [];
    for n=1:num_results
        noise_amplitudes(1,n) = 10*these_results(n).computation.noise;
    end
    
    % Plot resutls of power calculation
    subplot(num_relationships,1,r)
    %subplot(num_relationships,3,(r-1)*3+[2, 3])
    %semilogx(noise_amplitudes, power_mat(stat_is,:)', 'linewidth', 2)
    xs = noise_amplitudes;
    for i = fliplr(1:numel(stat_is))
        semilogx(noise_amplitudes, power_mat(stat_is(i),:), 'linewidth', 2, 'color', stat_colors(i,:))
        hold on
    end
    ylim([0, 1])
    %     xlim([1, 10])
    title(relationships{r}, 'fontsize', title_font_size)
    hold on
    num_noises = size(power_mat,2);
    
    if r == num_relationships
        xlabel('noise amplitude', 'fontsize', font_size)
    end
    ylabel('power', 'fontsize', font_size)
    set(gca, 'box', 'on', 'fontsize', font_size)
    
    power_mat_full(r,:,:) = power_mat;
end

% Set colormap
cmap = helper_power_colormap();
colormap(cmap)


save results/power_fdr/power_noise.mat power_mat_full noise_amplitudes

% Save figure
% saveas(gcf,'figures/power_noise_line.eps','epsc')


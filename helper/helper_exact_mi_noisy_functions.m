%measure = 'Kraskov', 'Reshef', or 'MI';
% If measure == 'Kraskov', need to supply a value for k
% In all cases, a value for N is optional

function result = helper_exact_mi_noisy_functions(noise_amps)

% These are the hard-coded noise amplitudes we use
num_noise_amps = numel(noise_amps);

% Define functions with noise added
funcs = helper_define_functions(noise_amps, 1E5);

num_funcs = size(funcs,1);
t=0;

% Define containers to hold all statistics
% columns -> functions
% rows -> noise levels
result.noise_rsq = [];
result.I_xy = [];
result.I_self = [];

for n=1:num_funcs
    
    % Display progress
    N = funcs{n,1};
    func_name = funcs{n,4};
    fprintf('Doing computations for: %s using %d data points...\n', func_name, N);
    
    % Get x-values and noiseless y-values
    x = funcs{n,5}(:);
    y0 = funcs{n,6}(:);
    for m=1:num_noise_amps
        
        % Get noisy y-values
        y = funcs{n,7}(:,m);
        
        % Compute Rsq noise
        result.noise_rsq(m,n) = 1 - statistic_sqcorr(y0,y); %%corr(y0,y, 'type', 'pearson')^2;
        
        % Record monotonicity
        result.monotonicity(m,1) = funcs{n,8};
        
        % Compute exact mutual information semianalytically
        range = max(y0)-min(y0);
        amp = noise_amps(m)*range;
        ybins = linspace(min(y)-eps, max(y)+eps, 500);
        dy = ybins(2)-ybins(1);
        counts = hist(y,ybins);
        ps = counts/sum(counts);
        H_y = -sum(ps.*log(ps+eps));
        H_ygx = log(amp/dy);
        mi = max(H_y - H_ygx,0);
        
        % Store information values (they are theoretically the same)
        result.I_xy(m,n) = mi;
        result.I_self(m,n) = mi;
    end
 
end

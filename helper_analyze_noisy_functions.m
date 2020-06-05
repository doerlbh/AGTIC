%measure = 'Kraskov', 'Reshef', or 'MI';
% If measure == 'Kraskov', need to supply a value for k
% In all cases, a value for N is optional

function result = helper_analyze_noisy_functions(noise_amps, N)

% These are the hard-coded noise amplitudes we use
num_noise_amps = numel(noise_amps);

% Define functions with noise added
if exist('N') && N > 0
    funcs = helper_define_functions(noise_amps, N);
else
    funcs = helper_define_functions(noise_amps);
end

num_funcs = size(funcs,1);
t=0;

% Define containers to hold all statistics
% columns -> functions
% rows -> noise levels
result.noise_rsq = [];
result.MIC_reshef_xy = [];
result.MIC_reshef_self = [];
result.MIC_albanese_xy = [];
result.MIC_albanese_self = [];
result.I_MIC_albanese_xy = [];
result.I_MIC_albanese_self = [];
result.I01_xy = [];
result.I01_self = [];
result.I06_xy = [];
result.I06_self = [];
result.I20_xy = [];
result.I20_xy = [];
result.dcor_xy = [];
result.dcor_self = [];
result.hoeffding_xy = [];
result.hoeffding_self = [];

for n=1:num_funcs
    
    % Display progress
    N = funcs{n,1};
    func_name = funcs{n,4};
    fprintf('Doing computations for: %s using %d data points...\n', func_name, N);
    
    % Get x-values and noiseless y-values
    x = funcs{n,5}(:);
    y0 = funcs{n,6}(:);
    
    % Record monotonicity
    result.monotonicity(n,1) = funcs{n,8};
    
    for m=1:num_noise_amps
        
        % Get noisy y-values
        y = funcs{n,7}(:,m);
        
        % Compute Rsq noise
        result.noise_rsq(m,n) = 1 - statistic_sqcorr(y0,y); %corr(y0,y, 'type', 'pearson')^2;
        
        % Perform Kraskov mutual information estimates
        result.I01_xy(m,n) = statistic_mi_kraskov(x,y,1);
        result.I06_xy(m,n) = statistic_mi_kraskov(x,y,6);
        result.I20_xy(m,n) = statistic_mi_kraskov(x,y,20);
        result.I01_self(m,n) = statistic_mi_kraskov(y0,y,1);
        result.I06_self(m,n) = statistic_mi_kraskov(y0,y,6);
        result.I20_self(m,n) = statistic_mi_kraskov(y0,y,20);
        
        % Perform Albanese MIC estimates
        [result.MIC_albanese_xy(m,n), result.I_MIC_albanese_xy(m,n)] = statistic_mic_albanese(x, y,0.6,15);
        [result.MIC_albanese_self(m,n), result.I_MIC_albanese_self(m,n)] = statistic_mic_albanese(y0,y,0.6,15);
        
        % do dCor and Hoeffding computations
        result.dcor_xy(m,n) = statistic_dcor(x,y);
        result.dcor_self(m,n) = statistic_dcor(y0,y);
        result.hoeffding_xy(m,n) = statistic_hoeffding(x,y);
        result.hoeffding_self(m,n) = statistic_hoeffding(y0,y);
    end
    
    % Compute MIC values
    ys = funcs{n,7};
    
    % Have to do this stupid stuff because MIC glitches some fraction of
    % the time
    a = statistic_mic_reshef(x,ys);
    k = 0;
    while numel(a) ~= numel(noise_amps);
        k = k+1;
        disp(['MIC glitch number ' num2str(k) '. Trying again...'])
        a = statistic_mic_reshef(x,ys);
    end
    result.MIC_reshef_xy(:,n) = a;
    
    b = statistic_mic_reshef(y0,ys);
    k = 0;
    while numel(b) ~= numel(noise_amps);
        k = k+1;
        disp(['MIC glitch number ' num2str(k) '. Trying again...'])
        b = statistic_mic_reshef(y0,ys);
    end
    result.MIC_reshef_self(:,n) = b;   
end

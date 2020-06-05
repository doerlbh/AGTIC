function functions = helper_define_functions(relative_noise_amps, N_override)
%% functions = helper_define_functions(relative_noise_amps, N_override)
% Defines the functions used in tests of equitability in Figs. 3, S3, and
% relative_noise_amps contol noise level
% N_override, if set, performs calculations all with N_override data points
% Returns a cell array whose columns list
% 1. N (number of data points)
% 2. x-range
% 3. f(x) given as a formula
% 4. Description of f(x)
% 5. x-values drawn evenly along the length of the curve (x, f(x))
% 6. y0 = f(x) values, without noise 
% 7. y = f(x) + noise values, N rows x 1 column for each noise level
% 8. function monotonicity = rho[x;f(x)]
functions = {
    % Listed from most monotonic to least monotonic
    
    % Perfect monotonicity
    1000, [0 1], 'x', 'Line';
    1000, [0 10], '2.^x', 'Exponential [2^X]';
    1000, [0 10], '10.^x', 'Exponential [10^X]';
    1000, [0 1], '(1/5)*sin(4*(2*x-1)) + (11/10)*(2*x-1)', 'LP, Low Freq';
    1000, [0 1], '(1/10)*sin(10.6*(2*x-1)) + (11/10)*(2*x-1)', 'LP, High Freq';
    
    % High monotonicity
    1000, [0 1], '(x/99).*(x < .99) + (x >= .99)', 'L-shaped';
    1000, [0 1], '(1/5)*sin(10.6*(2*x-1)) + (11/10)*(2*x-1)', 'LP, High Freq 2';
    1000, [0 1], '(50*(x-.5)+.5).*(x >= .49).*(x < .51) + 1*(x >= .51)', 'Sigmoid';
    
    % Intermediate monotonicity
    500,  [0 1], '200*x.*(x < .005) + (-198.*x + 1.99).*(x>=.005).*(x<.01) + ((1-x)/99).*(x>=.01)', 'Lopsided L-shaped';
    1000, [0 1], '20*x.*(x < .05) + (-18.*x + 1.9).*(x>=.05).*(x<.1) + ((1-x)/9).*(x>=.1)', 'Spike';
    
    % Low monotonicity
    1000, [-1.3 1.1], '41*(4.*x.^3 + x.^2 - 4*x)', 'Cubic, Y-stretched';
    500,  [0 1], 'sin(10*pi*x) + x', 'LP, Med Freq';
    1000, [-1.3 1.1], '4.*x.^3 + x.^2 - 4*x', 'Cubic'; 
    250,  [0 1], 'sin(8*pi*x)', 'Sin, Low Freq';
    1000, [0 1], 'sin(5*pi*x.*(1+x))', 'VF [Med] Cos';
    500,  [0 1], 'sin(6*pi*x.*(1+x))', 'VF [Med] Sin';
    1000, [0 1], 'sin(16*pi*x)', 'Sin, High Freq';
    250,  [0 1], 'cos(7*pi*x)', 'NFF [Low] Cos';
    
    % Zero monotonicity by symmetry
    500,  [0 1], 'cos(14*pi*x)', 'Cos, High Freq';
    1000, [-.5 .5], '4*x.^2', 'Parabola';
    1000, [0 1], 'sin(9*pi*x)', 'NFF [Low] Sin';
    };

% Number of functions
num_funcs = size(functions,1);

% Add noise to functions. Store noisy y-values in functions{:,7}
num_noises = numel(relative_noise_amps);

% Create evenly-spaced x-values for each function
for k=1:num_funcs
    
    % Set function, x-range, and num data points
    if exist('N_override', 'var')
        functions{k,1} = N_override;
    end
    
    % Override specified number of data points if requested
    N = functions{k,1};
    xl = functions{k,2};
    func_string = functions{k,3};
    func_name = functions{k,4};
    
    % Evaluate function on preliminary set of points 
    N_prelim = 1E3;
    x_prelim = linspace(xl(1), xl(2), N_prelim+1);
    x = x_prelim;
    dx = x(2)-x(1);
    y_prelim = eval(func_string);
    dy = diff(y_prelim);
    
    % Compute cumulative lengths    
    cum_lengths = [0, cumsum(sqrt(dx.^2 + dy.^2))];
    total_length = cum_lengths(end);
    
    % Compute evenly spaced lenghts. Stay away from endpoints
    dl = total_length/(N+1);
    even_lengths = linspace(dl/2, total_length-dl/2, N);
    
    % Interpolate to get both x- and y- coordinates
    x = interp1(cum_lengths, x_prelim, even_lengths); % Has to be named 'x'
    y0 = interp1(cum_lengths, y_prelim, even_lengths); 
    
    % Make sure there are no NaN values for x or y
    assert(all(~isnan(x)) & all(~isnan(y0)));
    
    % Store x- and y-valuse in functions{:,5} and functions{:,6}
    functions{k,5} = x(:);  % Thse are the x values
    functions{k,6} = y0(:);  % This is f(x), i.e. noiseless values

    % Get y-range
    y_range = max(y0)-min(y0);
    
    % Iterate over noise levels
    ys = [];
    for m=1:num_noises
        
        % Add noise to y-values
        ys(:,m) = y0(:) + (rand(N,1)-.5)*relative_noise_amps(m)*y_range;
    end
    
    % Save noisy functions
    functions{k,7} = ys;   % These are the noisy values, y = f(x) + \eta
    
    % Compute funciton monotonicity
    %functions{k,8} = corr(x(:),y0(:),'type','spearman')^2; %FUCKING BULLSHIT. Requires Statistics Toolbox
    functions{k,8} = statistic_sqcorr_spearman(x(:), y0(:)); % This doesn't require Statistics Toolbox
    
end

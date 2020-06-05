function all_colors = helper_simulation_colormap()
rows = 100;
up_grad = linspace(0, 1, rows)';
dn_grad = flipud(up_grad);
orange = [1 .5 0];
blue = [0 0 1];
% Create a gradient colormap running from red to blue
all_colors = dn_grad*orange + up_grad*blue;
end

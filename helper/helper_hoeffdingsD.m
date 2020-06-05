function [ D ] = helper_hoeffdingsD( x, y )
%Compute's Hoeffding's D measure of dependence between x and y
%   inputs x and y are both N x 1 arrays
%   output D is a scalar
%     The formula for Hoeffding's D is taken from
%     http://support.sas.com/documentation/cdl/en/procstat/63104/HTML/default/viewer.htm#procstat_corr_sect016.htm
% Below is demonstration code for several types of dependencies.
%
% % this case should be 0 - there are no dependencies
% x = randn(1000,1);
% y = randn(1000,1);
% D = hoeffdingsD( x, y );
% desc = 'x = N( 0, 1 ), y and x independent';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% % the rest of these cases have dependencies of different types
% x = randn(1000,1);
% y = x;
% D = hoeffdingsD( x, y );
% desc = 'x = N( 0, 1 ), y = x';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% x = randn(1000,1);
% y = cos(10*x);
% D = hoeffdingsD( x, y );
% desc = 'x = N( 0, 1 ), y = cos(10x)';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% x = randn(1000,1);
% y = x.^2;
% D = hoeffdingsD( x, y );
% desc = 'x = N( 0, 1 ), y = x^2';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% x = randn(1000,1);
% y = x.^2 + randn(1000,1);
% D = hoeffdingsD( x, y );
% desc = 'x = N( 0, 1 ), y = x^2 + N( 0, 1 )';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% x = rand(1000,1);
% y = rand(1000,1);
% z = sign(randn(1000,1));
% x = z.*x; y = z.*y;
% D = hoeffdingsD( x, y );
% desc = 'x = z U( [0, 1) ), y = z U( [0, 1) ), z = U( {-1,1} )';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );
%
% x = rand(1000,1);
% y = rand(1000,1);
% z = sign(randn(1000,1));
% x = z.*x; y = -z.*y;
% D = hoeffdingsD( x, y );
% desc = 'x = z U( [0, 1) ), y = -z U( [0, 1) ), z = U( {-1,1} )';
% desc = sprintf( '%s, Hoeffding''s D = %f', desc, D );
% fprintf( '%s\n', desc );
% figure; plot(x,y,'.'); title( desc );

N = size(x,1);

R = helper_rankorder(x); %tiedrank( x ); % These require the Statistics Toolbox
S = helper_rankorder(y); %tiedrank( y ); % These require the Statistics Toolbox

Q = zeros(N,1);
% for i = 1:N
parfor i = 1:N
    Q(i) = 1 + sum( R < R(i) & S < S(i) );
    % and deal with cases where one or both values are ties, which contribute less
    Q(i) = Q(i) + 1/4 * (sum( R == R(i) & S == S(i) ) - 1); % both indices tie.  -1 because we know point i matches
    Q(i) = Q(i) + 1/2 * sum( R == R(i) & S < S(i) ); % one index ties.
    Q(i) = Q(i) + 1/2 * sum( R < R(i) & S == S(i) ); % one index ties.
end

D1 = sum( (Q-1).*(Q-2) );
D2 = sum( (R-1).*(R-2).*(S-1).*(S-2) );
D3 = sum( (R-2).*(S-2).*(Q-1) );

D = 30*((N-2)*(N-3)*D1 + D2 - 2*(N-2)*D3) / (N*(N-1)*(N-2)*(N-3)*(N-4));

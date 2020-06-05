function y = helper_quantile(x, p, dim)

   nargsin = nargin;
   error(nargchk(2, 3, nargsin));

   sx = size(x);                % size of `x'
   dx = ndims(x);               % number of dimensions in `x'

   % make `p' a column vector
   p = p(:);
   np = length(p);              % number of elements in `p'

   % get first non-singleton dimension, or 1 if none found
   if nargsin < 3
      k = find(sx ~= 1);
         if isempty(k)
         dim = 1;
      else
         dim = k(1);
      end
   else
      if any(size(dim) ~= 1) || dim < 1 || dim ~= round(dim)
         error('Dimension must be a scalar positive integer.');
      end
   end

   n = size(x, dim);

   % special case when `x' is empty
   if isempty(x)
      y = zeros(sx);
      return;
   end

   % permute and reshape so DIM becomes the row dimension of a 2-D array
   perm = 1:dx;
   perm([1 dim]) = [dim 1];
   x = reshape(permute(x, perm), [n prod(sx)/n]);

   % compute the quantiles by linear interpolation
   y = interp1((0:n-1).'/(n-1), sort(x, 1), p);

   % reshape and permute back
   sy = sx;
   sy(dim) = np;
   y = permute(reshape(y, sy(perm)), perm);
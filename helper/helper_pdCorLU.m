function dCor = helper_pdCorLU(x,y,la,ua,lb,ub,method)

% Check if the sizes of the inputs match
% disp(size(x,1))
% disp(size(y,1))

if size(x,1) ~= size(y,1);
    error('Inputs must have the same number of rows')
end

% Delete rows containing unobserved values
N = any([isnan(x) isnan(y)],2);
x(N,:) = [];
y(N,:) = [];

% Geo-topological transformation

if la > 1 || ua > 1 || lb > 1 || ub > 1 
    method = 4;
end

if la > ua
    t = la;
    la = ua;
    ua = t;
end

if lb > ub
    t = lb;
    lb = ub;
    ub = t;
end

a = helper_pdist2(x,x,'euclidean');
aMax = max(a(:));
% aL = aMax * la;
% aU = aMax * ua;
aL = quantile(a(:),la);
aU = quantile(a(:),ua);

b = helper_pdist2(y,y,'euclidean');
bMax = max(b(:));
% bL = bMax * lb;
% bU = bMax * ub;
bL = quantile(b(:),lb);
bU = quantile(b(:),ub);

switch method
    case 1
        a(a <= aL) = 0;
        a(a > aL & a < aU) = a(a > aL & a < aU);
        a(a >= aU) = aMax;
        
        b(b <= bL) = 0;
        b(b > bL & b < bU) = b(b > bL & b < bU);
        b(b >= bU) = bMax;
        
    case 2
        a(a <= aL) = 0;
        a(a > aL & a < aU) = aU * (a(a > aL & a < aU) - aL) / (aU - aL);
        a(a >= aU) = aMax;
        
        b(b <= bL) = 0;
        b(b > bL & b < bU) = bU * (b(b > bL & b < bU) - bL) / (aU - aL);
        b(b >= bU) = bMax;
        
    case 3
        a(a <= aL) = 0;
        a(a > aL & a < aU) = aMax * (a(a > aL & a < aU) - aL) / (aU - aL);
        a(a >= aU) = aMax;
        
        b(b <= bL) = 0;
        b(b > bL & b < bU) = bMax * (b(b > bL & b < bU) - bL) / (aU - aL);
        b(b >= bU) = bMax;
                
    otherwise
end

% Calculate doubly centered distance matrices for x and y
% a = helper_pdist2(x,x,'euclidean');
mCol = mean(a);
mRow = mean(a,2);
ajBar = ones(size(mRow))*mCol;
akBar = mRow*ones(size(mCol));
aBar = mean(mean(a))*ones(size(a));
A = a - ajBar - akBar + aBar;

% b = helper_pdist2(y,y,'euclidean');
mCol = mean(b);
mRow = mean(b,2);
bjBar = ones(size(mRow))*mCol;
bkBar = mRow*ones(size(mCol));
bBar = mean(mean(b))*ones(size(b));
B = b - bjBar - bkBar + bBar;

% Calculate squared sample distance covariance and variances
dCov = sum(sum(A.*B))/(size(mRow,1)^2);

dVarX = sum(sum(A.*A))/(size(mRow,1)^2);
dVarY = sum(sum(B.*B))/(size(mRow,1)^2);

% Calculate the distance correlation
dCor = sqrt(abs(dCov/sqrt(dVarX*dVarY)));


function deepDistance(X,Y)

h=figure(20); set(h,'Color','w'); clf;

xl = 'X';
yl = 'Y';

ms = 40;

for i = 1:4
    
    if size(X,2)==1 && size(Y,2)==1
        subplot(2,2,i); plot(X(:),Y(:),'.k','MarkerSize',ms);
        axis equal;
        xlabel(xl); ylabel(yl);
    end
        
    n = size(X,1);
    if n>10000, break; end
    newN = (n^2-n)/2;
    ms = ms /sqrt(newN/n);
    
    X = pdist(X,'Euclidean')';
    Y = pdist(Y,'Euclidean')';

    xl=['d(',xl,')'];
    yl=['d(',yl,')'];
    
end







function [x,y,z]=bezier(P)
    
    P=P';
    t=0:.05:1;
    
    Q = zeros(size(P,1),numel(t));
 
for k=1:length(t)
    for j=1:size(P,2)
        Q(:,k)=Q(:,k)+P(:,j)*Bernstein(size(P,2)-1,j-1,t(k));
    end
end


x = Q(1,:)';
y = Q(2,:)';
if size(Q,1)==3
    z = Q(3,:)';
else
    z = 0*x;
end

end
 
function B=Bernstein(n,j,t)
    B=factorial(n)/(factorial(j)*factorial(n-j))*(t^j)*(1-t)^(n-j);
end
close all
figure; 
for i=1:30,
    
U=.5;
sig = 1;
Ce = [];

L=5;
for iSim=1:200
%     L=5*randn(1);
    pC=1/(1+exp(-(U(end)-L)));
    C=rand(1)<=pC;
    Ce(end+1) = 1/((C*(1-pC)^2 + (1-C)*pC^2) / (pC^2*(1-pC)^2));
    J = (1-pC)*pC;
    sig(end+1) = 1/( (1/sig(end)) + J*Ce(end)*J);
    U(end+1) = U(end) + sig(end)*J*Ce(end)*(C-pC);
end
subplot(1,2,1)
hold on
plot(U,'b')
subplot(1,2,2)
hold on
plot(sig,'g')
% subplot(1,3,3)
% hold on
% plot(Ce,'k')

end
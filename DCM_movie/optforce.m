function [Fopt,Fopt2,err]=optforce(theta,F0,sigma2)

FS = -2:.001:1;
pwin = @(F) (1/2) * (1+erf((F-F0)/sqrt(2*sigma2)));
U = @(F) theta*pwin(F) - (exp(F)-1);

US = U(FS); 
Fopt = FS(US==max(US));

Fopt2=sqrt(-2*sigma2*F0+2*sigma2*log(theta/(sqrt(2)*sqrt(pi)*sqrt(sigma2)))+sigma2^2)+F0-sigma2;

err=Fopt2-Fopt;

if imag(Fopt2)~=0
    Fopt2 = NaN;
    Fopt = NaN;
    err = NaN;
end




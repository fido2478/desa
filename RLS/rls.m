function [e,w, Recordedw]=rls(lambda,M,u,d,delta,N) 
% Recursive Least Squares 
% Call: 
% [e,w]=rls(lambda,M,u,d,delta); 
% 
% Input arguments: 
% lambda = forgetting factor, dim 1x1 
% M = filter length, dim 1x1 
% u = input signal, dim Nx1 
% d = desired signal, dim Nx1 
% delta = initial value, P(0)=delta^-1*I, dim 1x1 
% 
% Output arguments: 
% e = a priori estimation error, dim Nx1 
% w = final filter coefficients, dim Mx1

% inital values 
w=zeros(M,1); 
P=delta*eye(M); 

% make sure that u and d are column vectors 
u=u(:); 
d=d(:); 
% input signal length 
%N=length(u); 
% error vector 
e=d; 
% Loop, RLS 
for n=M:N 
    uvec=u(n:-1:n-M+1);
    %estimate output: y
    y=w' * uvec;
    e(n)=d(n) - y; 
    phi = uvec' * P;
    k=P*uvec/(lambda + phi * uvec); 
    %update w and P for next y
    w=w + k * conj(e(n)); 
    P=(P - k * phi)/lambda; 
    Recordedw(1:M,n)=w;
end 

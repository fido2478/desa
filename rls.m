function [y, e,w, Recordedw]=rls(lamda,sysorder,inporder,outorder,inp,d,delta,N,y) 
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
totallength=size(d,1);
P = delta * eye (sysorder ) ;
w = zeros ( sysorder  , 1 ) ; %estimated coefficients of weight

for n = inporder : N 
    %u(n),u(n-1),u(n-2)
	u = inp(n:-1:n-inporder+1) ;
    %d(n-1),d(n-2)
    outp= d(n-1:-1:n-outorder) ;
    u=[u ; outp];
    phi = u' * P ;
	k = phi'/(lamda + phi * u );
    y(n)=w' * u;
    e(n) = d(n) - y(n) ;
	w = w + k * e(n) ;
	P = ( P - k * phi ) / lamda ;
    % Just for plotting
    Recordedw(1:sysorder,n)=w; %estimated weight
end 
%check of results
for n =  N+1 : totallength
    %u(n),u(n-1),u(n-2)
	u = inp(n:-1:n-inporder+1) ;
    %d(n-1),d(n-2)
    outp= d(n-1:-1:n-outorder) ;    
    u=[u ; outp];
    y(n) = w' * u ; % estimated values
    e(n) = d(n) - y(n) ; % error beteen real and estimated data
end 

if 0
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

end
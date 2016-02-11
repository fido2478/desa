%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rlsalgo : IIR RLS algorithm demo
% Author : Tamer Abdelazim Mellik
% Contact information : 
%Department of Electrical & Computer Engineering,
%University of Calgary,
%2500 University Drive N.W. ,
%Calgary, AB T2N 1N4 ,
%Canada .
% email :abdelasi@enel.ucalgary.ca  
% email : abdelazim@ieee.org
% Webpage : http://www.enel.ucalgary.ca/~abdelasi/
% Date    : 2-4-2002
% Updated : 30-10-2003
% Version : 1.1.0
% Reference : S. Haykin, Adaptive Filter Theory. 3rd edition, Upper Saddle River, NJ: Prentice-Hall, 1996. 
% Note : The author doesn't take any responsibility for any harm caused by the use of this file
function rls_filter
clear all
%close all
% Number of system points
inp = loadfile('dat/log/load_demand-rand-fig.txt','%d ', [1 Inf]);%randn(N,1);
N=length(inp*60);
inp=inp';
lower_demand=5*60;
upper_demand=100*60;
n=lower_demand;
for i=2:N
    derivative=n(i-1)+round(2*lower_demand*normrnd(0,0.5));
    if derivative > upper_demand
        derivative=upper_demand;
    elseif derivative < lower_demand
        derivative=lower_demand;
    end
    n=[n; derivative];
end

[b,a] = butter(2,0.25);
Gz = tf(b,a,-1);
h=[b -a(2:length(a))]; %coefficients of weight

%If you don't have access to Control toolbox use the sample data
%load IIRsampledata;
%inp= IIRsampledata(1:2000);
%d= IIRsampledata(1:2000);

% use ldiv to get the approximate IIR weights of the filter ( a function only in the input)
% y=h*u
%ldiv is a function submitted to get inverse Z-transform (Matlab central file exchange)
%The first sysorder weight value
%use h=ldiv(b,a,sysorder)'; ==> here we use sysorder == 10

%channel system order (you can change the sysorder value and you don't need to change anything in the algorithm )
inporder=3;
outorder=2;
sysorder = inporder + outorder ;
%h= [0.0976   ; 0.2873  ;  0.3360   ; 0.2210   ; 0.0964   ; 0.0172 ;  -0.0159 ;  -0.0207  ; -0.0142  ; -0.0065 ; -0.0014 ;  0.0009 ;   0.0013   ; 0.0009   ; 0.0004  ;  0.0001  ; -0.0000  ; -0.0001  ; -0.0001  ; -0.0000];
%h=[0.097631   0.287310   0.335965   0.220981 0.096354 0.017183  -0.015917 -0.020735  -0.014243  -0.006517 -0.001396   0.000856   0.001272  0.000914 0.000438 0.000108 -0.000044  -0.00008  -0.000058 -0.000029];
%h=h(1:sysorder);
%y = lsim(Gz,inp);
%add some noise
%n = n * std(y)/(10*std(n));
%d = y + n;
y = lsim(Gz,inp); %estimated output
%add some noise
n = n * std(y)/(15*std(n)); %noise
d = y + n; %input data
%Take only 50 points for training ( N - inporder 47 = 50 - 3 )
NN=50 ;	
%begin of the algorithm
%forgetting factor
lamda = 0.999 ;		
%initial P matrix
delta = 1e2 ;		 

%Take only 70 points for training ( N - systorder 70 = 80 - 10 )
%begin of the algorithm
%forgetting factor
%lamda = 0.9995 ;		
%initial P matrix
%delta = 1e10 ;
%Train w
% N: number of points to train w
[y, e, w, Recordedw]=rls(lamda,sysorder,inporder,outorder,inp,d,delta,NN,y);

if 0
P = delta * eye (sysorder ) ;
w = zeros ( sysorder  , 1 ) ;
for n = sysorder : N 
	u = inp(n:-1:n-sysorder+1) ;
    phi = u' * P ;
	k = phi'/(lamda + phi * u );
    y(n)=w' * u;
    % estimate output: y(n)
    e(n) = d(n) - y(n) ;
    % get feedback: d(n)
	w = w + k * e(n) ;
    % update w
	P = ( P - k * phi ) / lamda ;
    % Just for plotting
    Recordedw(1:sysorder,n)=w;
end 

%check of results
for n =  N+1 : totallength
	u = inp(n:-1:n-sysorder+1) ;
    y(n) = w' * u ;
    e(n) = d(n) - y(n) ;
end 
end %if 0

figure %rlsfilter2.fig
plot([0:N-1],d/23,'-',[0:N-1],y/23,'-.','MarkerSize',4,'LineWidth',2); 
legend('True workload','Estimated workload',4);
xlabel('Load (C\times \Delta t)','FontSize',14)
ylabel('Workload (Coulombs)','FontSize',14)
figure %rlserror.fig
semilogy((abs(e/23))) ;
xlabel('Samples','FontSize',12);
ylabel('Error value e (C\times \Delta t)','FontSize',14);
figure
hold on
plot(h,'*r');
plot(w,'.');
hold off
%plot([1:length(h)],h, '+',[1:length(w)],w,'.','MarkerSize',4,'LineWidth',2);
legend('Filter weights','Estimated filter weights',4);
figure
plot(Recordedw(1:sysorder,sysorder:NN)');
title('Estimated weights convergence') ;
xlabel('Samples','FontSize',14);
ylabel('Weights value','FontSize',14);
axis([1 NN-sysorder min(min(Recordedw(1:sysorder,sysorder:NN)')) max(max(Recordedw(1:sysorder,sysorder:NN)')) ]);
hold off
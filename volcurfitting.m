function volcurfitting
clear all
close all
%   Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%   (min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
% This is a curve fitting of a function of discharge rate and time
% 
path='dat/';
datC=[];coeff=[]; xval=[]; yval=[]; zval=[];soc5C=[];
nominal_capacity=3600;
figure
hold on
for i=23:-1:1
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    %time5C=dat(1,1); 
    soc5C=1-dat(1,1)*60/nominal_capacity;
    vol5C=dat(4,1); %time is in minutes
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            soc5C=[soc5C 1-dat(1,j)*60/nominal_capacity];
            %time5C=[time5C dat(1,j)];
            vol5C=[vol5C dat(4,j)];
        end
    end
    %[p, S]=polyfit(time5C,vol5C, 15);
    [p, S]=polyfit(soc5C,vol5C, 15);
    coeff=[coeff; p];YY=polyval(p, soc5C);
    %coeff=[coeff; p];YY=polyval(p, time5C);
    xval=[xval i];
    ylen=length(yval);
    if ylen>0
        zval=[zval; vol5C(1:ylen)];
    else
        yval=soc5C(1:length(soc5C));
        zval=vol5C(1:length(soc5C));
        %yval=time5C(1:length(time5C));
        %zval=vol5C(1:length(time5C));
    end
    plot(1-soc5C,vol5C,'--',1-soc5C,YY,'-');
    %plot(time5C,vol5C,'--',time5C,YY,'-');
end
hold off
%voltage change with discharge rate varying: vltcr.fg
figure
zval=zval';

min=Inf;indx=0; min_pw=0
for i=1:30
    p_w=polyfitweighted2(xval,yval,zval,i,zval); %24 is opt
    ev=polyval2(p_w,xval(8),yval)-zval(:,8); %error vector
    perf=sse(ev);
    if min > perf
        min=perf; indx=i; min_pw=p_w;
    end
end

%voltage
H1=plot(1-yval,polyval2(min_pw,xval(8),yval),':',1-yval,zval(:,8),'--');%polyval(coeff(8,:),yval),'--'); %voltage
%set(H1,'MarkerSize',10,'LineWidth',2);
%xlabel('Time (min)','FontSize',12);
xlabel('SOC','FontSize',12);
ylabel('Voltage','FontSize',12);
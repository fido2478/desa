function [recovered_volt]=calculate_recovered_volt(discharge_rate, rest_time, debug_flag)
% input: discharge_rate (A/m2), rest_time(second), debug_flag
% process: calculate coefficients
% output: recovered_volt note: the amount of coulombs not change

path='dat/';
datC=[];xval=[]; yval=[]; zval=[];
filename=[path 'dualfoil5CRE1.out'];
dat=readfile(filename);
redat=[];retime=[];

time5C=dat(1,1); vol5C=dat(4,1);dischar=dat(6,1);
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        time5C=[time5C dat(1,j)];
        vol5C=[vol5C dat(4,j)];
        dischar=[dischar dat(6,j)];
    end
end
ind=find(dischar<1);
k=[ind(1)];
for i=2:length(ind)
    if (ind(i)-ind(i-1)) > 1
        k=[k ind(i-1) ind(i)]; %k = index of dat
    end
end
k=[k ind(i)]; %points at which discharge rate changed

tail=floor((k(4)-k(3))*1/5);
zval=vol5C(k(3):k(4)-tail);
%yval=time5C(k(3):k(4)-tail);
yval=time5C(k(3):k(4)-tail)-time5C(k(3));
xval=1;
h=k(3);t=k(4)-tail;
for i=2:100
    filename=[path 'dualfoil5CRE' num2str(i) '.out'];
    dat=readfile(filename); %C10
    time5C=dat(1,1); vol5C=dat(4,1);
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            %time5C=[time5C dat(1,j)];
            vol5C=[vol5C dat(4,j)];
        end
    end
    zval=[zval; vol5C(h:t)];
    %yval=[yval; time5C(k(3):length(zval))];
    xval=[xval i];
end
zval=zval';

min=Inf;indx=0; min_pw=0
for j=1:30
    p_w=polyfitweighted2(xval,yval,zval,j,zval); %17 is opt
    ev=polyval2(p_w,xval(4),yval)-zval(:,4); %error vector
    perf=sse(ev);
    if min > perf
        min=perf; indx=j; min_pw=p_w;
    end
end

recovered_volt=polyval2(min_pw,discharge_rate,rest_time/60)-polyval2(min_pw,discharge_rate,0);

%p_w=polyfitweighted2(xval,yval,zval,17,zval);
if debug_flag > 0
    figure
    hold on
    for i=1:length(xval)
        H1=plot(yval,polyval2(min_pw,xval(i),yval),':',yval,zval(:,i),'-'); %voltage
        xlabel('elapsed time (min)');ylabel('voltage');
    end
    hold off
end
function [min_pw]=calcul_coeff_volt(st,en)
% current unit = A/m2 but convert it to coulomb by division of 23
%[1-8], [9-18], [19-23], [24-34], [35-64], [65-80], [81-90],[91-100]
%st=91;en=100; 
path='dat/';
datC=[];coeff=[]; xval=[]; yval=[]; zval=[];soc5C=[];tval=[];
nominal_capacity=3602.7;
for i=en:-1:st
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    time5C=dat(1,1); % for eval purpose
    soc5C=1-dat(1,1)*(60.045/nominal_capacity)*(i/23);
    vol5C=dat(4,1); %time is in minutes
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            soc5C=[soc5C 1-dat(1,j)*(60.045/nominal_capacity)*(i/23)];
            time5C=[time5C dat(1,j)];
            vol5C=[vol5C dat(4,j)];
        end
    end
    %[p, S]=polyfit(time5C,vol5C, 15);
    %coeff=[coeff; p];YY=polyval(p, time5C);
    %[p, S]=polyfit(soc5C,vol5C, 15);
    %coeff=[coeff; p];YY=polyval(p, soc5C);
    xval=[xval i/23]; %convert into coulomb
    ylen=length(yval);
    if ylen>0
        zval=[zval; vol5C(1:ylen)];
%        tval=[tval; time5C];
    else
        yval=soc5C(1:length(soc5C));
        zval=vol5C(1:length(soc5C));
%        tval=time5C(1:length(time5C));
        %zval=vol5C(1:length(time5C));
    end
end
%voltage change with discharge rate varying: vltcr.fg
zval=zval';

min=Inf;indx=0; min_pw=0
for i=1:30
    p_w=polyfitweighted2(xval,yval,zval,i,zval); %24 is opt
    ev=polyval2(p_w,xval(round((en-st)/2)),yval)-zval(:,round((en-st)/2)); %error vector
    perf=sse(ev);
    if min > perf
        min=perf; indx=i; min_pw=p_w;
    end
end
if 0
figure
hold on
for i=1:length(xval)
    H1=plot(yval,polyval2(min_pw,xval(i),yval),':',yval,zval(:,i),'-'); %voltage
end
hold off
xlabel('SoC');ylabel('Voltage (V)');
end
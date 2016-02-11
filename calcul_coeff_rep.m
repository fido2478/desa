function [min_pw]=calcul_coeff_rep(st,en)
% 1 to 50 is OK
% reeffVot.fig
% input: previous discharge rate (xval), rest time (yval), 
% increment of voltage (zval)
% convert A/m2 to Coulomb by division of 23
ovolt=4.06267;
path='dat/';
datC=[];xval=[]; yval=[]; zval=[];
for i=st:en
    filename=[path 'dualfoil5CREP' num2str(i) '.out'];
    dat=readfile(filename); %C10
    time5C=dat(1,1); vol5C=dat(4,1);dischar=dat(6,1);
    %time5C=dat(1,1); 
    %vol5C=dat(4,1)-dat(4,1);
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            time5C=[time5C dat(1,j)];
            dischar=[dischar dat(6,j)];
            vol5C=[vol5C dat(4,j)];
        end
    end
    ind=find(dischar<1);
    k=[ind(1)];
    for j=2:length(ind)
        if (ind(j)-ind(j-1)) > 1
            k=[k ind(j-1) ind(j)]; %k = index of dat
        end
    end
    k=[k ind(j)]; %points at which discharge rate changed

    tail=floor((k(4)-k(3))*0*1/5);
    h=k(3);t=k(4)-tail;
    if i < st+1
        yval=[yval; time5C(h:t)-time5C(h)];
    end
    zval=[zval; vol5C(h:t)-vol5C(h)];
    xval=[xval i];

    %zval=[zval; vol5C(h:t)-vol5C(h)];
    %yval=[yval; time5C(h:t)-time5C(h)];
    %xval=[xval i/23];
end
zval=zval';

min=Inf;indx=0; min_pw=0;
%figure
for j=1:25
    p_w=polyfitweighted2(xval,yval,zval,j,zval); %17 is opt
    ev=polyval2(p_w,xval(round((en-st)/2)),yval)-zval(:,round((en-st)/2)); %error vector
    perf=sse(ev);
    if min > perf
        min=perf; indx=j; min_pw=p_w;
    end
%    H1=plot(yval,polyval2(p_w,xval(round((en-st)/2)),yval),':',yval,zval(:,round((en-st)/2)),'-');
end

if 1
figure
hold on
for i=1:length(xval)
    H1=plot(yval,polyval2(min_pw,xval(i),yval),':',yval,zval(:,i),'-'); %voltage
    text(yval,zval(:,i),int2str(i));
end
hold off
figure % reeffVot.fig
plot([0:en],[0 max(zval)/ovolt*100],'x-','MarkerSize',10,'LineWidth',2);
xlabel('discharge time (min)');ylabel('Degree of recovered voltage (%)');
end %if 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

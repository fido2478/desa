function fig_bat_behavior
clear all
close all
path='dat/';
%   Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%   (min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
nominal_capacity=3602.7;
datC=[];coeff=[]; xval=[]; yval=[];
time1C=[];time2C=[];time3C=[];time4C=[];time5C=[];
vol1C=[];vol2C=[];vol3C=[];vol4C=[];vol5C=[];
soc1C=[];soc2C=[];soc3C=[];soc4C=[];soc5C=[];
min1=Inf;min2=Inf;min3=Inf;min4=Inf;
hold on
for i=[23 46 69 92]
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case 23
        time1C=dat(1,1); vol1C=dat(4,1);soc1C=0;
        for j=2:length(dat(1,:))
            if dat(1,j)~=dat(1,j-1)
                time1C=[time1C dat(1,j)];
                vol1C=[vol1C dat(4,j)];
                soc1C=[soc1C 1-dat(1,j)*(60.045/nominal_capacity)*(i/23)];
            end 
        end
        for j=1:30
            p_w=polyfit(time1C,vol1C,j); %24 is opt
            ev=polyval(p_w,time1C)-vol1C; %error vector
            perf=sse(ev);
            if min1 > perf
                min1=perf;
            end
        end
        case 46
        time2C=dat(1,1); vol2C=dat(4,1);soc2C=0;
        for j=2:length(dat(1,:))
            if dat(1,j)~=dat(1,j-1)
                time2C=[time2C dat(1,j)];
                vol2C=[vol2C dat(4,j)];
                soc2C=[soc2C 1-dat(1,j)*(60.045/nominal_capacity)*(i/23)];
            end
        end
        for j=1:30
            p_w=polyfit(time2C,vol2C,j); %24 is opt
            ev=polyval(p_w,time2C)-vol2C; %error vector
            perf=sse(ev);
            if min2 > perf
                min2=perf;
            end
        end        
        case 69
        time3C=dat(1,1); vol3C=dat(4,1);soc3C=0;
        for j=2:length(dat(1,:))
            if dat(1,j)~=dat(1,j-1)
                time3C=[time3C dat(1,j)];
                vol3C=[vol3C dat(4,j)];
                soc3C=[soc3C 1-dat(1,j)*(60.045/nominal_capacity)*(i/23)];
            end
        end
        for j=1:30
            p_w=polyfit(time3C,vol3C,j); %24 is opt
            ev=polyval(p_w,time3C)-vol3C; %error vector
            perf=sse(ev);
            if min3 > perf
                min3=perf;
            end
        end
        case 92
        time4C=dat(1,1); vol4C=dat(4,1);soc4C=0;
        for j=2:length(dat(1,:))
            if dat(1,j)~=dat(1,j-1)
                time4C=[time4C dat(1,j)];
                vol4C=[vol4C dat(4,j)];
                soc4C=[soc4C 1-dat(1,j)*(60.045/nominal_capacity)*(i/23)];
            end
        end
        for j=1:30
            p_w=polyfit(time4C,vol4C,j); %24 is opt
            ev=polyval(p_w,time4C)-vol4C; %error vector
            perf=sse(ev);
            if min4 > perf
                min4=perf;
            end
        end
    end
end

%This figure shows the relationship between discharge rate and voltage drop
%voltvsdisch.fig
H1=plot(time1C,vol1C,'-',time2C,vol2C,'-.',time3C,vol3C,'--',time4C,vol4C,':');
set(H1,'MarkerSize',10,'LineWidth',2);
legend('C','2C','3C','4C');
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

time4Y=[];time4X=[];
for i=1:length(time4C)-12
    ind=find(vol4C(i) >= vol1C);
    if ~isempty(ind)
        time4Y=[time4Y time1C(ind(1))];
        time4X=[time4X time4C(i)];
    end
end
time3Y=[];time3X=[];
for i=1:length(time3C)-12
    ind=find(vol3C(i) >= vol1C);
    if ~isempty(ind)
        time3Y=[time3Y time1C(ind(1))];
        time3X=[time3X time3C(i)];
    end
end

time2Y=[];time2X=[];
for i=1:length(time2C)-12
    ind=find(vol2C(i) >= vol1C);
    if ~isempty(ind)
        time2Y=[time2Y time1C(ind(1))];
        time2X=[time2X time2C(i)];
    end
end

figure
% linearrelatwrtdisch.fig
hold on
plot(time2X,time2Y,'x', time3X,time3Y,'+',time4X,time4Y,'*','LineWidth',1);
legend('2C','3C','4C','FontSize',12);
xlabel('Time (Observed)','FontSize',12);ylabel('Time (Referred)','FontSize',12);

p4=polyfit(time4X,time4Y,1);
p3=polyfit(time3X,time3Y,1);
p2=polyfit(time2X,time2Y,1);
yy4=polyval(p4,time4X);
yy3=polyval(p3,time3X);
yy2=polyval(p2,time2X);

plot(time2X,yy2,':',time3X,yy3,':',time4X,yy4,':','LineWidth',2);
text(time2X(round(length(time2X)*0.8)),yy2(length(yy2)),...
    ['y = ' num2str(p2(1)) 'x + ' num2str(p2(2))]);
text(time3X(round(length(time3X)*0.8)),yy3(length(yy3)),...
    ['y = ' num2str(p3(1)) 'x + ' num2str(p3(2))]);
text(time4X(round(length(time4X)*0.8)),yy4(length(yy4)),...
    ['y = ' num2str(p4(1)) 'x + ' num2str(p4(2))]);
hold off

%recovery effect: re.fig
%filename=[path 'dualfoil5C100723.out'];
filename=[path 'dualfoil5CRET3.out'];
dat=readfile(filename);
time10C=dat(1,1); vol10C=dat(4,1);
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        time10C=[time10C dat(1,j)];
        vol10C=[vol10C dat(4,j)];
    end
end
figure
H1=plot(time10C,vol10C,'-'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
%legend('3C every 3 mins');
xlabel('Time (min)','FontSize',12);ylabel('Voltage (V)','FontSize',12);
text(time10C(round(length(time10C)/3)),vol10C(1),'Recovery effect','FontSize',12);
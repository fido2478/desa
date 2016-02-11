function batteryreading
clear all
close all
path='dat/';
%   Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%   (min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
datC=[];coeff=[]; xval=[]; yval=[]; zval=[];
figure
hold on
for i=5:5:100
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case 5 
            time5C=dat(1,1); vol5C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time5C=[time5C dat(1,j)];
                    vol5C=[vol5C dat(4,j)];
                end
            end
            [p, S]=polyfit(time5C,vol5C, 15);
            coeff=[coeff; p];YY=polyval(p, time5C);
            plot(time5C,vol5C,'--',time5C,YY,'-');
        case 10 
            time10C=dat(1,1); vol10C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time10C=[time10C dat(1,j)];
                    vol10C=[vol10C dat(4,j)];
                end
            end
            [p, S]=polyfit(time10C,vol10C, 15);
            coeff=[coeff; p];YY=polyval(p, time10C);
            plot(time10C,vol10C,'--',time10C,YY,'-');
        case 15 
            time15C=dat(1,1); vol15C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time15C=[time15C dat(1,j)];
                    vol15C=[vol15C dat(4,j)];
                end
            end
            [p, S]=polyfit(time15C,vol15C, 15);
            coeff=[coeff; p];YY=polyval(p, time15C);
            plot(time15C,vol15C,'--',time15C,YY,'-');
        case 20 
            time20C=dat(1,1); vol20C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time20C=[time20C dat(1,j)];
                    vol20C=[vol20C dat(4,j)];
                end
            end
            [p, S]=polyfit(time20C,vol20C, 15);
            coeff=[coeff; p];YY=polyval(p, time20C);
            plot(time20C,vol20C,'--',time20C,YY,'-');
        case 25
            time25C=dat(1,1); vol25C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time25C=[time25C dat(1,j)];
                    vol25C=[vol25C dat(4,j)];
                end
            end
            [p, S]=polyfit(time25C,vol25C, 15);
            coeff=[coeff; p];YY=polyval(p, time25C);
            plot(time25C,vol25C,'--',time25C,YY,'-');
        case 30
            time30C=dat(1,1); vol30C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time30C=[time30C dat(1,j)];
                    vol30C=[vol30C dat(4,j)];
                end
            end
            [p, S]=polyfit(time30C,vol30C, 15);
            coeff=[coeff; p];YY=polyval(p, time30C);
            plot(time30C,vol30C,'--',time30C,YY,'-');
        case 35 
            time35C=dat(1,1); vol35C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time35C=[time35C dat(1,j)];
                    vol35C=[vol35C dat(4,j)];
                end
            end
            [p, S]=polyfit(time35C,vol35C, 15);
            coeff=[coeff; p];YY=polyval(p, time35C);
            plot(time35C,vol35C,'--',time35C,YY,'-');
        case 40 
            time40C=dat(1,1); vol40C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time40C=[time40C dat(1,j)];
                    vol40C=[vol40C dat(4,j)];
                end
            end
            time40C=dat(1,:); vol40C=dat(4,:);
            [p, S]=polyfit(time40C,vol40C, 15);
            coeff=[coeff; p];YY=polyval(p, time40C);
            plot(time40C,vol40C,'--',time40C,YY,'-');
        case 45 
            time45C=dat(1,1); vol45C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time45C=[time45C dat(1,j)];
                    vol45C=[vol45C dat(4,j)];
                end
            end
            [p, S]=polyfit(time45C,vol45C, 15);
            coeff=[coeff; p];YY=polyval(p, time45C);
            plot(time45C,vol45C,'--',time45C,YY,'-');
        case 50 
            time50C=dat(1,1); vol50C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time50C=[time50C dat(1,j)];
                    vol50C=[vol50C dat(4,j)];
                end
            end
            [p, S]=polyfit(time50C,vol50C, 15);
            coeff=[coeff; p];YY=polyval(p, time50C);
            plot(time50C,vol50C,'--',time50C,YY,'-');
        case 55
            time55C=dat(1,1); vol55C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time55C=[time55C dat(1,j)];
                    vol55C=[vol55C dat(4,j)];
                end
            end
            [p, S]=polyfit(time55C,vol55C, 15);
            coeff=[coeff; p];YY=polyval(p, time55C);
           plot(time55C,vol55C,'--',time55C,YY,'-');
        case 60
            time60C=dat(1,1); vol60C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time60C=[time60C dat(1,j)];
                    vol60C=[vol60C dat(4,j)];
                end
            end
            [p, S]=polyfit(time60C,vol60C, 15);
            coeff=[coeff; p];YY=polyval(p, time60C);
            plot(time60C,vol60C,'--',time60C,YY,'-');
         case 65 
            time65C=dat(1,1); vol65C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time65C=[time65C dat(1,j)];
                    vol65C=[vol65C dat(4,j)];
                end
            end
            [p, S]=polyfit(time65C,vol65C, 15);
            coeff=[coeff; p];YY=polyval(p, time65C);
            plot(time65C,vol65C,'--',time65C,YY,'-');
        case 70 
            time70C=dat(1,1); vol70C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time70C=[time70C dat(1,j)];
                    vol70C=[vol70C dat(4,j)];
                end
            end
            [p, S]=polyfit(time70C,vol70C, 15);
            coeff=[coeff; p];YY=polyval(p, time70C);
            plot(time70C,vol70C,'--',time70C,YY,'-');
        case 75 
            time75C=dat(1,1); vol75C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time75C=[time75C dat(1,j)];
                    vol75C=[vol75C dat(4,j)];
                end
            end
            [p, S]=polyfit(time75C,vol75C, 15);
            coeff=[coeff; p];YY=polyval(p, time75C);
            plot(time75C,vol75C,'--',time75C,YY,'-');
        case 80 
            time80C=dat(1,1); vol80C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time80C=[time80C dat(1,j)];
                    vol80C=[vol80C dat(4,j)];
                end
            end
            [p, S]=polyfit(time80C,vol80C, 15);
            coeff=[coeff; p];YY=polyval(p, time80C);
            plot(time80C,vol80C,'--',time80C,YY,'-');
        case 85
            time85C=dat(1,1); vol85C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time85C=[time85C dat(1,j)];
                    vol85C=[vol85C dat(4,j)];
                end
            end
            [p, S]=polyfit(time85C,vol85C, 15);
            coeff=[coeff; p];YY=polyval(p, time85C);
            plot(time85C,vol85C,'--',time85C,YY,'-');
       case 90
            time90C=dat(1,1); vol90C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time90C=[time90C dat(1,j)];
                    vol90C=[vol90C dat(4,j)];
                end
            end
            [p, S]=polyfit(time90C,vol90C, 15);
            coeff=[coeff; p];YY=polyval(p, time90C);
            plot(time90C,vol90C,'--',time90C,YY,'-');
        case 95
            time95C=dat(1,1); vol95C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time95C=[time95C dat(1,j)];
                    vol95C=[vol95C dat(4,j)];
                end
            end
            [p, S]=polyfit(time95C,vol95C, 15);
            coeff=[coeff; p];YY=polyval(p, time95C);
            plot(time95C,vol95C,'--',time95C,YY,'-');
       case 100
            time100C=dat(1,1); vol100C=dat(4,1);
            for j=2:length(dat(1,:))
                if dat(1,j)~=dat(1,j-1)
                    time100C=[time100C dat(1,j)];
                    vol100C=[vol100C dat(4,j)];
                end
            end
            [p, S]=polyfit(time100C,vol100C, 15);
            coeff=[coeff; p];YY=polyval(p, time100C);
            plot(time100C,vol100C,'--',time100C,YY,'-');
    end
end
hold off
%voltage change with discharge rate varying: vltcr.fg
figure
H1=plot(time5C,vol5C,'-',time10C,vol10C,'-.',time15C,vol15C,'--',time20C,vol20C,':',time25C,vol25C,'-',time90C,vol90C,'-.'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('5A/m^2','10A/m^2','15A/m^2','20A/m^2','25A/m^2','90A/m^2');
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

for i=[-10 5 24 60 90]
    filename=[path 'dualfoil5C10T' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case -10 
            timen10T=dat(1,:); voln10T=dat(4,:);
        case 5 
            time5T=dat(1,:); vol5T=dat(4,:);
        case 24
            time24T=dat(1,:); vol24T=dat(4,:);
        case 60 
            time60T=dat(1,:); vol60T=dat(4,:);
        case 90 
            time90T=dat(1,:); vol90T=dat(4,:);
    end
end
%voltage change with battery temperature varying: vltK.fg
figure
lenq=[length(voln10T) length(vol5T) length(vol24T) length(vol60T) length(vol90T)];
len=min(lenq);
H1=plot(timen10T(1:len),voln10T(1:len),'-',time5T(1:len),vol5T(1:len),'--',...
    time24T(1:len),vol24T(1:len),'-',time60T(1:len),vol60T(1:len),'-.',...
    time90T(1:len),vol90T(1:len),'-'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('263K','278K','298K','333K','363K');
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

if 0
lenq=[length(voln10T) length(vol5T) length(vol24T) length(vol60T) length(vol90T)];
len=min(lenq);
crn10t=voln10T(1:len); cr5t=vol5T(1:len);cr24t=vol24T(1:len);
cr60t=vol60T(1:len); cr90t=vol90T(1:len);
%distance
% on a scale of 0 to inf
dis2n10=sum((cr24t-crn10t).*(cr24t-crn10t)./(cr24t+crn10t));
dis25=sum((cr24t-cr5t).*(cr24t-cr5t)./(cr24t+cr5t));
dis260=sum((cr24t-cr60t).*(cr24t-cr60t)./(cr24t+cr60t));
dis290=sum((cr24t-cr90t).*(cr24t-cr90t)./(cr24t+cr90t));
figure
H1=bar([dis2n10 dis25 0 dis260 dis290],0.5);
%H1=plot([-dis2n10 -dis2n10],[1 2],'-',[-dis25 -dis25],[1 2],'-',[0 0],[1 2],'-',...
%    [dis260 dis260],[1 2],'-',[dis290 dis290],[1 2],'-'); %voltage
%set(H1,'MarkerSize',10,'LineWidth',3);
%legend('263K','278K','298K','333K','363K');
xlabel('Distance');
end;

for i=[100721 100722]
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case 100721 
            timen10C=dat(1,:); voln10C=dat(4,:);
        case 100722 
            time90C=dat(1,:); vol90C=dat(4,:);
    end
end
figure
H1=plot(timen10C,voln10C,'-',time90C,vol90C,'-.'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('100A/m^2','100A/m^2 then 4A/m^2');
xlabel('Time (min)');ylabel('Voltage');

%comparison between sequential and parallel
for i=[50 25]
    filename=[path 'dualfoil5sp' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case 50 
            timen10C=dat(1,:); voln10C=dat(4,:);curn10C=dat(6,:);
        case 25 
            time90C=dat(1,:); vol90C=dat(4,:);cur90C=dat(6,:);
    end
end
figure
H1=plot(timen10C,voln10C,'-',time90C,vol90C,'-.'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('100A/m^2','100A/m^2 then 4A/m^2');
xlabel('Time (min)');ylabel('Voltage');

ind=find(curn10C==4);
['100A/m^2 for 10: ' num2str(timen10C(ind(length(ind)))-timen10C(ind(1)))]
ind=find(cur90C==4);
['50A/m^2 for 20: ' num2str(time90C(ind(length(ind)))-time90C(ind(1)))]

%recovery effect regression
filename=[path 'dualfoil5RE2.out']; %check dualfoil5RE and RE2 as well
dat=readfile(filename);
time10C=dat(1,1); vol10C=dat(4,1); dischar=dat(6,1);
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        time10C=[time10C dat(1,j)];
        vol10C=[vol10C dat(4,j)];
        dischar=[dischar dat(6,j)];
    end
end
figure
H1=plot(time10C,vol10C,'-'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('10A/m^2 to 100A/m^2');
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

%recovery efficiency regression
redat=[];retime=[];
ind=find(dischar<1);
k=[ind(1)];
for i=2:length(ind)
    if (ind(i)-ind(i-1)) > 1
        k=[k ind(i-1) ind(i)]; %k = index of dat
    end
end
k=[k ind(i)]; %points at which discharge rate changed

blen=k(3)-k(2)-1;
zlen=k(4)-k(1);
tail=floor((zlen-blen)*1/2)-1;
%flen=floor((k(2)-k(1))/6);
%tlen=floor((k(4)-k(3))*5/6);
%rec=vol10C(k(2)-flen:k(3)+tlen); %from 0 to next 0
rec=vol10C(k(2):k(3)+tail);
tm=time10C(k(2):k(3)+tail);
zlen=length(rec);
for i=4:2:length(k)-2
    blen=zlen-(k(i+1)-k(i)-1);
    rec=[rec; vol10C(k(i):k(i+1)+blen-2)];
    tm=[tm; time10C(k(i):k(i+1)+blen-2)];
end
figure
hold on
rwcl=size(rec);
for i=1:rwcl(1)
    H1=plot(tm(i,:),rec(i,:),'-');
    set(H1,'MarkerSize',10,'LineWidth',2);
end
hold off
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);


retime=dat(1,k(1):k(2));
for j=1:2:length(k)-2
    redat=[redat; max(dat(4,k(j):k(j+1)))+0.1-dat(4,k(j):k(j+1))];
end;

figure
hold on
rwcl=size(redat);
for i=1:rwcl(1)
    H1=plot(retime,redat(i,:),'-');
    set(H1,'MarkerSize',10,'LineWidth',2);
end
hold off
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

figure
hold on
rwcl=size(redat);
beta=[-1;-1;1];
for i=1:rwcl(1)
    b(1:length(retime))=i*10;
    x=[retime;b];
    x=x';
    yhat = nlinfit(x,redat(i,:)',@nlfun,beta);
    nlval=nlfun(yhat,x);
    %logp=polyfit(retime(i,:),log(redat(i,:)),2);
    %polyp=polyval(logp,retime(i,:));
    H1=plot(retime,redat(i,:),'-',retime,nlval','-.');
    set(H1,'MarkerSize',10,'LineWidth',2);
end
hold off
xlabel('Time (min)','FontSize',12);ylabel('Voltage (log)','FontSize',12);

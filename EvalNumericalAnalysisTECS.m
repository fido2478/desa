function EvalNumericalAnalysisTECS

if 1
% Voltage Imbalance
Ey=[];
Vy=[];
lambda_d=1:10; %1/lambda_d > delta_R
delta_R=1-[0.9 0.8 0.7];%[0.01 0.05 0.1]; %delta_R
x=1;y=1;
% if 1/lambda_d <= delta_R, then Ey=0 
Ey(length(lambda_d),length(delta_R))=0; 
Vy(length(lambda_d),length(delta_R))=0;
Er(length(lambda_d),length(delta_R))=0; 
for Y=delta_R
    for X=lambda_d
        %if Y > X
        %    Ey(x,y)=0;
        %else
            Ey(x,y) =1/X*exp(X * Y);
        %end
        Er(x,y)=exp(1/X * Y);
        Vy(x,y)=Ey(x,y)*(2*Y-Ey(x,y));
        x=x+1;
    end
    y=y+1;
    x=1;
end
figure %vi.fg
plot(lambda_d,Ey(:,1),'-', lambda_d, Ey(:,2),'--', lambda_d, Ey(:,3),'-.','MarkerSize',10,'LineWidth',2);
legend('\delta_R = 0.9','\delta_R = 0.8','\delta_R = 0.7','FontSize',14);
xlabel('Degree of voltage-imbalance ( \lambda_d) ','FontSize',14);
ylabel('Degree of suffer','FontSize',14);
%%%%%%%%%%%%%
return
T=10; %years
np=[1:40]; ns=[1:50];
EL=[];ER=[];
for j=1:length(np) %y 
    for i=1:length(ns) %x
        EL(j,i)=SysL(T,ns(i),np(j));
        ER(j,i)=SysR(T,ns(i),np(j));
    end
end
figure %phiL.fig
surf(ns,np,EL);xlabel('n_s','FontSize',14);ylabel('n_p','FontSize',14);
zlabel('Legacy System Lifetime','FontSize',14);
figure %phiR.fig
surf(ns,np,ER);xlabel('n_s','FontSize',14);ylabel('n_p','FontSize',14);
zlabel('Reconfig System Lifetime','FontSize',14);
figure %lifetimegain.fig
ED=(ER-EL)./EL;
surf(ns,np,ED);xlabel('n_s','FontSize',14);ylabel('n_p','FontSize',14);
zlabel('Reconfig Lifetime Gain Over Legacy','FontSize',14);

k=[];
for i=1:length(ns)
    ind=find(EL(:,i)>=10);
    if ~isempty(ind)
        k=[k ind(1)];
    else
        break;
    end
end
p=[];pp=[];ppp=[];
for i=1:length(ns)
    ind=find(ER(:,i)>=10);
    if ~isempty(ind)
        p=[p ind(1)];
    end
    ind=find(ER(:,i)>=20);
    if ~isempty(ind)
        pp=[pp ind(1)];
    end
    ind=find(ER(:,i)>=30);
    if ~isempty(ind)
        ppp=[ppp ind(1)];
    end
end
figure %warnt.fig
plot(k,ns(1:length(k)),'-',p,ns(1:length(p)),'--',pp,ns(1:length(pp)),'-.',...
ppp,ns(1:length(ppp)),':','MarkerSize',10,'LineWidth',2); 
xlabel('n_p','FontSize',14);ylabel('n_s','FontSize',14);
legend('r(Phi_L(X))\geq 10','r(Phi_R(X))\geq 10','r(Phi_R(X))\geq 20','r(Phi_R(X))\geq 30');
axis([1 35 1 20])

diff(ED(length(np),:)) % a slope of gain wrt ns
end %if 0

%requirement 4.1V * ns=150 * 1C * np /745.70
ns=4;np=[1:5:500];
EL=[];ER=[];HP=[];T=10;V=4.1;
for i=1:length(np)
    EL=[EL SysL(T,ns,np(i))];
    ER=[ER SysR(T,ns,np(i))];
    HP=[HP V*ns*1*np(i)/745.70];
end
figure %SLns4.fig
hold on
plot(np,ER,'--','Linewidth',2);%axes('Fontsize',14);
[AX, H1, H2]=plotyy(np,EL,np,HP);
set(get(AX(1),'Ylabel'),'String','System Lifetime','Fontsize',14);
set(get(AX(2),'Ylabel'),'String','HorsePower','Fontsize',14);
xlabel('n_p','Fontsize',14);
set(H1,'LineStyle','-','Linewidth',2);
set(H2,'LineStyle','-.','Linewidth',2);
% less ns more np to increase reliability
hold off

ns=200;np=[1:10];
ER=[];HP=[];EL=[];T=10;V=4.1;
for i=1:length(np)
    EL=[EL SysL(T,ns,np(i))];
    ER=[ER SysR(T,ns,np(i))];
    HP=[HP V*ns*1*np(i)/745.70];
end
figure %SLns200.fig
hold on
plot(np,EL,'--','Linewidth',2);%axes('Fontsize',14);
[AX, H1, H2]=plotyy(np,ER,np,HP);
set(get(AX(1),'Ylabel'),'String','\phi_R Lifetime','Fontsize',14);
set(get(AX(2),'Ylabel'),'String','HorsePower','Fontsize',14);
xlabel('n_p','Fontsize',14);
set(H1,'LineStyle','-','Linewidth',2)
set(H2,'LineStyle','-.','Linewidth',2)
hold off
%If we want to offer 10-year warrenty, what arrangement

C=1.3; %1.3A
I=0.2; %200mA
lamb=3; 
n=20;m=10;
maxtime=5; % < n
Tc=[];Tl=[];Tn=[];
% constant-voltage-keeping policy
% lifetime: Tc=(n-ceil(lamb*tick))*C/I

% legacy scheme
% lifetime: Tl=(n-lamb*tick)*C/I;

% No fault
% lifetime: Tn=n*C/I;

for tick=0:maxtime
    Tn=[Tn n*C/I];
    Tc=[Tc (n-ceil(lamb*tick/m))*C/I];
    Tl=[Tl (n-lamb*tick)*C/I];
end

figure
x=[0:maxtime]*lamb;
%plot(x,Tn, '-x',x,Tc,'-o',x,Tl,'-+','MarkerSize',10,'LineWidth',2);
bar([Tn' Tc' Tl'], 'group');
xlabel('# of faulty battery-cells (\lambda t)');
ylabel('Battery-device lifetime (hour)');

lamb=2;
maxtime=10;

gain=zeros(10,maxtime);
for m=1:10
    for tick=0:maxtime-1
        gain(m,tick+1)=(n-ceil(lamb*tick/m))/(n-lamb*tick);%(lamb*tick-ceil(lamb*tick/m))/(n-lamb*tick);
    end
end


figure
hold on
x=[0:maxtime-1]*lamb/n;
for m=[1 2 5 8 10]%1:10
    text(x(length(x)),gain(m,length(gain(m,:))),['n_s=' num2str(m)],'FontSize',12);
    plot(x,gain(m,:), ':x','MarkerSize',10,'LineWidth',2);
end
xlabel('Failure rate ((\lambda\times t)/n_p)','FontSize',12);
ylabel('A lifetime ratio of reconfiguration to legacy scheme','FontSize',12);
hold off

pow=zeros(20,20);
for m=6:20
    for n=6:20
        pow(m,n)=n*ceil(5/n)-m*ceil(5/m);
    end
end
figure
surface('XData',[6:20],'YData',[6:20],'ZData',pow(6:20,6:20),'CData',pow(6:20,6:20));
view(-45,35)
grid on
xlabel('# of parallel groups (=n)');
ylabel('# of battery-cells in series (=m)');
zlabel('Power (W)');

x=[2.5 3 3.32 3.54 3.68 3.8 3.88 3.98 4.02 4.06 4.08 4.24];
y=[0 0.5 2.1 5.4 8.7 22 58.4 73.4 76.7 81.7 85 100];
figure
plot(x,y,'-x');


%%%%%%%%%%%%
%dyvo3.eps

clear
CurNumDev=0; %the current number of devices
NumDev=700;
BatVolt=4.06267; %upper bound of 3.6 with jitter of 5%
BatAmp=1;%1.3325; %upper bound of 1.3 with jitter of 5%
CFrate=0.7;
DVolt=600; 
power=[];
gi=0;
range=['[' num2str(BatVolt) 'V(' num2str(BatAmp*NumDev)...
    'A) - ' num2str(BatVolt*NumDev) 'V(' num2str(BatAmp) 'A)]']

LCon=struct('name',['lcon' num2str(1)],...
    'Nt',{NumDev},'Nf',{0},'Vd',{DVolt},'Np',{0},'Ns',{0},...
    'nomV',{BatVolt},'aveV',{0},'totV',{0},'totA',{0},...
    'selectpolicy','lowest-voltage-first',...
    'dname',[1 NumDev], 'dcurvolt',rand([1 NumDev])*BatVolt*0.05+BatVolt*0.95,...
    'dcuramp',rand([1 NumDev])*BatAmp*0.05+BatAmp*0.95,'dfeedsw',rand([1 NumDev])*0,...
    'dparasw',rand([1 NumDev])*0,'dserisw',rand([1 NumDev])*0,...
    'dbypsw',rand([1 NumDev])*0,'dfaultcells',rand([1 NumDev])*0,...
    'ddetourcells',rand([1 NumDev])*0,'dconncells',rand([1 NumDev])*0);

figure
hold on
for gi=ceil(12/BatVolt):10:ceil(DVolt/BatVolt*1.5) %25
    %DemandVolt=rand*BatVolt*(NumDev-1);
    DemandVolt=BatVolt*(gi);
    while DemandVolt < BatVolt
        DemandVolt=rand*BatVolt*(NumDev-1); %but DemandVolt > BatVolt
    end;
    LCon.totA=0;LCon.totV=0;
    LCon.Vd=DemandVolt;
    
%Initialization:Open switches
LCon.dfeedsw=rand([1 NumDev])*0;
LCon.dparasw=rand([1 NumDev])*0;
LCon.dserisw=rand([1 NumDev])*0;
LCon.dbypsw=rand([1 NumDev])*0;
%Initialization:faulty cells
LCon.dfaultcells=rand([1 NumDev])*0;
LCon.dconncells=rand([1 NumDev])*0;
LCon.ddetourcells=rand([1 NumDev])*0;
% faulty cell dectaction
voltagecutoff=LCon.nomV*CFrate;
tind=find(LCon.dcurvolt > voltagecutoff);
LCon.aveV=mean(LCon.dcurvolt(tind)); %average Volt from healthy cells
LCon.Ns=ceil(LCon.Vd/LCon.aveV);
if LCon.Ns > NumDev
    LCon.Ns=NumDev;
end
tind=find(LCon.dfaultcells==1);
originfaulty=tind;
actNt=LCon.Nt-length(tind); %actual Num of cells available
LCon.Np=floor((actNt)/LCon.Ns);

num2bypass=actNt-LCon.Np*LCon.Ns;

if num2bypass>0
    for i=1:num2bypass %select cells to bypass in order of the lowest volt first
        tind=((LCon.dfaultcells&LCon.ddetourcells)==0);
        tind=find(LCon.dcurvolt==min(LCon.dcurvolt(tind)));
        LCon.ddetourcells(tind)=1;
    end;
end;


% Wiring and Drawing
for j=1:LCon.Np
    tind=find((LCon.dfaultcells&LCon.ddetourcells&LCon.dconncells)==0);
    LCon.dfeedsw(tind(1))=1; %feed switch ON on dev1
    LCon.dconncells(tind(1))=1; %connectivity indication
    for i=1:LCon.Ns-1
        LCon.dserisw(tind(i))=1; % series switch ON from dev2 till dev(n-1)
        LCon.dconncells(tind(i))=1; %connectivity indication
        LCon.totV=LCon.totV+LCon.dcurvolt(tind(i)); %increase in volt
    end %i
    LCon.dparasw(tind(LCon.Ns))=1; % parallel switch ON on devn
    LCon.dconncells(tind(LCon.Ns))=1; %connectivity indication
    LCon.totV=LCon.totV+LCon.dcurvolt(tind(LCon.Ns));%increase in volt
    LCon.totA=LCon.totA+LCon.dcuramp(tind(LCon.Ns));%increase in ampere
end %j
if LCon.Np > 0
    LCon.totV=LCon.totV/LCon.Np;
end;
text(LCon.totV, LCon.totV*LCon.totA/1000,['(' num2str(LCon.Ns) ',' num2str(LCon.Np) ')'],'FontSize',14);
power=[power [LCon.totV; LCon.totV*LCon.totA/1000]];
end %for gi

plot(power(1,:),power(2,:), 'x:','MarkerSize',10,'LineWidth',2);
xlabel('Demand voltage (V_d)','FontSize',14);
ylabel('Power (kW)','FontSize',14);
%dynvolt3.eps
hold off
function EvalNumericalAnalysis

if 1
% Voltage Imbalance
Ey=[];
Vy=[];
overlambda_d=0.001:0.001:0.3; %1/lambda_d > delta_R
delta_R=[0.01 0.05 0.1]; %delta_R
x=1;y=1;
% if 1/lambda_d <= delta_R, then Ey=0 
Ey(length(overlambda_d),length(delta_R))=0; 
Vy(length(overlambda_d),length(delta_R))=0;
Er(length(overlambda_d),length(delta_R))=0; 
for Y=delta_R
    for X=overlambda_d
        if Y > X
            Ey(x,y)=0;
        else
            Ey(x,y) =X*exp(-1/X * Y);
        end
        Er(x,y)=exp(-1/X * Y);
        Vy(x,y)=Ey(x,y)*(2*Y-Ey(x,y));
        x=x+1;
    end
    y=y+1;
    x=1;
end
figure %vi.fg
plot(overlambda_d,Ey(:,1),'-', overlambda_d, Ey(:,2),'--', overlambda_d, Ey(:,3),'-.','MarkerSize',10,'LineWidth',2);
legend('\delta_R = 0.01','\delta_R = 0.05','\delta_R = 0.1');
xlabel('Average amount of damage (\lambda_d^{-1} ) ','FontSize',12);
ylabel('Suffer amount','FontSize',12);
%%%%%%%%%%%%%

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
function MainPerfFaultTol
% This function evaluate how effectively dynamic-voltage
% allowing policy works as demand voltage changes over time
%Global parameters
clear
CurNumDev=0; %the current number of devices
NumDev=20;
BatVolt=4.1;
BatAmp=1.3;
CFrate=0.7;
DemandVolt=20; %ampere
power=[];numfcells=[];
fqof=15; %frequency of faut occurrence
fqod=1; %frequency of degradation of voltage over time by nature
lifetime=200;
p=findpolyfunc(lifetime,0);
range=['[' num2str(BatVolt) 'V(' num2str(BatAmp*NumDev)...
    'A) - ' num2str(BatVolt*NumDev) 'V(' num2str(BatAmp) 'A)]']

if 0
DemandVolt=rand*BatVolt*(NumDev-1);
while DemandVolt < BatVolt
   DemandVolt=rand*BatVolt*(NumDev-1); %but DemandVolt > BatVolt
end;
end; %if 0

LCon=struct('name',['lcon' num2str(1)],...
    'Nt',{NumDev},'Nf',{0},'Vd',{DemandVolt},'Np',{0},'Ns',{0},...
    'nomV',{BatVolt},'aveV',{0},'totV',{0},'totA',{0},...
    'selectpolicy','lowest-voltage-first',...
    'dname',[1 NumDev], 'dcurvolt',rand([1 NumDev])*BatVolt*0.05+BatVolt*0.95,...
    'dcuramp',rand([1 NumDev])*BatAmp*0.05+BatAmp*0.95,...
    'dfeedsw',rand([1 NumDev])*0,...
    'dparasw',rand([1 NumDev])*0,'dserisw',rand([1 NumDev])*0,...
    'dbypsw',rand([1 NumDev])*0,'dfaultcells',rand([1 NumDev])*0,...
    'ddetourcells',rand([1 NumDev])*0,'dconncells',rand([1 NumDev])*0);
 
for gi=1:lifetime

    LCon.totV=0;LCon.totA=0;
%Initialization:Open switches
LCon.dfeedsw=rand([1 NumDev])*0;
LCon.dparasw=rand([1 NumDev])*0;
LCon.dserisw=rand([1 NumDev])*0;
LCon.dbypsw=rand([1 NumDev])*0;
%Initialization:faulty cells
%LCon.dfaultcells=rand([1 NumDev])*0;
LCon.dconncells=rand([1 NumDev])*0;
LCon.ddetourcells=rand([1 NumDev])*0;

% calcul average voltage
voltagecutoff=LCon.nomV*CFrate;
tind=find(LCon.dfaultcells==0);
if ~isempty(tind)
    LCon.aveV=mean(LCon.dcurvolt(tind)); %average Volt from healthy cells
else
    break;
end;
LCon.Ns=ceil(LCon.Vd/LCon.aveV);
tind=find(LCon.dfaultcells==1);
originfaulty=tind;
actNt=LCon.Nt-length(tind); %actual Num of cells available
LCon.Np=floor((actNt)/LCon.Ns);

num2bypass=actNt-LCon.Np*LCon.Ns;

if num2bypass>0
    for i=1:num2bypass %select cells to bypass in order of the lowest volt first
        tind=(LCon.dfaultcells==0&LCon.ddetourcells==0);
        tind=find(LCon.dcurvolt==min(LCon.dcurvolt(tind)));
        LCon.ddetourcells(tind)=1;
    end;
end;


% Wiring and Drawing
for j=1:LCon.Np
    tind=find(LCon.dfaultcells==0&LCon.ddetourcells==0&LCon.dconncells==0);
    LCon.dfeedsw(tind(1))=1; %feed switch ON on dev1
    LCon.dconncells(tind(1))=1; %connectivity indication
    for i=1:LCon.Ns-1
        LCon.dserisw(tind(i))=1; % series switch ON from dev2 till dev(n-1)
        LCon.dconncells(tind(i))=1; %connectivity indication
        LCon.totV=LCon.totV+LCon.dcurvolt(tind(i)); %increase in volt
    end %i
    i=i+1;
    LCon.dparasw(tind(i))=1; % parallel switch ON on devn
    LCon.dconncells(tind(i))=1; %connectivity indication
    LCon.totV=LCon.totV+LCon.dcurvolt(tind(i));%increase in volt
    LCon.totA=LCon.totA+LCon.dcuramp(tind(i));%increase in ampere
end %j
if LCon.Np > 0
    LCon.totV=LCon.totV/LCon.Np;
end;
power=[power [LCon.totV; LCon.totV*LCon.totA]];
numfcells=[numfcells length(find(LCon.dfaultcells==1))];
%Decrease voltage in cells connected linearly
%if 0
if mod(gi,fqod)==0
    tind=find(LCon.dconncells==1);
    if ~isempty(tind)
        y=polyval(p,[gi-1 gi]);
        LCon.dcurvolt(tind)=LCon.dcurvolt(tind) + (y(2)-y(1));
    end;
end;
%end
%Generate faulty cells
if mod(gi,fqof)==0
    tind=find(LCon.dfaultcells==0);
    if ~isempty(tind)
        pick=ceil(rand*length(tind));
        LCon.dcurvolt(tind(pick))=LCon.dcurvolt(tind(pick))*CFrate;
    end;
end;

%Verification of faulty cells
voltagecutoff=LCon.nomV*CFrate;
tind=find(LCon.dcurvolt < voltagecutoff);
if ~isempty(tind)& LCon.totV > 0
    LCon.dfaultcells(tind)=1;
end;
end %for gi

figure
rl=size(power);
hold on
%plot([1:rl(2)],power(1,:),'-r',[1:rl(2)],power(2,:), '--',[1:rl(2)],numfcells,':k','MarkerSize',10,'LineWidth',2);
[AX,H1,H2]=plotyy([1:rl(2)],power(2,:),[1:rl(2)],numfcells,'plot');
set(H1,'LineStyle','--','MarkerSize',10,'LineWidth',2);
set(H2,'LineStyle',':','MarkerSize',10,'LineWidth',2);
H1=plot([1:rl(2)],power(1,:),'-r','MarkerSize',10,'LineWidth',2);
hold off
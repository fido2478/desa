function MainPerfEvalDyVolt
% This function evaluate how effectively dynamic-voltage
% allowing policy works as demand voltage changes over time
%Global parameters
clear
CurNumDev=0; %the current number of devices
NumDev=25;
BatVolt=3.69; %upper bound of 3.6 with jitter of 5%
BatAmp=1.3325; %upper bound of 1.3 with jitter of 5%
CFrate=0.7;
DemandVolt=30; %ampere
power=[];
gi=0;
range=['[' num2str(BatVolt) 'V(' num2str(BatAmp*NumDev)...
    'A) - ' num2str(BatVolt*NumDev) 'V(' num2str(BatAmp) 'A)]']

LCon=struct('name',['lcon' num2str(1)],...
    'Nt',{NumDev},'Nf',{0},'Vd',{DemandVolt},'Np',{0},'Ns',{0},...
    'nomV',{BatVolt},'aveV',{0},'totV',{0},'totA',{0},...
    'selectpolicy','lowest-voltage-first',...
    'dname',[1 NumDev], 'dcurvolt',rand([1 NumDev])*BatVolt*0.05+BatVolt*0.95,...
    'dcuramp',rand([1 NumDev])*BatAmp*0.05+BatAmp*0.95,'dfeedsw',rand([1 NumDev])*0,...
    'dparasw',rand([1 NumDev])*0,'dserisw',rand([1 NumDev])*0,...
    'dbypsw',rand([1 NumDev])*0,'dfaultcells',rand([1 NumDev])*0,...
    'ddetourcells',rand([1 NumDev])*0,'dconncells',rand([1 NumDev])*0);

figure
hold on
for gi=1:25%200
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
text(LCon.totV, LCon.totV*LCon.totA,['(' num2str(LCon.Ns) ',' num2str(LCon.Np) ')']);
power=[power [LCon.totV; LCon.totV*LCon.totA]];
end %for gi

plot(power(1,:),power(2,:), 'x:','MarkerSize',10,'LineWidth',2);
xlabel('Demand voltage (V_d)');
ylabel('Power (W)');
hold off
LCon
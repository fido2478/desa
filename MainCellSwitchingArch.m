function CellSwitchingArch
% 
%Global parameters
clear
CurNumDev=0; %the current number of devices
NumDev=20;
BatVolt=3.6;
BatAmp=1.3;
CFrate=0.7;
DemandVolt=30; %ampere
g=figure
range=['[' num2str(BatVolt) 'V(' num2str(BatAmp*NumDev)...
    'A) - ' num2str(BatVolt*NumDev) 'V(' num2str(BatAmp) 'A)]'];

while 1
reply = input(['Volt required? ' range ' : '],'s');
if isempty(reply)
    reply = '30';
end %if
DemandVolt=str2num(reply);
% configuration
%---(fs)--[dev]--(ps)---
%     /    |
%   (bs)  (ss)
%   /      |
%---(fs)--[dev]--(ps)---
%     /    |
%   (bs)  (ss)
%   /      |
%---(fs)--[dev]--(ps)---
%     /    |
%   (bs)  (ss)
%   /      |
%---(fs)--[dev]--(ps)---
%          |
%         (ss)
%          |
%---(fs)--[dev]--(ps)---

%Create one battery pack: i subcontrollers each of which has j cells
%Sub Controller
%numseries determine voltage; start with 1
%numparallel determine capacity (amp); start with 0
LCon=struct('name',['lcon' num2str(1)],...
    'Nt',{NumDev},'Nf',{0},'Vd',{DemandVolt},'Np',{0},'Ns',{0},...
    'nomV',{BatVolt},'aveV',{0},'totV',{0},'totA',{0},...
    'selectpolicy','lowest-voltage-first',...
    'dname',[1 NumDev], 'dcurvolt',rand([1 NumDev])+3,...
    'dcuramp',rand([1 NumDev])+BatAmp,'dfeedsw',rand([1 NumDev])*0,...
    'dparasw',rand([1 NumDev])*0,'dserisw',rand([1 NumDev])*0,...
    'dbypsw',rand([1 NumDev])*0,'dfaultcells',rand([1 NumDev])*0,...
    'ddetourcells',rand([1 NumDev])*0,'dconncells',rand([1 NumDev])*0);

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
h=figure
hold on

for j=1:LCon.Np
    tind=find((LCon.dfaultcells&LCon.ddetourcells&LCon.dconncells)==0);
    LCon.dfeedsw(tind(1))=1; %feed switch ON on dev1
    LCon.dconncells(tind(1))=1; %connectivity indication
    h=plot([tind(1) tind(1)],[1 2],'-','LineWidth',2); %draw circuits
    for i=1:LCon.Ns-1
        LCon.dserisw(tind(i))=1; % series switch ON from dev2 till dev(n-1)
        LCon.dconncells(tind(i))=1; %connectivity indication
        LCon.totV=LCon.totV+LCon.dcurvolt(tind(i)); %increase in volt
        h=plot([tind(i) tind(i) tind(i)+0.5 tind(i)+0.5 tind(i+1) tind(i+1)],...
            [2 2.5 2.5 1.5 1.5 2],'-','LineWidth',2); %draw series
    end %i
    i=i+1;
    LCon.dparasw(tind(i))=1; % parallel switch ON on devn
    LCon.dconncells(tind(i))=1; %connectivity indication
    LCon.totV=LCon.totV+LCon.dcurvolt(tind(i));%increase in volt
    LCon.totA=LCon.totA+LCon.dcuramp(tind(i));%increase in ampere
    h=plot([tind(i) tind(i)], [2 3],'-','LineWidth',2);
end %j
LCon.totV=LCon.totV/LCon.Np;
LCon
h=plot([1:NumDev],zeros([1 NumDev])+2, 's','MarkerSize',10);
h=plot(originfaulty,zeros([1 length(originfaulty)])+2,'x','MarkerSize',10);
hold off

reply = input('Do you want more? Y/N [Y]: ','s');
if (reply=='N' | reply=='n')
    break;
end
end %while
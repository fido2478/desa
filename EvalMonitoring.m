function EvalMonitoring
clear
CurNumDev=3; %the current number of devices
NumDev=5;
BatVolt=4.3;
BatAmp=1300;
CFrate=0.7;
power=[];numfcells=[];
vdegArt=0; dratio=0.995;
lifetime=100;
p=findpolyfunc(100,0); %viewed as discharge rate: if scale>1 stretch otherwise not
range=['[' num2str(BatVolt) 'V(' num2str(BatAmp*NumDev)...
    'A) - ' num2str(BatVolt*NumDev) 'V(' num2str(BatAmp) 'A)]']

LCon=struct('name',['lcon' num2str(1)],...
    'dname',[1 NumDev], 'dcurvolt',rand([1 NumDev])*BatVolt*0.01+BatVolt*0.99,...
    'dcuramp',rand([1 NumDev])*BatAmp*0.01+BatAmp*0.99,...
    'onsch',rand([1 NumDev])*0);

ddI=40;
%dI=rand*ddI;
dI=20;
ddT=5;
%dT=rand*ddT;
dT=30;
%dT=1/dI;
thres=0.1;
SOC=[];

LCon.onsch(:)=1;
temparr=LCon.dcuramp;
for i=1:(NumDev-CurNumDev)
    [c in]=min(temparr);
    LCon.onsch(in)=0;
    temparr(in)=max(temparr);
end

alpha=0.3;
for gi=1:lifetime
   %scheduling
   dSOC=min(LCon.dcuramp)/max(LCon.dcuramp);
   if (dSOC) > thres
       LCon.onsch(:)=1;
       temparr=LCon.dcuramp;
        for i=1:(NumDev-CurNumDev)
            [c in]=min(temparr);
            LCon.onsch(in)=0;
            temparr(in)=max(temparr);
        end
   end
   indx=find(LCon.onsch==1);
   dI=(rand*ddI/lifetime)*alpha+(1-alpha)*dI;
   LCon.dcuramp(indx)=LCon.dcuramp(indx)-dI*dT;
   SOC=[SOC dSOC]; 
end
figure
plot([1:length(SOC)],SOC,'-');
function CellSwitchingArch

%Global parameters
CurNumDev=0; %the current number of devices
NumBPack=1;
NumSCon=4;
NumDevperSC=4;
BatVolt=3.6;
BatAmp=1300;

BPack=[];
% configuration
%---(is)--[dev]--(os)---
%     /    |
%   (os)  (os)
%   /      |
%---(is)--[dev]--(os)---
%     /    |
%   (os)  (os)
%   /      |
%---(is)--[dev]--(os)---
%     /    |
%   (os)  (os)
%   /      |
%---(is)--[dev]--(os)---
%          |
%         (os)
%          |
%---(is)--[dev]--(os)---

%Create one battery pack: i subcontrollers each of which has j cells
for k=1:NumBPack
    for i=1:NumSCon
        %Sub Controller
        %numseries determine voltage; start with 1
        %numparallel determine capacity (amp); start with 0
        BPack(k).SCon(i)=struct('name',['scon' num2str(i)],...
            'maxvolt',{0},'maxamp',{0},'numinsw',{0},'numoutsw',{0},...
            'numseries',{0},'numparallel',{0},'selectpolicy','random',...
            'faultydevs','','mempredevs','',...
            'devices',struct('name','','volt',{BatVolt},...
            'amphere',{BatAmp},'feedsw',{0},'parsw',{0},...
            'serisw',{0},'bypsw',{0},'lfbus',{0},'rtbus',{0}));
        %Cell Nest
        for j=1:NumDevperSC
            BPack(k).SCon(i).devices(j)=struct('name',...
                ['dev' num2str(j+CurNumDev)],'volt',{BatVolt},...
                'amphere',{BatAmp},'feedsw',{0},...
                'parsw',{0},'serisw',{0},'bypsw',{0},...
                'lfbus',{0},'rtbus',{0});
        end % j
        CurNumDev=CurNumDev+j;
        BPack(k).SCon(i).maxvolt=j*BatVolt;
        BPack(k).SCon(i).maxamp=j*BatAmp;
        %Bridge Bus
        BPack(k).BBus(i)=struct('name',{['bbus' num2str(i)]},...
            'inconn',{0},'outconn',{0});
    end % i
    BPack(k).BBus(i+1)=struct('name',{['bbus' num2str(i+1)]},...
        'inconn',{0},'outconn',{0});
    BPack(k).LCon=struct('name',['bpack', num2str(k)],...
        'maxvolt',0,'maxamp',0,'policy','random');
    sumvolt=0;sumamp=0;
    for ti=1:i
        sumvolt=sumvolt+BPack(k).SCon(ti).maxvolt;
        sumamp=sumamp+BPack(k).SCon(ti).maxamp;
    end;
    BPack(k).LCon.maxvolt=sumvolt;
    BPack(k).LCon.maxamp=sumamp;
end % k
%One Battery Pack has been created


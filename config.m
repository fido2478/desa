function ctl=config(ctl,bat_pack)
numbypass=ctl.numcells-length(find(ctl.PB==1))-ctl.ns*ctl.np;
ind=find(ctl.TB==1);
ctl.TB(ind)=0; % reset
ctl.sdev(:,:)=0;
ctl.npgrp=[];
avail_pack=bat_pack.bpack;
for i=1:numbypass %find BC with the lowest SoC level
    ind=find(min(avail_pack)==avail_pack);
    ctl.TB(ind(1))=1;
    avail_pack(ind(1))=Inf;
end
%reconfiguration: connect
ctl.TB=ctl.TB+ctl.PB;
%ind=find(ctl.TB==0);
kk=0;%ind(1);
for i=1:ctl.np
    ind=kk+find(ctl.TB(kk+1:length(ctl.TB))==0);
    kk=ind(1);
    ctl.sdev(1,kk)=1; %input switch
    while ctl.TB(kk)>0
        ctl.sdev(2,kk)=1; %bypass switch
        kk=kk+1;
    end %while
    ctl.sdev(3,kk)=1; %series switch
    j=1;
    ctl.npgrp(i,j)=kk;    
    while j<(ctl.ns-1)
        kk=kk+1;
        while ctl.TB(kk)>0
            ctl.sdev(2,kk)=1; %bypass switch
            kk=kk+1;
        end %while
        ctl.sdev(3,kk)=1; %series switch
        j=j+1;
        ctl.npgrp(i,j)=kk;
    end %while
    j=j+1;
    kk=kk+1;
    ctl.npgrp(i,j)=kk;
    ctl.sdev(4,kk)=1; %parallel switch
end %for
        
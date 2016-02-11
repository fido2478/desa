function bat_pack=simdischarge(bat_pack,coeff,load_demand,npgrp,interval)
rwcl=size(npgrp);
refCC=bat_pack.refC;
dpergrp=load_demand/rwcl(1);
if load_demand < 1
    return
end
for i=1:rwcl(1)
    for j=1:rwcl(2)
        soc=bat_pack.bpack(npgrp(i,j))/bat_pack.max_cap;
        ti=0;
        ind=find(refCC.sX<=soc);
        if ~isempty(ind)
            ti=refCC.tX(ind(1));
        end
        dt=0;dV=0;
        if round(dpergrp)==0
            dt=1;dV=0;
        else
            p=coeff(round(dpergrp),:); % A/m2
            dt=polyval(p,ti+round(60/interval))-polyval(p,ti); %min time vs time
            dV=polyval(refCC.p,ti)-polyval(refCC.p,ti+abs(dt)); %time vs voltage
        end
        bat_pack.bvolt(npgrp(i,j))=bat_pack.bvolt(npgrp(i,j))-abs(dV);
        bat_pack.bpack(npgrp(i,j))=bat_pack.bpack(npgrp(i,j))-round(dpergrp)/23*interval;
    end
end
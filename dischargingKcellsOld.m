function [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
    avail_volt,load_demand,max_cap,interval,sp,k,refC,coeff)
for m=1:k
    discharge=load_demand*avail_pack(sp(m))/sum(avail_pack(sp(1:k)));
    %avail_pack(sp(m))=avail_pack(sp(m))-discharge;
    soc=avail_pack(sp(m))/max_cap;
    ti=0;
    ind=find(refC.sX<=soc);
    if ~isempty(ind)
        ti=refC.tX(ind(1));
    end
    if floor(discharge) > 100 | floor(discharge) < 0 %coulomb
        load_demand
        avail_pack(sp(m))
        sum(avail_pack(sp(1:k)))
        return
    end
    if round(discharge)==0
        dt=1;dV=0;
    else
        p=coeff(round(discharge),:); % A/m2
        dt=polyval(p,ti+round(interval/60))-polyval(p,ti); %min time vs time
        dV=polyval(refC.p,ti)-polyval(refC.p,ti+abs(dt)); %time vs voltage
    end
    avail_volt(sp(m))=avail_volt(sp(m))-abs(dV);
    avail_pack(sp(m))=avail_pack(sp(m))-round(discharge)/23*interval;
    %pw=hashing(min_pw,discharge/interval);
    %coulomb
    %avail_volt(sp(m))=emulate_voltagechange(pw,discharge/interval,soc);
end 
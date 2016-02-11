function [RE, ldisch]=recovery_count(bat_pack, avail_pack,interval);
diff_charge=bat_pack.bpack(bat_pack.GH)-avail_pack;%before-after coulomb
ind=find(diff_charge==0);
if ~isempty(ind) %not discharged
    bat_pack.RE(bat_pack.GH(ind))=bat_pack.RE(bat_pack.GH(ind))+1;%check this
end
ind=find(diff_charge>0);
if ~isempty(ind)
    bat_pack.RE(bat_pack.GH(ind))=0;
    bat_pack.ldisch(bat_pack.GH(ind))=diff_charge(ind);
end
if ~isempty(bat_pack.GL)
    bat_pack.RE(bat_pack.GL)=bat_pack.RE(bat_pack.GL)+1;
end
RE=bat_pack.RE;
ldisch=bat_pack.ldisch/interval;%Coulomb
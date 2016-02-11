function [avail_pack, avail_volt]=discharge_scheduling(policy2,k,etime,max_capacity,...
    load_demand,avail_pack,avail_volt,min_pw,interval)
%This function is replaced by dischargingKcells;as such, not used any more
% k: # of cells 
% etime: current time in second
% pick and choose top k cells
sp=[];
%SoC-based order
if isempty(avail_pack)
    return;
end;
copy_pack=avail_pack;
%Volt-based order
%copy_pack=avail_volt;
while length(sp) < length(copy_pack)
    ind=find(max(copy_pack)==copy_pack);
    if ~isempty(ind)
        sp=[sp ind];
        copy_pack(ind)=0;
    end  
end

% one cell is in lower voltage than another but it is at higher SoC level
if (k<length(avail_pack)) & (avail_volt(sp(k))<avail_volt(sp(k+1)) & policy2 > 0)
    tmp=sp(k);
    sp(k)=sp(k+1); 
    sp(k+1)=tmp;
end
%circle=sort(avail_pack, 'descend'); %coulombs
%circle_v=sort(avail_volt,'descend'); %volt
for i=1:k
    discharge=load_demand* avail_pack(sp(i))/sum(avail_pack(sp(1:k))); %coulomb
    avail_pack(sp(i))=avail_pack(sp(i))-discharge; %coulumbs per second
    soc=avail_pack(sp(i))/max_capacity;
    pw=hashing(min_pw,discharge/interval);
    % input current (coulomb)
    avail_volt(sp(i))=emulate_voltagechange(pw,discharge/interval,soc);
end

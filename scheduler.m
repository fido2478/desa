% battery simulator
function scheduler
clear all
%close all
% figure out this battery's characteristics
% amphere-hour, trade-off btw recovery efficiency and discharge rate
% 60 seconds : 60 coulumbs then 1 hour : 3600 coulumbs
% 1 coulumb : 1 sec : 23A/m2
% SOC scale is the same as lifetime
% SOC = 1 - sum of coulombs discharged/nominal coulombs
% nominal coulombs = 7200 means it lasts 2 hours when 1 coulomb per sec
% So, e.g., 20 Amp for 100 secs and 0.1 for the rest, ave amp is then
% 20*100/7200 + 0.1*7100/7200 =0.0986 amp
% the lifetime is 7200/0.0986 = 73022 secs

% init: number of cells, nominal coulombs of each
% input: number of coulombs in each interval (ms)
% process: calculate SOC of each Note coulombs not change but voltage
% output: number of coulumbs discharged in each interval

% init: number of cells, nominal coulombs of each
max_cap=3602.7; %coulombs 3602.7
max_volt=4.306267;
nomcells=4;
battery_pack=[];
battery_voltage=[];
k=0; % # of active cells (selected) every cycle
%GH=[];GL=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%offlin setup voltage and recovery functions
% discharge rate
%[1-8], [9-18], [19-23], [24-34], [35-64], [65-80], [81-90],[91-100]
%inx=[1, 9, 19, 24, 35, 65, 81, 91, 101];
if 0
inx=[1,24,65,101];
min_pw=[];
for i=1:length(inx)-1
    pw=calcul_coeff_volt(inx(i),inx(i+1)-1); %in minute
    min_pw=[min_pw struct('id',(inx(i+1)-1)/23,'pw',pw)];
    %min_pw=[min_pw; [inx(i+1)-1 pw]];
end;
end;

% recovery rate
% returns coeff of RT1;RT2;RT10 based on Coulomb
coeff_re=calcul_coeff_re(1,100); %[p1; p2; p10]
% find max recovery efficiency
p=coeff_re(1,:);
dep=polyder(p);
ddep=polyder(dep);
x=[0:0.00002:4];
ind=find(polyval(dep,x)<=0.000002 & polyval(dep,x)>=-0.000002);
maxreC=[];
for l=1:length(ind)
    if polyval(ddep,x(ind(l))) < 0 & x(ind(l)) > 0.5
        maxreC=[maxreC x(ind(l))];
    end
end
%maxreC=[0.8261 2.0435];
refC=Vref('dat/dualfoil5C23.out');
[coeff]=calcul_coeff_volt_new(1,100,refC);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%profiling load demand
runtimeratio=1; %0 to 1 (100% to 0%)
interval=60;%every x second(s)
lower_demand=18; %C1 (= 23A/m2)
upper_demand=100;   %C4
max_demand=upper_demand;
load_delta=lower_demand;
max_runtime=floor((max_cap*runtimeratio)*60/interval); %minute
load_demand=[];
dis_type='rand';

switch dis_type
    case 'rand'
        load_demand=loadfile('dat/log/load_demand-rand.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            for i=2:max_runtime
                derivative=load_demand(i-1)+round(load_delta*normrnd(0,0.5));
                if derivative > upper_demand
                    derivative=upper_demand;
                elseif derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const1'
        load_demand=loadfile('dat/log/load_demand-const10.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(1)*23*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.025)
                derivative=load_demand(i-1)+round(0.05*load_delta*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.025)+1:max_runtime
                derivative=load_demand(i-1)-round(0.05*load_delta*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const2'
        load_demand=loadfile('dat/log/load_demand-const20.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(2)*23*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.05)
                derivative=load_demand(i-1)+round(0.05*load_delta*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.05)+1:max_runtime
                derivative=load_demand(i-1)-round(0.05*load_delta*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end
    case 'const3'
        load_demand=loadfile('dat/log/load_demand-const30.txt','%d ', [1 Inf]);
        if isempty(load_demand) | load_demand<0
            load_demand=lower_demand;
            upper_demand=maxreC(1)*23*(round(nomcells*0.5));
            for i=2:round(max_runtime*0.025)
                derivative=load_demand(i-1)+round(0.05*load_delta*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.025)+1:round(max_runtime*0.05)
                derivative=load_demand(i-1)-round(0.05*load_delta*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.05)+1:round(max_runtime*0.1)
                derivative=load_demand(i-1)+round(0.05*load_delta*rand);
                if derivative > upper_demand
                    derivative=upper_demand;
                end
                load_demand=[load_demand derivative];
            end
            for i=round(max_runtime*0.1)+1:max_runtime
                derivative=load_demand(i-1)-round(0.05*load_delta*rand);
                if derivative < lower_demand
                    derivative=lower_demand;
                end
                load_demand=[load_demand derivative];
            end
            if savefile(load_demand,'%d ','dat/log/load_demand.txt')<0
                return;
            end
        end

end %switch       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Init parameter
turn=0.05;% at 1C (23A/m2) at this point voltage steeply drops
thres_g=turn*upper_demand/23;%at 100A/m2, voltage steeply drops %u_demand/max_cap * nomcells;% 0.2: 
shutdown=thres_g*turn*8; 
dyn_thres=1; %not much different
decr=0.5;

%thres_g=upper_demand/max_cap;% 0.2: 
%shutdown=thres_g*0.05;
%pw=hashing(min_pw,upper_demand/interval);
%cutoff_voltage=polyval2(pw,upper_demand/interval,thres_g);%3.5; %voltage cutoff
ind=find(refC.sX<=0.0005); %important factor
cutoff_voltage=polyval(refC.p,refC.tX(ind(1)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup Battery packs
numofsch=4;
name=['kRR';'1RR';'Seq';'nRR'];
batpack(1:nomcells)=max_cap;
batpack(1:nomcells)=[max_cap max_cap max_cap  max_cap];%max_cap*0.90];
batvolt(1:nomcells)=max_volt;
batvolt(1:nomcells)=[max_volt max_volt max_volt  max_volt];%max_volt*0.90];
bat_pack=[];
init(1:nomcells)=0;
for i=1:numofsch
    bat_pack=[bat_pack struct('id',name(i,:),'bpack',batpack,...
        'bvolt',batvolt,'RE',init,'ldisch',init,'GH',find(batpack>thres_g*max_cap),...
        'GL',find(batpack<=thres_g*max_cap),'k',[],'thres_g',thres_g,'status',0,...
        'shutdown',shutdown,'turn',turn,...
        'soc_log',[],'volt_log',[],'ldiff_log',[],'vdiff_log',[],'load_log',[])];
end
%%%%%%%%%%%%%%%%%%%%%%%%%
%log
soc_log=[];
volt_log=[];
load_log=[];
ldiff_log=[];
vdiff_log=[];
otime_log(1:numofsch)=0;
%%%%%%%%%%%%%%%%%%%%%%%%%

sch_policy=1; %1: k-RR; 2:1-RR; 3:sequential; 4:parallel
temp_pack=[];temp_volt=[];

listofsch=[1 2 3 4];
for i=1:max_runtime %second
    %avail_pack=battery_pack(GH);
    %avail_volt=battery_voltage(GH);

    if isempty(listofsch)
        break;
    end
    %log in each interval of 100ms
    for j=listofsch
        bat_pack(j).soc_log=[bat_pack(j).soc_log; bat_pack(j).bpack/max_cap];
        bat_pack(j).volt_log=[bat_pack(j).volt_log; bat_pack(j).bvolt];
    end    
    %soc_log=[soc_log; battery_pack/max_cap];
    %volt_log=[volt_log; battery_voltage];
    
    %num_cells=length(avail_pack);
    
    for j=listofsch
        switch j
            case 1%kRR
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        listofsch=listofsch(find(listofsch ~= j));
                        otime_log(j)=i;
                        continue;
                    end
                    bat_pack(j).status=1; %capacity status: low
                end

                avail_pack=bat_pack(j).bpack(bat_pack(j).GH);
                avail_volt=bat_pack(j).bvolt(bat_pack(j).GH);
                
                prior2load=bat_pack(j).bpack;
                num_cells=length(avail_pack);
                k=0;
                              
                if 0
                    k=ceil(num_cells * load_demand(i) / max_demand);
                else % adjust load_demand to fit max recovery
                    %vector of second order of derivative
                    ok=round(load_demand(i)./(maxreC*23));
                    if ok(1)> num_cells
                        k=ok(1)-ok(2); 
                    elseif ok(1)<1
                        k=1;
                    else
                        k=ok(1);
                    end
                    if k > num_cells
                        k=num_cells
                    end
                 end %if 0 or 1
                
                if bat_pack(j).status %when soc is low then nRR
                    k=num_cells;
                end
                
                bat_pack(j).k=[bat_pack(j).k k];
                
                if 1
                    sp=sorted_index(avail_pack);
                else %recovered cells first
                    ldisch=find(bat_pack(j).ldisch(bat_pack(j).GH)==0); %if ldisch==0 re
                    sp=0;si=sorted_index(avail_pack);
                    if ~isempty(ldisch)
                        sp=ldisch;
                        for m=1:length(si)
                            if isempty(find(si(m)==ldisch))
                                sp=[sp si(m)];
                            end
                        end
                    else
                        sp=si;
                    end
                end %if 0 or 1
                
                % distribute workloads
                [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
                avail_volt,load_demand(i),max_cap,interval,sp,k,refC,coeff); 
                indx=find(bat_pack(j).bvolt<0);
                
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);
                    
                % update SoC and Voltage               
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand(i)/k];
                
                %update GH
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand(i)/23;%u_demand/max_cap * nomcells;% 0.2: 
                end                
                down=merge(find(avail_pack<=bat_pack(j).thres_g*max_cap),...
                    find(avail_volt<=cutoff_voltage)); %| or operation
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*max_cap),...
                    find(avail_volt>cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < shutdown 
                    listofsch=listofsch(find(listofsch ~= j));
                    otime_log(j)=i;
                end;

            case 2 %rr
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        listofsch=listofsch(find(listofsch ~= j));
                        otime_log(j)=i;
                        continue;
                    end
                end
                avail_pack=bat_pack(j).bpack(bat_pack(j).GH);
                avail_volt=bat_pack(j).bvolt(bat_pack(j).GH);
                prior2load=bat_pack(j).bpack;
                k=1;
                bat_pack(j).k=[bat_pack(j).k k];
                sp=sorted_index(avail_pack);
                % distribute workloads
                [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
                avail_volt,load_demand(i),max_cap,interval,sp,k,refC,coeff); 

                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand(i)/k];

                %update GH
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand(i)/23;%u_demand/max_cap * nomcells;% 0.2: 
                end                
                down=merge(find(avail_pack<=bat_pack(j).thres_g*max_cap),...
                    find(avail_volt<=cutoff_voltage)); %| op
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*max_cap),...
                    find(avail_volt>cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < shutdown
                    listofsch=listofsch(find(listofsch ~= j));
                    otime_log(j)=i;
                end;
                
            case 3 %sequentail
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                %termination condition
                %At the low voltage level, volt is a determinator to move
                %We only move elements of high soc and volt into GH from GL
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        listofsch=listofsch(find(listofsch ~= j));
                        otime_log(j)=i;
                        continue;
                    end
                end
                avail_pack=bat_pack(j).bpack(bat_pack(j).GH);
                avail_volt=bat_pack(j).bvolt(bat_pack(j).GH);
                prior2load=bat_pack(j).bpack;
                k=1;
                bat_pack(j).k=[bat_pack(j).k k];
                sp=1;
                % distribute workloads
                [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
                avail_volt,load_demand(i),max_cap,interval,sp,k,refC,coeff); 
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand(i)/k];

                %update GH
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand(i)/23;%u_demand/max_cap * nomcells;% 0.2: 
                end                
                down=merge(find(avail_pack<=bat_pack(j).thres_g*max_cap),...
                    find(avail_volt<=cutoff_voltage)); %| op
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*max_cap),...
                    find(avail_volt>cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < shutdown
                    listofsch=listofsch(find(listofsch ~= j));
                    otime_log(j)=i;
                end;

            case 4 %parallel
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        listofsch=listofsch(find(listofsch ~= j));
                        otime_log(j)=i;
                        continue;
                    end
                end
                avail_pack=bat_pack(j).bpack(bat_pack(j).GH);
                avail_volt=bat_pack(j).bvolt(bat_pack(j).GH);
                prior2load=bat_pack(j).bpack;
                k=length(avail_pack);
                bat_pack(j).k=[bat_pack(j).k k];
                sp=sorted_index(avail_pack);
                % distribute workloads
                [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
                avail_volt,load_demand(i),max_cap,interval,sp,k,refC,coeff); 
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand(i)/k];

                %update GH
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand(i)/23;%u_demand/max_cap * nomcells;% 0.2: 
                end                
                down=merge(find(avail_pack<=bat_pack(j).thres_g*max_cap),...
                    find(avail_volt<=cutoff_voltage)); %| op
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*max_cap),...
                    find(avail_volt>cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < shutdown
                    listofsch=listofsch(find(listofsch ~= j));
                    otime_log(j)=i;
                end;

        end
    end
end %for

figure
for j=1:numofsch
    subplot(2,2,j);plot(bat_pack(j).soc_log,':','MarkerSize',10,'LineWidth',2); title(name(j,:));
    xlabel('time step','FontSize',12); ylabel('SoC level','FontSize',12);
end

figure
for j=1:numofsch
    subplot(2,2,j);plot(bat_pack(j).volt_log,'-','MarkerSize',10,'LineWidth',2); title(name(j,:));
    xlabel('time step','FontSize',12); ylabel('Voltage','FontSize',12);
end

figure
for j=1:numofsch
%for k=1:nomcells
subplot(2,2,j);plot(bat_pack(j).ldiff_log,'x','MarkerSize',4,'LineWidth',1);title(name(j,:));
%end
end
%xlabel('time step','FontSize',12); ylabel('Coulomb discharged','FontSize',12);

figure %ldiff.fig
%for j=1:numofsch
ln=length(bat_pack(1).load_log);
%subplot(2,2,j);plot([1:ln],load_demand(1:ln),'-',[1:ln],bat_pack(j).load_log,'--','MarkerSize',10,'LineWidth',2); 
plot([1:ln],load_demand(1:ln),'-',[1:length(bat_pack(1).load_log)],bat_pack(1).load_log,'-o',...
    [1:length(bat_pack(2).load_log)],bat_pack(2).load_log,'-+',...
    [1:length(bat_pack(3).load_log)],bat_pack(3).load_log,'-d',...
    [1:length(bat_pack(4).load_log)],bat_pack(4).load_log,'-x','MarkerSize',4,'LineWidth',1); 
%title(name(j,:));
legend('Load demand','kRR','1RR','1+1RR','nRR');
xlabel('time step (n\times \Delta t)','FontSize',12);ylabel('Load (Coulombs)','FontSize',12);
%end

figure %vdiff.fig
%for j=1:numofsch
%subplot(2,2,j);plot(bat_pack(j).vdiff_log,'-','MarkerSize',10,'LineWidth',2); title(name(j,:));
plot([1:numel(bat_pack(1).vdiff_log)],bat_pack(1).vdiff_log,'-o',...
    [1:numel(bat_pack(2).vdiff_log)],bat_pack(2).vdiff_log,'-+',...
    [1:numel(bat_pack(3).vdiff_log)],bat_pack(3).vdiff_log,'-d',...
    [1:numel(bat_pack(4).vdiff_log)],bat_pack(4).vdiff_log,'-x','MarkerSize',4,'LineWidth',1);
legend('kRR','1RR','1+1RR','nRR');
xlabel('time step','FontSize',12);ylabel('Difference in Voltage ((V_{max}-V_{min})/V_{max} \times 100 %)','FontSize',12);
%vdiff_log;
%end

figure
out=[];
for j=1:numofsch
    out=[out; (max_cap-bat_pack(j).bpack)/max_cap/nomcells];
end
bar(out, 'stack');ylabel('Battery Untilization','FontSize',12);xlabel('Scheduling mechanisms','FontSize',12);

deg=[];
%ind=find(otime_log==min(otime_log));
for k=1:numel(otime_log)
    for j=1:numel(otime_log)
        deg(k,j)=otime_log(k)/otime_log(j);
    end
end
grid on
figure %opcomp.fig
bar(deg);ylabel('Operation-time gain','FontSize',12);xlabel('Scheduling mechanisms','FontSize',12);
legend('Comparison with kRR','comparison with 1RR','comparison with 1+1RR','comparison with nRR');
grid off
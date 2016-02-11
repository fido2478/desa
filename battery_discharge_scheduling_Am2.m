function bat_pack=battery_discharge_scheduling_Am2(i,interval,bat_pack,listofsch,...
    coeff,coeff_re,dyn_thres,load_demand)
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

%log in each interval of 100ms
    for j=listofsch
        bat_pack(j).soc_log=[bat_pack(j).soc_log; bat_pack(j).bpack/bat_pack(j).max_cap];
        bat_pack(j).volt_log=[bat_pack(j).volt_log; bat_pack(j).bvolt];
    end    
    decr=0.5;
    for j=listofsch
        switch j
            case 1%kRR
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>bat_pack(j).cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        bat_pack(j).disconnect=0;
                        %listofsch=listofsch(find(listofsch ~= j));
                        bat_pack(j).otime_log= i;
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
                    k=ceil(num_cells * load_demand / max_demand);
                else % adjust load_demand to fit max recovery
                    %vector of second order of derivative
                    ok=ceil(load_demand./(bat_pack(j).maxreC*23));
                    if ok(1)> num_cells
                        %k=ok(2);
                        %k=ok(1)-ok(2);
                        k=num_cells;
                    elseif ok(1)<1
                        k=1;
                    elseif (load_demand/(23*ok(1)) < bat_pack(j).maxreC(1)) & (ok(1)>2)
                        k=ok(1)-1;
                    else
                        k=ok(1);
                    end
                    if k > num_cells
                        k=num_cells;
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
                avail_volt,load_demand,bat_pack(j).max_cap,interval,sp,k,bat_pack(j).refC,coeff); 
                indx=find(bat_pack(j).bvolt<0);
                
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);
                    
                % update SoC and Voltage               
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack; %coulomb
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand/k]; %per cell
                
                %update thres_g and shutdown
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand/23;%u_demand/max_cap * nomcells;% 0.2: 
                end
                %update GH
                down=merge(find(avail_pack<=bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt<=bat_pack(j).cutoff_voltage)); %| or operation
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt>bat_pack(j).cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < bat_pack(j).shutdown
                    bat_pack(j).disconnect=0;
                    %listofsch=listofsch(find(listofsch ~= j));
                    bat_pack(j).otime_log=i;
                end;

            case 2 %rr
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>bat_pack(j).cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        bat_pack(j).disconnect=0;
                        %listofsch=listofsch(find(listofsch ~= j));
                        bat_pack(j).otime_log=i;
                        continue;
                    end
                end
                avail_pack=bat_pack(j).bpack(bat_pack(j).GH);
                avail_volt=bat_pack(j).bvolt(bat_pack(j).GH);
                prior2load=bat_pack(j).bpack;
                k=1;
                bat_pack(j).k=[bat_pack(j).k k];
                sp=sorted_index(avail_pack); % this differs from 1+1RR
                % distribute workloads
                [avail_pack, avail_volt]=dischargingKcellsOld(avail_pack,...
                avail_volt,load_demand,bat_pack(j).max_cap,interval,sp,k,bat_pack(j).refC,coeff); 

                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand/k];

                %update thres_g and shutdown
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand/23;%u_demand/max_cap * nomcells;% 0.2: 
                end
                %update GH
                down=merge(find(avail_pack<=bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt<=bat_pack(j).cutoff_voltage)); %| op
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt>bat_pack(j).cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < bat_pack(j).shutdown
                    bat_pack(j).disconnect=0;
                    %listofsch=listofsch(find(listofsch ~= j));
                    bat_pack(j).otime_log= i;
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
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>bat_pack(j).cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        bat_pack(j).disconnect=0;
                        %listofsch=listofsch(find(listofsch ~= j));
                        bat_pack(j).otime_log= i;
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
                avail_volt,load_demand,bat_pack(j).max_cap,interval,sp,k,bat_pack(j).refC,coeff); 
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand/k];

                %update thres_g and shutdown
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand/23;%u_demand/max_cap * nomcells;% 0.2: 
                end
                %update GH
                down=merge(find(avail_pack<=bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt<=bat_pack(j).cutoff_voltage)); %| op
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt>bat_pack(j).cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < bat_pack(j).shutdown
                    bat_pack(j).disconnect=0;
                    %listofsch=listofsch(find(listofsch ~= j));
                    bat_pack(j).otime_log= i;
                end;

            case 4 %parallel
                % Recovery effect check
                % Increase volt if condition is met
                [bat_pack(j).bvolt bat_pack(j).ldisch]=re_effect_check(bat_pack(j),coeff_re);
                if isempty(bat_pack(j).GH)
                    bat_pack(j).thres_g=bat_pack(j).thres_g*decr;
                    [com dis]=leastcom(find(bat_pack(j).bpack(bat_pack(j).GL)>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(bat_pack(j).bvolt(bat_pack(j).GL)>bat_pack(j).cutoff_voltage));
                    bat_pack(j).GH=bat_pack(j).GL(com);
                    bat_pack(j).GL=bat_pack(j).GL(dis);
                    if isempty(bat_pack(j).GH)
                        bat_pack(j).disconnect=0;
                        %listofsch=listofsch(find(listofsch ~= j));
                        bat_pack(j).otime_log= i;
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
                avail_volt,load_demand,bat_pack(j).max_cap,interval,sp,k,bat_pack(j).refC,coeff); 
                % Recovery count
                [bat_pack(j).RE, bat_pack(j).ldisch]=recovery_count(bat_pack(j), avail_pack, interval);

                % update SoC and Voltage
                bat_pack(j).bpack(bat_pack(j).GH)=avail_pack;
                bat_pack(j).bvolt(bat_pack(j).GH)=avail_volt;
                %log
                bat_pack(j).ldiff_log=[bat_pack(j).ldiff_log; prior2load-bat_pack(j).bpack];
                bat_pack(j).vdiff_log=[bat_pack(j).vdiff_log; ...
                    (max(avail_volt)-min(avail_volt))/max(avail_volt)*100];
                bat_pack(j).load_log=[bat_pack(j).load_log; load_demand/k];

                %update thres_g and shutdown
                if dyn_thres > 0
                    %at 4C, voltage steeply drops (percentage) 
                    bat_pack(j).thres_g=bat_pack(j).turn*load_demand/23;%u_demand/max_cap * nomcells;% 0.2: 
                end
                %update GH
                down=merge(find(avail_pack<=bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt<=bat_pack(j).cutoff_voltage)); %| or operatior
                if ~isempty(down)
                    bat_pack(j).GL=[bat_pack(j).GL bat_pack(j).GH(down)];
                    [com, dis]=leastcom(find(avail_pack>bat_pack(j).thres_g*bat_pack(j).max_cap),...
                    find(avail_volt>bat_pack(j).cutoff_voltage)); %& and disjoint
                    bat_pack(j).GH=bat_pack(j).GH(com);
                end
                if 0 & bat_pack(j).thres_g < bat_pack(j).shutdown
                    bat_pack(j).disconnect=0;
                    %listofsch=listofsch(find(listofsch ~= j));
                    bat_pack(j).otime_log= i;
                end;

        end
    end
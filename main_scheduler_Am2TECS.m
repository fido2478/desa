function main_scheduler_Am2TECS
clear all
%close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% battery characteristics
% returns coeff of RT1;RT2;RT10 based on Coulomb
coeff_re=calcul_coeff_re(1,100); %[p1; p2; p10] coulomb
% find max recovery efficiency
p=coeff_re(1,:); %coulomb
dep=polyder(p);
ddep=polyder(dep);
x=[0:0.00002:4];
ind=find(polyval(dep,x)<=0.000002 & polyval(dep,x)>=-0.000002);
maxreC=[];
for l=1:length(ind)
    if polyval(ddep,x(ind(l))) < 0 & x(ind(l)) > 0.5
        maxreC=[maxreC x(ind(l))]; %recovery rate
    end
end
%maxreC=[0.8261 2.0435];
%generate reference
refC=Vref('dat/dualfoil5C23.out'); %coulomb
[coeff]=calcul_coeff_volt_new(1,100,refC); %nothing to do with coulomb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters associated with scheduling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
interval=60;%every x second(s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin: Profiling Load Demand
% Input: lb, ub, runtime, ptype
% Output: variable/constant loads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init: number of cells, nominal coulombs of each
max_cap=3602.7; %coulombs 3602.7
max_volt=4.06267;
ind=find(refC.sX<=0.0005);
cutoff_voltage=polyval(refC.p,refC.tX(ind(1))); % this is very important
%cutoff_voltage=2.50000;
nomcells=700; % # of battery cells also affect the operation-time try with 750
devolt=600;
ns=ceil(devolt/max_volt);
np=floor(nomcells/ns);
yes_config=1;
w_dc=1;
dist_type='exp'; %either uni or exp
ratio=0.8;
delta_r=0.005;
sw_oh=0.005;
log_oh_conf=0;
log_oh_rot=0;
log_oh_dc0=0;
log_oh_dc1=0;

l_demand=np*5; %A/m2 (= 23A/m2)
u_demand=np*23;   %A/m2
max_demand=u_demand;
runtimeratio=1;
max_runtime=floor((max_cap*runtimeratio)*60/interval); %minute
load_demand=[];

util=[];%utilization log
kkk=[];%tracking k
% rand, const1, const2, const3
dis_type=[l_demand:u_demand];
dis_type='rand';

ave_deg=[];
for ai=1:1

    % Coulomb
    load_demand=generate_loads_Am2(dis_type,l_demand,u_demand,max_runtime,...
        maxreC,nomcells,interval);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Battery pack
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    turn=0.05;% at 1C (23A/m2) at this point voltage steeply drops
    %check the following
    thres_g=turn*u_demand/23;%at 4C, voltage steeply drops percentage %u_demand/max_cap * nomcells;% 0.2: 
    shutdown=thres_g*turn*8; 
    dyn_thres=1; %if 1 then thres_g and shutdown vary with discharge rate

    bat_pack=[]; %battery pack
    controller=[];
    %debug
    log_conf=[];log_volt=[];log_pow_wodc=[];log_eff=[];
    
    batpack(1:nomcells)=max_cap;
    batvolt(1:nomcells)=max_volt;
    sdev(1:4,1:nomcells)=0;
    PB(1:nomcells)=0; %permanent bypass
    TB(1:nomcells)=0; %temporary bypass
    %batvolt(1:nomcells)=[max_volt max_volt max_volt  max_volt*0.90];
    %batpack(1:nomcells)=[max_cap max_cap max_cap  max_cap*0.90];
    name=['n'];%['kRR';'1RR';'Seq';'nRR']
    init(1:nomcells)=0;
    for i=1:length(name)
        bat_pack=[bat_pack struct('id',name(i,:),'bpack',batpack,...
            'bvolt',batvolt,'RE',init,'ldisch',init,'GH',find(batpack>thres_g*max_cap),...
            'GL',find(batpack<=thres_g*max_cap),'k',[],'thres_g',thres_g,'turn',turn,'status',0,...
            'max_cap',max_cap,'max_volt',max_volt,'cutoff_voltage',cutoff_voltage,...
            'refC',refC,'maxreC',maxreC,'shutdown',shutdown,'disconnect',i,...
            'soc_log',[],'volt_log',[],'ldiff_log',[],'vdiff_log',[],'load_log',[],'otime_log',0)];
        controller=[controller struct('sdev',sdev,'PB',PB,'TB',TB,'devolt',devolt,'numcells',nomcells,...
            'np',np,'ns',ns,'npgrp',[])];
    end
    %configuration
    controller=config(controller,bat_pack);
    listofsch=[1 2 3 4];
    %online procedure
    for i=1:length(load_demand) %second
        listofsch=[];
        for n=1:length(bat_pack)
            if bat_pack(n).disconnect~=0
                listofsch=[listofsch n];
            end
        end
        if isempty(listofsch)
            break;
        end     
            
            %discharge
        bat_pack=simdischarge(bat_pack,coeff,load_demand(i),controller.npgrp,interval);
        
        %discharge scheduling
        %bat_pack=battery_discharge_scheduling_Am2...
        %    (i,interval,bat_pack,listofsch,coeff,coeff_re,dyn_thres,load_demand(i));

        
        %reconfig
        %average available volt
        rwcl=size(controller.npgrp);
        svolt=0;
        for p=1:rwcl(1)
            svolt=svolt+sum(bat_pack.bvolt(controller.npgrp(p,:)));
        end
        svolt=svolt/rwcl(1);
        log_volt=[log_volt svolt];
        log_conf=[log_conf [controller.ns; controller.np]];
        log_pow_wodc=[log_pow_wodc load_demand(i)*svolt/23];
        ns=ceil(controller.devolt/(svolt/rwcl(2)));
        eff0=fdcdc(svolt, controller.devolt,0,ratio,dist_type);
        eff1=fdcdc(ns*svolt/rwcl(2),controller.devolt,sw_oh,ratio,dist_type);
        log_eff=[log_eff [eff0; eff1]];
        % if we have very efficient fdcdc, then reconfiguration is not very
        % effective. Rather, not using reconfig may be better.
        if  (eff0 <= eff1)& yes_config % need reconfig
            controller.ns=ns;
            controller.np=floor((controller.numcells-length(find(controller.PB==1)))/controller.ns);
            controller=config(controller,bat_pack);  
            log_oh_conf=log_oh_conf + 1;
        elseif (1-min(bat_pack.bpack)/max(bat_pack.bpack))> delta_r
            controller=config(controller,bat_pack);
            log_oh_rot=log_oh_rot + 1;
        end % if 
        if yes_config
            if w_dc
                bat_pack=simdischarge(bat_pack,coeff,(1-eff1)*load_demand(i),controller.npgrp,interval);
                log_oh_dc1=log_oh_dc1+(1-eff1)*load_demand(i)/23*devolt*interval;
            end
        else
            bat_pack=simdischarge(bat_pack,coeff,(1-eff0)*load_demand(i),controller.npgrp,interval);
            log_oh_dc0=log_oh_dc0+(1-eff0)*load_demand(i)/23*devolt*interval;
        end
        ind=find(bat_pack.bvolt<cutoff_voltage);
        if ~isempty(ind)
            break;
        end
    end %for

end %ai=


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluation
% when yes_config=0 No config; otherwise yes 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx=[1:length(log_volt)];
figure %voltcomp.fig
plot(xx,log_volt,'MarkerSize',4,'LineWidth',2);
xlabel('Operation-time (min)','FontSize',14);ylabel('Converter input voltage (V)','FontSize',14);
figure
plot(log_conf(1,:),log_conf(2,:),'+','MarkerSize',4,'LineWidth',2);
xlabel('n_s','FontSize',14);ylabel('n_p','FontSize',14);
figure %load.fig
plot(xx,log_pow_wodc,'MarkerSize',4,'LineWidth',2);
xlabel('Operation-time (min)','FontSize',14);ylabel('Power (W)','FontSize',14);
figure
plot(xx,log_eff(2,:),'b-',xx,log_eff(1,:),'b--','MarkerSize',4,'LineWidth',2);
xlabel('Operation-time (min)','FontSize',14);ylabel('EFF_{DCDC}','FontSize',14);
legend('w/ self-config','w/o self-config');
figure; %ohexp.fig ohuni.fig arrexp.fig arruni.fig
bar([log_oh_conf log_oh_rot log_oh_dc0 log_oh_dc1]/(sum(log_pow_wodc)*interval));
figure;
range=[300:615];
switch (dist_type)
    case 'uni'
        dist=unifcdf(range,ratio*devolt,devolt);
    case 'exp'
        dist=expcdf(range,300);
end
plot(range,dist,'LineWidth',2);
xlabel('Converter input voltage (V)','FontSize',14);ylabel('EFF_{DCDC}','FontSize',14);

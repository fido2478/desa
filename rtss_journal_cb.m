% rtss journal version
% cell balancing
function rtss_journal_cb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% battery characteristics
%generate reference
refC=Vref('dat/dualfoil5C23.out'); %coulomb
[coeff]=calcul_coeff_volt_new(1,100,refC); %nothing to do with coulomb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End: Offline procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_cap=3602.7; %coulombs 3602.7
max_volt=4.306267;
ind=find(refC.sX<=0.0005);
%cutoff_voltage=polyval(refC.p,refC.tX(ind(1))); % this is very important
cutoff_voltage=2;

%bottom-up
cell_cap=[3602.7, 3602.7, 3602.7, 3602.7, 3602.7]; %coulombs
cell_voltage=[4.06267, 4.06267, 4.06267, 4.06267, 4.06267]; %voltage
%vol_rate=[0.9, 0.9, 0.5, 0.9, 0.9]; %anomaly
%vol_rate=[1, 1, 1, 1, 1];
cons_c=[1.0101, 1.0526, 1.0101, 1.0000, 1.0204]; %individual discharge
%dis_rate=[1, 1, 1, 1, 1]; 
dw= sum(cell_voltage)*0.5;%power(C*V)/t 
delta_c=0.99;
%overhead evaluation
timelog_bu=[];caplog_bu=[];vollog_bu=[];dislog_bu=[];dislog_gn=[];
timelog_td=[];caplog_td=[];vollog_td=[];dislog_td=[];
timelog_md=[];caplog_md=[];vollog_md=[];dislog_md=[];
el_dis_td=[];el_dis_bu=[];el_dis_md=[];
sw_onoff=0;
sch_on_bu=0;

while (min(cell_cap)>0 & min(cell_voltage)>cutoff_voltage)
    valid_bits=[1,1,1,1,1];
    temp=[0,0,0,0,0];
    if delta_c>min(cell_cap)/max(cell_cap)
        temp_cap=cell_cap-min(cell_cap);
        valid_bits(find(temp_cap<0.00001))=0;
        while (max(valid_bits)>0)
            indv=find(valid_bits==1); %index of valid
            ind=find(min(cell_cap(indv))==cell_cap); % index from the whole
            eltime=sum(cell_voltage(indv))/dw *temp_cap(ind(1));            
            temp(indv)=temp(indv)+eltime;
            %cell_cap(indv)=cell_cap(indv)-temp_cap(ind(1))*cons_c(indv);
            discharge=dw/sum(cell_voltage(indv));
            for i=1:length(indv)
                [cell_voltage(indv(i)),cell_cap(indv(i))]=VCgraph(cell_voltage(indv(i)),...
                    cell_cap(indv(i)),refC,coeff,cons_c(indv(i))*discharge,eltime,max_cap);   
            end
            valid_bits(ind)=0;
            temp_cap(indv)=temp_cap(indv)-temp_cap(ind(1));
            valid_bits(find(temp_cap<0.00001))=0;
            dislog_bu=[dislog_bu cons_c(ind)*discharge];
            for k=1:length(ind)
                el_dis_bu=[el_dis_bu; [eltime cons_c(ind(k))*discharge]];
            end
        end
        sch_on_bu=sch_on_bu+1;
        timelog_bu=[timelog_bu;temp];
        vollog_bu=[vollog_bu;cell_voltage];
        caplog_bu=[caplog_bu; cell_cap];
    else
        discharge=dw/sum(cell_voltage);
        for j=1:length(cell_voltage)
            [cell_voltage(j),cell_cap(j)]=VCgraph(cell_voltage(j),...
                cell_cap(j),refC,coeff,cons_c(j)*discharge,30,max_cap); 
        end
        expd(1:30*4)=mean(cons_c)*discharge;
        dislog_bu=[dislog_bu expd]; %temporary
        vollog_bu=[vollog_bu;cell_voltage];
        caplog_bu=[caplog_bu; cell_cap];
        %cell_cap=cell_cap-cons_c*dw/sum(cell_voltage);
        %temp(1:5)=1;
    end
    %cell_voltage=cell_voltage.*vol_rate;
end


%top-down
cell_cap=[3602.7, 3602.7, 3602.7, 3602.7, 3602.7]; %coulombs
cell_voltage=[4.06267, 4.06267, 4.06267, 4.06267, 4.06267]; %voltage
dw= sum(cell_voltage)*0.5;%power(C*V)/t 
sch_on_td=0;

while (min(cell_cap)>0 & min(cell_voltage)>cutoff_voltage)
    valid_bits=[1,1,1,1,1];
    temp=[0,0,0,0,0];
    if delta_c>min(cell_cap)/max(cell_cap)
        temp_cap=cell_cap-min(cell_cap);
        valid_bits(find(temp_cap<0.00001))=0;
        while (max(valid_bits)>0)
            indv=find(valid_bits==1); %index of valid
            ind=find(max(cell_cap(indv))==cell_cap); % index from the whole
            eltime=sum(cell_voltage(ind(1)))/dw *temp_cap(ind(1));
            temp(ind(1))=temp(ind(1))+eltime;
            discharge=dw/sum(cell_voltage(ind(1)));
            [cell_voltage(ind(1)),cell_cap(ind(1))]=VCgraph(cell_voltage(ind(1)),...
            	cell_cap(ind(1)),refC,coeff,cons_c(ind(1))*discharge,eltime,max_cap); 
            %cell_cap(ind(1))=cell_cap(ind(1))-temp_cap(ind(1))*cons_c(ind(1));
            valid_bits(ind(1))=0;
            temp_cap(ind(1))=0;
            valid_bits(find(temp_cap<0.00001))=0;
            dislog_td=[dislog_td cons_c(ind(1))*discharge];
            el_dis_td=[el_dis_td; [eltime cons_c(ind(1))*discharge]];
        end
        sch_on_td=sch_on_td+1;
        timelog_td=[timelog_td;temp];
        vollog_td=[vollog_td;cell_voltage];
        caplog_td=[caplog_td; cell_cap];
    else
        discharge=dw/sum(cell_voltage);
        for j=1:length(cell_voltage)
            [cell_voltage(j),cell_cap(j)]=VCgraph(cell_voltage(j),...
                cell_cap(j),refC,coeff,cons_c(j)*discharge,30,max_cap); 
        end
        expd(1:30*4)=mean(cons_c)*discharge;
        dislog_td=[dislog_td expd]; %temporary
        vollog_td=[vollog_td;cell_voltage];
        caplog_td=[caplog_td; cell_cap];
        %cell_cap=cell_cap-cons_c*dw/sum(cell_voltage);
        %temp(1:5)=1;
    end
    %cell_voltage=cell_voltage.*vol_rate;
end


%median
cell_cap=[3602.7, 3602.7, 3602.7, 3602.7, 3602.7]; %coulombs
cell_voltage=[4.06267, 4.06267, 4.06267, 4.06267, 4.06267]; %voltage
dw= sum(cell_voltage)*0.5;%power(C*V)/t 
sch_on_md=0;

while (min(cell_cap)>0 & min(cell_voltage)>cutoff_voltage)
    valid_bits=[1,1,1,1,1];
    temp=[0,0,0,0,0];
    temp_cap=cell_cap-min(cell_cap);
    valid_bits(find(temp_cap<0.001))=0;
    indv=find(valid_bits==1); %index of valid
    if (delta_c>min(cell_cap)/max(cell_cap)) %& (length(indv) > mean(valid_bits))
    %if length(indv) <= mean(valid_bits) then skip
        md=median(temp_cap(indv));
        eltime=sum(cell_voltage(indv))/dw * md;
        temp(indv)=temp(indv)+eltime;
        discharge=dw/sum(cell_voltage(indv));
        dislog_md=[dislog_md cons_c(indv)*discharge];
        for kk=1:length(indv)
        	[cell_voltage(indv(kk)),cell_cap(indv(kk))]=VCgraph(cell_voltage(indv(kk)),...
            	cell_cap(indv(kk)),refC,coeff,cons_c(indv(kk))*discharge,eltime,max_cap);   
        	el_dis_md=[el_dis_md; [eltime cons_c(indv(kk))*discharge]];
        end
        sch_on_md=sch_on_md+1;
        timelog_md=[timelog_md;temp];
        vollog_md=[vollog_md;cell_voltage];
        caplog_md=[caplog_md; cell_cap];
    else
        discharge=dw/sum(cell_voltage);
        for j=1:length(cell_voltage)
            [cell_voltage(j),cell_cap(j)]=VCgraph(cell_voltage(j),...
                cell_cap(j),refC,coeff,cons_c(j)*discharge,30,max_cap); 
        end
        expd(1:30*4)=mean(cons_c)*discharge;
        dislog_md=[dislog_md expd]; %temporary
        vollog_md=[vollog_md;cell_voltage];
        caplog_md=[caplog_md; cell_cap];
        %cell_cap=cell_cap-cons_c*dw/sum(cell_voltage);
        %temp(1:5)=1;
    end
    %cell_voltage=cell_voltage.*vol_rate;
end

%cb-bu.eps
figure
bar(timelog_bu); 
legend('cell 1','cell 2','cell 3','cell 4','cell 5');
xlabel('Cell-balancing instance (-th)');
ylabel('The time period (sec)');
%figure
%bar(timelog_bu(length(timelog_bu)-10:length(timelog_bu),:));
%figure
%plot(caplog_bu);
%figure
%plot(vollog_bu);

%cb-td.eps
figure
bar(timelog_td,'stack');
legend('cell 1','cell 2','cell 3','cell 4','cell 5');
xlabel('Cell-balancing instance (-th)');
ylabel('The time period (sec)');
%figure
%bar(timelog_td(length(timelog_td)-10:length(timelog_td),:), 'stack');
%figure
%plot(caplog_td);
%figure
%plot(vollog_td);

%cb-md.eps
figure
bar(timelog_md); %very aggressive
legend('cell 1','cell 2','cell 3','cell 4','cell 5');
xlabel('Cell-balancing instance (-th)');
ylabel('The time period (sec)');
%figure
%bar(timelog_md(length(timelog_md)-10:length(timelog_md),:));
%figure
%plot(caplog_md); %irregular
%figure
%plot(vollog_md); %irregular

%cb-overhead.eps
figure
bar([sch_on_td, sch_on_bu, sch_on_md]);
xlabel('Policies');ylabel('Overhead (#)');


figure
plot(el_dis_bu(:,1),el_dis_bu(:,2),'x',el_dis_td(:,1),el_dis_td(:,2),'+',...
    el_dis_md(:,1),el_dis_md(:,2),'.','MarkerSize',10);
legend('BU','TD','MD','FontSize',14);
xlabel('elapsed time (sec)'); ylabel('discharge (coulomb)');
min(el_dis_td(:,2))
max(el_dis_td(:,2))
median(el_dis_td(:,1))
median(el_dis_bu(find(el_dis_bu(:,2)>2), 1))
var(el_dis_md(find(el_dis_md(:,2)<2), 2))

lb=min([el_dis_bu(:,2)' el_dis_td(:,2)' el_dis_md(:,2)']);
ub=max([el_dis_bu(:,2)' el_dis_td(:,2)' el_dis_md(:,2)'])
figure; hist(el_dis_td(:,2),lb:0.01:ub);xlabel('discharge by TD (coulombs)');ylabel('frequency');
figure; hist(el_dis_bu(:,2),lb:0.01:ub);xlabel('discharge by BU (coulombs)');ylabel('frequency');
figure; hist(el_dis_md(:,2),lb:0.01:ub);xlabel('discharge by MD (coulombs)');ylabel('frequency');

figure
x=[4310:4330]; %should be multiplied by 0.5 sec in the label
plot(x, dislog_bu(x), 'x:', x, dislog_td(x),'+-.',x, dislog_md(x),'.-.','MarkerSize',8,'LineWidth',1);
legend('BU','TD','MD','FontSize',14);
xlabel('Snap shot (Time domain)'); ylabel('Discharge (Coulombs)');

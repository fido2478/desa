function analyze_data(bat_pack,load_demand)
figure
for k=1:length(bat_pack)
    subplot(2,2,k);plot(bat_pack(k).soc_log,':','MarkerSize',10,'LineWidth',2); title(bat_pack(k).id);
    xlabel('time step','FontSize',12); ylabel('SoC level','FontSize',12);
end

figure
for k=1:length(bat_pack)
    subplot(2,2,k);plot(bat_pack(k).volt_log,'-','MarkerSize',10,'LineWidth',2); title(bat_pack(k).id);
    xlabel('time step','FontSize',12); ylabel('Voltage','FontSize',12);
end

figure %loadperc.fig
for k=1:length(bat_pack)
%for k=1:nomcells
subplot(2,2,k);plot(bat_pack(k).ldiff_log/23,'x','MarkerSize',4,'LineWidth',1);title(bat_pack(k).id);
%end
end
%xlabel('time step','FontSize',12); ylabel('Coulomb discharged','FontSize',12);

figure %profile1.fig
%for j=1:numofsch
ln=length(bat_pack(1).load_log);
%subplot(2,2,j);plot([1:ln],load_demand(1:ln),'-',[1:ln],bat_pack(j).load_log,'--','MarkerSize',10,'LineWidth',2); 
plot(load_demand(1:ln)/23,'-','MarkerSize',4,'LineWidth',1); 
%title(name(j,:));
%legend('Load demand','kRR','1RR','1+1RR','nRR');
xlabel('time step (n\times  \Delta t)','FontSize',12);ylabel('Load (Coulombs)','FontSize',12);
%end

figure %vdiff.fig
%for j=1:numofsch
%subplot(2,2,j);plot(bat_pack(j).vdiff_log,'-','MarkerSize',10,'LineWidth',2); title(name(j,:));
plot([1:numel(bat_pack(1).vdiff_log)],bat_pack(1).vdiff_log,'-o',...
    [1:numel(bat_pack(2).vdiff_log)],bat_pack(2).vdiff_log,'-+',...
    [1:numel(bat_pack(4).vdiff_log)],bat_pack(4).vdiff_log,'-x','MarkerSize',4,'LineWidth',1);
legend('kRR','1RR','nRR');
xlabel('time step','FontSize',12);ylabel('Difference in Voltage ((V_{max}-V_{min})/V_{max} \times 100 %)','FontSize',12);
%vdiff_log;
%end

figure
out=[];
for k=1:length(bat_pack)
    out=[out; (bat_pack(k).max_cap-bat_pack(k).bpack)/bat_pack(k).max_cap/length(bat_pack(k).bpack)];
end
bar(out, 'stack');ylabel('Battery Untilization','FontSize',12);xlabel('Scheduling mechanisms','FontSize',12);

deg=[];
for k=1:length(bat_pack)
    for m=1:length(bat_pack)
        deg(k,m)=bat_pack(k).otime_log/bat_pack(m).otime_log;
    end
end
grid on
figure %opcomp.fig
bar(deg);ylabel('Operation-time gain','FontSize',12);xlabel('Scheduling mechanisms','FontSize',12);
legend('Comparison with kRR','comparison with 1RR','comparison with 1+1RR','comparison with nRR');
grid off
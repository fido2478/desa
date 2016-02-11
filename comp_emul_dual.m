function comp_emul_dual(dis_type,load_demand,volt_log)
switch dis_type
    case 'comp1'    
        filename=['dat/dualfoil5C' num2str(23) '.out'];
    case 'comp2'
        filename=['dat/dualfoil5Ctst.out'];
end
dat=readfile(filename); %C10
time5C=dat(1,:); 
dischar=dat(6,1);
vol5C=dat(4,:);
ln=[0:length(load_demand)-1];
figure %dualmod-a.fig for comp1 and dualmod-b.fig for comp2
plot(time5C,vol5C,'-',[0:length(load_demand)-1],volt_log,'--','MarkerSize',10,'LineWidth',2);
xlabel('Time (min)'); ylabel('Voltage (V)');legend('Dualfoil','Model');
vv=vol5C(1);
ux=length(ln)-3;
vl=volt_log(1:ux);
for i=2:ux
    k=find(time5C<=(i-1+0.02));
    vv=[vv vol5C(k(length(k)))];
end
chi=((vv-vl).*(vv-vl))./(vv+vl);
figure
plot(chi,'LineWidth',2);
xlabel('Samples','FontSize',14);
ylabel('\chi^2 distance','FontSize',14);
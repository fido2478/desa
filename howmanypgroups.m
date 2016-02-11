function howmanypgroups
alpha=[0.8261 2.0435]; %recovery efficiency
v=[3.5; 4.06267]; %output voltage
hp=35; %horsepower
w=746; %watts per hp
m=[100:300];

figure %howmany.fig
hold on

k=0;
n1=[];n2=[];
for i=m
    n1=[n1 (w*hp)./(alpha(1) * i * v *(1+k))];
    n2=[n2 (w*hp)./(alpha(2) * i * v *(1+k))];
end

M1=mean(n1);
U1=n1(1,:)-M1;
L1=M1-n1(2,:);
errorbar(m,M1,L1,U1,'k');
text(m(1),M1(1),['q=' num2str(k) ', \nu=' num2str(alpha(1), '%1.4f') 'C'],'FontSize',14);

M2=mean(n2);
U2=n2(1,:)-M2;
L2=M2-n2(2,:);
errorbar(m,M2,L2,U2,'k');
text(m(1),M2(1),['q=' num2str(k) ', \nu=' num2str(alpha(2), '%1.4f') 'C'],'FontSize',14);

if 0
k=0.5;
n3=[];n4=[];
for i=m
    n3=[n3 (w*hp)./(alpha(1) * i * v *(1+k))];
    n4=[n4 (w*hp)./(alpha(2) * i * v *(1+k))];
end

M3=mean(n3);
U3=n3(1,:)-M3;
L3=M3-n3(2,:);
errorbar(m,M3,L3,U3,'k');
text(m(1),M3(1),['q=' num2str(k, '%1.1f') ', \nu=' num2str(alpha(1), '%1.4f') 'C'],'FontSize',14);

M4=mean(n4);
U4=n4(1,:)-M4;
L4=M4-n4(2,:);
errorbar(m,M4,L4,U4,'k');
text(m(1),M4(1),['q=' num2str(k, '%1.1f') ', \nu=' num2str(alpha(2), '%1.4f') 'C'],'FontSize',14);
end %if 0

%plot(m,n1,m,n2,'MarkerSize',4,'LineWidth',1);
%legend('k=0, \nu = 0.8261','k=0, \nu = 2.0435',...
%    'k=0.5, \nu = 0.8261','k=0.5, \nu = 2.0435');
xlabel('# of series-connected battery cells (=m)','FontSize',14);
ylabel('# of parallel groups (=n)','FontSize',14);
hold off

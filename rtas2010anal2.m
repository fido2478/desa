function rtas2010anal2

T=0.05;%[0.6:0.1:1];
lambdaa=3; alpha=2; Ca=1; N=10; M=7; Cf=0.5*Ca; n=20; m=18;x=N;

ya=power(1+T*lambdaa/alpha,-alpha);

lambdaB=1/10;lambdaS=1/30;
ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05;r=N;s=n;

C11=[];C12=[];C21=[];C22=[];C31=[];C32=[];C41=[];C42=[];
C51=[];C52=[];C61=[];C62=[];C71=[];C72=[];C81=[];C82=[];
max=5;
for m=n:-1:n-max
    C11=[C11;(n-m+1)/(lambdaB)]; 
        %(n-m+1)*(1/lambdaB+1./(lambdaS*ratio*[(1-q)*(1-p)*x/(s*r),...
        %(1-q)*(1-p)*x/s])-1./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/(s*r), (1-q)*(1-p)*x/s]))];
    C12=[C12; 1/(n*lambdaB)]; 
    C21=[C21; (n-m+1)./(lambdaB+lambdaS*ratio*[q*(1-p)*x/r, q*(1-p)*x])]; 
    C31=[C31; (n-m+1)./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/(s*r), (1-q)*(1-p)*x/s])]; 
    C41=[C41; (n-m+1)./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/r, (1-q)*(1-p)*x])]; 
end
C22=C11;
C32=C12;
C42=C22; 
C51=C11; C52=C11; 
C61=C21;C62=C12;
C71=C31;C72=C11;
C81=C41;C82=C12;

figure
plot([0:max],C11,'-k',[0:max],C12,'--b');

M2=mean(C21'); U2=C21(:,1)'-M2; L2=M2-C21(:,2)';
figure
hold on
errorbar([0:max],M2,L2,U2,'k'); plot([0:max],C22);
hold off

M3=mean(C31'); U3=C31(:,1)'-M3; L3=M3-C31(:,2)';
figure
hold on
errorbar([0:max],M3,L3,U3,'k'); plot([0:max],C32);
hold off

M4=mean(C41');U4=C41(:,1)'-M4;L4=M4-C41(:,2)';
figure
hold on
errorbar([0:max],M4,L4,U4,'k');plot([0:max],C42);
hold off

M6=mean(C61');U6=C61(:,1)'-M6;L6=M6-C61(:,2)';
figure
hold on
errorbar([0:max],M6,L6,U6,'k');plot([0:max],C62);
hold off

M7=mean(C71');U7=C71(:,1)'-M7;L7=M7-C71(:,2)';
figure
hold on
errorbar([0:max],M7,L7,U7,'k');plot([0:max],C72);
hold off

M8=mean(C81');U8=C81(:,1)'-M8;L8=M8-C81(:,2)';
figure
hold on
errorbar([0:max],M8,L8,U8,'k');plot([0:max],C82);
hold off

%%%%%%%%%%%%%%%%%
C11=[];C12=[];C21=[];C22=[];C31=[];C32=[];C41=[];C42=[];
C51=[];C52=[];C61=[];C62=[];C71=[];C72=[];C81=[];C82=[];
n=40;m=38
for x=1:N
    C11=[C11;(n-m+1)/(lambdaB)]; 
        %(n-m+1)*(1/lambdaB+1./(lambdaS*ratio*[(1-q)*(1-p)*x/(s*r),...
        %(1-q)*(1-p)*x/s])-1./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/(s*r), (1-q)*(1-p)*x/s]))];
    C12=[C12; 1/(n*lambdaB)]; 
    C21=[C21; (n-m+1)./(lambdaB+lambdaS*ratio*[q*(1-p)*x/r, q*(1-p)*x])]; 
    C31=[C31; (n-m+1)./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/(s*r), (1-q)*(1-p)*x/s])]; 
    C41=[C41; (n-m+1)./(lambdaB+lambdaS*ratio*[(1-q)*(1-p)*x/r, (1-q)*(1-p)*x])]; 
end
C22=C11;
C32=C12;
C42=C22; 
C51=C11; C52=C11; 
C61=C21;C62=C12;
C71=C31;C72=C11;
C81=C41;C82=C12;

figure
plot([1:N],C11,'-k',[1:N],C12,'--b');

M2=mean(C21');U2=C21(:,1)'-M2;L2=M2-C21(:,2)';
figure
hold on
errorbar([1:N],M2,L2,U2,'k');plot([1:N],C22);
hold off

M3=mean(C31');U3=C31(:,1)'-M3;L3=M3-C31(:,2)';
figure
hold on
errorbar([1:N],M3,L3,U3,'k');plot([1:N],C32);
hold off

M4=mean(C41');U4=C41(:,1)'-M4;L4=M4-C41(:,2)';
figure
hold on
errorbar([1:N],M4,L4,U4,'k');plot([1:N],C42);
hold off

M6=mean(C61');U6=C61(:,1)'-M6;L6=M6-C61(:,2)';
figure
hold on
errorbar([1:N],M6,L6,U6,'k');plot([1:N],C62);
hold off

M7=mean(C71');U7=C71(:,1)'-M7;L7=M7-C71(:,2)';
figure
hold on
errorbar([1:N],M7,L7,U7,'k');plot([1:N],C72);
hold off

M8=mean(C81');U8=C81(:,1)'-M8;L8=M8-C81(:,2)';
figure
hold on
errorbar([1:N],M8,L8,U8,'k');plot([1:N],C82);
hold off

%C01=(C11+M2'+M3'+M4'+C51+M6'+M7'+M8')/8;
meanL01=mean([C11 M2' M3' M4' C51 M6' M7' M8']);
meanL02=mean([C12 C22 C32 C42 C52 C62 C72 C82]);
figure %cpslifecomp.eps
bar([meanL01' meanL02']); 
max(meanL01'./meanL02') %40 times

warrantyT=1/lambdaB;
ind=find(warrantyT > meanL01);
ourcost=sum(warrantyT-meanL01(ind))*ya*Cf;
ind=find(warrantyT > meanL02);
legcost=sum(warrantyT-meanL02(ind))*ya*Cf;


if 0
minL02=min([C12 C22 C32 C42 C52 C62 C72 C82]);
meanL01=mean([C11 C21 C31 C41 C51 C61 C71 C81]);
maxL01=max([C11 C21 C31 C41 C51 C61 C71 C81]);
maxL02=max([C12 C22 C32 C42 C52 C62 C72 C82]);
L=[(meanL01-minL01)'; (meanL02-minL02)'];
U=[(maxL01-meanL01)'; (maxL02-meanL02)'];


minL012=[minL01;minL02];
meanL01=mean(mean([C11 C21 C31 C41 C51 C61 C71 C81]));
meanL02=mean(mean([C12 C22 C32 C42 C52 C62 C72 C82]));
meanL012=[meanL01;meanL02];
maxL01=max(max([C11 C21 C31 C41 C51 C61 C71 C81]));
maxL02=max(max([C12 C22 C32 C42 C52 C62 C72 C82]));
maxL012=[maxL01;maxL02];
meancost=(1-meanL012*lambdaB/(n-m+1))*Cf;
mincost=(1-minL012*lambdaB/(n-m+1))*Cf;
maxcost=(1-maxL012*lambdaB/(n-m+1))*Cf;
L=meancost-mincost;
U=maxcost-meancost;
figure
hold on
bar(meancost);
errorbar([1; 2],meancost,L,U,'xr');
hold off

Cs1=(1-mean(C01)*lambdaB/(n-m+1))*Cf;
C02=(C12+C22+C32+C42+C52+C62+C72+C82)/8;
L02=min([C12 C22 C32 C42 C52 C62 C72 C82]);
Cs2=(1-mean(C02)*lambdaB/(n-m+1))*Cf;

figure
bar([Cs1 Cs2; L01 L02]);
end
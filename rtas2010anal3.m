function rtas2010anal3
%%%%%%%%%%%%%%%%%%
% redundancy
%%%%%%%%%%%%%%%%%%
clear

lambdaB=1/23;lambdaS=1/(1.5*1/lambdaB);
ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05; t=10;

c1ppaba=[];c1ppcon=[];c2spaba=[];c2spcon=[];c3ppaba=[];c3ppcon=[];c4spaba=[];c4spcon=[];
c5psaba=[];c5pscon=[];c6ssaba=[];c6sscon=[];c7ppaba=[];c7ppcon=[];c8spaba=[];c8spcon=[];
c1psaba=[];c1pscon=[];c2ssaba=[];c2sscon=[];c3psaba=[];c3pscon=[];c4ssaba=[];c4sscon=[];
c5ppaba=[];c5ppcon=[];c6spaba=[];c6spcon=[];c7psaba=[];c7pscon=[];c8ssaba=[];c8sscon=[];

for redundancy=0:0.1:1
    m=20; n=m*(1+redundancy);
    M=10; N=M*(1+redundancy);
    x=N; r=N;s=n;

    Cplus=(1-p)*x; Cstar=(1-p)/M*x; Cno=p*x; tau=2*(Cplus+Cstar);

    curspP=1/tau*(1-q)/m*Cplus; curssS=1/tau*(1-q)*Cplus;
    curppP=1/tau*(1-q)/m*Cstar; curssB=1/tau*q*Cplus;
    curpsB=1/tau*q*Cstar; curpsS=1/tau*(1-q)*Cstar;
    curssS=1/tau*(1-q)*Cplus;
    %curspP=1;curssS=1;curppP=1;curssB=1;curpsB=1;curpsS=1;curssS=1;
    
    c1ppaba=[c1ppaba; RAfunction('c1ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)]; 
    c1ppcon=[c1ppcon; RAfunction('c1ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c1psaba=[c1psaba; RAfunction('c1psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsB)]; 
    c1pscon=[c1pscon; RAfunction('c1pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c2spaba=[c2spaba; RAfunction('c2spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c2spcon=[c2spcon; RAfunction('c2spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c2ssaba=[c2ssaba; RAfunction('c2ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c2sscon=[c2sscon; RAfunction('c2sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c3ppaba=[c3ppaba; RAfunction('c3ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c3ppcon=[c3ppcon; RAfunction('c3ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c3psaba=[c3psaba; RAfunction('c3psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c3pscon=[c3pscon; RAfunction('c3pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c4spaba=[c4spaba; RAfunction('c4spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c4spcon=[c4spcon; RAfunction('c4spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c4ssaba=[c4ssaba; RAfunction('c4ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c4sscon=[c4sscon; RAfunction('c4sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c5ppaba=[c5ppaba;RAfunction('c5ppaba',t,lambdaB,lambdaS,N,M,n,m,0,curppP)]; 
    c5ppcon=[c5ppcon; RAfunction('c5ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c5psaba=[c5psaba; RAfunction('c5psaba',t,lambdaB,lambdaS,N,M,n,m,0,curpsB)]; 
    c5pscon=[c5pscon; RAfunction('c5pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c6spaba=[c6spaba; RAfunction('c6spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c6spcon=[c6spcon; RAfunction('c6spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c6ssaba=[c6ssaba; RAfunction('c6ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c6sscon=[c6sscon; RAfunction('c6sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c7ppaba=[c7ppaba; RAfunction('c7ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c7ppcon=[c7ppcon; RAfunction('c7ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c7psaba=[c7psaba; RAfunction('c7psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c7pscon=[c7pscon; RAfunction('c7pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c8spaba=[c8spaba; RAfunction('c8spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c8spcon=[c8spcon; RAfunction('c8spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c8ssaba=[c8ssaba; RAfunction('c8ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c8sscon=[c8sscon; RAfunction('c8sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
end

meanL01=(c1ppaba+ c1psaba +c2spaba +c2ssaba +c3ppaba +c3psaba +c4spaba +c4ssaba ...
    +c5psaba+ c5ppaba +c6ssaba+ c6spaba +c7ppaba +c7psaba +c8spaba +c8ssaba)/16;
meanL02=(c1ppcon +c1pscon +c2spcon +c2sscon +c3ppcon +c3pscon +c4spcon +c4sscon ...
    +c5pscon +c5ppcon +c6sscon +c6spcon +c7ppcon +c7pscon +c8spcon +c8sscon)/16;

minL01=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
minL02=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);

figure %cpsredundancy.eps
plot([0:0.1:1],meanL01,'-+',[0:0.1:1],meanL02,'-*','LineWidth',2);
xlabel(['Redundancy (After ', num2str(t), ' years)']);
ylabel('Reliability (Mean)');
%bar([meanL01 meanL02]); 
legend('PISA','Conv. BMS');
max(meanL01'./meanL02') %40 times

figure %cpslifecomp.eps
%bar([minL01 minL02]); 
plot([0:0.1:1],minL01,'-+',[0:0.1:1],minL02,'-*','LineWidth',2);
xlabel(['Redundancy (After ', num2str(t), ' years)']);
ylabel('Reliability (Min)');
legend('PISA','Conv. BMS');

if 0
maxL01=max(max(max(max(max(max(max(max(max(max(max(max(max(max(max(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
maxL02=max(max(max(max(max(max(max(max(max(max(max(max(max(max(max(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);

figure %cpslifecomp.eps
%bar([minL01 minL02]); 
plot([0.1:0.1:1],maxL01,'-+',[0.1:0.1:1],maxL02,'-*','LineWidth',2);
xlabel('Redundancy in Max');
ylabel('Reliability');
legend('PISA','Conv. BMS');


U01=maxL01-meanL01; L01=meanL01-minL01;
U02=maxL02-meanL02; L02=meanL02-minL02;
figure
hold on
errorbar([0.1:0.1:1],meanL01,L01,U01,'-+b','LineWidth',2);
errorbar([0.1:0.1:1],meanL02,L02,U02,'-*g','LineWidth',2);
hold off
end

%%%%%%%%%%%%%%%%%%
% Scalability
%%%%%%%%%%%%%%%%%%
clear

lambdaB=1/23;lambdaS=1/(1.5*1/lambdaB);
ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05; t=10;

c1ppaba=[];c1ppcon=[];c2spaba=[];c2spcon=[];c3ppaba=[];c3ppcon=[];c4spaba=[];c4spcon=[];
c5psaba=[];c5pscon=[];c6ssaba=[];c6sscon=[];c7ppaba=[];c7ppcon=[];c8spaba=[];c8spcon=[];
c1psaba=[];c1pscon=[];c2ssaba=[];c2sscon=[];c3psaba=[];c3pscon=[];c4ssaba=[];c4sscon=[];
c5ppaba=[];c5ppcon=[];c6spaba=[];c6spcon=[];c7psaba=[];c7pscon=[];c8ssaba=[];c8sscon=[];

redundancy=0.7;
for m=10:5:100
    n=floor(m*(1+redundancy));
    M=m-5; N=floor(M*(1+redundancy));
    x=N; r=N;s=n;

    Cplus=(1-p)*x; Cstar=(1-p)/M*x; Cno=p*x; tau=2*(Cplus+Cstar);

    curspP=1/tau*(1-q)/m*Cplus; curssS=1/tau*(1-q)*Cplus;
    curppP=1/tau*(1-q)/m*Cstar; curssB=1/tau*q*Cplus;
    curpsB=1/tau*q*Cstar; curpsS=1/tau*(1-q)*Cstar;
    curssS=1/tau*(1-q)*Cplus;
    %curspP=1;curssS=1;curppP=1;curssB=1;curpsB=1;curpsS=1;curssS=1;
    
    c1ppaba=[c1ppaba; RAfunction('c1ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)]; 
    c1ppcon=[c1ppcon; RAfunction('c1ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c1psaba=[c1psaba; RAfunction('c1psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsB)]; 
    c1pscon=[c1pscon; RAfunction('c1pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c2spaba=[c2spaba; RAfunction('c2spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c2spcon=[c2spcon; RAfunction('c2spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c2ssaba=[c2ssaba; RAfunction('c2ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c2sscon=[c2sscon; RAfunction('c2sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c3ppaba=[c3ppaba; RAfunction('c3ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c3ppcon=[c3ppcon; RAfunction('c3ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c3psaba=[c3psaba; RAfunction('c3psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c3pscon=[c3pscon; RAfunction('c3pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c4spaba=[c4spaba; RAfunction('c4spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c4spcon=[c4spcon; RAfunction('c4spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c4ssaba=[c4ssaba; RAfunction('c4ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c4sscon=[c4sscon; RAfunction('c4sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c5ppaba=[c5ppaba;RAfunction('c5ppaba',t,lambdaB,lambdaS,N,M,n,m,0,curppP)]; 
    c5ppcon=[c5ppcon; RAfunction('c5ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c5psaba=[c5psaba; RAfunction('c5psaba',t,lambdaB,lambdaS,N,M,n,m,0,curpsB)]; 
    c5pscon=[c5pscon; RAfunction('c5pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c6spaba=[c6spaba; RAfunction('c6spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c6spcon=[c6spcon; RAfunction('c6spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c6ssaba=[c6ssaba; RAfunction('c6ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c6sscon=[c6sscon; RAfunction('c6sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c7ppaba=[c7ppaba; RAfunction('c7ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c7ppcon=[c7ppcon; RAfunction('c7ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c7psaba=[c7psaba; RAfunction('c7psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c7pscon=[c7pscon; RAfunction('c7pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c8spaba=[c8spaba; RAfunction('c8spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c8spcon=[c8spcon; RAfunction('c8spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c8ssaba=[c8ssaba; RAfunction('c8ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c8sscon=[c8sscon; RAfunction('c8sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
end

meanL01=(c1ppaba+ c1psaba +c2spaba +c2ssaba +c3ppaba +c3psaba +c4spaba +c4ssaba ...
    +c5psaba+ c5ppaba +c6ssaba+ c6spaba +c7ppaba +c7psaba +c8spaba +c8ssaba)/16;
meanL02=(c1ppcon +c1pscon +c2spcon +c2sscon +c3ppcon +c3pscon +c4spcon +c4sscon ...
    +c5pscon +c5ppcon +c6sscon +c6spcon +c7ppcon +c7pscon +c8spcon +c8sscon)/16;

minL01=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
minL02=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);

figure %cpsm.eps
plot([10:5:m],meanL01,'-+',[10:5:m],meanL02,'-*','LineWidth',2);
xlabel('# of available battery cells in an array (m)');
ylabel('Reliability (Mean)');
%bar([meanL01 meanL02]); 
legend('PISA','Conv. BMS');

figure %cpslifecomp.eps
%bar([minL01 minL02]); 
plot([10:5:m],minL01,'-+',[10:5:m],minL02,'-*','LineWidth',2);
xlabel('# of available battery cells in an array (m)');
ylabel('Reliability (Min)');
legend('PISA','Conv. BMS');

%%%%%%%%%%%%%%%%%%%
% lifetime
%%%%%%%%%%%%%%%%%%%
clear
redundancy=0.7;
m=20; n=m*(1+redundancy);
M=10; N=M*(1+redundancy);
x=N;

lambdaB=1/23;lambdaS=1/(1.5*1/lambdaB);
ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05;r=N;s=n;

c1ppaba=[];c1ppcon=[];c2spaba=[];c2spcon=[];c3ppaba=[];c3ppcon=[];c4spaba=[];c4spcon=[];
c5psaba=[];c5pscon=[];c6ssaba=[];c6sscon=[];c7ppaba=[];c7ppcon=[];c8spaba=[];c8spcon=[];
c1psaba=[];c1pscon=[];c2ssaba=[];c2sscon=[];c3psaba=[];c3pscon=[];c4ssaba=[];c4sscon=[];
c5ppaba=[];c5ppcon=[];c6spaba=[];c6spcon=[];c7psaba=[];c7pscon=[];c8ssaba=[];c8sscon=[];

for t=0:15
    Cplus=(1-p)*x; Cstar=(1-p)/M*x; Cno=p*x; tau=2*(Cplus+Cstar);

    curspP=1/tau*(1-q)/m*Cplus; curssS=1/tau*(1-q)*Cplus;
    curppP=1/tau*(1-q)/m*Cstar; curssB=1/tau*q*Cplus;
    curpsB=1/tau*q*Cstar; curpsS=1/tau*(1-q)*Cstar;
    curssS=1/tau*(1-q)*Cplus;
    %curspP=1;curssS=1;curppP=1;curssB=1;curpsB=1;curpsS=1;curssS=1;
    
    c1ppaba=[c1ppaba; RAfunction('c1ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)]; 
    c1ppcon=[c1ppcon; RAfunction('c1ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c1psaba=[c1psaba; RAfunction('c1psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsB)]; 
    c1pscon=[c1pscon; RAfunction('c1pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c2spaba=[c2spaba; RAfunction('c2spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c2spcon=[c2spcon; RAfunction('c2spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c2ssaba=[c2ssaba; RAfunction('c2ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c2sscon=[c2sscon; RAfunction('c2sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c3ppaba=[c3ppaba; RAfunction('c3ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c3ppcon=[c3ppcon; RAfunction('c3ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c3psaba=[c3psaba; RAfunction('c3psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c3pscon=[c3pscon; RAfunction('c3pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c4spaba=[c4spaba; RAfunction('c4spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c4spcon=[c4spcon; RAfunction('c4spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c4ssaba=[c4ssaba; RAfunction('c4ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c4sscon=[c4sscon; RAfunction('c4sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c5ppaba=[c5ppaba;RAfunction('c5ppaba',t,lambdaB,lambdaS,N,M,n,m,0,curppP)]; 
    c5ppcon=[c5ppcon; RAfunction('c5ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c5psaba=[c5psaba; RAfunction('c5psaba',t,lambdaB,lambdaS,N,M,n,m,0,curpsB)]; 
    c5pscon=[c5pscon; RAfunction('c5pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c6spaba=[c6spaba; RAfunction('c6spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c6spcon=[c6spcon; RAfunction('c6spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c6ssaba=[c6ssaba; RAfunction('c6ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c6sscon=[c6sscon; RAfunction('c6sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c7ppaba=[c7ppaba; RAfunction('c7ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c7ppcon=[c7ppcon; RAfunction('c7ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c7psaba=[c7psaba; RAfunction('c7psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c7pscon=[c7pscon; RAfunction('c7pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c8spaba=[c8spaba; RAfunction('c8spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c8spcon=[c8spcon; RAfunction('c8spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c8ssaba=[c8ssaba; RAfunction('c8ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c8sscon=[c8sscon; RAfunction('c8sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
end

if 0
figure
plot([0:length(c1ppaba)],c1ppaba,'-+',[0:length(c1ppcon)],c1ppcon,'-*',...
    [0:length(c1psaba)],c1psaba,'-x',[0:length(c1pscon)],c1pscon,'-o','LineWidth',2);
legend('C1.pp-aba','C1.pp-con','C1.ps-aba','C1.ps-con');
figure
plot([0:length(c2spaba)],c2spaba,'-+',[0:length(c2spcon)],c2spcon,'-*',...
    [0:length(c2ssaba)],c2ssaba,'-x',[0:length(c2sscon)],c2sscon,'-o','LineWidth',2);
legend('C2.sp-aba','C2.sp-con','C2.ss-aba','C2.ss-con');
figure
plot([0:length(c3ppaba)],c3ppaba,'-+',[0:length(c3ppcon)],c3ppcon,'-*',...
    [0:length(c3psaba)],c3psaba,'-x',[0:length(c3pscon)],c3pscon,'-o','LineWidth',2);
legend('C3.pp-aba','C3.pp-con','C3.ps-aba','C3.ps-con');
figure
plot([0:length(c4spaba)],c4spaba,'-+',[0:length(c4spcon)],c4spcon,'-*',...
    [0:length(c4ssaba)],c4ssaba,'-x',[0:length(c4sscon)],c4sscon,'-o','LineWidth',2);
legend('C4.sp-aba','C4.sp-con','C4.ss-aba','C4.ss-con');
figure
plot([0:length(c5ppaba)],c5ppaba,'-+',[0:length(c5ppcon)],c5ppcon,'-*',...
    [0:length(c5psaba)],c5psaba,'-x',[0:length(c5pscon)],c5pscon,'-o','LineWidth',2);
legend('C5.pp-aba','C5.pp-con','C5.ps-aba','C5.ps-con');
figure
plot([0:length(c6spaba)],c6spaba,'-+',[0:length(c6spcon)],c6spcon,'-*',...
    [0:length(c6ssaba)],c6ssaba,'-x',[0:length(c6sscon)],c6sscon,'-o','LineWidth',2);
legend('C6.sp-aba','C6.sp-con','C6.ss-aba','C6.ss-con');
figure
plot([0:length(c7ppaba)],c7ppaba,'-+',[0:length(c7ppcon)],c7ppcon,'-*',...
    [0:length(c7psaba)],c7psaba,'-x',[0:length(c7pscon)],c7pscon,'-o','LineWidth',2);
legend('C7.pp-aba','C7.pp-con','C7.ps-aba','C7.ps-con');
figure
plot([0:length(c8spaba)],c8spaba,'-+',[0:length(c8spcon)],c8spcon,'-*',...
    [0:length(c8ssaba)],c8ssaba,'-x',[0:length(c8sscon)],c8sscon,'-o','LineWidth',2);
legend('C8.sp-aba','C8.sp-con','C8.ss-aba','C8.ss-con');
end

meanL01=(c1ppaba+ c1psaba +c2spaba +c2ssaba +c3ppaba +c3psaba +c4spaba +c4ssaba ...
    +c5psaba+ c5ppaba +c6ssaba+ c6spaba +c7ppaba +c7psaba +c8spaba +c8ssaba)/16;
meanL02=(c1ppcon +c1pscon +c2spcon +c2sscon +c3ppcon +c3pscon +c4spcon +c4sscon ...
    +c5pscon +c5ppcon +c6sscon +c6spcon +c7ppcon +c7pscon +c8spcon +c8sscon)/16;
figure %cpsrelimean.eps
plot([0:t],meanL01,'-+',[0:t],meanL02,'-*','LineWidth',2);
xlabel('Time during which to use batteries (years)');
ylabel('Reliability (Mean)');
%bar([meanL01 meanL02]); 
legend('PISA','Conv. BMS');
max(meanL01'./meanL02') %40 times

minL01=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
minL02=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);
figure %cpsrelimin.eps
%bar([minL01 minL02]); 
plot([0:t],minL01,'-+',[0:t],minL02,'-*','LineWidth',2);
xlabel('Time during which to use batteries (years)');
ylabel('Reliability (Min)');
legend('PISA','Conv. BMS');

%%%%%%%%%%%%%%%%%%%
% lambdaB and lambdaS
%%%%%%%%%%%%%%%%%%%
clear

redundancy=0.7;
m=20; n=m*(1+redundancy);
M=10; N=M*(1+redundancy);
x=N;

ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05;r=N;s=n;t=10;

c1ppaba=[];c1ppcon=[];c2spaba=[];c2spcon=[];c3ppaba=[];c3ppcon=[];c4spaba=[];c4spcon=[];
c5psaba=[];c5pscon=[];c6ssaba=[];c6sscon=[];c7ppaba=[];c7ppcon=[];c8spaba=[];c8spcon=[];
c1psaba=[];c1pscon=[];c2ssaba=[];c2sscon=[];c3psaba=[];c3pscon=[];c4ssaba=[];c4sscon=[];
c5ppaba=[];c5ppcon=[];c6spaba=[];c6spcon=[];c7psaba=[];c7pscon=[];c8ssaba=[];c8sscon=[];

for i=1:40
    lambdaB=1/i;lambdaS=1/(i*1.5);
    Cplus=(1-p)*x; Cstar=(1-p)/M*x; Cno=p*x; tau=2*(Cplus+Cstar);

    curspP=1/tau*(1-q)/m*Cplus; curssS=1/tau*(1-q)*Cplus;
    curppP=1/tau*(1-q)/m*Cstar; curssB=1/tau*q*Cplus;
    curpsB=1/tau*q*Cstar; curpsS=1/tau*(1-q)*Cstar;
    curssS=1/tau*(1-q)*Cplus;
    %curspP=1;curssS=1;curppP=1;curssB=1;curpsB=1;curpsS=1;curssS=1;
    
    c1ppaba=[c1ppaba; RAfunction('c1ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)]; 
    c1ppcon=[c1ppcon; RAfunction('c1ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c1psaba=[c1psaba; RAfunction('c1psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsB)]; 
    c1pscon=[c1pscon; RAfunction('c1pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c2spaba=[c2spaba; RAfunction('c2spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c2spcon=[c2spcon; RAfunction('c2spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c2ssaba=[c2ssaba; RAfunction('c2ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c2sscon=[c2sscon; RAfunction('c2sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c3ppaba=[c3ppaba; RAfunction('c3ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c3ppcon=[c3ppcon; RAfunction('c3ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c3psaba=[c3psaba; RAfunction('c3psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c3pscon=[c3pscon; RAfunction('c3pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c4spaba=[c4spaba; RAfunction('c4spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c4spcon=[c4spcon; RAfunction('c4spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c4ssaba=[c4ssaba; RAfunction('c4ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c4sscon=[c4sscon; RAfunction('c4sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c5ppaba=[c5ppaba;RAfunction('c5ppaba',t,lambdaB,lambdaS,N,M,n,m,0,curppP)]; 
    c5ppcon=[c5ppcon; RAfunction('c5ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c5psaba=[c5psaba; RAfunction('c5psaba',t,lambdaB,lambdaS,N,M,n,m,0,curpsB)]; 
    c5pscon=[c5pscon; RAfunction('c5pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c6spaba=[c6spaba; RAfunction('c6spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c6spcon=[c6spcon; RAfunction('c6spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c6ssaba=[c6ssaba; RAfunction('c6ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c6sscon=[c6sscon; RAfunction('c6sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c7ppaba=[c7ppaba; RAfunction('c7ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c7ppcon=[c7ppcon; RAfunction('c7ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c7psaba=[c7psaba; RAfunction('c7psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c7pscon=[c7pscon; RAfunction('c7pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c8spaba=[c8spaba; RAfunction('c8spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c8spcon=[c8spcon; RAfunction('c8spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c8ssaba=[c8ssaba; RAfunction('c8ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c8sscon=[c8sscon; RAfunction('c8sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
end

if 0
figure
plot([1:length(c1ppaba)],c1ppaba,'-+',[1:length(c1ppcon)],c1ppcon,'-*',...
    [1:length(c1psaba)],c1psaba,'-x',[1:length(c1pscon)],c1pscon,'-o','LineWidth',2);
legend('C1.pp-aba','C1.pp-con','C1.ps-aba','C1.ps-con');
figure
plot([1:length(c2spaba)],c2spaba,'-+',[1:length(c2spcon)],c2spcon,'-*',...
    [1:length(c2ssaba)],c2ssaba,'-x',[1:length(c2sscon)],c2sscon,'-o','LineWidth',2);
legend('C2.sp-aba','C2.sp-con','C2.ss-aba','C2.ss-con');
figure
plot([1:length(c3ppaba)],c3ppaba,'-+',[1:length(c3ppcon)],c3ppcon,'-*',...
    [1:length(c3psaba)],c3psaba,'-x',[1:length(c3pscon)],c3pscon,'-o','LineWidth',2);
legend('C3.pp-aba','C3.pp-con','C3.ps-aba','C3.ps-con');
figure
plot([1:length(c4spaba)],c4spaba,'-+',[1:length(c4spcon)],c4spcon,'-*',...
    [1:length(c4ssaba)],c4ssaba,'-x',[1:length(c4sscon)],c4sscon,'-o','LineWidth',2);
legend('C4.sp-aba','C4.sp-con','C4.ss-aba','C4.ss-con');
figure
plot([1:length(c5ppaba)],c5ppaba,'-+',[1:length(c5ppcon)],c5ppcon,'-*',...
    [1:length(c5psaba)],c5psaba,'-x',[1:length(c5pscon)],c5pscon,'-o','LineWidth',2);
legend('C5.pp-aba','C5.pp-con','C5.ps-aba','C5.ps-con');
figure
plot([1:length(c6spaba)],c6spaba,'-+',[1:length(c6spcon)],c6spcon,'-*',...
    [1:length(c6ssaba)],c6ssaba,'-x',[1:length(c6sscon)],c6sscon,'-o','LineWidth',2);
legend('C6.sp-aba','C6.sp-con','C6.ss-aba','C6.ss-con');
figure
plot([1:length(c7ppaba)],c7ppaba,'-+',[1:length(c7ppcon)],c7ppcon,'-*',...
    [1:length(c7psaba)],c7psaba,'-x',[1:length(c7pscon)],c7pscon,'-o','LineWidth',2);
legend('C7.pp-aba','C7.pp-con','C7.ps-aba','C7.ps-con');
figure
plot([1:length(c8spaba)],c8spaba,'-+',[1:length(c8spcon)],c8spcon,'-*',...
    [1:length(c8ssaba)],c8ssaba,'-x',[1:length(c8sscon)],c8sscon,'-o','LineWidth',2);
legend('C8.sp-aba','C8.sp-con','C8.ss-aba','C8.ss-con');
end

meanL01=(c1ppaba+ c1psaba +c2spaba +c2ssaba +c3ppaba +c3psaba +c4spaba +c4ssaba ...
    +c5psaba+ c5ppaba +c6ssaba+ c6spaba +c7ppaba +c7psaba +c8spaba +c8ssaba)/16;
meanL02=(c1ppcon +c1pscon +c2spcon +c2sscon +c3ppcon +c3pscon +c4spcon +c4sscon ...
    +c5pscon +c5ppcon +c6sscon +c6spcon +c7ppcon +c7pscon +c8spcon +c8sscon)/16;
figure %cpslifemean.eps
plot([1:length(meanL01)],meanL01,'-+',[1:length(meanL02)],meanL02,'-*','LineWidth',2);
xlabel('Battery-cell lifetime (1/\lambda_B)');
ylabel('Reliability (Mean)');
%bar([meanL01 meanL02]); 
legend('PISA','Conv. BMS');
max(meanL01'./meanL02') %40 times

minL01=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
minL02=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);
figure %cpslifemin.eps
%bar([minL01 minL02]); 
plot([1:length(minL01)],minL01,'-+',[1:length(minL02)],minL02,'-*','LineWidth',2);
xlabel('Battery-cell lifetime (1/\lambda_B)');
ylabel('Reliability (Min)');
legend('PISA','Conv. BMS');


%%%%%%%%%%%%%%%%
% Cost
%%%%%%%%%%%%%%%%
clear
T=0.05;%[0.6:0.1:1];
lambdaa=3; alpha=2; Ca=1; Cf=3*Ca; 
ya=power(1+T*lambdaa/alpha,-alpha);

redundancy=0.9;
m=20; n=m*(1+redundancy);
M=10; N=M*(1+redundancy);
x=N;

ratio=0.01;%lifetime to coulomb: a flow of x coulombs degrades y degree of lifetime
p=0.05;q=0.05;r=N;s=n;t=10;

c1ppaba=[];c1ppcon=[];c2spaba=[];c2spcon=[];c3ppaba=[];c3ppcon=[];c4spaba=[];c4spcon=[];
c5psaba=[];c5pscon=[];c6ssaba=[];c6sscon=[];c7ppaba=[];c7ppcon=[];c8spaba=[];c8spcon=[];
c1psaba=[];c1pscon=[];c2ssaba=[];c2sscon=[];c3psaba=[];c3pscon=[];c4ssaba=[];c4sscon=[];
c5ppaba=[];c5ppcon=[];c6spaba=[];c6spcon=[];c7psaba=[];c7pscon=[];c8ssaba=[];c8sscon=[];

for t=0:10
    i=23;
    lambdaB=1/i;lambdaS=1/(i*1.5);
    Cplus=(1-p)*x; Cstar=(1-p)/M*x; Cno=p*x; tau=2*(Cplus+Cstar);

    curspP=1/tau*(1-q)/m*Cplus; curssS=1/tau*(1-q)*Cplus;
    curppP=1/tau*(1-q)/m*Cstar; curssB=1/tau*q*Cplus;
    curpsB=1/tau*q*Cstar; curpsS=1/tau*(1-q)*Cstar;
    curssS=1/tau*(1-q)*Cplus;
    %curspP=1;curssS=1;curppP=1;curssB=1;curpsB=1;curpsS=1;curssS=1;
    
    c1ppaba=[c1ppaba; RAfunction('c1ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)]; 
    c1ppcon=[c1ppcon; RAfunction('c1ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c1psaba=[c1psaba; RAfunction('c1psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsB)]; 
    c1pscon=[c1pscon; RAfunction('c1pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c2spaba=[c2spaba; RAfunction('c2spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c2spcon=[c2spcon; RAfunction('c2spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c2ssaba=[c2ssaba; RAfunction('c2ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c2sscon=[c2sscon; RAfunction('c2sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c3ppaba=[c3ppaba; RAfunction('c3ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c3ppcon=[c3ppcon; RAfunction('c3ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c3psaba=[c3psaba; RAfunction('c3psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c3pscon=[c3pscon; RAfunction('c3pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c4spaba=[c4spaba; RAfunction('c4spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c4spcon=[c4spcon; RAfunction('c4spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c4ssaba=[c4ssaba; RAfunction('c4ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c4sscon=[c4sscon; RAfunction('c4sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c5ppaba=[c5ppaba;RAfunction('c5ppaba',t,lambdaB,lambdaS,N,M,n,m,0,curppP)]; 
    c5ppcon=[c5ppcon; RAfunction('c5ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    c5psaba=[c5psaba; RAfunction('c5psaba',t,lambdaB,lambdaS,N,M,n,m,0,curpsB)]; 
    c5pscon=[c5pscon; RAfunction('c5pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)]; 
    
    c6spaba=[c6spaba; RAfunction('c6spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curspP)];
    c6spcon=[c6spcon; RAfunction('c6spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c6ssaba=[c6ssaba; RAfunction('c6ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cno,curssB)];
    c6sscon=[c6sscon; RAfunction('c6sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c7ppaba=[c7ppaba; RAfunction('c7ppaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curppP)];
    c7ppcon=[c7ppcon; RAfunction('c7ppcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c7psaba=[c7psaba; RAfunction('c7psaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cstar,curpsS)];
    c7pscon=[c7pscon; RAfunction('c7pscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    
    c8spaba=[c8spaba; RAfunction('c8spaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curspP)];
    c8spcon=[c8spcon; RAfunction('c8spcon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
    c8ssaba=[c8ssaba; RAfunction('c8ssaba',t,lambdaB,lambdaS,N,M,n,m,1/tau*Cplus,curssS)];
    c8sscon=[c8sscon; RAfunction('c8sscon',t,lambdaB,lambdaS,N,M,n,m,0,0)];
end

if 0
figure
plot([0:t],c1ppaba,'-+',[0:t],c1ppcon,'-*',...
    [0:t],c1psaba,'-x',[0:t],c1pscon,'-o','LineWidth',2);
legend('C1.pp-aba','C1.pp-con','C1.ps-aba','C1.ps-con');
figure
plot([0:t],c2spaba,'-+',[0:t],c2spcon,'-*',...
    [0:t],c2ssaba,'-x',[0:t],c2sscon,'-o','LineWidth',2);
legend('C2.sp-aba','C2.sp-con','C2.ss-aba','C2.ss-con');
figure
plot([0:t],c3ppaba,'-+',[0:t],c3ppcon,'-*',...
    [0:t],c3psaba,'-x',[0:t],c3pscon,'-o','LineWidth',2);
legend('C3.pp-aba','C3.pp-con','C3.ps-aba','C3.ps-con');
figure
plot([0:t],c4spaba,'-+',[0:t],c4spcon,'-*',...
    [0:t],c4ssaba,'-x',[0:t],c4sscon,'-o','LineWidth',2);
legend('C4.sp-aba','C4.sp-con','C4.ss-aba','C4.ss-con');
figure
plot([0:t],c5ppaba,'-+',[0:t],c5ppcon,'-*',...
    [0:t],c5psaba,'-x',[0:t],c5pscon,'-o','LineWidth',2);
legend('C5.pp-aba','C5.pp-con','C5.ps-aba','C5.ps-con');
figure
plot([0:t],c6spaba,'-+',[0:t],c6spcon,'-*',...
    [0:t],c6ssaba,'-x',[0:t],c6sscon,'-o','LineWidth',2);
legend('C6.sp-aba','C6.sp-con','C6.ss-aba','C6.ss-con');
figure
plot([0:t],c7ppaba,'-+',[0:t],c7ppcon,'-*',...
    [0:t],c7psaba,'-x',[0:t],c7pscon,'-o','LineWidth',2);
legend('C7.pp-aba','C7.pp-con','C7.ps-aba','C7.ps-con');
figure
plot([0:t],c8spaba,'-+',[0:t],c8spcon,'-*',...
    [0:t],c8ssaba,'-x',[0:t],c8sscon,'-o','LineWidth',2);
legend('C8.sp-aba','C8.sp-con','C8.ss-aba','C8.ss-con');
end

meanL01=(c1ppaba+ c1psaba +c2spaba +c2ssaba +c3ppaba +c3psaba +c4spaba +c4ssaba ...
    +c5psaba+ c5ppaba +c6ssaba+ c6spaba +c7ppaba +c7psaba +c8spaba +c8ssaba)/16;
meanL02=(c1ppcon +c1pscon +c2spcon +c2sscon +c3ppcon +c3pscon +c4spcon +c4sscon ...
    +c5pscon +c5ppcon +c6sscon +c6spcon +c7ppcon +c7pscon +c8spcon +c8sscon)/16;

minL01=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppaba, c1psaba), c2spaba),...
    c2ssaba), c3ppaba), c3psaba), c4spaba), c4ssaba), ...
    c5psaba), c5ppaba), c6ssaba), c6spaba), c7ppaba), c7psaba), c8spaba), c8ssaba); ...
minL02=min(min(min(min(min(min(min(min(min(min(min(min(min(min(min(c1ppcon, c1pscon), c2spcon),...
c2sscon), c3ppcon), c3pscon), c4spcon), c4sscon), ...
    c5pscon), c5ppcon), c6sscon), c6spcon), c7ppcon), c7pscon), c8spcon), c8sscon);


CM1(length(meanL01),1)=0;
CM1(:,1)=1.1*Ca/ya;
ourcost=(1-meanL01*ya)*Cf;
ourcost=CM1+ourcost;
legcost=(1-meanL02*ya)*Cf;
CM2(length(meanL02),1)=0;
CM2(:,1)=1*Ca/ya;
legcost=CM2+legcost;
figure %cpscostmean.eps
hold
hold on
bar([ourcost, legcost]);
bar([CM1, CM2]);
hold off
xlabel('Warranty in Mean');
ylabel('Cost');
legend('ABA-Manu','Con-Manu','ABA-Ser','Con-Ser');

CM1(length(minL01),1)=0;
CM1(:,1)=1.1*Ca/ya;
ourcost=(1-minL01*ya)*Cf;
ourcost=CM1+ourcost;
legcost=(1-minL02*ya)*Cf;
CM2(length(minL02),1)=0;
CM2(:,1)=1*Ca/ya;
legcost=CM2+legcost;
figure %cpscostworst.eps
hold
hold on
bar([ourcost, legcost]);
bar([CM1, CM2]);
hold off
xlabel('Warranty in Worst');
ylabel('Cost');
legend('ABA-Manu','Con-Manu','ABA-Ser','Con-Ser');


%RTAS2010 Analysis
function rtas2010analysis

%p: prob that the Slave BMS will be bypassed
%r: # of Slave BMSes connected to the load
%k: # of Slave BMSes connected consecutively among r
%i: # of Salve BMSes among k which precede the (k+1)-th Slave BMS
%rr: resistance of a switch
clear
ohm=0.025;
rr=0.0005;
p=[0:0.05:1];
x=10;
r=50;
k=20;
i=10;
%cell-level power loss
BMSparP=(1-p)/r * x;
BMSparS=0;
BMSparB= (1-p) * i/r * x;%nchoosek(k,i)*times(power(1-p, i), power(p, k-i)) * i/r * x;
BMSserP=0;%times(power(p, k), (1-p))*x;
BMSserS=(1-p)*x;
BMSserB=p*x;
figure
plot(p,BMSparP.*BMSparP*ohm,'r-',p,BMSparS.*BMSparS*ohm,'b-',...
    p,BMSparB.*BMSparB*ohm,'g-',p,BMSserP.*BMSserP*ohm,'m-',...
p,BMSserS.*BMSserS*ohm,'r--',p,BMSserB.*BMSserB*ohm,'b--','LineWidth',2);
xlabel('probability of being bypassed (p)');
ylabel('power dissipation on a switch (W)');

%pack-level power loss
s=10;
q=[0:0.05:1];
j=5;
BMSparparP=emtimes((1-q), BMSparP)*1/s;
BMSparserP=emtimes((1-q), BMSserS)*1/s;
BMSparparB= emtimes((1-q), BMSparP) * x * j/s;%nchoosek(k,i)*times(power(1-p, i), power(p, k-i)) * i/r * x;
BMSparserB= emtimes((1-q), BMSserS) * x* j/s;
BMSserparS=emtimes((1-q),BMSparP);
BMSserserS=emtimes((1-q),BMSserS);
BMSserparB=emtimes(q,BMSparP);
BMSserserB=emtimes(q,BMSserS);
figure
plot3(p,q,BMSparparP.^2*ohm,'r-',p,q,BMSparserP.^2*ohm,'r--',...
    p,q,BMSparparB.^2*ohm,'b-',p,q,BMSparserB.^2*ohm,'b--',...
    p,q,BMSserparS.^2*ohm,'g-',p,q,BMSserserS.^2*ohm,'g--',...
    p,q,BMSserparB.^2*ohm,'m-',p,q,BMSserserB.^2*ohm,'m--','LineWidth',2);
xlabel('probability of being bypassed (p)');
ylabel('power dissipation on a switch (W)');


r=50; k=20; i=10;
cur=[];
figure
hold on
for x=1:2:k %BMSparB
    BMSparB=(1-p) * i/r * x;%nchoosek(k,i)*times(power(1-p, i), power(p, k-i)) * i/r * x;
    pd=BMSparB.*BMSparB*ohm;
    cur=[cur; pd];
    ind=find(max(pd)==pd);
    text(p(ind), pd(ind),['x=' int2str(x)]);
end
plot(p,cur,'LineWidth',2);
xlabel('probability of being bypassed (p)');
ylabel('power dissipation on B-switch in parallel (W)');
hold off


x=10; r=50; k=20;
cur=[];
figure
hold on
for i=1:2:k %BMSparB
    BMSparB=(1-p) * i/r * x;%nchoosek(k,i)*times(power(1-p, i), power(p, k-i)) * i/r * x;
    pd=BMSparB.*BMSparB*ohm;
    cur=[cur; pd];
    ind=find(max(pd)==pd);
    text(p(ind), pd(ind),['i=' int2str(i)]);
end
plot(p,cur,'LineWidth',2);
xlabel('probability of being bypassed (p)');
ylabel('power dissipation on B-switch in parallel (W)');
hold off

%algorithm of assigning code
%
figure
events=[];
barr=[];
for k=1:11
    while 1
        barr=round(rand(1,11)); % arrangment is specified
        if ~ismember(sum(barr), events)
          events=[events sum(barr)];
          break
        end
    end
tarr=[];
carr=[];
ctype='SERI     '; % 010
%ctype='PARA     '; % 101
ccode=[0 1 0];
i=1;

while barr(i) < 1 
    i=i+1;
    switch barr(i)
        case {0} 
            tarr=[tarr 'NULL    ']; % 000
            carr=[carr [0 0 0]];
        case {1}
            tarr=[tarr 'INIT       ']; % 100
            carr=[carr [1 0 0]];
            break;
    end
end

i=i+1;

while i <= length(barr)
    switch barr(i)
        case {1}
            tarr=[tarr ctype];
            carr=[carr ccode];
        case {0}
            tarr=[tarr 'BYSS   ']; % 001
            carr=[carr [0 0 1]];
    end
    i=i+1;
end
barr
tarr

dis=carr*sum(barr);
cind=find(dis<1);
dis(cind)=dis(cind)+sum(barr)-0.2;
hold on
plot(dis,'-*','LineWidth',2,'MarkerSize',5);
text(1, max(dis)+0.3,tarr);
hold off
end
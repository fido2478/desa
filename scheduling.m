function scheduling
numcell=5;
T=10;
X=0;
Vint=10; %check battery cells every 10ms
G1=[]; G2=[];
deltaX=0.05;
deltaG1to2=3.6;
loadprof=[5 5 5 5 10 10 10 10 15 15 15 15 10 10 10 10 15 15 15 15 ...
    20 20 20 20 30 30 30 30 35 35 35 35 35 30 30 35 35 35 40 40 ...
    45 45 45 45 45 50 50 50 50 55 55 55 55 60 60 60 60 55 55 55 ...
    55 55 50 50 50 50 45 45 45 45 45 40 40 40 40 40 35 35 35 35 ...
    30 30 30 30 30 35 35 35 35 35 30 30 30 30 30 25 25 25 25 25 ... %100
    20 20 20 20 15 15 15 15 15 15 20 20 20 20 20 25 25 25 25 25 ...
    30 30 30 30 30 30 25 25 25 25 25 20 20 20 20 20 15 15 15 15 ...
    15 15 15 10 10 10 10 10 15 15 15 15 15 10 10 10 10 10 15 15 ...
    15 15 15 20 20 20 20 20 20 25 25 25 25 25 25 30 30 30 30 30 ...
    35 35 35 35 35 40 40 40 40 40 45 45 45 45 45 50 50 50 50 55 ... %200
    55 55 55 55 40 40 40 40 40 45 45 45 45 40 40 40 40 40 35 35 ...
    35 35 35 30 30 30 30 30 25 25 25 25 25 20 20 20 20 20 15 15 ...
    15 15 15 10 10 10 10 10 10 15 15 15 15 15 20 20 20 20 20 20 ...
    15 15 15 15 15 15 15 20 20 20 20 20 20 20 20 25 25 25 25 25 ...
    30 30 30 30 30 30 35 35 35 35 35 35 40 40 40 40 40 35 35 35 ... %300
    35 30 30 30 30 30 30 25 25 25 25 25 20 20 20 20 20 15 15 15 ];
%Y = poisspdf(X,drate); %Poisson with lamdba=drate
%r=binornd(n,p); %Bernoulli with prob p, and n trials
%y = exppdf(x,crate); %exp with lambda=crate

batpack(1:numcell)=4.05710;
etimebp(1:numcell)=0;
k=round(rand * numcell); %random choice
if k == 0
    k=1;
end;
%stepwise function of time and discharge rate
coeff=coefffunC5to100vol;
%volt=voltfun(coeff,load,time);
T=4; %1min
X=0; %250ms
togT=0; %toggle tag
unbal=0; %1: unbalanced 0: balanced
G1=find(batpack>deltaG1to2);
G2=find(batpack<=deltaG1to2);
%granularity: 250 ms
dt=1/4;
squeue=[]; 
chd=[];chv=[]; %debugging
tmpack=batpack(G1);
slc=sort(batpack(G1),'descend');
for i=1:k %k<=num(G1)
    ind=find(slc(i)==tmpack);
    if length(ind)>1
       ind=ind(1);
    end;
    squeue=[squeue G1(ind)];
    tmpack(ind)=0;
end
for i=1:80
    if (max(batpack(G1))-min(batpack(G1)))>deltaX
        if togT==0
            X=i-X;
            togT=1;
        end
        unbal=1;
    end;
    chd=[chd max(batpack(G1))-min(batpack(G1))];
    if mod(i,T)==0 | unbal>0 %preemption allowed
        if unbal>0
            if k>1
                k=k-1;
            end
            unbal=0;
        elseif T <= X
            if k<numcell
                k=k+1;
            end
        else
            if k>1
                k=k-1;
            end
            if togT==1
                T=X;
                X=i;
                togT=0;
            end
        end
        G1=find(batpack>deltaG1to2);
        G2=find(batpack<=deltaG1to2);
        squeue=[]; %reset
        if ~isempty(G1)
            tmpack=batpack(G1);
            slc=sort(batpack(G1),'descend'); %choose max(batpack)
            for i=1:k %k<=num(G1)
                ind=find(slc(i)==tmpack);
                if length(ind)>1
                    ind=ind(1);
                end;
                squeue=[squeue G1(ind)];
                tmpack(ind)=0;
            end
        elseif ~isempty(G2)
            k=length(G2);
            squeue=G2;
        end
    end
    if ~isempty(G1) | ~isempty(G2)
        [batpack etimebp]=drawing(batpack,etimebp,squeue,loadprof(ceil(i)), coeff,dt);
        chv=[chv batpack'];
    else
        break;
    end
end
figure
rwcl=size(chv);
x=[1:rwcl(2)];
hold on
lsty=['-', '-.', '--', ':', '-'];
%for i=1:rwcl(1)
%     H1=plot(x,chv(i,:),lsty(i));
    H1=plot(x,chv(1,:),'-',x,chv(2,:),'-.',x,chv(3,:),'--',x,chv(4,:),':',x,chv(5,:),'-');
    set(H1,'MarkerSize',10,'LineWidth',2);
%end
hold off
figure
H2=plot(x,chd,'--');
set(H2,'MarkerSize',10,'LineWidth',2);
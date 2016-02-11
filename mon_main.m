%monitoring
function mon_main
format long
% n-tree topology
% ns : total number of sensors: should be dividable by k
% k : k-bit state vector
% n : 2^k-bit of decoder 
% i : i-th sensor/battery
% p : p-th Mux
% S : state vector of the p-th Mux

% input: i
% output: array of S and demux
nmux=16; %in the bottom not in total
n=4; %n-tree-based
ns=n*nmux; %# of sensors
NS=[]; %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path-switching system
figure
for i=1:ns
    x=n_tree_topology(n,ns,i);
    NS=[NS; x]; %n:# of inputs per mux;
    hold on
    plot(i,x','.','MarkerSize',10);
    hold off
end
xlabel('i-th sensor');ylabel('state vector value');
legend('bottom-layered Muxes', 'mid-layered Muxes', 'top-layered Muxes');

%cascaded 
figure
ns=(n-1)*(nmux-1)+n;CS=[];
for i=1:ns
    x=cascaded_topology(n,i);
    CS=[CS x]; 
    hold on
    plot(i,x','.','MarkerSize',10);
    hold off
end
xlabel('i-th sensor');ylabel('state vector value');

%parallel
figure
ns=n*nmux;PS=[];
for i=1:ns
    x=parallel_topology(n,i);
    PS=[PS x]; %[position of mux, s vector]
    hold on
    plot(i,x','.','MarkerSize',10);
    hold off
end
xlabel('i-th sensor');ylabel('value');legend('p-th Mux', 'state vector');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load_demand=get_load_demand('../gps-traces/to_annarbor_GPS_record.txt');
fid=load('../gps-traces/to_annarbor_GPS_record.txt');
mlen=length(fid);
tline=fid(2:mlen,1)-fid(1,1);

figure
x=fid(2:mlen,1)-fid(1,1);
plot(x/60,load_demand,'LineWidth',1.5);
ylabel('Power (kW)');xlabel('Time (min)');

figure
a = 1;%a = [1 0.2];
b = [1/4 1/4 1/4 1/4];%b = [2 3];
b = [1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10];
y = filter(b,a,load_demand);
plot(x/60,y,'LineWidth',1.5);
ylabel('Power (kW)');xlabel('Time (min)');

figure
difval=abs((load_demand-y)./load_demand);
semilogy(difval);

sucrate=[];
totlen=length(difval);
sucrate=[];
for i=0.01:0.01:0.5
    sucrate=[sucrate; length(find(abs((load_demand-y)./load_demand)<=i))/totlen];
end
figure
x=[0.01:0.01:0.5];
plot(x,sucrate);
xlabel('error-tolerance ratio');ylabel('success ratio in estimation');

T=1000; %over time

n=64; %# of cells in series
m=4; %# of groups in parallel
ps=0.67; % probability of balancing ps=0 brute-forth monitoring
lambdac=70/1000;
lambdaa=10/1000;
DCc=[];%duty-cycle
DCa=[];

for lambdac=[10:10:100]
    x=1;
    for ps=0.1:0.05:0.8
        DCc(lambdac,x)=ps*lambdac/T; %Eq. 10
        DCa(lambdac,x)=(ps*lambdac+power(ps,n)*lambdaa)/T;
        x=x+1;
    end
end
figure
plot(0.1:0.05:0.8, DCa,'LineWidth',1.5);
figure
plot(0.1:0.05:0.8,DCc,'LineWidth',1.5);


gn=[];dcgpc=[];
y=1;ps=0.67;
for n=[10:2:32]
    x=1;
    for m=2:2:10
        gn(x,y)=double(1-(1-ps)^(n*m) + 1-(m*ps^n * (1-ps^n)^(m-1)+(1-ps^n)^m));
        dcgpc(x,y)=ps + m*ps^n/n;
        x=x+1;
    end
    y=y+1;
end
%figure
%plot([2:2:8],gn);%legend('m=2','m=4','m=6','m=8');
figure
plot([10:2:32], dcgpc', 'LineWidth',1.5);
end

function res=n_tree_topology(n, ns, i)
h=getheight(ns,n); % calculate height
p=0;S=[];
for m=1:h-1
    p=ceil(i/n); % pinpoint DeMux
    if p>=n
        S=[S i-n*(p-1)];
    else
        S=[S p];
    end
    i=p;
end
S=[S i];
res=S; %[demux; S];
end

function res=getheight(ns,n)
i=0; l= n;
while l>1
    l=ns/n;
    ns=l;
    i=i+1;
end
res=i;
end

function res=cascaded_topology(n, i)
S=[];
p=ceil(i/(n-1));
for m=1:(p-1)
    S=[S n];
end
S=[S i-(n-1)*(p-1)];
res=S;
end

function res=parallel_topology(n, i)
p=[];S=[];
%for m=1:length(i)
    x=ceil(i/n);
    p=[p, x];
    S=[S i-n*(x-1)];
%end
res=[p; S];
end
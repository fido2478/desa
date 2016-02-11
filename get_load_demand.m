function res=get_load_demand(file)
%fid=load('GPS_record_seg_0_1141');
fid=load(file);
mlen=length(fid);
time1=fid([1:mlen-1],1)/10000;
time2=fid([2:mlen],1)/10000;
deltaT=(time2-time1); %second
deltaD=gps_distance_cal(fid); %feet
%mile=0.621371192;

speed=0.000189393939*deltaD./deltaT; %mile/sec
pcon=111; %111kW GM Volt : Max 111kW
load_demand=speed*pcon; %Power W/sec
load_demand(2327)=load_demand(2326);
load_demand(2336)=load_demand(2335);
load_demand(2310)=load_demand(2309);
load_demand(2318)=load_demand(2317);
load_demand(2321)=load_demand(2320);
load_demand(2322)=load_demand(2321);
load_demand(2323)=load_demand(2322);
load_demand(2324)=load_demand(2323);
load_demand(2325)=load_demand(2324);
load_demand(2326)=load_demand(2325);
load_demand(2327)=load_demand(2326);
load_demand(2337)=load_demand(2336);

if 0
figure
x=fid(2:mlen,1)-fid(1,1);
H=plotyy(x,[0 load_demand],x,spdmileH);
set(get(H(1),'Ylabel'),'String',['Load demand (A) given ' num2str(sys_eff) 'A per mile']);
set(get(H(2),'Ylabel'),'String','Speed (Miles/H)');
xlabel('Time (sec)');
save('load_demand_city_drive_3p.txt','load_demand','-ASCII');
save('speed_mileH.txt','spdmileH','-ASCII');
end

if 0
figure
x=fid(2:mlen,1)-fid(1,1);
plot(x/60,load_demand,'LineWidth',1.5);
ylabel('Power (kW)');xlabel('Time (min)');
end

if 0
figure
a = 1;%a = [1 0.2];
b = [1/4 1/4 1/4 1/4];%b = [2 3];
b = [1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10 1/10];
y = filter(b,a,spdmileH);
plot(x,y,'LineWidth',1.5);
ylabel('Speed (M/H)');xlabel('Time (min)');
end 

if 0
a=1; b=[1/4 1/4 1/4 1/4];
y=filter(b,a,load_demand);
t= 1:length(load_demand);
figure
plot(t,load_demand,'-.',t,y,'-'), 
grid on
legend('Original Data','Shaped Data',2)
end

res=load_demand;
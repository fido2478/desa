function refitting
path='dat/';
datC=[];xval=[]; yval=[]; zval=[];
filename=[path 'dualfoil5CRE1.out'];
dat=readfile(filename);
redat=[];retime=[];

time5C=dat(1,1); vol5C=dat(4,1);dischar=dat(6,1);
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        time5C=[time5C dat(1,j)];
        vol5C=[vol5C dat(4,j)];
        dischar=[dischar dat(6,j)];
    end
end
ind=find(dischar<1);
k=[ind(1)];
for i=2:length(ind)
    if (ind(i)-ind(i-1)) > 1
        k=[k ind(i-1) ind(i)]; %k = index of dat
    end
end
k=[k ind(i)]; %points at which discharge rate changed

tail=floor((k(4)-k(3))*1/5);
zval=vol5C(k(3):k(4)-tail);
yval=time5C(k(3):k(4)-tail);
xval=1;
h=k(3);t=k(4)-tail;
for i=2:2:46
    filename=[path 'dualfoil5CRE' num2str(i) '.out'];
    dat=readfile(filename); %C10
    time5C=dat(1,1); vol5C=dat(4,1);
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            %time5C=[time5C dat(1,j)];
            vol5C=[vol5C dat(4,j)];
        end
    end
    zval=[zval; vol5C(h:t)];
    %yval=[yval; time5C(k(3):length(zval))];
    xval=[xval i];
end
figure
zval=zval';
p_w=polyfitweighted2(xval,yval,zval,17,zval);
hold on
for i=1:length(xval)
    H1=plot(yval,polyval2(p_w,xval(i),yval),':',yval,zval(:,i),'-'); %voltage
end
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recovery effect regression
filename=[path 'dualfoil5RE2.out']; %check dualfoil5RE and RE2 as well
dat=readfile(filename);
time10C=dat(1,1); vol10C=dat(4,1); dischar=dat(6,1);
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        time10C=[time10C dat(1,j)];
        vol10C=[vol10C dat(4,j)];
        dischar=[dischar dat(6,j)];
    end
end
figure
H1=plot(time10C,vol10C,'-'); %voltage
set(H1,'MarkerSize',10,'LineWidth',2);
legend('10A/m^2 to 100A/m^2');
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recovery efficiency regression
redat=[];retime=[];
ind=find(dischar<1);
k=[ind(1)];
for i=2:length(ind)
    if (ind(i)-ind(i-1)) > 1
        k=[k ind(i-1) ind(i)]; %k = index of dat
    end
end
k=[k ind(i)]; %points at which discharge rate changed

blen=k(3)-k(2)-1;
zlen=k(4)-k(1);
tail=floor((zlen-blen)*5/12)-1;
rec=vol10C(k(2):k(3)+tail);
tm=time10C(k(2):k(3)+tail);
zlen=length(rec);
for i=4:2:length(k)-2
    blen=zlen-(k(i+1)-k(i)-1);
    rec=[rec; vol10C(k(i):k(i+1)+blen-2)];
    tm=[tm; time10C(k(i):k(i+1)+blen-2)];
end
figure
hold on
rwcl=size(rec);
for i=1:rwcl(1)
    H1=plot(tm(i,:),rec(i,:),'-');
    set(H1,'MarkerSize',10,'LineWidth',2);
end
hold off
xlabel('Time (min)','FontSize',12);ylabel('Voltage','FontSize',12);
figure
xval=[10 20 30 40 50 60 70 80 90 100];
yval=tm(1,:);
zval=rec';
p_w=polyfitweighted2(xval,yval,zval,11,zval);
%voltage
H1=plot(yval,polyval2(p_w,xval(1),yval),':',tm(1,:),rec(1,:),'--'); %voltage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tail=floor((k(4)-k(3))*1/5);
rec2=vol10C(k(3):k(4)-tail);
tm2=time10C(k(3):k(4)-tail);
zlen=length(rec2);
for i=5:2:length(k)-1
    blen=(k(i+1)-k(i))-zlen+1;
    rec2=[rec2; vol10C(k(i):k(i+1)-blen)];
    tm2=[tm2; time10C(k(i):k(i+1)-blen)];
end
figure
xval=[10 20 30 40 50 60 70 80 90 100];
zval=rec2';
%voltage
hold on
if 0
min=Inf;indx=0; min_pw=0
pwvec=[];indxvec=[];
for i=4:6%length(xval)
    yval=tm2(1,:);
    for j=1:30
        p_w=polyfitweighted2(xval,yval,zval,i,zval); %24 is opt
        ev=polyval2(p_w,xval(i),yval)-rec2(i,:)'; %error vector
        perf=sse(ev);
        if min > perf
            min=perf; indx=j; min_pw=p_w;
        end
    end
    pwvec=[pwvec min_pw];
    indxvec=[indxvec indx];
    H1=plot(tm2(1,:),polyval2(min_pw,xval(i),yval),':',tm2(1,:),rec2(i,:),'--'); %voltage    
end
end %if 0
for i=4:6
    yval=tm2(i,:);
    min_pw=polyfitweighted2(xval,yval,zval,14,zval);
    H1=plot(tm2(1,:),polyval2(min_pw,xval(i),yval),':',tm2(1,:),rec2(i,:),'--'); %voltage
end
hold off
function res=coefffunC5to100vol
path='dat/';
%   Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%   (min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
coeff=[];
for i=5:5:100
    filename=[path 'dualfoil5C' num2str(i) '.out'];
    dat=readfile(filename); %C10
    switch i
        case 5 
            time5C=dat(1,:); vol5C=dat(4,:);
            [p, S]=polyfit(time5C,vol5C, 15);
            coeff=[coeff; p];YY=polyval(p, time5C);
        case 10 
            time10C=dat(1,:); vol10C=dat(4,:);
            [p, S]=polyfit(time10C,vol10C, 15);
            coeff=[coeff; p];YY=polyval(p, time10C);
        case 15 
            time15C=dat(1,:); vol15C=dat(4,:);
            [p, S]=polyfit(time15C,vol15C, 15);
            coeff=[coeff; p];YY=polyval(p, time15C);
        case 20 
            time20C=dat(1,:); vol20C=dat(4,:);
            [p, S]=polyfit(time20C,vol20C, 15);
            coeff=[coeff; p];YY=polyval(p, time20C);
        case 25
            time25C=dat(1,:); vol25C=dat(4,:);
            [p, S]=polyfit(time25C,vol25C, 15);
            coeff=[coeff; p];YY=polyval(p, time25C);
        case 30
            time30C=dat(1,:); vol30C=dat(4,:);
            [p, S]=polyfit(time30C,vol30C, 15);
            coeff=[coeff; p];YY=polyval(p, time30C);
        case 35 
            time35C=dat(1,:); vol35C=dat(4,:);
            [p, S]=polyfit(time35C,vol35C, 15);
            coeff=[coeff; p];YY=polyval(p, time35C);
        case 40 
            time40C=dat(1,:); vol40C=dat(4,:);
            [p, S]=polyfit(time40C,vol40C, 15);
            coeff=[coeff; p];YY=polyval(p, time40C);
        case 45 
            time45C=dat(1,:); vol45C=dat(4,:);
            [p, S]=polyfit(time45C,vol45C, 15);
            coeff=[coeff; p];YY=polyval(p, time45C);
        case 50 
            time50C=dat(1,:); vol50C=dat(4,:);
            [p, S]=polyfit(time50C,vol50C, 15);
            coeff=[coeff; p];YY=polyval(p, time50C);
        case 55
            time55C=dat(1,:); vol55C=dat(4,:);
            [p, S]=polyfit(time55C,vol55C, 15);
            coeff=[coeff; p];YY=polyval(p, time55C);
        case 60
            time60C=dat(1,:); vol60C=dat(4,:);
            [p, S]=polyfit(time60C,vol60C, 15);
            coeff=[coeff; p];YY=polyval(p, time60C);
         case 65 
            time65C=dat(1,:); vol65C=dat(4,:);
            [p, S]=polyfit(time65C,vol65C, 15);
            coeff=[coeff; p];YY=polyval(p, time65C);
        case 70 
            time70C=dat(1,:); vol70C=dat(4,:);
            [p, S]=polyfit(time70C,vol70C, 15);
            coeff=[coeff; p];YY=polyval(p, time70C);
        case 75 
            time75C=dat(1,:); vol75C=dat(4,:);
            [p, S]=polyfit(time75C,vol75C, 15);
            coeff=[coeff; p];YY=polyval(p, time75C);
        case 80 
            time80C=dat(1,:); vol80C=dat(4,:);
            [p, S]=polyfit(time80C,vol80C, 15);
            coeff=[coeff; p];YY=polyval(p, time80C);
        case 85
            time85C=dat(1,:); vol85C=dat(4,:);
            [p, S]=polyfit(time85C,vol85C, 15);
            coeff=[coeff; p];YY=polyval(p, time85C);
       case 90
            time90C=dat(1,:); vol90C=dat(4,:);
            [p, S]=polyfit(time90C,vol90C, 15);
            coeff=[coeff; p];YY=polyval(p, time90C);
        case 95
            time95C=dat(1,:); vol95C=dat(4,:);
            [p, S]=polyfit(time95C,vol95C, 15);
            coeff=[coeff; p];YY=polyval(p, time95C);
       case 100
            time100C=dat(1,:); vol100C=dat(4,:);
            [p, S]=polyfit(time100C,vol100C, 15);
            coeff=[coeff; p];YY=polyval(p, time100C);
    end
end
res=coeff;
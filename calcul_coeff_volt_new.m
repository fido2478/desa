function [coeff]=calcul_coeff_volt_new(st,en,refC)
% current unit = A/m2 but convert it to coulomb by division of 23
%[1-8], [9-18], [19-23], [24-34], [35-64], [65-80], [81-90],[91-100]
%st=91;en=100; 

coeff=[];
path='dat/';
%figure
%hold on
for k=st:en
    filename=[path 'dualfoil5C' num2str(k) '.out'];
    dat=readfile(filename); %C10
    timeX=[];timeY=[];
    ind=find(dat(4,1)>=refC.Y);
    if ~isempty(ind)
        timeX=[timeX dat(1,1)];
        timeY=[timeY refC.tX(ind(1))];
    end
    for j=2:length(dat(1,:))
        if dat(1,j)~=dat(1,j-1)
            ind=find(dat(4,j)>=refC.Y);
            if ~isempty(ind)
                timeX=[timeX dat(1,j)];
                timeY=[timeY refC.tX(ind(1))];
            end
        end
    end
    
    coeff=[coeff; polyfit(timeX,timeY,1)];
%    plot(timeX,timeY,timeX,polyval(polyfit(timeX,timeY,1),timeX),':','LineWidth',1);
end
%hold off

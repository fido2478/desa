function refC=Vref(filename);
nominal_capacity=3602.7;
dat=readfile(filename); %C10
time5C=dat(1,1); % for eval purpose
soc5C=1-dat(1,1)*(60.045/nominal_capacity)*(i/23);
vol5C=dat(4,1); %time is in minutes
for j=2:length(dat(1,:))
    if dat(1,j)~=dat(1,j-1)
        soc5C=[soc5C 1-dat(1,j)*(60.045/nominal_capacity)];
        time5C=[time5C dat(1,j)];
        vol5C=[vol5C dat(4,j)];
    end
end
refC=struct('p',opt_p(time5C,vol5C),'tX',time5C,'Y',vol5C,'sX',soc5C);
%[dev1, dev2]=differentiate(opt_p(time5C,vol5C),time5C);
%figure
%plot(dev2,'-');

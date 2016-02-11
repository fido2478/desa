function res=findpolyfunc4resist(scale)

filename='dat/resistance.txt';
fid = fopen(filename, 'r');
%Time     resistance
data=[];rdat=[];
data=fscanf(fid,'%f %e',[inf]);
fclose(fid);
for i=1:length(data)/2
    rdat(1,i)=data(i*2-1);
    rdat(2,i)=data(i*2);
end;

%scale=200;
mndat=min(rdat(1,:));mxdat=max(rdat(1,:));
ratio=scale/(mxdat-mndat);
%x=(mndat:(mxdat-mndat)/length(rdat(1,:)):mxdat)';

p = polyfit(rdat(1,:)*ratio,rdat(2,:),6);
f = polyval(p,rdat(1,:)*ratio);
%figure
%plot(rdat(1,:)*ratio,rdat(2,:), 'x', rdat(1,:)*ratio,f,'MarkerSize',5,'LineWidth',2);
res=p;

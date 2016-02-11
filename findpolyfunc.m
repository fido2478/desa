function res=findpolyfunc(scale,draw)

filename='dat/batcell.txt';
rdat=readfileold(filename);

%scale=200;
if scale>1
    mndat=min(rdat(1,:));mxdat=max(rdat(1,:));
    ratio=scale/(mxdat-mndat);
else
    ratio=1;
end
%x=(mndat:(mxdat-mndat)/length(rdat(1,:)):mxdat)';

p = polyfit(rdat(1,:)*ratio,rdat(2,:),3);
f = polyval(p,rdat(1,:)*ratio);
if draw > 0
figure
plot(rdat(1,:)*ratio,rdat(2,:), 'x', rdat(1,:)*ratio,f,'MarkerSize',5,'LineWidth',2);
end;
res=p;

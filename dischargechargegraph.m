function dischargechargegraph
filename='dat/dualfoil5C23dis23ch.out';
dat=readfile(filename); 
figure
len=length(dat(1,:));
ind=find(dat(1,:)==99.000);
plot(dat(1,ind(1):len)-dat(1,ind(1)),dat(4,ind(1):len));


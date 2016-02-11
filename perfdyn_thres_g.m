function perfdyn_thres_g
utilno=loadfile('dat/log/nodynthresg.txt','%f ',[4 Inf]);
util=loadfile('dat/log/dynthresg.txt','%f ',[4 Inf]);
diff=(util-utilno)./utilno;
x=[5:100]/23;
figure %thresgeffect.fig
bar(x,diff(1,:));
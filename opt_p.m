function min_p=opt_p(X, Y)
min=Inf;min_p=0;
for j=1:20
    p = polyfit(X,Y,j);
    ev=polyval(p,X)-Y;
    perf=sse(ev);
    if min > perf
        min=perf;min_p=p;
    end
end

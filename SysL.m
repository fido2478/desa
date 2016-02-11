function res=SysL(T, ns, np) %legacy system
    k=[];
    for i=1:np
        k=[k 1/i];
    end
    res=T/ns * sum(k);

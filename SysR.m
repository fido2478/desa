function res=SysR(T, ns, np) %reconfig system
    k=[];
    for i=ns:np*ns
        k=[k 1/i];
    end
    res=T* sum(k);

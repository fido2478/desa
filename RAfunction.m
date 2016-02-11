function res=RAfunction(etype,t,lambdaB,lambdaS,N,M,n,m,curPack,curArr)

switch etype
    case 'c1ppaba'
        eq7=1-(1-power((1-expcdf(t,1/(lambdaS*curArr))*expcdf(t,1/lambdaB)),n)...
            +1-binocdf(m,n,(1-expcdf(t,1/(lambdaS*curArr)))*expcdf(t,1/lambdaB)));      
        RAt=eq7;
        eq5=1-(1-power((1-expcdf(t,1/(lambdaS*curPack))*(1-RAt)),N)...
            +1-binocdf(M,N,(1-expcdf(t,1/(lambdaS*curPack)))*(1-RAt)));
        %eq5=1-binocdf(M-1,N,RAt);
        res=eq5;
    case {'c1ppcon','c3ppcon','c6sscon','c8sscon'}
        eq8=power(1-expcdf(t,1/lambdaB),n);
        RAt=eq8;
        eq6=power(RAt,N);
        res=eq6;
    case 'c1psaba'
        eq9=1-binocdf(m-1,n,(1-expcdf(t,1/(lambdaS*curArr)))*(1-expcdf(t,1/lambdaB)));
        RAt=eq9;
        eq5=1-(1-power((1-expcdf(t,1/(lambdaS*curPack))*(1-RAt)),N)...
            +1-binocdf(M,N,(1-expcdf(t,1/(lambdaS*curPack)))*(1-RAt)));
        %eq5=1-binocdf(M-1,N,RAt);
        res=eq5;
    case {'c1pscon','c3pscon','c6spcon','c8spcon'}
        eq10=1-binocdf(m-1,n,1-expcdf(t,1/lambdaB));
        RAt=eq10;
        eq6=power(RAt,N);
        res=eq6;
    case 'c2spaba'
        %eq7=1-binocdf(m-1,n,1-expcdf(t,1/lambdaB));  
        eq7=1-(1-power((1-expcdf(t,1/(lambdaS*curArr))*expcdf(t,1/lambdaB)),n)...
            +1-binocdf(m,n,(1-expcdf(t,1/(lambdaS*curArr)))*expcdf(t,1/lambdaB)));      
        RAt=eq7;
        eq11=1-binocdf(M-1,N,RAt*(1-expcdf(t,1/(lambdaS*curPack))));
        res=eq11;
    case {'c2spcon','c4spcon','c5pscon','c7pscon'}
        eq8=power(1-expcdf(t,1/lambdaB),n);
        RAt=eq8;
        eq12=1-binocdf(M-1,N,RAt);
        res=eq12;
    case {'c2ssaba','c3ppaba','c3psaba','c4spaba','c4ssaba','c6ssaba','c7ppaba','c7psaba','c8spaba','c8ssaba'}
        eq9=1-binocdf(m-1,n,(1-expcdf(t,1/(lambdaS*curArr)))*(1-expcdf(t,1/lambdaB)));
        RAt=eq9;
        eq11=1-binocdf(M-1,N,RAt*(1-expcdf(t,1/(lambdaS*curPack))));
        res=eq11;
    case {'c2sscon','c4sscon','c5ppaba','c5ppcon','c7ppcon'}
        eq10=1-binocdf(m-1,n,1-expcdf(t,1/lambdaB));
        RAt=eq10;
        eq12=1-binocdf(M-1,N,RAt);
        res=eq12;
    case {'c5psaba'}
        eq9=1-binocdf(m-1,n,(1-expcdf(t,1/(lambdaS*curArr)))*(1-expcdf(t,1/lambdaB)));
        RAt=eq9;
        eq12=1-binocdf(M-1,N,RAt);
        res=eq12;
    case {'c6spaba'}
        eq10=1-binocdf(m-1,n,1-expcdf(t,1/lambdaB));
        RAt=eq10;
        eq11=1-binocdf(M-1,N,RAt*(1-expcdf(t,1/(lambdaS*curPack))));
        res=eq11;
end
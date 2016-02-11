function [com, dis]=leastcom(A,B)
alen=length(A); blen=length(B);
sA=sort(A);sB=sort(B);
com=[]; dis=[];
i=1;j=1;
while (i<=alen) & (j<=blen)
    if sA(i) < sB(j)
        dis=[dis sA(i)];
        i=i+1;
    elseif sA(i)==sB(j)
        com=[com sA(i)];
        i=i+1;j=j+1;
    else
        dis=[dis sB(j)];
        j=j+1;
    end
end
if i<=alen
    dis=[dis sA(i:alen)];
end
if j<=blen
    dis=[dis sB(j:blen)];
end
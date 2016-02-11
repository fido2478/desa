function mer=merge(A,B)
alen=length(A); blen=length(B);
sA=sort(A);sB=sort(B);
mer=[];
i=1;j=1;
while (i<=alen) & (j<=blen)
    if sA(i) < sB(j)
        mer=[mer sA(i)];
        i=i+1;
    elseif sA(i)==sB(j)
        mer=[mer sA(i)];
        i=i+1;j=j+1;
    else
        mer=[mer sB(j)];
        j=j+1;
    end
end
if i<=alen
    mer=[mer sA(i:alen)];
end
if j<=blen
    mer=[mer sB(j:blen)];
end
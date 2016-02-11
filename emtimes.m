function res=emtimes(A, B)
rwcl1=size(A);
rwcl2=size(B);
m=[];k=[];
for i=1:rwcl1(2)
    m=[m; k];
    k=[];
    for j=1:rwcl2(2)
        k=[k A(i)*B(j)];
    end
end
res=m;
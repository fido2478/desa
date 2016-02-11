function [batpack etimebp]=drawing(batpack,etimebp,squeue,load, coeff,dt)
k=length(squeue);
for i=1:k%time/k in parallel assuming time proportion to load
    volt=voltfun(coeff,load,etimebp(squeue(i))+dt/k); 
    batpack(squeue(i))=volt;
    etimebp(squeue(i))=etimebp(squeue(i))+dt/k;
end

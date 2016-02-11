function res=voltfun(coeff,load,time)
l=load/5;
adtime=5/load * time;
volt=polyval(coeff(l,:),adtime);
res=volt;
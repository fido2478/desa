function [volt, cap]=VCgraph(volt,cap,refC,coeff,disCoulombs,dura,max_cap)
soc=cap/max_cap;
ti=0;
ind=find(refC.sX<=soc);
if ~isempty(ind)
    ti=refC.tX(ind(1));
end

yy=round(disCoulombs)*23;
if yy > 100
    yy=100
elseif yy<1
    yy=1
end
p=coeff(yy,:); % A/m2
dt=polyval(p,ti+round(dura/60))-polyval(p,ti); %min time vs time
dV=polyval(refC.p,ti)-polyval(refC.p,ti+abs(dt)); %time vs voltage

volt=volt-abs(dV);
cap=cap-disCoulombs*dura;
function res=iccps10jrl_get_ssp_markov(e,f,p,D)

p12=e;
p21=power(e,f);p23=p;p32=p/D;p24=e;
p31=p;p32=p/D;p35=power(e,f/D);
p42=power(e,f);p45=p;p47=power(e,f);
p54=p/D;p52=p;p56=p;p58=power(e,f/D);
p63=p;p65=p/D;p69=power(e,f/D);
p74=power(e,f);p78=p;
p87=p/D;p84=p;p89=p;
p98=p/D;p95=p;p90=p;
p09=p/D;p06=p;

p46=p;p64=p/D;p70=p;p07=p/D;

if ((p21+p23+p24)>=1|(p42+p46+p47)>=1|(p07+p06)>=1|(p31+p32+p35)>=1|...
    (p54+p52+p58+p56)>=1|(p87+p84+p89)>=1|(p98+p95+p90)>=1|(p09+p06)>=1)
    out='the sum of the probabilities of outgoing edges is greater than 1'
    return
end

ks2=['-(',num2str(p21+p24+p23),')*s2+',num2str(p12),'*s1+',...
    num2str(p42),'*s4+',num2str(p52),'*s5+',num2str(p32),'*s3'];
ks3=['-(',num2str(p32+p31+p35),')*s3+',num2str(p23),'*s3+',...
    num2str(p63),'*s6'];
ks4=['-(',num2str(p42+p47+p45),')*s4+',num2str(p24),'*s2+',...
    num2str(p54),'*s5+',num2str(p74),'*s7+',num2str(p84),'*s8'];
ks5=['-(',num2str(p54+p56+p52+p58),')*s5+',num2str(p35),'*s3+',...
    num2str(p45),'*s4+',num2str(p65),'*s6+',num2str(p95),'*s9'];
ks6=['-(',num2str(p63+p65+p69),')*s6+',num2str(p56),'*s5+',...
    num2str(p06),'*s0'];
ks7=['-(',num2str(p74+p78),')*s7+',num2str(p47),'*s4+',...
    num2str(p87),'*s8'];
ks8=['-(',num2str(p87+p84+p89),')*s8+',num2str(p78),'*s7+',...
    num2str(p58),'*s5+',num2str(p98),'*s9'];
ks9=['-(',num2str(p98+p95+p90),')*s9+',num2str(p89),'*s8+',...
    num2str(p69),'*s6+',num2str(p09),'*s0'];
ks0=['-(',num2str(p09+p06),')*s0+',num2str(p90),'*s9'];

AA=solve(ks2,ks3,ks4,ks5,ks6,ks7,ks8,ks9,ks0,...
's1+s2+s3+s4+s5+s6+s7+s8+s9+s0-1',...
's1','s2','s3','s4','s5','s6','s7','s8','s9','s0');

ks2=['-(',num2str(p21+p23+p24),')*t2+',num2str(p12),'*t1+',...
    num2str(p32),'*t3+',num2str(p42),'*t4'];
ks3=['-(',num2str(p31+p32),')*t3+',num2str(p23),'*t2+',...
    num2str(p63),'*t6'];
ks4=['-(',num2str(p42+p46+p47),')*t4+',num2str(p24),'*t2+',...
    num2str(p64),'*t6+',num2str(p74),'*t7'];
ks6=['-(',num2str(p63+p64),')*t6+',num2str(p46),'*t4+',...
    num2str(p06),'*t0'];
ks7=['-(',num2str(p74+p70),')*t7+',num2str(p47),'*t4+',...
    num2str(p07),'*t0'];
ks0=['-(',num2str(p06+p07),')*t0+',num2str(p70),'*t7'];

BB=solve(ks2,ks3,ks4,ks6,ks7,ks0,'t1+t2+t3+t4+t6+t7+t0-1',...
't1','t2','t3','t4','t6','t7','t0');

desaSSP=double([AA.s1 AA.s2 AA.s3 AA.s4 AA.s5 AA.s6 AA.s7 AA.s8 AA.s9 AA.s0]);
legacySSP=double([BB.t1 BB.t2 BB.t3 BB.t4 0 BB.t6 BB.t7 0 0 BB.t0]);

SSP=[desaSSP' legacySSP'];
%figure
%bar(SSP);

pcmat=[0 0 1 0 1 2 0 1 2 3];

pcdesa=sum(desaSSP.*pcmat);
pclegacy=sum(legacySSP.*pcmat);

%power efficiency gain (peg); the greater, the better
peg=1-sum(desaSSP.*pcmat)/sum(legacySSP.*pcmat); 
res=[desaSSP;legacySSP];
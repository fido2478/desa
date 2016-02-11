%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%



e=0.1; f=10; p=0.3; D=2;
pe=e;pp=p;ppeg=0;pdesaSSP=[];plegacySSP=[];
pegarr=[];


for e=0.01:0.02:0.10
    for p=0.1:0.02:0.30
        for f=6:9
            for D=1:f-2
                peg=iccps10jrl_markov_model(e,f,p,D);
                if peg > ppeg
                    ppeg=peg;
                    pe=e;pp=p;
                    pD=D;pf=f;
                end
            end
        end
    end
end

fid=fopen('iccps10res.txt','w+');
fprintf(fid,'%f %d %f %d\n',[pe pf pp pD]);
%fprintf(fid,'%f\n',pdesaSSP);
%fprintf(fid,'%f\n',plegacySSP);
fclose(fid);

ssp=iccps10jrl_get_ssp_markov(pe,pf,pp,pD);
fid=fopen('iccps10ssp.txt','w+');
fprintf(fid,'%f %f\n',ssp);
fclose(fid);

%0.5958 0.1986 0.0527 0.0862 0.0398 0.0265 0.0000 0.0001 0.0001 0.0001
%0.4948 0.1856 0.1649 0.0928      0 0.0619 0.0000      0      0 0.0000


fid=fopen('iccps10ssp.txt','r');
ssp=fscanf(fid,'%f %f',[2 inf]);
fclose(fid);

pD=2;pegarr=[];
for pf=2:0.5:10
    pegarr=[pegarr iccps10jrl_markov_model(pe,pf,pp,pD)];
end
figure
plot([2:0.5:10],pegarr);
 
pegarr=[];
for pD=1:0.5:pf
    pegarr=[pegarr iccps10jrl_markov_model(pe,pf,pp,pD)];
end
figure
plot([1:0.5:pf],pegarr);

pf=6;pp=0.3;pD=2;
pegarr=[];
for pe=0.01:0.02:0.15
    pegarr=[pegarr iccps10jrl_markov_model(pe,pf,pp,pD)];
end
figure
plot([0.01:0.02:0.15],pegarr);
    
pf=6;pe=0.05;pD=2;
pegarr=[];
for pp=0.01:0.02:0.35
    pegarr=[pegarr iccps10jrl_markov_model(pe,pf,pp,pD)];
end
figure
plot([0.01:0.02:0.35],pegarr);

pf=6;pp=0.3;pD=2;pe=0.1;
ssp=iccps10jrl_get_ssp_markov(pe,pf,pp,pD);
fid=fopen('iccps10ssp.txt','w+');
fprintf(fid,'%f %f\n',ssp);
fclose(fid);

%0.5958 0.1986 0.0527 0.0862 0.0398 0.0265 0.0000 0.0001 0.0001 0.0001
%0.4948 0.1856 0.1649 0.0928      0 0.0619 0.0000      0      0 0.0000


fid=fopen('iccps10ssp.txt','r');
ssp=fscanf(fid,'%f %f',[2 inf]);
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
sym('s1','real');sym('s2','real');sym('s3','real');sym('s4','real');
sym('s5','real');sym('s6','real');sym('s7','real');sym('s8','real');
sym('s9','real');sym('s0','real');
sym('p12','real');sym('p21','real');sym('p23','real');sym('p24','real');
sym('p31','real');sym('p32','real');sym('p35','real');
sym('p42','real');sym('p45','real');sym('p47','real');
sym('p54','real');sym('p52','real');sym('p56','real');sym('p58','real');
sym('p63','real');sym('p65','real');sym('p69','real');
sym('p74','real');sym('p78','real');
sym('p87','real');sym('p84','real');sym('p89','real');
sym('p98','real');sym('p95','real');sym('p90','real');
sym('p09','real');sym('p06','real');

sym('t1','real');sym('t2','real');sym('t3','real');sym('t4','real');
sym('t6','real');sym('t7','real');sym('t0','real');
sym('q12','real');sym('q21','real');sym('q23','real');sym('q24','real');
sym('q31','real');sym('q32','real');
sym('q42','real');sym('q46','real');sym('q47','real');
sym('q63','real');sym('q64','real');
sym('q74','real');sym('q70','real');
sym('q07','real');sym('q06','real');
end

if 0
B=solve('-(0.1+0.2+0.3)*t2+0.3*t1+0.1*t3+0.1*t4',...
    '-(0.2+0.1)*t3+0.2*t2+0.2*t6','-(0.1+0.2+0.3)*t4+0.3*t2+0.1*t6+0.1*t7',...
    '-(0.2+0.1)*t6+0.2*t4+0.2*t0','-(0.1+0.2)*t7+0.3*t4+0.1*t0',...
    '-(0.2+0.1)*t0+0.2*t7','t1+t2+t3+t4+t6+t7+t0-1',...
    't1','t2','t3','t4','t6','t7','t0')
BB=solve('-(q21+q23+q24)*t2+q12*t1+q32*t3+q42*t4',...
    '-(q31+q32)*t3+q23*t2+q63*t6','-(q42+q46+q47)*t4+q24*t2+q64*t6+q74*t7',...
    '-(q63+q64)*t6+q46*t4+q06*t0','-(q74+q70)*t7+q47*t4+q07*t0',...
    '-(q06+q07)*t0+q70*t7','t1+t2+t3+t4+t6+t7+t0-1',...
't1','t2','t3','t4','t6','t7','t0')
end
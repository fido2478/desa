function pw=hashing(min_pw,disch)
len=length(min_pw);pw=0;
for i=1:len
    if disch <= min_pw(i).id %because [inx(i+1)-1 pw]
        pw=min_pw(i).pw;
        break;
    end
end
        
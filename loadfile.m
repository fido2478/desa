function res=loadfile(fname,arg,dsize)
fid=fopen(fname,'r');
res=fid;
if fid>=0
    res=fscanf(fid,arg,dsize);
    fclose(fid);
end
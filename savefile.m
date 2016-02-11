function res=savefile(data,arg,fname)
fid=fopen(fname,'w');
res=fid;
if fid>=0
    fprintf(fid,arg,data);
    fclose(fid);
end
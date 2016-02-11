function res=readfile(filename)
fid = fopen(filename, 'r');
%Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%(min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
data=[];
%while feof(fid) == 0
    data=fscanf(fid,'%f %*f %*f %f %*f %*f %*f %*f',[inf]);
%end;
fclose(fid);
for i=1:length(data)/2
    rdat(1,i)=data(i*2-1);
    rdat(2,i)=data(i*2);
end;
res=rdat;
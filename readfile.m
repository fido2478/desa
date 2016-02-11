function res=readfile(filename)
fid = fopen(filename, 'r');
if fid<0
    filename
    return
end;
%Time     Util N  Util P  Cell Pot   Uocp      Curr      Temp   heatgen
%(min)       x       y      (V)       (V)      (A/m2)    (C)    (W/m2)
data=[];
while feof(fid) == 0
    tline = fgetl(fid);
    % get the time interval if possible
    if findstr(tline,'(min)')
        tline = fgetl(fid);
        break;
    end
end
tline = fgetl(fid);%skip an empty line
while isempty(findstr(tline,'mass'))
    if isempty(tline)
        tline = fgetl(fid);
        continue;
    end;
    if findstr(tline,'specific')
        tline = fgetl(fid);
        tline = fgetl(fid);
        tline = fgetl(fid);
        tline = fgetl(fid);
        continue;
    end
    comma=findstr(tline,',');
    tline(comma)=' ';
    data=[data sscanf(tline,'%f %f %f %f %f %f %f %f')];
    tline = fgetl(fid);
end;
fclose(fid);
res=data;
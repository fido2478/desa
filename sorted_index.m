function sp=sorted_index(avail_pack)
% return index array
sp=[];
if isempty(avail_pack)
    return;
end;
while length(sp) < length(avail_pack)
    ind=find(max(avail_pack)==avail_pack);
    if ~isempty(ind)
        sp=[sp ind];
        avail_pack(ind)=0;
    end  
end
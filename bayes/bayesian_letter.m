a = [1:16];
for i=4:15
    fi = combntns(a,i);
    for j=1:size(fi, 1)
        rs = bayesianf(fi(j,:));
        str(j).value = rs;
        str(j).list = fi(j,:);
    end
    s_str = sort([str.value], 'descend');
    rs = s_str(1);
    idx = find([str.value] == rs);
    str(idx)
end 
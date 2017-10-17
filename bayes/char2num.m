function rs=char2num(mat)
%char2num convert char array to number (int32)
%rs result
markZero = int32('0');
s = cell2mat(mat);
l = length(s);
r = 0;
for i=1:l
    r = r * 10 + double(s(i)) - markZero;
end
rs = r;


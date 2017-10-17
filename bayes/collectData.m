function [DataSet,index]=collecetData()
% read dataset from file which named letter-recognition.data.txt
% Return a Three-dimention matrix
fp = fopen('letter-recognition.data.txt', 'r');
markA = int32('A');
index = zeros(1,int32('Z') - int32('A') + 1);
DataSet=[];
for i=1:26
    for j=1:800
        for k=1:16
            DataSet(i,j,k) = 0;
        end
    end
end
while feof(fp) ~= 1
    fline = fgetl(fp);
    str = regexp(fline, ',', 'split');
    %str = strfind(fline, ',');
    l = int32(length(str));
    num1 = double(cell2mat(str(1))) - markA + 1;
    index(num1) = index(num1) + 1;
    idx = index(num1);
    vx = zeros(1, 16);
    for i=2:l
           vx(i - 1) = str2num(cell2mat(str(i)));
    end
    DataSet(num1,idx,:) = vx;
    sv = DataSet(num1, idx, :);
end
fclose(fp);



addr = 'C:\\Users\\EP\\Desktop\\vgg_face_dataset\\files';
fname = {'Adam_Levine.txt.rt', 'Taylor_Swift.txt.rt'};
[trainset, y, testset, yy] = dataprocess(addr, fname);
f_dims = size(trainset,2);
tr_n = size(trainset,1);
te_n = size(testset, 1);
w = zeros(1,f_dims);
yita = 1;
c =1;
cc = 1000;
[lambda, fval, exitflag] = svm_simple(tr_n, f_dims, trainset, y,c,cc);

for i=1:tr_n
    w = w + lambda(i) * y(i) * reshape(trainset(i,:),1, f_dims);
end
l = find(lambda ~= 0);
p = l(1);
b = -1* w*trainset(p,:)';

cor = 0;
for i=1:te_n
    c = -1;
    g = 0;
    d = 2;
    x = testset(i,:);
    %for j=1:tr_n
    %    tx = reshape(trainset(j,:),1, f_dims);
    %    g = g+ lambda(i) * y(i) * Kernal(tx, x,6);
    %end
    %g = w*x' + b ;
    %g = Kernel(x,w,3) + b 
    %g = g + b;
    g = g + b;
    if g>0
        c = 1;
    end
    if c == yy(i)
        cor = cor + 1;
    end
end
cor / te_n


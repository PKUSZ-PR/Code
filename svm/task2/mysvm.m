addr = 'C:\\Users\\EP\\Desktop\\vgg_face_dataset\\files';
fname = {'Adam_Levine.txt.rt', 'Taylor_Swift.txt.rt'};
[trainset, y, testset, yy] = dataprocess(addr, fname);
f_dims = size(trainset,2);
tr_n = size(trainset,1);
te_n = size(testset, 1);
w = zeros(1,f_dims);
yita = 0.1; 
cc = 0.1;
[lambda, fval, exitflag] = svm_simple(tr_n, f_dims, trainset, y, yita,cc);

for i=1:tr_n
    w = w + lambda(i) * y(i) * reshape(trainset(i,:),1, f_dims);
end
l = find(lambda > 0.02);
p = l(1);
b = 0;
for i = 1:size(l,1)
    p = l(i);
    b = b + y(p) - w*trainset(p,:)';
end
b = b / size(l,1);
cor = 1;
for i=1:te_n
    c = -1;
    x = 0;
    d = 3;
    x = testset(i,:);
    r = 2;
    for j=1:tr_n
        tx = reshape(trainset(j,:),1, f_dims);
        x = x + lambda(i) * y(i) * kernel(tx, x,d);
    end
    %g = w*x' + b ;
    %g = Kernel(x,w,3) + b 
    g = x + b;
   
    if g>0
        c = 1;
    end
    if c == yy(i)
        cor = cor + 1;
    end
end
cor / te_n


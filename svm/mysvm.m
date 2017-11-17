[trainset, y, testset, yy] = dataprocess();
f_dims = size(trainset,2);
tr_n = size(trainset,1);
te_n = size(testset, 1);
w = zeros(f_dims);
yita = 1;

[lambda, fval, exitflag] = svm_simple(tr_n, f_dims, trainset, y);

for i=1:tr_n
    w = w + lambda(i) * y(i) * reshape(trainset(i,:),1, f_dims);
end
l = find(lambda ~= 0);
p = l(1);
b = yita / y(p) - w*trainset(p,:)';

cor = 0;
for i=1:te_n
    c = -1;
    x = testset(i,:);
    g = w*x' + b ;
    if g>0
        c = 1;
    end
    if c == yy(i)
        cor = cor + 1;
    end
end
cor / testset


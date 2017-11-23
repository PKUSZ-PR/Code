%Function%
%dataset

ndims = size(dataset, 2);
num = size(dataset, 1);
lam = sym('lam', [1, num]);
f = 0;
g1 = 0, g2 = 0;
for i=1:num
    x = dataset(:,1)
    f = f + lam[i];
    g1 =  x' * lam[i] * y[i];
    g2 = x * lam[i] * y[i];
end
L = f - 0.5 * g1 & g2;




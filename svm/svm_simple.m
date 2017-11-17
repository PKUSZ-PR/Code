function [x, fval, exitflag] = svm_simple(N, n, data, y)
% N number of sample
% n dimensions of features
% data dataset
% y class of samples
H = zeros(N, N);
f = ones(N,1);
Aeq = zeros(N, N);
beq = zeros(N,1);
lb = zeros(N,1);
ub = [];
for i=1:N
    Aeq(i, :) = y(1,:);
    for j=1:N
        val = 0;
        for k=1:n
            val = val + y(i)*data(i,k) + y(j)*data(j,k);
        end
        H(i, j) = val;
    end
end
[x, fval, exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,ub);

    
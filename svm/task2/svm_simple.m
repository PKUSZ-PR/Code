function [x, fval, exitflag] = svm_simple(N, n, data, y, c,cc)
% N number of sample
% n dimensions of features
% data dataset
% y class of samples
H = zeros(N, N);
f = ones(N,1) *c * -1;
%f = ones(1,N) *c;
Aeq = ones(1, N);
beq = zeros(1,1);
%beq = zeros(1,N);
lb = zeros(N,1);
%lb = zeros(1,N);
ub = ones(N,1)*cc;
%ub = ones(1,N)*cc;
for i=1:N
    Aeq(i) = Aeq(i) * y(i);
    for j=1:N
        val = 0;
        for k=1:n
            val = val + data(i,k) *data(j,k);
        end
        H(i, j) =-0.5 * val * y(i) * y(j);
    end
end
H = H * -1;
[x, fval, exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,ub);
%[x, fval, exitflag] = quadprog(H,f,[],[],Aeq,beq,lb,[]);
%[x, fval, exitflag] = bintprog(H,f,[],[],Aeq,beq,lb,[]);

    
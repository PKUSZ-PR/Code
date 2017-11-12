function rs=bayesianf(a_vec)
[DataSet,total_vec]  = collectData(); %Get data from function collectData
markA = int32('A'); %ACSII code of letter 'A'
markZ = int32('Z'); %ACSII code of letter 'Z'
n = size(a_vec, 2);
for i=1:(markZ - markA + 1)
    for j=1:total_vec(i)
        v = DataSet(i,j,a_vec);
        DataSets(i,j,:) = v;
    end
end

% Select parts of data to construct training set 
trainNum = 16000;
tn = trainNum;
vec_tn = zeros(1, markZ - markA + 1); % A vector to store the number of classes of letter
for i=1:markZ - markA
    rn = int32(round(rand(1,1)*50)+600);
    vec_tn(i) = rn;
    tn = tn -rn;
end
vec_tn(markZ - markA + 1) = tn;

%The parameters to solve the problem
pwi = zeros(1,markZ - markA + 1); % the probality of each class
sigma = []; % Convariance Matrix
sigma_det = zeros(1,markZ - markA + 1); %Det of convariance matrix
u = zeros(markZ - markA + 1, n); % mean value of vectors of each class
for i=1:(markZ - markA + 1)
    for j=1:n
        for k=1:n
            sigma(i,j,k) = 0; %convariace matrix of every class
        end
    end
end

%Calculate pwi, sigma and sigma_det
for i=1:(markZ - markA + 1)
       pwi(i) = vec_tn(i) / trainNum;
       tmp_mat = zeros(vec_tn(i), n);
       x =  zeros(1,n);
       for j=1:vec_tn(i)
           x = x + reshape(DataSets(i,j,:), 1, n);
           tmp_mat(j,:) = DataSets(i,j,:);
       end
       u(i,:) = x / vec_tn(i);
       cov_ = cov(tmp_mat);
       sigma(i,:,:) = cov_;
       i_cov = inv(cov_); %inverse matrix of simga
       sigma_det(i) = double(det(cov_));
end

%Start to test
%g_x is discrimenant function 
testNum = 4000;
correct = 0;
output = zeros(markZ - markA + 1, 400);
for i=1:markZ - markA + 1
    for j=vec_tn(i) + 1: total_vec(i)
        x = DataSets(i,j,:);
        idx = i;
        for k = 1:markZ - markA + 1 
            if k ~= i
                rs1 = g_x(pwi(idx), sigma(idx,:,:), sigma_det(idx), x, u(idx,:));
                rs2 = g_x(pwi(k), sigma(k,:,:), sigma_det(k), x, u(k,:));
                if rs1 < rs2
                    idx = k;
                end
            end
        end
        if idx == i
            correct = correct + 1;
        end
    end
end
%Accurancy of our classifier
rs = correct / testNum;
        

                
                
                

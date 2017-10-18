%Load training sample
trainLables = loadMNISTLabels('train-labels-idx1-ubyte');
trainImages = loadMNISTImages('train-images-idx3-ubyte');
[pc,score,latent,tsquare] = pca(trainImages'); %use pca function to extract decrease dims from 28*28 to 108
trainImages = pc(:,1:108)' * trainImages;

totalNum = zeros(1, 10);
pwi = zeros(1, 10);
trainNum = 60000;
nrow = size(trainImages, 1);
sigma = [];
u = zeros(10, nrow );
tmpMat = [];
sigma_det = zeros(1, 10);
for i=1:10
    sigma(:,:,i) = zeros(nrow , nrow);
    tmpMat(:,:,i) = zeros(8000, nrow);
end


for i=1:size(trainLables, 1)
        idx = trainLables(i);
        totalNum(idx + 1) = totalNum(idx + 1) + 1;
        x = trainImages(:, i)';
        u(idx + 1,:) = u(idx + 1,:) + x;
        tmpMat(totalNum(idx + 1),:, idx + 1) = x;
end
%Calculate the prior probability of class and mean vectors
for i=1:10
    pwi(i) = vpa(totalNum(i) / trainNum, 10);
    u(i,:) = vpa(u(i,:) / totalNum(i),10);
end
for i=1:size(totalNum,2)
    tmp_mat = zeros(totalNum(i), nrow );
    for j=1:totalNum(i)
        x = reshape(tmpMat(j,:, i), 1, nrow);
        tmp_mat(j,:) = x;
    end

    sigma_tmp = cov(tmp_mat);
    sigma_det(i) = det(sigma_tmp);
    sigma(:,:,i) =  sigma_tmp;
end
%Load test samples and start to test
%g_x is discrimenant function
testLables = loadMNISTLabels('t10k-labels-idx1-ubyte');
testImages = loadMNISTImages('t10k-images-idx3-ubyte');
testImages = pc(:,1:108)' * testImages;
testNum = 10000;
correct = 0;
for i=1:testNum
    idx = testLables(i) + 1;
    c_i = idx;
    x = testImages(:,i)';
    for j=1:10
        sig1 = permute(sigma(:,:,idx), [3,2,1]);
        sig2 = permute(sigma(:,:,j), [3,2,1]);
        rs1 = g_x2(pwi(idx),sig1, sigma_det(idx),x,u(idx,:));
        rs2 = g_x2(pwi(j),sig2, sigma_det(j),x,u(j,:));
        if rs2 > rs1
            idx = j;
        end
    end
    if c_i == idx
        correct = correct + 1;
    end
end
%Accurancy of our bayesian classifier
rs = correct / testNum
        
        
        
trainLables = loadMNISTLabels('train-labels-idx1-ubyte');
trainImages = loadMNISTImages('train-images-idx3-ubyte');
select_list = [1,3:26,27]; %select parts of the features
for j = 1:size(trainImages,2)
    id = 1;
    while(id <= size(trainImages, 1))
        for i = 1:27
            trainImages(id,j) = trainImages(i + id,j) + trainImages(id, j);
        end
        id = id + 28;
    end
    id = 1;
    while(id <= size(trainImages, 1))
        re = fix(id/28) + 1;
        trainImages(re,j) = trainImages(id,j);
        id = id + 28;
    end
end
            
%     for i=1:28
%         id = i + 28;
%         while(id <= size(trainImages,1))
%             trainImages(i,j) = trainImages(i,j) + trainImages(id, j);
%             id = id + 28;
%         end
%     end

trImages = zeros(28, size(trainImages,2));
for i =1:28
    for j = 1:size(trainImages,2)
        trImages(i,j) = trainImages(i,j);
    end
end
tImages=[];
tImages(:,:) = trImages(select_list,:);

totalNum = zeros(1, 10);
pwi = zeros(1, 10);
trainNum = 60000;
nrow = size(tImages, 1);
ncol = size(tImages, 1);
sigma = [];
u = zeros(10, nrow );
tmpMat = [];
sigma_det = zeros(1, 10);
for i=1:10
    sigma(:,:,i) = zeros(nrow, nrow);
    tmpMat(:,:,i) = zeros(8000, nrow);
end

for i=1:size(trainLables, 1)
        idx = trainLables(i);
        totalNum(idx + 1) = totalNum(idx + 1) + 1;
        x = tImages(:, i)';
        u(idx + 1,:) = u(idx + 1,:) + x;
        tmpMat(totalNum(idx + 1),:, idx + 1) = x;
end
for i=1:10
    pwi(i) = vpa(totalNum(i) / trainNum, 10);
    u(i,:) = vpa(u(i,:) / totalNum(i),10);
end
for i=1:size(totalNum,2)
    tmp_mat = zeros(totalNum(i), nrow);
    for j=1:totalNum(i)
        x = reshape(tmpMat(j,:, i), 1, nrow);
        tmp_mat(j,:) = x;
    end
    sigma_tmp = vpa(cov(tmp_mat), 7);
    sigma_det(i) = vpa(det(sigma_tmp), 7);
    sigma(:,:,i) = vpa(sigma_tmp, 7);
%     sigma_tmp = cov(tmp_mat);
%     sigma_det(i) = det(sigma_tmp);
%     sigma(:,:,i) =  sigma_tmp;
end
sigma = sigma * 10000;
testLables = loadMNISTLabels('t10k-labels-idx1-ubyte');
testImages = loadMNISTImages('t10k-images-idx3-ubyte');
% for j = 1:size(testImages,2)
%     for i=1:28
%         id = i + 28;
%         while(id <= size(testImages,1))
%             testImages(i,j) = testImages(i,j) + testImages(id, j);
%             id = id + 28;
%         end
%     end
% end
for j = 1:size(testImages,2)
    id = 1;
    while(id <= size(testImages, 1))
        for i = 1:27
            testImages(id,j) = testImages(i + id,j) + testImages(id, j);
        end
        id = id + 28;
    end
    id = 1;
    while(id <= size(testImages, 1))
        re = fix(id/28) + 1;
        testImages(re,j) = testImages(id,j);
        id = id + 28;
    end
end
teImages = zeros(28, size(testImages,2));
for i =1:28
    for j = 1:size(testImages,2)
        teImages(i,j) = testImages(i,j);
    end
end
tImages=[];
tImages(:,:) = teImages(select_list,:); 

testNum = 10000;
correct = 0;
for i=1:testNum
    idx = testLables(i) + 1;
    c_i = idx;
    x = tImages(:,i)';
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

rs = correct / testNum
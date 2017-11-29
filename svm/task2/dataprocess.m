function [dataset, y, trainset, yy] = dataprocess(addr, fname)
%To process the image into a 150*200 gray picture
n = 1;
box = [150, 200];
str_size = box(1) * box(2);
features = zeros(2000,7);
ys = ones(2000,1);
n_dataset = zeros(2000,str_size);
samp_size = zeros(1,size(fname,2) + 1);
n_file = size(fname,2);
k = round(0);
for i = 1:size(fname, 2)
    fn = fname{i};
    tfname = [addr, '\\', fn];
    fp = fopen(tfname, 'r');
    while feof(fp)~=1
        fl = fgetl(fp);
        s = regexp(fl, '#', 'split');
        for j = 1:size(s, 2)
            tmp = str2double(s{j});
            features(n, j) = tmp;
        end
        n  = n+1;
        if i == 1
            ys(i) = -1;
        end
    end
    base = samp_size(i) - k;
    samp_size(i) = n - 1 - samp_size(i);
    samp_size(i + 1) = sum(samp_size(1:i));
    ss = fname{i};
    s1 = regexp(ss, '\.', 'split');
    tfname = [addr, '\\', s1{1}, '\\', '*.jpg'];
    pic_addr = [addr, '\\', s1{1}, '\\'];
    pics = dir(tfname);
    len = samp_size(i); 
    k = 0;
    for j = 1:len
        img = (imread([pic_addr,pics(j).name]));
        %img = rgb2gray(imread([pic_addr,pics(j).name]));
        if size(img,2) == 1 && size(img,1) == 1
            k = k + 1;
            continue;
        end
        size(img)
        fea = features(base + j,:)
        m1 = max([fea(2), fea(4)]);
        m2 = max([fea(1), fea(3)]);
        if m1 > size(img,1) || m2 > size(img,2)
            k = k + 1;
            continue;
        end
        img = img(int32(fea(2)):min([size(img,1),int32(fea(4))]),int32(fea(1)):min([int32(fea(3)), size(img,2)])); 
        %img = img(int32(fea(2)):min([size(img,1),int32(fea(4))]),int32(fea(1)):min([int32(fea(3)), size(img,2),1:3]));
        %imshow(img)
        %box = [box(1), box(2), 3];
        img = imresize(img, box);
        tmp_x = reshape(img, 1,box(1)*box(2));
        %tmp_x = reshape(img, 1,box(1)*box(2)*box(3));
        bdx = k + base;
        n_dataset(j + base - k,:) = tmp_x;
        %n_dataset(bdx,:) = tmp_x;
        %k = k+1;
    end
    samp_size(i) = len - k;
end
exp  = zeros(1,size(fname,2));
for i=1:size(fname,2)
    exp(i) = samp_size(i) * 0.9;
    exp(i) = int32(exp(i));
end
n_tr = round(sum(samp_size) - sum(exp));
idx = 1;
jdx = 1;
base = 0;
y = ones(2000, 1);
yy = ones(2000, 1);
dataset = zeros(1, str_size);
trainset = zeros(1, str_size);
for i=1:size(fname,2)
    len = samp_size(i);
    for j=1:len
        %if j <= exp(i)
            dataset(idx,:) = n_dataset(base + j);
            if i == 1
                y(idx) = -1;
            end
            idx = idx + 1;
        if j > exp(i)
            trainset(jdx,:) = n_dataset(base + j);
            if i == 1
                yy(jdx) = -1;
            end
            jdx = jdx + 1;
        end
    end
    base = base + len;
end
i




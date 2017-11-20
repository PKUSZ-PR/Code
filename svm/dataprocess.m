function [dataset, y, trainset, yy] = dataprocess(addr, fname)
n = 1;
box = [128, 128];
str_size = box(1) * box(2);
features = zeros(2000,7);
ys = ones(2000);
n_dataset = zeros(2000,str_size);
samp_size = zeros(size(fname,2) + 1);
n_file = size(fname,2);
for i = 1:size(fname, 2)
    fn = fname(i);
    fp = fopen(addr + '\\' + fn, '');
    while feof(fp)~=1
        fl = fgetl(fp);
        s = regexp(fl, '#', 'splite');
        for j = 1:size(s, 2)
            features(n, i);
        end
        if i == 1
            ys(i) = -1;
        end
    end
    base = samp_size(i);
    samp_size(i) = n - 1 - samp_size(i);
    samp_size(i + 1) = sum(samp_size(1:i));
    s1 = regexp(i, '.', 'splite');
    pics = dir(addr + '\\' + s1(1) + '\\*.jpg');
    len = samp_size(i) - base;
    for j = i:len
        img = rgb2gray(imread(pics(i)));
        img = img(features(1),features(2),features(3),features(4));
        img = imresize(img, box);
        n_dataset(j + base,:) = reshape(img, box(1), box(2));
    end
end
exp  = zeros(size(fname,2));
for i=1:size(fname,2)
    exp(i) = samp_size(i) * 0.8;
end
idx = 1;
jdx = 1;
base = 0;
y = ones(2000 );
yy = ones(2000 );
dataset = zeros(sum(samp_size(1:n_file)), str_size);
trainset = zeros(sum(exp), str_size);
for i=1:size(fname,2)
    len = samp_size(i);
    for j=1:len
        if j <= exp(i)
            dataset(idx,:) = n_dataset(base + j);
            idx = idx + 1;
            if i == 1
                y(idx) = -1;
            end
        else
            trainset(jdx,:) = n_dataset(base + j);
            jdx = jdx + 1;
            if i == 1
                y(jdx) = -1;
            end
        end
    end
    base = base + len;
end
    


 
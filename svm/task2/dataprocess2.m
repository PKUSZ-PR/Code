addr = 'C:\\Users\\EP\\Desktop\\vgg_face_dataset\\files';
fname = {'Adam_Levine.txt.rt', 'Taylor_Swift.txt.rt'};
n = 1;
box = [150, 200];
str_size = box(1) * box(2) *3;
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
        if size(img) ~= 3
            k = k+ 1;
            continue
        end
        fea = features(base + j,:)
        m1 = abs(fea(2)-fea(4));
        m2 = abs(fea(1)-fea(3));
        img = imcrop(img, [fea(1), fea(2), m1, m2]);
        img = imresize(img, box); 
        if m1 > size(img,1) || m2 > size(img,2)
            k = k + 1;
            continue;
        end
        size(img)
        tmp_x = reshape(img, 1,box(1)*box(2)*3); 
        bdx = k + base;
        n_dataset(j + base - k,:) = tmp_x;
    end
    samp_size(i) = len - k;
end
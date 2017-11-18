function [set, labels] = load_images(filename, set_num)

% initialization
img_dir = dir([filename, '*.jpg']);
set = zeros(224, 224, 3, set_num);
labels = zeros(set_num, 1);

% read the image
parfor i = 1:set_num
    image = imread([filename, img_dir(i).name]);
    if ismatrix(image)  
        image = cat(3,image,image,image);  
    end
    image = imresize(image, [224, 224]);
    name_split = regexp(img_dir(i).name, '_', 'split');
    label = cell2mat(name_split(2));
    set(:, :, :, i) = reshape(image, 1, 224, 224, 3);
    labels(i, 1) = str2double(label);
end

end

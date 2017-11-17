function [dataset, y, trainset, yy] = dataprocess()

i = imread('haha.jpg');
i = rgb2gray(i);
i = i(42:168, 43:168); 
i = imresize(i, [128,128]);
imshow(i)
a=[1,3,3;1,3,3];
 
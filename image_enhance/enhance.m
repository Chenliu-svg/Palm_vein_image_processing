function [im_out] = enhance(filename)
%enhance 按照已探索得到的流程增强照片
%   filename是图像路径名
%   im 为输出的图像

% 读取图像，转化为灰度图像
im=imread(filename); 
%im=rgb2gray(im);
niqeI = niqe(im);
fprintf('NIQE score for the original image is %0.4f.\n',niqeI);

% 高斯滤波
gaosi=fspecial('gaussian'); 
im_gaosi=imfilter(im,gaosi,'conv' ,'replicate');  

% 维纳滤波
PSF = fspecial('motion',1.5,40);
weina= deconvwnr(im_gaosi,PSF,0.14); 

% 同态滤波
image1 = im2double(weina);
tong = HomoFilter(image1, 1, 0.7, 1, 80);	% (img, rh, rl, c, D0)

% 对比度受限的自适应直方图均衡化
im_out = adapthisteq(tong);
niqeI = niqe(im_out); 
fprintf('NIQE score for the enhanced image is %0.4f.\n',niqeI);

imshowpair(im,im_out,'montage');
title('左边：原图像  右边：增强后图像');

end


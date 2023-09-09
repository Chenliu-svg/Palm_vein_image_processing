function [im] = linear_transform(filepath,a,b,c,d)
% 该函数用来对图像做分段线性变化，并输出分数
% [a,b]是 原图像的范围， [c,d]是要变化到的范围
I=imread(filepath);
I=rgb2gray(I);
[m,n]=size(I);
% 新的矩阵存放变化后的图像矩阵
new_im=zeros(m,n); 
niqeI = niqe(I);
fprintf('NIQE score for original image is %0.4f.\n',niqeI);
k1 = c /a; %求三段斜率
k2 = ( d-c) /( b-a) ;
k3 = ( 255-d) /( 255-b) ;
for i = 1: m %用双重循环进行分段线性拉伸
    for j=1:n
        if I(i,j)<a
            new_im(i,j)=k1*I(i,j);
        else
            if I(i,j)>=a && I(i,j)<b
                new_im(i,j)=k2* ( I( i,j) -a) +c;
            else
                new_im( i,j) = k3* ( I( i,j)-b) +d;
            end
        end
    end
end
im= uint8(new_im);
niqeI = niqe(im);
fprintf('NIQE score for transformed image is %0.4f.\n',niqeI);
end
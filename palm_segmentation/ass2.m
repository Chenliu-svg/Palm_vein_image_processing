im=imread('.\Capture\hzy_l_zhe_11.1v.png');
im=rgb2gray(im);
figure,imshow(im);
figure,imhist(im);

sigma = 1;
gausFilter=fspecial('gaussian',[5 5],sigma);
I2= imfilter(im, gausFilter, 'replicate');
figure(2);imshow(I2);title('高斯滤波后图像');


I3=edge(I2,'Canny',0.1);
figure(3),imshow(I3);title(' Canny边缘检测图像');

 % 孔洞填充
I41=imfill(I3,'holes');            
figure(4),imshow(I41);title('孔洞填充图像');
% 提取最外围边缘
I4=bwperim(I41);                   
figure(5),imshow(I4); title('边缘图像');
% 去除面积小于150px物体
I5=bwareaopen(I4,20);    
figure(6),imshow(I5);

clc,clear
I=imread('.\Capture\hzy_l_zhe_11.0v.png');
I=rgb2gray(I);

I=linear_transform('.\Capture\lhz_r_zhe_10.8v.png',70,110,10,256); 
imshow(I);
%输出直方图
figure;imhist(I);
%人工选定阈值进行分割，选择阈值为120
[width,height]=size(I);
T1=110;
for i=1:width
    for j=1:height
        if(I(i,j)<T1)
            BW1(i,j)=0;
        else 
            BW1(i,j)=1;
        end
    end
end
figure,imshow(BW1),title('人工阈值进行分割');
I41=imfill(BW1,'holes');            
figure,imshow(I41);title('孔洞填充图像');


%自动选择阈值
T2=graythresh(I);
BW2=im2bw(I,T2);%Otus阈值进行分割
figure;imshow(BW2),title('Otus阈值进行分割');

%% 同时处理
file_path =  '.\lab2\';% 图像文件夹路径
save_path = '.\lab2_pro\';
% image_name='test';
% save_name=strcat(save_path,image_name);
% imwrite(p1,save_name);

img_path_list = dir(strcat(file_path,'*.png'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量

if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));
            name=strcat(file_path,image_name);
            fprintf('%d %d %s\n',i,j,name);% 显示正在处理的图像名
            p1=grow(name);
            save_name=strcat(save_path,image_name);
            imwrite(p1,save_name);
        end
end


%% 区域生长
I=linear_transform('.\Capture\fjw_l_zhe_10.8v.png',40,100,10,200); 
%I=imread('.\Capture\dhy_l_zhe_10.8v.png');
I%=rgb2gray(I);
if isinteger(I)
    I=im2double(I);
end
%I = rgb2gray(I);

figure 
imshow(I);
[M,N]=size(I);
[y,x]=getpts; %单击取点后，按enter结束
x1=round(x);
y1=round(y);
seed=I(x1,y1); %获取中心像素灰度值

J=zeros(M,N);
J(x1,y1)=1;

count=1; %待处理点个数
threshold=0.29;
while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J(i,j)==1 %点在“栈”内
        if (i-1)>1&(i+1)<M&(j-1)>1&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J(i+u,j+v)==0&abs(I(i+u,j+v)-seed)<=threshold
                    J(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end


subplot(1,2,1),imshow(I);
title("original image")
subplot(1,2,2),imshow(J);
title("segmented image");

%% 边缘检测
% 各种边缘检测算法的叠加
im=imread('.\Capture\jzh_l_zhe_11.0v.png');
im=rgb2gray(im);
[J2,thresh]=edge(im,'prewitt',[],'horizontal');
figure,imshow(J2);
[J3,thresh]=edge(im,'prewitt',[],'vertical');
figure,imshow(J3);
J=J2+J3;
J1 = medfilt2(J,[3 3]);
figure,imshow(J);
[J4,thresh]=edge(im,'sobel',[],'horizontal');
figure,imshow(J4);

[J5,thresh]=edge(im,'sobel',[],'vertical');
J=J4+J5;
J = medfilt2(J,[3 3]);
J=J+J1;
figure,imshow(J);

[J6,thresh]=edge(im,'Roberts',[],'horizontal');
[J7,thresh]=edge(im,'Roberts',[],'vertical');
figure,imshow(J6+J7);

% 下面这两个会产生很多噪声，所以用中值滤波器滤波
[J8,thresh]=edge(I,'log');
figure,imshow(J8);
[J9,thresh]=edge(im,'zerocross');
figure,imshow(J9);

w=[-1,-1,-1;-1,8,-1;-1,-1,-1];
g2=imfilter(im,w,'replicate');
I3=edge(g2,'zerocross');
figure,imshow(I3);
figure,imhist(g2);
% 因为一个算子灰度不够，所以采用叠加
J=J2+J3+J4+J5+g2+J6+J7+J8+J9;
montage({J2,J3,J2+J3,J4,J5,J4+J5,g2,J6,J7,J8,J9},[1 11]);

J = medfilt2(J,[5 5]);
J=J*12;
figure,imshow(J);

figure,imshow(BW3);



I3=edge(I,'canny',0.3);
%I3 = medfilt2(I3,[3 3]);
figure,imshow(I3);title(' Canny边缘检测图像');

% 孔洞填充
I41=imfill(I3,'holes');            
figure(4),imshow(I41);title('孔洞填充图像');
% 提取最外围边缘
I4=bwperim(I41);                   
figure(5),imshow(I4); title('边缘图像');
% 去除面积小于150px物体
I5=bwareaopen(I4,20);    
figure(6),imshow(I5);

[B,L] = bwboundaries(J,'noholes');

% 画出手掌轮廓图，找到手腕中心点的坐标
figure;
imshow(label2rgb(L, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'black', 'LineWidth', 2)
end

wrist=[2;1109]; % 填入刚刚手动找到的手腕中点坐标，注意Y写在前，X写在后面

% 画出距离图，找到要用的点的序号，也就是图的横坐标
c1=B{1,1};
d1=((c1(:,1)-wrist(1)).^2+(c1(:,2)-wrist(2)).^2).^0.5;
x=1:size(d1);
x=x';
figure,plot(x,d1);

%idx=[2006;3097;4087;5023];%刚刚找到的四个点的横坐标
idx=[2006;3097]
% 画出最终的坐标
figure;
imshow(label2rgb(L, [.5 .5 .5]))
hold on
for i=1:length(idx)
   plot(c1(idx(i),2), c1(idx(i),1),'.','Color','r','MarkerSize',30)
   
end


%% 语义分割
%A = imread('.\Capture\xxx_l_zhe_11.1v.png');
A=linear_transform('.\Capture\xxx_l_zhe_11.1v.png',70,110,10,200);
A = imresize(A,0.25);
Agray=A;
%Agray = rgb2gray(A);
figure
imshow(A)

imageSize = size(A);
numRows = imageSize(1);
numCols = imageSize(2);

wavelengthMin = 4/sqrt(2);
wavelengthMax = hypot(numRows,numCols);
n = floor(log2(wavelengthMax/wavelengthMin));
wavelength = 2.^(0:(n-2)) * wavelengthMin;

deltaTheta = 45;
orientation = 0:deltaTheta:(180-deltaTheta);

g = gabor(wavelength,orientation);

gabormag = imgaborfilt(Agray,g);

for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma); 
end

X = 1:numCols;
Y = 1:numRows;
[X,Y] = meshgrid(X,Y);
featureSet = cat(3,gabormag,X);
featureSet = cat(3,featureSet,Y);

numPoints = numRows*numCols;
X = reshape(featureSet,numRows*numCols,[]);

X = bsxfun(@minus, X, mean(X));
X = bsxfun(@rdivide,X,std(X));

coeff = pca(X);
feature2DImage = reshape(X*coeff(:,1),numRows,numCols);
figure
imshow(feature2DImage,[])

L = kmeans(X,2,'Replicates',5);
L = reshape(L,[numRows numCols]);
figure
imshow(label2rgb(L))

%% 获取正方形
img=imread('.\Capture\xxx_l_zhe_11.1v.png');
figure,imshow(img),title('原图');
hold on;
x1=1216;y1=296;
x2=1035;y2=476;
x3=855;y3=295;
x4=1036;y4=115;
%连接顶点，画出正方形
plot([x3,x4],[y3,y4],'-','Color','r','LineWidth',3);
plot([x4,x1],[y4,y1],'-','Color','r','LineWidth',3);
plot([x1,x2],[y1,y2],'-','Color','r','LineWidth',3);
plot([x2,x3],[y2,y3],'-','Color','r','LineWidth',3);
hold off;
%这里暴力裁剪，先创建一个全0三维矩阵，再去原图中把符合条件的像素点的值赋进来
new_img=zeros(x1-x3+1,y2-y4+1);
new_img=cat(3,new_img,new_img,new_img);
new_img=im2uint8(new_img);
%xv,yv为多边形的各个顶点的横、纵坐标
xv=[x1,x2,x3,x4,x1];
yv=[y1,y2,y3,y4,y1];
for i=1:3
    for x=1:x1-x3
        for y=1:y2-y4
            in=inpolygon(x+x3,y+y4,xv,yv);%判断点(x+x3,y+y4)是否在正方形框中，返回的in是布尔类型
            if in
                new_img(y,x,i)=img(y+y4,x+x3,i);%如果点在正方形框中，就把它的像素值赋值给新图像
            end
        end
    end
end
%显示新的图像
figure,imshow(new_img),title('截取后的ROI区域');



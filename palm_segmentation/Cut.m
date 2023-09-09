%% 区域生长
%I=imread('.\Capture\lhz_r_zhe_11.1v.png');
%jzh_r_zhe_11.0v.png
%xxx_l_zhe_11.1v.png
I=linear_transform('xxx_l_zhe_11.1v.png',70,110,10,200); 
imwrite(I,'lashen.png','png')
%高斯模糊处理
w=fspecial('gaussian',[5 5],0.8);
I=imfilter(I,w);
if isinteger(I)
    I=im2double(I);
end
%I = rgb2gray(I);
figure 
imshow(I)
[M,N]=size(I);
[y,x]=getpts; %单击取点后，按enter结束
x1=round(x);
y1=round(y);
seed=I(x1,y1); %获取中心像素灰度值

J=zeros(M,N);
J(x1,y1)=1;

count=1; %待处理点个数
threshold=0.4;
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
imwrite(J,'segmented_image1.png','png')
title("segmented image")
[B,L] = bwboundaries(J,'noholes');
figure;
imshow(label2rgb(L, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'black', 'LineWidth', 2)
end

c1=B{1,1};
d1=(c1(:,1).^2+c1(:,2).^2).^0.5;
x=1:size(d1);
x=x';
figure,plot(x,d1);
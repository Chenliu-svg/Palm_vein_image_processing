%% 区域生长
%I=imread('.\Samples\lhz_r_zhe_11.1v.png');
I=linear_transform('.\Samples\xxx_l_zhe_11.1v.png',70,110,10,200); 
if isinteger(I)
    I=im2double(I);
end
%I = rgb2gray(I);

figure(1); 
imshow(I);
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
figure(2);
subplot(1,2,1),imshow(I);
title("original image")
subplot(1,2,2),imshow(J);
title("segmented image");
% 这里的J是区域生长法得到的手掌的二值图像
[B,L] = bwboundaries(J,'noholes');

% 画出手掌轮廓图，找到手腕中心点的坐标
figure(3);
imshow(label2rgb(L, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'black', 'LineWidth', 2);
end

wrist=[2;1109]; % 填入刚刚手动找到的手腕中点坐标，注意Y写在前，X写在后面

% 画出距离图，找到要用的点的序号，也就是图的横坐标
c1=B{1,1};
d1=((c1(:,1)-wrist(1)).^2+(c1(:,2)-wrist(2)).^2).^0.5;
x=1:size(d1);
x=x';
figure(4),plot(x,d1);

idx=[2006;3097;4087;5023];%刚刚找到的四个点的横坐标

% 画出最终的坐标
figure(5);
imshow(label2rgb(L, [.5 .5 .5]));
hold on;
for i=1:length(idx)
   plot(c1(idx(i),2), c1(idx(i),1),'.','Color','r','MarkerSize',30)
end
hold off;

x1=c1(idx(1),2);y1=c1(idx(1),1);
x2=c1(idx(2),2);y2=c1(idx(2),1);

%由(x1,y1)(x2,y2)可以计算得出正方形的另外两个顶点坐标
x3=0;y3=0;x4=0;y4=0;
x3=x2-(y2-y1);
y3=y2-(x1-x2);
x4=x1-(y2-y1);
y4=y1-(x1-x2);

%连接顶点，画出正方形
figure(6);
%imshow(label2rgb(L, [.5 .5 .5]));
I=imread('.\Samples\xxx_l_zhe_11.1v.png');
imshow(I),title("在原图上绘制出正方形锚框");
hold on;
plot([x3,x4],[y3,y4],'-','Color','r','LineWidth',3);
plot([x4,x1],[y4,y1],'-','Color','r','LineWidth',3);
plot([x1,x2],[y1,y2],'-','Color','r','LineWidth',3);
plot([x2,x3],[y2,y3],'-','Color','r','LineWidth',3);
hold off;
%在原图上截取
I=imread('.\Samples\xxx_l_zhe_11.1v.png');
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
                new_img(y,x,i)=I(y+y4,x+x3,i);%如果点在正方形框中，就把它的像素值赋值给新图像
            end
        end
    end
end
%显示截取得到的新图像
figure(7),imshow(new_img),title('固定锚框截取的ROI区域');

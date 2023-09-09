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
%J=bwmorph(J,'open');
subplot(1,2,2),imshow(J);
% imwrite(J,'hand_temp.png');
title("segmented image");

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
hold on
for i=1:length(idx)
   plot(c1(idx(i),2), c1(idx(i),1),'.','Color','r','MarkerSize',30)
end

x1=c1(idx(1),2);y1=c1(idx(1),1);
x2=c1(idx(2),2);y2=c1(idx(2),1);
x3=0;y3=0;x4=0;y4=0;

[x3,y3,x4,y4]=square_coordinate(x1,y1,x2,y2);%取得正方形另外两个点坐标
%计算延长线与手掌边缘的交点，即为新的(x3,y3)
original_x3=x3;original_y3=y3;
while(J(y3,x3)==1)
    x3=x3-1;
    y3=original_y3-(original_x3-x3)*(y2-original_y3)/(x2-original_x3);
    y3=round(y3);%四舍五入
end

%在(x2,y2)指向(x1,y1)的延长线上找到新的(x1,y1)点
[x1,y1]=get_adapter_point(J,x1,y1,x2,y2);
%由(x1,y1)(x2,y2)(x3,y3)计算得到(x4,y4)
x4=x1-(x2-x3);
y4=y1-(y2-y3);
%连接顶点，画出正方形
% plot([x3,x4],[y3,y4],'-','Color','r','LineWidth',3);
% plot([x4,x1],[y4,y1],'-','Color','r','LineWidth',3);
% plot([x1,x2],[y1,y2],'-','Color','r','LineWidth',3);
% plot([x2,x3],[y2,y3],'-','Color','r','LineWidth',3);


%在原图上截取
%先在原图上绘制出需要截取的矩形区域
I=imread('.\Samples\xxx_l_zhe_11.1v.png');
figure(6);subplot(1,2,1),imshow(I),title('原图');
% I=imtranslate(I,[0,-y4]);
hold on;
%需要平移
temp=y4;
%y1=y1-y4;y2=y2-y4;y3=y3-y4;y4=y4-y4;
plot([x3,x4],[y3,y4],'-','Color','r','LineWidth',3);
plot([x4,x1],[y4,y1],'-','Color','r','LineWidth',3);
plot([x1,x2],[y1,y2],'-','Color','r','LineWidth',3);
plot([x2,x3],[y2,y3],'-','Color','r','LineWidth',3);
hold off;

I=imtranslate(I,[0,-y4]);
y1=y1-y4;y2=y2-y4;y3=y3-y4;y4=y4-y4;
% y1=y1+temp;y2=y2+temp;y3=y3+temp;y4=temp;
ROI_img=get_square_ROI(I,x1,y1,x2,y2,x3,y3,x4,y4);
subplot(1,2,2),imshow(ROI_img),title("ROI");

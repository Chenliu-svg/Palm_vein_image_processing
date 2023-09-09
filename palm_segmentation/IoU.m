bw = imread("segmented_image.png");%输入二值图像
bw1 = imread("roi.png");%输入手绘roi
[M,N] = size(bw); % 图像大小 M N 表示图像的长和宽
j = M*N;  % 图像的总像素点数目
and = 0;  % 图像的像素点为与运算为1的数目
or = 0;   % 图像的像素点或或运算为1的数目
for m=1:M
    for n=1:N
        if bw(m,n) > 0&& bw1(m,n) > 0
            % 此处使用二维矩阵的方式访问图像的某一个像素点， 如果对应的位置数值大于0，and 加1
            and = and + 1;
        end
        if bw(m,n) > 0 || bw1(m,n) > 0% 如果对应的位置数值等于0，or加1
            or = or + 1;
        end
    end
end
fprintf('the total point of picure is %d\n',j)
fprintf('the AND_white point of picure is %d\n',and)
fprintf('the OR_white point of picure is %d\n',or)
fprintf('the IoU is %f\n',and/or)
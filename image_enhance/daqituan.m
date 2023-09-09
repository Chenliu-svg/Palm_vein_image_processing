function out=daqituan( image ,k )% k=0.00011 
%函数daqituan 对输入的图像进行大气湍流处理
%参数image 输入的待处理图像
%参数k 大气湍流模型常数
i=fft2(double(image)); 
G=fftshift(i);
[m, n, h] = size(i); 
H=zeros(m,n);
for i=1:m 
for j=1:n 
if sqrt((i-m/2)^2+(j-n/2)^2)<100 
H(i,j)=exp(-k*(i^2+j^2)^(5/6)); 
end 
end 
end 
for i=1:3 
out(:,:,i) = G(:,:,i).*H; 
end
out = real(ifft2(ifftshift(out))); 

end

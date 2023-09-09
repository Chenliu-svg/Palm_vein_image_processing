
%% 课题一
file_path =  '.\Samples\';% 图像文件夹路径
save_path = '.\processed\';
% image_name='test';
% save_name=strcat(save_path,image_name);
% imwrite(p1,save_name);

img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像
img_num = length(img_path_list);%获取图像总数量

if img_num > 0 %有满足条件的图像
        for j = 1:img_num %逐一读取图像
            image_name = img_path_list(j).name;% 图像名
            image =  imread(strcat(file_path,image_name));
            name=strcat(file_path,image_name);
            fprintf('%d %d %s\n',i,j,name);% 显示正在处理的图像名
            p1=enhance(name);
            save_name=strcat(save_path,image_name);
            imwrite(p1,save_name);
        end
end

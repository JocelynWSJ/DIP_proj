function out_img = filter2d(img,filter)
%计算滤波器大小
s = size(filter,1);
pos = round(s/2);%中心位置
%计算原图大小
height = size(img,1);
width = size(img,2);
%初始化输出矩阵
out_img = zeros(height,width);
%（i，j）代表输出图像正在进行计算的点
for i = 1:height
    for j = 1:width
        temp = 0;
        %(first_h,first_w)为滤波器左上角第一个值在图像中的位置
        first_h = i-pos+1;
        first_w = j-pos+1;
        %(f_i,f_j)为在滤波器中的位置
        for f_i = 1:s
            for f_j = 1:s
                %(img_i,img_j)为在图像中的位置
                img_i = first_h+f_i-1;
                img_j = first_w+f_j-1;
                if ((img_i>0)&&(img_i<=height)&&(img_j>0)&&(img_j<=width))
                    temp = temp + double(img(first_h+f_i-1,first_w+f_j-1))*(filter(f_i,f_j));
                end
            end
        end
        out_img(i,j) = temp;
    end
end
out_img = imcrop(out_img,[pos pos width-s height-s]);
end


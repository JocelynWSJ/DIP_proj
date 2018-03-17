function output = bicubic(img, h, w) 
height = size(img,1); %原图像的行数
width = size(img,2); %原图像的列数
%检测图像维度
img_size=size(img);
if numel(img_size)>2 %计算图像维度
    flag = 1;
else
    flag = 0;
end
if flag == 1
    output = zeros(h,w,3);%初始化输出矩阵
    A = height/h;%行数缩放倍数
    B = width/w;%列数缩放倍数
    f = zeros(4,4,3);
    for i = 1:h
        xi = (i-1)*A+1;%原图像中的相对行数
        x2 = floor(xi);%f窗口中第二行在原图中位置
        f_x = xi-x2+2;%对应点在f窗口中的行数位置
        for j = 1:w
            yj = (j-1)*B+1;%原图像中的相对列数
            y2 = floor(yj);%f窗口中第二列在原图中位置
            f_y = yj-y2+2;%对应点在f窗口中列数位置
            sum = 0;%结果
            %对f窗口赋值
            for fi = 1:4
                for fj = 1:4
                    img_fi = x2-2+fi;
                    img_fj = y2-2+fj;
                    if img_fi<1
                        img_fi = 1;
                    end
                    if img_fj<1
                        img_fj = 1;
                    end
                    if img_fi>height
                        img_fi = height;
                    end
                    if img_fj>width
                        img_fj = width;
                    end
                    f(fi, fj,:) = img(img_fi, img_fj,:);
                    sum = sum+f(fi, fj,:)*W(f_x-fi)*W(f_y-fj);
                end
            end

            output(i,j,:) = sum;
        end
    end
end
if flag == 0
        output = zeros(h,w);%初始化输出矩阵
    A = height/h;%行数缩放倍数
    B = width/w;%列数缩放倍数
    f = zeros(4,4);
    for i = 1:h
        xi = (i-1)*A+1;%原图像中的相对行数
        x2 = floor(xi);%f窗口中第二行在原图中位置
        f_x = xi-x2+2;%对应点在f窗口中的行数位置
        for j = 1:w
            yj = (j-1)*B+1;%原图像中的相对列数
            y2 = floor(yj);%f窗口中第二列在原图中位置
            f_y = yj-y2+2;%对应点在f窗口中列数位置
            sum = 0;%结果
            %对f窗口赋值
            for fi = 1:4
                for fj = 1:4
                    img_fi = x2-2+fi;
                    img_fj = y2-2+fj;
                    if img_fi<1
                        img_fi = 1;
                    end
                    if img_fj<1
                        img_fj = 1;
                    end
                    if img_fi>height
                        img_fi = height;
                    end
                    if img_fj>width
                        img_fj = width;
                    end
                    f(fi, fj) = img(img_fi, img_fj);
                    sum = sum+f(fi, fj)*W(f_x-fi)*W(f_y-fj);
                end
            end

            output(i,j) = sum;
        end
    end
end

output = uint8(output);
end
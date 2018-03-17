function out_img = filter2d(img,filter)
%�����˲�����С
s = size(filter,1);
pos = round(s/2);%����λ��
%����ԭͼ��С
height = size(img,1);
width = size(img,2);
%��ʼ���������
out_img = zeros(height,width);
%��i��j���������ͼ�����ڽ��м���ĵ�
for i = 1:height
    for j = 1:width
        temp = 0;
        %(first_h,first_w)Ϊ�˲������Ͻǵ�һ��ֵ��ͼ���е�λ��
        first_h = i-pos+1;
        first_w = j-pos+1;
        %(f_i,f_j)Ϊ���˲����е�λ��
        for f_i = 1:s
            for f_j = 1:s
                %(img_i,img_j)Ϊ��ͼ���е�λ��
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


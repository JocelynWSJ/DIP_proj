function output = bicubic(img, h, w) 
height = size(img,1); %ԭͼ�������
width = size(img,2); %ԭͼ�������
%���ͼ��ά��
img_size=size(img);
if numel(img_size)>2 %����ͼ��ά��
    flag = 1;
else
    flag = 0;
end
if flag == 1
    output = zeros(h,w,3);%��ʼ���������
    A = height/h;%�������ű���
    B = width/w;%�������ű���
    f = zeros(4,4,3);
    for i = 1:h
        xi = (i-1)*A+1;%ԭͼ���е��������
        x2 = floor(xi);%f�����еڶ�����ԭͼ��λ��
        f_x = xi-x2+2;%��Ӧ����f�����е�����λ��
        for j = 1:w
            yj = (j-1)*B+1;%ԭͼ���е��������
            y2 = floor(yj);%f�����еڶ�����ԭͼ��λ��
            f_y = yj-y2+2;%��Ӧ����f����������λ��
            sum = 0;%���
            %��f���ڸ�ֵ
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
        output = zeros(h,w);%��ʼ���������
    A = height/h;%�������ű���
    B = width/w;%�������ű���
    f = zeros(4,4);
    for i = 1:h
        xi = (i-1)*A+1;%ԭͼ���е��������
        x2 = floor(xi);%f�����еڶ�����ԭͼ��λ��
        f_x = xi-x2+2;%��Ӧ����f�����е�����λ��
        for j = 1:w
            yj = (j-1)*B+1;%ԭͼ���е��������
            y2 = floor(yj);%f�����еڶ�����ԭͼ��λ��
            f_y = yj-y2+2;%��Ӧ����f����������λ��
            sum = 0;%���
            %��f���ڸ�ֵ
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
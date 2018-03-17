function output = PSNR(input_img1, input_img2)
%���ͼ��ά��
img_size=size(input_img1);
if numel(img_size)>2 %����ͼ��ά��
    input_img1 = rgb2ycbcr(input_img1); %��ͼ����RGBɫ�ʿռ�ת����YCbCrɫ�ʿռ�
    input_img1 = input_img1(:, :, 1);
end
img_size=size(input_img2);
if numel(img_size)>2
    input_img2 = rgb2ycbcr(input_img2);
    input_img2 = input_img2(:, :, 1);
end

%
MAX = 255;
%����MSE
M = size(input_img1,1);
N = size(input_img1,2);
input_img1 = double(input_img1);
input_img2 = double(input_img2);
sum = 0;
%MSE=sum(sum((input_img1-input_img2).^2))/(M*N); 

for i = 1:M
    for j = 1:N
        sum = sum+(input_img1(i,j)-input_img2(i,j))^2;
    end
end
MSE = sum/(M*N);
output = 20*log10(MAX/sqrt(MSE));
end
clear;  
clc;  

%
img=imread('Set14\face.bmp');  
img2 = bicubic(img, round(size(img,1)/3), round(size(img,2)/3));
img3 = bicubic(img2, size(img,1), size(img,2));

p1 = PSNR(img, img3);
p2 = SSIM(img, img3);

data = ['PSNR=' num2str(p1) '  SSIM='   num2str(p2)];
figure
subplot(1,2,1)
imshow(img);
title('ԭͼ');
subplot(1,2,2)
imshow(img3);
title(data);




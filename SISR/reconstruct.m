clear;  
clc;

load('clusters_data');
num_cluster = 512;


%读入系数
load('coef');
sf = 3;

img=imread('Set14\zebra.bmp');  
image = img;

patch_to_vector_exclude_corner = [2:6 8:42 44:48];
no_gass = bicubic(img, round(size(img,1)/3), round(size(img,2)/3));
no_gass_bic = bicubic(no_gass, round(size(img,1)), round(size(img,2)));
no_gass_bic = uint8(no_gass_bic);

tic;%开始计时
img_size=size(img);
flag = 0;
if numel(img_size)>2 %计算图像维度
    flag = 1;
    UV = rgb2ycbcr(no_gass_bic);
    U = UV(:, :, 2);
    V = UV(:, :, 3);
    img_Y = rgb2ycbcr(img);
    img = img_Y(:,:,1);
end
LR_ori = round(GaussianKernel(img,3,1.2)*255);

patchsize = 7;
patch_center = (patchsize-1)/2;
%延拓LR边界
[h_ori,w_ori] = size(LR_ori);
LR = ones((h_ori+patchsize+1),(w_ori+patchsize+1))*150;
[h,w] = size(LR);
LR(patch_center+2:h-patch_center-1,patch_center+2:w-patch_center-1) = LR_ori(:,:);

for time = 1:4
    LR(time,patch_center+2:w-patch_center-1) = LR_ori(1,:);
    LR(patch_center+2:h-patch_center-1,time) = LR_ori(:,1);
    LR(h-time+1,patch_center+2:w-patch_center-1) = LR_ori(h_ori,:);
    LR(patch_center+2:h-patch_center-1,w-time+1) = LR_ori(:,w_ori);
end
LR(1:4,1:4) = ones(4,4)*LR_ori(1,1);
LR(1:4,w-3:w) = ones(4,4)*LR_ori(1,w_ori);
LR(h-3:h,1:4) = ones(4,4)*LR_ori(h_ori,1);
LR(h-3:h,w-3:w) = ones(4,4)*LR_ori(h_ori,w_ori);
%结果
SR = zeros(h*sf,w*sf);

for r=patch_center+1:h-patch_center
    for c=patch_center+1:w-patch_center
        patch_lr = LR(r-patch_center:r+patch_center,c-patch_center:c+patch_center);
        vector_lr_exclude_corner = patch_lr(patch_to_vector_exclude_corner);       
        vector_mean= sum(vector_lr_exclude_corner)/45;
        feature = vector_lr_exclude_corner - vector_mean;
        diff = repmat(feature,[num_cluster,1]) - clusters;        %each row of clusters is a feature
        [~,label_idx] = min(sqrt(sum(diff.^2,2)));
        V = [feature 1];
        W = V*coef_matrix(:,:,label_idx)+vector_mean;
        W = reshape(W,9,9);
        %定位HR
        r1 = r-1;
        r2 = r+1;
        c1 = c-1;
        c2 = c+1;
        rh = (r1-1)*sf+1;     
        rh1 = r2*sf;
        ch = (c1-1)*sf+1;
        ch1 = c2*sf;
        SR(rh:rh1,ch:ch1) = SR(rh:rh1,ch:ch1)+ W/9;
    end
end

%裁剪图像
[height,width,~] = size(img);
[hSR,wSR] = size(SR);
interval_h = ceil(double(hSR-height)/2+0.1);
interval_w = ceil(double(wSR-width)/2+0.1);
SR = imcrop(SR,[interval_w,interval_h,width-1,height-1]);
SR = 0.8*SR+0.2*double(img);
SR = uint8(SR);
if flag == 1
    UV(:,:,1) = SR;
    result = uint8(UV);
    result = ycbcr2rgb(result);
else
    result = SR;
end
toc   %计时结束

p11 = PSNR(image, no_gass_bic);
p12 = SSIM(image, no_gass_bic);
p21 = PSNR(image, result);
p22 = SSIM(image, result);
data1 = ['PSNR=' num2str(p11) '  SSIM='   num2str(p12)];
data2 = ['PSNR=' num2str(p21) '  SSIM='   num2str(p22)];
figure
subplot(1,3,1)
imshow(image);
title('原图');
subplot(1,3,2)
imshow(no_gass_bic);
title(data1);
subplot(1,3,3)
imshow(result);
title(data2);




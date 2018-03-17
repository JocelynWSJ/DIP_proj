clear;  
clc;  
%����Train�ļ��������ļ���
fileRoot = pwd;%��ǰ����·��
fileFolder=fullfile([pwd '\Final Proj\SISR\Train']);
fileCluster = fullfile([pwd '\Final Proj\SISR\Cluster1\cluster.txt']);
dirOutput=dir(fullfile(fileFolder,'*.jpg'));
fileNames={dirOutput.name}';
img_num = length(fileNames);
sf = 3;
HRtoVECTOR = [1:81];
%patch�Ĵ�С
patchsize = 7;
patch_center = (patchsize-1)/2;
%�������ͼ
end_dim = 2000000;
feature=zeros(end_dim,45);
HR_feature=zeros(end_dim,81);
table_position_center=zeros(4,end_dim);
index = 0;
isbreak = 0;
for num = 1:img_num
    num
    road = ['Train\' fileNames{num}];
    img = imread(road);
    img_size=size(img);
    if numel(img_size)>2 %����ͼ��ά��
        img = rgb2ycbcr(img); %��ͼ����RGBɫ�ʿռ�ת����YCbCrɫ�ʿռ�
        img = img(:, :, 1);
    end
    HR = img;
    LR = round(GaussianKernel(HR,3,1.2)*255);
    [h, w] = size(LR);
    
    %LR����ά��
    feature_dim = 45;
    grad_lr = LR;
    
    patch_to_vector_exclude_corner = [2:6 8:42 44:48];
    %��ȡpatch
    for r=patch_center+9:h-patch_center-8
        for c=patch_center+9:w-patch_center-8
                index = index + 1;
                table_position_center(1,index) = r;
                table_position_center(2,index) = c;
                table_position_center(3,index) = num;
                patch_lr = LR(r-patch_center:r+patch_center,c-patch_center:c+patch_center);
                vector_lr_exclude_corner = patch_lr(patch_to_vector_exclude_corner);   
                vector_mean= mean(vector_lr_exclude_corner);
                table_position_center(4,index) = vector_mean;
                f = vector_lr_exclude_corner - vector_mean;
                feature(index,:) = f;
                %index
                
                %��ȡHR
                r1 = r-1;   %LR���Ĳ�����ʼ����
                r2 = r+1;   %LR���Ĳ�����ֹ����
                c1 = c-1;   %LR���Ĳ�����ʼ����
                c2 = c+1;   %LR���Ĳ�����ֹ����
                rh = (r1-1)*sf+1;   %HR��ʼ����     
                rh1 = r2*sf;        %HR��ֹ����
                ch = (c1-1)*sf+1;   %HR��ʼ����
                ch1 = c2*sf;        %HR��ֹ����
                patch_HR = double(HR(rh:rh1,ch:ch1))-vector_mean;
                diff_hr = double(patch_HR);
                HR_feature(index,:) = diff_hr(HRtoVECTOR);%תΪһά����
            %end
            if index >= end_dim
                break;
            end
        end
        if index >= end_dim
            break;
        end
    end
    if index >= end_dim
        break;
    end
end
save('feature_data','feature','table_position_center','HR_feature');
   

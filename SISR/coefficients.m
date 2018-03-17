clear;  
clc;  

load('feature_data');
load('clusters_data');
%label = label_feature(feature, clusters);

%save('label_data','label');
load('label_data');

sf = 3;
ps = 7;     %patch size
sigma = 1.2;
featurelength_lr = 45;
featurelength_hr = (3*sf)^2;
HRtoVECTOR = [1:featurelength_hr];
idx_label_start = 1;
idx_label_end = 512;
%系数矩阵
coef_matrix = zeros(featurelength_lr+1,featurelength_hr,idx_label_end);


for idx_label = idx_label_start:idx_label_end
    idx_label
    %此类块的数目
    idx_inst = 0;
    V = [];
    W = [];
    %寻找位置
    arr_match = (label == idx_label);
    
    if nnz(arr_match) == 0
        continue;
    end
    %非零所在的位置
    feature_pos = find(arr_match);
    %这一簇含有的数目
    num_this_label = length(feature_pos);
    for idx = 1:num_this_label
            idx_inst = idx_inst + 1;
            feature_idx = feature_pos(idx);
            W(idx_inst,:) = double(HR_feature(feature_idx,:));
            V(idx_inst,:) = double(feature(feature_idx,:));
    
            if idx_inst >= 1000
                break   %break the idx_image loop
            end
    end
    l = size(V,1);
    V = [V ones(l,1)];
    if ~isempty(V)
        coef = V\W;                         %计算回归系数
        coef_matrix(:,:,idx_label) = coef;  %记录对应簇的系数
    else
        coef_matrix(:,:,idx_label) = zeros(46,81);%若未找到对应feature，系数为0
    end
end

save('coef','coef_matrix');
size(coef_matrix)


    
   
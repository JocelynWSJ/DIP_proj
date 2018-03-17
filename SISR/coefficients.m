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
%ϵ������
coef_matrix = zeros(featurelength_lr+1,featurelength_hr,idx_label_end);


for idx_label = idx_label_start:idx_label_end
    idx_label
    %��������Ŀ
    idx_inst = 0;
    V = [];
    W = [];
    %Ѱ��λ��
    arr_match = (label == idx_label);
    
    if nnz(arr_match) == 0
        continue;
    end
    %�������ڵ�λ��
    feature_pos = find(arr_match);
    %��һ�غ��е���Ŀ
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
        coef = V\W;                         %����ع�ϵ��
        coef_matrix(:,:,idx_label) = coef;  %��¼��Ӧ�ص�ϵ��
    else
        coef_matrix(:,:,idx_label) = zeros(46,81);%��δ�ҵ���Ӧfeature��ϵ��Ϊ0
    end
end

save('coef','coef_matrix');
size(coef_matrix)


    
   
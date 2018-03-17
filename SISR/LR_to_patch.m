function [feature, table_position_center] = LR_to_patch(LR) 

%LR特征维度
feature_dim = 45;

%patch的大小
patchsize = 7;
patch_center = (patchsize-1)/2;
[h,w] = size(LR);   
grad_lr = LR;
%grad_lr = suppressboundary(LR);
index = 0;
%HR截取的patch数目
total_patch = (h-patchsize+1)*(w-patchsize+1);
%特征空间
feature = zeros(total_patch,feature_dim);
%patch对应的中心位置
table_position_center = zeros(3,total_patch);      %r,c
patch_to_vector_exclude_corner = [2:6 8:42 44:48];
%截取patch
for r=patch_center+1:h-patch_center
    for c=patch_center+1:w-patch_center
        index = index + 1;
        table_position_center(1,index) = r;
        table_position_center(2,index) = c;
        patch_lr = LR(r-patch_center:r+patch_center,c-patch_center:c+patch_center);
        vector_lr_exclude_corner = patch_lr(patch_to_vector_exclude_corner);       
        vector_mean= mean(vector_lr_exclude_corner);
        table_position_center(3,index) = vector_mean;
        feature(index,:) = vector_lr_exclude_corner - vector_mean;
        %{
        patch_grad_lr = grad_lr(r-2:r+2,c-2:c+2,:);     %2 for detectsmooth region
        num_underthd = nnz(abs(patch_grad_lr) <= 0.05);
        %neglect smooth patch
        if num_underthd < 200
            index = index + 1;
            table_position_center(1,index) = r;
            table_position_center(2,index) = c;
            patch_lr = LR(r-patch_center:r+patch_center,c-patch_center:c+patch_center);
            vector_lr_exclude_corner = patch_lr(patch_to_vector_exclude_corner);       
            vector_mean= mean(vector_lr_exclude_corner);
            table_position_center(3,index) = vector_mean;
            feature(index,:) = vector_lr_exclude_corner - vector_mean;
        end
        %}
    end
end
feature = feature(1:index,:);
table_position_center = table_position_center(:,1:index);
end
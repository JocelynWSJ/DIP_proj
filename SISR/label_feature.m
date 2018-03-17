function arr_label = label_feature(feature, clusters)
%Ϊpatch�������ľ۵�
num_inst = size(feature,1);
num_cluster = size(clusters,1);
arr_label = zeros(num_inst,1);
for i=1:num_inst
    feature_this = feature(i,:);
    diff = repmat(feature_this,[num_cluster,1]) - clusters;        %each row of clusters is a feature
    [~,idx_this] = min(sqrt(sum(diff.^2,2)));
    arr_label(i) = idx_this;
end
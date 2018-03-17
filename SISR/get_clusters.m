clear;  
clc;  

   
load('feature_data');
feature = feature(1:200000,:);
iteration = 350;  
K = 512;
opts = statset('Display','iter','MaxIter',iteration);
[index, clusters] = kmeans(feature,K,'emptyaction','drop','options',opts);     %use uniform option to prevent randomness
 
save('clusters_data','clusters');
    
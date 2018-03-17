function filter = gaussian_filter(size,sd)
filter = zeros(size,size);%��ʼ���������
center = round(size/2);
for i = 1:size
    for j = 1:size
        filter(i,j) = (-(i-center)^2 - (j-center)^2)/(2*sd^2);
    end
end
filter = exp(filter);

sum = 0;
for i = 1:size
    for j = 1:size
        sum = sum + filter(i,j);
    end
end
filter = filter/sum;%���˲������й�һ��
end
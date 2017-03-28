close all; clear all; clc;
L=4;
v=zeros(1,2^(3*L));
for p=1:33
    sample=double(imread([num2str(p) '.bmp']));
    [m,n,d]=size(sample);
    density=zeros(1,2^(3*L));
    for k=1:m
        for j=1:n
            r=floor(sample(k,j,1)*2^(L-8));
            g=floor(sample(k,j,2)*2^(L-8));
            b=floor(sample(k,j,3)*2^(L-8));
            color=b+g*(2^L)+r*2^(2*L)+1;
            density(color)=density(color)+1;
        end
    end
    density=density./m./n;
    v=v+density;
end
v=v./33;
plot(v);
save('v.mat','v');
close all;clear all;clc;
load hall.mat;
N=8;
[m,n]=size(hall_gray);
for k=1:8:m-7
for j=1:8:n-7
block=double(hall_gray(k:k+7,j:j+7));
block_dct=dct2(block-128);
l2z=block_dct;
r2z=block_dct;
l2z(1:N,1:4)=0;
r2z(1:N,5:N)=0;
left(k:k+7,j:j+7)=idct2(l2z)+128;
right(k:k+7,j:j+7)=idct2(r2z)+128;
end
end
subplot(1,3,1),imshow(uint8(left)),title('◊Û≤‡÷√¡„','Color','b');
subplot(1,3,2),imshow(uint8(right)),title('”“≤‡÷√¡„','Color','b');
subplot(1,3,3),imshow(hall_gray),title('‘≠Õº','Color','b');
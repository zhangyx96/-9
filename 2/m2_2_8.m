close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
N=8;
output=[];
[m,n]=size(hall_gray);
for k=1:8:m-7
for j=1:8:n-7
block=double(hall_gray(k:k+7,j:j+7));
block_dct=dct2(block-128);
block_q=round(block_dct./QTAB);
block_zz=ZigZag(block_q);
output=[output block_zz];
end
end

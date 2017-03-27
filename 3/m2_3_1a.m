%空域隐藏
close all;clear all;clc;
load hall.mat;
[m,n]=size(hall_gray);
info=randi([0 1],[m n]);                      %随机生成m*n的0-1信息矩阵
pic_encrypted=double(hall_gray);
for k=1:m
    for j=1:n
        pix=double(hall_gray(k,j));           %取出像素点
        pix_bin=dec2bin(pix);                 %转换成2进制
        pix_bin(end)=num2str(info(k,j));      %最后一位改成信息位
        pic_encrypted(k,j)=bin2dec(pix_bin);  %重新转成10进制
    end
end
pic_encrypted=uint8(pic_encrypted);
imshow(pic_encrypted);
save('pic_encrypted.mat','pic_encrypted','info');

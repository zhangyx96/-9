%��������
close all;clear all;clc;
load hall.mat;
[m,n]=size(hall_gray);
info=randi([0 1],[m n]);                      %�������m*n��0-1��Ϣ����
pic_encrypted=double(hall_gray);
for k=1:m
    for j=1:n
        pix=double(hall_gray(k,j));           %ȡ�����ص�
        pix_bin=dec2bin(pix);                 %ת����2����
        pix_bin(end)=num2str(info(k,j));      %���һλ�ĳ���Ϣλ
        pic_encrypted(k,j)=bin2dec(pix_bin);  %����ת��10����
    end
end
pic_encrypted=uint8(pic_encrypted);
imshow(pic_encrypted);
save('pic_encrypted.mat','pic_encrypted','info');

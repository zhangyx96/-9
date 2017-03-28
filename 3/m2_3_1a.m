%¿ÕÓòÒþ²Ø
close all;clear all;clc;
load hall.mat;
[m,n]=size(hall_gray);
info=randi([0 1],[m n]);                      %Ëæ»úÉú³Ém*nµÄ0-1ÐÅÏ¢¾ØÕó
pic_encrypted=double(hall_gray);
for k=1:m
    for j=1:n
        pix=double(hall_gray(k,j));           %È¡³öÏñËØµã
        pix_bin=dec2bin(pix);                 %×ª»»³É2½øÖÆ
        pix_bin(end)=num2str(info(k,j));      %×îºóÒ»Î»¸Ä³ÉÐÅÏ¢Î»
        pic_encrypted(k,j)=bin2dec(pix_bin);  %ÖØÐÂ×ª³É10½øÖÆ
    end
end
pic_encrypted=uint8(pic_encrypted);
imshow(pic_encrypted);
save('pic_encrypted.mat','pic_encrypted','info');

%ø’”ÚÃ·»°
close all;clear all;clc;
load pic_encrypted.mat;
[m,n]=size(pic_encrypted);
info_decrypted=[];
for k=1:m
    for j=1:n
        pix=double(pic_encrypted(k,j));
        pix_bin=dec2bin(pix);
        a=str2num((pix_bin(end)));
        info_decrypted=[info_decrypted a];
    end
end
info=reshape(info',1,m*n);
ise=sum(sum(info_decrypted~=info));

close all;clear all;clc;
load hall.mat;
hall_c2=hall_color;
[m n]=size(hall_gray);
%120/8=15 168/8=21
for k=1:m
    for j=1:n
    if ((mod(k,30)<=15&&mod(k,30)~=0) && (mod(j,42)>21||mod(j,42)==0))||((mod(k,30)>15||mod(k,30)==0)&&(mod(j,42)<=21&&mod(j,42)~=0))
        hall_c2(k,j,:)=[0 0 0];
    end
    end
end
imshow(hall_c2);
imwrite(hall_c2,'picture2.jpg');

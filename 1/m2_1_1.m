close all;clear all;clc;
load hall.mat;
imshow(hall_color);
hold on;
[m n]=size(hall_gray);
r=min(m,n)/2;
a=0:0.001:2*pi;
x=round(r*cos(a))+n/2;
y=round(r*sin(a))+m/2+1;
plot(x,y,'r',n/2,m/2);
hall_c1=hall_color;
for n = 1:length(x)
    hall_c1(y(n),x(n),:) = [255 0 0];
end
imwrite(hall_c1,'picture1.jpg');
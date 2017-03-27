%适当改变颜色
close all; clear all; clc;
load v.mat;
photo=imread('合影1.jpg');
pp=sum(sum(photo>255));
N=4;
L=4;
delta=0.82;
[m,n,w]=size(photo);
photo=double(imadjust(photo,[0.2,0.3,0;0.6,0.7,1],[],1));
pp=sum(sum(photo>255));
[m,n,w]=size(photo);
photo_bw=zeros(m,n);
for k=1:N:m-N
    for j=1:N:n-N
        block=photo(k:k+N-1,j:j+N-1,:);
        u=get_u(block,L);
        d=get_d(u,v);
        if d<delta
            photo_bw(k:k+N-1,j:j+N-1)=1;
        end
    end
end
[photo_bw num]=bwlabel(photo_bw,8);
for k=1:num
    [p_row,p_col]=find(photo_bw==k);
    row_min=min(p_row);
    row_max=max(p_row);
    col_min=min(p_col);
    col_max=max(p_col);
    if (range(p_row)>m/12)&&(range(p_col)>(n/20))    %合影1   
    photo(row_min:row_max, col_min:col_min+1,1)=255;
    photo(row_min:row_max, col_min:col_min+1,2:3)=0;
    photo(row_min:row_max,col_max-1:col_max,1)=255;
    photo(row_min:row_max,col_max-1:col_max,2:3)=0;
    photo(row_min:row_min+1,col_min:col_max,1)=255;
    photo(row_min:row_min+1,col_min:col_max,2:3)=0;
    photo(row_max-1:row_max,col_min:col_max,1)=255;
    photo(row_max-1:row_max,col_min:col_max,2:3)=0;
    end
end
photo=uint8(photo);
imshow(photo);
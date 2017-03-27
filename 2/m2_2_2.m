close all;clear all;clc;
load hall.mat;
N=8;
block=double(hall_gray(1:N,1:N));  
preblock=block-128;
row1=repmat(sqrt(0.5),1,N);
D=sqrt(0.25).*[row1;cos([1:N-1]'*[1:2:2*N-1]*pi/(2*N))];
C1=D*block*D';
C2=dct2(block);

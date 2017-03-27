close all;clear all;clc;
load hall.mat;
block=double(hall_gray(1:8,1:8));     
preblock=block-128;
block1 = dct2(block);
block1(1,1)=block1(1,1)-1024;
block2 = dct2(preblock);

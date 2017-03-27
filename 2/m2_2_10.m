close all; clear all; clc;
load jpegcodes.mat;
a=m*n*8;
b=length(AC_code)+length(DC_code)+length(dec2bin(m))+length(dec2bin(n));
ratio=a/b;
disp(['Ñ¹Ëõ±È = ' num2str(ratio)]);
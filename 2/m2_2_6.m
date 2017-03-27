close all; clear all; clc;
c=-52; 
if c~=0
    category=floor((log(abs(c))/log(2)))+1;
else 
     category=0;
end
disp(category);

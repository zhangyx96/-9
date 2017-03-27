close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
N=8;
output=[];
[m,n]=size(hall_gray);
num=m*n/64;
for k=1:8:m-7
for j=1:8:n-7
block=double(hall_gray(k:k+7,j:j+7));
block_dct=dct2(block-128);
block_q=round(block_dct./QTAB);
block_zz=ZigZag(block_q);
output=[output block_zz];
end
end
%DC
DC_code=[];
c=output(1,:);
c_diff=-diff(c);
c_diff=[c(1) c_diff];
for k=1:num
    cg=category(c_diff(k));
    bits=DCTAB(cg+1,1);
    DC_code=[DC_code DCTAB(cg+1,2:bits+1)];
    if c_diff(k)>0
    bin = bitget(c_diff(k),cg:-1:1);
    elseif c_diff(k)<0
    bin = double(~bitget(-c_diff(k),cg:-1:1));
    else
    bin=0;
    end
    DC_code=[DC_code bin];
end
%AC
AC_code = [];
ZRL = [1 1 1 1 1 1 1 1 0 0 1] ;
EOB = [1 0 1 0];
for i=1:num
run=0;
size1=0;
temp=output(:,i);
f=find(temp);
ed=f(end);
for w=2:ed
    t=temp(w);
    if t==0
        run=run+1;
        if run==16
            AC_code=[AC_code ZRL];
            run=0;
        end
    else
        size1=category(t);
        bits2=ACTAB(run*10+size1,3);
        AC_code=[AC_code ACTAB(run*10+size1,4:3+bits2)];
        if t>0
        bin = bitget(t,size1:-1:1);
        else 
        bin = double(~bitget(-t,size1:-1:1));
        end
        AC_code=[AC_code bin];
        run=0;
    end
end
AC_code=[AC_code EOB];
end
save('jpegcodes.mat','DC_code','AC_code','m','n');

    
    


    
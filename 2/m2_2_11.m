close all; clear all; clc;
load jpegcodes.mat;
load hall.mat;
load JpegCoeff.mat;
num=m*n/64;
c=zeros(64,num);
c_diff=zeros(1,num);
ratio=num2str(m*n*8/(length(AC_code)+length(DC_code)+length(dec2bin(m))+length(dec2bin(n)))); %计算压缩比
%DC_decode
for p=1:num
    for k=1:12
        bits=DCTAB(k,1);
        if DCTAB(k,2:1+bits)==DC_code(1:bits)
            break
        end
    end
    if k==1
        c_diff(1,p)=0;
        DC_code=DC_code(4:end);
    else
        bin=DC_code(bits+1:bits+k-1);
        DC_code=DC_code(bits+k:end);
        if bin(1)==1
            c_diff(1,p)=bin2dec(num2str(bin));
        else
            c_diff(1,p)=-bin2dec(num2str(double(~bin)));
        end
    end
    if p==1
        c(1,p)=c_diff(1,p);
    else
        c(1,p)=c(1,p-1)-c_diff(1,p);
    end
end
%AC_decode
acmap=containers.Map;
for i=1:160
    bitss=ACTAB(i,3);
    str_temp=num2str(ACTAB(i,4:3+bitss));
    acmap(str_temp)=ACTAB(i,1:3);
end
acmap('1  0  1  0')=[0 0 4];                %EOB
acmap('1  1  1  1  1  1  1  1  0  0  1')=[16 0 11];   %ZRL
flag=1;
count=1;
col=1;
col_temp=[];
while col<316               
    code_t=num2str(AC_code(1:count));
    judge=isKey(acmap,code_t);   %判断是否是map中的值
    if judge
        count=1;
        temp=acmap(code_t);
        run_t=temp(1); size_t=temp(2);bits_t=temp(3);
        if size_t~=0   %非EOB和ZRL的情况
            bin_t=AC_code(bits_t+1:bits_t+size_t);
            AC_code=AC_code(bits_t+size_t+1:end);
            if bin_t(1)==1
                dec_t=bin2dec(num2str(bin_t));
            else
                dec_t=-bin2dec(num2str(double(~bin_t)));
            end
            col_temp=[col_temp zeros(1,run_t) dec_t];
        else
            if run_t==16   %ZRL的情况
                AC_code=AC_code(bits_t+1:end);
                col_temp=[col_temp zeros(1,16)];
            else           %EOB的情况
                c(2:1+length(col_temp),col)=col_temp';
                col_temp=[];
                col=col+1;
                AC_code=AC_code(bits_t+1:end);
            end
        end
    else
        count=count+1 ;
    end
end
hall_ecode=zeros(m,n);
for k=1:8:m-7
    for j=1:8:n-7
        bs=(k-1)/8*n/8+(j+7)/8;
        block_izz=iZigZag(c(:,bs))  ;
        block_iq=block_izz.*QTAB;
        block_idct=idct2(block_iq)+128;
        hall_ecode(k:k+7,j:j+7)=block_idct;
    end
end
MSE=sum(sum((double(hall_gray)-hall_ecode).^2))/m/n;
PSNR = 10*log10(255^2/MSE);
disp(['PSNR =' ' ' num2str(PSNR)]);
disp(['ratio =' ' ' ratio]);
subplot(1,2,1),imshow(uint8(hall_ecode)),title('恢复后图形');
subplot(1,2,2),imshow(hall_gray),title('原图');
save('pic2_2_11','hall_ecode','ratio','PSNR');
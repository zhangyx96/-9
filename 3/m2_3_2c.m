%方法3 信息位追加在每个块ZIGZAG顺序的最后一个非零DCT系数之后
tic;
close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
[m,n]=size(hall_gray);
N=8;
[m,n]=size(hall_gray);
num=m*n/64;
info_new=2*randi([0 1],[1 num])-1;            %生成1，-1序列
hall_t=zeros(m,n);
output=[];
count=1;
%dct,量化
for k=1:8:m-7
    for j=1:8:n-7
        block=double(hall_gray(k:k+7,j:j+7));
        block_dct=dct2(block-128);
        block_q=round(block_dct./QTAB);
        block_zz=ZigZag(block_q);
        pp=find(block_zz~=0);            %找到所有非零元素
        if pp(end)~=length(block_zz)
            block_zz(pp(end)+1)=info_new(count);
        else
            block_zz(end)=info_new(count);
        end
        count=count+1;
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
%熵解码
ratio=num2str(m*n*8/(length(AC_code)+length(DC_code)+length(dec2bin(m))+length(dec2bin(n))));
c=zeros(64,num);
c_diff=zeros(1,num);
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
%AC
acmap=containers.Map;
for i=1:160
    bitss=ACTAB(i,3);
    str_temp=num2str(ACTAB(i,4:3+bitss));
    acmap(str_temp)=ACTAB(i,1:3);
end
acmap('1  0  1  0')=[0 0 4];
acmap('1  1  1  1  1  1  1  1  0  0  1')=[16 0 11];
flag=1;
count=1;
col=1;
col_temp=[];
while col<316
    code_t=num2str(AC_code(1:count));
    judge=isKey(acmap,code_t);
    if judge
        count=1;
        temp=acmap(code_t);
        run_t=temp(1);
        size_t=temp(2);
        bits_t=temp(3);
        if size_t~=0
            bin_t=AC_code(bits_t+1:bits_t+size_t);
            AC_code=AC_code(bits_t+size_t+1:end);
            if bin_t(1)==1
                dec_t=bin2dec(num2str(bin_t));
            else
                dec_t=-bin2dec(num2str(double(~bin_t)));
            end
            col_temp=[col_temp zeros(1,run_t) dec_t];
        else
            if run_t==16
                AC_code=AC_code(bits_t+1:end);
                col_temp=[col_temp zeros(1,16)];
            else
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
pe_ecode=zeros(m,n);
info_decrypted=[];
for k=1:8:m-7
    for j=1:8:n-7       
        bs=(k-1)/8*n/8+(j+7)/8;  %块个数
        pp=find(c(:,bs)~=0);
        info_decrypted=[info_decrypted c(pp(end),bs)];   %提取信息
        block_izz=iZigZag(c(:,bs));
        block_iq=block_izz.*QTAB;
        block_idct=round(idct2(block_iq))+128;
        pe_ecode(k:k+7,j:j+7)=block_idct;
    end
end
ise=num2str(sum(sum(info_decrypted==info_new))/length(info_new));
MSE=sum(sum((double(hall_gray)-pe_ecode).^2))/m/n;
PSNR = num2str(10*log10(255^2/MSE));
disp(['PSNR = ' PSNR]);
disp(['ratio = ' ratio]);
disp(['数据正确率 = ' ise]);
subplot(1,2,2),imshow(uint8(pe_ecode)),title('解压缩后图形');
subplot(1,2,1),imshow(hall_gray),title('原图');
toc;
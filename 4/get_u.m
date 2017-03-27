function density=get_u(a,L)
    [m,n,~]=size(a);
    density=zeros(1,2^(3*L));
    for k=1:m
        for j=1:n
            r=floor(a(k,j,1)*2^(L-8));
            g=floor(a(k,j,2)*2^(L-8));
            b=floor(a(k,j,3)*2^(L-8));
            color=b+g*(2^L)+r*2^(2*L);
            density(color+1)=density(color+1)+1;
        end
    end
    density=density./m./n;
end
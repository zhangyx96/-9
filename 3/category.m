function output=category(c)
if c~=0
    output=floor((log(abs(c))/log(2)))+1;
else 
    output=0;
end
return 
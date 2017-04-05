function[valmat]=vect2mat(windowsize,val)
len=length(val)-windowsize+1;
valmat=zeros(len,windowsize);
for dumi=1:windowsize
    valmat(:,dumi)=val(dumi:dumi+len-1); 
end
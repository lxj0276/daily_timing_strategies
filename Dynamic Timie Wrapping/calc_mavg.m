function[ma]=calc_mavg(windowsize,val,keephead)
temp=ones(1,windowsize);
ma=filter(temp,windowsize,val);
if ~keephead
    ma(1:windowsize-1)=NaN;
end
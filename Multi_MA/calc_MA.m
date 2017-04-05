function[ma]=calc_MA(n,vals)
ma=filter(ones(1,n),n,vals);
if n>1
    ma(1:n-1)=NaN;
end
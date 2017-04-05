function[normvals]=calc_mnorm(windowsize,val,centralized)
ma=calc_mavg(windowsize,val,0);
ma=ma(windowsize:end);
mamat=repmat(ma,1,windowsize);
valmat=vect2mat(windowsize,val);
std=sum((valmat-mamat).^2,2)/(windowsize-1);
if centralized
    normvals=bsxfun(@rdivide,valmat-mamat,std);
else
    normvals= bsxfun(@rdivide,valmat,std);
end


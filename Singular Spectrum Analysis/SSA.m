function[newvals]=SSA(m,vals)
lenval=length(vals);
if lenval<=m
    display('Window size too big!');
    newvals=NaN;
else
    tralen=lenval-m+1;
    tracemat=zeros(tralen,m);
    for dumi=1:m
        tracemat(:,dumi)=vals(dumi:(lenval-m+dumi));
    end 
    newvals=zeros(lenval,1);
    [U,S,V] = svd(tracemat,'econ');
    reconmat=S(1,1)*U(:,1)*(V(:,1)');
    if tralen<=m
        reconmat=reconmat';
        temp=tralen;
        tralen=m;
        m=temp;
    end        
    for dumj=1:lenval
        if dumj<=m
            tot=0;
            for dumk=1:dumj
                tot=tot+reconmat(dumj-dumk+1,dumk);
            end
            newvals(dumj)=tot/dumj;
        elseif dumj>m && dumj<=tralen
            tot=0;
            for dumk=1:m
                tot=tot+reconmat(dumj-dumk+1,dumk);
            end
            newvals(dumj)=tot/m;
        else
            tot=0;
            klen=(lenval-dumj+1);
            for dumk=flip(1:klen)
                tot=tot+reconmat(tralen- (klen-dumk)  ,m-dumk+1);
            end
            newvals(dumj)=tot/(lenval-dumj+1);
        end
    end
end


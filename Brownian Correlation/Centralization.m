function[normval]=Centralization(val,windowsize)
% calculate the centralized data matrix for a single column of data :val
lenval=length(val);
if windowsize>=lenval
    display('window too long!');
    normval=NaN;
else
    templen=lenval-windowsize+1;
    tempmat=zeros(templen,windowsize);    
    for dumi=1:windowsize
        tempmat(:,dumi)=val(dumi:dumi+templen-1);        
    end
    meanval=mean(tempmat,2);
    stdval=std(tempmat,0,2);
    normval=(tempmat-meanval*ones(1,windowsize))./(stdval*ones(1,windowsize));
end


function[selectedidx,checkidx]=SampleSelection(BCmat,samplenum,threshcorr)
% BCmat should be an upper triangular matrix
[len,~]=size(BCmat);
if samplenum>=len
    display('sample too long!');
    selectedidx=NaN;
else
    selectedidx=zeros(len,samplenum);
    checkidx=zeros(len,samplenum);
    for dumi=(samplenum+1):len
        tmpidx=1:(dumi-1);
        distances=BCmat(tmpidx,dumi);
        tmp=[tmpidx' distances];
        sorttmp=sortrows(tmp,-2); 
        selectedidx(dumi,:)=sorttmp(1:samplenum,1)';
        checkidx(dumi,:)=sorttmp(1:samplenum,2)'>threshcorr;
    end
end
selectedidx=selectedidx(samplenum+1:end,:);
checkidx=checkidx(samplenum+1:end,:);
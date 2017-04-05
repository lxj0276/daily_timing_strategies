function[signals,positions]=HistStatesSpace(data,paras,type)

%date=data(:,1);
cls=data(:,5);
vol=data(:,6);
ret=data(:,end);
%totlen=length(date);

windowlen=paras(1);
threshold=paras(2);
threshcorr=paras(3);
samplenum=30;
%predictlen=paras(4);

normcls=Centralization(cls,windowlen);
normvol=Centralization(vol,windowlen);

outlen=length(normcls); %len-windowlen+1
BCmat=diag(ones(outlen,1));
for row=1:(outlen-1)
    for col=(row+1):outlen
        tmpX=[normcls(row,:)' normvol(row,:)'];
        tmpY=[normcls(col,:)' normvol(col,:)'];
        BCmat(row,col)=BrownianCorrelation(tmpX,tmpY);
    end
end
[selectedidx,checkidx]=SampleSelection(BCmat,samplenum,threshcorr); %只是针对normal后的矩阵的index
actualidx=selectedidx+windowlen-1; %在实际序列中，末尾当天所对应的位置

selectlen=length(selectedidx); %len-windowlen+1-samplenum
%predret=zeros(selectlen,predictlen);
predret=zeros(selectlen,1);
for dumi=1:selectlen
%     for dumj=1:predictlen
%         predret(dumi,dumj)=mean(ret(actualidx(dumi,:)+dumj-1));
%     end
    tmpret=ret(actualidx(dumi,:)+1);
    predret(dumi,1)=mean(tmpret(checkidx(dumi,:)));
end
signals=(predret>threshold)-(predret<-threshold);
states=signals(1);
for i=2:selectlen
    samecheck=(states==signals(i) & signals(i)~=0);
    diffcheck=(states~=signals(i) & signals(i)~=0);
    if samecheck
        signals(i)=0;
    end
    if diffcheck
        states=signals(i);
    end
end
positions=calc_positions(signals,type);


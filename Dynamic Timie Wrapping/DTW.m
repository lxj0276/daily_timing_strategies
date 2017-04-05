function[signals,positions]=DTW(data,paras,skip,type,closeend)
vectlen=paras(1);
threshold=paras(2);
selectnum=10;

date=data(:,1);
cls=data(:,5);
vol=data(:,6);
rets=[0;cls(2:end)./cls(1:end-1)-1];
totlen=length(date);
start=find(date>=skip,1); %skip以后开始发信号

%normalize the data
centralized=0;
normcls=calc_mnorm(vectlen,cls,centralized);
normvol=calc_mnorm(vectlen,vol,centralized);
normcls=[zeros(vectlen-1,vectlen);normcls];
normvol=[zeros(vectlen-1,vectlen);normvol];
totvect=zeros(totlen*2,vectlen);
odd=mod((1:totlen*2)',2)==1;
even=(1-odd)==1;
totvect(odd,:) =normcls;
totvect(even,:)=normvol;

predret=zeros(totlen,1);
for dumi=start:totlen  %start - vectlen 必须要大于 selectnum
    currvect=totvect(2*dumi-1:2*dumi,:);
    distances=zeros(dumi-vectlen,1);
    for dumj=vectlen:(dumi-1)
        tempvect=totvect(2*dumj-1:2*dumj,:);
        distances(dumj-vectlen+1)=calc_dtw_dist(currvect,tempvect,vectlen);
    end
    idx=(1:dumi-vectlen)';
    dist=[idx distances rets(vectlen+1:dumi)];
    sortdist=sortrows(dist,2);
    selectdist=sortdist(1:selectnum,:);
    weights=1./selectdist(:,2);
    predret(dumi)=sum(weights.*selectdist(:,3))/sum(weights);    
end

signals=(predret>threshold)-(predret<-threshold);
states=signals(start);
for i=(start+1):totlen
    samecheck=(states==signals(i) & signals(i)~=0);
    diffcheck=(states~=signals(i) & signals(i)~=0);
    if samecheck
        signals(i)=0;
    end
    if diffcheck
        states=signals(i);
    end
end
signals=signals(start:end);
positions=calc_positions(signals,type);
if closeend %数据结尾强制平仓
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end
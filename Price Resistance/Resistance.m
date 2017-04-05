function[signals,positions]=Resistance(data,paras,skip,type,closeend)
windowsize=paras(1);
lower=paras(2);
upper=paras(3);

date=data(:,1);
close=data(:,5);
amt=data(:,7);
totlen=length(date);
start=find(date>=skip,1); %skip以后开始发信号

weights_dist=log(2:(windowsize+1))/log(windowsize+1);
weights_dist=weights_dist';

resistance=zeros(totlen,1);
signals=zeros(totlen,1);
for dumi=(windowsize+1):totlen
    idx=(dumi-windowsize):(dumi-1);
    weights_prc=log( close(dumi)./abs(close(idx)-close(dumi)) );
    base=amt(idx).*weights_prc.*weights_dist;
    resistance(dumi)=sum(base.*(close(idx)>close(dumi)))/sum(base);    
    signals(dumi)=(resistance(dumi)<lower)-(resistance(dumi)>upper);
end
signals(1:(start-1))=0;

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
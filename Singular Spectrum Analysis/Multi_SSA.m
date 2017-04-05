function[signals,positions]=Multi_SSA(data,paras,skip,type,closeend)

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

paralen=length(paras);
allsigs=zeros(totlen,paralen);

for dumi=(paras(end)+1):totlen
    tmpprc=prices(1:dumi);
    for dumj=1:paralen
        tmpssa=SSA(paras(dumj),tmpprc);
        allsigs(dumi,dumj)=(tmpssa(end)>tmpssa(end-1))-(tmpssa(end)<tmpssa(end-1));
    end
end

sigs=sum(allsigs,2);
signals=(sigs>0)-(sigs<0);
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

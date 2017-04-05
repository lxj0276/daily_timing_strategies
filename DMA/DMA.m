function[signals,positions]=DMA(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);
m=paras(3);

date=data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

sums=sum(prices((long-short+1):long));
suml=sum(prices(1:long));
dma=zeros(totlen,1);
dma(1:(long-1))=NaN;
dma(long)=sums/short-suml/long;
ama=zeros(totlen,1);
ama(1:(long+m-2))=NaN;
sumama=0;

for i=(long+1):totlen
    sums=sums+prices(i)-prices(i-short);
    suml=suml+prices(i)-prices(i-long);
    mas=sums/short;
    mal=suml/long;
    dma(i)=mas-mal;
    if i==long+m-1
       sumama=sum(dma((i-m+1):i));
       ama(i)=sumama/m;
    end
    if i>long+m-1
        sumama=sumama+dma(i)-dma(i-m);
        ama(i)=sumama/m;
    end
end

signals=zeros(totlen-1,1);
signals((dma(2:totlen)>dma(1:(totlen-1))) & (dma(2:totlen)>ama(2:totlen)) & (dma(1:(totlen-1))<ama(1:(totlen-1))))=1;
signals((dma(2:totlen)<dma(1:(totlen-1))) & (dma(2:totlen)<ama(2:totlen)) & (dma(1:(totlen-1))>ama(1:(totlen-1))))=-1;
signals=[0;signals];
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
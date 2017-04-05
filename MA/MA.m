function[signals,positions]=MA(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

sums=sum(prices((long-short+1):long));
suml=sum(prices(1:long));
sma=zeros(totlen,1);
lma=zeros(totlen,1);
sma(1:(long-1))=NaN;
lma(1:(long-1))=NaN;
sma(long)=sums/short;
lma(long)=suml/long;

for i=(long+1):totlen
    sums=sums+prices(i)-prices(i-short);
    suml=suml+prices(i)-prices(i-long);
    sma(i)=sums/short;
    lma(i)=suml/long;
end

signals=zeros(totlen-1,1);
signals((sma(2:totlen)>sma(1:(totlen-1))) & (sma(2:totlen)>lma(2:totlen)) & (sma(1:(totlen-1))<lma(1:(totlen-1))))=1;
signals((lma(2:totlen)<lma(1:(totlen-1))) & (sma(2:totlen)<lma(2:totlen)) & (sma(1:(totlen-1))>lma(1:(totlen-1))))=-1;
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
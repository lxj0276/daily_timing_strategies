function[signals,positions]=MACD(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);
m=paras(3);

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

short_a=2/(short+1);
short_b=1-short_a;
long_a=2/(long+1);
long_b=1-long_a;
dif_a=2/(m+1);
dif_b=1-dif_a;

emas=prices(1);
emal=prices(1);
dif=zeros(totlen,1);
dif(1)=emas-emal;
dea=zeros(totlen,1);
dea(1)=dif(1)*dif_a;

for i=2:totlen
    emas=prices(i)*short_a+emas*short_b;
    emal=prices(i)*long_a+emal*long_b;
    dif(i)=emas-emal;
    dea(i)=dif(i)*dif_a+dea(i-1)*dif_b;
end

signals=zeros(totlen-1,1);
signals((dif(2:totlen)>dif(1:(totlen-1))) & (dif(2:totlen)>dea(2:totlen)) & (dif(1:(totlen-1))<dea(1:(totlen-1))) & (dif(2:totlen)>0))=1;
signals((dif(2:totlen)<dif(1:(totlen-1))) & (dif(2:totlen)<dea(2:totlen)) & (dif(1:(totlen-1))>dea(1:(totlen-1))) & (dif(2:totlen)<0))=-1;
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
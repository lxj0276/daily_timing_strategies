function[signals,positions]=TRIX(data,paras,skip,type,closeend)
n=paras(1);
m=paras(2);

date=data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

n_a=2/(n+1);
n_b=1-n_a;

ema1=prices(1);
ema2=prices(1);
ema3=prices(1);
tr=zeros(totlen,1);
tr(1)=ema3;
trix=zeros(totlen,1);
matrix=zeros(totlen,1);
matrix(1:(m-1))=NaN;
sumtrix=0;
for i=2:totlen
    ema1=prices(i)*n_a+ema1*n_b;
    ema2=ema1*n_a+ema2*n_b;
    ema3=ema2*n_a+ema3*n_b;
    tr(i)=ema3;
    trix(i)=(tr(i)/tr(i-1)-1)*100;
    if i==m
        sumtrix=sum(trix(1:i));
    end
    if i>m
        sumtrix=sumtrix+trix(i)-trix(i-m);
    end
    matrix(i)=sumtrix/m;
end

signals=zeros(totlen-1,1);
signals((trix(2:totlen)>trix(1:(totlen-1))) & (trix(2:totlen)>matrix(2:totlen)) & (trix(1:(totlen-1))<matrix(1:(totlen-1))))=1;
signals((trix(2:totlen)<trix(1:(totlen-1))) & (trix(2:totlen)<matrix(2:totlen)) & (trix(1:(totlen-1))>matrix(1:(totlen-1))))=-1;
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
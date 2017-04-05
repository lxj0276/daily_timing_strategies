function[signals,positions]=voldiff_rps(data,paras,skip,type,closeend)

N=paras(1);
M=paras(2);
binnum=paras(3);
size=paras(4);

date  =data(:,1);
opn=data(:,2);
high=data(:,3);
low=data(:,4);
cls=data(:,5);
ret=[0;cls(2:end)./cls(1:end-1)-1];
totlen=length(date);
start=find(date>=skip,1); %skip以后开始发信号

%计算波动差
voldiff=(high+low)./opn-2;

%计算RPS and maRPS
maxret=zeros(totlen,1);
minret=maxret;
for dumi=N:totlen
    maxret(dumi)=max(ret(dumi-N+1:dumi));
    minret(dumi)=min(ret(dumi-N+1:dumi));
end
RPS=(ret-minret)./(maxret-minret)*100;
RPS(1:N-1)=NaN;
maRPS=filter(ones(1,M),M,RPS);
maRPS(1:(max(N,M)-1))=NaN;

%计算移动波动差
binsize=100/binnum;
actbinsize=(size/100)*binsize;
ma_voldiff=zeros(totlen,1);
for dumi=N:totlen
    movlen=min(ceil(maRPS(dumi)/binsize)*actbinsize,dumi);
    ma_voldiff(dumi)=mean(voldiff(dumi-movlen+1:dumi));
end

signals=(ma_voldiff>0)-(ma_voldiff<0);
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




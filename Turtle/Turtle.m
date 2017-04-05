function[signals,positions]=Turtle(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);

date=data(:,1);
prices=data(:,5);
totlen=length(prices);

positions=zeros(totlen,1);
signals=zeros(totlen,1);

longMax=zeros(totlen,1);
longMin=zeros(totlen,1);
shortMax=zeros(totlen,1);
shortMin=zeros(totlen,1);

for dumi=long:totlen
    longMax(dumi) =max( prices((dumi-long+1):dumi) );
    longMin(dumi) =min( prices((dumi-long+1):dumi) );
    shortMax(dumi)=max( prices((dumi-short+1):dumi) );
    shortMin(dumi)=min( prices((dumi-short+1):dumi) );
end

prepos=0;
start=find(date>=skip,1); %skip以后开始发信号
for dumi=(start+1):totlen
    if prepos==0
        signals(dumi)=(prices(dumi)>longMax(dumi-1))-(prices(dumi)<longMin(dumi-1));
        positions(dumi)=prepos;
        prepos=signals(dumi);
        continue;
    elseif prepos==1
        signals(dumi)=-(prices(dumi)<shortMin(dumi-1));
        positions(dumi)=prepos;
        if abs(signals(dumi))
            if prices(dumi)<longMin(dumi-1)
                prepos=-1;
            else
                prepos=0;
            end
        end
        continue;
    elseif prepos==-1
        signals(dumi)=prices(dumi)>shortMax(dumi-1);
        positions(dumi)=prepos;
        if abs(signals(dumi))
            if prices(dumi)>longMax(dumi-1)
                prepos=1;
            else
                prepos=0;
            end
        end
        continue;
    end    
end
positions=positions(start:end);
if abs(type)
    positions=floor((positions+type)/2);
end
signals=signals(start:end);
if closeend %数据结尾强制平仓
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end

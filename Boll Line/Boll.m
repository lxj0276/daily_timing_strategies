function[signals,positions]=Boll(data,paras,skip,type,closeend)
% type=0  long short
% type=1  long only
% type=-1 short only

n=paras(1);
c=paras(2);

date=data(:,1);
prices=data(:,5);
totlen=length(prices);

positions=zeros(totlen,1);
signals=zeros(totlen,1);

Upper=zeros(totlen,1);
Lower=zeros(totlen,1);
Mid=zeros(totlen,1);

total=sum(prices(1:n));
vstd=std(prices(1:n));
Mid(n)=total/n;
Upper(n)=Mid(n)+c*vstd;
Lower(n)=Mid(n)-c*vstd;
for dumi=(n+1):totlen
    total=total+prices(dumi)-prices(dumi-n);
    Mid(dumi)=total/n;
    vstd=std(prices((dumi-n+1):dumi));
    Upper(dumi)=Mid(dumi)+c*vstd;
    Lower(dumi)=Mid(dumi)-c*vstd;    
end

prepos=0;
start=find(date>=skip,1);
for dumi=start:totlen
    if prepos==0
        signals(dumi)=(prices(dumi)>Upper(dumi))-(prices(dumi)<Lower(dumi));
        positions(dumi)=prepos;
        prepos=signals(dumi);
        continue;
    elseif prepos==1
        signals(dumi)=-(prices(dumi)<Mid(dumi));
        positions(dumi)=prepos;
        if abs(signals(dumi))
            if prices(dumi)<Lower(dumi)
                prepos=-1;
            else
                prepos=0;
            end
        end
        continue;
    elseif prepos==-1
        signals(dumi)=prices(dumi)>Mid(dumi);
        positions(dumi)=prepos;
        if abs(signals(dumi))
            if prices(dumi)>Upper(dumi)
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
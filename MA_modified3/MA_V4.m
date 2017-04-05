function[signals,positions]=MA_V4(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);
filt=paras(3);

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号

%计算MA
temps=ones(1,short);
templ=ones(1, long);
tempf=ones(1, filt);
sma=filter(temps,short,prices);
lma=filter(templ, long,prices);
fma=filter(tempf, filt,prices);
sma(1:(filt-1))=NaN;
lma(1:(filt-1))=NaN;
fma(1:(filt-1))=NaN;

golden=zeros(totlen,1);
death =zeros(totlen,1);
golden(2:end)=(sma(2:totlen)>sma(1:(totlen-1))) & (sma(2:totlen)>lma(2:totlen)) & (sma(1:(totlen-1))<lma(1:(totlen-1)));
death(2:end) =(lma(2:totlen)<lma(1:(totlen-1))) & (sma(2:totlen)<lma(2:totlen)) & (sma(1:(totlen-1))>lma(1:(totlen-1)));
golden(1:long)=0;
death(1:long)=0;

signals=zeros(totlen,1);
hold=0;
for dumi=start:totlen
    if hold==0
        tempsig=golden(dumi)-death(dumi);
        if tempsig>0
            signals(dumi)=tempsig*(type>=0)*(prices(dumi)>fma(dumi));
        elseif tempsig<0
            signals(dumi)=tempsig*(type<=0)*(prices(dumi)<fma(dumi));
        end
        if abs(signals(dumi))
            hold=signals(dumi);
        end
    elseif hold==1 %如果type为-1则不会进入该分支
        if death(dumi) % && (prices(dumi)<fma(dumi)) 止损是够加过滤
            signals(dumi)=-1;
            hold=-(type==0);
        else
            continue;
        end
    elseif hold==-1
        if golden % && (prices(dumi)>fma(dumi))
            signals(dumi)=1;
            hold=(type==0);
        else
            continue;
        end
    end
end
signals=signals(start:end);
positions=calc_positions(signals,type);
if closeend %数据结尾强制平仓
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end
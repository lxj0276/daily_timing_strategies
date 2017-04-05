function[signals,positions]=MA_RSI(data,paras,skip,type,closeend)
short=paras(1);
long=paras(2);
n=paras(3);
lower=paras(4);
upper=100-lower;

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip�Ժ�ʼ���ź�

% construction of MA
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

golden=zeros(totlen,1);
death =zeros(totlen,1);
golden(2:end)=(sma(2:totlen)>sma(1:(totlen-1))) & (sma(2:totlen)>lma(2:totlen)) & (sma(1:(totlen-1))<lma(1:(totlen-1)));
death(2:end) =(lma(2:totlen)<lma(1:(totlen-1))) & (sma(2:totlen)<lma(2:totlen)) & (sma(1:(totlen-1))>lma(1:(totlen-1)));
golden(1:long)=0;
death(1:long)=0;

% construction of RSI
prcdif=[0;prices(2:end)-prices(1:end-1)];
positive= (prcdif>0).*prcdif;
negative=-(prcdif<0).*prcdif;
possum=zeros(totlen,1);
negsum=zeros(totlen,1);
possum(n)=sum(positive(1:n));
negsum(n)=sum(negative(1:n));
RS=zeros(totlen,1);
for dumi=(n+1):totlen
    possum(dumi)=possum(dumi-1)+positive(dumi)-positive(dumi-n);
    negsum(dumi)=negsum(dumi-1)+negative(dumi)-negative(dumi-n);
end
RS(n:end)=possum(n:end)./negsum(n:end);
RSI=100*RS./(1+RS);

signals=zeros(totlen,1);
hold=0;
entprc=0; %�������������볡�ۣ���Ϊ�ն���ʱ���źź�ڶ���Ŀ��̼۽����������һ������
for dumi=start:totlen
    if hold==0
        tempsig=golden(dumi)-death(dumi);
        if tempsig>0
            signals(dumi)=tempsig*(type>=0)*(RSI(dumi)<=lower);
        elseif tempsig<0
            signals(dumi)=tempsig*(type<=0)*(RSI(dumi)>=upper);
        end
        if abs(signals(dumi))
            hold=signals(dumi);
            entprc=prices(dumi);
        end
    elseif hold==1 %���typeΪ-1�򲻻����÷�֧
        if death(dumi) && (prices(dumi)<entprc)
            signals(dumi)=-1;
            hold=-(type==0);
        elseif golden(dumi)
            entprc=prices(dumi); %update entprc
        else
            continue;
        end
    elseif hold==-1
        if golden && (prices(dumi)>entprc)
            signals(dumi)=1;
            hold=(type==0);
        elseif death(dumi)
            entprc=prices(dumi);
        else
            continue;
        end
    end
end
signals=signals(start:end);
positions=calc_positions(signals,type);
if closeend %���ݽ�βǿ��ƽ��
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end









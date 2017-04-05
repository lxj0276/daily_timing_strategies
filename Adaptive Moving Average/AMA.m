function[signals,positions]=AMA(data,paras,skip,type,closeend)
N=paras(1);
a=paras(2);
b=paras(3);
thr=paras(4);
pw=paras(5);

date=data(:,1);
cls=data(:,5);
totlen=length(date);
start=find(date>=skip,1); %skip�Ժ�ʼ���ź�

absdif=[0;abs(cls(2:end)-cls(1:end-1))];
ER=zeros(totlen,1);
weights=zeros(totlen,1);
AMA=zeros(totlen,1);
for dumi=N:totlen
    alldif=abs(cls(dumi)-cls(dumi-N+1));
    sumdif=sum(absdif((dumi-N+1):dumi));
    ER(dumi)=alldif/sumdif;    
    weights(dumi)=(min(ER(dumi)*a+b,0.99))^pw;
    AMA(dumi)=weights(dumi)*cls(dumi)+(1-weights(dumi))*cls(dumi-1);
end

signals=[0;(AMA(2:end)./AMA(1:end-1)-1>thr) - (AMA(2:end)./AMA(1:end-1)-1<-thr)];
signals(1:(start-1))=0;

states=signals(start); %����Ч�źŴ���ʼ����
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
if closeend %���ݽ�βǿ��ƽ��
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end
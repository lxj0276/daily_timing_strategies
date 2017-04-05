function[signals,positions]=SLM(data,paras,skip,type,closeend)

basenum=paras(1);
windowlen=paras(2);
threshold=paras(3); %��������С��������

date=data(:,1);
clsprc=data(:,5); 
[totlen,~]=size(data);
start=find(date>=skip,1); %skip�Ժ�ʼ���ź�

pctchg=[0;clsprc(2:end)./clsprc(1:(end-1))-1];

% ״̬����
if basenum==2  %ʹ�ö�����
    %long 1, short 0
    states=(pctchg>0);
elseif basenum==3 && ~isnan(threshold)  %ʹ��������
    %long 2, hold 1, short 0
    states=(pctchg>=abs(threshold))-(pctchg<=-abs(threshold))+1;
end

%״̬���
signals=zeros(totlen,1);
counters=zeros(1,basenum^windowlen);
for dumi=(windowlen+1):totlen
    if dumi>=start  %start�Ժ�ʼ���ź�,��ǰֻ����counter
        topred0=[states((dumi-windowlen+2):dumi);0];
        topred1=[states((dumi-windowlen+2):dumi);1];
        prdnum0=States_Number_Trans(topred0',basenum,1)+1; %��counter�е�λ��
        prdnum1=States_Number_Trans(topred1',basenum,1)+1;
        if basenum==3
            topred2=[states((dumi-windowlen+2):dumi);2];
            prdnum2=States_Number_Trans(topred2',basenum,1)+1;
        end        
        if basenum==2
            signals(dumi)=(counters(prdnum1)>counters(prdnum0))-(counters(prdnum1)<counters(prdnum0));
        elseif basenum==3
            signals(dumi)=(counters(prdnum2)>max(counters(prdnum0),counters(prdnum1)))-(counters(prdnum0)>max(counters(prdnum2),counters(prdnum1)));
        end
    end
    realstates=states((dumi-windowlen+1):dumi);
    realnumber=States_Number_Trans(realstates',basenum,1)+1;
    counters(realnumber)=counters(realnumber)+1;
end
signals(1:(start-1))=0;

firststate=signals(start);
for i=(start+1):totlen
    samecheck=(firststate==signals(i) & signals(i)~=0);
    diffcheck=(firststate~=signals(i) & signals(i)~=0);
    if samecheck
        signals(i)=0;
    end
    if diffcheck
        firststate=signals(i);
    end
end
signals=signals(start:end);
positions=calc_positions(signals,type);
if closeend %���ݽ�βǿ��ƽ��
    if positions(end)~=0
        signals(end)=-positions(end);
    end
end
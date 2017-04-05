function[signals,positions]=Multi_MA(data,paras,skip,type,closeend)

manum=length(paras)-1;
%distribution=AllPermsDist(manum);
temp=load(['distribution' num2str(manum)]);
distribution=temp(1).distribution;

date  =data(:,1);
prices=data(:,5);
totlen=length(prices);
start=find(date>=skip,1); %skip以后开始发信号
margin=paras(end);

ma_mat=zeros(totlen,manum);
for dumi=1:manum
   ma_mat(:,dumi)=calc_MA(paras(dumi),prices); 
end

% 排序后，逆序数小说明多头强势，逆序数大说明空头强势
%margin=0.05;
index=1:manum;
revorders=zeros(totlen,1);
signals=zeros(totlen,1);
for dumi=(start-1):totlen
    mavals=ma_mat(dumi,:);
    sorted=sortrows([index;mavals]',2);
    revorders(dumi)=ReverseOrderCount(sorted(:,1));
    if dumi>=start
       delta=distribution(revorders(dumi)+1)-distribution(revorders(dumi-1)+1);
       signals(dumi)=(delta>=margin)-(delta<=-margin);
    end
end
%revorders(1:start-2)=NaN;
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
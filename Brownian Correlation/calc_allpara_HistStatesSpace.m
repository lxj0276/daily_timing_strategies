function[parasdata]=calc_allpara_HistStatesSpace(data,tscost,type,lowers,uppers,stepsize)
date=data(:,1);
opnprc=data(:,2);
clsprc=data(:,5);

parasdata=struct('tableK',{});
allparas=TestParasGen(lowers,uppers,stepsize);
[paralen,~]=size(allparas);

for dumi=1:paralen
    paras=allparas(dumi,:);    
    [signals,positions]=HistStatesSpace(data,paras,type);
    [returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost);
    tableK=array2table([date signals,positions,points,returns,netval],'VariableNames',...
        {'date','signals','positions','points','returns','netval'});
    tableK=tableK((windowsize+1):end,:);
    indicators=validation_indicators(tableK);
    tmptb=[tableK indicators];
    parasdata(dumi).tableK=tmptb;    
end

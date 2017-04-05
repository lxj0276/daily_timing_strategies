function[tableK]=calc_test_single(data,paras,tscost,type)
date=data(:,1);
opnprc=data(:,2);
clsprc=data(:,5);

windowlen=paras(1);
samplenum=paras(2);

date=date(windowlen+samplenum:end);
opnprc=opnprc(windowlen+samplenum:end);
clsprc=clsprc(windowlen+samplenum:end);

[signals,positions]=HistStatesSpace(data,paras,type);
[returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost);
tableK=array2table([date signals,positions,points,returns,netval],'VariableNames',...
    {'date','signals','positions','points','returns','netval'});
indicators=validation_indicators(tableK);
tableK=[tableK indicators];

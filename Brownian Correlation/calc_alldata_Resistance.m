clear;

%indices={'000001','000300','000905','000016','399001'};
indices={'000001','000300','000905'};
tscost=2/1000;
type=1;

lowers  =[10, 0.05, 0.95];
uppers  =[60, 0.3,  0.99];
stepsize=[5,  0.05, 0.01];

start=20000101;

tic
for dumi=1:length(indices)
    index=indices{dumi};
    file=strcat('D:\Works\Strategies\Trend Following\指数日度数据\day',index,'.csv');
    data=csvread(file,0,0);
    
    idx=(data(:,1)>=start);
    trddata=data(idx,:);
    
    [parasdata]=calc_allpara_HistStatesSpace(trddata,tscost,type,lowers,uppers,stepsize);
    assignin('base',strcat('alldata',indices{dumi}),parasdata);
    save(strcat('alldata',indices{dumi}),strcat('alldata',indices{dumi}));
    clear(strcat('alldata',indices{dumi}));
end
toc

%%


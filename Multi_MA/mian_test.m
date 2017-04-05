clc;
clear;

%%

data=csvread('D:\Works\Strategies\Trend Following\指数日度数据\day000001.csv',1,0);
skip=20000101;
paras=[5,10,15,20,25,30,35,40,45,0.1];
type=1;
closeend=1;
tscost=2/1000;
func=@Multi_MA;

%%

[tableK]=calc_test_single(data,paras,tscost,type,skip,func);
%%
figure(1);
plot(table2array(tableK(:,'netval')));
hold on;
bg=(data(:,1)>=skip);
plot(data(bg,5)./data(find(bg,1),5));


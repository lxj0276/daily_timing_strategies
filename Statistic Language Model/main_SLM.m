clear;
clc;

indices={'000001','000300','000905','000016','399001'};
types={'annret','sharp','calmar'};

tscost=2/1000;
type=1;

lowers=  [3, 5 , 0.01];
uppers=  [3, 15, 0.05];
stepsize=[1, 1 , 0.01];

% lowers=  [2, 5 , 1];
% uppers=  [2, 20, 1];
% stepsize=[1, 1 , 1];
windowlen=uppers(2)+1;
paraskip=zeros(prod(floor((uppers-lowers)./stepsize)+1),1);

starts=[19960101,20050408,20070115,20040102,19960101]; %数据截取开始日
skips =[20000101,20060101,20080101,20050101,20000101]; %开始发信号日期
trains=[20010101,20070101,20090101,20060101,20010101]; %外推开始计算日
ends  =[20160630,20160630,20160630,20160630,20160630]; %截取数据结束日

func=@SLM;

%%
[errors]=calc_alldata(indices,lowers,uppers,stepsize,skips,type,tscost,starts,ends,paraskip,func);
errors

%%
[errors_best]=bestparas_all_final(indices,types,lowers,uppers,stepsize,trains,paraskip);
errors_best

%%
[errors_out]=outsample_validation(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_out

%%
[errors_in]=insample_validation(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_in

%%
errors_insp=calc_inspdata(indices,lowers,uppers,stepsize,trains,type,tscost,starts,ends,paraskip,func);
errors_insp

%%
load('validation_result_in');
load('validation_result_out');
[valresults,idxresults]=Output_Insample_Best(indices,types,paraskip);
temp=[valresults;Output_Validation_Result(validation_result_in);Output_Validation_Result(validation_result_out)]

%%
[errors_out_cont]=outsample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_out_cont

%%
[errors_in_cont]=insample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_in_cont
%%
load('validation_result_in_continue');
load('validation_result_out_continue');
temp2=[Output_Validation_Result(validation_result_in_continue);Output_Validation_Result(validation_result_out_continue)]

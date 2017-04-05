clear;
clc;

indices={'000001','000300','000905','000016','399001'};
types={'annret','sharp','calmar'};

tscost=2/1000;
type=1;

lowers=[5 ,10,20,30,40,50,60,0.05];
uppers=[10,20,30,40,50,60,70,0.3];
stepsize=[5,5,5,5,5,5,5,0.05];

windowlen=uppers(end-1);
testparas=TestParasGen(lowers,uppers,stepsize);
temp=ones(length(testparas),1);
for dumi=1:(length(lowers)-2)
   temp=temp & (testparas(:,dumi)<testparas(:,dumi+1));
end
paraskip=~temp;

starts=[19960101,20050408,20070115,20040102,19960101]; %���ݽ�ȡ��ʼ��
skips =[20000101,20060101,20080101,20050101,20000101]; %��ʼ���ź�����
trains=[20010101,20070101,20090101,20060101,20010101]; %���ƿ�ʼ������
ends  =[20160630,20160630,20160630,20160630,20160630]; %��ȡ���ݽ�����

func=@Multi_MA;

%%
[errors]=calc_alldata(indices,lowers,uppers,stepsize,skips,type,tscost,starts,ends,paraskip,func);
errors

%%
errors_insp=calc_inspdata(indices,lowers,uppers,stepsize,trains,type,tscost,starts,ends,paraskip,func);
errors_insp

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
[errors_out_cont]=outsample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_out_cont

%%
[errors_in_cont]=insample_validation_continue(indices,types,type,tscost,skips,trains,ends,windowlen,func);
errors_in_cont


%%
load('validation_result_in');
load('validation_result_out');
load('validation_result_in_continue');
load('validation_result_out_continue');
[valresults,idxresults]=Output_Insample_Best(indices,types,paraskip);
temp=[valresults;Output_Validation_Result(validation_result_in);Output_Validation_Result(validation_result_out);...
      Output_Validation_Result(validation_result_in_continue);Output_Validation_Result(validation_result_out_continue)]

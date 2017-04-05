function[dist]=calc_dtw_dist(var1,var2,windowsize)
%var1\var2 can be matrices with row to be the variable dimension and col
%the vector's length, ����var1,var2��С���� O(windowsize^2)
[r1,c1]=size(var1);
[r2,c2]=size(var2);
if windowsize<min(c1,c2)
    row=windowsize;
    col=windowsize;
else
    row=c1;
    col=c2;
end
%�Ը���ά�ȵľ��������м�����Ϊ�ܾ��������ȷ������ά������������֮��ģ����ܲ�������
distmat=zeros(row,col);
for dumi=1:min(r1,r2)
   distmat=distmat + (bsxfun(@minus,var1(dumi,:)',var2(dumi,:))).^2; 
end
distmat=rot90(distmat.^(0.5),2); %��ʱ���Ͽ�����ת��������Ͻǵ�λ��Ϊ����ʱ���Ӧ����
cumdistmat=calc_dtw_distmat(distmat);
dist=cumdistmat(end,end);
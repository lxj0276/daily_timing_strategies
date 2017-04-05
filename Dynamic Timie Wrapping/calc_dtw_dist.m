function[dist]=calc_dtw_dist(var1,var2,windowsize)
%var1\var2 can be matrices with row to be the variable dimension and col
%the vector's length, 计算var1,var2最小距离 O(windowsize^2)
[r1,c1]=size(var1);
[r2,c2]=size(var2);
if windowsize<min(c1,c2)
    row=windowsize;
    col=windowsize;
else
    row=c1;
    col=c2;
end
%对各个维度的距离矩阵进行加总作为总距离矩阵，需确保各个维度数据是正则化之后的，加总才有意义
distmat=zeros(row,col);
for dumi=1:min(r1,r2)
   distmat=distmat + (bsxfun(@minus,var1(dumi,:)',var2(dumi,:))).^2; 
end
distmat=rot90(distmat.^(0.5),2); %从时间上看，翻转后矩阵左上角的位置为最新时间对应距离
cumdistmat=calc_dtw_distmat(distmat);
dist=cumdistmat(end,end);
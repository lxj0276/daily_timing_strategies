function[dtwmat]=calc_dtw_distmat(distmat)
%计算最小累计距离矩阵 O(mn)
[row,col]=size(distmat);
newdist=[inf(1,col+1);[inf(row,1) distmat]];
newdist(1,1)=0;
%dtwmat=zeros(row,col);
for dumi=1:row
    for dumj=1:col
        newdist(dumi+1,dumj+1)=newdist(dumi+1,dumj+1)+min(min(newdist(dumi,dumj),newdist(dumi+1,dumj)),newdist(dumi,dumj+1));
    end
end
dtwmat=newdist(2:end,2:end);
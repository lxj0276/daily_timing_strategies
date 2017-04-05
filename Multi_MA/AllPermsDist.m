function[distribution]=AllPermsDist(n)

%应用字典序全排列算法，生成n全排列的逆序分布
arrays=1:n;
distribution=zeros(1,n*(n-1)/2+1);
distribution(1)=1;

invnum=fliplr(2:n);

while ~CheckOrder(arrays)
    for dumi=invnum
        if arrays(dumi-1)<arrays(dumi)
           toreplace=dumi-1;     
           break;
        end        
    end
    for dumi=(toreplace+1):n
        if arrays(dumi)>arrays(toreplace)
            replace=dumi;
        end
    end
    temp=arrays(toreplace);
    arrays(toreplace)=arrays(replace);
    arrays(replace)=temp;
    arrays(toreplace+1:end)=fliplr(arrays(toreplace+1:end));
    revorder=ReverseOrderCount(arrays);
    distribution(revorder+1)=distribution(revorder+1)+1;
end
distribution=cumsum(distribution/sum(distribution));
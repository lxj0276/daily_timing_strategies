function[count]=AllPerms(n)
%×ÖµäĞòÈ«ÅÅÁĞ
arrays=1:n;
display(1:n);
count=1;

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
    display(arrays);
    count=count+1;
end
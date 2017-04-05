function[done]=CheckOrder(arrays)
done=1;
n=length(arrays);
for dumi=1:(n-1)
    if arrays(dumi)<arrays(dumi+1)
        done=0;
    end
end

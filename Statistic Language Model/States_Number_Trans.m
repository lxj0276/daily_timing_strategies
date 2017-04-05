function[transfered]=States_Number_Trans(totrans,basenum,tp)
if tp % states to number
    states=totrans;
    transfered=0;
    len=length(states);
    for dumi=fliplr(1:len)
        transfered=transfered+states(dumi)*basenum^(len-dumi);
    end
else % number to states
    number=totrans;
    templen=20;
    while number>basenum^templen
        templen=templen*2;
    end
    tempstates=zeros(1,templen);
    count=1;
    while number>1
        quotient=floor(number/basenum);
        reminder=number-quotient*basenum;
        tempstates(count)=reminder;
        number=quotient;
        count=count+1;
    end
    tempstates(count)=number;
    transfered=fliplr(tempstates(1:count));    
end
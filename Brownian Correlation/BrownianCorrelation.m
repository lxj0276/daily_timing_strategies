function[corrXY]=BrownianCorrelation(X,Y)
% X,Y have observatins along the rows
len=length(X);
matX=zeros(len,len);
matY=zeros(len,len);

for dumi=1:len
    for dumj=dumi:len
        matX(dumi,dumj)=norm(X(dumi,:)-X(dumj,:));
        matY(dumi,dumj)=norm(Y(dumi,:)-Y(dumj,:));
    end
end
distX=matX+matX';
distY=matY+matY';
meanX=mean(distX);
meanY=mean(distY);
centdistX=distX-ones(len,1)*meanX-mean(distX,2)*ones(1,len)-mean(meanX);
centdistY=distY-ones(len,1)*meanY-mean(distY,2)*ones(1,len)-mean(meanY);
corrXY=mean(mean(centdistX.*centdistY))/sqrt(mean(mean(centdistX.^2))*mean(mean(centdistY.^2)));

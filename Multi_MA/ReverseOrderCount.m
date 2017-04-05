function[count]=ReverseOrderCount(arrays)
n=length(arrays);
count=0;
for dumi=1:n
   pos=find(arrays==dumi);
   count=count+sum(arrays(1:pos)>arrays(pos));
end
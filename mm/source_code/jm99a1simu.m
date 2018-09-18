%99年中国大学生数学建模竞赛a题：自动化车床管理模型一
%参见《数学的实践与认识》2000.1.p36-40
%随机模拟
clear;
data=normrnd(600*0.95,196.6292*0.95,1,10000);
out=find((data>1200)|(data<=0));
data(out)=[];
leng=length(data);
minfee=inf;
for n=1:20
   for m=310:10:390
      f=jm99asmfun(data,n,m);
      if f<minfee
         minfee=f;
         n0=n;m0=m;
      end
   end
end
n0,m0,minfee

      
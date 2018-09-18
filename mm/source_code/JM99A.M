function [x,opt]=jm99a(n,m)
%99年中国大学生数学建模竞赛a题：自动化车床问
%参见《数学的实践与认识》2000.1.p36-40
opt=inf;
for n=10:5:30
   for m=300:10:400
      [x0,op]=fmins('jm99afun',[n m]);
      if op(8)<opt,
         x=x0;opt=op(8);
      end
   end
end

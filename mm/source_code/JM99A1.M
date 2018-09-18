%99年中国大学生数学建模竞赛a题：自动化车床管理模型一
%参见《数学的实践与认识》2000.1.p36-40
clear;opt=inf;
for n=[10 20 30]
   for m=[200 300 400]
      [x0,op]=fmins('jm99afun',[n m]);
      if op(8)<opt,
         x=x0;opt=op(8);
      end
   end
end
n=x(1),m=x(2),f=opt

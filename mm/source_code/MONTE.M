%MonteCarlo法解最优化的例
clear;
%设定一个初值
vmax=-inf;
 %specrnd生成给定分布律的随机数
 %r=specrnd(x,p)返回一个来自分布律P(x)=p的随机数
 %r=specrnd(x,p,m,n)返回m*n随机数矩阵
 %p的默认值为等概率
 %例如 分布律
 %      ξ 	7      8      9     10
 %      p 	0.1   0.2   0.4    0.3
 %命令    specrnd([7 8 9 10],[0.1 0.2 0.4 0.3],10,10)
 %产生100个模拟数据  
x2=specrnd(10:20,[],1,5);
x3=specrnd(-5:16,[],1,5);
for i=1:5
   for j=1:5
      if x2(i)+2*x3(j)>=10&3*x2(i)+2*x3(j)<=62,
         v=(x2(i)+10)*x2(i)*x3(j);
         if v>vmax,
            vmax=v;x20=x2(i);x30=x3(j);
         end
      end
   end
end
x1=x20+10,x2=x20,x3=x30
vmax

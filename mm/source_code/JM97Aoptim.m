function [f,g]=JM97Aoptim(x)
% 97年中国大学生数学建模竞赛A题目标函数
% 用法： [f,g]=jm97aoptim(x)
%       x--7个零件参数
%       f--目标函数
%       g--虚拟参数，优化工具箱实用
%       全程变量：COST(成本矩阵），VARI(容差等级）
% 相关M文件：jm97a, jm97afun

global COST VARI;
y=jm97afun(x);
sig=0;h=0.0001;
for i=1:7
   xh=x;xh(i)=x(i)+h;
   dy=(jm97afun(xh)-jm97afun(x))/h;
   sig=sig+dy^2*(VARI(i)/300*x(i))^2;
end
sig=sig^0.5;
f=9000-8000*(normcdf(1.8,y,sig)-normcdf(1.2,y,sig))...
   -1000*(normcdf(1.6,y,sig)-normcdf(1.4,y,sig));
gra=[10 5 1];
for i=1:7
   f=f+sum((VARI(i)==gra).*COST(i,:));
end
g=-1;
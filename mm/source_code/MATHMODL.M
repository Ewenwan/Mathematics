clc;echo on;
%##########################################################################
%  本工具箱主要为学习数学建模和参加中国大学生数学建模竞赛的同学而制作。汇集了
%  数学建模常用的最优化、微分方程、数据拟合、统计等方面的计算工具，包括我们自
%  编的补充工具。工具箱还汇集了96-99中国大学生数学建模竞赛题解MATLAB程序。本
%  工具箱也可供使用MATLAB作数值计算的学生、教师和科技人员参考。
%##########################################################################
echo off
more(25)
echo on

pause % Strike any key to continue (Note: use Ctrl-C to abort)

type contents %使用回车键看下行
more off

pause % Strike any key to continue (Note: use Ctrl-C to abort)
clc

%##########################################################################
% 例一：使用中文帮助
%##########################################################################

%(1)其实使用中文帮助和通常使用英文帮助是一样的，例如你想知道 plot 的用法，用命令
pause % Strike any key to continue (Note: use Ctrl-C to abort)
help plot
%以上最前几行是中文帮助，紧随其后的是原先的英文帮助。

pause % Strike any key to continue (Note: use Ctrl-C to abort)
%(2)除少数英文帮助已配例题外，中文帮助大多都配有中文例题，例如样条插值 spline
pause % Strike any key to continue (Note: use Ctrl-C to abort)
help spline

%现在使用
pause % Strike any key to continue (Note: use Ctrl-C to abort)
clear;close;
x=[1 2 4 5];y=[1 3 4 2];
p=spline(x,y);
xi=1:0.1:5;yi=ppval(p,xi);
plot(x,y,'o',xi,yi,'k');
title('not-a-knot SPLINE');
[b,c]=unmkpp(p)

%(3)中文帮助只列出了最常用的使用格式，完全格式请参考英文帮助。

pause % Strike any key to continue (Note: use Ctrl-C to abort)
close;clc
%##########################################################################
% 例二：学习最优化方法
%##########################################################################

% MATLAB优化工具箱有一个学习最优化计算的教程。使用tutdemo启动（这里省略）。
% 如果你对其中英文命令不太懂，请使用相应的中文帮助
% 
% 例如下列非线性约束优化方法 constr
pause % Strike any key to continue (Note: use Ctrl-C to abort)
help constr


% 根据帮助，现在请你先用MATLAB编辑器将模型函数写成M函数optfun2.m
%           function  [f,g]=optfun2(x)
%           f=-x(1)*x(2)*x(3)
%           g(1)=x(1)-x(2)-10;
%           g(2)=x(1)-x(2)-2*x(3);
%           g(3)=x(1)+2*x(2)+2*x(3)-72
% 然后在MATLAB命令窗口求解
pause % Strike any key to continue (Note: use Ctrl-C to abort)
x0=[10,10,10];
options(13)=1;
[x,options]=constr('optfun2',x0,options,[-inf,10,-inf]',[inf,20,inf]);
x             %最大值点
-options(8)   %目标函数最大值

pause % Strike any key to continue (Note: use Ctrl-C to abort)
clc
%##########################################################################
% 例三：自编工具
%##########################################################################

% 我们自编了许多MATLAB欠缺的数学建模工具。如重积分、随机模拟、离散优化等。例如
% 下列最小生成树kruskal算法使用了CMEX技术
pause % Strike any key to continue (Note: use Ctrl-C to abort)
help kruskal

clear;map=[1 2 30;2 4 5;2 5 50;3 2 6;4 3 1;1 4 20;1 5 30]
[out,len]=kruskal(map)

pause % Strike any key to continue (Note: use Ctrl-C to abort)
close;clc;
%##########################################################################
% 例四：数学建模竞赛题解程序
%##########################################################################

%我们编写了96—99数学建模竞赛一些优秀解答的MATLAB程序
pause % Strike any key to continue (Note: use Ctrl-C to abort)
type jm98a1
echo off
jm98a1
echo on
pause % Strike any key to continue (Note: use Ctrl-C to abort)
type jm98a2
echo off
jm98a2
echo on
pause % Strike any key to continue (Note: use Ctrl-C to abort)
type jm98a1
echo off
jm98a3
echo on
pause % Strike any key to continue (Note: use Ctrl-C to abort)
clc
%##########################################################################
% 愿我们的工作能对您有所帮助。
% 欢迎交流，请多提意见。
% Email: ljhu@dhu.edu.cn
% 参加制作：胡良剑、丁晓东、马裕、陆锁军、李伟钟
%##########################################################################
echo off

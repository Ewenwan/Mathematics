# 1. 方程求根
    % 方程求根
    % inv - 逆矩阵

    % roots - 多项式的根

    % fzero - 一元函数零点

    % fsolve - 非线性方程组

    % solve - 符号方程解

    % *newton - 牛顿迭代法解非线性方程
# 2. 离散优化
    % *enum - 枚举法
    % *monte - 蒙特卡洛法
    % *lpint (BranchBound)- 线性整数规划
    % *L01p_e - 0-1整数规划枚举法
    % *L01p_ie - 0-1整数规划隐枚举法
    % *bnb18 - 非线性整数规划(在MATLAB5.3使用)
    % *bnbgui - 非线性整数规划图形工具(在MATLAB5.3使用)
    % *mintreek - 最小生成树kruskal算法
    % *minroute - 最短路dijkstra算法
    % *krusk - 最小生成树kruskal算法mex程序
    % *dijkstra - 最短路dijkstra算法mex程序
    % *dynprog - 动态规划
    
# 3. 数据拟合
    % interp1 - 一元函数插值
    % spline - 样条插值
    % polyfit - 多项式插值或拟合 
    % curvefit - 曲线拟合
    % caspe - 各种边界条件的样条插值
    % casps - 样条拟合(没有)
    % interp2 - 二元函数插值
    % griddata - 不规则数据的二元函数插值
    % *interp - 不单调节点插值
    % *lagrange - 拉格朗日插值法
    
# 4. % 数学规划
    % lp - 线性规划
    % linprog - 线性规划(在MATLAB5.3使用)
    % fmin - 一元函数极值
    % fminu - 多元函数极值拟牛顿法
    % fmins - 多元函数极值单纯形搜索法
    % constr - 非线性规划
    % fmincon - 非线性规划(在MATLAB5.3使用)

# 5. %随机模拟和统计分析
    % max,min - 最大，最小值
    % sum - 求和
    % mean - 均值
    % std - 标准差
    % sort - 排序（升序）
    % sortrows - 按某一列排序(升序)
    % rand - [0，1]区间均匀分布随机数
    % randn - 标准正态分布随机数
    % randperm - 1...n 随机排列
    % regress - 线性回归
    % classify - 统计聚类
    % *trim - 坏数据祛除
    % *specrnd - 给定分布律随机数生成
    % *randrow - 整行随机排列
    % *randmix - 随机置换
    % *chi2test - 分布拟合度卡方检验
# 6. % 图形
    % plot - 平面曲线（一元函数）
    % plot3 - 空间曲线
    % mesh - 空间曲面（二元函数）
    % *meshf - 非矩形网格图
    % *draw - 用鼠标划光滑曲线
# 7. %微积分和微分方程
    % diff - 差分
    % diff - 符号导函数
    % trapz - 梯形积分法
    % quad8 - 高精度数值积分
    % int - 符号积分
    % dblquad - 矩形域二重积分
    % ode45 - 常微分方程
    % dsolve - 符号微分方程
    % *polyint - 多项式积分法
    % *quadg - 高斯积分法
    % *quad2dg - 矩形域高斯二重积分
    % *dblquad2 - 非矩形域二重积分 
    % *rk4 - 常微分方程RungeKutta法
    
# 8. % 演示程序
    % funtool - 函数计算器
    % tutdemo - MATLAB优化工具箱教程
    % mathmodl - 数学建模工具箱演示
    
# 9. %中国大学生数学建模竞赛题解
    % jm96a - 捕鱼策略
    % jm96b - 节水洗衣机
    % jm96bfun - 节水洗衣机优化函数
    % jm97a - 零件参数设计
    % jm97afun - 零件参数函数 
    % jm97aoptim - 零件参数设计优化函数
    % jm97b - 截断切割
    % jm97bcount - 截断切割枚举法
    % jm97brule - 截断切割优化准则 
    % jm98a1 - 风险投资模型求解
    % jm98a2 - 风险投资模型讨论
    % jm98a3 - 收益与风险非线性模型求解
    % jm98a3fun - 收益与风险非线性模型优化函数
    % jm98b - 灾情巡视路线（C程序）
    % jm99a1 - 自动化车床模型一
    % jm99a1fun - 自动化车床模型目标函数
    % jm99a1simu - 自动化车床模型随机模拟
    % jm99asmfun - 自动化车床模型费用函数

# 10. 递推关系式的作图程序
```m
x(1)=1;x(2)=10;
hold on
for t=3:10
    x(t)=0.8*x(t-1)+1.5*x(t-2);%递推关系式，注意MATLAB里向量的下标不能从零开始。
end
plot(2:10,x(2:10))
```

# 11. 时间序列分析程序
```m
z=[16 12 15 10 9 17 11 16 10 14]; %任给一组数据，通过下面函数求解样本均值z1、样本自协方差函数r、样本自相关函数p（SACF）和样本偏自相关函数q(SPACF)

N=size(z);   %size(A,1)返回矩阵A的行数  size(A,2)返回矩阵A的列数
n=N(1,2);
z1=sum(z)/n; %样本均值z1

s0=0;
for i=1:n
    s0=(z(i)-z1)^2+s0;
end
r0=s0/n;

%%样本自协方差函数r
for k=1:(n-1)
    nr(k)=0;
    for t=1:(n-k)
        nr(k)=(z(t)-z1)*(z(t+k)-z1)+nr(k);
    end 
end   
r=nr./n;

%%样本自相关函数p
p=(r./r0)';%p=vpa((r./r0)',3); %vpa(n,m)对n保留小数点后m位

%%偏自相关函数q
for m=1:(n-2)
    q(1,1)=p(1);
    D=0;T=0;
    for h=1:m
        D=p(m+1-h)*q(m,h)+D;
        T=p(h)*q(m,h)+T;
    end
        q(m+1,m+1)=(p(m+1)-D)/(1-T);
    for j=1:m
        q(m+1,j)=q(m,j)-q(m+1,m+1)*q(m,m+1-j);
    end     
end
q

```

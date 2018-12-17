function DE(Gm,F0)
% F0 初始变异缩放比例
% Gm 最大进化代数
%%
%{
差异进化算法DE,Differential Evolution 
step1. 初始化总群 种群大小（每一代个体数量，i=1 to NP） 每个个体的维度大小（基因数量，j = 1 to D）
       第0代： Xij(0) 最小 + rand(0,1)* （最大-最小）（个体中基因 的最大最小）

step2. 变异操作   差分策略个体变异（区别于遗传算法） 随机选取 其他两个不同个体 取得其向量差缩放后 与待变异个体进行向量合成
       变异中间体  Vi(g+1) = Xi(g) + F * (Xm(g) - Xn(g))  边界条件进行处理  用初始方法 更新不符合条件的变异个体
       整体变化

       缩放比例 F影响 种群早熟（同质化），F 随着进化代数变化，自适应 变异算法
       lamd  = exp(1 - Gmax/(Gmax + 1 - G)) ( 注：Gmax 为最大进化代数， G为当前进化代数
       F(g)  = F0  * 2^lamd ,一开始 F 较大 F0 ~ 2*F0 后期 接近 F0

step3. 交叉操作  第g代 Xi(g) 与 变异中间体 Vi(g+1) 进行交叉操作（染色体基因交叉）
       个体部分基因 变化交叉 
       交叉后中间体  Uij（g+1） =  Vij(g+1)（if rand（0,1）<= CR  or j =jrand）,
                                  Xij(g)   (其他)
       jrand 为 基因总数 [1 D] 中的一个随机整数，确保至少有一个 变异中间体的基因传递到下一代

step4. 选择操作 采样贪婪算法选择 留下 上一代 和 变异交叉个体 中的优良基因
       （个体 对 全局最优函数 的 输出） 最大 或最小

本示例 最优函数 min sum(Xi^2 - 10*cos(2*pi*Xi) + 10)  Xi<=5.12
最优 xi =0  f = 0

%}
%%
t0 = cputime;  %当前时间  
%差分进化算法程序  
%F0是变异率 %Gm 最大迭代次数  
if nargin < 1  
    Gm = 7000;  
end
if nargin < 2  
    F0 = 0.5;   
end

Np = 100;  % 种群个体数量
CR = 0.9;  % 交叉概率（基因选择变异个体基因的概率）   
G= 1;      % 初始化代数  
D = 10;    % 个体基因总数，所求问题的维数  
Gmin = zeros(1,Gm);   % 各代的最优值  （最优问题的解）
best_x = zeros(Gm,D); % 各代的最优解   每一代 的 一个最优解  
value = zeros(1,Np);  % 
  
%% 产生初始种群  
%xmin = -10; xmax = 100;%带负数的下界 
% 个体约束
xmin = -5.12;  
xmax = 5.12;
% 最优函数
function y = f(v)  
    %Rastrigr 函数  
y = sum(v.^2 - 10.*cos(2.*pi.*v) + 10);  
end  
% 随机产生Np 个 个体
X0 = (xmax-xmin)*rand(Np,D) + xmin;  %产生Np个D维向量  
XG = X0;  
  
%——————————这里未做评价，不判断终止条件———————%  
  
XG_next_1= zeros(Np,D);   %初始化 变异中间体
XG_next_2 = zeros(Np,D);  %变异交叉后的中间体 
XG_next = zeros(Np,D);    %下一代

%% 迭代进化
while G <= Gm 
str = fprintf('当前进化代数： %d', G );
disp(str);  
%% ——————————变异操作—————————————————%  
    for i = 1:Np % 每个个体 
    %% 产生j,k,p三个不同的数 （其他的个体） 
        a = 1;  
        b = Np;  
        dx = randperm(b-a+1) + a - 1;  %randperm(n)随机打乱 1：序列
        j = dx(1); %% 随机选择三个个体 
        k = dx(2);  
        p = dx(3);  
        %要保证与i个体不同  
        if j == i  
            j  = dx(4);  
            else if k == i  
                 k = dx(4);  
                else if p == i  
                    p = dx(4);  
                    end  
                end  
         end  
          
        %% 变异算子  
        lamd  = exp(1-Gm/(Gm + 1-G));  
        F = F0*2.^lamd;
        
        %差分变异的个体来自三个随机父代           
        son = XG(p,:) + F*(XG(j,:) - XG(k,:));  %  上一代 种群 XG 
        % 考虑边界 
        for j = 1: D % 个体的每个 基因 
            if son(1,j) >xmin  && son(1,j) < xmax %防止变异超出边界  
                XG_next_1(i,j) = son(1,j);  
            else  
                XG_next_1(i,j) = (xmax - xmin)*rand(1) + xmin;  %对于不符合的变异基因 按边界条件随机产生
            end  
        end  
    end  

    
%% ————————-————交叉操作—————————————————%        
    for i = 1: Np    % 每个个体
        randx = randperm(D); % [1,2,3,...D]的随机序列     
        for j = 1: D % 每个基因
              
            if rand > CR && randx(1) ~= j %  CR = 0.9   
                XG_next_2(i,j) = XG(i,j); %  该基因来自 父代个体基因
            else  
                XG_next_2(i,j) = XG_next_1(i,j);  % 该基因来自 变异中间体 基因 
            end  
        end  
    end  
%% ——————————选择操作————————————————% 
    for i = 1:Np  %每个个体
        if f(XG_next_2(i,:)) < f(XG(i,:))  % 选择 达到 最优（本例最小）的个体
              
            XG_next(i,:) = XG_next_2(i,:); % 来自交叉变异个体
        else  
            XG_next(i,:) = XG(i,:);        % 来自父代个体
        end  
    end  
      
    %% 找出最小值  
    for i = 1:Np  % 对于新一代 的每个个体 
        value(i) = f(XG_next(i,:));   % 目标函数值
    end  
    [value_min,pos_min] = min(value); % 最优个体 和 最优值 
      
    %% 第G代中的目标函数的最小值  
    Gmin(G) = value_min;     
    %保存最优的个体  
    best_x(G,:) = XG_next(pos_min,:); % 每一代中的最优个体    
      
    XG = XG_next;           % 更新到下一代     
    trace(G,1) = G;         % 对于代数
    trace(G,2) = value_min; % 最小值
    G = G + 1; % 下一代 
    
end  
  [value_min,pos_min] = min(Gmin);  % 总进化代数 中的最优个体
  best_value = value_min  
  best_vector =  best_x(pos_min,:)    
  fprintf('DE所耗的时间为：%f \n',cputime - t0);  
  %画出代数跟最优函数值之间的关系图    
  plot(trace(:,1),trace(:,2));  
    
end  
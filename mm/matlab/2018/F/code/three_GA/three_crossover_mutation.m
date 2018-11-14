%%{ 
% 交叉
% in： 种群 grop_soure ，航班表 Flight_table，登机口类型表 Gate_table，交叉概率 cros_weight
% 单点交叉  k之后的基因全部 交换
function [grop_cros] = three_crossover_mutation(grop_soure, Flight_table, Gate_table, cros_weight)
    FS = size(Flight_table);
    %GS = size(Gate_table);
    grop_size = size(grop_soure);
    grop_nums = grop_size(3); % 种群数量
    Flight_nums = FS(1);      % 航班数量   基因数量
    % Gate_nums = GS(2);      % 登机口数量

    grop_cros = grop_soure; % 初始化交叉后的种群
    %disp(Flight_nums);
    
    for i = 1 : 2 : grop_nums% 前后两个父代 交叉产生子代，再从交叉点之后检查，不合适的基因，使用变异产出合适的基于
       % 单点交叉产出交叉点 cros_point
       cros_point = ceil(rand() * (Flight_nums-1)); % 1 ~ N-1
       % disp(cros_point);
       
       % 双点交叉  cros_point1 cros_point2
       %{
        flag = 1;
        while flag == 1
            cros_point1 = ceil(rand() * Flight_nums);
            cros_point2 = ceil(rand() * Flight_nums);
            if cros_point2 > cros_point1
                flag = 0;
                break;
            end
        end
       %}
       
       % 交叉            ========================================
       if cros_weight > rand() % 按照交叉概率进行交叉
           a = grop_soure(cros_point:Flight_nums,:,i);
           b = grop_soure(cros_point:Flight_nums,:,i+1);
           grop_cros(cros_point:Flight_nums,:,i) = b;
           grop_cros(cros_point:Flight_nums,:,i+1) = a;
           
       % 检查 不可行解，用 变异 产生 可行解 ======================================== 
           grop_cros(:,:,i) = three_crossover_check(grop_cros(:,:,i), Flight_table, Gate_table, cros_point);
           grop_cros(:,:,i+1) = three_crossover_check(grop_cros(:,:,i), Flight_table, Gate_table, cros_point);
       end

    end
end
%%}
      
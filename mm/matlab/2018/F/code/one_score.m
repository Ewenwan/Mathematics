%%{ 
% 返回变异后的解，以及 其 临时口使用数量 和 固定扣空闲数量
function [Temp_gate_num, Gate_free_num] = one_score(Solu_soure)  
        SS = size(Solu_soure);
        Gate_nums = SS(2)-2;   % 登机口数量
        Temp_gate_num = sum(Solu_soure( : , Gate_nums+1));  % 临时口 使用数量   少
        Gate_free_num = 0;
        for j=1:Gate_nums
                if sum(Solu_soure(:,j))==0 % 未占用
                    Gate_free_num=Gate_free_num+1;% 未占用数量     固定口 空闲数量   多
                end
        end
             
end
%%}
      
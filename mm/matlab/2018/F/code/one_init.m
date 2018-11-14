%%{ 
    function [Solu] = one_init(Flight_table, Gate_table)
        %% 窄求解 N 
        FS = size(Flight_table);
        GS = size(Gate_table);
        Flight_nums = FS(1); %航班数量
        Gate_nums = GS(2);   %登机口数量
        
        Solu = zeros(Flight_nums, Gate_nums+1); % 初始化解
        
        Gate_time_net = zeros( Flight_nums*2 ,Gate_nums); % 待优化 中间变量
        
        Gate_time = zeros(1, Gate_nums);% 门最后空闲时间
        p=0;
        
        temp_flag = 0;
        
        for i = 1:Flight_nums % 遍历每个航班
            
           %i
           index = ceil(rand()*Gate_nums);%选择一个 登机口
           
           f1 = ((Flight_table(i,3)==0)&&((Gate_table(1,index)==1)));
           f2 = ((Flight_table(i,3)==1)&&((Gate_table(1,index)==0)));
           f3 = ((Flight_table(i,4)==0)&&((Gate_table(2,index)==1)));
           f4 = ((Flight_table(i,4)==1)&&((Gate_table(2,index)==0)));

           f5 = ( Flight_table(i, 1) < Gate_time(index));

           while( f1 || f2 || f3 || f4 || f5 )
                index = ceil(rand()*Gate_nums);
                p=p+1;
                %p
                % i

               f1 = ((Flight_table(i,3)==0)&&((Gate_table(1,index)==1)));
               f2 = ((Flight_table(i,3)==1)&&((Gate_table(1,index)==0)));
               f3 = ((Flight_table(i,4)==0)&&((Gate_table(2,index)==1)));
               f4 = ((Flight_table(i,4)==1)&&((Gate_table(2,index)==0)));

               f5 = ( Flight_table(i, 1) <= Gate_time(index)); % 是插入合适 待更改

               in_time = Flight_table(i, 1);       %该航班到时间
               out_time = Flight_table(i, 2) + 45; %该航班离开时间 + 45 


               if(p >100)
                   
                   Solu(i, Gate_nums+1) = 1;
                   p = 0;
                   temp_flag = 1; % 进入临时停车口                
                   break;
               end 
               %f1 
               %f2 
               %f3 
               %f4 
               %f5
           end
           
           if(temp_flag)
               temp_flag = 0;
               continue
           end
           
           Solu(i,index) = 1;
           Gate_time(index) = Flight_table(i, 2) + 45;   
           
        end
    end
%%}
      
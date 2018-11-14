
%{
SW   = xlsread('SW_src2.xlsx'); %约束
FW =  xlsread('Flight_W.xlsx'); %约束

use_rate_ = zeros(1,24); % 登机口使用率

for i = 1:24 % 每个登机口
    flight_id = find(SW(:,i) == 1); % 登录的航班id
    flight_id_size = size(flight_id);
    use_time = 0;
    if flight_id_size(1) >0 % 该登机口被使用了
        for  j = 1 : flight_id_size(1)
             fid = flight_id(j); % 航班号
             in_time  = FW(fid,1); % 到时间
             out_time = FW(fid,2); % 离开时间
             if in_time < 24*60
                in_time = 24*60;
             end
             if out_time > 24*60*2
                out_time = 24*60*2;
             end
             use_time = use_time + out_time - in_time;
        end
    end
    use_rate_(i) = use_time/(24*60);
    % 登机口未被使用
end
%}

SN = xlsread('SN_src2.xlsx'); %约束
FN =  xlsread('Flight_N.xlsx'); %约束

use_rate_ = zeros(1,45); % 登机口使用率

for i = 1:45 % 每个登机口
    flight_id = find(SN(:,i) == 1); % 登录的航班id
    flight_id_size = size(flight_id);
    use_time = 0;
    if flight_id_size(1) >0 % 该登机口被使用了
        for  j = 1 : flight_id_size(1)
             fid = flight_id(j); % 航班号
             in_time  = FN(fid,1); % 到时间
             out_time = FN(fid,2); % 离开时间
             if in_time < 24*60
                in_time = 24*60;
             end
             if out_time > 24*60*2
                out_time = 24*60*2;
             end
             use_time = use_time + out_time - in_time;
        end
    end
    use_rate_(i) = use_time/(24*60);
    % 登机口未被使用
end
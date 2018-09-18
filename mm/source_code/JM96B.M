%96年中国大学生数学建模竞赛B题:洗衣机
%主程序
%参考：《数学的实践与认识》1997，1，67-70
%相关M文件：jm96bfun

%L.J.HU
clear;vmin0=inf;
for t=2:5
  vini=30*ones(1,t);
  vlb=20*ones(1,t);%最小水量
  vub=40*ones(1,t);%最大水量
  opt([2:3,14])=[1e-8,1e-8,500]; 
  [vmin,options]=constr('washfun',vini,opt,vlb,vub);
  vmin  %每轮水量
  if sum(vmin)<sum(vmin0)
     vmin0=vmin;
     t0=t;
  end
end
disp(['最优洗衣轮次: ',int2str(t0)]);
disp(['洗衣每轮水量: ',num2str(vmin0)]);


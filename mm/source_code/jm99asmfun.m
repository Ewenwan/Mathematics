function f=test(data,n,m)
%年中国大学生数学建模竞赛a题：自动化车床管理模型一
%参见《数学的实践与认识》2000.1.p36-40
%费用函数
%n--examing interval
%m--Max number of products
%x--Living 
%y--average loss
x=data;
num_prod=min((n*ceil(x/n)),m);
exam_times=fix(num_prod/n);
bad_prod=max(num_prod-x+1,0);
knife_fee=3000*(x<num_prod)+3000*(x==num_prod).*(num_prod~=m)+1000*(x>num_prod)+1000*(x==num_prod).*(num_prod==m);
loss=bad_prod*200+exam_times*10+knife_fee;
f=mean(loss)/mean(num_prod);




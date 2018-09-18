%96年中国大学生数学建模竞赛A题:捕鱼
%参考：《数学的实践与认识》1997，1，50-57
%x1,x2,x3,x4--各龄鱼的数量
%k--4龄鱼捕捞系数
%y3,y4--各龄鱼的捕捞数量
%y--鱼的捕获重量
%n--产卵数量

%L.J.HU
clear;
%微分方程求解
x1=dsolve('Dx1=-0.8*x1','x1(0)=a','t');
x11=subs(x1,'t',1);
x2=dsolve('Dx2=-0.8*x2','x2(0)=b','t');
x21=subs(x2,'t',1);
x21=subs(x21,'b',x11);
x3a=dsolve('Dx3a=-0.8*x3a-0.42*k*x3a','x3a(0)=c','t');
x3a=subs(x3a,'c',x21);
x3a2=subs(x3a,'t',2/3);
x3b=dsolve('Dx3b=-0.8*x3b','x3b(2/3)=x3b0','t');
x3b=subs(x3b,'x3b0',x3a2);
x3b=simple(x3b);
x31=subs(x3b,'t',1);
x4a=dsolve('Dx4a=-0.8*x4a-k*x4a','x4a(0)=d','t');
x4a2=subs(x4a,'t',2/3);
x4b=dsolve('Dx4b=-0.8*x4b','x4b(2/3)=x4b0','t');
x4b=subs(x4b,'x4b0',x4a2);
x4b=simple(x4b);
x41=subs(x4b,'t',1);
%捕获量产卵量
syms k;dy3=0.42*k*x3a;dy4=k*x4a;
y3=int(dy3,'t',0,2/3);
y4=int(dy4,'t',0,2/3);
y=17.86*y3+22.99*y4;
n=1.109e5*3*int(0.5*x3b+x4b,'t',2/3,1);
x10=122*n/(122+n);
%优化
y=subs(y,{'a','d',k},{'x(1)','x(2)','x(3)'});
x10=subs(x10,{'a','d',k},{'x(1)','x(2)','x(3)'});
x31=subs(x31,{'a',k},{'x(1)','x(3)'});
x41=subs(x41,{'a','d',k},{'x(1)','x(2)','x(3)'});
funf = ['f =',char(-y),';'];
fung = ['g =[x(1)-',char(x10),';x(2)-',char(x31+x41),'];'];
funn = [funf fung];
options(13)=2;
[x,options]=constr(funn,[122,3.29,1],options);
y=-options(8);
x11=vpa(subs(x11,'a',x(1)),4);
x21=vpa(subs(x21,'a',x(1)),4);
%输出
disp(['可持续捕获3,4龄鱼捕捞系数:',num2str([x(3)*0.42,x(3)])]);
disp(['每年捕获重量(10^9):',num2str(y)]);
disp(['年初各龄鱼分布(10^9):',num2str(x(1)),' ',char(x11),...
      ' ',char(x21),' ',num2str(x(2))]);

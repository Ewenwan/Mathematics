function [out,len]=kruskal(map)
%求最小生成树算法,通过kruskal算法求最优树,并给出相应图像. 
%用法:
%	首先输入矩阵: 
%		map=[起点1 终点1 边长1;起点2 终点2  边长2;............;起点n 终点n 边长n]
%	再用[out,len]=kruskal(map)求最优树
%参数说明
%	map----3列邻接矩阵,每行表示一条边.第一列表示起点,第二列表示终点,第三列表示边长
%	out---输出边阵:[起点 终点]
%	len---输出最优树的总长度
%
%例如  
%		clear;map=[1 2 30;2 4 5;2 5 50;3 2 6;4 3 1;1 4 20;1 5 30]
%		[out,len]=kruskal(map)
%
%本算法调用由VC++6.0程序crusal1.c生成的MEX文件kruskal1.dll求得最小生成树,
%	表示无穷大的数值上界(默认10000)
%
%See also DIJKSTRA,LPINT,DP,BNBGUI,BNB18,

%By S. J. Lu 2000

mx=0;
[m,n]=size(map);
mx=max(max(map(:,1:2)));
op=10000*ones(mx,mx);
for i=1:m
   op(map(i,1),map(i,2))=map(i,3);
   op(map(i,2),map(i,1))=map(i,3);
end
[out,len]=krusk(op);
out=out';

% 画图
close;
 set(gcf,'numbertitle','off');
 set(gcf,'name','Kruskal');
 set(gca,'visible','off');
 axis square;
 hold on;
 
 b=linspace(0,2*pi,mx+1);
 b1=10*sin(b);
 b2=10*cos(b);
 plot(b1,b2,'ko');
 
 hh=char(49:48+mx);
 for i=1:mx
    text(b1(i)+1,b2(i),hh(i));
 end;
 map
 for j=1:m
   for i=1:2
     c1(i)=b1(map(j,i));
     c2(i)=b2(map(j,i));
    end;
    plot(c1,c2,':');
end;

 k1=length(out);
 for i=1:k1
   for j=1:2
      d1(j)=b1(out(i,j));
      d2(j)=b2(out(i,j));
   end
   h=plot(d1,d2,'r');
   set(h,'linewidth',2);
 end 
 legend(h,'粗线为最优树');
 hold off
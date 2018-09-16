function [p,v]=dijkstra(map,u1,u2)
%求网络最短路径的dijkstra算法
%用法:
%	首先输入矩阵: 
%		map=[起点1 终点1 边长1;起点2 终点2  边长2;............;起点n 终点n 边长n]
%		和u1,u2
%  注意：这里map为无向图。
%	再用[p,v]=dijkstra(map,u1,u2)求最短路径
%参数说明
%	map----3列邻接矩阵,每行表示一条边.
%         第一列表示起点,第二列表示终点,第三列表示边长
%	u1---所求路径起点
%	u2---所求路径终点
%   p---输出最短路径
%   v---最短路径的总长度
%
%
%例如  
%		clear;map=[1 2 30;2 4 5;2 5 50;3 2 6;4 3 1;1 4 20;1 5 3]
%		[p,v]=dijkstra(map,2,5)
%
%本算法调用由VC++6.0程序dijk.c生成的MEX文件dijk.dll求得最短路径
%	表示无穷大的数值上界(默认10000)
%
%See also KRUSKAL,LPINT,DP,BNBGUI,BNB18,

%By W. Z. Li, 2000

[m,n]=size(map);
mx=max(max(map(:,1:2)));
l=10000*ones(mx,mx);
for i=1:m
    l(map(i,1),map(i,2))=map(i,3);
    l(map(i,2),map(i,1))=map(i,3);
 end;
 [p,v]=dijk(l,u1,u2);
p=p(p~=0); 

%画图
close;
 set(gcf,'numbertitle','off');
 set(gcf,'name','Dijkstra');
 set(gca,'visible','off');
 axis square;
 hold on;
 
 b=linspace(0,2*pi,mx+1);
 b1=10*sin(b);
 b2=10*cos(b);
 plot(b1,b2,'ko');
 hh=char(49:48+mx);
 for i=1:mx
    text(b1(i)+0.5,b2(i),hh(i));
 end;
 for j=1:m
   for i=1:2
    c1(i)=b1(map(j,i));
    c2(i)=b2(map(j,i));
    end;
    plot(c1,c2,':');   
  end;

 kk=length(p);
 k=0;
 for i=1:kk
    if(p(1,i)~=0)
       k=k+1;
    end;
 end;
 for i=1:k
   d1(i)=b1(p(1,i));
   d2(i)=b2(p(1,i));
  h=plot(d1,d2,'r');
end; 
 set(h,'linewidth',2); 
 legend(h,'粗线表示最短路');
 hold off


 

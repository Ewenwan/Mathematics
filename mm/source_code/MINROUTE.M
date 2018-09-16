function [S,D]=minRoute(i,m,W)
%图与网络论中求最短路径的Dijkstra算法 M-函数
%格式 [S,D]=minroute(i,n,W)
%    i为最短路径的起始点,m为图顶点数,W为图的带权邻接矩阵，
%    不构成边的两顶点之间的权用inf表示。显示结果为：S的每
%    一列从上到下记录了从始点到终点的最短路径所经顶点的序号；
%    D是一行向量，记录了S中所示路径的大小;
%例如
%    clear;w=inf*ones(6);w(1,3)=10;w(1,5)=30;
%    w(1,6)=100;w(2,3)=5;w(3,4)=50;w(4,6)=10;
%    w(5,4)=20;w(5,6)=60;
%    i=1;[s,d]=minroute(i,6,w)

% By X.D. Ding June 2000

dd=[];tt=[];ss=[];ss(1,1)=i;V=1:m;V(i)=[];dd=[0;i];
% dd的第二行是每次求出的最短路径的终点，第一行是最短路径的值
kk=2;[mdd,ndd]=size(dd);
while ~isempty(V)
   [tmpd,j]=min(W(i,V));tmpj=V(j);
   for k=2:ndd
      [tmp1,jj]=min(dd(1,k)+W(dd(2,k),V));
      tmp2=V(jj);tt(k-1,:)=[tmp1,tmp2,jj];
   end
   tmp=[tmpd,tmpj,j;tt];[tmp3,tmp4]=min(tmp(:,1));
   if tmp3==tmpd, ss(1:2,kk)=[i;tmp(tmp4,2)];
   else,tmp5=find(ss(:,tmp4)~=0);tmp6=length(tmp5);
      if dd(2,tmp4)==ss(tmp6,tmp4)
         ss(1:tmp6+1,kk)=[ss(tmp5,tmp4);tmp(tmp4,2)];
         else, ss(1:3,kk)=[i;dd(2,tmp4);tmp(tmp4,2)];
   end;end
   dd=[dd,[tmp3;tmp(tmp4,2)]];V(tmp(tmp4,3))=[];
   [mdd,ndd]=size(dd);kk=kk+1;
end; S=ss; D=dd(1,:);             

function x=randrow(v)
% 矩阵整行的随机置换
% x=randrow(v)将矩阵v按整行随机重排得x

%L.J. Hu 8-17-1999

[m,n]=size(v);
v=[randperm(m)',v];
v=sortrows(v);
x=v(:,2:(n+1));


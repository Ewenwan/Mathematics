function x=randmix(v)
% 矩阵元素的随机置换
% x=randmix(v)将矩阵v的元素随机混合得x

% L.J.Hu 8-17-1999

[m,n]=size(v);
v=v(:);
v=[randperm(m*n)',v];
v=sortrows(v);
x=reshape(v(:,2),m,n);


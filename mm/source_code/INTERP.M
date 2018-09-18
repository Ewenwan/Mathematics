function yi=interp(x,y,xi,method)
% 一维非单调数据插值
% 用法参考interp1，唯一区别是interp不要求节点是单调的

% L.J.HU 4-15-1999

x=x(:);y=y(:);
z=[x,y];
z=sortrows(z);
yi=interp1(z(:,1),z(:,2),xi,method);



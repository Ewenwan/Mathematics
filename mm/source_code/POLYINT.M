  function q = polyint(p,a,b)
  %POLYINT 多项式积分快速算法
  %polyint(p)返回多项式p的不定积分,常数项用0;
  %polyint(p,a,b) 返回多项式p在[a,b]的定积分.
  
  %by L.J. Hu 1999
  
  p=p(:)';
  n=length(p);
  q=p./[n:-1:1];
  q=[q,0];
  if nargin>2,
     q=polyval(q,b)-polyval(q,a);
  end

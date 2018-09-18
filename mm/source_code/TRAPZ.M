function z = trapz(x,y,dim)
%梯形积分法.适用于数值函数和光滑性不好的函数.
%  z=trapz(x,y),x是表示积分区间的离散化向量;
%               y是与x同维数的向量,表示被积函数;
%               z返回积分的近似值.
%例     计算exp(-x^2)在[-1 1]上的定积分  
%     clear;
%     x=-1:0.1:1;
%     y=exp(-x.^2);
%     trapz(x,y)
%
%TRAPZ  Trapezoidal numerical integration.
%   Z = TRAPZ(Y) computes an approximation of the integral of Y via
%   the trapazoidal method (with unit spacing).  To compute the integral
%   for spacing different from one, multiply Z by the spacing increment.
%
%   For vectors, TRAPZ(Y) is the integral of Y. For matrices, TRAPZ(Y)
%   is a row vector with the integral over each column. For N-D
%   arrays, TRAPZ(Y) works across the first non-singleton dimension.
%
%   Z = TRAPZ(X,Y) computes the integral of Y with respect to X using
%   the trapezoidal method.  X and Y must be vectors of the same
%   length, or X must be a column vector and Y an array whose first
%   non-singleton dimension is length(X).  TRAPZ operates along this
%   dimension.
%
%   Z = TRAPZ(X,Y,DIM) or TRAPZ(Y,DIM) integrates across dimension DIM
%   of Y. The length of X must be the same as size(Y,DIM)).
%
%   Example: If Y = [0 1 2
%                    3 4 5]
%
%   then trapz(Y,1) is [1.5 2.5 3.5] and trapz(Y,2) is [2
%                                                       8];
%
%   See also SUM, CUMSUM, CUMTRAPZ.

%   Clay M. Thompson, 10/16/90; Cleve Moler, 1/19/92.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.10 $  $Date: 1997/11/21 23:24:10 $

%   Make sure x and y are column vectors, or y is a matrix.

perm = []; nshifts = 0;
if nargin == 3, % trapz(x,y,dim)
  perm = [dim:max(ndims(y),dim) 1:dim-1];
  y = permute(y,perm);
  m = size(y,1);
elseif nargin==2 & length(y)==1 % trapz(y,dim)
  dim = y; y = x;
  perm = [dim:max(ndims(y),dim) 1:dim-1];
  y = permute(y,perm);
  m = size(y,1);
  x = 1:m;
else
  if nargin < 2, y = x; end
  [y,nshifts] = shiftdim(y);
  m = size(y,1);
  if nargin < 2, x = 1:m; end
end
x = x(:);
if length(x) ~= m
    error('length(x) must equal length of first non-singleton dim of y.');
end

%   Trapezoid sum computed with vector-matrix multiply.
z = diff(x,1,1)' * (y(1:m-1,:) + y(2:m,:))/2;

siz = size(y); siz(1) = 1;
z = reshape(z,[ones(1,nshifts),siz]);
if ~isempty(perm), z = ipermute(z,perm); end

function y = mean(x,dim)
%列状数据平均值
%例如
%    A=[11 4 0.2;22 3 0.5;0 3 0.4];
%    mean(A)
%
%MEAN   Average or mean value.
%   For vectors, MEAN(X) is the mean value of the elements in X. For
%   matrices, MEAN(X) is a row vector containing the mean value of
%   each column.  For N-D arrays, MEAN(X) is the mean value of the
%   elements along the first non-singleton dimension of X.
%
%   MEAN(X,DIM) takes the mean along the dimension DIM of X. 
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   then mean(X,1) is [1.5 2.5 3.5] and mean(X,2) is [1
%                                                     4]
%
%   See also MEDIAN, STD, MIN, MAX, COV.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.13 $  $Date: 1997/11/21 23:23:55 $

if nargin==1, 
  % Determine which dimension SUM will use
  dim = min(find(size(x)~=1));
  if isempty(dim), dim = 1; end

  y = sum(x)/size(x,dim);
else
  y = sum(x,dim)/size(x,dim);
end

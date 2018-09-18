%列状数据升序排列
%例如
%    A=[11 4 0.2;22 3 0.5;0 3 0.4];
%    sort(A)
%
%SORT   Sort in ascending order.
%   For vectors, SORT(X) sorts the elements of X in ascending order.
%   For matrices, SORT(X) sorts each column of X in ascending order.
%   For N-D arrays, SORT(X) sorts the along the first non-singleton
%   dimension of X. When X is a cell array of strings, SORT(X) sorts
%   the strings in ASCII dictionary order.
%
%   SORT(X,DIM) sorts along the dimension DIM.
%
%   [Y,I] = SORT(X) also returns an index matrix I. If X is a
%   vector, then Y = X(I).  If X is an m-by-n matrix, then
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end
%
%   When X is complex, the elements are sorted by ABS(X).  Complex
%   matches are further sorted by ANGLE(X).
%
%   Example: If X = [3 7 5
%                    0 4 2]
%
%   then sort(X,1) is [0 4 2  and sort(X,2) is [3 5 7
%                      3 7 5]                   0 2 4];
%
%   See also SORTROWS, MIN, MAX, MEAN, MEDIAN.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.11 $  $Date: 1997/11/21 23:24:04 $
%   Built-in function.

%   Cell array implementation in @cell/sort.m

%列状数据最小值
%例如
%    A=[11 4 0.2;22 3 0.5;0 3 0.4];
%    min(A)
%
%MIN    Smallest component.
%   For vectors, MIN(X) is the smallest element in X. For matrices,
%   MIN(X) is a row vector containing the minimum element from each
%   column. For N-D arrays, MIN(X) operates along the first
%   non-singleton dimension.
%
%   [Y,I] = MIN(X) returns the indices of the minimum values in vector I.
%   If the values along the first non-singleton dimension contain more
%   than one minimal element, the index of the first one is returned.
%
%   MIN(X,Y) returns an array the same size as X and Y with the
%   smallest elements taken from X or Y. Either one can be a scalar.
%
%   [Y,I] = MIN(X,[],DIM) operates along the dimension DIM.  Suppose
%   X=[2 8 4;7 3 9] then min(X,[],1) is [2 3 4] and min(X,[],2) is [2,3].
%
%   When complex, the magnitude MIN(ABS(X)) is used. NaN's are ignored
%   when computing the minimum.
%
%   Example: If X = [2 8 4   then min(X,[],1) is [2 3 4],
%                    7 3 9]
%
%       min(X,[],2) is [2    and min(X,5) is [2 5 4
%                       3],                   5 3 5].
%
%   See also MAX, MEDIAN, MEAN, SORT.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.10 $  $Date: 1997/11/21 23:23:57 $

%   Built-in function.

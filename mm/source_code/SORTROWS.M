function [y,ndx] = sortrows(x,col)
%[Y,I]=sortrows(A,k)按第k列升序的排列,向量I返各行的原编址.
%例如
%    A=[11 4 0.2;22 3 0.5;0 3 0.4];
%    sortrows(A,3)
%SORTROWS Sort rows in ascending order.
%   SORTROWS(X) sorts the rows of the matrix X in ascending order as a
%   group.  For ASCII strings, this is the familiar dictionary sort.
%   When X is complex, the elements are sorted by ABS(X). Complex
%   matches are further sorted by ANGLE(X).
%
%   SORTROWS(X,COL) sorts the matrix based on the columns specified in
%   the vector COL.  For example, SORTROWS(X,[2 3]) sorts the rows of X
%   by the second and third columns of X.
%
%   [Y,I] = SORTROWS(X) also returns an index matrix I. If X is a
%   vector, then Y = X(I).  If X is an m-by-n matrix, then Y = X(I,:).
%
%   See also SORT.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.9 $  $Date: 1997/11/21 23:24:05 $

if nargin<1, error('Not enough input arguments.'); end
if ndims(x)>2, error('X must be a 2-D matrix.'); end

if nargin<2, col = 1:size(x,2); end
if isempty(x), y = x; ndx = []; return, end

% Sort back to front
ndx = (1:size(x,1))';
for i=length(col):-1:1,
  [v,ind] = sort(x(ndx,col(i)));
  ndx = ndx(ind);
end
y = x(ndx,:);

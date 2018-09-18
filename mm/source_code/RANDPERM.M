function p = randperm(n);
%P=randperm(n) 生成1,2…,n的一个随机排列
%
%RANDPERM Random permutation.
%   RANDPERM(n) is a random permutation of the integers from 1 to n.
%   For example, RANDPERM(6) might be [2 4 5 6 1 3].
%   
%   Note that RANDPERM calls RAND and therefore changes RAND's
%   seed value.
%
%   See also PERMUTE.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.4 $  $Date: 1997/11/21 23:44:34 $

[ignore,p] = sort(rand(1,n));

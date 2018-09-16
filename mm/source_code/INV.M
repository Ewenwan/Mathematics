%求逆矩阵
%用法 B=inv(A) 其中A为数值或符号方阵,B返回A的逆
%例如
%    inv([1 2;3 4])                    %数值
%    syms a b c d;inv([[a,b;c,d])      %符号
%
%INV    Matrix inverse.
%   INV(X) is the inverse of the square matrix X.
%   A warning message is printed if X is badly scaled or
%   nearly singular.
%
%   See also SLASH, PINV, COND, CONDEST, NNLS, LSCOV.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.5 $  $Date: 1997/11/21 23:38:31 $
%   Built-in function.

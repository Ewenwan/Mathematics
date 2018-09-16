function r = roots(c)
%roots(p)可求得多项式p的所有复根.
%例   x^3+2x^2-3=0
%   求解
%      roots([1 2 0 -3])
%
%ROOTS  Find polynomial roots.
%   ROOTS(C) computes the roots of the polynomial whose coefficients
%   are the elements of the vector C. If C has N+1 components,
%   the polynomial is C(1)*X^N + ... + C(N)*X + C(N+1).
%
%   See also POLY, RESIDUE, FZERO.

%   J.N. Little 3-17-86
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.6 $  $Date: 1997/11/21 23:41:05 $

% ROOTS finds the eigenvalues of the associated companion matrix.

if size(c,1)>1 & size(c,2)>1
    error('Must be a vector.')
end
c = c(:).';
n = size(c,2);
r = zeros(0,1);

inz = find(c);
if isempty(inz),
    % All elements are zero
    return
end

% Strip leading zeros and throw away.  
% Strip trailing zeros, but remember them as roots at zero.
nnz = length(inz);
c = c(inz(1):inz(nnz));
r = zeros(n-inz(nnz),1);

% Polynomial roots via a companion matrix
n = length(c);
if n > 1
    a = diag(ones(1,n-2),-1);
    a(1,:) = -c(2:n) ./ c(1);
    r = [r;eig(a)];
end

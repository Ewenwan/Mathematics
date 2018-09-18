function [x,lambda,how]=lp(f,A,B,vlb,vub,x,neqcstr,verbosity)
%线性规划lp
%求解线性规划问题：
%       min  c'x 
%       s.t. Ax<=b
%这里A为m*n矩阵,C为m*1向量,b为m*1向量,n为变量个数
%用法
%     x=lp(C,A,b)求得上述线性规划的解。
%     x=lp(C,A,b,vlb,vub) 指定上下界vlb<=x<=vub
%     x=lp(C,A,b,vlb,vub,x0)给定迭代初值
%     x=lp(C,A,b,vlb,vub,x0,k)前k个约束为等式
%例  max   z=10x1+5x2
%    s.t. 5x1+2x2<=8
%         3x1+4x2=9
%         x1+x2>=1
%         x1,x2>=0
% 首先化为：min   - z = -10x1 -5x2
%    s.t. 3x1+4x2=9              
%         5x1+2x1<=8
%         -x1-x2<=-1
%         x1,x2>=0
%  解法              
%  clear;
%  C=[-10,-5]';
%  A=[3 4;5 2;-1 -1];
%  b=[9,8,-1]';
%  x=lp(C,A,b,zeros(2,1),[],[],1)
%LP     Linear programming.                   
%   LP has been replaced with LINPROG.  LP currently works but
%   will be removed in the future.  Use LINPROG instead.
%
%   X=LP(f,A,b) solves the linear programming problem:
%        
%            min f'x    subject to:   Ax <= b 
%             x
%   
%   X=LP(f,A,b,VLB,VUB) defines a set of lower and upper
%   bounds on the design variables, X, so that the solution is always in
%   the range VLB <= X <= VUB.
%
%   X=LP(f,A,b,VLB,VUB,X0) sets the initial starting point to X0.
%
%   X=LP(f,A,b,VLB,VUB,X0,N) indicates that the first N constraints defined
%   by A and b are equality constraints.
%
%   X=LP(f,A,b,VLB,VUB,X0,N,DISPLAY) controls the level of warning
%   messages displayed.  Warning messages can be turned off with
%   DISPLAY = -1.
%
%   [x,LAMBDA]=LP(f,A,b) returns the set of Lagrangian multipliers,
%   LAMBDA, at the solution. 
%   
%   [X,LAMBDA,HOW] = LP(f,A,b) also returns a string how that indicates 
%   error conditions at the final iteration.
%
%   LP produces warning messages when the solution is either unbounded
%   or infeasible. 

%   Copyright (c) 1990-98 by The MathWorks, Inc.
%   $Revision: 1.13 $  $Date: 1998/08/31 22:29:20 $
%   Andy Grace 7-9-90. Mary Ann Branch 9-30-96.
         
if nargin<8, verbosity = 0; 
    if nargin<7, neqcstr = 0; 
        if nargin<6, x = []; 
            if nargin<5, vub = [];
                if nargin<4, vlb = [];
        end, end, end, end, end
[ncstr,nvars]=size(A);
nvars = max([length(f),nvars]); % In case A is empty
        
if isempty(verbosity), verbosity = 0; end
if isempty(neqcstr), neqcstr = 0; end
if isempty(x), x=zeros(nvars,1); end       
        
if isempty(A), A=zeros(0,nvars); end
if isempty(B), B=zeros(0,1); end       

% Set to column vectors
f = f(:);
B = B(:);
x = x(:);

caller = 'lp'; 
[x,lambda,how]=qpsubold([],f,A,B,vlb,vub,x,neqcstr,verbosity,caller,ncstr,nvars);          


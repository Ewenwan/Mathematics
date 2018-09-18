%R=randn(m,n) 生成标准正态分布的m行n列随机矩阵
%RANDN  Normally distributed random numbers.
%   RANDN(N) is an N-by-N matrix with random entries, chosen from
%   a normal distribution with mean zero and variance one.
%   RANDN(M,N) and RANDN([M,N]) are M-by-N matrices with random entries.
%   RANDN(M,N,P,...) or RANDN([M,N,P...]) generate random arrays.
%   RANDN with no arguments is a scalar whose value changes each time it
%   is referenced.  RANDN(SIZE(A)) is the same size as A.  
%
%   RANDN produces pseudo-random numbers.  The sequence of numbers
%   generated is determined by the state of the generator.  Since MATLAB
%   resets the state at start-up, the sequence of numbers generated will
%   be the same unless the state is changed.
%
%   S = RANDN('state') is a 2-element vector containing the current state
%   of the normal generator.  RANDN('state',S) resets the state to S.
%   RANDN('state',0) resets the generator to its initial state.
%   RANDN('state',J), for integer J, resets the generator to its J-th state.
%   RANDN('state',sum(100*clock)) resets it to a different state each time.
%
%   MATLAB Version 4.x used random number generators with a single seed.
%   RANDN('seed',0) and RANDN('seed',J) cause the MATLAB 4 generator
%   to be used.
%   RANDN('seed') returns the current seed of the MATLAB 4 normal generator.
%   RANDN('state',J) and RANDN('state',S) cause the MATLAB 5 generator
%   to be used. 
%
%   See also RAND, SPRAND, SPRANDN, RANDPERM.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.9 $  $Date: 1997/11/21 23:30:11 $
%   Built-in function.

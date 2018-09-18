%R=rand(m,n) 生成(0,1)上均匀分布的m行n列随机矩阵
%RAND   Uniformly distributed random numbers.
%   RAND(N) is an N-by-N matrix with random entries, chosen from
%   a uniform distribution on the interval (0.0,1.0).
%   RAND(M,N) and RAND([M,N]) are M-by-N matrices with random entries.
%   RAND(M,N,P,...) or RAND([M,N,P,...]) generate random arrays.
%   RAND with no arguments is a scalar whose value changes each time it
%   is referenced.  RAND(SIZE(A)) is the same size as A.  
%
%   RAND produces pseudo-random numbers.  The sequence of numbers
%   generated is determined by the state of the generator.  Since MATLAB
%   resets the state at start-up, the sequence of numbers generated will
%   be the same unless the state is changed.
%
%   S = RAND('state') is a 35-element vector containing the current state
%   of the uniform generator.  RAND('state',S) resets the state to S.
%   RAND('state',0) resets the generator to its initial state.
%   RAND('state',J), for integer J, resets the generator to its J-th state.
%   RAND('state',sum(100*clock)) resets it to a different state each time.
%
%   This generator can generate all the floating point numbers in the 
%   closed interval [2^(-53), 1-2^(-53)].  Theoretically, it can generate
%   over 2^1492 values before repeating itself.
%
%   MATLAB Version 4.x used random number generators with a single seed.
%   RAND('seed',0) and RAND('seed',J) cause the MATLAB 4 generator to be used.
%   RAND('seed') returns the current seed of the MATLAB 4 uniform generator.
%   RAND('state',J) and RAND('state',S) cause the MATLAB 5 generator to be used.
%
%   See also RANDN, SPRAND, SPRANDN, RANDPERM.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.8 $  $Date: 1997/11/21 23:30:10 $
%   Built-in function.

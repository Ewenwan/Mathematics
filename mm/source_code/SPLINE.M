function output = spline(x,y,xx)
%三次样条插值
%yi=spline(x,y,xi)等价于YI=interp(x,y,xi,'spline'),
%     根据数据(x,y)给出在xi的线性插值结果yi..
%     使用"非扭结"端点条件, 即强迫第一﹑二端多项式三次项系数相同,
%     最后一段和倒数第二段三次项系数相同.
%pp=spline(x,y)返回样条插值的分段多项式(pp形式).
%[breaks,coefs]=unmkpp(pp)将pp形式展开,其中breaks为结点,coefs为各段多项式系数.
%yi=ppval(pp,xi),pp形式在xi的函数值.
%例 考虑数据
%          x | 1  2  4  5
%         ---|-------------
%          y | 1  3  4  2 
%      clear;close;
%      x=[1 2 4 5];y=[1 3 4 2];
%      p=spline(x,y);
%      xi=1:0.1:5;yi=ppval(p,xi);
%      plot(x,y,'o',xi,yi,'k');
%      title('not-a-knot SPLINE');
%      [b,c]=unmkpp(p)
%另一个例子见下列英文部分
%
%SPLINE Cubic spline data interpolation.
%   YY = SPLINE(X,Y,XX) uses cubic spline interpolation
%   to find a vector YY corresponding to XX.  X and Y are the
%   given data vectors and XX is the new abscissa vector.
%
%   The ordinates Y may be vector-valued, in which case Y(:,j) is
%   the j-th ordinate.
%
%   PP = SPLINE(X,Y) returns the pp-form of the cubic spline 
%   interpolant instead, for later use with  PPVAL, etc.
%
%   Ordinarily, the not-a-knot end conditions are used. However, if
%   Y contains two more ordinates than X has entries, then the first
%   and last ordinate in Y are used as the endslopes for the cubic spline.
%
%   Here's an example that generates a coarse sine curve, then
%   samples the spline over a finer mesh:
%
%       x = 0:10;  y = sin(x);
%       xx = 0:.25:10;
%       yy = spline(x,y,xx);
%       plot(x,y,'o',xx,yy)
%
%   Here is an example that features a vector-valued spline, along with complete
%   spline interpolation, i.e., fitting to given end slopes (instead of using the
%   not-a-knot end condition); it uses SPLINE to generate a circle:
%
%       circle = spline( 0:4, [0 1 0 -1 0 1 0; pi/2 0 1 0 -1 0 pi/2] );
%       xx = 0:.1:4; cc = ppval(circle, xx); plot(cc(1,:), cc(2,:)), axis equal
%
%   See also INTERP1, PPVAL, SPLINES (The Spline Toolbox).

%   Carl de Boor 7-2-86
%   Revised 11-24-87 JNL, 6-16-92 CBM, 10-14-97 CB.
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.11 $  $Date: 1997/12/03 19:22:33 $

% Generate the cubic spline interpolant in pp form, depending on the
% number of data points (and usually using the not-a-knot end condition).

output=[];
n=length(x);
if n<2, error('There should be at least two data points.'), end

if any(diff(x)<0), [x,ind]=sort(x); else, ind=1:n; end

x=x(:); dx = diff(x);
if all(dx)==0, error('The data abscissae should be distinct.'), end

[yd,yn] = size(y); % if Y happens to be a column matrix, change it to 
                   % the expected row matrix.
if yn==1, yn=yd; y=reshape(y,1,yn); yd=1; end

if yn==n
   notaknot = 1;
elseif yn==n+2
   notaknot = 0; endslopes = y(:,[1 n+2]).'; y(:,[1 n+2])=[];
else
   error('Abscissa and ordinate vector should be of the same length.')
end

yi=y(:,ind).'; dd = ones(1,yd);
dx = diff(x); divdif = diff(yi)./dx(:,dd);
if n==2
   if notaknot, % the interpolant is a straight line
      pp=mkpp(x.',[divdif.' yi(1,:).'],yd);
   else         % the interpolant is the cubic Hermite polynomial
      divdif2 = diff([endslopes(1,:);divdif;endslopes(2,:)])./dx([1 1],dd);
      pp = mkpp(x,...
      [(diff(divdif2)./dx(1,dd)).' ([2 -1]*divdif2).' ...
                                           endslopes(1,:).' yi(1,:).'],yd);
   end
elseif n==3&notaknot, % the interpolant is a parabola
   yi(2:3,:)=divdif;
   yi(3,:)=diff(divdif)/(x(3)-x(1));
   yi(2,:)=yi(2,:)-yi(3,:)*dx(1);
   pp = mkpp([x(1),x(3)],yi([3 2 1],:).',yd);
else % set up the sparse, tridiagonal, linear system for the slopes at  X .
   b=zeros(n,yd);
   b(2:n-1,:)=3*(dx(2:n-1,dd).*divdif(1:n-2,:)+dx(1:n-2,dd).*divdif(2:n-1,:));
   if notaknot
      x31=x(3)-x(1);xn=x(n)-x(n-2);
      b(1,:)=((dx(1)+2*x31)*dx(2)*divdif(1,:)+dx(1)^2*divdif(2,:))/x31;
      b(n,:)=...
      (dx(n-1)^2*divdif(n-2,:)+(2*xn+dx(n-1))*dx(n-2)*divdif(n-1,:))/xn;
   else
      x31 = 0; xn = 0; b([1 n],:) = dx([1 n-2],dd).*endslopes;
   end
   c = spdiags([ [dx(2:n-1);xn;0] ...
        [dx(2);2*[dx(2:n-1)+dx(1:n-2)];dx(n-2)] ...
        [0;x31;dx(1:n-2)] ],[-1 0 1],n,n);

   % sparse linear equation solution for the slopes
   mmdflag = spparms('autommd');
   spparms('autommd',0);
   s=c\b;
   spparms('autommd',mmdflag);
   % convert to pp form
   c4=(s(1:n-1,:)+s(2:n,:)-2*divdif(1:n-1,:))./dx(:,dd);
   c3=(divdif(1:n-1,:)-s(1:n-1,:))./dx(:,dd) - c4;
   pp=mkpp(x.',...
     reshape([(c4./dx(:,dd)).' c3.' s(1:n-1,:).' yi(1:n-1,:).'],(n-1)*yd,4),yd);
end
if nargin==2
   output=pp;
else
   output=ppval(pp,xx);
end

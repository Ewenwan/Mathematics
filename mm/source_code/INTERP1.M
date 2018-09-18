function yi = interp1(varargin)
% yi=interp1(x,y,xi)根据数据(x,y)给出在xi的线性插值结果yi.
% yi=interp1(x,y,xi,'spline')使用三次样条插值.
% yi=interp1(x,y,xi,'cubic')使用三次插值.
% 例如
%   clear;close;fplot('sin',[0,2*pi]);hold on;
%   x=0:2*pi;y=sin(x);
%   h1=plot(x,y,'ko');
%   xi=[1:5]+0.5;
%   yi=interp1(x,y,xi,'linear');
%   h2=plot(xi,yi,'kx');
%   yi=interp1(x,y,xi,'spline');
%   h3=plot(xi,yi,'k*');
%   legend([h1;h2;h3],'data','linear','spline');
%   hold off;
%
%INTERP1 1-D interpolation (table lookup).
%   YI = INTERP1(X,Y,XI) interpolates to find YI, the values of
%   the underlying function Y at the points in the vector XI.
%   The vector X specifies the points at which the data Y is
%   given. If Y is a matrix, then the interpolation is performed
%   for each column of Y and YI will be length(XI)-by-size(Y,2).
%   Out of range values are returned as NaN. 
%
%   YI = INTERP1(Y,XI) assumes X = 1:N, where N is the length(Y)
%   for vector Y or SIZE(Y,1) for matrix Y.
%
%   Interpolation is the same operation as "table lookup".  Described in
%   "table lookup" terms, the "table" is [X,Y] and INTERP1 "looks-up"
%   the elements of XI in X, and, based upon their location, returns
%   values YI interpolated within the elements of Y.
%
%   YI = INTERP1(X,Y,XI,'method') specifies alternate methods.
%   The default is linear interpolation.  Available methods are:
%
%     'nearest' - nearest neighbor interpolation
%     'linear'  - linear interpolation
%     'spline'  - cubic spline interpolation
%     'cubic'   - cubic interpolation
%
%   All the interpolation methods require that X be monotonic. X can be
%   non-uniformly spaced.  For faster interpolation when X is equally
%   spaced and monotonic, use the methods '*linear', '*cubic', '*nearest'. 
%   For faster linear interpolation when X is non-uniformly spaced 
%   see INTERP1Q.
%
%   For example, generate a coarse sine curve and interpolate over a
%   finer abscissa:
%       x = 0:10; y = sin(x); xi = 0:.25:10;
%       yi = interp1(x,y,xi); plot(x,y,'o',xi,yi)
%
%   See also INTERP1Q, INTERPFT, SPLINE, INTERP2, INTERP3, INTERPN.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.25 $  $Date: 1997/11/21 23:40:40 $

error(nargchk(2,4,nargin));

bypass = 0;
uniform = 1;
if isstr(varargin{end}),
  narg = nargin-1;
  method = [varargin{end} '    ']; % Protect against short string.
  if method(1)=='*', % Direct call bypass.
    if method(2)=='l', % linear interpolation.
      yi = linear(varargin{1:end-1});
      return

    elseif method(2)=='c', % cubic interpolation
      yi = cubic(varargin{1:end-1});
      return

    elseif method(2)=='n', % Nearest neighbor interpolation
      yi = nearest(varargin{1:end-1});
      return

    elseif method(2)=='s', % Spline interpolation
      method = 'spline'; bypass = 1;

    else
      error([deblank(method),' is an invalid method.']);

    end
  elseif method(1)=='s', % Spline interpolation
    method = 'spline'; bypass = 1;
  end
  
else
  narg = nargin;
  method = 'linear';
end

if narg==2, % interp1(y,xi)
  y = varargin{1};
  if min(size(y))==1, x = 1:length(y); else x = 1:size(y,1); end
  [msg,x,y,xi] = xychk(x,varargin{1:2});

elseif narg==3, % interp1(x,y,xi)
  [msg,x,y,xi] = xychk(varargin{1:3});

end

if ~isempty(msg), error(msg); end

if isempty(xi), yi = []; return, end
if min(size(xi))~=1, error('XI must be a vector.'); end

x = x(:); % Make sure x is a column vector.
if min(size(y))==1, y = y(:); end % Make sure y is a column vector.
siz = size(xi); xi = xi(:); % Make sure xi is a column vector.

%
% Check for non-equally spaced data.  If so, map x and
% xi to matrix (row,col) coordinate system.
%
if length(x)>2 & ~bypass,
  dx = diff(x);
  if max(abs(diff(dx))) > eps*max(x),
    if any(dx < 0), % Flip orientation of data so x is increasing.
      if size(x,1)==1,
        x = fliplr(x); y = fliplr(y);
        dx = -fliplr(dx);
      else
        x(:) = flipud(x); y(:) = flipud(y);
        dx(:) = -flipud(dx);
      end
    end

    if any(dx<=0), 
      error('X must be monotonic.');
      return
    end

    % Only nearest needs this mapping code now
   if method(1)=='n', 

      % Determine the nearest location of xi in x
      [xxi,j] = sort(xi(:));
      [dum,i] = sort([x;xxi]);
      ui(i) = 1:length(i);
      ui = (ui(length(x)+1:end) - (1:length(xxi)))';
      ui(j) = ui;
    
      % Map values in xi to index offset (ui) via linear interpolation
      ui(ui<1) = 1;
      ui(ui>length(x)-1) = length(x)-1;
      ui = ui + (xi(:)-x(ui))./(x(ui+1)-x(ui));
    
      x = (1:length(x)).';
      xi = ui;
    else
      uniform = 0;
    end
  end
end

%
% Now do the interpolation based on the method flag
%
if method(1)=='n', % Nearest neighbor interpolation
  yi = nearest(x,y,xi);

elseif method(1)=='l', % Linear interpolation
  if uniform
    yi = linear(x,y,xi);
  else
    yi = interp1q(x,y,xi);
  end

elseif method(1)=='s', % Spline interpolation
  yi = spline(x,y.',xi(:).').';

elseif method(1)=='c', % Cubic interpolation
  if uniform
    yi = cubic(x,y,xi);
  else
    d = find(xi < min(x) | xi > max(x));
    yi = spline(x,y.',xi(:).').';
    if min(size(yi))==1, yi(d) = NaN; else yi(d,:) = NaN; end
  end

else
  error([deblank(method),' is an invalid method.']);

end

if (min(size(yi))==1) & (prod(siz)>1), yi = reshape(yi,siz); end


%------------------------------------------------------
function F=linear(x,y,u)
%LINEAR Linear Interpolation of a 1-D function.
%   F=LINEAR(Y,XI) returns the value of the 1-D function Y at the
%   points XI using linear interpolation. length(F)=length(XI). XI is
%   an index into the vector Y. Y is the value of the function
%   evaluated uniformly on a interval. If Y is a matrix, then
%   the interpolation is performed for each column of Y in which
%   case F is length(XI)-by-size(Y,2).
%
%   If Y is of length N then XI must contain values between 1 and N.
%   The value NaN is returned if this is not the case.
%
%   F = LINEAR(X,Y,XI) uses the vector X to specify the coordinates
%   of the underlying interval. X must be equally spaced and
%   monotonic. NaN's are returned for values of XI outside the
%   coordinates in X.
%
%   See also CUBIC, INTERP1.

%   Clay M. Thompson 7-4-91

if nargin==2,   % No X specified.
  u = y; y = x;
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  [nrows,ncols] = size(y);

elseif nargin==3, % X specified.
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  if min(size(x))==1, x = x(:); end
  [nrows,ncols] = size(y);
  % Scale and shift u to be indices into Y.
  if (min(size(x))~=1), error('X must be a vector.'); end
  [m,n] = size(x);
  if m ~= nrows, 
    error('The length of X must match the number of rows of Y.');
  end
  u = 1 + (u-x(1))/(x(m)-x(1))*(nrows-1);
  
else
  error('Wrong number of input arguments.');
end

if isempty(u), F = []; return, end
if nrows<2, error('Y must have at least 2 rows.'); end

siz = size(u);
u = u(:); % Make sure u is a vector
u = u(:,ones(1,ncols)); % Expand u
[m,n] = size(u);

% Check for out of range values of u and set to 1
uout = find(u<1 | u>nrows);
if ~isempty(uout), u(uout) = 1; end

% Interpolation parameters, check for boundary value.
s = (u - floor(u));
u = floor(u);
if isempty(u), d = u; else d = find(u==nrows); end
if length(d)>0, u(d) = u(d)-1; s(d) = s(d)+1; end

% Now interpolate.
v = (0:n-1)*nrows;
ndx = u+v(ones(m,1),:);
F =  ( y(ndx).*(1-s) + y(ndx+1).*s );

% Now set out of range values to NaN.
if ~isempty(uout), F(uout) = NaN; end

if (min(size(F))==1) & (prod(siz)>1), F = reshape(F,siz); end


%------------------------------------------------------
function F=cubic(x,y,u)
%CUBIC Cubic Interpolation of a 1-D function.
%   YI=CUBIC(Y,XI) returns the value of the 1-D function Y at the
%   points XI using cubic interpolation. length(YI)=length(XI). XI is
%   an index into the vector Y. Y is the value of the function
%   evaluated uniformly on a interval. If Y is a matrix, then
%   the interpolation is performed for each column of Y in which
%   case F is length(XI)-by-size(Y,2).
%
%   If Y is of length N then XI must contain values between 1 and N.
%   The value NaN is returned if this is not the case.
%
%   YI = CUBIC(X,Y,XI) uses the vector X to specify the coordinates
%   of the underlying interval. X must be equally spaced and
%   monotonic. NaN's are returned for values of XI outside the
%   coordinates in X.
%
%   See also LINEAR, INTERP1.

%   Clay M. Thompson 7-4-91

%   Based on "Cubic Convolution Interpolation for Digital Image
%   Processing", Robert G. Keys, IEEE Trans. on Acoustics, Speech, and
%   Signal Processing, Vol. 29, No. 6, Dec. 1981, pp. 1153-1160.

if nargin==2,   % No X specified.
  u = y; y = x;
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  [nrows,ncols] = size(y);

elseif nargin==3, % X specified.
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  if min(size(x))==1, x = x(:); end
  [nrows,ncols] = size(y);
  % Scale and shift u to be indices into Y.
  if (min(size(x))~=1), error('X must be a vector.'); end
  [m,n] = size(x);
  if m ~= nrows, 
    error('The length of X must match the number of rows of Y.');
  end
  u = 1 + (u-x(1))/(x(m)-x(1))*(nrows-1);
  
else
  error('Wrong number of input arguments.');
end

if isempty(u), F = []; return, end
if nrows<3, error('Y must have at least 3 rows.'); end

siz = size(u); u = u(:); % Make sure u is a vector.
u = u(:,ones(1,ncols)); % Expand u 
[m,n] = size(u);

% Check for out of range values of u and set to 1
if isempty(u), uout = u; else uout = find(u<1 | u>nrows); end
if ~isempty(uout), u(uout) = 1; end

% Interpolation parameters, check for boundary value.
s = (u - floor(u));
u = floor(u);
if isempty(u), d = u; else d = find(u==nrows); end
if length(d)>0, u(d) = u(d)-1; s(d) = s(d)+1; end

% Expand y so interpolation is valid at the boundary.
y = [3*y(1,:)-3*y(2,:)+y(3,:);y;3*y(nrows,:)-3*y(nrows-1,:)+y(nrows-2,:)];
nrows = nrows + 2;

% Now interpolate using computationally efficient algorithm.
s2 = s.*s; s3 = s.*s2;
v = (0:n-1)*nrows;
ndx = u+v(ones(m,1),:);
F = y(ndx).*(-s3+2*s2-s) + y(ndx+1).*(3*s3-5*s2+2) + ...
    y(ndx+2).*(-3*s3+4*s2+s) + y(ndx+3).*(s3-s2);
F = F/2;

% Now set out of range values to NaN.
if ~isempty(uout), F(uout) = NaN; end

if (min(size(F))==1) & (prod(siz)>1), F = reshape(F,siz); end


%------------------------------------------------------
function F = nearest(x,y,u)
%NEAREST Nearest Neighbor Interpolation of a 1-D function.
%   YI=NEAREST(Y,XI) returns the value of the 1-D function Y at
%   the points XI using nearest neighbor interpolation,
%   length(YI)=length(XI). XI is an index into the vector Y. Y is
%   the value of the function evaluated uniformly on a interval. If
%   Y is a matrix, then the interpolation is performed for each
%   column of Y in which case F is length(XI)-by-size(Y,2).
%
%   If Y is of length N then XI must contain values between 1 and N.
%   The value NaN is returned if this is not the case.
%
%   YI = NEAREST(X,Y,XI) uses the vector X to specify the
%   coordinates of the underlying interval. X must be equally spaced
%   and monotonic. NaN's are returned for values of XI outside the
%   coordinates in X.
%
%   See also LINEAR, INTERP1.

%   Clay M. Thompson 7-4-91

if nargin==2,   % No X specified.
  u = y; y = x;
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  [nrows,ncols] = size(y);

elseif nargin==3, % X specified.
  % Check for vector problem.  If so, make everything a column vector.
  if min(size(y))==1, y = y(:); end
  if min(size(x))==1, x = x(:); end
  [nrows,ncols] = size(y);
  % Scale and shift u to be indices into Y.
  if (min(size(x))~=1), error('X must be a vector.'); end
  [m,n] = size(x);
  if m ~= nrows, 
    error('The length of X must match the number of rows of Y.');
  end
  u = 1 + (u-x(1))/(x(m)-x(1))*(nrows-1);
  
else
  error('Wrong number of input arguments.');
end

if isempty(u), F = []; return, end
if nrows<2, error('Y must have at least 2 rows.'); end

siz = size(u); u = u(:); % Make sure u is a vector.
u = u(:,ones(1,ncols)); % Expand u 
[m,n] = size(u);

% Check for out of range values of u and set to 1
uout = find(u<.5 | u>=nrows+.5);
if ~isempty(uout), u(uout) = 1; end

% Interpolation parameters
s = (u - round(u));
u = round(u);

% Now interpolate
v = (0:n-1)*nrows;
ndx = u+v(ones(m,1),:);
F = y(ndx);

% Now set out of range values to NaN.
if ~isempty(uout), F(uout) = NaN; end

if (min(size(F))==1) & (prod(siz)>1), F = reshape(F,siz); end

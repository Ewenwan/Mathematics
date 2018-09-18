function [xi,yi,zi] = griddata(x,y,z,xi,yi,method)
%不规则数据的曲面插值
%ZI=griddata(x,y,z,XI,YI)
%  这里x,y,z均为向量(不必单调)表示数据.
%  XI,YI为网格数据矩阵.griddata采用三角形线性插值.
%ZI=griddata(x,y,z,XI,YI,'cubic') 采用三角形三次插值
%例题  如果数据残缺不全(x,y,z)
%      | 0   1    2     3    4 
%-----|------------------------
%  2  | *    *   80    82   84 
%  3  | 79   *   61    65   * 
%  4  | 84  84    *     *   86
% 使用
%   x=[2,3,4,0,2,3,0,1,4];
%   y=[2,2,2,3,3,3,4,4,4];
%   z=[80,82,84,79,61,65,84,84,86];
%   subplot(2,1,1);stem3(x,y,z);title('RAW DATA');
%   xi=0:0.1:4;yi=2:0.2:4;
%   [XI,YI]=meshgrid(xi,yi);
%   ZI=griddata(x,y,z,XI,YI,'cubic');
%   subplot(2,1,2);mesh(XI,YI,ZI);title('GRIDDATA');
%
%GRIDDATA Data gridding and surface fitting.
%   ZI = GRIDDATA(X,Y,Z,XI,YI) fits a surface of the form Z = F(X,Y)
%   to the data in the (usually) nonuniformly-spaced vectors (X,Y,Z)
%   GRIDDATA interpolates this surface at the points specified by
%   (XI,YI) to produce ZI.  The surface always goes through the data
%   points.  XI and YI are usually a uniform grid (as produced by
%   MESHGRID) and is where GRIDDATA gets its name.
%
%   XI can be a row vector, in which case it specifies a matrix with
%   constant columns. Similarly, YI can be a column vector and it 
%   specifies a matrix with constant rows. 
%
%   [XI,YI,ZI] = GRIDDATA(X,Y,Z,XI,YI) also returns the XI and YI
%   formed this way (the results of [XI,YI] = MESHGRID(XI,YI)).
%
%   [...] = GRIDDATA(...,'method') where 'method' is one of
%       'linear'    - Triangle-based linear interpolation (default).
%       'cubic'     - Triangle-based cubic interpolation.
%       'nearest'   - Nearest neighbor interpolation.
%       'v4'        - MATLAB 4 griddata method.
%   defines the type of surface fit to the data. The 'cubic' and 'v4'
%   methods produce smooth surfaces while 'linear' and 'nearest' have
%   discontinuities in the first and zero-th derivative respectively.  All
%   the methods except 'v4' are based on a Delaunay triangulation of the
%   data.
%
%   See also INTERP2, DELAUNAY, MESHGRID.

%   Clay M. Thompson 8-21-95
%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.22 $  $Date: 1997/11/21 23:40:37 $

error(nargchk(5,6,nargin))

[msg,x,y,z,xi,yi] = xyzchk(x,y,z,xi,yi);
if ~isempty(msg), error(msg); end

if nargin<6, method = 'linear'; end
if ~isstr(method), 
  error('METHOD must be one of ''linear'',''cubic'',''nearest'', or ''v4''.');
end


% Sort x and y so duplicate points can be averaged before passing to delaunay

% Need x,y and z to be column vectors
sz = prod(size(x));
x = reshape(x,sz,1);
y = reshape(y,sz,1);
z = reshape(z,sz,1);
sxyz = sortrows([x y z],[2 1]);
x = sxyz(:,1);
y = sxyz(:,2);
z = sxyz(:,3);
ind = [0; y(2:end) == y(1:end-1) & x(2:end) == x(1:end-1); 0];
if sum(ind) > 0
  warning('Duplicate x-y data points detected: using average of the z values');
  fs = find(ind(1:end-1) == 0 & ind(2:end) == 1);
  fe = find(ind(1:end-1) == 1 & ind(2:end) == 0);
  for i = 1 : length(fs)
    % averaging z values
    z(fe(i)) = mean(z(fs(i):fe(i)));
  end
  x = x(~ind(2:end));
  y = y(~ind(2:end));
  z = z(~ind(2:end));
end

switch lower(method),
  case 'linear'
    zi = linear(x,y,z,xi,yi);
  case 'cubic'
    zi = cubic(x,y,z,xi,yi);
  case 'nearest'
    zi = nearest(x,y,z,xi,yi);
  case {'invdist','v4'}
    zi = gdatav4(x,y,z,xi,yi);
  otherwise
    error('Unknown method.');
end
  
if nargout<=1, xi = zi; end


%------------------------------------------------------------
function zi = linear(x,y,z,xi,yi)
%LINEAR Triangle-based linear interpolation

%   Reference: David F. Watson, "Contouring: A guide
%   to the analysis and display of spacial data", Pergamon, 1994.

siz = size(xi);
xi = xi(:); yi = yi(:); % Treat these as columns
x = x(:); y = y(:); % Treat these as columns

% Triangularize the data
tri = delaunay(x,y,'sorted');
if isempty(tri),
  warning('Data cannot be triangulated.');
  zi = repmat(NaN,size(xi));
  return
end

% Find the nearest triangle (t)
t = tsearch(x,y,tri,xi,yi);

% Only keep the relevant triangles.
out = find(isnan(t));
if ~isempty(out), t(out) = ones(size(out)); end
tri = tri(t,:);

% Compute Barycentric coordinates (w).  P. 78 in Watson.
del = (x(tri(:,2))-x(tri(:,1))) .* (y(tri(:,3))-y(tri(:,1))) - ...
      (x(tri(:,3))-x(tri(:,1))) .* (y(tri(:,2))-y(tri(:,1)));
w(:,3) = ((x(tri(:,1))-xi).*(y(tri(:,2))-yi) - ...
          (x(tri(:,2))-xi).*(y(tri(:,1))-yi)) ./ del;
w(:,2) = ((x(tri(:,3))-xi).*(y(tri(:,1))-yi) - ...
          (x(tri(:,1))-xi).*(y(tri(:,3))-yi)) ./ del;
w(:,1) = ((x(tri(:,2))-xi).*(y(tri(:,3))-yi) - ...
          (x(tri(:,3))-xi).*(y(tri(:,2))-yi)) ./ del;
w(out,:) = zeros(length(out),3);

z = z(:).'; % Treat z as a row so that code below involving
            % z(tri) works even when tri is 1-by-3.
zi = sum(z(tri) .* w,2);

zi = reshape(zi,siz);

if ~isempty(out), zi(out) = NaN; end
%------------------------------------------------------------

%------------------------------------------------------------
function zi = cubic(x,y,z,xi,yi)
%TRIANGLE Triangle-based cubic interpolation

%   Reference: T. Y. Yang, "Finite Element Structural Analysis",
%   Prentice Hall, 1986.  pp. 446-449.
%
%   Reference: David F. Watson, "Contouring: A guide
%   to the analysis and display of spacial data", Pergamon, 1994.

siz = size(xi);
xi = xi(:); yi = yi(:); % Treat these as columns
x = x(:); y = y(:); z = z(:); % Treat these as columns

% Triangularize the data
tri = delaunay(x,y,'sorted');
if isempty(tri), 
  warning('Data cannot be triangulated.');
  zi = repmat(NaN,size(xi));
  return
end

%
% Estimate the gradient as the average the triangle slopes connected
% to each vertex
%
t1 = [x(tri(:,1)) y(tri(:,1)) z(tri(:,1))];
t2 = [x(tri(:,2)) y(tri(:,2)) z(tri(:,2))];
t3 = [x(tri(:,3)) y(tri(:,3)) z(tri(:,3))];
Area = ((x(tri(:,2))-x(tri(:,1))) .* (y(tri(:,3))-y(tri(:,1))) - ...
       (x(tri(:,3))-x(tri(:,1))) .* (y(tri(:,2))-y(tri(:,1))))/2;
nv = cross((t3-t1).',(t2-t1).').';

% Normalize normals
nv = nv ./ repmat(nv(:,3),1,3);

% Sparse matrix is non-zero if the triangle specified the row
% index is connected to the point specified by the column index.
% Gradient estimate is area weighted average of triangles 
% around a datum.
m = size(tri,1);
n = length(x);
i = repmat((1:m)',1,3);
T = sparse(i,tri,repmat(-nv(1:m,1).*Area,1,3),m,n);
A = sparse(i,tri,repmat(Area,1,3),m,n);
s = full(sum(A));
gx = (full(sum(T))./(s + (s==0)))';
T = sparse(i,tri,repmat(-nv(1:m,2).*Area,1,3),m,n);
gy = (full(sum(T))./(s + (s==0)))';

% Compute triangle areas and side lengths
i1 = [1 2 3]; i2 = [2 3 1]; i3 = [3 1 2];
xx = x(tri);
yy = y(tri);
zz = z(tri);
gx = gx(tri);
gy = gy(tri);
len = sqrt((xx(:,i3)-xx(:,i2)).^2 + (yy(:,i3)-yy(:,i2)).^2);

% Compute average normal slope
gn = ((gx(:,i2)+gx(:,i3)).*(yy(:,i2)-yy(:,i3)) - ...
      (gy(:,i2)+gy(:,i3)).*(xx(:,i2)-xx(:,i3)))/2./len;

% Compute triangle normal edge gradient at the center of each side (Wn)
Area = repmat(Area,1,3);
Wna = 1/4*(-2*yy(:,i2).*yy(:,i3)+yy(:,i2).^2+yy(:,i3).^2+xx(:,i2).^2 - ...
             2*xx(:,i2).*xx(:,i3)+xx(:,i3).^2).*zz; 
Wna(:) = Wna-1/16.*(yy(:,i2).^2-2*yy(:,i2).*yy(:,i3)+yy(:,i3).^2+xx(:,i2).^2- ...
         2.*xx(:,i2).*xx(:,i3)+xx(:,i3).^2).*(-xx(:,i2)+2.*xx(:,i1)-xx(:,i3)).*gx;
Wna(:) = Wna-1/16.*(yy(:,i2).^2-2.*yy(:,i2).*yy(:,i3)+yy(:,i3).^2+xx(:,i2).^2- ...
         2.*xx(:,i2).*xx(:,i3)+xx(:,i3).^2).*(-yy(:,i2)+2.*yy(:,i1)-yy(:,i3)).*gy;
Wna(:) = Wna./Area./len(:,i1);

Wnb = 1/4*(yy(:,i1).^2+yy(:,i1).*yy(:,i3)-3.*yy(:,i2).*yy(:,i1)+ ...
        3.*yy(:,i2).*yy(:,i3)-2.*yy(:,i3).^2+xx(:,i1).^2+xx(:,i1).*xx(:,i3)- ...
        3.*xx(:,i2).*xx(:,i1)+3.*xx(:,i2).*xx(:,i3)-2.*xx(:,i3).^2).*zz;
Wnb(:) = Wnb-1/16*(6*yy(:,i1).*xx(:,i2).*yy(:,i3)-3*yy(:,i1).^2.*xx(:,i2)- ...
         2*yy(:,i1).*xx(:,i1).*yy(:,i3)+2*yy(:,i1).^2.*xx(:,i1)- ...
         4*yy(:,i1).*xx(:,i3).*yy(:,i3)+yy(:,i1).^2.*xx(:,i3)- ...
         2*yy(:,i2).*xx(:,i3).*yy(:,i3)+2*yy(:,i2).*xx(:,i3).*yy(:,i1)+ ...
         2*yy(:,i2).*xx(:,i1).*yy(:,i3)-2*yy(:,i2).*xx(:,i1).*yy(:,i1)+ ...
         3*yy(:,i3).^2.*xx(:,i3)-3*yy(:,i3).^2.*xx(:,i2)-xx(:,i1).^2.*xx(:,i3)+ ...
         2*xx(:,i1).^3+10*xx(:,i2).*xx(:,i1).*xx(:,i3)-5*xx(:,i2).*xx(:,i1).^2- ...
         4*xx(:,i1).*xx(:,i3).^2-5*xx(:,i3).^2.*xx(:,i2)+3*xx(:,i3).^3).*gx;
Wnb(:) = Wnb-1/16*(-yy(:,i1).^2.*yy(:,i3)+2*yy(:,i1).^3+ ...
         10*yy(:,i2).*yy(:,i1).*yy(:,i3)-5*yy(:,i2).*yy(:,i1).^2- ...
         4*yy(:,i1).*yy(:,i3).^2-5*yy(:,i3).^2.*yy(:,i2)+3*yy(:,i3).^3+ ...
         6*yy(:,i2).*xx(:,i1).*xx(:,i3)-3*yy(:,i2).*xx(:,i1).^2- ...
         2*yy(:,i1).*xx(:,i1).*xx(:,i3)+2*yy(:,i1).*xx(:,i1).^2- ...
         4*yy(:,i3).*xx(:,i1).*xx(:,i3)+yy(:,i3).*xx(:,i1).^2- ...
         2*yy(:,i3).*xx(:,i2).*xx(:,i3)+2*yy(:,i3).*xx(:,i2).*xx(:,i1)+ ...
         2*yy(:,i1).*xx(:,i2).*xx(:,i3)-2*yy(:,i1).*xx(:,i2).*xx(:,i1)+ ...
         3*xx(:,i3).^2.*yy(:,i3)-3*yy(:,i2).*xx(:,i3).^2).*gy;
Wnb(:) = Wnb./Area./len(:,i2);

Wnc = 1/4*(yy(:,i2).*yy(:,i1)+yy(:,i1).^2-2*yy(:,i2).^2+3*yy(:,i2).*yy(:,i3)- ...
         3.*yy(:,i1).*yy(:,i3)+xx(:,i2).*xx(:,i1)+xx(:,i1).^2-2.*xx(:,i2).^2+ ...
         3.*xx(:,i2).*xx(:,i3)-3.*xx(:,i1).*xx(:,i3)).*zz;
Wnc(:) = Wnc-1/16*(yy(:,i1).^2.*xx(:,i2)-4*yy(:,i1).*xx(:,i2).*yy(:,i2)+ ...
         2*yy(:,i1).^2.*xx(:,i1)-2*yy(:,i2).*xx(:,i1).*yy(:,i1)- ...
         3*yy(:,i1).^2.*xx(:,i3)+6*yy(:,i2).*xx(:,i3).*yy(:,i1)- ...
         3*yy(:,i2).^2.*xx(:,i3)+3*yy(:,i2).^2.*xx(:,i2)+ ...
         2*yy(:,i1).*xx(:,i2).*yy(:,i3)-2*yy(:,i2).*xx(:,i2).*yy(:,i3)- ...
         2*yy(:,i1).*xx(:,i1).*yy(:,i3)+2*yy(:,i2).*xx(:,i1).*yy(:,i3)+ ...
         2*xx(:,i1).^3-xx(:,i2).*xx(:,i1).^2-4*xx(:,i2).^2.*xx(:,i1)- ...
         5*xx(:,i1).^2.*xx(:,i3)+10*xx(:,i2).*xx(:,i1).*xx(:,i3)+ ...
         3*xx(:,i2).^3-5*xx(:,i2).^2.*xx(:,i3)).*gx;
Wnc(:) = Wnc-1/16*(2*yy(:,i1).^3-yy(:,i2).*yy(:,i1).^2- ...
         4*yy(:,i2).^2.*yy(:,i1)-5*yy(:,i1).^2.*yy(:,i3)+ ...
         10*yy(:,i2).*yy(:,i1).*yy(:,i3)+3*yy(:,i2).^3- ...
         5*yy(:,i2).^2.*yy(:,i3)+yy(:,i2).*xx(:,i1).^2- ...
         4*yy(:,i2).*xx(:,i1).*xx(:,i2)+2*yy(:,i1).*xx(:,i1).^2- ...
         2*yy(:,i1).*xx(:,i2).*xx(:,i1)-3*yy(:,i3).*xx(:,i1).^2+ ...
         6*yy(:,i3).*xx(:,i2).*xx(:,i1)-3*yy(:,i3).*xx(:,i2).^2+ ...
         3*yy(:,i2).*xx(:,i2).^2+2*yy(:,i2).*xx(:,i1).*xx(:,i3)- ...
         2*yy(:,i2).*xx(:,i2).*xx(:,i3)-2*yy(:,i1).*xx(:,i1).*xx(:,i3)+ ...
         2*yy(:,i1).*xx(:,i2).*xx(:,i3)).*gy;
Wnc(:) = Wnc./Area./len(:,i3);

Wn = Wna(:,[1 2 3]) + Wnb(:,[3 1 2]) + Wnc(:,[2 3 1]);

% Find the nearest triangle (t)
t = tsearch(x,y,tri,xi,yi);

% Only keep the relevant triangles.
out = find(isnan(t));
if ~isempty(out), t(out) = ones(size(out)); end
tri = tri(t,:);
Area = Area(t,:);
len = len(t,:);
xx = xx(t,:);
yy = yy(t,:);
zz = zz(t,:);
gx = gx(t,:);
gy = gy(t,:);
gn = gn(t,:);
Wn = Wn(t,:);

% Compute Barycentric coordinates (w).  P. 78 in Watson.
w = 1/2.*((xx(:,i2)-repmat(xi,1,3)).*(yy(:,i3)-repmat(yi,1,3)) - ...
          (xx(:,i3)-repmat(xi,1,3)).*(yy(:,i2)-repmat(yi,1,3)))./Area;
w(out,:) = ones(length(out),3);

N1 = w(:,i1) + w(:,i1).^2.*w(:,i2) + w(:,i1).^2.*w(:,i3) - ...
               w(:,i1).*w(:,i2).^2 - w(:,i1).*w(:,i3).^2;
N2 = (xx(:,i2)-xx(:,i1)).*(w(:,i1).^2.*w(:,i2)+1/2.*w(:,i1).*w(:,i2).*w(:,i3))+ ...
     (xx(:,i3)-xx(:,i1)).*(w(:,i1).^2.*w(:,i3)+1/2.*w(:,i1).*w(:,i2).*w(:,i3));
N3 = (yy(:,i2)-yy(:,i1)).*(w(:,i1).^2.*w(:,i2)+1/2.*w(:,i1).*w(:,i2).*w(:,i3))+ ...
     (yy(:,i3)-yy(:,i1)).*(w(:,i1).^2.*w(:,i3)+1/2.*w(:,i1).*w(:,i2).*w(:,i3));
N1(out) = zeros(size(out));
N2(out) = zeros(size(out));
N3(out) = zeros(size(out));

M = 8*Area./len.*w(:,i1).*w(:,i2).^2.*w(:,i3).^2 ./ ...
                (w(:,i1)+w(:,i2)+(w(:,i1)+w(:,i2)==0)) ./ ...
                (w(:,i1)+w(:,i3)+(w(:,i1)+w(:,i3)==0));
M(out,:) = zeros(length(out),3);

zi = sum((N1.*zz + N2.*gx + N3.*gy + M.*(gn - Wn)).').';

zi = reshape(zi,siz);

if ~isempty(out), zi(out) = NaN; end
%------------------------------------------------------------

%------------------------------------------------------------
function zi = nearest(x,y,z,xi,yi)
%NEAREST Triangle-based nearest neightbor interpolation

%   Reference: David F. Watson, "Contouring: A guide
%   to the analysis and display of spacial data", Pergamon, 1994.

siz = size(xi);
xi = xi(:); yi = yi(:); % Treat these a columns
x = x(:); y = y(:); z = z(:); % Treat these as columns

% Triangularize the data
tri = delaunay(x,y,'sorted');
if isempty(tri), 
  warning('Data cannot be triangulated.');
  zi = repmat(NaN,size(xi));
  return
end

% Find the nearest vertex
k = dsearch(x,y,tri,xi,yi);

zi = k;
d = find(isfinite(k));
zi(d) = z(k(d));
zi = reshape(zi,siz);
%----------------------------------------------------------


%----------------------------------------------------------
function [xi,yi,zi] = gdatav4(x,y,z,xi,yi)
%GDATAV4 MATLAB 4 GRIDDATA interpolation

%   Reference:  David T. Sandwell, Biharmonic spline
%   interpolation of GEOS-3 and SEASAT altimeter
%   data, Geophysical Research Letters, 2, 139-142,
%   1987.  Describes interpolation using value or
%   gradient of value in any dimension.

xy = x(:) + y(:)*sqrt(-1);

% Determine distances between points
d = xy(:,ones(1,length(xy)));
d = abs(d - d.');
n = size(d,1);
% Replace zeros along diagonal with ones (so these don't show up in the
% find below or in the Green's function calculation).
d(1:n+1:prod(size(d))) = ones(1,n);

non = find(d == 0);
if ~isempty(non),
  % If we've made it to here, then some points aren't distinct.  Remove
  % the non-distinct points by averaging.
  [r,c] = find(d == 0);
  k = find(r < c);
  r = r(k); c = c(k); % Extract unique (row,col) pairs
  v = (z(r) + z(c))/2; % Average non-distinct pairs
  
  rep = find(diff(c)==0);
  if ~isempty(rep), % More than two points need to be averaged.
    runs = find(diff(diff(c)==0)==1)+1;
    for i=1:length(runs),
      k = find(c==c(runs(i))); % All the points in a run
      v(runs(i)) = mean(z([r(k);c(runs(i))])); % Average (again)
    end
  end
  z(r) = v;
  if ~isempty(rep),
    z(r(runs)) = v(runs); % Make sure average is in the dataset
  end

  % Now remove the extra points.
  x(c) = [];
  y(c) = [];
  z(c) = [];
  xy(c,:) = [];
  xy(:,c) = [];
  d(c,:) = [];
  d(:,c) = [];
  
  % Determine the non distinct points
  ndp = sort([r;c]);
  ndp(find(ndp(1:length(ndp)-1)==ndp(2:length(ndp)))) = [];

  warning(sprintf(['Averaged %d non-distinct points.\n' ...
       '         Indices are: %s.'],length(ndp),num2str(ndp')))
end

% Determine weights for interpolation
g = (d.^2) .* (log(d)-1);   % Green's function.
% Fixup value of Green's function along diagonal
g(1:size(d,1)+1:prod(size(d))) = zeros(size(d,1),1);
weights = g \ z(:);

[m,n] = size(xi);
zi = zeros(size(xi));
jay = sqrt(-1);
xy = xy.';

% Evaluate at requested points (xi,yi).  Loop to save memory.
for i=1:m
  for j=1:n
    d = abs(xi(i,j)+jay*yi(i,j) - xy);
    mask = find(d == 0);
    if length(mask)>0, d(mask) = ones(length(mask),1); end
    g = (d.^2) .* (log(d)-1);   % Green's function.
    % Value of Green's function at zero
    if length(mask)>0, g(mask) = zeros(length(mask),1); end
    zi(i,j) = g * weights;
  end
end

if nargout<=1,
  xi = zi;
end
%----------------------------------------------------------


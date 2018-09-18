function h = mesh(x,y,z,c)
%空间曲面图
%  mesh(x,y,z)其中x,y,z为同阶矩阵，每一组对应元素代表一个网格点。
%
%例如 曲面 z=x.*exp(-x^2-y^2),-2<x<2,-2<y<2。
%
%     clear;close;xa=-2:.2:2;ya=xa;
%     [x,y]=meshgrid(xa,ya);z=x.*exp(-x.^2-y.^2);
%     mesh(x,y,z);%网格图
%
%MESH   3-D mesh surface.
%   MESH(X,Y,Z,C) plots the colored parametric mesh defined by
%   four matrix arguments.  The view point is specified by VIEW.
%   The axis labels are determined by the range of X, Y and Z,
%   or by the current setting of AXIS.  The color scaling is determined
%   by the range of C, or by the current setting of CAXIS.  The scaled
%   color values are used as indices into the current COLORMAP.
%
%   MESH(X,Y,Z) uses C = Z, so color is proportional to mesh height.
%
%   MESH(x,y,Z) and MESH(x,y,Z,C), with two vector arguments replacing
%   the first two matrix arguments, must have length(x) = n and
%   length(y) = m where [m,n] = size(Z).  In this case, the vertices
%   of the mesh lines are the triples (x(j), y(i), Z(i,j)).
%   Note that x corresponds to the columns of Z and y corresponds to
%   the rows.
%
%   MESH(Z) and MESH(Z,C) use x = 1:n and y = 1:m.  In this case,
%   the height, Z, is a single-valued function, defined over a
%   geometrically rectangular grid.
%
%   MESH returns a handle to a SURFACE object.
%
%   AXIS, CAXIS, COLORMAP, HOLD, SHADING and VIEW set figure, axes, and 
%   surface properties which affect the display of the mesh.
%
%   See also SURF, MESHC, MESHZ, WATERFALL.

%-------------------------------
%   Additional details:
%
%   MESH sets the FaceColor property to background color and the EdgeColor
%   property to 'flat'.
%
%   If the NextPlot axis property is REPLACE (HOLD is off), MESH resets 
%   all axis properties, except Position, to their default values
%   and deletes all axis children (line, patch, surf, image, and 
%   text objects).

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.7 $  $Date: 1997/11/21 23:33:57 $

%   J.N. Little 1-5-92
%   Modified 2-3-92, LS.

user_view = 0;
cax = newplot;
fc = get(gca,'color');
if strcmp(lower(fc),'none')
    fc = get(gcf,'color');
end

if nargin == 1
    hh = surface(x,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
elseif nargin == 2
        if isstr(y), error('Invalid argument.'); end
    [my ny] = size(y);
    [mx nx] = size(x);
    if mx == my & nx == ny
        hh = surface(x,y,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
    else
        if my*ny == 2 % must be [az el]
            hh = surface(x,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
            set(gca,'View',y);
            user_view = 1;
        else
            error('Invalid input arguments.');
        end
    end
elseif nargin == 3
        if isstr(y) | isstr(z), error('Invalid argument.'); end
    if min(size(y)) == 1 & min(size(z)) == 1 % old style
        hh = surface(x,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
        set(gca,'View',y);
        user_view = 1;
    else
        hh = surface(x,y,z,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
    end
elseif nargin == 4
    hh = surface(x,y,z,c,'FaceColor',fc,'EdgeColor','flat', 'FaceLighting', 'none', 'EdgeLighting', 'flat');
else
    error('Requires 1, 2, 3, or 4 input arguments.');
end
if ~ishold & ~user_view
    view(3); grid on
end
if nargout == 1
    h = hh;
end

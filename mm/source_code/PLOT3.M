%空间曲线图
% PLOT3(x,y,z,s)其中x,y,z为向量，每一组分量代表一个数据点。
%                    s为表示颜色、连线和标记选择的字符串
%例如 曲线x=exp(-0.2*z)*cos(0.5*pi*z),y=exp(-0.2*z)*sin(0.5*pi*z), 0<z<20。
%
%  clear;close;z=0:0.1:20;r=exp(-0.2*z);th=0.5*pi*z;
%  x=r.*cos(th);y=r.*sin(th);plot3(x,y,z,'r');
%
%PLOT3  Plot lines and points in 3-D space.
%   PLOT3() is a three-dimensional analogue of PLOT().
% 
%   PLOT3(x,y,z), where x, y and z are three vectors of the same length,
%   plots a line in 3-space through the points whose coordinates are the
%   elements of x, y and z.
% 
%   PLOT3(X,Y,Z), where X, Y and Z are three matrices of the same size,
%   plots several lines obtained from the columns of X, Y and Z.
% 
%   Various line types, plot symbols and colors may be obtained with
%   PLOT3(X,Y,Z,s) where s is a 1, 2 or 3 character string made from
%   the characters listed under the PLOT command.
% 
%   PLOT3(x1,y1,z1,s1,x2,y2,z2,s2,x3,y3,z3,s3,...) combines the plots
%   defined by the (x,y,z,s) fourtuples, where the x's, y's and z's are
%   vectors or matrices and the s's are strings.
% 
%   Example: A helix:
% 
%       t = 0:pi/50:10*pi;
%       plot3(sin(t),cos(t),t);
% 
%   PLOT3 returns a column vector of handles to LINE objects, one
%   handle per line. The X,Y,Z triples, or X,Y,Z,S quads, can be 
%   followed by parameter/value pairs to specify additional 
%   properties of the lines.
%
%   See also PLOT, LINE, AXIS, VIEW, MESH, SURF.

%-------------------------------
%   Additional details:
%
%
%   If the NextPlot axis property is REPLACE (HOLD is off), PLOT3 resets 
%   all axis properties, except Position, to their default values, and
%   deletes all axis children (line, patch, text, surface, and
%   image objects).

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.3 $  $Date: 1997/11/21 23:34:01 $
%   Built-in function.

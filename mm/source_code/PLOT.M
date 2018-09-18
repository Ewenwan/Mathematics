%二维图（一元函数图）
%用法 plot(x,y,s) 其中x,y为向量，每一对分量代表一个数据点。
%                    s为表示颜色、连线和标记选择的字符串
%图形的线型，标记，颜色均可设定，常用有
%       颜色	   |                线型	                标记
% ---------------------      -------------------  -------------------
%   b          蓝(默认)	       -      实线(默认)	无(默认)
%   g           绿             --     虚线         *          星
%   r           红             :      粗点线       .          点
%   y           黄             -.     点划线       o          圈
%   m           洋红                               x          叉
%   c           青                                 +          十字
%   w           白                                 s          方块
%   k           黑                                 d          菱形
%                                                  v          下三角形
%                                                  ^          上三角形
%                                                  <          左三角形
%                                                  >          右三角形
%                                                  h          六角形
%                                                  p          五角形
%例如
%    x=0:0.2:2*pi;y=sin(x);
%    plot(x,y,'r*')
%
%PLOT   Linear plot. 
%   PLOT(X,Y) plots vector Y versus vector X. If X or Y is a matrix,
%   then the vector is plotted versus the rows or columns of the matrix,
%   whichever line up. 
%
%   PLOT(Y) plots the columns of Y versus their index.
%   If Y is complex, PLOT(Y) is equivalent to PLOT(real(Y),imag(Y)).
%   In all other uses of PLOT, the imaginary part is ignored.
%
%   Various line types, plot symbols and colors may be obtained with
%   PLOT(X,Y,S) where S is a character string made from one element
%   from any or all the following 3 colunms:
%
%          y     yellow        .     point              -     solid
%          m     magenta       o     circle             :     dotted
%          c     cyan          x     x-mark             -.    dashdot 
%          r     red           +     plus               --    dashed   
%          g     green         *     star
%          b     blue          s     square
%          w     white         d     diamond
%          k     black         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
%                         
%   For example, PLOT(X,Y,'c+:') plots a cyan dotted line with a plus 
%   at each data point; PLOT(X,Y,'bd') plots blue diamond at each data 
%   point but does not draw any line.
%
%   PLOT(X1,Y1,S1,X2,Y2,S2,X3,Y3,S3,...) combines the plots defined by
%   the (X,Y,S) triples, where the X's and Y's are vectors or matrices 
%   and the S's are strings.  
%
%   For example, PLOT(X,Y,'y-',X,Y,'go') plots the data twice, with a
%   solid yellow line interpolating green circles at the data points.
%
%   The PLOT command, if no color is specified, makes automatic use of
%   the colors specified by the axes ColorOrder property.  The default
%   ColorOrder is listed in the table above for color systems where the
%   default is yellow for one line, and for multiple lines, to cycle
%   through the first six colors in the table.  For monochrome systems,
%   PLOT cycles over the axes LineStyleOrder property.
%
%   PLOT returns a column vector of handles to LINE objects, one
%   handle per line. 
%
%   The X,Y pairs, or X,Y,S triples, can be followed by 
%   parameter/value pairs to specify additional properties 
%   of the lines.
%                                   
%   See also SEMILOGX, SEMILOGY, LOGLOG, GRID, CLF, CLC, TITLE,
%   XLABEL, YLABEL, AXIS, AXES, HOLD, COLORDEF, and SUBPLOT.

%   If the NextPlot axes property is "replace" (HOLD is off), PLOT resets 
%   all axes properties, except Position, to their default values,
%   deletes all axes children (line, patch, text, surface, and
%   image objects), and sets the View property to [0 90].

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 5.7 $  $Date: 1997/11/21 23:33:07 $
%   Built-in function.


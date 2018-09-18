function funtool(keyword,varargin)
%图形界面函数计算器，能进行函数各类初等运算、积分、微分、作图。
%FUNTOOL A function calculator.
%   FUNTOOL is an interactive graphing calculator that manipulates
%   functions of a single variable.  At any time, there are two functions
%   displayed, f(x) and g(x).  The result of most operations replaces f(x).
%
%   The controls labeled 'f = ' and 'g = ' are editable text that may
%   be changed at any time to install a new function.  The control
%   labeled 'x = ' may be changed to specify a new domain.  The control
%   labeled 'a = ' may be changed to specify a new value of a parameter.
%
%   The top row of control buttons are unary function operators that
%   involve only f(x).  These operators are:
%      df/dx     - Symbolically differentiate f(x).
%      int f     - Symbolically integrate f(x).
%      simple f  - Simplify the symbolic expression, if possible.
%      num f     - Extract the numerator of a rational expression.
%      den f     - Extract the denominator of a rational expression.
%      1/f       - Replace f(x) by 1/f(x).
%      finv      - Replace f(x) by its inverse function.
%
%   The operators int(f) and finv may fail if the corresponding symbolic
%   expressions do not exist in closed form.
%
%   The second row of buttons translate and scale f(x) by the parameter 'a'.
%   The operations are:
%      f + a    - Replace f(x) by f(x) + a.
%      f - a    - Replace f(x) by f(x) - a.
%      f * a    - Replace f(x) by f(x) * a.
%      f / a    - Replace f(x) by f(x) / a.
%      f ^ a    - Replace f(x) by f(x) ^ a.
%      f(x+a)   - Replace f(x) by f(x + a).
%      f(x*a)   - Replace f(x) by f(x * a).
%
%   The third row of buttons are binary function operators that
%   operate on both f(x) and g(x).  The operations are:
%      f + g  - Replace f(x) by f(x) + g(x).
%      f - g  - Replace f(x) by f(x) - g(x).
%      f * g  - Replace f(x) by f(x) * g(x).
%      f / g  - Replace f(x) by f(x) / g(x).
%      f(g)   - Replace f(x) by f(g(x)).
%      g = f  - Replace g(x) by f(x).
%      swap   - Interchange f(x) and g(x).
%
%   The first three buttons in the fourth row manage a list of functions.
%   The Insert button places the current active function in the list.
%   The Cycle button rotates the function list.
%   The Delete button removes the active function from the list.  
%   The list of functions is named fxlist.  A default fxlist containing 
%           several interesting functions is provided.
%
%   The Reset button sets f, g, x, a and fxlist to their initial values.
%   The Help button prints this help text.  
%
%   The Demo button poses the following challenge: Can you generate the
%   function sin(x) without touching the keyboard, using just the mouse?
%   The demo does it with a reset and then nine clicks.  If you can do
%   it with fewer clicks, please send e-mail to moler@mathworks.com.
%
%   The Close button closes all three windows.
%
%   See also EZPLOT.

%   Copyright (c) 1993-98 by The MathWorks, Inc.
%       $Revision: 1.11 $  $Date: 1997/11/29 01:06:25 $

%Implementation Notes:
%   f,g, and a are syms.
%   x is a string. fxlist is a string matrix.
%
%   The values of f, g, a, and x are stored in the UserData of the text 
%     objects "f", "g", "a", and "x", respectively. These text objects are 
%     tagged "fobj", "gobj", "aobj", and "xstr", respectively.
%   fxlist is stored in the UserData of the control panel figure, which is 
%     tagged as "figp".
%   The edit text boxes for f, g, x, and a are tagged "Sf", "Sg", "Sx", and
%     "Sa", respectively.
%   The initial values of f, g, x, a, and fxlist are stored in a structure 
%     called init that has fields .f, .g, .x, .a and .l. The structure is 
%     stored in the UserData of the Reset button.

%%%%%%%%%%%%%%%%%%%%%%%%%%  Initialization section.
if nargin == 0

init.f = 'x';
init.g = '1';
init.x = '[-2*pi, 2*pi]';
init.a = '1/2';
init.l = str2mat( ...
    '1/(5+4*cos(x));  [-2*pi, 2*pi]', ...
    'cos(x^3)/(1+x^2);  [-2*pi, 2*pi]', ...
    'x^4*(1-x)^4/(1+x^2);  [0, 1]', ...
    'x^7-7*x^6+21*x^5-35*x^4+35*x^3-21*x^2+7*x-1;  [0.985, 1.015]', ...
    'log(abs(sqrt(x)));  [0, 2]', ...
    'tan(sin(x))-sin(tan(x));  [-pi, pi]');

f = sym(init.f); 
g = sym(init.g);
a = sym(init.a);
x = init.x;
fxlist = init.l;

% Macros
blanks = '  ';
p = .12*(1:7) - .02;
q = .60 - .14*(1:4);
r = [.10 .10];

% Position the two figures and the control panel.
figf = figure('units','normalized','pos',[.01 .50 .48 .48],...
              'menu','none','tag','figf');
figg = figure('units','normalized','pos',[.50 .50 .48 .48],...
              'menu','none', 'tag','figg');
figp = figure('units','normalized','pos',[.25 .05 .50 .40],'menu','none', ...
              'tag','figp',...
              'Color',get(0,'DefaultUIControlBackgroundColor'), ...
              'DefaultUIControlUnit','norm','UserData',fxlist);

% Plot f(x) and g(x).
figure(figf)
ezplot(f,x,figf)
figure(figg)
ezplot(g,x,figg)

% Control panel
figure(figp)
uicontrol('style','frame','pos',[0.01 0.60 0.98 0.38]);
uicontrol('style','frame','pos',[0.01 0.01 0.98 0.58]);
uicontrol('style','text','string','f = ','pos',[0.04 0.86 0.09 0.10],...
    'tag','fobj','UserData',f);
uicontrol('style','text','string','g = ','pos',[0.04 0.74 0.09 0.10],...
    'tag','gobj','UserData',g);
uicontrol('style','text','string','x = ','pos',[0.04 0.62 0.09 0.10],...
    'tag','xstr','UserData',x);
uicontrol('style','text','string','a = ','pos',[0.54 0.62 0.09 0.10],...
    'tag','aobj','UserData',a);
uicontrol('pos',[.12 .86 .82 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', ...
    'string', [blanks char(f)],'tag','Sf', ...
    'CallBack','funtool Sfcallback');
uicontrol('pos',[.12 .74 .82 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', ...
    'string', [blanks char(g)], 'tag','Sg',...
    'CallBack','funtool Sgcallback');
uicontrol('pos',[.12 .62 .32 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white','string',[blanks x], 'tag','Sx',...
    'CallBack','funtool Sxcallback');
uicontrol('pos',[.62 .62 .32 .10],'style','edit','horiz','left', ...
    'backgroundcolor','white', 'tag','Sa',...
    'string',[blanks char(a)],'CallBack','funtool Sacallback');

% Top row of unary operators. 
uicontrol('pos',[p(1) q(1) r],'string','df/dx', ...
   'CallBack','funtool(''row1'',''diff'')');
uicontrol('pos',[p(2) q(1) r],'string','int f', ...  
   'CallBack','funtool(''row1'',''int'')');
uicontrol('pos',[p(3) q(1) r],'string','simple f', ...  
   'CallBack','funtool(''row1'',''simple'')');
uicontrol('pos',[p(4) q(1) r],'string','num f', ...  
   'CallBack','funtool(''row1'',''num'')');
uicontrol('pos',[p(5) q(1) r],'string','den f', ...  
   'CallBack','funtool(''row1'',''den'')');
uicontrol('pos',[p(6) q(1) r],'string','1/f', ...  
   'CallBack','funtool(''row1'',''1/f'')');
uicontrol('pos',[p(7) q(1) r],'string','finv', ...  
   'CallBack','funtool(''row1'',''finverse'')');

% Second row of unary operators.  
uicontrol('pos',[p(1) q(2) r],'string','f+a', ...
   'CallBack','funtool(''row2'',''f+a'')');
uicontrol('pos',[p(2) q(2) r],'string','f-a', ...
   'CallBack','funtool(''row2'',''f-a'')');
uicontrol('pos',[p(3) q(2) r],'string','f*a', ...
   'CallBack','funtool(''row2'',''f*a'')');
uicontrol('pos',[p(4) q(2) r],'string','f/a', ...
   'CallBack','funtool(''row2'',''f/a'')');
uicontrol('pos',[p(5) q(2) r],'string','f^a', ...
   'CallBack','funtool(''row2'',''f^a'')');
uicontrol('pos',[p(6) q(2) r],'string','f(x+a)', ...
   'CallBack','funtool(''row2'',''f(x+a)'')');
uicontrol('pos',[p(7) q(2) r],'string','f(x*a)', ...
   'CallBack','funtool(''row2'',''f(x*a)'')');

% Third row, binary operators.
uicontrol('pos',[p(1) q(3) r],'string','f + g', ...
    'CallBack','funtool(''row3'',''f+g'')');
uicontrol('pos',[p(2) q(3) r],'string','f - g', ...
    'CallBack','funtool(''row3'',''f-g'')');
uicontrol('pos',[p(3) q(3) r],'string','f * g', ...
    'CallBack','funtool(''row3'',''f*g'')');
uicontrol('pos',[p(4) q(3) r],'string','f / g', ...
    'CallBack','funtool(''row3'',''f/g'')');
uicontrol('pos',[p(5) q(3) r],'string','f(g)', ...
    'CallBack','funtool(''row3'',''f(g)'')');
uicontrol('pos',[p(6) q(3) r],'string','g = f', ...
    'CallBack','funtool(''row3'',''g=f'')');
uicontrol('pos',[p(7) q(3) r],'string','swap', ...
    'CallBack','funtool(''row3'',''swap'')');

% Fourth row, auxilliary controls.
uicontrol('pos',[p(1) q(4) r],'string','Insert','CallBack','funtool Insert');
uicontrol('pos',[p(2) q(4) r],'string','Cycle','CallBack','funtool Cycle'); 
uicontrol('pos',[p(3) q(4) r],'string','Delete','CallBack','funtool Delete');
uicontrol('pos',[p(4) q(4) r],'string','Reset','Tag','reset', ...
    'UserData', init, 'CallBack', 'funtool Reset');
uicontrol('pos',[p(5) q(4) r],'string','Help', ...
    'CallBack','helpwin funtool');
uicontrol('pos',[p(6) q(4) r],'string','Demo', ...
    'CallBack','funtool Demo');
uicontrol('pos',[p(7) q(4) r],'string','Close', ...
    'CallBack','funtool close');

%%%%%%%%%%%%%%%%%%%%%%%%%%  end of Initialization section

else
switch keyword

%%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for top row of unary operators.
case 'row1'
   figp = findobj(0,'tag','figp');
   fhndl = findobj(figp,'tag','fobj');
   f = get(fhndl,'UserData');
   x = get(findobj(figp,'tag','xstr'),'UserData');
   figf = findobj(0,'tag','figf');

   switch varargin{1}
     case 'diff'
       f = diff(f);
     case 'int'
       f = int(f);
     case 'simple'
       f = simple(f);
     case 'num'
       [f,ans] = numden(f); 
     case 'den'
       [ans,f] = numden(f);
     case '1/f'
       f = 1/f;
     case 'finverse'
       f = finverse(f);
   end

   set(fhndl,'UserData',f);
   ezplot(f,x,figf)
   blanks = '  ';
   set(findobj(figp,'tag','Sf'),'string',[blanks char(f)]);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for second row of unary operators.
case 'row2'
   figp = findobj(0,'tag','figp');
   fhndl = findobj(figp,'tag','fobj');
   f = get(fhndl,'UserData');
   x = get(findobj(figp,'tag','xstr'),'UserData');
   a = get(findobj(figp,'tag','aobj'),'UserData');
   figf = findobj(0,'tag','figf');

   switch varargin{1}
     case 'f+a'
       f = f+a;
     case 'f-a'
       f = f-a;
     case 'f*a'
       f = f*a;
     case 'f/a'
       f = f/a;
     case 'f^a'
       f = f^a;
     case 'f(x+a)'
       f = subs(f,sym('x'),sym('x')+a);
     case 'f(x*a)', ...
       f = subs(f,sym('x'),sym('x')*a);
   end

   set(fhndl,'UserData',f);
   ezplot(f,x,figf)
   blanks = '  ';
   set(findobj(figp,'tag','Sf'),'string',[blanks char(f)]);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%  Callback for third row, binary operators.
case 'row3'
   blanks = '  ';

   % Get variables.
   figp = findobj(0,'tag','figp');
   fhndl = findobj(figp,'tag','fobj');
   ghndl = findobj(figp,'tag','gobj');
   f = get(fhndl,'UserData');
   g = get(ghndl,'UserData');
   x = get(findobj(figp,'tag','xstr'),'UserData');
   a = get(findobj(figp,'tag','aobj'),'UserData');
   figf = findobj(0,'tag','figf');
   figg = findobj(0,'tag','figg');

   if strcmp(varargin{1}, 'g=f')
     g = f;
     set(ghndl,'UserData',g);
     ezplot(g,x,figg)
     set(findobj(figp,'tag','Sg'),'string',[blanks char(g)]);

   elseif strcmp(varargin{1}, 'swap')
     h = f; f = g; g = h;
     set(fhndl,'UserData',f);
     ezplot(f,x,figf)
     set(findobj(figp,'tag','Sf'),'string',[blanks char(f)]);
     set(ghndl,'UserData',g);
     ezplot(g,x,figg)
     set(findobj(figp,'tag','Sg'),'string',[blanks char(g)]);

   else
     switch varargin{1}
       case 'f+g'
         f = f+g;
       case 'f-g'
         f = f-g; 
       case 'f*g'
         f = f*g; 
       case 'f/g'
         f = f/g; 
       case 'f(g)'
         f = compose(f,g); 
     end

     set(fhndl,'UserData',f);
     ezplot(f,x,figf)
     set(findobj(figp,'tag','Sf'),'string',[blanks char(f)]);
   end

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for F's edit text box.
case 'Sfcallback'
   figp = findobj(0,'tag','figp');
   f = sym(get(gco,'string'));
   fhndl = findobj(figp,'tag','fobj');
   set(fhndl,'UserData',f);
   x = get(findobj(figp,'tag','xstr'),'UserData');
   figf = findobj(0,'tag','figf');
   ezplot(f,x,figf)

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for G's edit text box.
case 'Sgcallback'
   figp = findobj(0,'tag','figp');
   g = sym(get(gco,'string'));
   ghndl = findobj(figp,'tag','gobj');
   set(ghndl,'UserData',g);
   x = get(findobj(figp,'tag','xstr'),'UserData');
   figg = findobj(0,'tag','figg');
   ezplot(g,x,figg)

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for A's edit text box.
case 'Sacallback'
   a = sym(get(gco,'String'));
   set(findobj(gcf,'tag','aobj'),'UserData',a);

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for X's edit text box.
case 'Sxcallback'

   figp = findobj(0,'tag','figp');
   x = get(gco,'String');

   % add brackets if needed
   if isempty(x=='['),
      x = ['[' x ']'];
      blanks = '  ';
      set(gco,'string',[blanks x]),
   end;
   set(findobj(figp,'tag','xstr'),'UserData',x);

   fhndl = findobj(figp,'tag','fobj');
   ghndl = findobj(figp,'tag','gobj');
   f = get(fhndl,'UserData');
   g = get(ghndl,'UserData');
   a = get(findobj(figp,'tag','aobj'),'UserData');
   figf = findobj(0,'tag','figf');
   figg = findobj(0,'tag','figg');
   
   ezplot(f,x,figf)
   ezplot(g,x,figg)

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Insert button.
case 'Insert'
   f = get(findobj(gcf,'tag','fobj'),'UserData');
   x = get(findobj(gcf,'tag','xstr'),'UserData');
   fxlist = get(gcf,'UserData');
   fxlist = str2mat(fxlist,[char(f) ';  ' x]);
   set(gcf,'UserData',fxlist);

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Cycle button.
case 'Cycle'

   % Get variables.
   figp = gcf;
   figf = findobj(0,'tag','figf');
   fxlist = get(figp,'UserData');

   fx = fxlist(1,:); 
   fx(find(fx==' ')) = [];
   k = find(fx == ';'); 
   fstr = fx(1:k-1); f = sym(fstr); 
   set(findobj(figp,'tag','fobj'),'UserData',f);
   x = fx(k+1:length(fx)); 
   set(findobj(figp,'tag','xstr'),'UserData',x);

   blanks = '  ';
   set(findobj(figp,'tag','Sx'),'string',[blanks x]); 
   set(findobj(figp,'tag','Sf'),'string',[blanks fstr]); 
   ezplot(f,x,figf);
   k = [2:size(fxlist,1),1]; 
   fxlist = fxlist(k,:);
   set(figp,'UserData',fxlist);

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Delete button.
case 'Delete'

   % Get variables.
   figp = gcf;
   f = get(findobj(figp,'tag','fobj'),'UserData');
   x = get(findobj(figp,'tag','xstr'),'UserData');
   fxlist = get(figp,'UserData');

   fx = [char(f) ';' x]; 
   fx(find(fx==' ')) = [];
   for k = 1:size(fxlist,1), 
      element = fxlist(k,:);
      element(find(element==' ')) = [];
      if strcmp(fx,element)
        fxlist(k,:) = []; 
        break 
      end 
   end; 
   if isempty(fxlist), fxlist = '0-0;  [0,1]'; end

   set(figp,'UserData',fxlist);

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Reset button.
case 'Reset'
   blanks = '  ';

   % Get variables.
   figp = gcf;
   figf = findobj(0,'tag','figf');
   figg = findobj(0,'tag','figg');
   init = get(findobj(figp,'tag','reset'),'UserData');

   set(findobj(figp,'tag','fobj'),'UserData',sym(init.f));
   set(findobj(figp,'tag','Sf'),'String',[blanks init.f]);
   ezplot(sym(init.f),init.x,figf);

   set(findobj(figp,'tag','gobj'),'UserData',sym(init.g));
   set(findobj(figp,'tag','Sg'),'String',[blanks init.g]);
   ezplot(sym(init.g),init.x,figg);

   set(findobj(figp,'tag','xstr'),'UserData',init.x);
   set(findobj(figp,'tag','Sx'),'string',[blanks init.x]);

   set(findobj(figp,'tag','aobj'),'UserData',sym(init.a));
   set(findobj(figp,'tag','Sa'),'string',[blanks init.a]);

   set(figp,'UserData',init.l);

   % Reset all buttons to default bkgd color.
   set(findobj(figp,'Style','pushbutton'),'BackgroundColor','default');

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Close button.
case 'close'
   close(findobj(0,'tag','figf')); 
   close(findobj(0,'tag','figg')); 
   close(findobj(0,'tag','figp')); 

%%%%%%%%%%%%%%%%%%%%%%%%%% Callback for Demo button.
case 'Demo'

   % "B" is the vector of button handles in the control panel.
   % "prog" is a "program" consisting of button codes.

   prog = {'Reset','f/a','int f','f + g','1/f', ...
           'int f','finv','int f','df/dx','num f'};
   B = findobj(gcf,'Style','pushbutton'); 
   for k = 1: length(prog)
      currB = findobj(B,'String',prog{k});
      set(currB,'BackgroundColor','white');
      eval(get(currB,'Callback'));
      pause(1)
      set(currB,'BackgroundColor','default');
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end % switch statement for callbacks
end     % end of FUNTOOL

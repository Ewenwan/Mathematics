function BNBGUI(file)
%非线性整数规划图形工具
% BNGUI Runs a GUI for BNB18 
% Usage: BNBGUI
% or     BNBGUI(file)
%
% file is a MAT-file saved by BNBGUI. 
%
% The GUI has (some) online help.
%
% E.C. Kuipers
% e-mail E.C.Kuipers@cpedu.rug.nl 
% FI-Lab
% Applied Physics
% Rijksuniversiteit Groningen
%
% BNBGUI uses:
% bnbgui.m bnbguicb.m guierr.m guierr.mat guifun.m guifun.mat
% guimain.m guimain.mat guiset.m guiset.mat bnb18.m
% 
% BNB18 uses:
% Optimization Toolbox Version 2.0 (R11) 09-Oct-1998
% From this toolbox fmincon.m is called.
%
if nargin==0
   bnbguicb('init');
   bnbguicb('main');
elseif nargin==1
   bnbguicb('load',file);
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         S_MSE= objfun(FVr_temp, S_struct)
% Author:           Rainer Storn
% Description:      Implements the cost function to be minimized.
% Parameters:       FVr_temp     (I)    Paramter vector
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     S_MSE.I_nc   (O)    Number of constraints
%                   S_MSE.FVr_ca (O)    Constraint values. 0 means the constraints
%                                       are met. Values > 0 measure the distance
%                                       to a particular constraint.
%                   S_MSE.I_no   (O)    Number of objectives.
%                   S_MSE.FVr_oa (O)    Objective function values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function S_MSE= objfun(FVr_temp, S_struct)

x = FVr_temp(1);
y = FVr_temp(2);
f1 = x^2+y;
f2 = x+y^2;

%----strategy to put everything into a cost function------------
S_MSE.I_nc      = 0;%no constraints
S_MSE.FVr_ca    = 0;%no constraint array
S_MSE.I_no      = 2;%number of objectives (costs)
S_MSE.FVr_oa = [f1 f2]; % This should be a row vector, or will have problem in PlotIt
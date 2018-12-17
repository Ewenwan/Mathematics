%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:         PlotIt(FVr_temp,iter,S_struct)
% Author:           Rainer Storn
% Description:      PlotIt can be used for special purpose plots
%                   used in deopt.m.
% Parameters:       FVr_temp     (I)    Paramter vector
%                   iter         (I)    counter for optimization iterations
%                   S_Struct     (I)    Contains a variety of parameters.
%                                       For details see Rundeopt.m
% Return value:     -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PlotIt(FVr_temp,iter,S_struct)

figure(1);
plot(S_struct.FM_pop(:,1),S_struct.FM_pop(:,2),'ro');
xlabel('x');
ylabel('y');
xlim([-10;10]);
ylim([-10;10]);
grid on;

ff = vertcat(S_struct.S_val.FVr_oa);
f1 = ff(:,1);
f2 = ff(:,2);
figure(2);
plot(f1,f2,'bo');
xlabel('f_1');
ylabel('f_2');
xlim([-100;100]);
ylim([-100;100]);
grid on;

drawnow;
pause(0.5); %wait for one second to allow convenient viewing
return

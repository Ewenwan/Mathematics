%%本程序是用分枝定界法求解整数线性规划问题
%%问题的标准形式：
%%  min c'*x
%% s.t. A*x<=b
%%      Aeq*x=beq
%%  x要求是整数
%例 min Z=x1+4x2
% s.t.  2x1+x2<=8
%       x1+2x2>=6
%       2x1+3x2=9;
%       x1, x2>=0且为整数
%先将x1+2x2>=6化为 - x1 - 2x2<= -6
%c=[1 4];
%A=[2 1;-1 -2];
%b=[8;-6];
%Aeq=[2 3];
%beq=9;
%[y,fval]=BranchBound(c,A,b,Aeq,beq)



function [y,fval]=BranchBound(c,A,b,Aeq,beq)
NL=length(c);  
UB=inf;
LB=-inf;
FN=[0];
AA(1)={A};
BB(1)={b};
k=0; 
flag=0;
while flag==0;      
    [x,fval,exitFlag]=linprog(c,A,b,Aeq,beq);
    if (exitFlag == -2) | (fval >= UB)    
        FN(1)=[];
        if isempty(FN)==1    
            flag=1;
        else
            k=FN(1);
            A=AA{k};
            b=BB{k};
        end
    else
        for i=1:NL
            if abs(x(i)-round(x(i)))>1e-7    
                kk=FN(end);
                FN=[FN,kk+1,kk+2];   
                temp_A=zeros(1,NL);
                temp_A(i)=1;
                temp_A1=[A;temp_A];
                AA(kk+1)={temp_A1};
                b1=[b;fix(x(i))];
                BB(kk+1)={b1};
                temp_A2=[A;-temp_A];
                AA(kk+2)={temp_A2};
                b2=[b;-(fix(x(i))+1)];
                BB(kk+2)={b2};
                FN(1)=[];
                k=FN(1);
                A=AA{k};
                b=BB{k};
                break;   
            end
        end
        if (i==NL) & (abs(x(i)-round(x(i)))<=1e-7)       
            UB=fval;
            y=x;
            FN(1)=[];  
            if isempty(FN)==1
                flag=1;
            else
                k=FN(1);
                A=AA{k};
                b=BB{k};
            end
        end
    end
end
y=round(y);
fval=c*y;

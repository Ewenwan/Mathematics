%最优化枚举法例——满足一定条件求最优解的穷举法
clear;
vmax=-inf;
for x2=10:20
   for x3=-5:16
      if x2+2*x3>=10&3*x2+2*x3<=62,
         v=(x2+10)*x2*x3;
         if v>vmax,
            vmax=v;x20=x2;x30=x3;
         end
      end
   end
end
x1=x20+10,x2=x20,x3=x30
vmax

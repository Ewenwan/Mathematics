function f=jm99afun(n)
%99年中国大学生数学建模竞赛a题：自动化车床问题一函数
%参见《数学的实践与认识》2000.1.p36-40
mu=600*0.95;sig=196.6292*0.95;
L=100*n(1)+3005;
L=L*normcdf(n(2)-n(1)/2,mu,sig);
t=0:0.1:(n(2)-n(1)/2);
L=L+10/n(1)*trapz(t,t.*normpdf(t,mu,sig));
c=200*n(2)+10*n(2)/n(1)+3000;
L=L+c*(normcdf(n(2),mu,sig)-normcdf(n(2)-n(1)/2,mu,sig));
t=(n(2)-n(1)/2):0.01:n(2);
L=L-200*trapz(t,t.*normpdf(t,mu,sig));
L=L+(10*n(2)/n(1)+1000)*(1-normcdf(n(2),mu,sig));

t=0:0.1:(n(2)-n(1)/2);
np=trapz(t,t.*normpdf(t,mu,sig));
np=np+n(1)/2*normcdf(n(2)-n(1)/2,mu,sig);
np=np+n(2)*(1-normcdf(n(2)-n(1)/2,mu,sig));

f=L/np;




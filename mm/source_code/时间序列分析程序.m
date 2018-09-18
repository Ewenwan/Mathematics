z=[16 12 15 10 9 17 11 16 10 14]; %任给一组数据，通过下面函数求解样本均值z1、样本自协方差函数r、样本自相关函数p（SACF）和样本偏自相关函数q(SPACF)

N=size(z);   %size(A,1)返回矩阵A的行数  size(A,2)返回矩阵A的列数
n=N(1,2);
z1=sum(z)/n; %样本均值z1

s0=0;
for i=1:n
    s0=(z(i)-z1)^2+s0;
end
r0=s0/n;

%%样本自协方差函数r
for k=1:(n-1)
    nr(k)=0;
    for t=1:(n-k)
        nr(k)=(z(t)-z1)*(z(t+k)-z1)+nr(k);
    end 
end   
r=nr./n;

%%样本自相关函数p
p=(r./r0)';%p=vpa((r./r0)',3); %vpa(n,m)对n保留小数点后m位

%%偏自相关函数q
for m=1:(n-2)
    q(1,1)=p(1);
    D=0;T=0;
    for h=1:m
        D=p(m+1-h)*q(m,h)+D;
        T=p(h)*q(m,h)+T;
    end
        q(m+1,m+1)=(p(m+1)-D)/(1-T);
    for j=1:m
        q(m+1,j)=q(m,j)-q(m+1,m+1)*q(m,m+1-j);
    end     
end
q

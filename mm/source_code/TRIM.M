function data=trim(data,outval)
%data=trim(data,outval)
% 祛除坏数据，包括NaN, Inf, 和异常大小数据
% data: 列状数据，每列来自一个总体,返回净化后的数据
% outval: 系数因子，离均值超过outval倍标准差被判为异常大小，默认为4

% L.J.HU 8-17-1999

if nargin<2,outval=4;end
outliers=(isnan(data)|abs(data)==inf);
[n,m]=size(data);mu=mean(data);sigma=std(data);
outliers=outliers+(abs(data-ones(n,1)*mu)>outval*ones(n,1)*sigma);
if m>1,
   data(any(outliers'),:)=[];
else
  data(find(outliers'),:)=[];
end


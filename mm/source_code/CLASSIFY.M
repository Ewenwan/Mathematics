function class = classify(sample,training,group)
%线性统计聚类
%class = classify(样品集，训练品集，训练品类别集)将各样品分类。
%         样品集为n*p矩阵，训练品集为m*p矩阵，
%         类别集为m维列向量，表示各训练品归类。
%         class为n维列向量，返回各样品分类。
%
%例如
%     load discrim      %MATLAB内部数据，表达美国329个城市天气住房等9个指标
%       					  %共分1，2两类
%     sample = ratings(idx,:);       %其实idx都是2类
%     training = ratings(1:200,:);  %已知训练品集
%     g = group(1:200);				 %已知训练品集城市类别
%     class = classify(sample,training,g)；%对idx分类
%     [class,group(idx)]              %结果基本正确
%
%CLASSIFY Linear discriminant analysis.
%   CLASSIFY(SAMPLE,TRAINING,GROUP) classifies each row of 
%   the data in SAMPLE into one of the values of the vector
%   GROUP. GROUP contains integers from one to the number of 
%   groups in the training set, which is the matrix, TRAINING.
%
%   SAMPLE and TRAINING must have the same number of columns.
%   TRAINING and GROUP must have the same number of rows.
%   CLASS is a vector with the same number of rows as SAMPLE.

%   B.A. Jones 2-05-95
%   Copyright (c) 1993-98 by The MathWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:07 $

[gr,gc] = size(group);
if min(gr,gc) ~= 1
   error('Requires a vector third argument.');
end

if gc ~= 1,
   group = group(:);
   gr = gc;
end

if any(group - round(group)) | any(group) < 1
  error('The third input argument must be positive integers.');
end
maxg = max(group);

[tr,tc] = size(training);
if tr ~= gr,
  error('The number of rows in the second and third input arguments must match.');
end

[sr,sc] = size(sample);
if sc ~= tc
  error('The number of columns in the first and second input arguments must match.');
end

d = zeros(sr,maxg);
for k = 1:maxg
   groupk = training(find(group == k),:);
   d(:,k) = mahal(sample,groupk);
end
[tmp, class] = min(d');
class = class';

# Boost.org math 数学库分析
[项目地址](https://github.com/Ewenwan/math)

## 1. 浮点数处理 Floating Point Utilities  浮点数运算 floating point arithmetic
    a. 浮点数分类 floating point classification (fpclassify, isnan, isinf等),
    b. 符号处理   sign manipulation
    c. 舍入       rounding
    d. 比较       comparison
    e. 计算浮点数之间差异 computing the distance between floating point numbers


## 2. 统计分布 Statistical Distributions
提供一组相当全面的统计分布，可以在其上构建更高级别的统计测试。
    
    中心单变量分布 the central univariate distributions
       连续分布 continuous (正态normal & Fisher) 
       和离散分布 discrete (二项式binomial & 泊松Poisson) distributions
       
## 3. 数学特殊函数 Mathematical Special Functions
目前实现的函数系列是gamma，beta和erf函数以及不完整的gamma和beta函数（每个函数的四个变量）以及这些函数的所有可能的逆，加上digamma，各种阶乘函数，贝塞尔函数，椭圆积分，窦基数（以及它们的双曲线变体），反双曲函数，Legrendre / Laguerre / Hermite多项式以及各种特殊的幂和对数函数。

## 4. 寻根和功能最小化 Root Finding and Function Minimisation
    布伦特方法最小化 Brent's Method
    
## 5. 多项式和有理函数 Polynomials and Rational Functions
用于操纵多项式和有效评估有理数或多项式的工具。

## 6. 插值 Interpolation
通过重心或立方B_spline近似的函数插值。

## 7. 数值积分与微分 Numerical Integration and Differentiation
一套相当全面的积分程序（梯形，Gaus-Legendre，Gaus-Kronrod和双指数）和微分。

## 8. 四元数和八元数 Quaternions and Octonions 
Quaternion和Octonians作为类似于std :: complex的类模板。

# 项目结构 
math/include/boost/math/

> /concepts  /概念/
 
定义RealType类基本功能的原型（请参阅real_concept.hpp）。大多数应用程序将使用double作为RealType（并且尽可能为此类型保留分布的短typedef名称），少数将使用float或long double，但也可以使用更高精度类型，如NTL :: RR，GNU多精度算术库，GNU MPFR库，符合real_concept指定的要求。

> /constants  /常数/

一些高度精确的数学常量的模板化定义（在constants.hpp中）。

> /distributions  /分布/

数学中使用的分布，尤其是统计学：高斯，学生，费舍尔，二项式等

> 规范 策略 /policies/ /政策/

策略框架，用于处理用户请求的行为修改。

> 特殊函数 /special_functions 

数学函数通常被认为是“特殊的”，如beta，cbrt，erf，gamma，lgamma，tgamma ......（其中一些在C ++中指定，C99 / TR1，也许是TR2）。

> /工具/ /tools/ 

函数使用的工具，如评估多项式，连续分数，根查找，精度和限制，以及通过测试。有些人会在此套餐外找到申请。


> 参考文档 boost/math/doc/ 

Quickbook格式的文档源文件处理为html和pdf格式。

> boost/math/example/ /例子/

使用数学函数和分布的示例和演示。

/性能/

性能测试和调优程序。

/测试/

测试文件，在许多.cpp文件中，大多数使用Boost.Test（一些测试数据为.ipp文件，通常使用NTL RR类型生成，具有足够的类型精度，通常用于适用于高达256位有效数字和真实类型的精度）。

/工具/

用于生成测试数据的程序。还更改了NTL发布的包，以提供一些额外的（和重要的）额外功能。


# 参考
[（西瓜书）公式推导解析](https://github.com/Ewenwan/pumpkin-book)

[程序员的数学3册 数学思维 概率论 线代csdn下载](https://download.csdn.net/download/starstars/10216368)

[程序员的数学3册笔记](https://github.com/Ewenwan/book-note/tree/master/books/mathematics)

[latex在线可视化编辑 hostMath](http://www.hostmath.com/)

[Mathpix将截图转换成LaTeX可编辑文本 使用snap安装 sudo snap install mathpix-snipping-tool](https://snapcraft.io/mathpix-snipping-toolhttps://snapcraft.io/mathpix-snipping-tool)

[python 学习线性代数](https://github.com/Ewenwan/Play-with-Linear-Algebra)

[数学家 参考](http://www.mathor.com/portal.php)

[数学计算 - C++数学计算](https://python.ctolib.com/categories/cpp-math.html)

[数学狂想曲（一）——搞笑图片的数学原理, 欧拉公式, 傅里叶变换](http://antkillerfarm.github.io/math/2016/11/26/math.html)

[Statistical learning methods, 统计学习方法，李航](https://github.com/SmirkCao/Lihang)

[微积分 导数 隐函数 极限 积分 泰勒展开](https://github.com/Ewenwan/Algorithm_Interview_Notes-Chinese/blob/master/C-%E6%95%B0%E5%AD%A6/B-%E5%BE%AE%E7%A7%AF%E5%88%86%E7%9A%84%E6%9C%AC%E8%B4%A8.md)


其他：

    05 Feb 2018 » 数学狂想曲（八）——核弹当量问题, Lanchester战争模型, 随机过程
    22 Sep 2017 » 数学狂想曲（七）——函数连续性, 莱洛三角形
    05 Mar 2017 » 数学狂想曲（六）——自相关&互相关&卷积, 闵可夫斯基距离, 马氏距离, 数学的深渊, Gabriel's Horn
    02 Mar 2017 » 数学狂想曲（五）——概率分布（2）
    14 Jan 2017 » 数学狂想曲（四）——软件滤波算法, 玻尔兹曼分布
    25 Dec 2016 » 数学狂想曲（三）——统计杂谈, PID算法, 20世纪10大算法, 矩阵&向量的积
    15 Dec 2016 » 数学狂想曲（二）——拉普拉斯变换, 随机变量的特征函数, 双曲函数和悬链线, 概率分布（1）
    26 Nov 2016 » 数学狂想曲（一）——搞笑图片的数学原理, 欧拉公式, 傅里叶变换

[矩阵求导方法](https://github.com/LynnHo/Matrix-Calculus)

[博客算法参考 ](https://www.cnblogs.com/sddai/category/852185.html)

[国防科学技术大学 计算机控制技术 ](http://www.icourses.cn/web/sword/portal/shareDetails?cId=6563#/course/chapter)

[在线matlab代码学习神器Octave Online](https://octave-online.net/)

[离散数学 树 图 mook](https://www.icourse163.org/course/UESTC-1002268006)

![](https://github.com/Ewenwan/Mathematics/blob/master/pic/numeric.PNG)

[中国图书馆分类法](http://www.ztflh.com/?c=33276)

[视觉SLAM中的数学基础](https://www.cnblogs.com/gaoxiang12/p/5113334.html)

[SLAM中的EKF，UKF，PF原理简介优化方式 ](https://www.cnblogs.com/gaoxiang12/p/5560360.html)

![](https://github.com/Ewenwan/Mathematics/blob/master/pic/func.png)


数学函数拟合： 泰勒展开式拟合 / 正交多项式拟合 https://github.com/chebfun/chebfun



# 感谢支持

![](https://github.com/Ewenwan/EwenWan/blob/master/zf.jpg)



# 数学知识点滴
[数学pdf　微分几何　黎曼几何　群论　流形　随机过程　概率论　图论　拓扑学](http://vdisk.weibo.com/s/qBVN187myezF0)

[概率图模型 pdf 视频 课程 ](http://www.cs.cmu.edu/~epxing/Class/10708-14/lecture.html)

[An Introduction to Conditional Random Fields 条件随机场](https://arxiv.org/pdf/1011.4088.pdf)

[统计之都](https://cosx.org/)

[贝叶斯 博客](https://blog.csdn.net/neu_chenguangq)

[浅谈流形学习](http://blog.pluskid.org/?p=533)

[较好的博客数学知识](https://blog.csdn.net/myarrow/article/list/2)

[Signal Processing 信号处理课程：信号和系统、数字信号处理、估计理论、数据压缩](http://www.ws.binghamton.edu/fowler/)

[RANSAC 维基百科](https://en.wikipedia.org/wiki/Random_sample_consensus)

## 方差 协方差 协方差矩阵 协方差矩阵对角化  矩阵的迹  均方误差  高斯分布
### 方差 分散程度，可以用数学上的方差来表述。
      此处，一个字段的方差可以看做是每个元素与字段均值的差的平方和的均值，即：
      var(a) = 1/n * sum（ai - u）^2
      如果 a的每个元素已经减去其均值（简化处理） 则 var(a) = 1/n * sum(ai'^2)
### [协方差](https://www.zhihu.com/question/20852004/answer/134902061)
      从直观上说，让两个字段尽可能表示更多的原始信息，
      我们是不希望它们之间存在（线性）相关性的，
      因为相关性意味着两个字段不是完全独立，必然存在重复表示的信息。
      Cov(a,b) = 1/n * sum（ai - u）*(bi - v)
      如果两个向量均做了 去均值处理则可以写为（进行零均值化，即减去这一行的均值）
      Cov(a,b) = 1/n * sum（ai' * bi')
      可以看到，在字段均值为0的情况下，两个字段的协方差简洁的表示为其内积除以元素数m。
      当协方差为0时，表示两个字段完全独立。
      为了让协方差为0，我们选择第二个基时只能在与第一个基正交的方向上选择。
      因此最终选择的两个方向一定是正交的。
      
> 协方差是变量间的相关关系  Conv(X,Y)=SUM(E(Xi - EX)(Yi - EY))  两个变量所有时刻点对之间的相关关系 期望 之和，

> 同一时刻你比均值大，我也比均值大，就是正相关；同一时刻你比均值小，我也比均值小，也是正相关；同一时刻一个比均值大，一个比均值小，就是负相关；

> 所有时刻的相关性加和就是两个变量之间的协方差；如果两个变量独立，那么他们之间的协方差为0，同一个变量和自身的协方差，就是方差，就是标准差平方。

### [协方差矩阵](https://zhuanlan.zhihu.com/p/24650651)
> 就是多个变量，两两之间的协方差，排列成的矩阵。

> 例如两个变量之间的协方差矩阵，维度就是 2*2 

> n个变量之间的协方差矩阵，维度就是 n*n

> 例如 独立随机变量 X 和 Y 的均值为0，标准差为1 和 2，则他们的协方差矩阵 为 |1 0; 0 4|

> 再如变量 X1 X2 X3 X4 X5 C=|Conv(X1,X1) Conv(X1,X2) Conv(X1,X3) Conv(X1,X4) Conv(X1,X5);...|

> 如果 X1 , ... ,  Xn 之间独立，则他们的协方差矩阵为 diag(Conv(X1,X1),...,Conv(Xn,Xn))

> 同时如果 X1, ,...,Xn 是多维变量，则他们的协方差矩阵为 diag(C1, ..., Cn)
### 协方差矩阵对角化
      这个矩阵对角线上的两个元素分别是两个字段的方差，
      而其它元素是a和b的协方差。两者被统一到了一个矩阵的。
      我们发现要达到优化目前，等价于将协方差矩阵对角化：
      即除对角线外的其它元素化为0，并且在对角线上将元素按大小从上到下排列，
      这样我们就达到了优化目的。
      这样说可能还不是很明晰，我们进一步看下原矩阵与基变换后矩阵协方差矩阵的关系：
      
      设原始数据矩阵X对应的协方差矩阵为C，而P是一组基按行组成的矩阵，
      设Y=PX，则Y为X对P做基变换后的数据。设Y的协方差矩阵为D，我们推导一下D与C的关系：
      D = 1/m * Y * Y转置
        = 1/m *(PX)*(PX)转置
        = 1/m * PXX转置*P转置
        = P ( 1/m *XX转置)*P转置
        = P * C * P转置
#### PCA降维
      PCA（Principal Component Analysis）是一种常用的数据分析方法。

      PCA通过线性变换将原始数据变换为一组各维度线性无关的表示，

      可用于提取数据的主要特征分量，常用于高维数据的降维。
[PCA降维](http://blog.codinglabs.org/articles/pca-tutorial.html)

[PCA数学原理](http://www.360doc.com/content/13/1124/02/9482_331688889.shtml)

      PCA算法
      总结一下PCA的算法步骤：

      设有m条n维数据。

      1）将原始数据按列组成n行m列矩阵X

      2）将X的每一行（代表一个属性字段）进行零均值化，即减去这一行的均值

      3）求出协方差矩阵C=1/m*X*X转置

      4）求出协方差矩阵的特征值及对应的特征向量(奇异值分解)

      5）将特征向量按对应特征值大小从上到下按行排列成矩阵，取前k行组成矩阵P

      6）Y=PX
      即为降维到k维后的数据        


### 矩阵的迹
矩阵

[后面被误删除了](https://github.com/zxp771/Mathematics/blob/master/README.md)

## 整数线性规划求解工具
[Integer Set Library](http://isl.gforge.inria.fr/)

### 编译

    ISL,Integer Set Library
    版本0.22.1，http://isl.gforge.inria.fr/
    README关于编译的部分说了
    ./configure
    make
    make install
    使用./configure --help阅读后针对本地环境，使用
    ./configure --prefix=/opt/isl --enable-shared=yes --enable-static=yes \
    CC=/opt/gcc/bin/gcc \
    CFLAGS="-O3 -I/opt/gmp/include" \
    LDFLAGS="-L/opt/gmp/lib -Wl,--rpath=/opt/gmp/lib" \
    CXX=/opt/gcc-10.2.0/bin/g++ \
    CXXFLAGS="-I/opt/gmp/include" \
    PYTHON=/opt/python3/bin/python3 \
    --enable-fast-install=no --with-gnu-ld
    make
    make install

[islpy python接口](https://github.com/inducer/islpy)

 

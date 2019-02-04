# latex 用法

## 安装
      注意!
      ▶ 不能放在带有中文的路径中
      离线安装镜像 (约 ѲGB 大小)
      ▶ https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/texlive.iso
      在线安装包（和相应的校验文件，以.shaѱѴ6 结尾）
      ▶ https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/
      ▶ 更多可见 http://mirror.ctan.org/README.mirrors
      可选步骤：校验安装包
      LANG=C sha256sum --check install -tl-unx.tar.gz.sha256
      install -tl-unx.tar.gz: OK
      
      Windows
      ▶ 双击下载的安装程序
      ▶ 切换默认仓库为国内镜像：加速网络下载
      Windows 上安装过程比较慢，尤其是最后的生成索引阶段，请耐心等待
      
      Mac OS X
      ▶ https://mirrors.tuna.tsinghua.edu.cn/
      CTAN/systems/mac/mactex/MacTeX.pkg
      
      Linux
      ▶ 图形安装界面需要 Perl Tk 模块：
      yum install perl-Tk 或 apt-get install perl-tk
      sudo mkdir /usr/local/texlive
      sudo chown yourname:yourname /usr/local/texlive
      ./install -tl -gui -repository \
      https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet/
      
      网络安装后配置（仅 Linux）
      
      添加环境变量到 ~/.bash_profile 文件：
      export PATH=/usr/local/texlive/2018/bin/x86_64 -linux:$PATH
      export MANPATH=/usr/local/texlive/2018/texmf/doc/man:$MANPATH
      export INFOPATH=/usr/local/texlive/2018/texmf/doc/info:$INFOPATH
      
      打开 TEX Live 指南中文版 “texlive-zh-cn.pdf”，关注第 Ѳ.ѳ 节
      texdoc texlive -zh
      
      X TEEX 系统字体配置
      cp /usr/local/texlive/2018/texmf -var/fonts/conf/texlive -fontconfig.
      conf \
      /etc/fonts/conf.d/09-texlive.conf
      fc-cache -fsv
      
      让系统的包管理器知道 TeX Live 已经装过了，所以安装一个 dummy package
      
      ▶ Arch Linux 用户装 AUR 里的 texlive-dummy
      ▶ Debian/Ubuntu 用户参照手册做一个包即可
      https://www.tug.org/texlive/debian.html#vanilla
      
      ▶ Feodra 用户可以在
      https://copr.fedoraproject.org/coprs/fatka/texlive-dummy/ 下载
      教程可参考: http://zhuanlan.zhihu.com/LaTeX/20069414
      
      编辑器配置
      TEX 编辑器
      ▶ 专用编辑器：TeXworks、TeXStudio、TeXmaker、WinEdt 等
      ▶ 通用编辑器（加 LaTeX 插件）：Vim、Emacs、VS Code、Sublime、Atom 等
      TeXStudio 配置
      Options -> Configure TeXstudio
      ▶ Build：Default Compiler 选择 XeLaTeX
      ▶ 搜索框输入 Line Number -> Adv. Editor -> 打开行号

      使用在线协作平台
      通过在线平台编辑、编译
      ▶ OverLeaf, ShareLaTeX（已经与前者合并）
      免去安装/升级等一系列烦恼
      可以多人协作
      支持中文，但有时需要自己上传字体
      ▶ OverLeaf 可直接使用 ctex 宏集和 thuthesis 文档模板，国内体验较好
      容量有一定限制

      后期安装宏包
      很多时候需要自己安装宏包
      发行版没有预装
      宏包需要更新
      TEX Live
      开始菜单里找 Tex Live Manager
      设置仓库地址 tlmgr option repository
      https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
      使用 tlmgr install <pkgname> 命令
      CTEX 或 MiKTEX
      开始菜单里找 CTeX / MiKTeX -> Package Manager
      在 WinEdt 里 MiKTex Options -> Packages
      
安装后测试

编辑 hello.tex（Windows 下不要用中文文件名；注意 LATEX 文档对大小写敏感。）

```tex
\documentclass{ctexart} % 使 用 ctex 适 配 过 的 article 文
档 类
\begin{document}
\TeX{}你 好！
\end{document}
▶ Windows 下缺省使用中易字体
▶ Linux、Mac OS X 下需要注意字体（参见 ctex 文档）
使用 XeLaTeX 引擎编译，得到 PDF 文档
      
```
 
## 用法
### 文件结构
```tex

\documentclass[a4paper]{article}
% 文档类型， 如 article，[]内是选项， 比如 a4paper 设置为A4纸

% 这里开始是导言区
\usepackage{graphicx} % 引用宏包
\graphicspath{{fig/}} % 设置图片目录
% 导言区到此 止

\begin{document}
%==============
% 这 里 开 始 是 正 文
% ...
%==============
\end{document}

```
## LATEX 命令 宏 (Macro)、或者控制序列 (control sequence)

简单命令
```tex
▶ \命令 {\songti 中国人民解放军} ⇒ 中国人民解放军
▶ \命令[可选参数]{必选参数}
\section[精简标题]{这个题目实在太长了放到目录里面不太好看}
⇒ 1.1 这个题目实在太长了放到目录里面不太好看
```
环境
```tex
\begin{equation*}
a^2-b^2=(a+b)(a-b)
\end{equation*}
```
a^2-b^2=(a+b)(a-b)

### LATEX 常用命令

命令

      \chapter  \section  \subsection \paragraph
       章         节        小节         带题头段落

      \centering   \emph  \verb    \url
      居中对齐      强调   原样输出  超链接

      \footnote   \item    \caption   \includegraphics
      脚注        列表条目   标题 插    入图片

      \label    \cite        \ref
      标号      引用参考文献 引用图表公式等
      

```tex
\chapter{前言}
⇒ 第1章 前言
\section[精简标题]{这个题目实在太长了放到目录里面不太好看}
⇒ 1.1 这个题目实在太长了放到目录里面不太好看
\footnote{我是可爱的脚注}
⇒ 前方高能1

1我是可爱的脚注

```

环境

      table   figure   equation
      表格     图片    公式
      itemize     enumerate   description
      无编号列表    编号列表    描述


列举

```tex
\begin{itemize}     % itemize无编号列表
  \item 一 条
  \item 次 条
  \item 这 一 条 可 以 分 为 ...
    \begin{itemize}
       \item 子 一 条
    \end{itemize}
  \end{itemize}

一条
次条
这一条可以分为...
  ▶ 子一条


\begin{enumerate}  % enumerate带有标号 枚举 索引  编号列表
  \item 一 条
  \item 次 条
  \item 再 条
\end{enumerate}
1 一条
2 次条
3 再条

```

> 数学公式

```tex
% 第一种===  用单个美元符号 ($) 包围起来的，本行内公式
$V = \frac{4}{3}\pi r^3$   % V = 4/3 * pi * r^3

% 第二种=== 用两个美元符号 ($$) 或\[ \] 包围起来的是单行公式 或行间公式
\[
V = \frac{4}{3}\pi r^3   
\]

% 第三种===
\begin{equation} 
\label{eq:vsphere}
V = \frac{4}{3}\pi r^3 
\end{equation}

%  使用数学环境，例如 equation 环境内的公式会自动加上编号，
% align 环境用于多行公式 (例如方程组)
% 运行 texdoc symbols 查看符号表
% MathType 也可以使用和导出 LATEX 公式

```

> 层次与目录生成

```tex
\tableofcontents % 这 里 是 目 录
\part{有 监 督 学 习}
\chapter{支 持 向 量 机}
\section{支 持 向 量 机 简 介}
\subsection{支 持 向 量 机 的 历 史}
\subsubsection{支 持 向 量 机 的 诞 生}
\paragraph{一 些 趣 闻}
\subparagraph{第 一 个 趣 闻}

第一部分 有监督学习
第一章 支持向量机
1. 支持向量机简介
1.1 支持向量机的历史
1.1.1 支持向量机的诞生
一些趣闻
第一个趣闻

```

> 列表与枚举
```tex
\begin{enumerate}               % enumerate带有标号 枚举 索引  编号列表===
\item \LaTeX{} 好处都有啥
  \begin{description}                  % 带描述开头====
    \item[好 用] 体验好才是真的好  
    \item[好 看] 强迫症的福音
    \item[开 源] 众人拾柴火焰高
  \end{description}
\item 还有呢?
  \begin{itemize}   % itemize无编号列表===
    \item 好处 1
    \item 好处 2
  \end{itemize}
\end{enumerate}


1 LATEX 好处都有啥
  好用 体验好才是真的好
  好看 治疗强迫症
  开源 众人拾柴火焰高
2 还有呢?
  ▶ 好处 1
  ▶ 好处 2

```




# 添加参考文献
    在Google scholar中搜索指定文献，点击引用中的BibTex，复制内容粘贴到egbib.tex中
    在文章中输入\cite{} ，选择并确定
# 图片
    1、插入图片 
    图片插入前的工作：用Visio画好图，转成PDF格式，再用专业版的PDF剪切去白边 
    *注：用Visio是因为可以画矢量图（用PPT画好像也可以），用专业版PDF剪切是可以去背景。 
    latex中插入图片的语句如下：

    \begin{figure} %这样的话显示在图片是在双栏中的一侧；如果图片很大想跨栏的话，应该用\begin{figure*}
    \begin{center} %控制图片居中
    \fbox{ %如果不想要图像的边框，可以把fbox去掉
    \includegraphics[height=5cm]{需要插入的图片的名称}
    }
    \end{center}
    \caption{图注}
    \label{fig:xx} %也是之后需要引用该图片时的索引
    \end{figure} %或对应\end{figure*}

# 公式太长溢出
    双栏写作中，稍微长一点的公式就会跑到页面外面去，因此需要换行并对齐，语句如下：

    \begin{equation}
    \begin{aligned} %加了这个才可以控制对齐
     L^{stu}
    &=\sum_{i=1}^N L\left(x_i,y_i,\Theta^{stu}\right)\\ %'\\'是用来控制换行
    &=-\sum_{i=1}^N\sum_{j=1}^C q_j log\left(p_j\right) %两行在'&'处对齐
    \end{aligned}
    \label{L^stu}
    \end{equation}

# 表格
    1、某个格内文字太多，需要换行：\makecell{...}，同时需要在前面导入包：\usepackage{makecell} 
    2、例子：

    \begin{table}
    \begin{center}
    \begin{tabular}{|c|c|c|c|} %'c'表示文字居中，每一个竖线'|'表示画边框
    \hline %画横线
    Network & \makecell{Accuracy\\(\%)}\\
    \hline
    \hline
    NIN & 3.7 & \textbf{89.59} & / \\
    \hline
    \end{tabular}
    \end{center}
    \caption{注释bulabula}
    \label{table:xxx}
    \end{table}

    3、在表格中需要打印大于号（’>’）：导入包\usepackage[T1]{fontenc}

# 修改字号
    Latex 设置字体大小命令由小到大依次为：

    \tiny
    \scriptsize
    \footnotesize
    \small
    \normalsize
    \large
    \Large
    \LARGE
    \huge
    \Huge

# 例如调整表格里的字号：

    \begin{table}
    \small %修改表格里的字号为small类型
    \begin{center}
    \begin{tabular}{|c|c|c|c|}

    \end{tabular}
    \end{center}
    \caption{}
    \label{table}
    \end{table}

# 添加罗马数字
    大写罗马数字：

    \uppercase\expandafter{\romannumeral1}

    小写罗马数字：

    \romannumeral20

# 添加页码
    在 LATEX 中，页眉和页脚的样式是由命令 \pagestyle 和 \pagenumbering 来定义的。
    \pagestyle命令定义了页眉和页脚的基本内容（如页码出现在哪里），
    而 \pagenumbering则定义了页码的显示方式。 

    \pagestyle{option}可选参数：

    empty       没有页眉也没有页脚
    plain       没有页眉，页脚包含一个居中的页码
    headings    没有页脚，页眉包含章/节或者子节的名字和页码
    myheadings  没有页脚，页眉包含有页码和用户提供的其他信息

    \pagenumbering{numstyle}可选参数：

    arabic   阿拉伯数字
    roman   小写的罗马数字
    Roman   大写的罗马数字
    alph    小写字母
    Alph    大写字母

# 花写字体
    需要导入包：\usepackage{amssymb} 
    \mathbb{N}: N
    最后的一个小注释
    参考文献引用：\cite{xxx} 
    公式、图片、表格等引用：\ref{xxx}

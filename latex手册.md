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

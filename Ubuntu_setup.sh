#新系统环境设置
#/etc/apt/sources.list，更换软件源
<<BLOCK
cp    -f     /etc/apt/sources.list         /etc/apt/sources.list_backup
echo '
#  阿里源
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
'         >             /etc/apt/sources.list
BLOCK
#新系统更新软件
apt   update
apt   install           -y   --fix-broken
apt   full-upgrade      -y
apt   install           -y                 wget curl net-tools gcc make perl zip unzip vim axel fcitx daemon python3-gpg ffmpeg steam-installer
apt   install           -y                 qbittorrent libavcodec-extra hardinfo  ttf-mscorefonts-installer  ubuntu-restricted-extras
apt   autoremove        -y

#空格的正则表达式为"\ "
#设定网络容忍度
sed    -i    "s/lcp-echo-failure\ 4/lcp-echo-failure\ 15/g"       /etc/ppp/options
#禁用wifi电源节省管理
sed    -i    "s/wifi.powersave\ =\ 3/wifi.powersave\ =\ 2/g"       /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
#删除dhcp服务器ipv6功能
sed    -i    "s/dhcp6.name-servers,\ dhcp6.domain-search,\ dhcp6.fqdn,\ dhcp6.sntp-servers,//g"      /etc/dhcp/dhclient.conf
#禁用ipv6
echo   "net.ipv6.conf.all.disable_ipv6 = 1"            >>   /etc/sysctl.conf
echo   "net.ipv6.conf.default.disable_ipv6 = 1"        >>   /etc/sysctl.conf
echo   "net.ipv6.conf.lo.disable_ipv6 = 1"             >>   /etc/sysctl.conf
sysctl -p

#修改swap分区大小 
free -h
#创建一个新的12G的swap文件
cd /
dd if=/dev/zero of=/myexchange bs=1G count=12
#创建swap文件系统
mkswap -f myexchange
chmod 0600 myexchange
#开启新的swap
swapoff /swapfile
swapon /myexchange
#设置开机启动
sed -i     "s/swapfile/myexchange/g"       /etc/fstab
#删掉旧的swap文件
rm -f /swapfile
free -h

#卸载tint和自带输入法
pkill    tint2   &&   apt   purge   tint2
apt   remove     -y  ibus
#安装谷歌输入法
apt   install    -y  fcitx-bin fcitx-table  fcitx-googlepinyin
#重新启动以应用设置





#安装R studio
apt install -y r-base libjpeg62
#到此网址查询Rstudio最新版本 https://rstudio.com/products/rstudio/download/
wget     -c      https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5042-amd64.deb    -P      /home/downloads/
dpkg     -i      /home/downloads/rstudio*.deb




#安装Finalshell
rm -f finalshell_install_linux.sh
wget   -c   www.hostbuf.com/downloads/finalshell_install_linux.sh            
chmod +x finalshell_install_linux.sh
./finalshell_install_linux.sh




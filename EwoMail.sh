# EwoMail 安装脚本 @ CentOS 7
site=hanhongju.com
#关闭Selinux
sed       -i       ''s/SELINUX\=.*/SELINUX\=disabled/g''        /etc/sysconfig/selinux
#添加SWAP缓存空间
if        [[   $(free  -m  |  awk   'NR==3{print $2}'   2>&1)    >   3000   ]]
then      echo   ''已经有SWAP，无需重复配置''
else      echo   ''添加SWAP空间，大小4000M''
          dd       if=/dev/zero of=/mnt/swap bs=1M count=4000
          mkswap   /mnt/swap
          swapon   /mnt/swap
          echo    '/mnt/swap swap swap defaults 0 0'      >>       /etc/fstab
fi
#安装EwoMail
yum         -y         install   git
apt         -y         install   git
cd          /root/
git         clone      https://github.com/gyxuehu/EwoMail.git
tar         -Pcf       /root/EwoMail.tar     /root/EwoMail
#tar        -Pxf       /root/EwoMail.tar
sed         -i         ''s/yum\ install\ epel-release.*/yum\ install\ epel-release\ \-y/g''     /root/EwoMail/install/start.sh
#设定脚本工作目录，不要更改否则会出现安装失败
cd          /root/EwoMail/install/
bash        start.sh    $site
#安装后的常规配置

sed         -i          ''s/listen.*/listen\ 80\;/g''           /ewomail/nginx/conf/vhost/rainloop.conf
sed         -i          ''s/listen.*/listen\ 8010\;/g''         /ewomail/nginx/conf/vhost/ewomail-admin.conf
sed         -i          ''/clamd/d''                            /usr/lib/systemd/system/amavisd.service
sed         -i          ''/bypass_virus/d''                     /etc/amavisd/amavisd.conf
sed         -i          ''/bypass_spam/d''                      /etc/amavisd/amavisd.conf
echo        '@bypass_virus_checks_maps = (1);@bypass_spam_checks_maps  = (1);'           >>          /etc/amavisd/amavisd.conf
sed         -i          ''/$site/d''                            /etc/hosts
echo        ''127.0.0.1 mail.$site smtp.$site imap.$site''                               >>          /etc/hosts
#重启服务
systemctl   daemon-reload
systemctl   stop        clamd@amavisd
systemctl   disable     clamd@amavisd
systemctl   restart     postfix dovecot nginx amavisd
ss          -plnt   |   awk 'NR>1 {print $4,$6}'   |   column   -t
echo        "后台管理端口为8010，账户为admin，密码为ewomail123。"






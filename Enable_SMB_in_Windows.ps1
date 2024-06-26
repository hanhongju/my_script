#打开网络连接；查看网络属性；勾选“Microsoft 网络的文件和打印机共享”
#使用管理员权限的powershell运行以下代码
#将当前网络改为专有网络
Set-NetConnectionProfile         -Name  (Get-NetConnectionProfile).Name        -NetworkCategory  Private
#SMBv1存在重大安全漏洞，强烈建议不要使用它。
Get-SmbServerConfiguration   |   Select  EnableSMB1Protocol, EnableSMB2Protocol
#在SMB服务器上启用SMBv2和SMBv3，因为SMBv2和SMBv3共用一个栈，所以在启用或禁用 SMBv2时，也会启用或禁用SMBv3。
Set-SmbServerConfiguration       -EnableSMB2Protocol  $true          -Force
#客户端主机开启SMB大型MTU支持提升文件传输效率，并禁用带宽限制。
Set-SmbClientConfiguration       -EnableBandwidthThrottling  0       -EnableLargeMtu  1      -Force
#计算机配置--windows设置--安全设置--本地策略--安全选项	       帐户：来宾帐户状态	                            设置为：已启用
net    user    guest             /active:yes
#计算机配置--windows设置--安全设置--本地策略--安全选项	       帐户：使用空密码的本地帐户只允许进行控制台登录	    设置为：已禁用
Set-ItemProperty     -Path  "HKLM:\SYSTEM\ControlSet001\Control\Lsa"  LimitBlankPasswordUse       -Force      -Type  DWord       -Value 0
#计算机配置--windows设置--安全设置--本地策略--用户权限分配	     拒绝从网络访问这台计算机	                      删除“Guest”账号
secedit       /export            /cfg           security.inf
(Get-Content security.inf)       -replace      "SeDenyNetworkLogonRight.*" , "SeDenyNetworkLogonRight =" | Set-Content "security.inf"
secedit       /configure         /cfg           security.inf         /db        security.sdb




#开启文件共享（SMB）和打印机共享

New-Item          -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"  -Force
Set-ItemProperty  -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"  -Name Model  -Type String  -Value "A Property of Hanhongju"
Remove-Item       -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"  -Recurse  -ErrorAction SilentlyContinue





# 修改系统设置-关于-设备规格下面的一行字，这是系统OEM信息

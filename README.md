# bootable_usb_winpe
Run：
把bootable_usb_winpe_builder.bat以及Tools文件夹提取到${install_path}\Tools\PETools目录下，运行bootable_usb_winpe_builder.bat即可。
Note：
1、系统要求为64位的Windows 7，需要提前安装好Windows AIK（Windows 8级以上则为ADK，相应的命令亦有改变），英文全称：Windows Automated Installation Kit。
2、Tools目录下存放的是WinPE里用户自定义的工具，项目里提供的是64位的ghost以及磁盘分区工具。
3、暂时不支持多U盘识别，使用时需小心。

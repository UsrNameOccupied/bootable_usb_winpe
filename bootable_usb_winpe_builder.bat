@echo on

:: 创建WinPE
set winpe_dir=D:\WinPE_64
set work_dir="%cd%"

rmdir /s /q %winpe_dir%
call "%cd%"\copype amd64 %winpe_dir%

:: 重新回到工作目录
cd %work_dir%

set err_code=%errorlevel%

if "%err_code%"=="1" (
  echo "please install Windows Automated Installation Kit(Windows 7)."
  pause
  exit
)

Dism /Mount-Wim /WimFile:%winpe_dir%\winpe.wim /index:1 /MountDir:%winpe_dir%\mount
Dism /image:%winpe_dir%\mount /Add-Package /PackagePath:"%cd%\amd64\WinPE_FPs\WinPE-HTA.cab"
Dism /image:%winpe_dir%\mount /Add-Package /PackagePath:"%cd%\amd64\WinPE_FPs\winpe-fontsupport-zh-cn.cab"
Dism /image:%winpe_dir%\mount /Add-Package /PackagePath:"%cd%\amd64\WinPE_FPs\winpe-mdac.cab"
Dism /image:%winpe_dir%\mount /Add-Package /PackagePath:"%cd%\amd64\WinPE_FPs\winpe-scripting.cab"
Dism /image:%winpe_dir%\mount /Add-Package /PackagePath:"%cd%\amd64\WinPE_FPs\winpe-wmi.cab"

copy "%cd%\Tools\*"  %winpe_dir%\mount\Windows\System32\

Dism /Unmount-Wim /MountDir:%winpe_dir%\mount /Commit

copy %winpe_dir%\winpe.wim %winpe_dir%\ISO\sources\boot.wim

:: 获取U盘的序号，以便diskpart使用
for /f "tokens=2 delims==" %%a in ('wmic DiskDrive where "MediaType='Removable Media' and Model='USB Device'" get Index /value') do (
  set DriveU=%%a
)

if "%DriveU%"==""  (
  echo "please insert usb disk."
  pause
  exit
)

:: 生成格式化指令
set diskpart_cmds=diskpart.txt
echo,select disk %DriveU% > %diskpart_cmds%
echo,clean >> %diskpart_cmds%
echo,create partition primary >> %diskpart_cmds%
echo,select partition 1 >> %diskpart_cmds%
echo,active >> %diskpart_cmds%
echo,format fs=fat32 quick >> %diskpart_cmds%
echo,exit >> %diskpart_cmds%

:: 格式化U盘
diskpart /s diskpart.txt

:: 获取U盘的盘符
for /f "tokens=2 delims==" %%a in ('wmic LogicalDisk where "DriveType='2'" get DeviceID /value') do (
  set DriverSym=%%a
)

echo,%DriverSym%

:: 把PE拷贝到U盘
xcopy /s %winpe_dir%\ISO\* %DriverSym%

pause
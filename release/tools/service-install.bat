@echo off

:::::

:: �ݒ�t�@�C����ǂݍ���
for /f "usebackq tokens=1,* delims==" %%a in (..\bin\env) do (
    set %%a=%%b
)

:::::

:input
set INPUT=
set /P INPUT="�T�[�r�X�o�^�������J�n���܂����H(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo �����𒆒f���܂��B
  exit 0
)

:: �T�[�r�X�o�^
rem sc.exe create %APP_NAME% binPath= "C:\%APP_NAME%\bin\start.bat" start= auto
nssm install %APP_NAME%

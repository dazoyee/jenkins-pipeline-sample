@echo off

:::::

:: �ݒ�t�@�C����ǂݍ���
for /f "usebackq tokens=1,* delims==" %%a in (""C:\jenkins-pipeline-sample\bin\env"") do (
    set %%a=%%b
)

:::::

:input
set INPUT=
set /P INPUT="�T�[�r�X���N�����܂����H(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo �����𒆒f���܂��B
  exit 0
)

:: �T�[�r�X�N��
sc.exe start %APP_NAME%

@echo off

:input
set INPUT=
set /P INPUT="�T�[�r�X���~���܂����H(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo �����𒆒f���܂��B
  exit 0
)

:: �T�[�r�X�ċN��
sc.exe stop jenkins-pipeline-sample
:DoWhile
  sc.exe query jenkins-pipeline-sample | findstr STATE | findstr STOPPED
  if %errorlevel% equ 0 goto DoWhileExit
goto DoWhile
:DoWhileExit
sc.exe start jenkins-pipeline-sample

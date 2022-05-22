@echo off

:input
set INPUT=
set /P INPUT="サービスを停止しますか？(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo 処理を中断します。
  exit 0
)

:: サービス再起動
sc.exe stop jenkins-pipeline-sample
:DoWhile
  sc.exe query jenkins-pipeline-sample | findstr STATE | findstr STOPPED
  if %errorlevel% equ 0 goto DoWhileExit
goto DoWhile
:DoWhileExit
sc.exe start jenkins-pipeline-sample

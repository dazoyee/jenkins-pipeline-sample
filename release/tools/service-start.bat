@echo off

:input
set INPUT=
set /P INPUT="サービスを起動しますか？(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo 処理を中断します。
  exit 0
)

:: サービス起動
sc.exe start jenkins-pipeline-sample

@echo off

:::::

:: 設定ファイルを読み込む
for /f "usebackq tokens=1,* delims==" %%a in (""C:\jenkins-pipeline-sample\bin\env"") do (
    set %%a=%%b
)

:::::

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

:: サービス停止
sc.exe stop %APP_NAME%

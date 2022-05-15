@echo off

:::::

:: 設定ファイルを読み込む
for /f "usebackq tokens=1,* delims==" %%a in (""C:\jenkins-pipeline-sample\bin\env"") do (
    set %%a=%%b
)

:::::

:input
set INPUT=
set /P INPUT="サービス削除処理を開始しますか？(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo 処理を中断します。
  exit 0
)

:: サービス登録
rem sc.exe delete %APP_NAME%
nssm remove %APP_NAME%

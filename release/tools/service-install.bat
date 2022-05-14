@echo off

:::::

:: 設定ファイルを読み込む
for /f "usebackq tokens=1,* delims==" %%a in (..\bin\env) do (
    set %%a=%%b
)

:::::

:input
set INPUT=
set /P INPUT="サービス登録処理を開始しますか？(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo 処理を中断します。
  exit 0
)

:: サービス登録
rem sc.exe create %APP_NAME% binPath= "C:\%APP_NAME%\bin\start.bat" start= auto
nssm install %APP_NAME%

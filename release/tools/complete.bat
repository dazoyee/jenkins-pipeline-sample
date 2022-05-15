@echo off

:: 遅延環境変数
setlocal EnableDelayedExpansion

:: 設定ファイルを読み込む
for /f "usebackq tokens=1,* delims==" %%a in ("C:\jenkins-pipeline-sample\bin\env") do (
    set %%a=%%b
    echo %%a=%%b
)

:: バリデーションチェック
if not exist "C:\jenkins-pipeline-sample\bin\env" (
  echo "C:\jenkins-pipeline-sample\bin\env"ファイルが存在しません。
  exit 1
)
if not exist "%APP_HOME%\tmp\latest" (
  echo "%APP_HOME%\tmp\latest"ディレクトリが存在しません。
  exit 1
)
if not exist "%APP_HOME%\tmp\now" (
  echo "%APP_HOME%\tmp\now"ディレクトリが存在しません。
  exit 1
)

::::: アプリバージョンの取得 start

if exist "%APP_HOME%\tmp" (
  call :get_len %APP_NAME% & set APP_NAME_LEN=!length!
  for %%f in ("%APP_HOME%\tmp\latest\%APP_NAME%-*.jar") do (
  set JAR_NAME=%%~nf
  call :get_ver & set LATEST_VERSION=!ver!
  )
  for %%f in ("%APP_HOME%\tmp\now\%APP_NAME%-*.jar") do (
  set JAR_NAME=%%~nf
  call :get_ver & set NOW_VERSION=!ver!
  )
) else (
  echo 対象の最新JARファイルを取得できませんでした。
  exit 1
)

ping -n 1 localhost > nul
if %LATEST_VERSION% == %NOW_VERSION% (
  echo アプリバージョンが重複しているため、処理を中止しました。
  exit 1
)

::::: アプリバージョンの取得 end
::::: JARの後片付け start

copy "%APP_HOME%\tmp\now\%APP_NAME%-%NOW_VERSION%.jar" "%APP_HOME%\bin\bk"

::::: JARの後片付け end

exit /b

:::::subroutine start

:get_len
set targetStr=%~1
set length=0

:loop
if not "%targetStr%"=="" (
  set targetStr=%targetStr:~1%
  set /a length=%length%+1
  goto :loop
)
exit /b

:::::subroutine end
:::::subroutine start

:get_ver
set /a n=%APP_NAME_LEN%+1
call set ver=%%JAR_NAME:~%n%%%

exit /b

:::::subroutine end

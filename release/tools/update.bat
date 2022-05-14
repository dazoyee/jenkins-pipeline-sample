@echo off

:: 遅延環境変数
setlocal EnableDelayedExpansion

:: 設定ファイルを読み込む
for /f "usebackq tokens=1,* delims==" %%a in (..\bin\env) do (
    set %%a=%%b
    echo %%a=%%b
)

::::: サービス停止 start

sc.exe stop %APP_NAME%
sleep 5
sc.exe query %APP_NAME% | findstr STATE | findstr STOPPED
if not %errorlevel% equ 0 (
  echo *****サービス停止に失敗しました。*****
  exit 1
)
::::: サービス停止 end
::::: アプリバージョンの取得 start

if exist "%APP_HOME%\tmp" (
  for %%f in ("%APP_HOME%\tmp\%APP_NAME%-*.jar") do (
  set JAR_NAME=%%~nf
  call :get_len %APP_NAME% & set APP_NAME_LEN=!length!
  call :get_ver & set LATEST_VERSION=!ver!
  )
  for %%f in ("%APP_HOME%\bin\%APP_NAME%-*.jar") do (
  set JAR_NAME=%%~nf
  call :get_len %APP_NAME% & set APP_NAME_LEN=!length!
  call :get_ver & set NOW_VERSION=!ver!
  )
) else (
  echo 対象の最新JARファイルを取得できませんでした。
  exit 1
)

if %LATEST_VERSION% == %NOW_VERSION% (
  echo アプリバージョンが重複しているため、処理を中止しました。
  exit 1
)

::::: アプリバージョンの取得 end
::::: アプリバージョンの書き換え start

set ENV=%APP_HOME%\bin\env

ren %ENV% env.tmp
for /f "delims=" %%e in (%ENV%.tmp) do (
  set line=%%e
  set target=!line:~0,11!
  if !target! == APP_VERSION (
    echo APP_VERSION=%LATEST_VERSION%>>%ENV%
  ) else (
    echo !line!>>%ENV%
  )
)
del %ENV%.tmp

::::: アプリバージョンの書き換え end
::::: JARの差し替え start

copy "%APP_HOME%\tmp\%APP_NAME%-%LATEST_VERSION%.jar" "%APP_HOME%\bin"
if not exist "%APP_HOME%\bin\bk" (
  mkdir "%APP_HOME%\bin\bk"
)
move "%APP_HOME%\bin\%APP_NAME%-%NOW_VERSION%.jar" "%APP_HOME%\bin\bk"

::::: JARの差し替え end
::::: サービス起動 start

sc.exe start %APP_NAME%
sleep 10
sc.exe query %APP_NAME% | findstr STATE | findstr RUNNING
if not %errorlevel% equ 0 (
  echo *****サービス起動に失敗しました。*****
  exit 1
)

::::: サービス起動 end

endlocal

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

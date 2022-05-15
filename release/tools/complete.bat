@echo off

:: �x�����ϐ�
setlocal EnableDelayedExpansion

:: �ݒ�t�@�C����ǂݍ���
for /f "usebackq tokens=1,* delims==" %%a in ("C:\jenkins-pipeline-sample\bin\env") do (
    set %%a=%%b
    echo %%a=%%b
)

:: �o���f�[�V�����`�F�b�N
if not exist "C:\jenkins-pipeline-sample\bin\env" (
  echo "C:\jenkins-pipeline-sample\bin\env"�t�@�C�������݂��܂���B
  exit 1
)
if not exist "%APP_HOME%\tmp\latest" (
  echo "%APP_HOME%\tmp\latest"�f�B���N�g�������݂��܂���B
  exit 1
)
if not exist "%APP_HOME%\tmp\now" (
  echo "%APP_HOME%\tmp\now"�f�B���N�g�������݂��܂���B
  exit 1
)

::::: �A�v���o�[�W�����̎擾 start

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
  echo �Ώۂ̍ŐVJAR�t�@�C�����擾�ł��܂���ł����B
  exit 1
)

ping -n 1 localhost > nul
if %LATEST_VERSION% == %NOW_VERSION% (
  echo �A�v���o�[�W�������d�����Ă��邽�߁A�����𒆎~���܂����B
  exit 1
)

::::: �A�v���o�[�W�����̎擾 end
::::: JAR�̌�Еt�� start

copy "%APP_HOME%\tmp\now\%APP_NAME%-%NOW_VERSION%.jar" "%APP_HOME%\bin\bk"

::::: JAR�̌�Еt�� end

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

@echo off

:::::

:: İ’èƒtƒ@ƒCƒ‹‚ğ“Ç‚İ‚Ş
for /f "usebackq tokens=1,* delims==" %%a in ("env") do (
    set %%a=%%b
)

rem APP_HOME=
rem APP_NAME=
rem APP_VERSION=

:::::

java^
    -Xms256m  ^
    -Xmx256m  ^
    -Dspring.config.location=..\config\application.yml  ^
    -jar %APP_NAME%-%APP_VERSION%.jar

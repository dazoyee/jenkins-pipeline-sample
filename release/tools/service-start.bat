@echo off

:input
set INPUT=
set /P INPUT="�T�[�r�X���N�����܂����H(n/Y):
if not defined INPUT (
  goto input
)
if not %INPUT% == Y (
  echo �����𒆒f���܂��B
  exit 0
)

:: �T�[�r�X�N��
sc.exe start jenkins-pipeline-sample

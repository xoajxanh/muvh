@echo off
chcp 65001 >nul
color 0B
title MU Auto Register Tool (Proxy)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0excute_test\reg_with_proxy.ps1"
pause

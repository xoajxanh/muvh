@echo off
chcp 65001 > nul
color 0A
title MU VIP Mod Builder
powershell -ExecutionPolicy Bypass -File "%~dp0build_and_update.ps1"
pause

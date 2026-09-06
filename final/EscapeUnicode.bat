@echo off
chcp 65001 >nul
powershell -ExecutionPolicy Bypass -File "%~dp0escape_unicode.ps1"
pause

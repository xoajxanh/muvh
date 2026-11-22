@echo off
chcp 65001 >nul
title [TIEN ICH] Nap script test vao gia lap duoc chon
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0NAP_SCRIPT.ps1"

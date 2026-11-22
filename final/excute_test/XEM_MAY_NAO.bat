@echo off
chcp 65001 >nul
title [TIEN ICH] Xem cua so gia lap nao ung voi serial nao
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0XEM_MAY_NAO.ps1"

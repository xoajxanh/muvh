@echo off
chcp 65001 >nul
title [FARM KC] Lay log tu may ao
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0LAY_LOG.ps1"

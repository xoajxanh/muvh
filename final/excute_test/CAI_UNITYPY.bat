@echo off
chcp 65001 >nul
title [BUILD] Cai UnityPy cho buoc dong goi lua.mu2
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0CAI_UNITYPY.ps1"

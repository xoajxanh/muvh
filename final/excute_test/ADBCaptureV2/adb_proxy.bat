@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Quan ly Proxy ADB cho Gia lap Android

:: Mac dinh thiet bi la emulator-5554 (co the doi trong menu)
set DEVICE=emulator-5554

:MENU
cls
echo ====================================================
echo          QUAN LY PROXY ADB - GIA LAP ANDROID
echo ====================================================
echo  Thiet bi dang chon : %DEVICE%
echo ====================================================
echo  1. Xem danh sach thiet bi (adb devices)
echo  2. Chon / Doi thiet bi thao tac (nhap so thu tu)
echo  3. Xem Proxy hien tai cua thiet bi dang chon
echo  4. Cai dat Proxy moi (IP:Port)
echo  5. Tat / Xoa Proxy (ve mang goc)
echo  6. Xem Proxy cua TAT CA thiet bi
echo  7. Thoat
echo ====================================================
set /p CHOICE="Nhap lua chon cua ban (1-7): "

if "%CHOICE%"=="1" goto LIST_DEVICES
if "%CHOICE%"=="2" goto SELECT_DEVICE
if "%CHOICE%"=="3" goto GET_PROXY
if "%CHOICE%"=="4" goto SET_PROXY
if "%CHOICE%"=="5" goto CLEAR_PROXY
if "%CHOICE%"=="6" goto LIST_ALL_PROXY
if "%CHOICE%"=="7" exit
goto MENU

:: ---------------------------------------------------------------
:: Quet danh sach thiet bi -> DEV_1, DEV_2, ... va DEV_COUNT
:: ---------------------------------------------------------------
:SCAN_DEVICES
set DEV_COUNT=0
for /f "skip=1 tokens=1,2" %%A in ('adb.exe devices') do (
    if not "%%B"=="" (
        set /a DEV_COUNT+=1
        set "DEV_!DEV_COUNT!=%%A"
        set "ST_!DEV_COUNT!=%%B"
    )
)
exit /b

:LIST_DEVICES
echo.
echo [Danh sach thiet bi dang ket noi]
call :SCAN_DEVICES
if %DEV_COUNT%==0 (
    echo   Khong tim thay thiet bi nao. Hay bat gia lap roi thu lai.
) else (
    for /l %%I in (1,1,%DEV_COUNT%) do (
        set "MARK= "
        if "!DEV_%%I!"=="%DEVICE%" set "MARK=*"
        echo   !MARK! %%I. !DEV_%%I!   [!ST_%%I!]
    )
    echo.
    echo   (* = thiet bi dang chon^)
)
echo.
pause
goto MENU

:SELECT_DEVICE
echo.
echo [Chon thiet bi thao tac]
call :SCAN_DEVICES
if %DEV_COUNT%==0 (
    echo   Khong tim thay thiet bi nao. Hay bat gia lap roi thu lai.
    echo.
    pause
    goto MENU
)
for /l %%I in (1,1,%DEV_COUNT%) do (
    set "MARK= "
    if "!DEV_%%I!"=="%DEVICE%" set "MARK=*"
    echo   !MARK! %%I. !DEV_%%I!   [!ST_%%I!]
)
echo.
set "NEW_IDX="
set /p NEW_IDX="Nhap so thu tu thiet bi (1-%DEV_COUNT%, de trong de giu nguyen): "
if "%NEW_IDX%"=="" (
    echo Giu nguyen thiet bi: %DEVICE%
    pause
    goto MENU
)
set "PICKED=!DEV_%NEW_IDX%!"
if "%PICKED%"=="" (
    echo [Loi] So thu tu khong hop le!
    pause
    goto MENU
)
set "DEVICE=%PICKED%"
echo Da chon thiet bi: %DEVICE%
pause
goto MENU

:GET_PROXY
echo.
echo [Proxy hien tai tren %DEVICE%]
adb.exe -s %DEVICE% shell settings get global http_proxy
echo.
pause
goto MENU

:LIST_ALL_PROXY
echo.
echo [Proxy cua TAT CA thiet bi dang ket noi]
call :SCAN_DEVICES
if %DEV_COUNT%==0 (
    echo   Khong tim thay thiet bi nao. Hay bat gia lap roi thu lai.
    echo.
    pause
    goto MENU
)
echo ----------------------------------------------------------------
echo   #   THIET BI              TRANG THAI     PROXY
echo ----------------------------------------------------------------
for /l %%I in (1,1,%DEV_COUNT%) do (
    set "CUR_DEV=!DEV_%%I!"
    set "CUR_ST=!ST_%%I!"
    set "CUR_PROXY="
    if "!CUR_ST!"=="device" (
        for /f "usebackq delims=" %%P in (`adb.exe -s !CUR_DEV! shell settings get global http_proxy 2^>nul`) do set "CUR_PROXY=%%P"
    ) else (
        set "CUR_PROXY=(khong doc duoc - !CUR_ST!^)"
    )
    if "!CUR_PROXY!"=="" set "CUR_PROXY=(trong - khong dung proxy^)"
    if "!CUR_PROXY!"==":0" set "CUR_PROXY=(da tat proxy^)"
    if "!CUR_PROXY!"=="null" set "CUR_PROXY=(trong - khong dung proxy^)"
    set "MARK= "
    if "!CUR_DEV!"=="%DEVICE%" set "MARK=*"
    set "PAD_DEV=!CUR_DEV!                      "
    set "PAD_ST=!CUR_ST!               "
    echo  !MARK!%%I.  !PAD_DEV:~0,22! !PAD_ST:~0,14! !CUR_PROXY!
)
echo ----------------------------------------------------------------
echo   (* = thiet bi dang chon^)
echo.
pause
goto MENU

:SET_PROXY
echo.
set /p PROXY="Nhap Proxy dinh dang IP:Port (VD: 160.250.166.11:10072): "
if "%PROXY%"=="" (
    echo [Loi] Ban chua nhap Proxy!
    pause
    goto MENU
)
adb.exe -s %DEVICE% shell settings put global http_proxy %PROXY%
echo.
echo Da ap dung Proxy [%PROXY%] cho [%DEVICE%].
echo Kiem tra lai gia tri vua luu:
adb.exe -s %DEVICE% shell settings get global http_proxy
echo.
pause
goto MENU

:CLEAR_PROXY
echo.
adb.exe -s %DEVICE% shell settings put global http_proxy :0
echo Da xoa Proxy tren [%DEVICE%].
echo Kiem tra lai gia tri hien tai:
adb.exe -s %DEVICE% shell settings get global http_proxy
echo.
pause
goto MENU

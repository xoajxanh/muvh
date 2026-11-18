# =========================================================================
# [FARM KC] CONG CU KIEM THU 4 API MA MOI RONG VANG
# Cach dung:
#   .\Test-FarmApi.ps1                              -> hoi domain roi hien menu
#   .\Test-FarmApi.ps1 -BaseUrl http://test.guntop.net
#   .\Test-FarmApi.ps1 -BaseUrl http://localhost:3000 -ServerId 517 -WebUser admin
#   .\Test-FarmApi.ps1 -BaseUrl http://test.guntop.net -Auto    -> chay het, khong hoi
# =========================================================================
param(
    [string]$BaseUrl  = "",
    [int]   $ServerId = 517,
    [string]$WebUser  = "admin",
    [string]$Salt     = "MUVH_FARM_KC_SALT_2026_XOAI",
    [switch]$Auto
)

$ErrorActionPreference = "Continue"

# ---------- Duong dan 4 API ----------
$API = @{
    GetInviter    = "/api/v1/farm/inviter"
    ReportInviter = "/api/v1/farm/inviter/report"
    ClaimCode     = "/api/v1/farm/invite/claim"
    ReportResult  = "/api/v1/farm/invite/result"
}

# ---------- Tien ich ----------
function Write-Title($t) {
    Write-Host ""
    Write-Host ("=" * 70) -ForegroundColor DarkGray
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("=" * 70) -ForegroundColor DarkGray
}

function Get-Md5([string]$text) {
    $md5   = [System.Security.Cryptography.MD5]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    $hash  = $md5.ComputeHash($bytes)
    return ([System.BitConverter]::ToString($hash) -replace '-','').ToLower()
}

function Get-Ts { [int][double]::Parse((Get-Date -UFormat %s)) }

# sign = MD5(noi cac tham so + ts + Salt)
function Get-Sign([array]$parts, [int]$ts) {
    $joined = ""
    foreach ($p in $parts) { if ($null -ne $p) { $joined += [string]$p } }
    $raw = $joined + [string]$ts + $Salt
    return (Get-Md5 $raw)
}

function Invoke-Api {
    param([string]$Method, [string]$Path, [hashtable]$Body, [hashtable]$Query, [string]$SignRaw)

    $url = "$BaseUrl$Path"
    if ($Query) {
        $pairs = @()
        foreach ($k in ($Query.Keys | Sort-Object)) {
            $pairs += "$k=" + [System.Uri]::EscapeDataString([string]$Query[$k])
        }
        $url = $url + "?" + ($pairs -join "&")
    }

    Write-Host "  URL      : $url" -ForegroundColor DarkCyan
    if ($SignRaw) { Write-Host "  Chuoi ky : $SignRaw" -ForegroundColor DarkGray }
    if ($Body) {
        $json = $Body | ConvertTo-Json -Compress
        Write-Host "  Body     : $json" -ForegroundColor DarkGray
    }

    try {
        if ($Method -eq "GET") {
            $resp = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -TimeoutSec 25
        } else {
            $json = $Body | ConvertTo-Json -Compress
            $utf8 = [System.Text.Encoding]::UTF8.GetBytes($json)
            $resp = Invoke-WebRequest -Uri $url -Method POST -ContentType "application/json; charset=utf-8" `
                        -Body $utf8 -UseBasicParsing -TimeoutSec 25
        }
        Write-Host "  HTTP     : $($resp.StatusCode)" -ForegroundColor Green
        Write-Host "  Tra ve   : $($resp.Content)" -ForegroundColor White
        return ($resp.Content | ConvertFrom-Json)
    }
    catch {
        $code = $null
        try { $code = $_.Exception.Response.StatusCode.value__ } catch {}
        $content = ""
        try {
            $sr = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $content = $sr.ReadToEnd()
        } catch {}

        if ($code) {
            $color = if ($code -eq 404) { "Red" } else { "Yellow" }
            Write-Host "  HTTP     : $code" -ForegroundColor $color
            if ($code -eq 404) { Write-Host "  >> ROUTE CHUA DEPLOY!" -ForegroundColor Red }
            if ($content) { Write-Host "  Tra ve   : $content" -ForegroundColor White }
            if ($content) { try { return ($content | ConvertFrom-Json) } catch {} }
        } else {
            Write-Host "  LOI KET NOI: $($_.Exception.Message)" -ForegroundColor Red
        }
        return $null
    }
}

# ---------- 4 ham goi API ----------
function Test-GetInviter([string]$email) {
    Write-Title "API 1/4 - GET $($API.GetInviter)  (kiem tra acc Lv200)"
    $ts  = Get-Ts
    $raw = "$email$ServerId$ts$Salt"
    Invoke-Api -Method GET -Path $API.GetInviter -SignRaw $raw -Query @{
        email = $email; serverId = $ServerId; createdBy = $WebUser
        ts = $ts; sign = (Get-Sign @($email, $ServerId) $ts)
    }
}

function Test-ReportInviter([string]$email, [string]$code, [int]$num) {
    Write-Title "API 2/4 - POST $($API.ReportInviter)  (bao cao acc Lv200)"
    $ts     = Get-Ts
    $roleId = "5945036050158842885"
    $raw    = "$email$ServerId$roleId$code$num$ts$Salt"
    Invoke-Api -Method POST -Path $API.ReportInviter -SignRaw $raw -Body @{
        email = $email; password = "12345ZXC"
        serverId = $ServerId; serverName = "VINH HANG $ServerId"
        roleId = $roleId; roleName = "TestInviter"; level = 200
        inviteCode = $code; gameInviteNum = $num
        unboundGold = 41071; unboundDiamond = 0
        createdBy = $WebUser; ts = $ts
        sign = (Get-Sign @($email, $ServerId, $roleId, $code, $num) $ts)
    }
}

function Test-ClaimCode([string]$email, [string]$deviceId) {
    Write-Title "API 3/4 - POST $($API.ClaimCode)  (acc Lv50 xin ma)"
    $ts  = Get-Ts
    $raw = "$email$ServerId$deviceId$ts$Salt"
    Invoke-Api -Method POST -Path $API.ClaimCode -SignRaw $raw -Body @{
        email = $email; password = "12345ZXC"
        serverId = $ServerId; serverName = "VINH HANG $ServerId"
        roleId = "2001"; roleName = "TestInvitee"; level = 50
        deviceId = $deviceId; createdBy = $WebUser; ts = $ts
        sign = (Get-Sign @($email, $ServerId, $deviceId) $ts)
    }
}

function Test-ReportResult([string]$email, [string]$status, [string]$errMsg) {
    Write-Title "API 4/4 - POST $($API.ReportResult)  (bao ket qua nhap ma)"
    $ts  = Get-Ts
    $raw = "$email$ServerId$status$ts$Salt"
    Invoke-Api -Method POST -Path $API.ReportResult -SignRaw $raw -Body @{
        email = $email; serverId = $ServerId
        serverName = "VINH HANG $ServerId"; roleId = "2001"
        roleName = "TestInvitee"; level = 50
        status = $status; errorMsg = $errMsg
        createdBy = $WebUser; ts = $ts
        sign = (Get-Sign @($email, $ServerId, $status) $ts)
    }
}

function Test-Ping {
    Write-Title "KIEM TRA KET NOI + 4 ROUTE CO TON TAI KHONG"
    Write-Host "  (body rong -> ky vong 400/401. Neu 404 = chua deploy)" -ForegroundColor DarkGray
    foreach ($name in @("GetInviter","ReportInviter","ClaimCode","ReportResult")) {
        $p = $API[$name]
        try {
            $r = Invoke-WebRequest -Uri "$BaseUrl$p" -Method POST -ContentType "application/json" `
                    -Body "{}" -UseBasicParsing -TimeoutSec 20
            Write-Host ("  {0,-14} {1,-34} HTTP {2}" -f $name, $p, $r.StatusCode) -ForegroundColor Green
        } catch {
            $c = $null; try { $c = $_.Exception.Response.StatusCode.value__ } catch {}
            if ($c -eq 404)      { Write-Host ("  {0,-14} {1,-34} HTTP 404  << CHUA DEPLOY" -f $name,$p) -ForegroundColor Red }
            elseif ($c)          { Write-Host ("  {0,-14} {1,-34} HTTP {2}  (route OK)" -f $name,$p,$c) -ForegroundColor Green }
            else                 { Write-Host ("  {0,-14} {1,-34} KHONG KET NOI DUOC: {2}" -f $name,$p,$_.Exception.Message) -ForegroundColor Red }
        }
    }
}

function Test-FullScenario {
    $stamp   = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $inviter = "ps_inviter_$stamp@test.local"
    $invitee = "ps_invitee_$stamp@test.local"
    $code    = "PSCODE$stamp$ServerId"

    Write-Host ""
    Write-Host "  Acc Lv200 test : $inviter" -ForegroundColor Yellow
    Write-Host "  Acc Lv50  test : $invitee" -ForegroundColor Yellow
    Write-Host "  Ma moi test    : $code"    -ForegroundColor Yellow

    Test-ReportInviter $inviter $code 0 | Out-Null
    Test-GetInviter    $inviter        | Out-Null
    $claim = Test-ClaimCode $invitee "PS_DEVICE_01"

    if ($claim -and $claim.inviteCode) {
        Write-Host "  >> Da nhan ma: $($claim.inviteCode)" -ForegroundColor Green
        Test-ReportResult $invitee "SUCCESS" "" | Out-Null

        Write-Title "KIEM TRA LAI ACC LV200 (confirmedCount phai = 1)"
        $final = Test-GetInviter $inviter
        if ($final -and $final.confirmedCount -eq 1) {
            Write-Host "  >> DAT: confirmedCount = 1, reservedCount = $($final.reservedCount)" -ForegroundColor Green
        } else {
            Write-Host "  >> KIEM TRA LAI: confirmedCount = $($final.confirmedCount)" -ForegroundColor Yellow
        }

        Write-Title "KIEM TRA IDEMPOTENT (goi lai result - khong duoc cong 2 lan)"
        Test-ReportResult $invitee "SUCCESS" "" | Out-Null
        $again = Test-GetInviter $inviter
        if ($again -and $again.confirmedCount -eq 1) {
            Write-Host "  >> DAT: van = 1, khong cong trung" -ForegroundColor Green
        } else {
            Write-Host "  >> SAI: confirmedCount = $($again.confirmedCount)" -ForegroundColor Red
        }
    } else {
        Write-Host "  >> Khong xin duoc ma, bo qua cac buoc sau." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "  Don du lieu test bang SQL:" -ForegroundColor DarkGray
    Write-Host "    DELETE FROM FarmInvitee WHERE email LIKE 'ps_invitee_%';" -ForegroundColor DarkGray
    Write-Host "    DELETE FROM FarmInviter WHERE email LIKE 'ps_inviter_%';" -ForegroundColor DarkGray
}

# ---------- BAT DAU ----------
Write-Host ""
Write-Host "#####################################################" -ForegroundColor Magenta
Write-Host "#     KIEM THU 4 API FARM KC - MA MOI RONG VANG     #" -ForegroundColor Magenta
Write-Host "#####################################################" -ForegroundColor Magenta

if ([string]::IsNullOrWhiteSpace($BaseUrl)) {
    Write-Host ""
    $BaseUrl = Read-Host "Nhap domain (vd http://test.guntop.net, Enter = http://localhost:3000)"
    if ([string]::IsNullOrWhiteSpace($BaseUrl)) { $BaseUrl = "http://localhost:3000" }
}
$BaseUrl = $BaseUrl.TrimEnd('/')
if ($BaseUrl -notmatch '^https?://') { $BaseUrl = "http://$BaseUrl" }

Write-Host ""
Write-Host "  Domain   : $BaseUrl"  -ForegroundColor White
Write-Host "  ServerId : $ServerId" -ForegroundColor White
Write-Host "  User web : $WebUser"  -ForegroundColor White
Write-Host "  Salt     : $Salt"     -ForegroundColor DarkGray

if ($Auto) {
    Test-Ping
    Test-FullScenario
    Write-Host ""
    Write-Host "===== XONG =====" -ForegroundColor Magenta
    exit
}

while ($true) {
    Write-Host ""
    Write-Host "-----------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  [1] Kiem tra ket noi + 4 route co ton tai khong"
    Write-Host "  [2] Chay KICH BAN DAY DU (bao cao -> xin ma -> bao ket qua)"
    Write-Host "  [3] Goi rieng API 1 - GET inviter"
    Write-Host "  [4] Goi rieng API 2 - POST inviter/report"
    Write-Host "  [5] Goi rieng API 3 - POST invite/claim"
    Write-Host "  [6] Goi rieng API 4 - POST invite/result"
    Write-Host "  [7] Doi domain"
    Write-Host "  [q] Thoat"
    Write-Host "-----------------------------------------------------" -ForegroundColor DarkGray
    $c = Read-Host "Chon"

    switch ($c) {
        "1" { Test-Ping }
        "2" { Test-FullScenario }
        "3" {
            $e = Read-Host "  Email acc Lv200"
            if ($e) { Test-GetInviter $e | Out-Null }
        }
        "4" {
            $e = Read-Host "  Email acc Lv200"
            $k = Read-Host "  Ma moi"
            $n = Read-Host "  So nguoi da moi (Enter = 0)"
            if (-not $n) { $n = 0 }
            if ($e) { Test-ReportInviter $e $k ([int]$n) | Out-Null }
        }
        "5" {
            $e = Read-Host "  Email acc Lv50"
            $d = Read-Host "  DeviceId (Enter = PS_DEVICE_01)"
            if (-not $d) { $d = "PS_DEVICE_01" }
            if ($e) { Test-ClaimCode $e $d | Out-Null }
        }
        "6" {
            $e = Read-Host "  Email acc Lv50"
            $s = Read-Host "  Status (SUCCESS / FAILED / ALREADY_USED / NO_CODE)"
            if (-not $s) { $s = "SUCCESS" }
            $m = Read-Host "  Loi (bo trong neu khong co)"
            if ($e) { Test-ReportResult $e $s.ToUpper() $m | Out-Null }
        }
        "7" {
            $nb = Read-Host "  Domain moi"
            if ($nb) {
                $BaseUrl = $nb.TrimEnd('/')
                if ($BaseUrl -notmatch '^https?://') { $BaseUrl = "http://$BaseUrl" }
                Write-Host "  >> Da doi sang: $BaseUrl" -ForegroundColor Green
            }
        }
        "q" { Write-Host "Thoat."; break }
        default { Write-Host "  Lua chon khong hop le." -ForegroundColor Yellow }
    }
    if ($c -eq "q") { break }
}

-- =========================================================================
-- [TEST SCRIPT T2+T3]: GOI 4 API TU TRONG GAME
-- Muc dich: kiem chung ban Farm GOI DUOC web (GET + POST JSON) va chu ky
--           MD5 khop voi server.
-- QUAN TRONG: script TU CHUA toan bo ha tang -> chay duoc tren APK HIEN TAI,
--             KHONG can build lai mod.
-- Cach dung: copy vao input.txt -> push_test -> bam EXEC -> doc output.txt
--            (cho khoang 15-20 giay roi moi lay log)
-- =========================================================================

-- ====== SUA 3 DONG NAY NEU CAN ======
local BASE_URL = "http://test.guntop.net"
local SALT     = "MUVH_FARM_KC_SALT_2026_XOAI"
local WEB_USER = "admin"            -- phai co that trong bang User cua web
local DO_POST  = true               -- false = chi thu GET, khong ghi gi len DB
-- ====================================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log("")
    log("==================================================")
    log("  " .. tostring(t))
    log("==================================================")
end
local function kv(k, v) log(string.format("  %-20s = %s", tostring(k), tostring(v))) end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

-- ---------- MD5 ----------
local function MD5(str)
    if CS and CS.PCUtility and CS.PCUtility.Md5 then
        return string.lower(CS.PCUtility.Md5(str))
    end
    return ""
end

local function UrlEncode(str)
    if not str then return "" end
    str = string.gsub(tostring(str), "([^%w %-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return (string.gsub(str, " ", "+"))
end

-- ---------- JSON ----------
local function EscJson(v)
    v = tostring(v)
    v = string.gsub(v, '\\', '\\\\'); v = string.gsub(v, '"', '\\"')
    v = string.gsub(v, '\n', '\\n');  v = string.gsub(v, '\r', '\\r')
    return v
end
local function ToJson(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do table.insert(keys, tostring(k)) end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do
        local v = tbl[k]
        local piece
        if type(v) == "number" then
            if v == math.floor(v) then piece = string.format("%d", v) else piece = tostring(v) end
        elseif type(v) == "boolean" then piece = v and "true" or "false"
        else piece = '"' .. EscJson(v) .. '"' end
        table.insert(parts, '"' .. EscJson(k) .. '":' .. piece)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

local function Now()
    local t = 0
    pcall(function()
        if _G.Time and _G.Time.GetServerSecondTime then t = tonumber(_G.Time.GetServerSecondTime()) or 0 end
    end)
    if t < 1000000000 then t = os.time() end
    return math.floor(t)
end

local function Sign(parts, ts)
    local joined = ""
    for _, p in ipairs(parts) do joined = joined .. tostring(p == nil and "" or p) end
    return MD5(joined .. tostring(ts) .. SALT)
end

-- ---------- Loi goi mang (dung Timer.StartLoop) ----------
local function Send(req, label, onDone)
    local finished = false
    local function finish(ok, raw, err)
        if finished then return end
        finished = true
        pcall(function() req:Dispose() end)
        log(string.format("  [%s] ket qua: ok=%s", label, tostring(ok)))
        if raw and raw ~= "" then log("  [" .. label .. "] tra ve: " .. tostring(raw)) end
        if err then log("  [" .. label .. "] LOI: " .. tostring(err)) end
        saveOutput()
        if onDone then pcall(onDone, ok, raw) end
    end

    local okStart = pcall(function() req:SendWebRequest() end)
    if not okStart then finish(false, "", "Khong gui duoc request"); return end

    if not (_G.Timer and _G.Timer.StartLoop) then
        finish(false, "", "Khong co Timer.StartLoop"); return
    end

    local ticks, timerObj = 0, nil
    timerObj = _G.Timer.StartLoop(0.1, 150, function()
        if finished then return end
        ticks = ticks + 1
        local isDone = false
        pcall(function() isDone = req.isDone end)
        if isDone then
            if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
            local raw = ""
            pcall(function() if req.downloadHandler then raw = req.downloadHandler.text or "" end end)
            if raw == "" then finish(false, "", "Web khong tra ve du lieu") else finish(true, raw, nil) end
        elseif ticks >= 150 then
            if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
            finish(false, "", "Qua thoi gian cho 15s")
        end
    end)
end

local function HttpGet(path, query, label, onDone)
    local qs, keys = {}, {}
    for k, _ in pairs(query) do table.insert(keys, tostring(k)) end
    table.sort(keys)
    for _, k in ipairs(keys) do table.insert(qs, UrlEncode(k) .. "=" .. UrlEncode(tostring(query[k]))) end
    local url = BASE_URL .. path .. "?" .. table.concat(qs, "&")
    log("  [" .. label .. "] GET " .. url)
    saveOutput()
    local ok, req = pcall(function()
        local r = CS.UnityEngine.Networking.UnityWebRequest.Get(url)
        r.timeout = 15
        return r
    end)
    if not ok or not req then log("  [" .. label .. "] Khong tao duoc request"); saveOutput(); if onDone then onDone(false) end; return end
    Send(req, label, onDone)
end

local function HttpPost(path, body, label, onDone)
    local url = BASE_URL .. path
    local jsonStr = ToJson(body)
    log("  [" .. label .. "] POST " .. url)
    log("  [" .. label .. "] body: " .. jsonStr)
    saveOutput()
    local ok, req = pcall(function()
        local N = CS.UnityEngine.Networking
        local r = N.UnityWebRequest(url, "POST")
        local bytes = CS.System.Text.Encoding.UTF8:GetBytes(jsonStr)
        r.uploadHandler = N.UploadHandlerRaw(bytes)
        r.downloadHandler = N.DownloadHandlerBuffer()
        r:SetRequestHeader("Content-Type", "application/json")
        r.timeout = 15
        return r
    end)
    if not ok or not req then
        log("  [" .. label .. "] KHONG TAO DUOC POST REQUEST (XLua khong ho tro?)")
        saveOutput(); if onDone then onDone(false) end; return
    end
    Send(req, label, onDone)
end

-- ---------- Thu thap thong tin that ----------
local function Collect()
    local i = { email="", password="", serverId=0, serverName="", roleId="", roleName="",
                level=0, code="", num=0, isCode=false, unboundGold=0, unboundDiamond=0, deviceId="" }
    pcall(function()
        local a = _G.GetCurrentAccount and _G.GetCurrentAccount()
        if a then i.email = tostring(a.account or ""); i.password = tostring(a.password or "") end
    end)
    pcall(function()
        local md = _G.ViewData and _G.ViewData.meData
        local me = _G.RoleManager and _G.RoleManager.me
        local rid = (md and md.id) or (me and me.id)
        if rid ~= nil then i.roleId = (string.gsub(tostring(rid), "%.0*$", "")) end
        i.roleName = tostring((md and md.name) or (me and me.name) or "")
        i.level = tonumber((md and md.level) or (me and me.level) or 0) or 0
    end)
    pcall(function()
        if _G.GetActualCurrentServerInfo then
            local s, n = _G.GetActualCurrentServerInfo()
            i.serverId = tonumber(s) or 0; i.serverName = tostring(n or "")
        end
    end)
    pcall(function()
        local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
        if c then
            i.unboundGold = tonumber(c[1000020] or 0) or 0
            i.unboundDiamond = tonumber(c[1000030] or 0) or 0
        end
    end)
    pcall(function()
        local m = _G.QuickFind and _G.QuickFind:GetTask_EarlyGoldManager()
        local vd = m and m.GetVerifyData and m:GetVerifyData()
        if vd then i.code = tostring(vd.code or ""); i.num = tonumber(vd.num or 0) or 0; i.isCode = (vd.isCode == true) end
    end)
    pcall(function() i.deviceId = tostring(CS.UnityEngine.SystemInfo.deviceUniqueIdentifier or "") end)
    return i
end

-- ===================== CHAY =====================
log("=== T2+T3: GOI 4 API TU TRONG GAME ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
log("BASE_URL : " .. BASE_URL)
kv("MD5 kha dung", MD5("test") ~= "")
kv("UploadHandlerRaw", CS.UnityEngine.Networking.UploadHandlerRaw ~= nil)

local info = Collect()
hdr("0. THONG TIN ACC DANG DUNG")
kv("email", info.email); kv("serverId", info.serverId); kv("serverName", info.serverName)
kv("roleId", info.roleId); kv("roleName", info.roleName); kv("level", info.level)
kv("code", info.code); kv("num", info.num); kv("isCode", info.isCode)
kv("unboundGold", info.unboundGold); kv("unboundDiamond", info.unboundDiamond)
kv("deviceId", info.deviceId)
saveOutput()

if info.email == "" or info.serverId == 0 then
    log("")
    log("!!! CHUA VAO GAME hoac thieu thong tin -> DUNG LAI")
    saveOutput()
    return
end

-- B1: GET inviter
hdr("1. GET /api/v1/farm/inviter  (kiem tra acc Lv200)")
local ts1 = Now()
HttpGet("/api/v1/farm/inviter", {
    email = info.email, serverId = info.serverId, createdBy = WEB_USER,
    ts = ts1, sign = Sign({ info.email, info.serverId }, ts1),
}, "GET-inviter", function(ok1)

    if not DO_POST then
        hdr("DA TAT POST (DO_POST = false) -> KET THUC")
        saveOutput()
        return
    end

    -- B2: POST inviter/report
    hdr("2. POST /api/v1/farm/inviter/report  (bao cao acc Lv200)")
    local ts2 = Now()
    HttpPost("/api/v1/farm/inviter/report", {
        email = info.email, password = info.password,
        serverId = info.serverId, serverName = info.serverName,
        roleId = info.roleId, roleName = info.roleName, level = info.level,
        inviteCode = info.code, gameInviteNum = info.num,
        unboundGold = info.unboundGold, unboundDiamond = info.unboundDiamond,
        createdBy = WEB_USER, ts = ts2,
        sign = Sign({ info.email, info.serverId, info.roleId, info.code, info.num }, ts2),
    }, "POST-report", function(ok2)

        -- B3: GET lai de xac nhan da ghi vao DB
        hdr("3. GET lai inviter  (xac nhan DB da luu)")
        local ts3 = Now()
        HttpGet("/api/v1/farm/inviter", {
            email = info.email, serverId = info.serverId, createdBy = WEB_USER,
            ts = ts3, sign = Sign({ info.email, info.serverId }, ts3),
        }, "GET-lai", function(ok3)
            hdr("=== KET THUC T2+T3 ===")
            log("  GET inviter  : " .. tostring(ok1))
            log("  POST report  : " .. tostring(ok2))
            log("  GET xac nhan : " .. tostring(ok3))
            saveOutput()
        end)
    end)
end)

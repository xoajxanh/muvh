-- =========================================================================
-- [TEST SCRIPT T4]: LUONG ACC LV200 (INVITER) - BAN STANDALONE
-- Muc dich: chay THU toan bo luong se dua vao mod, tren APK HIEN TAI.
--   1. Cho du lieu ma moi
--   2. Chua co ma + du dieu kien -> bam [Tao ma] -> cho ma ve
--   3. Thu thap va gui len web
--   4. LUON "chuyen acc" du loi gi (o day chi in ra, khong chuyen that)
-- KHONG can build lai mod.
-- =========================================================================

-- ====== CAU HINH ======
local BASE_URL = "http://test.guntop.net"
local SALT     = "MUVH_FARM_KC_SALT_2026_XOAI"
local WEB_USER = "admin"
local CHO_VERIFY_DATA = 10
local CHO_TAO_MA      = 10
local CHO_PHAN_HOI    = 15
-- Dat true neu muon THU TAO MA tren acc CHUA CO ma (acc da co ma thi bo qua)
local CHO_PHEP_TAO_MA = true
-- ======================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log(""); log("=================================================="); log("  " .. tostring(t)); log("==================================================")
end
local function kv(k, v) log(string.format("  %-22s = %s", tostring(k), tostring(v))) end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

local N = CS.UnityEngine.Networking

local function MD5(s)
    if CS and CS.PCUtility and CS.PCUtility.Md5 then return string.lower(CS.PCUtility.Md5(s)) end
    return ""
end
local function Now()
    local t = 0
    pcall(function() if _G.Time and _G.Time.GetServerSecondTime then t = tonumber(_G.Time.GetServerSecondTime()) or 0 end end)
    if t < 1000000000 then t = os.time() end
    return math.floor(t)
end
local function Sign(parts, ts)
    local j = ""
    for _, p in ipairs(parts) do j = j .. tostring(p == nil and "" or p) end
    return MD5(j .. tostring(ts) .. SALT)
end
local function EscJson(v)
    v = tostring(v)
    v = string.gsub(v, '\\', '\\\\'); v = string.gsub(v, '"', '\\"')
    v = string.gsub(v, '\n', '\\n');  v = string.gsub(v, '\r', '\\r')
    return v
end
local function ToJson(t)
    local keys = {}
    for k, _ in pairs(t) do table.insert(keys, tostring(k)) end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do
        local v = t[k]
        local piece
        if type(v) == "number" then
            if v == math.floor(v) then piece = string.format("%d", v) else piece = tostring(v) end
        elseif type(v) == "boolean" then piece = v and "true" or "false"
        else piece = '"' .. EscJson(v) .. '"' end
        table.insert(parts, '"' .. EscJson(k) .. '":' .. piece)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

-- POST: Put(url, chuoi) + doi method (cach da kiem chung T3c)
local function PostJson(path, body, onDone)
    local url = BASE_URL .. path
    local jsonStr = ToJson(body)
    log("  POST " .. url)
    log("  body: " .. jsonStr)
    saveOutput()

    local ok, req = pcall(function()
        local r = N.UnityWebRequest.Put(url, jsonStr)
        r.method = "POST"
        r.downloadHandler = N.DownloadHandlerBuffer()
        r:SetRequestHeader("Content-Type", "application/json")
        r.timeout = CHO_PHAN_HOI
        return r
    end)
    if not ok or not req then log("  >> Tao request that bai"); saveOutput(); if onDone then onDone(false) end; return end

    local okSend = pcall(function() req:SendWebRequest() end)
    if not okSend then log("  >> Gui that bai"); saveOutput(); if onDone then onDone(false) end; return end

    local fin, ticks, tObj = false, 0, nil
    tObj = _G.Timer.StartLoop(0.1, CHO_PHAN_HOI * 10 + 20, function()
        if fin then return end
        ticks = ticks + 1
        local isDone = false
        pcall(function() isDone = req.isDone end)
        if isDone then
            fin = true
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            local raw, code = "", 0
            pcall(function() if req.downloadHandler then raw = req.downloadHandler.text or "" end end)
            pcall(function() code = req.responseCode end)
            log("  HTTP " .. tostring(code) .. " | " .. tostring(raw))
            pcall(function() req:Dispose() end)
            saveOutput()
            if onDone then pcall(onDone, (tostring(code) == "200"), raw) end
        elseif ticks >= CHO_PHAN_HOI * 10 + 20 then
            fin = true
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            log("  >> Qua thoi gian cho")
            pcall(function() req:Dispose() end)
            saveOutput()
            if onDone then pcall(onDone, false) end
        end
    end)
end

-- Thu thap
local function Collect()
    local i = { email="", password="", serverId=0, serverName="", roleId="", roleName="", level=0,
                code="", num=0, isCode=false, unboundGold=0, unboundDiamond=0, deviceId="",
                canGenCode=false, hasVerifyData=false }
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
        if c then i.unboundGold = tonumber(c[1000020] or 0) or 0; i.unboundDiamond = tonumber(c[1000030] or 0) or 0 end
    end)
    pcall(function()
        local m = _G.QuickFind and _G.QuickFind:GetTask_EarlyGoldManager()
        local vd = m and m.GetVerifyData and m:GetVerifyData()
        if vd then
            i.hasVerifyData = true
            i.code = tostring(vd.code or ""); i.num = tonumber(vd.num or 0) or 0; i.isCode = (vd.isCode == true)
        end
    end)
    pcall(function()
        local f = _G.ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")
        if f and _G.ConditionManager and _G.ConditionManager.Check4D then
            i.canGenCode = (_G.ConditionManager.Check4D(f.condition) == true)
        end
    end)
    pcall(function() i.deviceId = tostring(CS.UnityEngine.SystemInfo.deviceUniqueIdentifier or "") end)
    return i
end

-- Poll cho den khi dieu kien dung
local function PollUntil(maxSec, kiemTra, onDone)
    local fin, ticks = false, 0
    local maxTicks = math.max(1, math.floor(maxSec))
    local function finish(ok) if fin then return end; fin = true; if onDone then pcall(onDone, ok, Collect()) end end
    if kiemTra(Collect()) then finish(true); return end
    if not (_G.Timer and _G.Timer.StartLoop) then finish(false); return end
    local tObj
    tObj = _G.Timer.StartLoop(1.0, maxTicks, function()
        if fin then return end
        ticks = ticks + 1
        local cur = Collect()
        if kiemTra(cur) then
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            finish(true)
        elseif ticks >= maxTicks then
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            finish(false)
        end
    end)
end

-- ===================== CHAY LUONG =====================
log("=== T4: LUONG ACC LV200 (INVITER) ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))

local finished = false
local function KetThuc(ly_do)
    if finished then return end
    finished = true
    hdr("KET THUC -> CHUYEN ACC")
    log("  Ly do: " .. tostring(ly_do))
    log("")
    log("  (Trong mod that, day la luc bot chuyen sang acc ke tiep)")
    log("=== KET THUC T4 ===")
    saveOutput()
end

local function GuiBaoCao(info)
    hdr("BUOC 3: GUI BAO CAO LEN WEB")
    local ts = Now()
    PostJson("/api/v1/farm/inviter/report", {
        email = info.email, password = info.password,
        serverId = info.serverId, serverName = info.serverName,
        roleId = info.roleId, roleName = info.roleName, level = info.level,
        inviteCode = info.code, gameInviteNum = info.num,
        unboundGold = info.unboundGold, unboundDiamond = info.unboundDiamond,
        createdBy = WEB_USER, ts = ts,
        sign = Sign({ info.email, info.serverId, info.roleId, info.code, info.num }, ts),
    }, function(ok, raw)
        if ok then KetThuc("Da bao cao thanh cong")
        else KetThuc("Loi gui bao cao -> trong mod that se luu cho gui bu") end
    end)
end

hdr("BUOC 1: CHO DU LIEU MA MOI (toi da " .. CHO_VERIFY_DATA .. "s)")
PollUntil(CHO_VERIFY_DATA, function(i) return i.hasVerifyData end, function(co, info)
    kv("Co du lieu", co)
    if not co then KetThuc("Khong nhan duoc du lieu ma moi"); return end

    kv("email", info.email)
    kv("serverId", info.serverId)
    kv("serverName", info.serverName)
    kv("roleName", info.roleName)
    kv("level", info.level)
    kv("code", info.code == "" and "(CHUA CO MA)" or info.code)
    kv("num", info.num)
    kv("canGenCode", info.canGenCode)
    kv("unboundGold", info.unboundGold)
    kv("unboundDiamond", info.unboundDiamond)
    saveOutput()

    if info.code ~= "" then
        hdr("BUOC 2: DA CO MA SAN -> BO QUA TAO MA")
        GuiBaoCao(info)
        return
    end

    hdr("BUOC 2: CHUA CO MA -> TAO MA")
    if not info.canGenCode then KetThuc("Chua du dieu kien tao ma (can Lv200)"); return end
    if not CHO_PHEP_TAO_MA then KetThuc("CHO_PHEP_TAO_MA = false -> khong tao"); return end

    log("  Gui networkRequest.ReqRoleCode() ...")
    saveOutput()
    local okGui = pcall(function() _G.networkRequest.ReqRoleCode() end)
    kv("Goi ReqRoleCode", okGui)
    if not okGui then KetThuc("Goi ReqRoleCode that bai"); return end

    PollUntil(CHO_TAO_MA, function(i) return i.code ~= nil and i.code ~= "" end, function(coMa, info2)
        kv("Tao duoc ma", coMa)
        if not coMa then KetThuc("Tao ma qua han " .. CHO_TAO_MA .. "s"); return end
        kv("Ma moi", info2.code)
        saveOutput()
        GuiBaoCao(info2)
    end)
end)

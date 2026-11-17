-- =========================================================================
-- [TEST SCRIPT T1b]: HAM THU THAP CHINH THUC + KIEM CHUNG Timer.StartLoop
-- Muc dich:
--   1. Dinh nghia 3 ham se dua vao ban mod that:
--        _G.Mod_FarmInvite_CollectInfo()              -- gom moi thong tin
--        _G.Mod_FarmInvite_ToJson(tbl)                -- dong goi JSON de POST sau nay
--        _G.Mod_FarmInvite_WaitVerifyData(maxSec, cb) -- cho goi 1029 (dung StartLoop)
--   2. Chay thu va in ket qua de doi chieu voi T1.
-- AN TOAN: KHONG gui goi tin, KHONG hook, KHONG sua du lieu game.
-- Cach dung: copy vao input.txt -> push_test -> bam EXEC -> doc output.txt
-- =========================================================================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log("")
    log("==================================================")
    log("  " .. tostring(t))
    log("==================================================")
end
local function kv(k, v) log(string.format("  %-24s = %s", tostring(k), tostring(v))) end
local function saveOutput()
    pcall(function()
        local path = CS.UnityEngine.Application.persistentDataPath .. "/output.txt"
        local f = io.open(path, "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

-- =========================================================================
-- [MOD FEATURE]: FARM KC - DONG GOI JSON
-- Mo ta: Chuyen bang Lua phang thanh chuoi JSON de gui POST len web.
--        Chi ho tro string/number/boolean - du cho payload cua FARM KC.
-- =========================================================================
local function EscapeJsonString(s)
    s = tostring(s)
    s = string.gsub(s, '\\', '\\\\')
    s = string.gsub(s, '"', '\\"')
    s = string.gsub(s, '\n', '\\n')
    s = string.gsub(s, '\r', '\\r')
    s = string.gsub(s, '\t', '\\t')
    return s
end

local function Mod_FarmInvite_ToJson(tbl)
    if type(tbl) ~= "table" then return "{}" end
    local parts = {}
    -- sap xep key de chuoi JSON on dinh (de doi chieu khi debug)
    local keys = {}
    for k, _ in pairs(tbl) do table.insert(keys, tostring(k)) end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local v = tbl[k]
        local piece
        if type(v) == "number" then
            -- tranh ghi dang 1e+18 cho so lon
            if v == math.floor(v) then
                piece = string.format("%d", v)
            else
                piece = tostring(v)
            end
        elseif type(v) == "boolean" then
            piece = v and "true" or "false"
        elseif v == nil then
            piece = "null"
        else
            piece = '"' .. EscapeJsonString(v) .. '"'
        end
        table.insert(parts, '"' .. EscapeJsonString(k) .. '":' .. piece)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end
_G.Mod_FarmInvite_ToJson = Mod_FarmInvite_ToJson

-- =========================================================================
-- [MOD FEATURE]: FARM KC - THU THAP THONG TIN NHAN VAT CHO LUONG MA MOI
-- Mo ta: Gom moi thong tin can bao cao len web. CHI DOC, khong gui goi tin.
--        Moi truy cap boc pcall, thieu truong nao tra mac dinh -> khong bao gio
--        lam vo luong farm.
-- Da kiem chung tren game that 2026-11-17 (acc Tedyg4 Lv282, server 517).
-- =========================================================================
local function Mod_FarmInvite_CollectInfo()
    local info = {
        email = "", password = "",
        serverId = 0, serverName = "",
        roleId = "", roleName = "", level = 0,
        code = "", num = 0, isCode = false,
        unboundGold = 0, unboundDiamond = 0,
        deviceId = "",
        canGenCode = false,
        hasVerifyData = false,
        inGame = false,
    }

    -- 1. Acc bot dang chay (lay duoc ca khi chua vao game)
    pcall(function()
        local acc = _G.GetCurrentAccount and _G.GetCurrentAccount()
        if acc then
            info.email = tostring(acc.account or "")
            info.password = tostring(acc.password or "")
        end
    end)

    -- 2. Nhan vat. roleId la int64 rat lon -> LUON ep ve string, khong de thanh number
    pcall(function()
        local meData = _G.ViewData and _G.ViewData.meData
        local me = _G.RoleManager and _G.RoleManager.me
        info.inGame = (meData ~= nil) or (me ~= nil)
        -- roleId la int64 RAT LON (> 9 trieu ti). TUYET DOI KHONG dung tonumber()
        -- hay string.format("%.0f") - se bi lam tron mat vai so cuoi.
        -- Phai tostring() THANG tu gia tri goc.
        local rid = (meData and meData.id) or (me and me.id)
        if rid ~= nil then
            local sid = tostring(rid)
            -- phong truong hop tostring tra ve dang 5.94e+18 hoac co duoi .0
            if string.find(sid, "e", 1, true) or string.find(sid, "E", 1, true) then
                sid = string.format("%.0f", rid)   -- du phong, van co the mat chinh xac
            end
            sid = string.gsub(sid, "%.0*$", "")
            info.roleId = sid
        end
        info.roleName = tostring((meData and meData.name) or (me and me.name) or "")
        info.level = tonumber((meData and meData.level) or (me and me.level) or 0) or 0
    end)

    -- 3. Server. Uu tien ham rieng cua ban Farm, du phong LoginData
    pcall(function()
        if _G.GetActualCurrentServerInfo then
            local sId, sName = _G.GetActualCurrentServerInfo()
            info.serverId = tonumber(sId) or 0
            info.serverName = tostring(sName or "")
        end
    end)
    if info.serverId == 0 then
        pcall(function()
            local LD = _G.LoginData
            if LD then
                info.serverId = tonumber(LD.serverId) or 0
                if LD.GetServerName then info.serverName = tostring(LD.GetServerName() or "") end
            end
        end)
    end

    -- 4. Tien te: 1000020 = Vang KHONG khoa, 1000030 = KC KHONG khoa (da xac nhan bang anh)
    pcall(function()
        local coins = _G.BagInfoData and _G.BagInfoData.CoinInfos
        if coins then
            info.unboundGold = tonumber(coins[1000020] or coins["1000020"] or 0) or 0
            info.unboundDiamond = tonumber(coins[1000030] or coins["1000030"] or 0) or 0
        end
    end)

    -- 5. Du lieu ma moi (server tu day goi 1029 khi vao game)
    pcall(function()
        local mgr = _G.QuickFind and _G.QuickFind:GetTask_EarlyGoldManager()
        local vd = mgr and mgr.GetVerifyData and mgr:GetVerifyData()
        if vd then
            info.hasVerifyData = true
            info.code = tostring(vd.code or "")
            info.num = tonumber(vd.num or 0) or 0
            info.isCode = (vd.isCode == true)
        end
    end)

    -- 6. Dieu kien mo nut [Tao ma] (func 5100001 = Lv200)
    pcall(function()
        local func = _G.ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")
        if func and _G.ConditionManager and _G.ConditionManager.Check4D then
            info.canGenCode = (_G.ConditionManager.Check4D(func.condition) == true)
        end
    end)

    -- 7. deviceId - da chot dung deviceUniqueIdentifier (T1)
    pcall(function()
        info.deviceId = tostring(CS.UnityEngine.SystemInfo.deviceUniqueIdentifier or "")
    end)

    return info
end
_G.Mod_FarmInvite_CollectInfo = Mod_FarmInvite_CollectInfo

-- =========================================================================
-- [MOD FEATURE]: FARM KC - CHO DU LIEU MA MOI (POLL)
-- Mo ta: Poll GetVerifyData() moi 1s, toi da maxSec giay.
--        BAT BUOC dung Timer.StartLoop - Timer.Start KHONG CHAY trong moi
--        truong nay (da kiem chung T1 ngay 2026-11-17).
--        onDone(ok, info) - ok = true khi da co VerifyData.
-- =========================================================================
local function Mod_FarmInvite_WaitVerifyData(maxSec, onDone)
    maxSec = tonumber(maxSec) or 10
    local finished = false
    local ticks = 0
    local maxTicks = math.floor(maxSec)
    if maxTicks < 1 then maxTicks = 1 end

    local function finish(ok)
        if finished then return end
        finished = true
        local info = Mod_FarmInvite_CollectInfo()
        if onDone then pcall(onDone, ok, info) end
    end

    -- kiem tra ngay lap tuc truoc khi cho
    local first = Mod_FarmInvite_CollectInfo()
    if first.hasVerifyData then finish(true); return end

    if not (_G.Timer and _G.Timer.StartLoop) then
        finish(false)
        return
    end

    local timerObj
    timerObj = _G.Timer.StartLoop(1.0, maxTicks, function()
        if finished then return end
        ticks = ticks + 1
        local cur = Mod_FarmInvite_CollectInfo()
        if cur.hasVerifyData then
            if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
            finish(true)
        elseif ticks >= maxTicks then
            if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
            finish(false)
        end
    end)
end
_G.Mod_FarmInvite_WaitVerifyData = Mod_FarmInvite_WaitVerifyData

-- ===================== CHAY THU =====================
log("=== T1b: HAM THU THAP CHINH THUC ===")
log("Thoi diem: " .. tostring(os.date("%Y-%m-%d %H:%M:%S")))

hdr("1. GOI Mod_FarmInvite_CollectInfo()")
local info = Mod_FarmInvite_CollectInfo()
kv("inGame", info.inGame)
kv("email", info.email)
kv("password", info.password)
kv("serverId", info.serverId)
kv("serverName", info.serverName)
kv("roleId (string)", info.roleId)
kv("roleName", info.roleName)
kv("level", info.level)
kv("code", info.code)
kv("num", info.num)
kv("isCode", info.isCode)
kv("unboundGold", info.unboundGold)
kv("unboundDiamond", info.unboundDiamond)
kv("canGenCode", info.canGenCode)
kv("hasVerifyData", info.hasVerifyData)
kv("deviceId", info.deviceId)

hdr("2. PAYLOAD JSON (chinh la thu se POST len web o P5)")
local payload = {
    email = info.email,
    password = info.password,
    serverId = info.serverId,
    serverName = info.serverName,
    roleId = info.roleId,
    roleName = info.roleName,
    level = info.level,
    inviteCode = info.code,
    gameInviteNum = info.num,
    unboundGold = info.unboundGold,
    unboundDiamond = info.unboundDiamond,
    createdBy = "admin",
}
local jsonStr = Mod_FarmInvite_ToJson(payload)
log("  " .. tostring(jsonStr))
kv("do dai chuoi JSON", #jsonStr)

hdr("3. KIEM TRA roleId KHONG BI LAM TRON")
kv("roleId (ham tra ve)", info.roleId)
kv("ky vong (T1)", "5945036050158842885")
kv("KHOP?", info.roleId == "5945036050158842885")
log("  --- so sanh cac cach lay ---")
pcall(function()
    local meData = _G.ViewData and _G.ViewData.meData
    local me = _G.RoleManager and _G.RoleManager.me
    local rid = (meData and meData.id) or (me and me.id)
    kv("type(rid)", type(rid))
    kv("tostring(rid)", tostring(rid))
    kv("string.format(%s,rid)", string.format("%s", tostring(rid)))
    kv("string.format(%.0f,rid)", string.format("%.0f", rid))
    kv("tonumber roi tostring", tostring(tonumber(rid)))
    if math and math.type then kv("math.type(rid)", tostring(math.type(rid))) end
end)

hdr("4. KIEM CHUNG Timer.StartLoop (quan trong)")
log("  Dang goi Mod_FarmInvite_WaitVerifyData(5s)...")
log("  Neu thay muc 5 ben duoi => StartLoop CHAY DUOC.")
saveOutput()

Mod_FarmInvite_WaitVerifyData(5, function(ok, info2)
    hdr("5. CALLBACK DA CHAY => Timer.StartLoop HOAT DONG")
    kv("ok (co VerifyData)", ok)
    kv("code", info2.code)
    kv("num", info2.num)
    kv("isCode", info2.isCode)
    log("")
    log("=== KET THUC T1b ===")
    saveOutput()
end)

-- Moc kiem chung rieng cho StartLoop: dem 3 nhip
pcall(function()
    if not (_G.Timer and _G.Timer.StartLoop) then
        log("  [CANH BAO] Timer.StartLoop KHONG TON TAI")
        saveOutput()
        return
    end
    local n = 0
    _G.Timer.StartLoop(1.0, 3, function()
        n = n + 1
        log(string.format("  [StartLoop] nhip %d/3 - OK", n))
        saveOutput()
    end)
end)

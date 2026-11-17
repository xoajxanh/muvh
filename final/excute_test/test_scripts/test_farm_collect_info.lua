-- =========================================================================
-- [TEST SCRIPT T1]: THU THAP TOI DA THONG TIN NHAN VAT (CHI DOC - AN TOAN)
-- Muc dich: Lay het moi thong tin can cho luong FARM KC MA MOI RONG VANG,
--           de doi chieu truoc khi viet ham _G.Mod_FarmInvite_CollectInfo().
-- AN TOAN TUYET DOI: KHONG gui bat ky goi tin nao, KHONG hook, KHONG sua gi.
-- Cach dung: copy file nay vao final\excute_test\input.txt -> push_test -> bam EXEC
--            -> doc ket qua o final\excute_test\output.txt
-- =========================================================================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log("")
    log("==================================================")
    log("  " .. tostring(t))
    log("==================================================")
end
local function kv(k, v) log(string.format("  %-26s = %s", tostring(k), tostring(v))) end

local function saveOutput()
    pcall(function()
        local path = CS.UnityEngine.Application.persistentDataPath .. "/output.txt"
        local f = io.open(path, "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

-- Goi 1 ham doc du lieu, loi thi ghi nhan chu khong lam vo script
local function try(label, fn)
    local ok, err = pcall(fn)
    if not ok then log("  [LOI] " .. tostring(label) .. ": " .. tostring(err)) end
end

local function dumpTable(t, prefix, depth)
    depth = depth or 0
    if type(t) ~= "table" or depth > 2 then return end
    for k, v in pairs(t) do
        if type(v) == "table" then
            log(string.format("%s%s = {table}", prefix, tostring(k)))
            dumpTable(v, prefix .. "   ", depth + 1)
        else
            log(string.format("%s%s = %s", prefix, tostring(k), tostring(v)))
        end
    end
end

log("=== T1: THU THAP THONG TIN NHAN VAT (CHI DOC) ===")
log("Thoi diem: " .. tostring(os.date("%Y-%m-%d %H:%M:%S")))

-- -------------------------------------------------------------------------
-- 1. THONG TIN NHAN VAT
-- -------------------------------------------------------------------------
hdr("1. NHAN VAT (ViewData.meData / RoleManager.me)")
try("nhan vat", function()
    local meData = _G.ViewData and _G.ViewData.meData
    local me = _G.RoleManager and _G.RoleManager.me
    kv("co ViewData.meData", meData ~= nil)
    kv("co RoleManager.me", me ~= nil)
    kv("roleId", (meData and meData.id) or (me and me.id) or "nil")
    kv("roleName", (meData and meData.name) or (me and me.name) or "nil")
    kv("level", (meData and meData.level) or (me and me.level) or "nil")
    kv("masterLevel", (meData and meData.masterLevel) or (me and me.masterLevel) or "nil")
    kv("fight (luc chien)", (meData and meData.fight) or "nil")
    kv("career", (me and me.career) or (meData and meData.career) or "nil")
    kv("isDead", (me and me.isDead) or "nil")
end)

try("ten nghe nghiep", function()
    local me = _G.RoleManager and _G.RoleManager.me
    local meData = _G.ViewData and _G.ViewData.meData
    local career = (me and me.career) or (meData and meData.career) or 0
    if _G.RoleUtility and _G.RoleUtility.GetCareerName then
        kv("careerName", _G.RoleUtility.GetCareerName(career))
    end
end)

try("hp/mp", function()
    local me = _G.RoleManager and _G.RoleManager.me
    if not me then return end
    kv("hp / maxHp", tostring(me.hp) .. " / " .. tostring(me.maxHp))
    kv("mp / maxMp", tostring(me.mp) .. " / " .. tostring(me.maxMp))
end)

try("vi tri + map", function()
    local me = _G.RoleManager and _G.RoleManager.me
    if me then
        local sc = me.serverCoord or me.cellPos
        kv("toa do (x,y)", tostring(sc and sc.x) .. "," .. tostring(sc and sc.y))
    end
    local mapId = (_G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId)) or 0
    kv("mapId", mapId)
    if mapId and mapId > 0 and _G.ClientTable and _G.ClientTable.cfg_Map_mapManager then
        local m = _G.ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
        kv("mapName", m and m.name or "?")
    end
end)

-- -------------------------------------------------------------------------
-- 2. SERVER
-- -------------------------------------------------------------------------
hdr("2. SERVER")
try("GetActualCurrentServerInfo", function()
    if _G.GetActualCurrentServerInfo then
        local sId, sName = _G.GetActualCurrentServerInfo()
        kv("sId  (ban Farm)", sId)
        kv("sName(ban Farm)", sName)
    else
        log("  _G.GetActualCurrentServerInfo = nil")
    end
end)
try("LoginData", function()
    local LD = _G.LoginData
    if not LD then log("  LoginData = nil"); return end
    kv("LoginData.serverId", LD.serverId)
    kv("LoginData.sid", LD.sid)
    kv("LoginData.sdk_pid", LD.sdk_pid)
    kv("LoginData.account", LD.account)
    kv("LoginData.userName", LD.userName)
    if LD.GetServerName then kv("GetServerName()", LD.GetServerName()) end
end)

-- -------------------------------------------------------------------------
-- 3. ACC BOT DANG CHAY (email / password tu danh sach cua ban Farm)
-- -------------------------------------------------------------------------
hdr("3. ACC BOT HIEN TAI (GetCurrentAccount)")
try("acc bot", function()
    local getAcc = _G.GetCurrentAccount
    if not getAcc then log("  _G.GetCurrentAccount = nil"); return end
    local acc = getAcc()
    kv("chi so acc", tostring(_G.CurrentAccountIndex) .. " / " .. tostring(_G.BotAccounts and #_G.BotAccounts))
    if not acc then log("  acc = nil"); return end
    kv("acc.account (email)", acc.account)
    kv("acc.password", acc.password)
    kv("acc.targetServer", acc.targetServer)
    kv("acc.id / acc.stt", tostring(acc.id) .. " / " .. tostring(acc.stt))
end)

-- -------------------------------------------------------------------------
-- 4. TIEN TE - dump TOAN BO de doi chieu
--    Can cho bao cao: 1000020 = Vang KHONG khoa, 1000030 = KC KHONG khoa
-- -------------------------------------------------------------------------
hdr("4. TIEN TE (BagInfoData.CoinInfos)")
try("coin", function()
    local coins = _G.BagInfoData and _G.BagInfoData.CoinInfos
    if not coins then log("  CoinInfos = nil"); return end
    local keys = {}
    for k, _ in pairs(coins) do table.insert(keys, k) end
    table.sort(keys, function(a, b) return (tonumber(a) or 0) < (tonumber(b) or 0) end)
    for _, k in ipairs(keys) do
        local nm = "?"
        pcall(function()
            local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(k))
            nm = it and it.name or "?"
        end)
        local mark = ""
        if tostring(k) == "1000020" then mark = "   <<< VANG KHONG KHOA" end
        if tostring(k) == "1000030" then mark = "   <<< KC KHONG KHOA" end
        log(string.format("  coinId=%-10s value=%-14s ten=%s%s", tostring(k), tostring(coins[k]), tostring(nm), mark))
    end
end)

-- -------------------------------------------------------------------------
-- 5. DU LIEU MA MOI (server tu day goi 1029 khi vao game)
-- -------------------------------------------------------------------------
hdr("5. MA MOI RONG VANG (Task_EarlyGoldManager:GetVerifyData)")
try("verify data", function()
    local mgr = nil
    pcall(function() mgr = _G.QuickFind:GetTask_EarlyGoldManager() end)
    if not mgr then log("  Khong lay duoc Task_EarlyGoldManager"); return end
    local vd = mgr.GetVerifyData and mgr:GetVerifyData()
    if not vd then
        log("  VerifyData = nil  (CHUA nhan goi 1029 - thu doi vai giay roi chay lai)")
        return
    end
    kv("code  (ma moi cua minh)", vd.code ~= nil and vd.code or "nil")
    kv("code rong?", (vd.code == nil or vd.code == ""))
    kv("num   (da moi duoc)", vd.num)
    kv("isCode(da NHAP ma nguoi khac)", vd.isCode)
    log("  --- dump day du ---")
    dumpTable(vd, "    ")
end)

try("dieu kien tao ma", function()
    local func = _G.ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")
    kv("co config func 5100001", func ~= nil)
    if func and _G.ConditionManager and _G.ConditionManager.Check4D then
        kv("du dieu kien [Tao ma] (Lv200)", _G.ConditionManager.Check4D(func.condition))
    end
end)

try("moc thuong", function()
    local mgr = nil
    pcall(function() mgr = _G.QuickFind:GetTask_EarlyGoldManager() end)
    if not mgr then return end
    for _, gid in ipairs({ 6600001, 6600002, 6600003 }) do
        local gift = _G.ClientTable.cfg_Gift_giftManager:TryGetValue(gid)
        local received = gift and mgr.GetRefreshCountFun and mgr:GetRefreshCountFun(gift)
        kv("moc thuong " .. tostring(gid) .. " da nhan", received)
    end
end)

-- -------------------------------------------------------------------------
-- 6. UNG VIEN LAM deviceId (can cho API claim)
-- -------------------------------------------------------------------------
hdr("6. UNG VIEN deviceId")
try("deviceUniqueIdentifier", function()
    kv("SystemInfo.deviceUniqueIdentifier", CS.UnityEngine.SystemInfo.deviceUniqueIdentifier)
end)
try("deviceModel", function()
    kv("SystemInfo.deviceModel", CS.UnityEngine.SystemInfo.deviceModel)
end)
try("deviceName", function()
    kv("SystemInfo.deviceName", CS.UnityEngine.SystemInfo.deviceName)
end)
try("LoginData.account lam deviceId", function()
    kv("LoginData.account", _G.LoginData and _G.LoginData.account)
end)
try("persistentDataPath", function()
    kv("persistentDataPath", CS.UnityEngine.Application.persistentDataPath)
end)

-- -------------------------------------------------------------------------
-- 7. PLAYERPREFS LIEN QUAN FARM (de biet cau hinh hien tai)
-- -------------------------------------------------------------------------
hdr("7. PLAYERPREFS CUA BAN FARM")
try("playerprefs", function()
    local PP = CS.UnityEngine.PlayerPrefs
    kv("Mod_Farm_AccPrefix", PP.GetString("Mod_Farm_AccPrefix", "(chua dat)"))
    kv("Mod_Farm_AccStart", PP.GetInt("Mod_Farm_AccStart", -1))
    kv("Mod_Farm_AccEnd", PP.GetInt("Mod_Farm_AccEnd", -1))
    kv("Mod_Farm_AccPass", PP.GetString("Mod_Farm_AccPass", "(chua dat)"))
    kv("Mod_Farm_TargetServer", PP.GetInt("Mod_Farm_TargetServer", -1))
    kv("Mod_Farm_TargetLevel", PP.GetInt("Mod_Farm_TargetLevel", -1))
    kv("Mod_Farm_CurAccIndex", PP.GetInt("Mod_Farm_CurAccIndex", -1))
    kv("Mod_Farm_WebUsername", PP.GetString("Mod_Farm_WebUsername", "(chua co - se them o P4)"))
    kv("Mod_Farm_InviteMode", PP.GetString("Mod_Farm_InviteMode", "(chua co - se them o P4)"))
end)

-- -------------------------------------------------------------------------
-- 8. KIEM TRA HA TANG MANG (chi kiem tra CO HAY KHONG, khong goi gi)
-- -------------------------------------------------------------------------
hdr("8. HA TANG CAN CHO P5 (chi kiem tra ton tai)")
try("ha tang", function()
    kv("CS.UnityEngine.Networking", CS.UnityEngine.Networking ~= nil)
    kv("UnityWebRequest", CS.UnityEngine.Networking.UnityWebRequest ~= nil)
    kv("UploadHandlerRaw", CS.UnityEngine.Networking.UploadHandlerRaw ~= nil)
    kv("DownloadHandlerBuffer", CS.UnityEngine.Networking.DownloadHandlerBuffer ~= nil)
    kv("_G.Timer", _G.Timer ~= nil)
    kv("_G.Timer.StartLoop", _G.Timer and _G.Timer.StartLoop ~= nil)
    kv("_G.LuaTimer", _G.LuaTimer ~= nil)
    kv("_G.networkRequest", _G.networkRequest ~= nil)
    kv("networkRequest.ReqRoleCode", _G.networkRequest and _G.networkRequest.ReqRoleCode ~= nil)
    kv("networkRequest.ReqRoleVerifyCode", _G.networkRequest and _G.networkRequest.ReqRoleVerifyCode ~= nil)
    kv("_G.UIManager.Show", _G.UIManager and _G.UIManager.Show ~= nil)
end)

try("thoi gian may chu", function()
    if _G.Time and _G.Time.GetServerSecondTime then
        kv("Time.GetServerSecondTime()", _G.Time.GetServerSecondTime())
    end
    kv("os.time()", os.time())
end)

log("")
log("=== KET THUC T1 ===")
saveOutput()

-- Chup lai lan 2 sau 5 giay: phong truong hop goi 1029 ve muon
pcall(function()
    local function second()
        hdr("9. DOC LAI MA MOI SAU 5 GIAY")
        try("verify data lan 2", function()
            local mgr = nil
            pcall(function() mgr = _G.QuickFind:GetTask_EarlyGoldManager() end)
            if not mgr then log("  Khong lay duoc manager"); return end
            local vd = mgr.GetVerifyData and mgr:GetVerifyData()
            if not vd then log("  VerifyData VAN nil sau 5s"); return end
            kv("code", vd.code ~= nil and vd.code or "nil")
            kv("num", vd.num)
            kv("isCode", vd.isCode)
        end)
        log("=== KET THUC (lan 2) ===")
        saveOutput()
    end
    if _G.Timer and _G.Timer.Start then
        _G.Timer.Start(5.0, second)
    elseif _G.LuaTimer and _G.LuaTimer.Add then
        _G.LuaTimer.Add(5000, second)
    end
end)

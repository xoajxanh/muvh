-- =========================================================================
-- [TEST SCRIPT T3b]: DO TIM CACH TAO POST JSON CHAY DUOC TREN XLUA
-- Muc dich: thu 5 cach dung UnityWebRequest POST khac nhau, IN RO LOI tung
--           cach, roi goi that cach nao dung duoc.
-- Chay duoc tren APK hien tai, KHONG can build lai mod.
-- =========================================================================

local BASE_URL = "http://test.guntop.net"
local SALT     = "MUVH_FARM_KC_SALT_2026_XOAI"
local WEB_USER = "admin"

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log(""); log("=================================================="); log("  " .. tostring(t)); log("==================================================")
end
local function kv(k, v) log(string.format("  %-26s = %s", tostring(k), tostring(v))) end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

local N = CS.UnityEngine.Networking

log("=== T3b: DO TIM CACH POST JSON ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))

-- ---------------------------------------------------------------------
-- PHAN A: KIEM TRA CAC LOP / HAM CO TON TAI KHONG
-- ---------------------------------------------------------------------
hdr("A. CAC LOP & HAM CO SAN")
kv("UnityWebRequest", N.UnityWebRequest ~= nil)
kv("UploadHandlerRaw", N.UploadHandlerRaw ~= nil)
kv("DownloadHandlerBuffer", N.DownloadHandlerBuffer ~= nil)
pcall(function() kv("UnityWebRequest.Post", N.UnityWebRequest.Post ~= nil) end)
pcall(function() kv("UnityWebRequest.Put", N.UnityWebRequest.Put ~= nil) end)
pcall(function() kv("UnityWebRequest.Get", N.UnityWebRequest.Get ~= nil) end)
pcall(function() kv("UnityWebRequest.PostWwwForm", N.UnityWebRequest.PostWwwForm ~= nil) end)
saveOutput()

local testUrl = BASE_URL .. "/api/v1/farm/inviter/report"
local testJson = '{"test":1}'
local okBytes, testBytes = pcall(function()
    return CS.System.Text.Encoding.UTF8:GetBytes(testJson)
end)
kv("Tao duoc mang byte UTF8", okBytes)
saveOutput()

-- ---------------------------------------------------------------------
-- PHAN B: THU 5 CACH TAO REQUEST - IN RO LOI
-- ---------------------------------------------------------------------
hdr("B. THU 5 CACH TAO POST REQUEST")

local winner = nil   -- cach nao chay duoc

-- Cach 1: constructor UnityWebRequest(url, "POST")
local ok1, err1 = pcall(function()
    local r = N.UnityWebRequest(testUrl, "POST")
    r.uploadHandler = N.UploadHandlerRaw(testBytes)
    r.downloadHandler = N.DownloadHandlerBuffer()
    r:SetRequestHeader("Content-Type", "application/json")
    r:Dispose()
end)
kv("CACH 1 constructor(url,POST)", ok1)
if not ok1 then log("     loi: " .. tostring(err1)) elseif not winner then winner = 1 end
saveOutput()

-- Cach 2: UnityWebRequest.Post(url, "") roi GAN uploadHandler
local ok2, err2 = pcall(function()
    local r = N.UnityWebRequest.Post(testUrl, "")
    r.uploadHandler = N.UploadHandlerRaw(testBytes)
    r:SetRequestHeader("Content-Type", "application/json")
    r:Dispose()
end)
kv("CACH 2 Post(url,'')+upload", ok2)
if not ok2 then log("     loi: " .. tostring(err2)) elseif not winner then winner = 2 end
saveOutput()

-- Cach 3: UnityWebRequest.Put(url, bytes) roi doi method = POST
local ok3, err3 = pcall(function()
    local r = N.UnityWebRequest.Put(testUrl, testBytes)
    r.method = "POST"
    r.downloadHandler = N.DownloadHandlerBuffer()
    r:SetRequestHeader("Content-Type", "application/json")
    r:Dispose()
end)
kv("CACH 3 Put(url,bytes)+method", ok3)
if not ok3 then log("     loi: " .. tostring(err3)) elseif not winner then winner = 3 end
saveOutput()

-- Cach 4: UnityWebRequest.Post(url, jsonString) - khong gan upload handler
local ok4, err4 = pcall(function()
    local r = N.UnityWebRequest.Post(testUrl, testJson)
    r:SetRequestHeader("Content-Type", "application/json")
    r:Dispose()
end)
kv("CACH 4 Post(url,json) tho", ok4)
if not ok4 then log("     loi: " .. tostring(err4)) elseif not winner then winner = 4 end
saveOutput()

-- Cach 5: tao rong roi gan tung thuoc tinh
local ok5, err5 = pcall(function()
    local r = N.UnityWebRequest()
    r.url = testUrl
    r.method = "POST"
    r.uploadHandler = N.UploadHandlerRaw(testBytes)
    r.downloadHandler = N.DownloadHandlerBuffer()
    r:SetRequestHeader("Content-Type", "application/json")
    r:Dispose()
end)
kv("CACH 5 tao rong + gan", ok5)
if not ok5 then log("     loi: " .. tostring(err5)) elseif not winner then winner = 5 end
saveOutput()

hdr("KET LUAN PHAN B")
if winner then
    log("  >> CACH DUNG DUOC: CACH " .. tostring(winner))
else
    log("  >> KHONG CACH NAO TAO DUOC REQUEST - can doi huong sang GET")
    saveOutput()
    return
end
saveOutput()

-- ---------------------------------------------------------------------
-- PHAN C: GOI THAT BANG CACH TIM DUOC
-- ---------------------------------------------------------------------
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

-- Tao request POST theo cach da tim duoc
local function MakePost(url, jsonStr)
    local bytes = CS.System.Text.Encoding.UTF8:GetBytes(jsonStr)
    local r
    if winner == 1 then
        r = N.UnityWebRequest(url, "POST")
        r.uploadHandler = N.UploadHandlerRaw(bytes)
        r.downloadHandler = N.DownloadHandlerBuffer()
    elseif winner == 2 then
        r = N.UnityWebRequest.Post(url, "")
        r.uploadHandler = N.UploadHandlerRaw(bytes)
        if r.downloadHandler == nil then r.downloadHandler = N.DownloadHandlerBuffer() end
    elseif winner == 3 then
        r = N.UnityWebRequest.Put(url, bytes)
        r.method = "POST"
        r.downloadHandler = N.DownloadHandlerBuffer()
    elseif winner == 4 then
        r = N.UnityWebRequest.Post(url, jsonStr)
    else
        r = N.UnityWebRequest()
        r.url = url
        r.method = "POST"
        r.uploadHandler = N.UploadHandlerRaw(bytes)
        r.downloadHandler = N.DownloadHandlerBuffer()
    end
    r:SetRequestHeader("Content-Type", "application/json")
    r.timeout = 15
    return r
end

-- Thu thap thong tin that
local info = { email="", password="", serverId=0, serverName="", roleId="", roleName="", level=0, code="", num=0, unboundGold=0, unboundDiamond=0 }
pcall(function()
    local a = _G.GetCurrentAccount and _G.GetCurrentAccount()
    if a then info.email = tostring(a.account or ""); info.password = tostring(a.password or "") end
end)
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    local rid = md and md.id
    if rid ~= nil then info.roleId = (string.gsub(tostring(rid), "%.0*$", "")) end
    info.roleName = tostring((md and md.name) or "")
    info.level = tonumber((md and md.level) or 0) or 0
end)
pcall(function()
    if _G.GetActualCurrentServerInfo then
        local s, n = _G.GetActualCurrentServerInfo()
        info.serverId = tonumber(s) or 0; info.serverName = tostring(n or "")
    end
end)
pcall(function()
    local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
    if c then info.unboundGold = tonumber(c[1000020] or 0) or 0; info.unboundDiamond = tonumber(c[1000030] or 0) or 0 end
end)
pcall(function()
    local m = _G.QuickFind and _G.QuickFind:GetTask_EarlyGoldManager()
    local vd = m and m.GetVerifyData and m:GetVerifyData()
    if vd then info.code = tostring(vd.code or ""); info.num = tonumber(vd.num or 0) or 0 end
end)

hdr("C. GOI THAT POST inviter/report BANG CACH " .. tostring(winner))
if info.email == "" or info.serverId == 0 then
    log("  Chua vao game -> bo qua phan C")
    saveOutput()
    return
end

local ts = Now()
local body = {
    email = info.email, password = info.password,
    serverId = info.serverId, serverName = info.serverName,
    roleId = info.roleId, roleName = info.roleName, level = info.level,
    inviteCode = info.code, gameInviteNum = info.num,
    unboundGold = info.unboundGold, unboundDiamond = info.unboundDiamond,
    createdBy = WEB_USER, ts = ts,
    sign = Sign({ info.email, info.serverId, info.roleId, info.code, info.num }, ts),
}
local jsonStr = ToJson(body)
log("  body: " .. jsonStr)
saveOutput()

local okMake, req = pcall(function() return MakePost(BASE_URL .. "/api/v1/farm/inviter/report", jsonStr) end)
if not okMake or not req then
    log("  >> Tao request that bai: " .. tostring(req))
    saveOutput()
    return
end

local finished = false
local okSend = pcall(function() req:SendWebRequest() end)
if not okSend then
    log("  >> SendWebRequest that bai")
    saveOutput()
    return
end

local ticks, timerObj = 0, nil
timerObj = _G.Timer.StartLoop(0.1, 160, function()
    if finished then return end
    ticks = ticks + 1
    local isDone = false
    pcall(function() isDone = req.isDone end)
    if isDone then
        finished = true
        if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
        local raw, code = "", 0
        pcall(function() if req.downloadHandler then raw = req.downloadHandler.text or "" end end)
        pcall(function() code = req.responseCode end)
        log("  HTTP code: " .. tostring(code))
        log("  Tra ve   : " .. tostring(raw))
        if raw ~= "" and string.find(raw, '"ok":true', 1, true) then
            log("")
            log("  ############################################")
            log("  ##  POST JSON CHAY DUOC - CACH " .. tostring(winner) .. "          ##")
            log("  ############################################")
        end
        pcall(function() req:Dispose() end)
        log("=== KET THUC T3b ===")
        saveOutput()
    elseif ticks >= 160 then
        finished = true
        if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
        log("  >> Qua thoi gian cho 16s")
        pcall(function() req:Dispose() end)
        saveOutput()
    end
end)

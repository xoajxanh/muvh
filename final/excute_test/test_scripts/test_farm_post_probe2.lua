-- =========================================================================
-- [TEST SCRIPT T3c]: GO NUT THAT - TAO BODY GUI DI MA KHONG CAN GetBytes
-- Phat hien tu T3b:
--   - Constructor UnityWebRequest(url,"POST") CHAY DUOC (cach 1/3/5 deu ok)
--   - Encoding.UTF8:GetBytes() KHONG CHAY -> "invalid arguments to GetBytes"
-- => Script nay do 6 cach tao body, cach nao duoc thi GOI THAT luon.
-- =========================================================================

local BASE_URL = "http://test.guntop.net"
local SALT     = "MUVH_FARM_KC_SALT_2026_XOAI"
local WEB_USER = "admin"

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log(""); log("=================================================="); log("  " .. tostring(t)); log("==================================================")
end
local function kv(k, v) log(string.format("  %-30s = %s", tostring(k), tostring(v))) end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

local N = CS.UnityEngine.Networking
local testUrl = BASE_URL .. "/api/v1/farm/inviter/report"
local testJson = '{"test":1}'

log("=== T3c: DO CACH TAO BODY (khong dung GetBytes) ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))

-- ---------------------------------------------------------------------
-- PHAN A: 5 CACH LAY MANG BYTE
-- ---------------------------------------------------------------------
hdr("A. CAC CACH TAO MANG BYTE TU CHUOI")
local bytesMaker = nil   -- ham tao bytes neu tim duoc

-- A1: Encoding.UTF8:GetBytes(str)   (cach cu - da biet hong)
local a1ok, a1err = pcall(function()
    local b = CS.System.Text.Encoding.UTF8:GetBytes(testJson)
    if b == nil then error("tra ve nil") end
    return b
end)
kv("A1 Encoding.UTF8:GetBytes", a1ok)
if not a1ok then log("     loi: " .. tostring(a1err))
elseif not bytesMaker then bytesMaker = function(s) return CS.System.Text.Encoding.UTF8:GetBytes(s) end end

-- A2: goi dang static - truyen self thu cong
local a2ok, a2err = pcall(function()
    local enc = CS.System.Text.Encoding.UTF8
    local b = CS.System.Text.Encoding.GetBytes(enc, testJson)
    if b == nil then error("tra ve nil") end
    return b
end)
kv("A2 Encoding.GetBytes(enc,str)", a2ok)
if not a2ok then log("     loi: " .. tostring(a2err))
elseif not bytesMaker then bytesMaker = function(s) return CS.System.Text.Encoding.GetBytes(CS.System.Text.Encoding.UTF8, s) end end

-- A3: tao doi tuong UTF8Encoding moi
local a3ok, a3err = pcall(function()
    local enc = CS.System.Text.UTF8Encoding()
    local b = enc:GetBytes(testJson)
    if b == nil then error("tra ve nil") end
    return b
end)
kv("A3 UTF8Encoding():GetBytes", a3ok)
if not a3ok then log("     loi: " .. tostring(a3err))
elseif not bytesMaker then bytesMaker = function(s) return CS.System.Text.UTF8Encoding():GetBytes(s) end end

-- A4: dung Convert.FromBase64String (ma hoa base64 trong Lua truoc)
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function LuaBase64(data)
    local result = {}
    local len = #data
    for i = 1, len, 3 do
        local b1 = string.byte(data, i)
        local b2 = (i + 1 <= len) and string.byte(data, i + 1) or 0
        local b3 = (i + 2 <= len) and string.byte(data, i + 2) or 0
        local n = (b1 << 16) | (b2 << 8) | b3
        local c1, c2, c3, c4 = (n >> 18) & 63, (n >> 12) & 63, (n >> 6) & 63, n & 63
        table.insert(result, string.sub(b64chars, c1 + 1, c1 + 1))
        table.insert(result, string.sub(b64chars, c2 + 1, c2 + 1))
        table.insert(result, (i + 1 <= len) and string.sub(b64chars, c3 + 1, c3 + 1) or "=")
        table.insert(result, (i + 2 <= len) and string.sub(b64chars, c4 + 1, c4 + 1) or "=")
    end
    return table.concat(result)
end
local a4ok, a4err = pcall(function()
    local b = CS.System.Convert.FromBase64String(LuaBase64(testJson))
    if b == nil then error("tra ve nil") end
    return b
end)
kv("A4 Convert.FromBase64String", a4ok)
if not a4ok then log("     loi: " .. tostring(a4err))
elseif not bytesMaker then bytesMaker = function(s) return CS.System.Convert.FromBase64String(LuaBase64(s)) end end

-- A5: tao mang byte rong roi gan tung phan tu
local a5ok, a5err = pcall(function()
    local arr = CS.System.Array.CreateInstance(typeof(CS.System.Byte), #testJson)
    for i = 1, #testJson do
        arr:SetValue(string.byte(testJson, i), i - 1)
    end
    return arr
end)
kv("A5 Array.CreateInstance + Set", a5ok)
if not a5ok then log("     loi: " .. tostring(a5err))
elseif not bytesMaker then bytesMaker = function(s)
    local arr = CS.System.Array.CreateInstance(typeof(CS.System.Byte), #s)
    for i = 1, #s do arr:SetValue(string.byte(s, i), i - 1) end
    return arr
end end

kv(">> TIM DUOC CACH TAO BYTES", bytesMaker ~= nil)
saveOutput()

-- ---------------------------------------------------------------------
-- PHAN B: DUONG TAT - Put(url, chuoi) KHONG CAN BYTES
-- ---------------------------------------------------------------------
hdr("B. DUONG TAT: Put(url, chuoi) roi doi method = POST")
local putStrOk, putStrErr = pcall(function()
    local r = N.UnityWebRequest.Put(testUrl, testJson)
    if r == nil then error("tra ve nil") end
    r.method = "POST"
    r:Dispose()
end)
kv("B1 Put(url, chuoi)", putStrOk)
if not putStrOk then log("     loi: " .. tostring(putStrErr)) end
saveOutput()

-- ---------------------------------------------------------------------
-- CHON CACH GUI
-- ---------------------------------------------------------------------
hdr("C. CHON CACH GUI")
local mode = nil
if putStrOk then mode = "PUT_STRING"
elseif bytesMaker then mode = "RAW_BYTES" end
kv("Cach se dung", mode or "KHONG CO")
if not mode then
    log("  >> Khong gui duoc body -> phai doi huong sang GET")
    saveOutput()
    return
end
saveOutput()

-- ---------------------------------------------------------------------
-- PHAN D: GOI THAT
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

local function MakePost(url, jsonStr)
    local r
    if mode == "PUT_STRING" then
        r = N.UnityWebRequest.Put(url, jsonStr)
        r.method = "POST"
        r.downloadHandler = N.DownloadHandlerBuffer()
    else
        r = N.UnityWebRequest(url, "POST")
        r.uploadHandler = N.UploadHandlerRaw(bytesMaker(jsonStr))
        r.downloadHandler = N.DownloadHandlerBuffer()
    end
    r:SetRequestHeader("Content-Type", "application/json")
    r.timeout = 15
    return r
end

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

hdr("D. GOI THAT POST inviter/report (" .. mode .. ")")
if info.email == "" or info.serverId == 0 then
    log("  Chua vao game -> dung lai"); saveOutput(); return
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
    log("  >> Tao request that bai: " .. tostring(req)); saveOutput(); return
end

local okSend = pcall(function() req:SendWebRequest() end)
if not okSend then log("  >> SendWebRequest that bai"); saveOutput(); return end

local finished, ticks, timerObj = false, 0, nil
timerObj = _G.Timer.StartLoop(0.1, 170, function()
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
            log("  ##################################################")
            log("  ##   POST CHAY DUOC!  CACH = " .. mode)
            log("  ##################################################")
        end
        pcall(function() req:Dispose() end)
        log("=== KET THUC T3c ===")
        saveOutput()
    elseif ticks >= 170 then
        finished = true
        if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
        log("  >> Qua thoi gian cho 17s")
        pcall(function() req:Dispose() end)
        saveOutput()
    end
end)

-- =========================================================================
-- [TEST SCRIPT T5]: LUONG ACC LV50 (INVITEE) - BAN STANDALONE
-- Chay THU toan bo luong tren APK HIEN TAI, khong can build lai mod.
--   1. Cho du lieu ma moi
--   2. isCode == true -> bao ALREADY_USED -> chuyen acc
--   3. Xin ma tu web  -> het ma -> NO_CODE -> chuyen acc
--   4. Gai bay bat popup loi + gui [Xac minh]
--   5. Theo doi isCode moi giay (toi da 10s)
--   6. Bao ket qua -> go bay -> chuyen acc
--
-- !!! CANH BAO: Buoc 4 NHAP MA THAT vao nhan vat dang dung.
--     Moi nhan vat CHI NHAP DUOC 1 LAN, khong hoan tac duoc.
--     Dat CHO_PHEP_NHAP_MA = false de chi chay thu den buoc xin ma.
-- =========================================================================

-- ====== CAU HINH ======
local BASE_URL = "http://test.guntop.net"
local SALT     = "MUVH_FARM_KC_SALT_2026_XOAI"
local WEB_USER = "admin"
local CHO_VERIFY_DATA  = 10
local CHO_KET_QUA      = 10
local CHO_PHAN_HOI     = 15
local CHO_PHEP_NHAP_MA = true    -- << doi thanh true khi muon nhap ma THAT
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
local function ParseJson(str)
    local obj = {}
    if type(str) ~= "string" then return obj end
    for k, v in string.gmatch(str, '"([^"]-)"%s*:%s*"(.-)"') do obj[k] = (string.gsub(v, '\\"', '"')) end
    for k, v in string.gmatch(str, '"([^"]-)"%s*:%s*(%-?%d+%.?%d*)%s*[,}]') do if obj[k] == nil then obj[k] = tonumber(v) end end
    for k, v in string.gmatch(str, '"([^"]-)"%s*:%s*(%a+)%s*[,}]') do
        if obj[k] == nil then
            if v == "true" then obj[k] = true elseif v == "false" then obj[k] = false end
        end
    end
    return obj
end

local function PostJson(path, body, nhan, onDone)
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
    if not ok or not req then log("  >> Tao request that bai"); saveOutput(); if onDone then onDone(false, {}) end; return end
    local okSend = pcall(function() req:SendWebRequest() end)
    if not okSend then log("  >> Gui that bai"); saveOutput(); if onDone then onDone(false, {}) end; return end

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
            if onDone then pcall(onDone, (tostring(code) == "200"), ParseJson(raw)) end
        elseif ticks >= CHO_PHAN_HOI * 10 + 20 then
            fin = true
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            log("  >> Qua thoi gian cho")
            pcall(function() req:Dispose() end)
            saveOutput()
            if onDone then pcall(onDone, false, {}) end
        end
    end)
end

local function Collect()
    local i = { email="", password="", serverId=0, serverName="", roleId="", roleName="", level=0,
                code="", num=0, isCode=false, unboundGold=0, unboundDiamond=0, deviceId="", hasVerifyData=false }
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
    pcall(function() i.deviceId = tostring(CS.UnityEngine.SystemInfo.deviceUniqueIdentifier or "") end)
    return i
end

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
        if kiemTra(Collect()) then
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            finish(true)
        elseif ticks >= maxTicks then
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            finish(false)
        end
    end)
end

-- Gai bay bat popup
local function HookPopup(onPopup)
    local restore = {}
    pcall(function()
        local UM = _G.UIManager
        if UM and UM.Show then
            local orig = UM.Show
            UM.Show = function(uiId, args, ...)
                pcall(function()
                    if type(args) == "table" and (args.textContent or args.title) then
                        onPopup(tostring(args.textContent or args.title or ""))
                    end
                end)
                return orig(uiId, args, ...)
            end
            table.insert(restore, function() UM.Show = orig end)
        end
    end)
    for _, u in ipairs({ "FloatingTipUtility", "FloatingWordUtility" }) do
        pcall(function()
            local U = _G[u]
            if U and U.QuickMsg then
                local orig = U.QuickMsg
                U.QuickMsg = function(msg, ...) pcall(function() onPopup(tostring(msg or "")) end); return orig(msg, ...) end
                table.insert(restore, function() U.QuickMsg = orig end)
            end
        end)
    end
    return function() for _, f in ipairs(restore) do pcall(f) end end
end

-- ===================== CHAY LUONG =====================
log("=== T5: LUONG ACC LV50 (INVITEE) ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
kv("CHO_PHEP_NHAP_MA", CHO_PHEP_NHAP_MA)

local finished, goBay = false, nil
local function KetThuc(ly_do)
    if finished then return end
    finished = true
    if goBay then pcall(goBay); goBay = nil end
    hdr("KET THUC -> CHUYEN ACC")
    log("  " .. tostring(ly_do))
    log("")
    log("  (Trong mod that, day la luc bot chuyen sang acc ke tiep)")
    log("=== KET THUC T5 ===")
    saveOutput()
end

local function BaoKetQua(info, trangThai, loi, ghiChu)
    hdr("BUOC 6: BAO KET QUA LEN WEB (" .. trangThai .. ")")
    local ts = Now()
    PostJson("/api/v1/farm/invite/result", {
        email = info.email, serverId = info.serverId,
        serverName = info.serverName, roleId = info.roleId,
        roleName = info.roleName, level = info.level,
        inviteCode = info.code or "", status = trangThai,
        errorMsg = loi or "", createdBy = WEB_USER, ts = ts,
        sign = Sign({ info.email, info.serverId, trangThai }, ts),
    }, trangThai, function(ok)
        KetThuc(tostring(ghiChu or trangThai) .. (ok and " | da bao web" or " | LOI bao web"))
    end)
end

hdr("BUOC 1: CHO DU LIEU MA MOI (toi da " .. CHO_VERIFY_DATA .. "s)")
PollUntil(CHO_VERIFY_DATA, function(i) return i.hasVerifyData end, function(co, info)
    kv("Co du lieu", co)
    if not co then KetThuc("Khong nhan duoc du lieu ma moi"); return end

    kv("email", info.email)
    kv("serverId", info.serverId)
    kv("roleName", info.roleName)
    kv("level", info.level)
    kv("isCode (da nhap ma chua)", info.isCode)
    saveOutput()

    hdr("BUOC 2: KIEM TRA DA NHAP MA CHUA")
    if info.isCode == true then
        log("  isCode = true -> acc nay DA NHAP ma tu truoc")
        BaoKetQua(info, "ALREADY_USED", nil, "Acc da nhap ma tu truoc")
        return
    end
    log("  isCode = false -> co the nhap ma")
    saveOutput()

    hdr("BUOC 3: XIN MA TU WEB")
    local ts = Now()
    PostJson("/api/v1/farm/invite/claim", {
        email = info.email, password = info.password,
        serverId = info.serverId, serverName = info.serverName,
        roleId = info.roleId, roleName = info.roleName, level = info.level,
        deviceId = info.deviceId, createdBy = WEB_USER, ts = ts,
        sign = Sign({ info.email, info.serverId, info.deviceId }, ts),
    }, "claim", function(okXin, obj)
        if not okXin then
            if obj and obj.reason == "NO_CODE" then
                KetThuc("Khong con ma cung server -> vong sau thu lai")
            else
                KetThuc("Loi xin ma -> chuyen acc")
            end
            return
        end
        if obj and obj.alreadySuccess == true then
            KetThuc("Web bao acc nay da nhap ma truoc do")
            return
        end

        local maMoi = obj and obj.inviteCode
        kv("Ma nhan duoc", maMoi)
        saveOutput()
        if maMoi == nil or maMoi == "" then KetThuc("Web khong tra ve ma"); return end

        hdr("BUOC 4: NHAP MA + XAC MINH")
        if not CHO_PHEP_NHAP_MA then
            log("  CHO_PHEP_NHAP_MA = false -> DUNG LAI, khong nhap ma that.")
            log("  (Da xin duoc ma tu web -> luong den day la DAT)")
            log("  Doi thanh true neu muon nhap ma that.")
            KetThuc("Dung o buoc 4 theo cau hinh")
            return
        end

        local loiPopup = nil
        goBay = HookPopup(function(noiDung)
            if noiDung and noiDung ~= "" then
                log("  [POPUP GAME] " .. noiDung)
                if string.find(noiDung, "mã mời") or string.find(noiDung, "Mã mời")
                   or string.find(noiDung, "đã dùng") or string.find(noiDung, "lỗi") then
                    loiPopup = noiDung
                end
            end
        end)

        log("  Gui networkRequest.ReqRoleVerifyCode('" .. tostring(maMoi) .. "')")
        saveOutput()
        local okGui = pcall(function() _G.networkRequest.ReqRoleVerifyCode(maMoi) end)
        kv("Goi ReqRoleVerifyCode", okGui)
        if not okGui then
            info.code = maMoi
            BaoKetQua(info, "FAILED", "Goi ReqRoleVerifyCode that bai", "Loi goi tin")
            return
        end

        hdr("BUOC 5: THEO DOI isCode (toi da " .. CHO_KET_QUA .. "s)")
        local ticks, tObj, xong = 0, nil, false
        local function ketThucTheoDoi(tt, loi, ghiChu)
            if xong then return end
            xong = true
            if tObj and tObj.Stop then pcall(function() tObj:Stop() end) end
            local moi = Collect()
            moi.code = maMoi
            BaoKetQua(moi, tt, loi, ghiChu)
        end
        tObj = _G.Timer.StartLoop(1.0, CHO_KET_QUA, function()
            if xong or finished then return end
            ticks = ticks + 1
            local cur = Collect()
            log(string.format("  giay %d: isCode = %s", ticks, tostring(cur.isCode)))
            saveOutput()
            if cur.isCode == true then
                ketThucTheoDoi("SUCCESS", nil, "NHAP MA THANH CONG: " .. tostring(maMoi))
            elseif loiPopup ~= nil then
                ketThucTheoDoi("FAILED", loiPopup, "Game bao loi")
            elseif ticks >= CHO_KET_QUA then
                ketThucTheoDoi("FAILED", "Qua han " .. CHO_KET_QUA .. "s", "Khong xac nhan duoc")
            end
        end)
    end)
end)

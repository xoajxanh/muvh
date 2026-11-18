-- =========================================================================
-- [TEST SCRIPT T9]: BAT GOI TIN KHI MUA GOI BANG KIM PHIEU
-- Muc dich: KHONG doan nua - gai bay ghi lai CHINH XAC game gui gi khi anh
--           bam mua goi "60 kim cuong / 25K" o tab "Mua truc tiep Kim Phieu".
--
-- CACH DUNG:
--   1. Bam EXEC chay script nay (no se gai bay va mo san popup)
--   2. VAO GAME, tu tay bam mua goi 60 kim cuong bang Kim Phieu
--   3. Keo log ve -> se thay message ID + noi dung goi tin da gui
--
-- Script CHI GHI LAI, khong tu mua gi.
-- Bay tu go sau 180 giay.
-- =========================================================================

local TU_MO_POPUP = true    -- true = tu mo san popup Phuc loi/Cong dong

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t) log(""); log("=================================================="); log("  " .. t); log("==================================================") end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

local function dumpTbl(t, prefix, depth)
    depth = depth or 0
    if type(t) ~= "table" or depth > 3 then return end
    for k, v in pairs(t) do
        if type(v) == "table" then
            log(string.format("%s%s = {", prefix, tostring(k)))
            dumpTbl(v, prefix .. "    ", depth + 1)
            log(prefix .. "}")
        elseif type(v) ~= "function" then
            log(string.format("%s%s = %s", prefix, tostring(k), tostring(v)))
        end
    end
end

log("=== T9: BAT GOI TIN KHI MUA GOI BANG KIM PHIEU ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)

-- So Kim Phieu truoc khi mua
local function soKimPhieu()
    local n = 0
    pcall(function()
        if _G.BagInfoData and _G.BagInfoData.GetItemByConfigID then
            local it = _G.BagInfoData.GetItemByConfigID(1000250)
            if it then n = tonumber(it.count or 0) or 0 end
        end
    end)
    return n
end
log("Kim Phieu hien co: " .. tostring(soKimPhieu()))
saveOutput()

-- ---------------------------------------------------------------
hdr("1. GAI BAY BAT GOI TIN GUI DI (NetManager.Send)")
local restore = {}
pcall(function()
    local NM = _G.NetManager
    if NM and NM.Send then
        local orig = NM.Send
        NM.Send = function(msgId, data, ...)
            pcall(function()
                local ten = ""
                pcall(function() ten = tostring(_G.MessageIDToName and _G.MessageIDToName[msgId] or "") end)
                -- chi ghi cac goi lien quan nap (20000-20099)
                local idSo = tonumber(msgId) or 0
                if idSo >= 20000 and idSo <= 20099 then
                    log("")
                    log(string.format(">>> GUI DI: msgId=%s  (%s)", tostring(msgId), ten))
                    if type(data) == "table" then
                        dumpTbl(data, "      ")
                    else
                        log("      data = " .. tostring(data))
                    end
                    saveOutput()
                end
            end)
            return orig(msgId, data, ...)
        end
        table.insert(restore, function() NM.Send = orig end)
        log("  Da gai bay NetManager.Send")
    else
        log("  !!! Khong tim thay NetManager.Send")
    end
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("2. GAI BAY BAT UI MO RA")
pcall(function()
    local UM = _G.UIManager
    if UM and UM.Show then
        local orig = UM.Show
        UM.Show = function(uiId, args, ...)
            pcall(function()
                log(string.format("  [UI MO] %s", tostring(uiId)))
                if type(args) == "table" then dumpTbl(args, "        ") end
                saveOutput()
            end)
            return orig(uiId, args, ...)
        end
        table.insert(restore, function() UM.Show = orig end)
        log("  Da gai bay UIManager.Show")
    end
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("3. DUMP BANG GOI NAP - TIM GOI 60 KIM CUONG")
pcall(function()
    local mgr = _G.ClientTable and _G.ClientTable.cfg_Recharge_rechargeManager
    if not mgr then log("  Khong co cfg_Recharge_rechargeManager"); return end
    local daIn = 0
    -- duyet nhieu type de tim
    for lType = 1, 40 do
        local ok, ds = pcall(function() return mgr:BaseGetTabListByType(lType, "type") end)
        if ok and ds then
            local co = false
            for _, v in pairs(ds) do
                pcall(function()
                    local dia = tonumber(v.diamond or v.gold or 0) or 0
                    local rmb = tonumber(v.rmb or v.price or 0) or 0
                    -- in cac goi nho (de tim goi 60 KC / 25K)
                    if dia == 60 or rmb == 25000 or rmb == 25 then
                        if not co then log("  --- type = " .. lType .. " ---"); co = true end
                        daIn = daIn + 1
                        local s = "      "
                        for k2, v2 in pairs(v) do
                            if type(v2) ~= "table" and type(v2) ~= "function" then
                                s = s .. tostring(k2) .. "=" .. tostring(v2) .. "  "
                            end
                        end
                        log(s)
                    end
                end)
            end
        end
    end
    log("  (tim thay " .. daIn .. " goi khop dieu kien 60 KC hoac 25K)")
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("4. MO POPUP")
if TU_MO_POPUP then
    local ok = pcall(function()
        _G.UIManager.Show(_G.UIID.RechargeWelfareUI, { openFirstTab = 4 })
    end)
    log("  Mo RechargeWelfareUI (openFirstTab=4): " .. tostring(ok))
    log("")
    log("  >>> GIO ANH TU TAY BAM MUA GOI 60 KIM CUONG BANG KIM PHIEU <<<")
    log("  >>> Bay se ghi lai goi tin game gui di                      <<<")
else
    log("  TU_MO_POPUP = false -> khong mo")
end
saveOutput()

-- ---------------------------------------------------------------
-- Tu go bay sau 180 giay
pcall(function()
    if not (_G.Timer and _G.Timer.StartLoop) then return end
    local n, t = 0, nil
    t = _G.Timer.StartLoop(10.0, 19, function()
        n = n + 1
        if n >= 18 then
            if t and t.Stop then pcall(function() t:Stop() end) end
            for _, f in ipairs(restore) do pcall(f) end
            hdr("5. DA GO BAY (sau 180s)")
            log("  Kim Phieu con lai: " .. tostring(soKimPhieu()))
            log("=== KET THUC T9 ===")
            saveOutput()
        end
    end)
end)

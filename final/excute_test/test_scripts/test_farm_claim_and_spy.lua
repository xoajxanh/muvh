-- =========================================================================
-- [TEST SCRIPT T10]: NHAN THUONG MOC + GAI BAY BAT LENH MUA
-- Gop 2 viec:
--   1. Nhan cac moc thuong mời bạn bè con nhan duoc (de co Kim Phieu)
--   2. Gai bay, mo popup Cong dong de anh bam mua -> ghi lai lenh gui di
-- Chay tren acc co nguoi moi nhung CHUA nhan thuong (vd Tedyg4).
-- Bay song 300 giay.
-- =========================================================================

local SONG_BAO_LAU = 300

local header, body = {}, {}
local function ghi(m) table.insert(body, tostring(m)) end
local function batDuoc(m) table.insert(header, tostring(m)) end

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

local function saveOutput()
    pcall(function()
        local out = {}
        table.insert(out, "##################################################")
        table.insert(out, "#   LENH MUA BAT DUOC (quan trong nhat)          #")
        table.insert(out, "##################################################")
        if #header == 0 then
            table.insert(out, "  (chua bat duoc lenh mua nao)")
        else
            for _, l in ipairs(header) do table.insert(out, l) end
        end
        table.insert(out, "")
        table.insert(out, "##################################################")
        table.insert(out, "#   DIEN BIEN                                     #")
        table.insert(out, "##################################################")
        for _, l in ipairs(body) do table.insert(out, l) end
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(out, "\n")); f:close() end
    end)
end

ghi("=== T10: NHAN THUONG + BAT LENH MUA ===")
ghi("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    ghi("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)

local soNguoiMoi = 0
pcall(function()
    local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
    local vd = mgr and mgr:GetVerifyData()
    if vd then soNguoiMoi = tonumber(vd.num) or 0 end
end)
ghi("So nguoi da moi: " .. tostring(soNguoiMoi))
ghi("Kim Phieu ban dau: " .. tostring(soKimPhieu()))
saveOutput()

-- ---------- GAI BAY TRUOC ----------
local restore = {}
pcall(function()
    local NM = _G.NetManager
    if not (NM and NM.Send) then ghi("  !!! Khong co NetManager.Send"); return end
    local orig = NM.Send
    NM.Send = function(msgId, data, ...)
        pcall(function()
            local idSo = tonumber(msgId) or 0
            if idSo >= 20000 and idSo <= 20099 and type(data) == "table" then
                local co = false
                for _ in pairs(data) do co = true break end
                if co then
                    local ten = ""
                    pcall(function() ten = tostring(_G.MessageIDToName and _G.MessageIDToName[msgId] or "") end)
                    batDuoc("")
                    batDuoc(string.format(">>> msgId = %s   (%s)", tostring(msgId), ten))
                    for k, v in pairs(data) do
                        if type(v) == "table" then
                            local s = "      " .. tostring(k) .. " = { "
                            for k2, v2 in pairs(v) do
                                if type(v2) ~= "table" and type(v2) ~= "function" then
                                    s = s .. tostring(k2) .. "=" .. tostring(v2) .. " "
                                end
                            end
                            batDuoc(s .. "}")
                        elseif type(v) ~= "function" then
                            batDuoc(string.format("      %s = %s", tostring(k), tostring(v)))
                        end
                    end
                    batDuoc("      [Kim Phieu luc nay: " .. tostring(soKimPhieu()) .. "]")
                    saveOutput()
                end
            end
        end)
        return orig(msgId, data, ...)
    end
    table.insert(restore, function() NM.Send = orig end)
end)

pcall(function()
    local UM = _G.UIManager
    if not (UM and UM.Show) then return end
    local orig = UM.Show
    UM.Show = function(uiId, args, ...)
        pcall(function() ghi("  [UI MO] " .. tostring(uiId)) end)
        return orig(uiId, args, ...)
    end
    table.insert(restore, function() UM.Show = orig end)
end)
ghi("  Da gai bay")
saveOutput()

-- ---------- BUOC 1: NHAN CAC MOC THUONG CON NHAN DUOC ----------
local CAN_MOI = { [6600001] = 1, [6600002] = 3, [6600003] = 5 }
local dsNhan = {}
pcall(function()
    local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
    local g = _G.ClientTable.cfg_Global_globalManager:TryGetValue(68000001)
    if not (mgr and g and g.effect) then return end
    for v in string.gmatch(tostring(g.effect), "[^#]+") do
        local gift = _G.ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(v))
        if gift then
            local can = CAN_MOI[tonumber(gift.id)] or 0
            local daNhan = false
            pcall(function() daNhan = (mgr:GetRefreshCountFun(gift) == true) end)
            ghi(string.format("  moc %s: can %d nguoi | da nhan=%s", tostring(gift.id), can, tostring(daNhan)))
            if soNguoiMoi >= can and not daNhan then table.insert(dsNhan, gift) end
        end
    end
end)
ghi("  So moc se nhan: " .. tostring(#dsNhan))
saveOutput()

local function moPopup()
    local ok = pcall(function()
        _G.UIManager.Show(_G.UIID.RechargeWelfareUI, { openFirstTab = 4 })
    end)
    ghi("")
    ghi("  Kim Phieu sau khi nhan thuong: " .. tostring(soKimPhieu()))
    ghi("  Mo popup Cong dong: " .. tostring(ok))
    ghi("")
    ghi("  >>> VAO TAB 'MUA TRUC TIEP KIM PHIEU' VA BAM MUA GOI 60 KIM CUONG <<<")
    ghi("  >>> Bay song " .. SONG_BAO_LAU .. " giay <<<")
    saveOutput()
end

if #dsNhan == 0 then
    ghi("  Khong con moc nao de nhan -> mo popup luon")
    moPopup()
else
    local i = 0
    local function guiTiep()
        i = i + 1
        if i > #dsNhan then
            -- cho 2s roi mo popup
            local n, t = 0, nil
            t = _G.Timer.StartLoop(0.5, 6, function()
                n = n + 1
                if n >= 4 then
                    if t and t.Stop then pcall(function() t:Stop() end) end
                    moPopup()
                end
            end)
            return
        end
        local gift = dsNhan[i]
        local ok = pcall(function() _G.networkRequest.ReqGetGift({ gift.id }) end)
        ghi(string.format("  Nhan moc %s -> %s", tostring(gift.id), tostring(ok)))
        saveOutput()
        local n, t = 0, nil
        t = _G.Timer.StartLoop(0.5, 4, function()
            n = n + 1
            if n >= 3 then
                if t and t.Stop then pcall(function() t:Stop() end) end
                guiTiep()
            end
        end)
    end
    guiTiep()
end

-- ---------- Tu go bay ----------
pcall(function()
    if not (_G.Timer and _G.Timer.StartLoop) then return end
    local n, t = 0, nil
    local soNhip = math.floor(SONG_BAO_LAU / 10)
    t = _G.Timer.StartLoop(10.0, soNhip + 1, function()
        n = n + 1
        if n >= soNhip then
            if t and t.Stop then pcall(function() t:Stop() end) end
            for _, f in ipairs(restore) do pcall(f) end
            ghi("")
            ghi("=== DA GO BAY ===")
            ghi("Kim Phieu cuoi cung: " .. tostring(soKimPhieu()))
            saveOutput()
        end
    end)
end)

-- =========================================================================
-- [TEST SCRIPT T9b]: BAT GOI TIN MUA GOI - BAN GON
-- Khac ban truoc:
--   - KHONG dump bang goi nap va noi dung UI (log truoc dai 49KB bi troi)
--   - Cac goi tin gui di duoc gom rieng va in o DAU file -> khong bao gio mat
--   - Bay song 300 giay (5 phut)
-- CACH DUNG: bam EXEC -> vao game bam mua -> keo log
-- =========================================================================

local SONG_BAO_LAU = 300   -- giay

local header = {}     -- phan dau: cac goi tin bat duoc
local body = {}       -- phan sau: dien bien

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
        table.insert(out, "#   CAC GOI TIN DA BAT DUOC (quan trong nhat)    #")
        table.insert(out, "##################################################")
        if #header == 0 then
            table.insert(out, "  (chua bat duoc goi nao - anh da bam mua chua?)")
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

ghi("=== T9b: BAT GOI TIN MUA GOI BANG KIM PHIEU ===")
ghi("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    ghi("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)
local kpTruoc = soKimPhieu()
ghi("Kim Phieu TRUOC khi mua: " .. tostring(kpTruoc))

-- ---------- Gai bay ----------
local restore = {}

pcall(function()
    local NM = _G.NetManager
    if not (NM and NM.Send) then ghi("  !!! Khong co NetManager.Send"); return end
    local orig = NM.Send
    NM.Send = function(msgId, data, ...)
        pcall(function()
            local idSo = tonumber(msgId) or 0
            -- bo qua cac goi hoi thong tin dinh ky, chi giu goi co DU LIEU
            if idSo >= 20000 and idSo <= 20099 and type(data) == "table" then
                local coDuLieu = false
                for _ in pairs(data) do coDuLieu = true break end
                if coDuLieu then
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
    ghi("  Da gai bay NetManager.Send")
end)

-- Chi ghi TEN UI, khong dump noi dung (tranh log dai)
pcall(function()
    local UM = _G.UIManager
    if not (UM and UM.Show) then return end
    local orig = UM.Show
    UM.Show = function(uiId, args, ...)
        pcall(function() ghi("  [UI MO] " .. tostring(uiId)) end)
        return orig(uiId, args, ...)
    end
    table.insert(restore, function() UM.Show = orig end)
    ghi("  Da gai bay UIManager.Show (chi ghi ten)")
end)

-- ---------- Mo popup ----------
local ok = pcall(function()
    _G.UIManager.Show(_G.UIID.RechargeWelfareUI, { openFirstTab = 4 })
end)
ghi("  Mo popup Cong dong: " .. tostring(ok))
ghi("")
ghi("  >>> VAO TAB 'MUA TRUC TIEP KIM PHIEU' VA BAM MUA <<<")
ghi("  >>> Bay song " .. SONG_BAO_LAU .. " giay <<<")
saveOutput()

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
            ghi("Kim Phieu SAU: " .. tostring(soKimPhieu()) .. "  (truoc: " .. tostring(kpTruoc) .. ")")
            saveOutput()
        end
    end)
end)

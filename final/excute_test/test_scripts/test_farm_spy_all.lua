-- =========================================================================
-- [TEST SCRIPT T11]: BAT **MOI** GOI TIN GUI DI (khong loc ma)
-- Ban truoc chi loc ma 20000-20099 nen bo sot lenh mua.
-- Ban nay:
--   - Bat TAT CA msgId co du lieu
--   - Theo doi so Kim Phieu moi 1 giay; khi THAY DOI thi danh dau ro
--   - Giu 60 goi gan nhat, in o dau file
--   - Bat them Http.Request (phong truong hop di qua SDK)
-- Bay song 300 giay.
-- =========================================================================

local SONG_BAO_LAU = 300

local goiTin = {}     -- danh sach goi bat duoc (toi da 60)
local body = {}
local function ghi(m) table.insert(body, tostring(m)) end

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

local kpHienTai = soKimPhieu()

local function themGoi(dong)
    table.insert(goiTin, dong)
    if #goiTin > 60 then table.remove(goiTin, 1) end
end

local function saveOutput()
    pcall(function()
        local out = {}
        table.insert(out, "##################################################")
        table.insert(out, "#   MOI GOI TIN GUI DI (60 goi gan nhat)         #")
        table.insert(out, "##################################################")
        if #goiTin == 0 then
            table.insert(out, "  (chua bat duoc goi nao)")
        else
            for _, l in ipairs(goiTin) do table.insert(out, l) end
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

ghi("=== T11: BAT MOI GOI TIN ===")
ghi("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    ghi("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)
ghi("Kim Phieu ban dau: " .. tostring(kpHienTai))
saveOutput()

local restore = {}

-- ---------- Bat MOI goi tin ----------
pcall(function()
    local NM = _G.NetManager
    if not (NM and NM.Send) then ghi("  !!! Khong co NetManager.Send"); return end
    local orig = NM.Send
    NM.Send = function(msgId, data, ...)
        pcall(function()
            local ten = ""
            pcall(function() ten = tostring(_G.MessageIDToName and _G.MessageIDToName[msgId] or "") end)
            local s = string.format("  msgId=%-8s %s", tostring(msgId), ten)
            if type(data) == "table" then
                local noiDung = ""
                for k, v in pairs(data) do
                    if type(v) == "table" then
                        noiDung = noiDung .. tostring(k) .. "={"
                        for k2, v2 in pairs(v) do
                            if type(v2) ~= "table" and type(v2) ~= "function" then
                                noiDung = noiDung .. tostring(k2) .. "=" .. tostring(v2) .. " "
                            end
                        end
                        noiDung = noiDung .. "} "
                    elseif type(v) ~= "function" then
                        noiDung = noiDung .. tostring(k) .. "=" .. tostring(v) .. "  "
                    end
                end
                if noiDung ~= "" then s = s .. "  |  " .. noiDung end
            end
            themGoi(s)
            saveOutput()
        end)
        return orig(msgId, data, ...)
    end
    table.insert(restore, function() NM.Send = orig end)
    ghi("  Da gai bay NetManager.Send (BAT TAT CA)")
end)

-- ---------- Bat Http.Request (phong SDK) ----------
pcall(function()
    local H = _G.Http
    if not (H and H.Request) then return end
    local orig = H.Request
    H.Request = function(...)
        local args = { ... }
        pcall(function()
            local s = "  [HTTP] "
            for i = 1, math.min(#args, 3) do
                if type(args[i]) ~= "table" and type(args[i]) ~= "function" then
                    s = s .. tostring(args[i]) .. "  "
                end
            end
            themGoi(s)
            saveOutput()
        end)
        return orig(table.unpack(args))
    end
    table.insert(restore, function() H.Request = orig end)
    ghi("  Da gai bay Http.Request")
end)

-- ---------- Mo popup ----------
local ok = pcall(function()
    _G.UIManager.Show(_G.UIID.RechargeWelfareUI, { openFirstTab = 4 })
end)
ghi("  Mo popup: " .. tostring(ok))
ghi("")
ghi("  >>> BAM MUA GOI 60 KIM CUONG BANG KIM PHIEU <<<")
ghi("  >>> Bay song " .. SONG_BAO_LAU .. " giay <<<")
saveOutput()

-- ---------- Theo doi Kim Phieu moi giay ----------
pcall(function()
    if not (_G.Timer and _G.Timer.StartLoop) then return end
    local n, t = 0, nil
    t = _G.Timer.StartLoop(1.0, SONG_BAO_LAU + 5, function()
        n = n + 1
        local kp = soKimPhieu()
        if kp ~= kpHienTai then
            themGoi("")
            themGoi(string.format("  ******** KIM PHIEU THAY DOI: %s -> %s  (giay thu %d) ********",
                tostring(kpHienTai), tostring(kp), n))
            themGoi("  ^^^ LENH MUA LA GOI NGAY TRUOC DONG NAY ^^^")
            themGoi("")
            kpHienTai = kp
            saveOutput()
        end
        if n >= SONG_BAO_LAU then
            if t and t.Stop then pcall(function() t:Stop() end) end
            for _, f in ipairs(restore) do pcall(f) end
            ghi("")
            ghi("=== DA GO BAY ===")
            ghi("Kim Phieu cuoi: " .. tostring(soKimPhieu()))
            saveOutput()
        end
    end)
end)

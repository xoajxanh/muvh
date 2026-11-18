-- =========================================================================
-- [TEST SCRIPT T13]: NHAN VAT PHAM TRONG THU
-- Nguon: Mail_MailUI.lua - nut "Nhan tat ca" = NetManager.Send(3006) khong tham so
-- CHE DO:
--   "VIEW"  = chi liet ke thu dang co (AN TOAN)
--   "CLAIM" = gui lenh nhan TAT CA thu
-- =========================================================================

local MODE = "CLAIM"     -- << doi thanh "CLAIM" de nhan that

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function kv(k, v) log(string.format("  %-26s = %s", tostring(k), tostring(v))) end
local function hdr(t) log(""); log("=================================================="); log("  " .. t); log("==================================================") end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

local function soKimCuong()
    local n = 0
    pcall(function()
        local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
        if c then n = tonumber(c[1000030] or 0) or 0 end
    end)
    return n
end
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

local function danhSachThu()
    local ds = {}
    pcall(function()
        if _G.MailData and _G.MailData.TotalMail then
            for _, v in pairs(_G.MailData.TotalMail) do table.insert(ds, v) end
        end
    end)
    return ds
end

log("=== T13: NHAN VAT PHAM TRONG THU - MODE: " .. MODE .. " ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)
kv("KC khong khoa truoc", soKimCuong())
kv("Kim Phieu truoc", soKimPhieu())
saveOutput()

-- Tai danh sach thu
hdr("1. TAI DANH SACH THU")
local okTai = pcall(function()
    if _G.networkRequest and _G.networkRequest.ReqGetMailList then
        _G.networkRequest.ReqGetMailList()
    else
        _G.NetManager.Send(_G.MailMessage.ReqGetMailList)
    end
end)
kv("Gui ReqGetMailList", okTai)
saveOutput()

-- Cho 2s roi liet ke
local n, t = 0, nil
t = _G.Timer.StartLoop(0.5, 8, function()
    n = n + 1
    if n < 4 then return end
    if t and t.Stop then pcall(function() t:Stop() end) end

    hdr("2. DANH SACH THU DANG CO")
    local ds = danhSachThu()
    kv("So thu", #ds)
    for i, m in ipairs(ds) do
        local s = string.format("  [%d] ", i)
        pcall(function()
            s = s .. "mailId=" .. tostring(m.mailId)
            if m.title then s = s .. " | title=" .. tostring(m.title) end
            if m.rechargeId then s = s .. " | rechargeId=" .. tostring(m.rechargeId) end
            if m.stateType then s = s .. " | stateType=" .. tostring(m.stateType) end
        end)
        log(s)
    end
    saveOutput()

    if MODE ~= "CLAIM" then
        hdr("3. CHE DO VIEW - KHONG NHAN GI")
        log("  Doi MODE = \"CLAIM\" de gui lenh nhan tat ca thu.")
        log("=== KET THUC T13 ===")
        saveOutput()
        return
    end

    hdr("3. LOC VA GUI LENH NHAN THU")
    -- Chi nhan thu CON vat pham (stateType 1 hoac 3).
    -- CHI_THU_NAP = true -> chi nhan thu nap (rechargeId ~= 0), khong dung thu khac
    local CHI_THU_NAP = true
    local dsNhan = {}
    for _, m in ipairs(ds) do
        local tt = tonumber(m.stateType) or 0
        local rid = tonumber(m.rechargeId) or 0
        if tt == 1 or tt == 3 then
            if (not CHI_THU_NAP) or rid ~= 0 then
                table.insert(dsNhan, m.mailId)
                log(string.format("  se nhan: mailId=%s | rechargeId=%s | stateType=%s",
                    tostring(m.mailId), tostring(rid), tostring(tt)))
            end
        end
    end
    kv("So thu se nhan", #dsNhan)
    if #dsNhan == 0 then
        log("  Khong co thu nao can nhan -> ket thuc")
        log("=== KET THUC T13 ===")
        saveOutput()
        return
    end

    local ok = pcall(function()
        _G.NetManager.Send(_G.MailMessage.ReqGetMailItems, {
            mailIds = dsNhan,
            delete = false,
        })
    end)
    kv("Gui ReqGetMailItems", ok)
    saveOutput()

    -- cho 3s roi kiem tra lai
    local n2, t2 = 0, nil
    t2 = _G.Timer.StartLoop(0.5, 10, function()
        n2 = n2 + 1
        if n2 < 6 then return end
        if t2 and t2.Stop then pcall(function() t2:Stop() end) end
        hdr("4. KIEM TRA LAI SAU KHI NHAN")
        kv("So thu con lai", #danhSachThu())
        kv("KC khong khoa SAU", soKimCuong())
        kv("Kim Phieu SAU", soKimPhieu())
        log("")
        log("  (KC tang = da nhan duoc goi 60 kim cuong tu thu)")
        log("=== KET THUC T13 ===")
        saveOutput()
    end)
end)

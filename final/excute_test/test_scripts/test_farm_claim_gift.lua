-- =========================================================================
-- [TEST SCRIPT T6]: NHAN THUONG MOC MOI BAN BE (5000 / 10K / 15K KIM PHIEU)
-- Nguon: InviteReward_ItemTemplate.lua + Task_EarlyGoldData.lua
--   - Danh sach moc: cfg_Global_globalManager:TryGetValue(68000001).effect
--                    tach bang "#" -> cfg_Gift_giftManager:TryGetValue(id)
--   - Dieu kien   : VerifyData.num >= targetNum (1 / 3 / 5) VA chua nhan
--   - Da nhan chua: RefreshData.GetRefreshByKey(gift.countKey) -> total == count
--   - Nhan        : networkRequest.ReqGetGift({ gift.id })
--
-- CHE DO:
--   "VIEW"  = chi doc, khong nhan gi (AN TOAN)
--   "CLAIM" = nhan THAT tat ca moc du dieu kien
-- =========================================================================

local MODE = "CLAIM"          -- << doi thanh "CLAIM" de nhan that

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

log("=== T6: NHAN THUONG MOC MOI BAN BE - MODE: " .. MODE .. " ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))

-- ---------- 1. Thong tin nhan vat + so nguoi da moi ----------
hdr("1. THONG TIN")
local soNguoiMoi = 0
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    kv("roleName", md and md.name or "?")
    kv("level", md and md.level or "?")
end)
pcall(function()
    local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
    local vd = mgr and mgr.GetVerifyData and mgr:GetVerifyData()
    if vd then
        soNguoiMoi = tonumber(vd.num) or 0
        kv("ma moi", vd.code)
        kv("so nguoi da moi (num)", soNguoiMoi)
        kv("isCode", vd.isCode)
    else
        log("  !!! Khong doc duoc VerifyData")
    end
end)
saveOutput()

-- ---------- 2. Doc danh sach moc tu cau hinh game ----------
hdr("2. DANH SACH MOC THUONG (tu cfg_Global 68000001)")
local dsMoc = {}
pcall(function()
    local g = _G.ClientTable.cfg_Global_globalManager:TryGetValue(68000001)
    if not g then log("  Khong doc duoc cfg_Global 68000001"); return end
    kv("chuoi effect", g.effect)
    local parts = _G.string.split and _G.string.split(g.effect, "#") or nil
    if not parts then
        -- tu tach neu khong co string.split
        parts = {}
        for s in string.gmatch(tostring(g.effect), "[^#]+") do table.insert(parts, s) end
    end
    for _, v in ipairs(parts) do
        local gift = _G.ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(v))
        if gift then table.insert(dsMoc, gift) end
    end
end)
kv("so moc doc duoc", #dsMoc)
saveOutput()

-- Bang doi chieu so nguoi can moi (tu InviteReward_ItemTemplate)
local CAN_MOI = { [6600001] = 1, [6600002] = 3, [6600003] = 5 }

-- ---------- 3. Trang thai tung moc ----------
hdr("3. TRANG THAI TUNG MOC")
local dsCoTheNhan = {}
for i, gift in ipairs(dsMoc) do
    local id = tonumber(gift.id)
    local can = CAN_MOI[id] or 0
    local daNhan = false
    pcall(function()
        local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
        if mgr and mgr.GetRefreshCountFun then daNhan = mgr:GetRefreshCountFun(gift) == true end
    end)
    local duNguoi = (soNguoiMoi >= can)
    local coTheNhan = duNguoi and (not daNhan)

    log(string.format("  [Moc %d] giftId=%s | can moi %d nguoi", i, tostring(id), can))
    log(string.format("           du nguoi: %-5s | da nhan: %-5s | CO THE NHAN: %s",
        tostring(duNguoi), tostring(daNhan), tostring(coTheNhan)))

    -- dump them thong tin gift de hieu cau truc
    pcall(function()
        kv("           countKey", gift.countKey)
        if _G.RefreshData and _G.RefreshData.GetRefreshByKey then
            local rd = _G.RefreshData.GetRefreshByKey(tonumber(gift.countKey))
            if rd then
                log(string.format("           RefreshData: total=%s count=%s", tostring(rd.total), tostring(rd.count)))
            else
                log("           RefreshData: nil")
            end
        end
    end)

    if coTheNhan then table.insert(dsCoTheNhan, gift) end
end
kv("So moc co the nhan ngay", #dsCoTheNhan)
saveOutput()

-- ---------- 4. Nhan that ----------
hdr("4. NHAN THUONG")
if MODE ~= "CLAIM" then
    log("  MODE = VIEW -> chi doc, khong nhan gi.")
    log("  Doi MODE = \"CLAIM\" de nhan that.")
    log("=== KET THUC T6 ===")
    saveOutput()
    return
end

if #dsCoTheNhan == 0 then
    log("  Khong co moc nao du dieu kien -> khong nhan gi.")
    log("=== KET THUC T6 ===")
    saveOutput()
    return
end

-- Bat thong bao game de xem server tra ve gi
local goBay = nil
pcall(function()
    local restore = {}
    for _, u in ipairs({ "FloatingTipUtility", "FloatingWordUtility" }) do
        local U = _G[u]
        if U and U.QuickMsg then
            local orig = U.QuickMsg
            U.QuickMsg = function(msg, ...)
                pcall(function() log("  [THONG BAO GAME] " .. tostring(msg)) end)
                return orig(msg, ...)
            end
            table.insert(restore, function() U.QuickMsg = orig end)
        end
    end
    goBay = function() for _, f in ipairs(restore) do pcall(f) end end
end)

-- Gui lan luot tung moc, cach nhau 1 giay
local i = 0
local function guiTiep()
    i = i + 1
    if i > #dsCoTheNhan then
        -- doc lai trang thai sau khi nhan
        hdr("5. KIEM TRA LAI SAU KHI NHAN")
        for _, gift in ipairs(dsMoc) do
            local daNhan = false
            pcall(function()
                local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
                if mgr and mgr.GetRefreshCountFun then daNhan = mgr:GetRefreshCountFun(gift) == true end
            end)
            log(string.format("  giftId=%s | da nhan = %s", tostring(gift.id), tostring(daNhan)))
        end
        pcall(function()
            local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
            if c then
                kv("KC khong khoa (1000030)", c[1000030])
                kv("Kim Cuong Khoa (1000050)", c[1000050])
            end
        end)
        if goBay then pcall(goBay) end
        log("=== KET THUC T6 ===")
        saveOutput()
        return
    end

    local gift = dsCoTheNhan[i]
    log(string.format("  Gui ReqGetGift({ %s }) ...", tostring(gift.id)))
    saveOutput()
    local ok = pcall(function() _G.networkRequest.ReqGetGift({ gift.id }) end)
    log("  ket qua goi: " .. tostring(ok))
    saveOutput()

    -- cho 1.5s roi gui moc tiep theo
    local n, t = 0, nil
    t = _G.Timer.StartLoop(0.5, 4, function()
        n = n + 1
        if n >= 3 then
            if t and t.Stop then pcall(function() t:Stop() end) end
            guiTiep()
        end
    end)
end

-- Ghi lai so KC truoc khi nhan de doi chieu
pcall(function()
    local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
    if c then
        kv("KC truoc khi nhan (1000030)", c[1000030])
        kv("KC Khoa truoc khi nhan (1000050)", c[1000050])
    end
end)
saveOutput()
guiTiep()

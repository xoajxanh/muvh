-- =========================================================================
-- [TEST SCRIPT T7]: TIM "KIM PHIEU" NAM O DAU
-- Da biet: nhan 3 moc thuong xong nhung 1000030 va 1000050 KHONG tang.
-- Script nay quet:
--   1. TOAN BO bang tien te, in cai nao > 0
--   2. Tui do, tim vat pham ten chua "Phieu" / "Kim"
--   3. Doc cau hinh cua 3 gift -> xem phan thuong tra ve ID gi
-- CHI DOC, khong nhan gi, khong gui goi tin.
-- =========================================================================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t)
    log(""); log("=================================================="); log("  " .. tostring(t)); log("==================================================")
end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

log("=== T7: TIM KIM PHIEU ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)

-- ---------------------------------------------------------------
hdr("1. TOAN BO TIEN TE CO GIA TRI > 0")
pcall(function()
    local coins = _G.BagInfoData and _G.BagInfoData.CoinInfos
    if not coins then log("  CoinInfos = nil"); return end
    local keys = {}
    for k, _ in pairs(coins) do table.insert(keys, k) end
    table.sort(keys, function(a, b) return (tonumber(a) or 0) < (tonumber(b) or 0) end)
    local dem = 0
    for _, k in ipairs(keys) do
        local gt = tonumber(coins[k]) or 0
        if gt > 0 then
            dem = dem + 1
            local nm = "?"
            pcall(function()
                local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(k))
                nm = it and it.name or "?"
            end)
            local danhDau = ""
            if gt == 30000 then danhDau = "   <<<<<< DUNG 30.000 - RAT CO THE LA KIM PHIEU"
            elseif gt >= 5000 and gt <= 35000 then danhDau = "   <<< trong khoang thuong 5K-30K" end
            log(string.format("  coinId=%-10s gia tri=%-12s ten=%s%s", tostring(k), tostring(gt), tostring(nm), danhDau))
        end
    end
    log("  (tong " .. dem .. " loai tien co gia tri > 0)")
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("2. QUET TUI DO - TIM VAT PHAM TEN CHUA 'PHIEU' / 'KIM'")
pcall(function()
    local bag = _G.BagInfoData and _G.BagInfoData.TotalItems
    if not bag then log("  TotalItems = nil"); return end
    local dem = 0
    for _, item in pairs(bag) do
        pcall(function()
            local cfgId = item.configId or item.cfgId or item.itemId
            local soLuong = item.count or item.num or item.number or 0
            local ten = "?"
            pcall(function()
                local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(cfgId))
                ten = it and it.name or "?"
            end)
            local tenThuong = tostring(ten)
            if string.find(tenThuong, "Phi") or string.find(tenThuong, "phi")
               or string.find(tenThuong, "Kim") or string.find(tenThuong, "kim") then
                dem = dem + 1
                log(string.format("  cfgId=%-10s so luong=%-8s ten=%s", tostring(cfgId), tostring(soLuong), tenThuong))
            end
        end)
    end
    if dem == 0 then log("  Khong tim thay vat pham nao ten chua Phieu/Kim") end
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("3. CAU HINH 3 GIFT - PHAN THUONG TRA VE GI")
pcall(function()
    local mgr = _G.QuickFind:GetTask_EarlyGoldManager()
    for _, gid in ipairs({ 6600001, 6600002, 6600003 }) do
        local gift = _G.ClientTable.cfg_Gift_giftManager:TryGetValue(gid)
        log("  --- giftId " .. tostring(gid) .. " ---")
        if not gift then log("      khong doc duoc"); goto tiep end

        -- dump cac truong cua gift
        pcall(function()
            for k, v in pairs(gift) do
                if type(v) ~= "table" and type(v) ~= "function" then
                    log(string.format("      %s = %s", tostring(k), tostring(v)))
                end
            end
        end)

        -- lay danh sach vat pham thuong qua ham cua game
        pcall(function()
            if mgr and mgr.GetBoxItemTbl then
                local tbl = mgr:GetBoxItemTbl({ gift })
                if tbl then
                    log("      >>> GetBoxItemTbl tra ve:")
                    for i, it in pairs(tbl) do
                        local s = "          "
                        pcall(function()
                            for k2, v2 in pairs(it) do
                                if type(v2) ~= "table" and type(v2) ~= "function" then
                                    s = s .. tostring(k2) .. "=" .. tostring(v2) .. "  "
                                end
                            end
                        end)
                        log(s)
                    end
                end
            end
        end)
        ::tiep::
    end
end)
saveOutput()

-- ---------------------------------------------------------------
hdr("4. TIM TRONG BANG VAT PHAM: TEN CHUA 'Kim Phieu'")
pcall(function()
    -- thu mot dai ID quanh cac loai tien te da biet
    local dsThu = { 1000150, 1000022, 1000040, 1000130, 1000110, 1000100,
                    1000204, 1000207, 1000208, 1000209, 1000210 }
    for _, id in ipairs(dsThu) do
        local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(id)
        local gt = 0
        pcall(function()
            local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
            if c then gt = tonumber(c[id]) or 0 end
        end)
        log(string.format("  id=%-10s ten=%-28s gia tri hien co=%s",
            tostring(id), tostring(it and it.name or "?"), tostring(gt)))
    end
end)

log("")
log("=== KET THUC T7 ===")
saveOutput()

-- =========================================================================
-- [TEST SCRIPT T8]: KIEM CHUNG DOC SO KIM PHIEU (itemId 1000250)
-- Thu CA 3 CACH doc, xem cach nao ra dung so trong game.
-- CHI DOC, khong nhan gi.
-- =========================================================================
local MA_KIM_PHIEU = 1000250

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function kv(k, v) log(string.format("  %-34s = %s", tostring(k), tostring(v))) end
local function hdr(t) log(""); log("=================================================="); log("  " .. t); log("==================================================") end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

log("=== T8: KIEM CHUNG DOC KIM PHIEU (ma " .. MA_KIM_PHIEU .. ") ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)

hdr("TEN VAT PHAM")
pcall(function()
    local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(MA_KIM_PHIEU)
    kv("ten", it and it.name or "?")
    if it then
        for k, v in pairs(it) do
            if type(v) ~= "table" and type(v) ~= "function" then
                log(string.format("    %s = %s", tostring(k), tostring(v)))
            end
        end
    end
end)
saveOutput()

hdr("CACH 1: BagInfoData.GetItemByConfigID")
pcall(function()
    if not (_G.BagInfoData and _G.BagInfoData.GetItemByConfigID) then
        log("  Khong co ham GetItemByConfigID"); return
    end
    local it = _G.BagInfoData.GetItemByConfigID(MA_KIM_PHIEU)
    if not it then log("  tra ve nil"); return end
    for k, v in pairs(it) do
        if type(v) ~= "table" and type(v) ~= "function" then
            log(string.format("    %s = %s", tostring(k), tostring(v)))
        end
    end
    kv(">> so luong doc duoc", it.count or it.num or it.number or "?")
end)
saveOutput()

hdr("CACH 2: quet BagInfoData.TotalItems")
pcall(function()
    local bag = _G.BagInfoData and _G.BagInfoData.TotalItems
    if not bag then log("  TotalItems = nil"); return end
    local tong, soO = 0, 0
    for _, it in pairs(bag) do
        pcall(function()
            local cid = tonumber(it.configId or it.cfgId or it.itemId or 0) or 0
            if cid == MA_KIM_PHIEU then
                soO = soO + 1
                local n = tonumber(it.count or it.num or it.number or 0) or 0
                tong = tong + n
                log(string.format("    o thu %d: so luong = %s", soO, tostring(n)))
            end
        end)
    end
    kv(">> tong cong", tong)
    kv(">> so o chua vat pham nay", soO)
end)
saveOutput()

hdr("CACH 3: bang tien te (du phong)")
pcall(function()
    local c = _G.BagInfoData and _G.BagInfoData.CoinInfos
    if not c then log("  CoinInfos = nil"); return end
    kv("CoinInfos[" .. MA_KIM_PHIEU .. "]", c[MA_KIM_PHIEU] or "khong co")
end)

hdr("DOI CHIEU")
log("  Anh mo TUI DO trong game, tim Kim Phieu va so sanh voi so o tren.")
log("  Acc vua nhan 3 moc -> ky vong 30.000 (neu truoc do chua co).")
log("")
log("=== KET THUC T8 ===")
saveOutput()

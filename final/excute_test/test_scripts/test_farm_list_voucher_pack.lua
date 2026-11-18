-- =========================================================================
-- [TEST SCRIPT T12]: LIET KE CAC GOI MUA BANG KIM PHIEU (type 28)
-- Muc dich: tim goi RE nhat de test duoc voi 5.000 Kim Phieu con lai.
-- CHI DOC, khong mua gi.
-- =========================================================================

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function hdr(t) log(""); log("=================================================="); log("  " .. t); log("==================================================") end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
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

log("=== T12: CAC GOI MUA BANG KIM PHIEU ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)
log("Kim Phieu dang co: " .. tostring(soKimPhieu()))
saveOutput()

-- ---------- Liet ke TOAN BO type 28 ----------
hdr("TOAN BO GOI type = 28")
pcall(function()
    local mgr = _G.ClientTable.cfg_Recharge_rechargeManager
    local ds = mgr:BaseGetTabListByType(28, "type")
    if not ds then log("  khong co du lieu"); return end
    local dem = 0
    for _, v in pairs(ds) do
        dem = dem + 1
        local s = "  "
        for k, val in pairs(v) do
            if type(val) ~= "table" and type(val) ~= "function" then
                s = s .. tostring(k) .. "=" .. tostring(val) .. "  "
            end
        end
        log(s)
    end
    log("  (tong " .. dem .. " goi)")
end)
saveOutput()

-- ---------- Thu cac type lan can, tim goi gia nho ----------
hdr("CAC GOI GIA NHO O MOI type (<= 10.000)")
pcall(function()
    local mgr = _G.ClientTable.cfg_Recharge_rechargeManager
    for lType = 1, 45 do
        local ok, ds = pcall(function() return mgr:BaseGetTabListByType(lType, "type") end)
        if ok and ds then
            local daIn = false
            for _, v in pairs(ds) do
                pcall(function()
                    -- tim theo ten co chua "VND" va so nho
                    local ten = tostring(v.name or "")
                    local so = tonumber(string.match(ten, "^(%d+)VND$") or 0) or 0
                    if so > 0 and so <= 10000 then
                        if not daIn then log("  --- type " .. lType .. " ---"); daIn = true end
                        local s = "      "
                        for k, val in pairs(v) do
                            if type(val) ~= "table" and type(val) ~= "function" then
                                s = s .. tostring(k) .. "=" .. tostring(val) .. "  "
                            end
                        end
                        log(s)
                    end
                end)
            end
        end
    end
end)
saveOutput()

-- ---------- Tim ten vat pham 1000250 de chac chan ----------
hdr("XAC NHAN VAT PHAM 1000250")
pcall(function()
    local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(1000250)
    log("  ten = " .. tostring(it and it.name or "?"))
end)

log("")
log("=== KET THUC T12 ===")
saveOutput()

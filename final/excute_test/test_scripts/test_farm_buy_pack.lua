-- =========================================================================
-- [TEST SCRIPT T14]: TEST RIENG BUOC MUA GOI BANG KIM PHIEU
-- Mo phong dung ham trong mod, in ro TUNG BUOC de biet hong o dau.
-- Cong thuc (bat duoc tu goi tin that):
--   networkRequest.ReqUseItem(25000, <id O KIM PHIEU trong tui>, { 100001 })
-- Chay duoc tren APK hien tai, KHONG can build lai.
-- =========================================================================

local GIA_KIM_PHIEU = 25000      -- gia goi
local MA_GOI        = 100001     -- ma goi "60 kim cuong / 25K"
local MA_VAT_PHAM   = 1000250    -- Kim Phieu
local THUC_SU_MUA   = true       -- false = chi doc, khong gui lenh

local logs = {}
local function log(m) table.insert(logs, tostring(m)) end
local function kv(k, v) log(string.format("  %-30s = %s", tostring(k), tostring(v))) end
local function hdr(t) log(""); log("=================================================="); log("  " .. t); log("==================================================") end
local function saveOutput()
    pcall(function()
        local f = io.open(CS.UnityEngine.Application.persistentDataPath .. "/output.txt", "w")
        if f then f:write(table.concat(logs, "\n")); f:close() end
    end)
end

log("=== T14: TEST RIENG BUOC MUA GOI ===")
log("Thoi diem: " .. os.date("%Y-%m-%d %H:%M:%S"))
pcall(function()
    local md = _G.ViewData and _G.ViewData.meData
    log("Nhan vat: " .. tostring(md and md.name) .. " | Lv " .. tostring(md and md.level))
end)
saveOutput()

-- ---------- BUOC 1: TIM O KIM PHIEU TRONG TUI ----------
hdr("1. TIM O KIM PHIEU TRONG TUI")
local oKP = nil

-- Cach 1
pcall(function()
    if _G.BagInfoData and _G.BagInfoData.GetItemByConfigID then
        oKP = _G.BagInfoData.GetItemByConfigID(MA_VAT_PHAM)
        kv("Cach 1 GetItemByConfigID", oKP ~= nil)
    else
        kv("Cach 1 GetItemByConfigID", "KHONG CO HAM")
    end
end)

-- Cach 2
if oKP == nil then
    pcall(function()
        local bag = _G.BagInfoData and _G.BagInfoData.TotalItems
        if bag then
            for _, it in pairs(bag) do
                local cid = tonumber(it.configId or it.cfgId or it.itemId or 0) or 0
                if cid == MA_VAT_PHAM then oKP = it break end
            end
        end
        kv("Cach 2 quet tui", oKP ~= nil)
    end)
end

if oKP == nil then
    log("")
    log("  !!! KHONG TIM THAY KIM PHIEU TRONG TUI -> DUNG LAI")
    log("  (acc nay chua nhan thuong moc, hoac da tieu het)")
    log("=== KET THUC T14 ===")
    saveOutput()
    return
end

log("  --- Toan bo truong cua o Kim Phieu ---")
pcall(function()
    for k, v in pairs(oKP) do
        if type(v) ~= "table" and type(v) ~= "function" then
            log(string.format("      %s = %s", tostring(k), tostring(v)))
        end
    end
end)

local idO = oKP.id or oKP.uid or oKP.itemUid
local dangCo = tonumber(oKP.count or oKP.num or 0) or 0
kv(">> id O (dung lam itemId)", idO)
kv(">> so Kim Phieu dang co", dangCo)
saveOutput()

-- ---------- BUOC 2: KIEM TRA DIEU KIEN ----------
hdr("2. KIEM TRA DIEU KIEN")
kv("Gia goi can tra", GIA_KIM_PHIEU)
kv("Du tien khong", dangCo >= GIA_KIM_PHIEU)
kv("Co id o khong", idO ~= nil)
kv("Co networkRequest.ReqUseItem", (_G.networkRequest and _G.networkRequest.ReqUseItem) ~= nil)

if dangCo < GIA_KIM_PHIEU then
    log("")
    log(string.format("  !!! KHONG DU KIM PHIEU (co %d, can %d) -> DUNG LAI", dangCo, GIA_KIM_PHIEU))
    log("=== KET THUC T14 ===")
    saveOutput()
    return
end
if idO == nil then
    log("")
    log("  !!! KHONG LAY DUOC id O -> DUNG LAI")
    log("=== KET THUC T14 ===")
    saveOutput()
    return
end
saveOutput()

if not THUC_SU_MUA then
    hdr("3. THUC_SU_MUA = false -> KHONG GUI LENH")
    log("  Doi THUC_SU_MUA = true de mua that.")
    log("=== KET THUC T14 ===")
    saveOutput()
    return
end

-- ---------- BUOC 3: GUI LENH MUA ----------
hdr("3. GUI LENH MUA")
log(string.format("  networkRequest.ReqUseItem(%d, %s, { \"%d\" })",
    GIA_KIM_PHIEU, tostring(idO), MA_GOI))
saveOutput()

local okGui, loiGui = pcall(function()
    -- clientParams phai la mang CHUOI, khong phai so
    _G.networkRequest.ReqUseItem(GIA_KIM_PHIEU, idO, { tostring(MA_GOI) })
end)
kv("Ket qua goi", okGui)
if not okGui then kv("Loi", loiGui) end
saveOutput()

-- ---------- BUOC 4: DON POPUP + THEO DOI ----------
hdr("4. THEO DOI KET QUA (10 giay)")

local function donPopup()
    pcall(function()
        if _G.UIID and _G.UIID.PromptTipUI and _G.UIManager
           and _G.UIManager.IsVisible and _G.UIManager.IsVisible(_G.UIID.PromptTipUI) then
            local p = _G.UIManager.GetUiByName and _G.UIManager.GetUiByName(_G.UIID.PromptTipUI)
            if p then
                local daBam = false
                pcall(function()
                    if p.btn_okOnClick and p.btn_ok then p:btn_okOnClick(p.btn_ok); daBam = true end
                end)
                if not daBam then
                    pcall(function()
                        if p.btn_sureOnClick and p.btn_sure then p:btn_sureOnClick(p.btn_sure); daBam = true end
                    end)
                end
                log("      [popup] da xu ly popup Nhac nho (bam duoc: " .. tostring(daBam) .. ")")
                -- liet ke cac truong cua popup de biet ten nut
                if not daBam then
                    pcall(function()
                        for k, v in pairs(p) do
                            if type(v) ~= "function" and type(v) ~= "table" then
                                log("          " .. tostring(k) .. " = " .. tostring(v))
                            elseif type(v) == "table" then
                                log("          " .. tostring(k) .. " = {table}")
                            end
                        end
                    end)
                end
                saveOutput()
            end
        end
    end)
end

local function layKimPhieu()
    local n = 0
    pcall(function()
        local it = _G.BagInfoData.GetItemByConfigID(MA_VAT_PHAM)
        if it then n = tonumber(it.count or 0) or 0 end
    end)
    return n
end

local n, t = 0, nil
t = _G.Timer.StartLoop(1.0, 12, function()
    n = n + 1
    donPopup()
    local hienTai = layKimPhieu()
    log(string.format("  giay %d: Kim Phieu = %s", n, tostring(hienTai)))
    saveOutput()

    if hienTai < dangCo then
        if t and t.Stop then pcall(function() t:Stop() end) end
        hdr("5. MUA THANH CONG")
        kv("Kim Phieu truoc", dangCo)
        kv("Kim Phieu sau", hienTai)
        kv("Da tieu", dangCo - hienTai)
        log("")
        log("  >>> Vat pham nam trong THU, can nhan thu de lay ve tui <<<")
        log("=== KET THUC T14 ===")
        saveOutput()
    elseif n >= 10 then
        if t and t.Stop then pcall(function() t:Stop() end) end
        hdr("5. KHONG THAY KIM PHIEU GIAM")
        kv("Kim Phieu van la", hienTai)
        log("  Co the: server tu choi, sai ma goi, hoac can xac nhan popup.")
        log("=== KET THUC T14 ===")
        saveOutput()
    end
end)

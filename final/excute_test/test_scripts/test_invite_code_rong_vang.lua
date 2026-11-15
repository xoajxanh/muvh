-- =========================================================================
-- [TEST SCRIPT]: MÃ MỜI RỒNG VÀNG (Task_EarlyGoldGameplay - tab "Mời Bạn Bè")
-- Bản lưu trữ (đã test thật trên server 517 ngày 2026-11-15). Cách dùng: copy nội dung vào
-- final\excute_test\input.txt -> USER push_test + bấm nút EXEC trong game -> đọc output.txt.
--
-- Gói tin (module User):
--   ReqRoleCode (1027)        = Nút [Tạo mã]   -> networkRequest.ReqRoleCode()
--   ReqRoleVerifyCode (1028)  = Nút [Xác minh] -> networkRequest.ReqRoleVerifyCode(code)
--   ResRoleCode (1029)        = Server trả {code, num, isCode} -> QuickFind:GetTask_EarlyGoldManager():SetVerificationCode
--   Thưởng mốc mời 1/3/5 người: ReqGetGift({6600001 | 6600002 | 6600003})  (CHƯA dùng trong script này)
--
-- CHỌN CHẾ ĐỘ (sửa dòng MODE):
--   "VIEW"   : CHỈ ĐỌC - dump mã mời / số người mời / thông tin nhân vật / tiền tệ (an toàn, không gửi gì)
--   "GEN"    : Acc Lv200 - gửi [Tạo mã] rồi dump kết quả
--   "VERIFY" : Acc Lv50  - nhập mã VERIFY_CODE rồi bấm [Xác minh], dump kết quả + thông báo/popup game trả về
-- LƯU Ý: Ở lần test VERIFY thật, timer 3s không chạy -> kết quả xác nhận bằng cách chạy lại VIEW (isCode = true).
-- =========================================================================
local MODE = "VIEW"
local VERIFY_CODE = ""   -- chỉ dùng cho MODE = "VERIFY": mã mời của acc Lv200 CÙNG server

local logs = {}
local function log(m) table.insert(logs, "[" .. os.date("%H:%M:%S") .. "] " .. tostring(m)) end
local function saveOutput()
    local path = CS.UnityEngine.Application.persistentDataPath .. "/output.txt"
    local f = io.open(path, "w")
    if f then f:write(table.concat(logs, "\n")); f:close() end
end
local function Delay(sec, fn)
    local wrapped = function() local ok, err = pcall(fn); if not ok then log("[LOI] " .. tostring(err)); saveOutput() end end
    if _G.LuaTimer and _G.LuaTimer.Add then
        _G.LuaTimer.Add(math.floor(sec * 1000), wrapped)
    elseif _G.Timer and _G.Timer.Start then
        _G.Timer.Start(sec, wrapped)
    else
        log("[LOI] Khong co Timer!"); saveOutput()
    end
end
local function dumpTable(t, prefix, depth)
    depth = depth or 0
    if type(t) ~= "table" or depth > 2 then return end
    for k, v in pairs(t) do
        if type(v) == "table" then
            log(string.format("%s%s = {table}", prefix, tostring(k)))
            dumpTable(v, prefix .. "   ", depth + 1)
        else
            log(string.format("%s%s = %s", prefix, tostring(k), tostring(v)))
        end
    end
end

-- 1. Thông tin nhân vật & server (tái sử dụng đoạn code từ modules/mod_player_info)
local function DumpRoleInfo()
    log("=== THONG TIN NHAN VAT ===")
    pcall(function()
        local meData = _G.ViewData and _G.ViewData.meData
        local pMe = _G.RoleManager and _G.RoleManager.me
        local roleId = tostring((meData and meData.id) or (pMe and pMe.id) or 0)
        local lvl = tonumber((meData and meData.level) or (pMe and pMe.level) or 0)
        local name = (meData and meData.name) or (pMe and pMe.name) or "?"
        log(string.format("RoleId=%s | Name=%s | Level=%s", roleId, tostring(name), tostring(lvl)))
    end)
    pcall(function()
        local LD = _G.LoginData
        if LD then
            local sName = LD.GetServerName and LD.GetServerName() or "?"
            log(string.format("Server: name=%s | serverId=%s | sid=%s | sdk_pid=%s | account=%s",
                tostring(sName), tostring(LD.serverId), tostring(LD.sid), tostring(LD.sdk_pid), tostring(LD.account or LD.userName)))
        end
    end)
    pcall(function()
        local func = _G.ClientTable.cfg_Function_functionManager:TryGetValue(5100001, "id")
        local ok = func and _G.ConditionManager and _G.ConditionManager.Check4D(func.condition)
        log("Dieu kien mo [Tao ma] (func 5100001 - Lv200): " .. tostring(ok))
    end)
end

-- 2. Tiền tệ: dump toàn bộ CoinInfos (Vàng không khóa = 1000020, KC không khóa = 1000030)
local function DumpCoins()
    log("=== TIEN TE (BagInfoData.CoinInfos) ===")
    pcall(function()
        local coins = _G.BagInfoData and _G.BagInfoData.CoinInfos
        if not coins then log("Khong co CoinInfos"); return end
        local keys = {}
        for k, _ in pairs(coins) do table.insert(keys, k) end
        table.sort(keys, function(a, b) return tonumber(a) < tonumber(b) end)
        for _, k in ipairs(keys) do
            local nm = "?"
            pcall(function()
                local it = _G.ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(k))
                nm = it and it.name or "?"
            end)
            log(string.format("  coinId=%s | value=%s | ten=%s", tostring(k), tostring(coins[k]), tostring(nm)))
        end
    end)
end

-- 3. Dữ liệu mã mời hiện có trong client
local function GetMgr()
    local mgr = nil
    pcall(function() mgr = _G.QuickFind:GetTask_EarlyGoldManager() end)
    return mgr
end
local function DumpInviteData(label)
    log("=== DU LIEU MA MOI (" .. label .. ") ===")
    local mgr = GetMgr()
    if not mgr then log("Khong lay duoc Task_EarlyGoldManager"); return end
    local vd = mgr.GetVerifyData and mgr:GetVerifyData()
    if not vd then log("VerifyData = nil") else dumpTable(vd, "  VerifyData.") end
    pcall(function()
        for _, gid in ipairs({ 6600001, 6600002, 6600003 }) do
            local gift = _G.ClientTable.cfg_Gift_giftManager:TryGetValue(gid)
            local received = gift and mgr.GetRefreshCountFun and mgr:GetRefreshCountFun(gift)
            log(string.format("  Thuong moc gift %d: da nhan = %s", gid, tostring(received)))
        end
    end)
end

-- 4. Bắt gói 1029 + popup Nhắc nhở (PromptTipUI) + thông báo nổi game trả về trong lúc test
local restoreFns = {}
local function HookCapture()
    pcall(function()
        local mgr = GetMgr()
        if mgr and mgr.SetVerificationCode then
            local orig = mgr.SetVerificationCode
            mgr.SetVerificationCode = function(self, data)
                log(">>> [RES 1029 ResRoleCode] nhan duoc:")
                dumpTable(data, "     ")
                return orig(self, data)
            end
            table.insert(restoreFns, function() mgr.SetVerificationCode = orig end)
        end
    end)
    pcall(function()
        local UM = _G.UIManager
        if UM and UM.Show then
            local origShow = UM.Show
            UM.Show = function(uiId, args, ...)
                pcall(function()
                    if type(args) == "table" and (args.textContent or args.title) then
                        log(">>> [POPUP GAME - UIManager.Show] title=" .. tostring(args.title) .. " | noi dung=" .. tostring(args.textContent))
                    end
                end)
                return origShow(uiId, args, ...)
            end
            table.insert(restoreFns, function() UM.Show = origShow end)
        end
    end)
    for _, uName in ipairs({ "FloatingTipUtility", "FloatingWordUtility" }) do
        pcall(function()
            local U = _G[uName]
            if U and U.QuickMsg then
                local orig = U.QuickMsg
                U.QuickMsg = function(msg, ...)
                    log(">>> [THONG BAO GAME - " .. uName .. "] " .. tostring(msg))
                    return orig(msg, ...)
                end
                table.insert(restoreFns, function() U.QuickMsg = orig end)
            end
        end)
    end
end
local function Unhook()
    for _, fn in ipairs(restoreFns) do pcall(fn) end
    restoreFns = {}
end

-- ===================== BẮT ĐẦU =====================
log("=== TEST MA MOI RONG VANG - MODE: " .. MODE .. " ===")
DumpRoleInfo()
DumpCoins()
DumpInviteData("TRUOC")
saveOutput()

if MODE == "VIEW" then
    log("[VIEW] Chi doc, khong gui goi tin.")
    saveOutput()
elseif MODE == "GEN" then
    HookCapture()
    log("[GEN] Gui networkRequest.ReqRoleCode() ...")
    pcall(function() _G.networkRequest.ReqRoleCode() end)
    saveOutput()
    Delay(3.0, function()
        DumpInviteData("SAU KHI TAO MA (3s)")
        Unhook()
        saveOutput()
    end)
elseif MODE == "VERIFY" then
    local isCodeBefore = false
    pcall(function()
        local vd = GetMgr() and GetMgr():GetVerifyData()
        isCodeBefore = vd and vd.isCode == true
    end)
    if VERIFY_CODE == "" then
        log("[VERIFY] Chua dien VERIFY_CODE!")
        saveOutput()
    else
        log("[VERIFY] isCode truoc khi xac minh = " .. tostring(isCodeBefore) .. " (true = acc DA nhap ma truoc do)")
        HookCapture()
        log("[VERIFY] Gui networkRequest.ReqRoleVerifyCode('" .. VERIFY_CODE .. "') ...")
        pcall(function() _G.networkRequest.ReqRoleVerifyCode(VERIFY_CODE) end)
        saveOutput()
        Delay(3.0, function()
            DumpInviteData("SAU KHI XAC MINH (3s)")
            Unhook()
            saveOutput()
        end)
    end
else
    log("[LOI] MODE khong hop le: " .. tostring(MODE))
    saveOutput()
end

pcall(function()
    local execTime = os.date("%H:%M:%S")
    if _G.UIManager and _G.UIID and _G.UIID.TipFloatTipUI then
        pcall(function() _G.UIManager.Show(_G.UIID.TipFloatTipUI) end)
    end
    if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
        _G.FloatingWordUtility.QuickMsg(string.format("[EXECUTE] Nạp Script mới: %s", execTime))
    end
end)

local function TriggerDungeonSkipWait()
    pcall(function()
        -- 1. Gửi gói tin mạng SkipWait
        if _G.networkRequest and _G.networkRequest.ReqSkipWait then
            _G.networkRequest.ReqSkipWait()
        end
        if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqSkipWait then
            _G.NetManager.Send(_G.MapMessage.ReqSkipWait)
        end

        -- 2. Tìm Instance_GoalUI
        local goalUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Instance_GoalUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.Instance_GoalUI)))
        if goalUI then
            if goalUI.btn_rightnowOnClick then
                goalUI:btn_rightnowOnClick(goalUI.btn_rightnow)
            elseif goalUI.btn_rightnow and goalUI.btn_rightnow.OnClick then
                goalUI.btn_rightnow:OnClick()
            end
        end

        -- 3. Tìm qua LeftTopPanelUI.transTempUI
        local leftTopUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("LeftTopPanelUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.LeftTopPanelUI)))
        if leftTopUI and leftTopUI.transTempUI and leftTopUI.transTempUI.btn_rightnowOnClick then
            leftTopUI.transTempUI:btn_rightnowOnClick(leftTopUI.transTempUI.btn_rightnow)
        end

        -- 4. Tìm trực tiếp GameObject btn_rightnow trên Unity Hierarchy
        if CS and CS.UnityEngine and CS.UnityEngine.GameObject and CS.UnityEngine.GameObject.Find then
            local btnObj = CS.UnityEngine.GameObject.Find("btn_rightnow")
            if btnObj and not IsObjectNil(btnObj) and btnObj.activeInHierarchy then
                local uBtn = btnObj:GetComponent(typeof(CS.UnityEngine.UI.Button)) or btnObj:GetComponent("Button")
                if uBtn and uBtn.onClick then
                    uBtn.onClick:Invoke()
                end
            end
        end
    end)
end
_G.TriggerDungeonSkipWait = TriggerDungeonSkipWait

-- Cho phép UIManager.GetUI trỏ đến UIManager.GetUiByName
pcall(function()
    if _G.UIManager and _G.UIManager.GetUiByName then
        _G.UIManager.GetUI = _G.UIManager.GetUiByName
    end
end)

-- =========================================================================
-- [BOT FARM CLIENT - FULL PIPELINE: MULTI-ROLE (1->2->3->4) & MULTI-ACCOUNT]
-- =========================================================================

_G.Bot_Running = false
_G.Mod_IsInputScriptRunning = true
_G.IsRoleCreating = false
_G.HasCreatedRoleForTarget = false
_G.Bot_IsInGameWorld = false
_G.Bot_PauseTask = false

_G.Bot_Pause = function()
    _G.Bot_PauseTask = true
    pcall(function()
        if _G.UIManager then
            if _G.UIID and _G.UIID.BagSellInfoUI then _G.UIManager.Hide(_G.UIID.BagSellInfoUI) end
            if _G.UIID and _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
        end
    end)
    _G.Log(">>> [USER OVERRIDE] ĐÃ TẠM DỪNG BOT! Anh có thể tự do gỡ step bằng tay. Gõ _G.Bot_Resume() để tiếp tục.", true)
end

_G.Bot_Resume = function()
    _G.Bot_PauseTask = false
    _G.Log(">>> [USER OVERRIDE] ĐÃ TIẾP TỤC BOT CHẠY TỰ ĐỘNG!", true)
end

-- =========================================================================
-- CẤU HÌNH BIẾN DELAY CHỜ GIỮA CÁC STEP (MẶC ĐỊNH = 1.0s ĐỂ TEST, CÓ THỂ ĐỔI THÀNH 0.5s KHI CHẠY MƯỢT)
-- =========================================================================
_G.BOT_STEP_DELAY = 1.0
local DELAY = _G.BOT_STEP_DELAY or 1.0

local logLines = {}
local lastScreenMsg = ""
local lastScreenMsgTime = 0

local function FormatQuickMsg(rawMsg)
    local msg = tostring(rawMsg or "")
    msg = msg:gsub("^%s*[->>%*#!%s=]+", ""):gsub("[-><%*#!%s=]+$", "")
    if #msg == 0 or msg:match("^[%s=-]+$") then
        return ""
    end
    
    local tag, body = msg:match("^%[([^%]]+)%]%s*[:%-]?%s*(.*)$")
    if tag and body and #body > 0 then
        return string.format("[%s] : %s", tag, body)
    end
    
    if msg:find("Đang trong Game") or msg:find("Đăng nhập") or msg:find("kết nối") then
        return string.format("[Đăng Nhập] : %s", msg)
    elseif msg:find("Nhiệm vụ") or msg:find("Quest") or msg:find("quest") then
        return string.format("[Nhiệm Vụ] : %s", msg)
    elseif msg:find("mặc đồ") or msg:find("Trang bị") or msg:find("Mặc") then
        return string.format("[Trang Bị] : %s", msg)
    elseif msg:find("chuyển cường hóa") or msg:find("kế thừa") or msg:find("Chuyển") then
        return string.format("[Chuyển Cường Hóa] : %s", msg)
    elseif msg:find("thu hồi") or msg:find("Thu hồi") or msg:find("rác") then
        return string.format("[Thu Hồi] : %s", msg)
    elseif msg:find("Cường hóa") or msg:find("cường hóa") or msg:find("ĐẬP ĐỒ") then
        return string.format("[Cường Hóa] : %s", msg)
    elseif msg:find("Huỳnh Thạch") or msg:find("huỳnh thạch") or msg:find("ngọc") then
        return string.format("[Huỳnh Thạch] : %s", msg)
    elseif msg:find("Phó bản") or msg:find("Huyết Lâu") or msg:find("Quảng Trường Quỷ") or msg:find("phó bản") then
        return string.format("[Phó Bản] : %s", msg)
    elseif msg:find("Rương Vàng") or msg:find("rương vàng") then
        return string.format("[Rương Vàng] : %s", msg)
    elseif msg:find("Bãi farm") or msg:find("quái") or msg:find("luyện cấp") then
        return string.format("[Luyện Cấp] : %s", msg)
    elseif msg:find("Mua Máu") or msg:find("bình Máu") then
        return string.format("[Mua Thuốc] : %s", msg)
    end
    
    return string.format("[Auto BOT] : %s", msg)
end

local function Log(str, showOnScreen)
    local msg = tostring(str)
    table.insert(logLines, msg)
    print("[BOT_FARM]: " .. msg)
    
    local cleanMsg = FormatQuickMsg(msg)
    if cleanMsg == "" then return end
    
    pcall(function()
        if _G.Bot_StatusTextComp and not IsObjectNil(_G.Bot_StatusTextComp) then
            _G.Bot_StatusTextComp.text = cleanMsg
        end
    end)
    
    if showOnScreen and _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
        local now = os.time()
        if cleanMsg ~= lastScreenMsg or (now - lastScreenMsgTime) >= 3 then
            lastScreenMsg = cleanMsg
            lastScreenMsgTime = now
            pcall(function() _G.FloatingWordUtility.QuickMsg(cleanMsg) end)
        end
    end
end
_G.Log = Log
_G.Bot_Log = function(msg) Log(msg, false) end

-- Cho phép QuickMsg hiển thị thông báo chuẩn format
pcall(function()
    if _G.FloatingWordUtility and _G.FloatingWordUtility.QuickMsg then
        local orig_Word_QuickMsg = _G.FloatingWordUtility.QuickMsg
        _G.FloatingWordUtility.QuickMsg = function(msg, ...)
            return orig_Word_QuickMsg(msg, ...)
        end
    end
end)

local function SaveOutput()
    local resultText = table.concat(logLines, "\n")
    pcall(function()
        local outPath = "/storage/emulated/0/Android/data/com.vnyh.gp/files/output.txt"
        local f = io.open(outPath, "w")
        if f then
            f:write(resultText)
            f:close()
        end
    end)
end

-- =========================================================================
-- KHAI BÁO FORWARD FUNCTIONS & CẤU HÌNH MAP TRAVEL
-- =========================================================================
local StartFullLoginProcess
local ConnectToTargetServer
local EnsureServerListLoaded
local StartGoldenChestProcess
local TeleportToTrainMapAndFarm
local SwitchToNextRoleOrAccount
local SelectRoleByIndex
local ForceLogoutToLogin
local DismissBlockers
local RunAutoGiftcode
local AutoEvenEnhanceEquipments
local AutoEvenUpgradeGems
local AutoEquipBetterItems
local AutoBuyPotionsIfLow
local RunPeriodicUpgradeCycle
local StartGlobal30sUpgradePipeline
local SolveBranchAndRewardsTasks
local AutoRecycleBagItems
local GetBestMonsterFarmPoint
local TeleportToBestFarmPoint
local CheckAndRunBloodCastleOrDemonPlaza
local StartNewbieQuestPipeline

-- =========================================================================
-- [CẤU HÌNH MAP TRAVEL]: BẢNG CẤU HÌNH CÁC NHIỆM VỤ CHUYỂN MAP ("ĐẾN...")
-- =========================================================================
local MAP_TRAVEL_TASKS = {
    [3050] = { name = "Devias", targetMap = 1003, x = 215, y = 45, altMaps = { 1003 } },
    [3101] = { name = "Dungeon", targetMap = 100201, x = 109, y = 247, altMaps = { 100201, 100202, 100203 } },
    [3106] = { name = "Lost Tower Tầng 2", targetMap = 100502, x = 193, y = 30, altMaps = { 100501, 100502, 100503, 100504, 100505, 100506, 100507 } },
    [3107] = { name = "Lost Tower Tầng 2", targetMap = 100502, x = 193, y = 30, altMaps = { 100501, 100502, 100503, 100504, 100505, 100506, 100507 } },
    [3200] = { name = "Atlantis", targetMap = 1008, x = 72, y = 43, altMaps = { 1008, 100801 } },
    [3224] = { name = "Aida", targetMap = 1010, x = 60, y = 60, altMaps = { 1010 } },
    [3234] = { name = "Icarus", targetMap = 1011, x = 15, y = 13, altMaps = { 1011 } },
    [3244] = { name = "Phế Tích Kanturu", targetMap = 1012, x = 50, y = 50, altMaps = { 1012 } },
    [3254] = { name = "Di Chỉ Kanturu", targetMap = 1013, x = 50, y = 50, altMaps = { 1013 } },
}
_G.MAP_TRAVEL_TASKS = MAP_TRAVEL_TASKS

-- =========================================================================
-- [CẤU HÌNH MÁY CHỦ FARM MỤC TIÊU - TARGET SERVER CONFIG]
-- =========================================================================
_G.TARGET_SERVER_ID = _G.TARGET_SERVER_ID or 491 -- ID Server chỉ định (VD: 491 -> S491). Sau này Mod UI sẽ set biến này trước khi Start.
_G.TARGET_SERVER_NAME = _G.TARGET_SERVER_NAME or "S491"

-- =========================================================================
-- 1. CẤU HÌNH BOT (CHỈ ĐỊNH SERVER FARM & MULTI-ROLE)
-- =========================================================================
_G.BotAccounts = {
    [1] = {
        account = "accmuvh0001@gmail.com",
        password = "12345ZXC",
        targetServer = _G.TARGET_SERVER_ID or 491, -- Server S491 chỉ định
        roles = {
            [1] = {
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            },
            [2] = {
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            },
            [3] = {
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            },
            [4] = {
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            }
        }
    }
}

_G.CurrentAccountIndex = 1
_G.CurrentRoleIndex = 1
_G.TargetRoleIndex = 1
_G.TotalRolesInCurrentAccount = 1

local function GetCurrentAccount()
    if not _G.BotAccounts or #_G.BotAccounts == 0 then
        return {
            account = "accmuvh0001@gmail.com",
            password = "12345ZXC",
            targetServer = 491, -- Server S491 mới nhất
            roles = {}
        }
    end
    local accIdx = _G.CurrentAccountIndex or 1
    if accIdx < 1 or accIdx > #_G.BotAccounts then
        accIdx = 1
        _G.CurrentAccountIndex = 1
    end
    return _G.BotAccounts[accIdx]
end
_G.GetCurrentAccount = GetCurrentAccount

-- Hàm lấy cấu hình hợp nhất cho Role hiện tại theo RoleIndex (1, 2, 3, 4) hoặc RoleName
local function GetCurrentRoleConfig(roleIndex, roleName)
    local curAcc = GetCurrentAccount()
    local cfg = nil
    if curAcc.roles then
        -- 1. Ưu tiên tìm theo Index (1, 2, 3, 4) - Chuẩn cho API cấu hình theo mảng thứ tự
        if roleIndex and curAcc.roles[roleIndex] then
            cfg = curAcc.roles[roleIndex]
        -- 2. Tìm theo Tên (nếu có truyền tên)
        elseif roleName and curAcc.roles[roleName] then
            cfg = curAcc.roles[roleName]
        else
            for _, rCfg in pairs(curAcc.roles) do
                if type(rCfg) == "table" and rCfg.name and roleName and string.lower(tostring(rCfg.name)) == string.lower(tostring(roleName)) then
                    cfg = rCfg
                    break
                end
            end
        end
        -- 3. Mặc định fallback về role 3
        if not cfg and curAcc.roles[3] then
            cfg = curAcc.roles[3]
        end
    end

    local merged = {}
    for k, v in pairs(curAcc) do
        if k ~= "roles" then merged[k] = v end
    end
    if cfg then
        for k, v in pairs(cfg) do
            merged[k] = v
        end
    end
    return merged
end
_G.GetCurrentRoleConfig = GetCurrentRoleConfig

local function GetActiveConfig()
    local rIdx = _G.CurrentRoleIndex or 1
    _G.ActiveRoleIndex = rIdx
    _G.ActiveRoleConfig = GetCurrentRoleConfig(rIdx)
    return _G.ActiveRoleConfig
end
_G.GetActiveConfig = GetActiveConfig
_G.ActiveRoleConfig = GetActiveConfig()

local curInitAcc = GetCurrentAccount()
Log("=========================================================================")
Log(string.format("=== KHỞI ĐỘNG CHU TRÌNH BOT FARM (ACC %d/%d: %s | S%s | ROLE %d/4) ===", 
    _G.CurrentAccountIndex or 1, #_G.BotAccounts, tostring(curInitAcc.account), tostring(curInitAcc.targetServer or (_G.GetCurrentServerId and _G.GetCurrentServerId()) or 'Auto'), _G.CurrentRoleIndex or 1))
Log("Thời gian: " .. os.date("%Y-%m-%d %H:%M:%S") .. " | Step Delay: " .. tostring(DELAY) .. "s")
Log("=========================================================================")

-- Hủy bỏ các listener cũ nếu đã từng chạy
if _G.TestEventContainer then
    pcall(function() _G.TestEventContainer:UnRegistAll() end)
end
_G.TestEventContainer = EventContainer(EventManager)

-- =========================================================================
-- 2. HỆ THỐNG MÃ HÓA CHUẨN SDK (XXTEA + MD5 + BASE64)
-- =========================================================================
local SDK_SALT = "oxKddFw0opc2ayAqm-WJCfzwdukeFwMFxPy6ClJWe_s"
local SDK_SIGNATURE = "YhAY9FjSeo2WC7oeyhhoGZupa8g"

local function MD5(str)
    if CS and CS.PCUtility and CS.PCUtility.Md5 then
        return string.lower(CS.PCUtility.Md5(str))
    end
    return ""
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Base64Encode(bytes)
    local result = {}
    local len = #bytes
    for i = 1, len, 3 do
        local b1 = string.byte(bytes, i)
        local b2 = (i + 1 <= len) and string.byte(bytes, i + 1) or 0
        local b3 = (i + 2 <= len) and string.byte(bytes, i + 2) or 0
        
        local n = (b1 << 16) | (b2 << 8) | b3
        
        local c1 = (n >> 18) & 63
        local c2 = (n >> 12) & 63
        local c3 = (n >> 6) & 63
        local c4 = n & 63
        
        table.insert(result, string.sub(b64chars, c1 + 1, c1 + 1))
        table.insert(result, string.sub(b64chars, c2 + 1, c2 + 1))
        if i + 1 <= len then
            table.insert(result, string.sub(b64chars, c3 + 1, c3 + 1))
        else
            table.insert(result, "=")
        end
        if i + 2 <= len then
            table.insert(result, string.sub(b64chars, c4 + 1, c4 + 1))
        else
            table.insert(result, "=")
        end
    end
    return table.concat(result)
end

local function UrlEncode(str)
    if not str then return "" end
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w %-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "+")
    return str
end

local function ToIntArray(bStr, isIncludeLength)
    local len = #bStr
    local n = ((len & 3) == 0) and (len >> 2) or ((len >> 2) + 1)
    local result = {}
    local totalInts = isIncludeLength and (n + 1) or n
    for i = 1, totalInts do result[i] = 0 end
    if isIncludeLength then result[totalInts] = len end
    for i = 1, len do
        local byteVal = string.byte(bStr, i)
        local idx = (i - 1) >> 2
        local shift = ((i - 1) & 3) << 3
        result[idx + 1] = result[idx + 1] | (byteVal << shift)
    end
    return result
end

local function ToByteArray(ints)
    local len = #ints << 2
    local bytes = {}
    for i = 1, len do
        local idx = (i - 1) >> 2
        local shift = ((i - 1) & 3) << 3
        local byteVal = (ints[idx + 1] >> shift) & 255
        table.insert(bytes, string.char(byteVal))
    end
    return table.concat(bytes)
end

local function FixKey(kStr)
    local len = #kStr
    if len == 16 then return kStr end
    local bytes = {}
    for i = 1, 16 do
        if i <= len then
            table.insert(bytes, string.sub(kStr, i, i))
        else
            table.insert(bytes, string.char(0))
        end
    end
    return table.concat(bytes)
end

local function XXTEA_Encrypt(dataStr, keyStr)
    if #dataStr == 0 then return dataStr end
    local v = ToIntArray(dataStr, true)
    local k = ToIntArray(FixKey(keyStr), false)
    local n = #v - 1
    if n < 1 then return dataStr end
    
    local z = v[#v]
    local y = v[1]
    local DELTA = 0x9E3779B9
    local q = 6 + (52 // (#v))
    local sumVal = 0
    local MASK = 0xFFFFFFFF
    
    while q > 0 do
        sumVal = (sumVal + DELTA) & MASK
        local e = (sumVal >> 2) & 3
        for p = 0, n - 1 do
            y = v[p + 2]
            local kIdx = ((p & 3) ~ e) + 1
            local mx = ((( (z >> 5) ~ (y << 2) ) + ( (y >> 3) ~ (z << 4) )) ~ ((sumVal ~ y) + (k[kIdx] ~ z))) & MASK
            v[p + 1] = (v[p + 1] + mx) & MASK
            z = v[p + 1]
        end
        y = v[1]
        local kIdx = ((n & 3) ~ e) + 1
        local mx = ((( (z >> 5) ~ (y << 2) ) + ( (y >> 3) ~ (z << 4) )) ~ ((sumVal ~ y) + (k[kIdx] ~ z))) & MASK
        v[#v] = (v[#v] + mx) & MASK
        z = v[#v]
        q = q - 1
    end
    
    return ToByteArray(v)
end

-- =========================================================================
-- 3. FOV & SPEED HACK (FOV = 65 MẶC ĐỊNH TOÀN GAME, SPEED = 2.0X CHUẨN KHÔNG NHÂN DỒN)
-- =========================================================================
_G.GLOBAL_FOV = 65
_G.GLOBAL_SPEED_MULT = 2.0

local function ApplyFovAndSpeed()
    pcall(function()
        local targetFov = _G.GLOBAL_FOV or 65
        _G.RunSpeedMultiplier = _G.GLOBAL_SPEED_MULT or 2.0

        if CS and CS.UnityEngine and CS.UnityEngine.Camera and CS.UnityEngine.Camera.main then
            CS.UnityEngine.Camera.main.fieldOfView = targetFov
        end

        if _G.MainCamera then
            if _G.MainCamera.camera then
                _G.MainCamera.camera.fieldOfView = targetFov
            end

            if not _G.ModCameraHooked then
                _G.ModCameraHooked = true
                local orig_AttachRole = _G.MainCamera.AttachRole
                _G.MainCamera.AttachRole = function(role)
                    if orig_AttachRole then orig_AttachRole(role) end
                    pcall(function()
                        local fov = _G.GLOBAL_FOV or 65
                        if _G.MainCamera.camera then _G.MainCamera.camera.fieldOfView = fov end
                        if CS and CS.UnityEngine and CS.UnityEngine.Camera and CS.UnityEngine.Camera.main then
                            CS.UnityEngine.Camera.main.fieldOfView = fov
                        end
                    end)
                end

                local orig_Reset = _G.MainCamera.Reset
                _G.MainCamera.Reset = function()
                    if orig_Reset then orig_Reset() end
                    pcall(function()
                        local fov = _G.GLOBAL_FOV or 65
                        if _G.MainCamera.camera then _G.MainCamera.camera.fieldOfView = fov end
                    end)
                end

                local orig_LoginRoleSet = _G.MainCamera.LoginRoleCameraSet
                _G.MainCamera.LoginRoleCameraSet = function()
                    if orig_LoginRoleSet then orig_LoginRoleSet() end
                    pcall(function()
                        local fov = _G.GLOBAL_FOV or 65
                        if _G.MainCamera.camera then _G.MainCamera.camera.fieldOfView = fov end
                    end)
                end
            end
        end

        if _G.Role then
            if not _G.RawOriginal_Role_SetMoveSpeed then
                _G.RawOriginal_Role_SetMoveSpeed = _G.Role.SetMoveSpeed
            end
            local raw_SetMoveSpeed = _G.RawOriginal_Role_SetMoveSpeed
            _G.Role.SetMoveSpeed = function(self, moveSpeed, isFromMod)
                if self and self.isMe then
                    -- Luôn lấy tốc độ gốc chuẩn từ thuộc tính nhân vật (Chống nhân dồn lũy kế 2.5x * 2.5x...)
                    local base = 5.0
                    if self.GetMoveSpeedByAttribute then
                        local b = self:GetMoveSpeedByAttribute()
                        if b and b > 0 and b <= 10.0 then base = b end
                    elseif self.data and self.data.GetAttribute and _G.EAttributeType and _G.EAttributeType.moveSpeed then
                        local b = self.data:GetAttribute(_G.EAttributeType.moveSpeed) * 0.01
                        if b and b > 0 and b <= 10.0 then base = b end
                    elseif moveSpeed and moveSpeed > 0 and moveSpeed <= 8.0 and not isFromMod then
                        base = moveSpeed
                    end

                    local mult = _G.RunSpeedMultiplier or _G.GLOBAL_SPEED_MULT or 2.0
                    if mult < 1.0 then mult = 1.0 end
                    if mult > 5.0 then mult = 5.0 end

                    local finalSpeed = base * mult
                    raw_SetMoveSpeed(self, finalSpeed)
                else
                    raw_SetMoveSpeed(self, moveSpeed)
                end
            end
        end

        if _G.Me and not _G.Mod_Hooked_Me_ChangePos then
            _G.Mod_Hooked_Me_ChangePos = true
            local old_Me_ChangePos = _G.Me.ChangePos
            _G.Me.ChangePos = function(self, moveType, changeReason, reasonParam)
                if self.isMe and _G.ERoleChangePosReason and changeReason == _G.ERoleChangePosReason.MoveFailed then
                    return
                end
                return old_Me_ChangePos(self, moveType, changeReason, reasonParam)
            end
        end

        local pMe = _G.RoleManager and _G.RoleManager.me
        if pMe and pMe.SetMoveSpeed then
            local baseSpeed = (pMe.GetMoveSpeedByAttribute and pMe:GetMoveSpeedByAttribute()) or 5.0
            pMe:SetMoveSpeed(baseSpeed, true)
        end
    end)
end

-- Timer duy trì liên tục FOV = 65 không bao giờ bị mất khi đổi map
if not _G.Mod_FOV_TimerStarted then
    _G.Mod_FOV_TimerStarted = true
    pcall(function()
        if _G.Timer and _G.Timer.StartLoopForever then
            _G.Timer.StartLoopForever(0.5, function()
                pcall(function()
                    local targetFov = _G.GLOBAL_FOV or 65
                    local cam = CS.UnityEngine.Camera.main
                    if cam and math.abs(cam.fieldOfView - targetFov) > 0.5 then
                        cam.fieldOfView = targetFov
                    end
                    if _G.MainCamera and _G.MainCamera.camera and math.abs(_G.MainCamera.camera.fieldOfView - targetFov) > 0.5 then
                        _G.MainCamera.camera.fieldOfView = targetFov
                    end
                end)
            end)
        elseif _G.Timer and _G.Timer.StartLoop then
            _G.Timer.StartLoop(0.5, -1, function()
                pcall(function()
                    local targetFov = _G.GLOBAL_FOV or 65
                    local cam = CS.UnityEngine.Camera.main
                    if cam and math.abs(cam.fieldOfView - targetFov) > 0.5 then
                        cam.fieldOfView = targetFov
                    end
                    if _G.MainCamera and _G.MainCamera.camera and math.abs(_G.MainCamera.camera.fieldOfView - targetFov) > 0.5 then
                        _G.MainCamera.camera.fieldOfView = targetFov
                    end
                end)
            end)
        end
    end)
end

-- =========================================================================
-- 4. HOOK TỰ ĐỘNG NHẶT TỨC THÌ KHI MỞ RƯƠNG VÀNG (INSTANT BATCH LOOT HOOK)
-- =========================================================================
_G.Mod_GoldenChestBatchIds = _G.Mod_GoldenChestBatchIds or {}
_G.Mod_AutoOpenGoldenChest_Enabled = false
_G.Mod_GoldenChestState = "INIT_CLEAN"
_G.Mod_GoldenChestWaitTime = 0

-- Hook ConditionalMgr để chặn AI tự di chuyển tới vị trí đồ rơi khi đang mở rương
if _G.ConditionalMgr then
    local orig_CanAutoPickUp = _G.ConditionalMgr.CanAutoPickUpDropItem
    _G.ConditionalMgr.CanAutoPickUpDropItem = function(self, itemInfo)
        if _G.Mod_AutoOpenGoldenChest_Enabled then return false end
        if orig_CanAutoPickUp then return orig_CanAutoPickUp(self, itemInfo) end
        return false
    end

    local orig_CanPickUp = _G.ConditionalMgr.CanPickUpDropItem
    _G.ConditionalMgr.CanPickUpDropItem = function(self, itemInfo)
        if _G.Mod_AutoOpenGoldenChest_Enabled then return false end
        if orig_CanPickUp then return orig_CanPickUp(self, itemInfo) end
        return false
    end
end

-- Hook PickupItemNode để chặn hành vi nhặt mặc định làm chậm tiến trình
if _G.PickupItemNode and not _G.Mod_HookedPickupNode then
    _G.Mod_HookedPickupNode = true
    local orig_Visit = _G.PickupItemNode.Visit
    _G.PickupItemNode.Visit = function(self)
        if _G.Mod_AutoOpenGoldenChest_Enabled then
            self.status = (_G.BehaviorStatusEnum and _G.BehaviorStatusEnum.FAILED) or 3
            return
        end
        if orig_Visit then return orig_Visit(self) end
    end
end

-- Hook PickupManager.AddDropSceneCellPos để chụp ID đồ rơi ngay lập tức
pcall(function()
    if _G.PickupManager and not _G.Mod_Hooked_Pickup_Chest then
        _G.Mod_Hooked_Pickup_Chest = true
        local orig_AddDropSceneCellPos = _G.PickupManager.AddDropSceneCellPos
        _G.PickupManager.AddDropSceneCellPos = function(item)
            if orig_AddDropSceneCellPos then orig_AddDropSceneCellPos(item) end
            if not (item and item.data) then return end
            local dropItemData = item.data

            if _G.Mod_AutoOpenGoldenChest_Enabled then
                pcall(function()
                    local objId = dropItemData.id or dropItemData.objId or (dropItemData.item and dropItemData.item.id)
                    if objId then
                        _G.Mod_GoldenChestBatchIds = _G.Mod_GoldenChestBatchIds or {}
                        table.insert(_G.Mod_GoldenChestBatchIds, objId)

                        -- Gửi ngay gói tin nhặt lập tức
                        if _G.PickupManager and _G.PickupManager.ReqPickUpMapItems then
                            _G.PickupManager.ReqPickUpMapItems(_G.Mod_GoldenChestBatchIds)
                        elseif _G.networkRequest and _G.networkRequest.ReqPickUpMapItems then
                            _G.networkRequest.ReqPickUpMapItems(_G.Mod_GoldenChestBatchIds)
                        elseif _G.PickupManager and _G.PickupManager.ReqPickUpMapItem then
                            _G.PickupManager.ReqPickUpMapItem(objId)
                        end
                    end
                end)
            end
        end
    end
end)

-- Hút sạch toàn bộ vật phẩm đang rơi trên mặt đất (Batch Ids + DropItemManager)
local function VacuumAllMapDropItems()
    pcall(function()
        local allIds = {}
        
        -- 1. Lấy từ danh sách BatchIds vừa rơi
        if _G.Mod_GoldenChestBatchIds then
            for _, id in ipairs(_G.Mod_GoldenChestBatchIds) do
                table.insert(allIds, id)
            end
        end

        -- 2. Lấy từ DropItemManager table
        if _G.DropItemManager and _G.DropItemManager.GetDropItemById then
            local _, val = debug.getupvalue(_G.DropItemManager.GetDropItemById, 1)
            if type(val) == "table" then
                for id, dItem in pairs(val) do
                    if id then table.insert(allIds, id) end
                end
            end
        end

        -- 3. Phát gói tin nhặt hàng loạt
        if #allIds > 0 then
            if _G.PickupManager and _G.PickupManager.ReqPickUpMapItems then
                _G.PickupManager.ReqPickUpMapItems(allIds)
            elseif _G.networkRequest and _G.networkRequest.ReqPickUpMapItems then
                _G.networkRequest.ReqPickUpMapItems(allIds)
            end
            for _, id in ipairs(allIds) do
                if _G.PickupManager and _G.PickupManager.ReqPickUpMapItem then
                    _G.PickupManager.ReqPickUpMapItem(id)
                end
            end
        end
    end)
end

-- =========================================================================
-- 5. DỌN DẸP POPUP & LOGOUT RA LOGIN SCENE
-- =========================================================================
DismissBlockers = function()
    pcall(function()
        if LoginData then LoginData.equipmentList = nil end
        if UIManager then
            if UIID and UIID.WaitingUI then UIManager.Hide(UIID.WaitingUI) end
            if UIID and UIID.PromptTipUI then UIManager.Hide(UIID.PromptTipUI) end
            if UIID and UIID.OnHookProfitUI then UIManager.Hide(UIID.OnHookProfitUI) end
            if UIID and UIID.AttributeAddTipsUI then UIManager.Hide(UIID.AttributeAddTipsUI) end
            if UIID and UIID.Role_AttributeUI then UIManager.Hide(UIID.Role_AttributeUI) end
            UIManager.Hide("Attribute_AddTipsUI")
            UIManager.Hide("Role_AttributeUI")
            UIManager.Hide("OnHook_ProfitUI")
            UIManager.Hide("AutoPopUIManager")
            UIManager.Hide("DailySignUI")
            UIManager.Hide("Welfare_WelfareUI")
        end
        
        -- Tự động bấm Chuyển nhanh khi bảng Chuyển Trang Bị xuất hiện
        local transferUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Equip_ZhuanyiFastUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.Equip_ZhuanyiFastUI)))
        if transferUI and transferUI.btn_confirm and not IsObjectNil(transferUI.btn_confirm) and transferUI.btn_confirm.gameObject.activeInHierarchy then
            pcall(function()
                if _G.RoleManager and _G.RoleManager.me then
                    _G.PlayerPrefs.SetString(tostring(_G.RoleManager.me.id), "noFirst")
                end
                if transferUI.btn_confirmOnClick then
                    transferUI:btn_confirmOnClick(transferUI.btn_confirm)
                elseif transferUI.btn_confirm.OnClick then
                    transferUI.btn_confirm:OnClick()
                end
                Log("[Chuyển Cường Hóa] : Đã tự động bấm Chuyển Nhanh thuộc tính sang đồ mới", true)
            end)
        end
        
        -- Tự động bấm Trang bị ngay khi nhặt được đồ xịn hơn
        local tipUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Equip_TIpsUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.Equip_TIpsUI)))
        if tipUI and tipUI.btn_quickequip and not IsObjectNil(tipUI.btn_quickequip) and tipUI.btn_quickequip.gameObject.activeInHierarchy then
            pcall(function()
                if tipUI.Btn_quickequip then
                    tipUI:Btn_quickequip()
                elseif tipUI.btn_quickequipOnClick then
                    tipUI:btn_quickequipOnClick(tipUI.btn_quickequip)
                end
            end)
        end
        
        local auctionTipUI = _G.UIManager and _G.UIManager.GetUiByName and (_G.UIManager.GetUiByName("Auction_RecommendTIpsUI") or (_G.UIID and _G.UIManager.GetUiByName(_G.UIID.Auction_RecommendTIpsUI)))
        if auctionTipUI and auctionTipUI.btn_quickequip and not IsObjectNil(auctionTipUI.btn_quickequip) and auctionTipUI.btn_quickequip.gameObject.activeInHierarchy then
            pcall(function()
                if auctionTipUI.btn_quickequipOnClick then
                    auctionTipUI:btn_quickequipOnClick(auctionTipUI.btn_quickequip)
                end
            end)
        end

        -- Tự động bấm Mở Ngay phó bản nếu đang trong phó bản
        local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
        local inBC = (curMap >= 1012000 and curMap <= 1012099)
        local inDS = (curMap >= 1010000 and curMap <= 1010099)
        if inBC or inDS or (_G.TranScriptData and _G.TranScriptData.InTranscript) then
            TriggerDungeonSkipWait()
        end

        if CS and CS.MuInterface and CS.MuInterface.Instance and CS.MuInterface.Instance.HideView then
            CS.MuInterface.Instance:HideView()
        end
        if CS and CS.LauncherUI and CS.LauncherUI.Close then
            CS.LauncherUI.Close()
        end
    end)
end

ForceLogoutToLogin = function()
    Log("--- THỰC HIỆN ĐĂNG XUẤT RA MÀN HÌNH LOGIN ---")
    _G.Bot_IsInGameWorld = false
    _G.IsRoleCreating = false
    _G.HasCreatedRoleForTarget = false
    if _G.BotQuestMonitorTimer then
        pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
        _G.BotQuestMonitorTimer = nil
    end
    DismissBlockers()
    pcall(function()
        if NetManager and NetManager.IsConnect and NetManager.IsConnect() then
            NetManager.Send(UserMessage.ReqLogout, { reason = 5 })
        end
    end)
    pcall(function()
        if EventManager and EventManager.Dispatch then
            EventManager.Dispatch(Event.GamePlay_Leave)
        end
    end)
    pcall(function()
        if NetManager and NetManager.Close then
            NetManager.Close()
        end
    end)
    pcall(function()
        if UIManager then
            UIManager.HideAll()
            if UIID and UIID.LoginCreateRoleUI then UIManager.Hide(UIID.LoginCreateRoleUI) end
            if UIID and UIID.LoginRoleUI then UIManager.Hide(UIID.LoginRoleUI) end
        end
    end)
    pcall(function()
        if Scene and Scene.EnterLogin then
            Scene.EnterLogin()
        end
    end)
    pcall(function()
        if LoginData then
            LoginData.InGame = false
            LoginData.roleId = 0
            LoginData.accessToken = ""
            LoginData.sign = ""
            LoginData.equipmentList = nil
            LoginData.roleList = {}
        end
    end)
    SaveOutput()
end

-- =========================================================================
-- 6. LỌC ĐỒ & THU HỒI / TÁCH TRANG BỊ
-- =========================================================================
local function IsGoodItem(item, subType, excDesList)
    local activeCfg = GetActiveConfig()
    if not activeCfg.keepGoodLines then return false end

    local sInfo = item.serverInfo or item.serverData or {}
    local specialEffectIds = item.specialEffectIds or sInfo.specialEffectIds or item.specials or sInfo.specials
    if specialEffectIds then
        local hasSpecial = false
        pcall(function()
            if type(specialEffectIds) == "table" then
                hasSpecial = (_G.next(specialEffectIds) ~= nil)
            elseif type(specialEffectIds) == "userdata" then
                local count = specialEffectIds.Count or specialEffectIds.Length
                if count and count > 0 then hasSpecial = true end
            end
        end)
        if hasSpecial then return true end
    end

    if not excDesList or #excDesList == 0 then return false end

    if subType == 113 or subType == 114 or subType == 115 or subType == 116 or subType == 117 then
        for _, des in ipairs(excDesList) do
            if string.find(des, "MP tối đa") or string.find(des, "Vàng") or string.find(des, "vàng") then
                return false
            end
        end
        return true
    end

    if subType == 101 or subType == 106 or subType == 108 or subType == 109 or subType == 124 or subType == 181 then
        for _, des in ipairs(excDesList) do
            if string.find(des, "diệt quái") or string.find(des, "HP tăng") or string.find(des, "MP tăng") then
                return false
            end
        end
        return true
    end

    if subType == 36 or subType == 35 or subType == 38 then
        local hasGood = false
        for _, des in ipairs(excDesList) do
            local isCap = string.find(des, "cấp/20") or string.find(des, "cấp")
            local isGoodLine = (string.find(des, "Công Tốc") or string.find(des, "Tấn công")) and not isCap
            if isGoodLine then hasGood = true else return false end
        end
        return hasGood
    end

    if subType == 34 or subType == 37 then
        local hasGood = false
        for _, des in ipairs(excDesList) do
            if string.find(des, "Phòng Ngự") or string.find(des, "Phản DMG") or string.find(des, "Phản") then
                hasGood = true
            else
                return false
            end
        end
        return hasGood
    end

    if subType == 18 or subType == 19 then
        for _, des in ipairs(excDesList) do
            local isValid = false
            if string.find(des, "Công Tốc +2", 1, true) then isValid = true
            elseif string.find(des, "Tỷ lệ Đòn Trác Việt +3.0%", 1, true) then isValid = true
            elseif string.find(des, "Tấn công +cấp/20.0", 1, true) then isValid = true
            elseif string.find(des, "Tấn công +1.0%", 1, true) then isValid = true
            end
            if not isValid then return false end
        end
        return true
    end

    if subType == 26 then
        for _, des in ipairs(excDesList) do
            local isValid = false
            if string.find(des, "Sát thương giảm +2.0%", 1, true) then isValid = true
            elseif string.find(des, "Phản DMG +4.0%", 1, true) then isValid = true
            elseif string.find(des, "Tỉ lệ Phòng Ngự thành công +5.0%", 1, true) then isValid = true
            elseif string.find(des, "HP tối đa +3.0%", 1, true) then isValid = true
            end
            if not isValid then return false end
        end
        return true
    end

    return false
end

-- =========================================================================
-- [QUY TẮC LỌC TRANG BỊ THU HỒI CHUẨN CLIENT - MỞ RƯƠNG VÀNG & TÚI ĐỒ]
-- Mô tả: CHỈ thu hồi Quần áo (subType 13..17) và Vũ khí (subType 1..12, 24, 25, 56, 57, 81).
--        TUYỆT ĐỐI KHÔNG thu hồi Cánh, Nhẫn, Dây chuyền, Ngọc, Sách kỹ năng, Bình máu/mana, Rương, Vé.
-- =========================================================================
local function IsRecyclableEquipment(item)
    if not item or not item.id then return false end
    local tblItem = item.tblItem or (item.data and item.data.tblItem)
    if not tblItem then return false end
    
    local itemId = item.itemId or tblItem.id or (item.data and item.data.itemId) or 0
    local itemType = tblItem.type or 0
    local subType = tblItem.subType or 0
    local itemName = tostring(tblItem.name or item.name or "")
    
    -- 1. Phải là Trang bị (type == 2 hoặc có cấu hình trong cfg_Item_equip)
    local isEquipType = (itemType == 2) or (item.tblEquip ~= nil)
    if not isEquipType and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager and itemId > 0 then
        local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
        if eq then isEquipType = true end
    end
    if not isEquipType then return false end

    -- 2. Phân loại theo chuẩn subtype client:
    --    - Quần áo / Giáp trụ: 13 (Mũ), 14 (Áo), 15 (Quần), 16 (Găng), 17 (Giày)
    --    - Vũ khí: 1..12, 24, 25, 56, 57, 81 (Kiếm, Rìu, Chùy, Giáo, Cung, Nỏ, Trượng, Khiên, v.v.)
    local isArmor = (subType >= 13 and subType <= 17)
    local isWeapon = ((subType >= 1 and subType <= 12) or subType == 24 or subType == 25 or subType == 56 or subType == 57 or subType == 81)
    
    -- CHỈ thu hồi Quần áo & Vũ khí, TUYỆT ĐỐI không động vào các loại khác
    if not (isArmor or isWeapon) then return false end

    -- 3. Phải có giá bán thu hồi
    if string.isNullOrEmpty(tblItem.sell) then return false end

    -- 4. Bỏ qua trang bị đang mặc trên người
    if item.bagGridIndex and item.bagGridIndex >= 100 then return false end
    if item.isEquiped and type(item.isEquiped) == "function" and item:isEquiped() then return false end

    -- 5. Bỏ qua trang bị đã được cường hóa hoặc tiến cấp
    if item.intensify and item.intensify > 0 then return false end
    if item.additional and item.additional > 0 then return false end

    -- 6. Bỏ qua nếu là Cánh, Nhẫn, Dây chuyền, Bông tai hoặc vật phẩm đặc biệt
    if subType == 18 or subType == 19 or subType == 20 or subType == 21 or subType == 22 or subType == 26 then return false end
    if string.find(itemName, "Cánh") or string.find(itemName, "Nhẫn") or string.find(itemName, "Chuyền") then return false end

    -- 7. Kiểm tra dòng Trác Việt ngon (nếu bật cấu hình giữ dòng)
    local activeCfg = GetActiveConfig()
    if activeCfg and activeCfg.keepGoodLines then
        local excDesList = {}
        local sInfo = item.serverInfo or item.serverData or {}
        local rawExc = item.excellence or sInfo.excellentList or sInfo.excellentInfo or sInfo.excellentAttrs
        local tblEquip = item.tblEquip or {}
        if (not tblEquip.id) and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager and itemId > 0 then
            local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
            if eq then tblEquip = eq end
        end

        if _G.RoleEquipUtility then
            if rawExc and _G.RoleEquipUtility.GetEquipExcellence then
                pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellence(rawExc, tblEquip) end)
            end
            if (#excDesList == 0) and _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo then
                pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo(sInfo) end)
            end
        end
        if (#excDesList == 0) and item.GetEquipExcellenceDesList then
            pcall(function() excDesList = item:GetEquipExcellenceDesList() end)
        end

        if IsGoodItem and IsGoodItem(item, subType, excDesList) then
            return false
        end
    end

    return true
end
_G.IsRecyclableEquipment = IsRecyclableEquipment

-- 1. Thu hồi đồ Trác Việt thường
local function PerformRecycleExcellence()
    local activeCfg = GetActiveConfig()
    if not activeCfg.autoRecycleExcellence then return end
    pcall(function()
        local items = _G.BagInfoData and _G.BagInfoData.TotalItems
        if not items and _G.BagInfoData and _G.BagInfoData.GetTotalItems then
            pcall(function() items = _G.BagInfoData:GetTotalItems() end)
        end
        if not items then return end

        local recycleMap = {}
        local recycleCount = 0

        for k, item in pairs(items) do
            if item then
                local tblItem = item.tblItem or (item.data and item.data.tblItem) or {}
                local tblEquip = item.tblEquip or (item.data and item.data.tblEquip) or {}
                local itemType = tblItem.type or 0
                local itemId = tblItem.id or item.itemId or (item.data and item.data.itemId) or 0
                local subType = tblItem.subType or 0
                local itemCount = item.count or (item.data and item.data.count) or 1

                if itemType == 2 or (tblEquip and tblEquip.id) then
                    if (not tblEquip or not tblEquip.id) and itemId > 0 and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
                        pcall(function()
                            local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
                            if eq then tblEquip = eq end
                        end)
                    end
                    tblEquip = tblEquip or {}

                    local excDesList = {}
                    local sInfo = item.serverInfo or item.serverData or {}
                    local rawExc = item.excellence or sInfo.excellentList or sInfo.excellentInfo or sInfo.excellentAttrs

                    if _G.RoleEquipUtility then
                        if rawExc and _G.RoleEquipUtility.GetEquipExcellence then
                            pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellence(rawExc, tblEquip) end)
                        end
                        if (#excDesList == 0) and _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo then
                            pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo(sInfo) end)
                        end
                    end
                    if (#excDesList == 0) and item.GetEquipExcellenceDesList then
                        pcall(function() excDesList = item:GetEquipExcellenceDesList() end)
                    end

                    local name = tblItem.name or item.name or ""
                    local isExcellenceItem = (string.find(name, "Trác Việt") ~= nil) or (#excDesList > 0)

                    local isArmor = (subType >= 13 and subType <= 17)
                    local isWeapon = ((subType >= 1 and subType <= 12) or subType == 24 or subType == 25 or subType == 56 or subType == 57 or subType == 81)

                    if isExcellenceItem and (isArmor or isWeapon) then
                        local isGood = false
                        if activeCfg.keepGoodLines then
                            if isArmor then
                                local hasHP, hasReflect = false, false
                                for _, str in ipairs(excDesList) do
                                    if str then
                                        if string.find(str, "HP tối đa +4.0%", 1, true) then hasHP = true end
                                        if string.find(str, "Phản DMG +5.0%", 1, true) then hasReflect = true end
                                    end
                                end
                                if hasHP and hasReflect then isGood = true end
                            elseif isWeapon then
                                local hasSpeed, hasAtk = false, false
                                for _, str in ipairs(excDesList) do
                                    if str then
                                        if string.find(str, "Công Tốc +7", 1, true) then hasSpeed = true end
                                        if string.find(str, "Tấn công +2.0%", 1, true) then hasAtk = true end
                                    end
                                end
                                if hasSpeed and hasAtk then isGood = true end
                            end
                        end

                        local GUID = item.id or (item.data and item.data.id)
                        if not isGood and GUID then
                            recycleMap[GUID] = itemCount
                            recycleCount = recycleCount + 1
                        end
                    end
                end
            end
        end

        if recycleCount > 0 then
            local wayType = (_G.RecycleWayType and _G.RecycleWayType.BlackSmith) or 2
            pcall(function()
                if _G.networkRequest and _G.networkRequest.ReqItemRecycle then
                    _G.networkRequest.ReqItemRecycle(recycleMap, wayType)
                elseif _G.NetManager and _G.ItemRecycleMessage and _G.ItemRecycleMessage.ReqItemRecycle then
                    _G.NetManager.Send(_G.ItemRecycleMessage.ReqItemRecycle, { recycleItems = recycleMap, recycleType = wayType })
                end
            end)
            Log("-> Đã gửi lệnh THU HỒI " .. tostring(recycleCount) .. " món đồ Trác Việt rác!")
            SaveOutput()
        end
    end)
end

-- 2. Tách Trang sức Trác Việt & Tách Đồ Bộ
local function PerformSmeltEquipments()
    local activeCfg = GetActiveConfig()
    pcall(function()
        local items = _G.BagInfoData and _G.BagInfoData.TotalItems
        if not items and _G.BagInfoData and _G.BagInfoData.GetTotalItems then
            pcall(function() items = _G.BagInfoData:GetTotalItems() end)
        end
        if not items then return end

        local smeltItems = {}

        for k, item in pairs(items) do
            if item then
                local tblItem = item.tblItem or (item.data and item.data.tblItem) or {}
                local tblEquip = item.tblEquip or (item.data and item.data.tblEquip) or {}
                local itemType = tblItem.type or 0
                local itemId = tblItem.id or item.itemId or (item.data and item.data.itemId) or 0
                local subType = tblItem.subType or 0

                if itemType == 2 or (tblEquip and tblEquip.id) then
                    if (not tblEquip or not tblEquip.id) and itemId > 0 and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
                        pcall(function()
                            local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
                            if eq then tblEquip = eq end
                        end)
                    end
                    tblEquip = tblEquip or {}

                    local shouldSmelt = false

                    if activeCfg.autoSmeltExcellenceAccessory and (subType == 18 or subType == 19 or subType == 26) then
                        shouldSmelt = true
                    end

                    if activeCfg.autoSmeltSuit then
                        local isSuit = (tblEquip.suitId and tblEquip.suitId > 0) or 
                                       (subType == 35 or subType == 38 or subType == 36 or subType == 34 or subType == 37) or
                                       (subType >= 113 and subType <= 117) or
                                       (subType == 101 or subType == 106 or subType == 108 or subType == 109 or subType == 124 or subType == 181)
                        if isSuit then
                            shouldSmelt = true
                        end
                    end

                    if shouldSmelt and activeCfg.keepGoodLines then
                        local excDesList = {}
                        local sInfo = item.serverInfo or item.serverData or {}
                        local rawExc = item.excellence or sInfo.excellentList or sInfo.excellentInfo or sInfo.excellentAttrs

                        if _G.RoleEquipUtility then
                            if rawExc and _G.RoleEquipUtility.GetEquipExcellence then
                                pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellence(rawExc, tblEquip) end)
                            end
                            if (#excDesList == 0) and _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo then
                                pcall(function() excDesList = _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo(sInfo) end)
                            end
                        end
                        if (#excDesList == 0) and item.GetEquipExcellenceDesList then
                            pcall(function() excDesList = item:GetEquipExcellenceDesList() end)
                        end

                        if IsGoodItem(item, subType, excDesList) then
                            shouldSmelt = false
                        end
                    end

                    if shouldSmelt and item.id then
                        table.insert(smeltItems, item.id)
                    end
                end
            end
        end

        if #smeltItems > 0 then
            local batch = {}
            local batchCount = 0
            for i, id in ipairs(smeltItems) do
                table.insert(batch, id)
                if #batch >= 4 or i == #smeltItems then
                    if _G.networkRequest and _G.networkRequest.ReqEquipDecompose then
                        _G.networkRequest.ReqEquipDecompose(batch)
                        batchCount = batchCount + #batch
                    end
                    batch = {}
                end
            end
            Log("-> Đã gửi lệnh TÁCH " .. tostring(batchCount) .. " món Đồ Bộ & Trang Sức Trác Việt!")
            SaveOutput()
        end
    end)
end

-- =========================================================================
-- 7. MỞ RƯƠNG VÀNG THEO ĐỢT (MỞ 20 -> HÚT ĐỒ -> THU HỒI/TÁCH 20 ĐỒ -> MỞ TIẾP)
-- =========================================================================
StartGoldenChestProcess = function(onFinished)
    Log("--- [BƯỚC 5] BẮT ĐẦU MỞ RƯƠNG VÀNG (BATCH 20/20 LOOT & SMELT) ---")
    ApplyFovAndSpeed()

    _G.Mod_AutoOpenGoldenChest_Enabled = true
    _G.Mod_GoldenChestState = "INIT_CLEAN"
    _G.Mod_GoldenChestWaitTime = 0
    _G.Mod_GoldenChestBatchIds = {}
    local openedBatchCount = 0

    local chestTimer = nil
    chestTimer = Timer.StartLoopForever(0.1, function()
        if not _G.Mod_AutoOpenGoldenChest_Enabled then
            if chestTimer then Timer.Stop(chestTimer) end
            return
        end

        pcall(function()
            local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.clock()

            -- 1. Dọn dẹp túi ban đầu trước khi mở đợt đầu tiên
            if _G.Mod_GoldenChestState == "INIT_CLEAN" then
                Log("-> [PRE-CLEAN] Dọn sạch túi đồ rác trước khi mở rương...")
                PerformRecycleExcellence()
                PerformSmeltEquipments()
                VacuumAllMapDropItems()
                _G.Mod_GoldenChestWaitTime = nowTime + DELAY
                _G.Mod_GoldenChestState = "WAIT_INIT"

            elseif _G.Mod_GoldenChestState == "WAIT_INIT" then
                VacuumAllMapDropItems()
                if nowTime >= (_G.Mod_GoldenChestWaitTime or 0) then
                    _G.Mod_GoldenChestState = "OPEN"
                end

            -- 2. Tìm rương vàng trong túi và mở tối đa 20 cái
            elseif _G.Mod_GoldenChestState == "OPEN" then
                local activeCfg = GetActiveConfig()
                local maxBatches = activeCfg.maxChestBatches or 3
                if openedBatchCount >= maxBatches then
                    _G.Mod_AutoOpenGoldenChest_Enabled = false
                    if chestTimer then Timer.Stop(chestTimer) end

                    Log(string.format("-> [TEST LIMIT] ĐÃ HOÀN THÀNH %d ĐỢT MỞ RƯƠNG VÀNG! Dừng mở để giữ rương test tiếp...", openedBatchCount))
                    VacuumAllMapDropItems()
                    PerformRecycleExcellence()
                    PerformSmeltEquipments()
                    SaveOutput()

                    if onFinished then
                        Timer.Start(DELAY, function() onFinished() end)
                    end
                    return
                end

                local items = _G.BagInfoData and _G.BagInfoData.TotalItems
                if not items and _G.BagInfoData and _G.BagInfoData.GetTotalItems then
                    pcall(function() items = _G.BagInfoData:GetTotalItems() end)
                end

                local targetChestId = nil
                local targetChestCount = 0

                if items then
                    for k, item in pairs(items) do
                        if item then
                            local tblItem = item.tblItem or (item.data and item.data.tblItem) or {}
                            local name = tblItem.name or item.name or ""
                            local itemCount = item.count or (item.data and item.data.count) or 1
                            local itemType = tblItem.type or 0

                            if itemType == 5 and string.find(name, "Rương Vàng") then
                                targetChestId = item.id or (item.data and item.data.id)
                                targetChestCount = itemCount
                                break
                            end
                        end
                    end
                end

                -- Nếu không còn Rương Vàng nào nữa -> Kết thúc!
                if not targetChestId or targetChestCount == 0 then
                    _G.Mod_AutoOpenGoldenChest_Enabled = false
                    if chestTimer then Timer.Stop(chestTimer) end

                    Log("-> ĐÃ MỞ HẾT SẠCH TOÀN BỘ RƯƠNG VÀNG!")
                    VacuumAllMapDropItems()
                    PerformRecycleExcellence()
                    PerformSmeltEquipments()
                    SaveOutput()

                    if onFinished then
                        Timer.Start(DELAY, function() onFinished() end)
                    end
                    return
                end

                -- Mở tối đa 20 rương cho đợt này
                local openBatch = math.min(20, targetChestCount)
                openedBatchCount = openedBatchCount + 1
                Log(string.format("-> [ĐỢT %d/%d] Mở %d Rương Vàng (Còn lại trong stack: %d)...", openedBatchCount, maxBatches, openBatch, targetChestCount - openBatch))
                
                _G.Mod_GoldenChestBatchIds = {}
                if _G.networkRequest and _G.networkRequest.ReqUseItem then
                    _G.networkRequest.ReqUseItem(openBatch, targetChestId)
                end

                _G.Mod_GoldenChestWaitTime = nowTime + math.max(1.0, DELAY)
                _G.Mod_GoldenChestState = "WAIT_DROP"

            -- 3. Chờ cho 20 món đồ rớt ra và liên tục hút sạch vào túi
            elseif _G.Mod_GoldenChestState == "WAIT_DROP" then
                VacuumAllMapDropItems()
                if nowTime >= (_G.Mod_GoldenChestWaitTime or 0) then
                    _G.Mod_GoldenChestState = "RECYCLE"
                end

            -- 4. Xử lý thu hồi / tách sạch sẽ 20 món đồ vừa nhặt vào túi
            elseif _G.Mod_GoldenChestState == "RECYCLE" then
                VacuumAllMapDropItems()
                PerformRecycleExcellence()
                PerformSmeltEquipments()
                _G.Mod_GoldenChestWaitTime = nowTime + DELAY
                _G.Mod_GoldenChestState = "WAIT_SYNC"

            -- 5. Chờ DELAY cho túi đồ đồng bộ dọn chỗ trống rồi mới mở tiếp 20 rương đợt sau
            elseif _G.Mod_GoldenChestState == "WAIT_SYNC" then
                VacuumAllMapDropItems()
                if nowTime >= (_G.Mod_GoldenChestWaitTime or 0) then
                    _G.Mod_GoldenChestState = "OPEN"
                end
            end
        end)
    end)
end

-- =========================================================================
-- =========================================================================
-- KHAI BÁO FORWARD FUNCTIONS ĐỂ CÁC BƯỚC GỌI NHAU TỰ ĐỘNG
-- =========================================================================
local GenerateUniqueRoleName
local CreateRoleAndEnterGame

local NamePrefixes = {
    "Rex", "Leo", "Kai", "Ken", "Zin", "Max", "Vut", "Roy", "Ben", "Sam", "Tom", "Zen", "Lux", "Fox", "Dan", "Jin",
    "Ken", "Jay", "Ron", "Ace", "Neo", "Sky", "Ray", "Taj", "Kev", "Ian", "Eli", "Guy", "Lee", "Ted", "Val", "Zak"
}

GenerateUniqueRoleName = function()
    local realTime = 0
    pcall(function() realTime = CS.UnityEngine.Time.realtimeSinceStartup end)
    local seed = os.time() + math.floor(realTime * 1000)
    math.randomseed(seed)
    local p = NamePrefixes[math.random(1, #NamePrefixes)]
    local t = (os.time() + math.random(1, 999)) % 46656 -- 36^3 = 46656 (3 ký tự)
    local b36 = "0123456789abcdefghijklmnopqrstuvwxyz"
    local s = ""
    for i = 1, 3 do
        local rem = t % 36
        s = string.sub(b36, rem + 1, rem + 1) .. s
        t = math.floor(t / 36)
    end
    return p .. s -- Tổng đúng 6 ký tự (ví dụ: Rex8k2, Leo9m1)
end

CreateRoleAndEnterGame = function(targetIdx)
    if _G.IsRoleCreating or _G.HasCreatedRoleForTarget then
        Log(string.format("-> [BỎ QUA] Đang hoặc đã hoàn thành tạo nhân vật cho slot [%d]...", targetIdx))
        return
    end
    _G.IsRoleCreating = true
    _G.HasCreatedRoleForTarget = true

    local newName = GenerateUniqueRoleName()
    
    -- TẬP TRUNG TẠO CUNG THỦ (ARCHER - CAREER 13, SEX 2 NỮ) THEO YÊU CẦU THỬ NGHIỆM
    -- (Tạm thời comment class Ma Kỵ Sĩ 14 để kiểm thử hoàn hảo từng phần)
    --[[
    local canSpellSword = false
    pcall(function()
        if LoginData and LoginData.JudgeCanEstablishSpellSwordId then
            canSpellSword = LoginData.JudgeCanEstablishSpellSwordId()
        end
    end)
    local targetCareer = 14
    local careerName = "Ma Ky Si (Magic Gladiator)"
    local targetSex = 1
    if not canSpellSword then
        targetCareer = 13
        careerName = "Cung Thu (Archer)"
        targetSex = 2
    end
    ]]
    local targetCareer = 13 -- Cung Thủ (Archer)
    local careerName = "Cung Thủ (Archer)"
    local targetSex = 2 -- Nữ

    Log("=========================================================================")
    Log(string.format(">>> [TẠO NHÂN VẬT] PHÁT HIỆN SLOT [%d/4] CHƯA CÓ NHÂN VẬT! <<<", targetIdx))
    Log(string.format(">>> ĐANG TẠO MỚI NHÂN VẬT: Tên = %s | Hệ = %s <<<", newName, careerName))
    Log("=========================================================================")
    SaveOutput()

    -- Lắng nghe event tạo nhân vật thành công từ Server
    if _G.TestEventContainer then
        _G.TestEventContainer:Regist(Event.Login_CreateRole, function()
            Log("[EVENT] Login_CreateRole -> TẠO NHÂN VẬT THÀNH CÔNG!")
            SaveOutput()

            pcall(function()
                if RoleDeclareManager and RoleDeclareManager.GetRoleInformation then
                    RoleDeclareManager.GetRoleInformation()
                end
                if NetManager and NetManager.Send and UserMessage and UserMessage.ReqGetRoleList then
                    NetManager.Send(UserMessage.ReqGetRoleList, {})
                end
            end)

            -- Chờ server cập nhật LoginData.roleList đầy đủ
            Timer.Start(DELAY * 2, function()
                if _G.LoginData and _G.LoginData.InGame then
                    return
                end
                local roles = LoginData.roleList or {}
                Log(string.format("-> Danh sách nhân vật sau khi tạo: %d nhân vật. Tiến hành chọn nhân vật %d...", #roles, targetIdx))
                SelectRoleByIndex(targetIdx)
            end)
        end)
    end

    -- Gửi gói tin tạo nhân vật: Chỉ tạo Ma Kỵ Sĩ (14) hoặc Cung Thủ (13)
    if _G.networkRequest and _G.networkRequest.ReqCreateRole then
        _G.networkRequest.ReqCreateRole(newName, targetSex, targetCareer)
    elseif NetManager and NetManager.Send and UserMessage and UserMessage.ReqCreateRole then
        NetManager.Send(UserMessage.ReqCreateRole, { roleName = newName, sex = targetSex, career = targetCareer })
    end
end

-- =========================================================================
-- 8. TỰ ĐỘNG CHỌN NHÂN VẬT (SELECT ROLE BY INDEX 1..4) & ĐỔI TÀI KHOẢN
-- =========================================================================
SelectRoleByIndex = function(targetIdx)
    local roles = LoginData.roleList or {}
    if targetIdx < 1 then targetIdx = 1 end

    -- Nếu slot nhân vật này chưa có
    if not roles or targetIdx > #roles then
        if not _G.HasCreatedRoleForTarget then
            Log(string.format("Tài khoản hiện có %d nhân vật. Slot [%d] chưa có -> Bắt đầu tạo mới nhân vật!", #roles, targetIdx))
            CreateRoleAndEnterGame(targetIdx)
        else
            Log(string.format("-> [ĐANG ĐỒNG BỘ] Đang chờ server nạp slot [%d] (Hiện có: %d)...", targetIdx, #roles))
            Timer.Start(1.0, function()
                SelectRoleByIndex(targetIdx)
            end)
        end
        return
    end

    _G.IsRoleCreating = false
    local targetRole = roles[targetIdx]
    local info = targetRole.info or targetRole.data or targetRole
    local roleId = tonumber(info.roleId or info.id or targetRole.roleId or targetRole.id)
    local roleName = tostring(info.name or info.roleName or targetRole.name or ("Role_" .. targetIdx))
    local roleLevel = tonumber(info.level or info.roleLevel or targetRole.level or 1)
    local createTime = tonumber(info.createTime or targetRole.createTime or 1)

    _G.ActiveRoleIndex = targetIdx
    _G.ActiveRoleConfig = GetCurrentRoleConfig(targetIdx, roleName)

    Log("=========================================================================")
    Log(string.format(">>> ĐANG CHỌN NHÂN VẬT [%d/%d] TRÊN PEDESTAL: %s (ID: %s | Level: %s) <<<", 
        targetIdx, #roles, tostring(roleName), tostring(roleId), tostring(roleLevel)))
    Log(string.format("   Cấu hình áp dụng: Tự động Match Bãi Train theo Phòng Thủ | Rương: %s đợt | Giữ dòng ngon: %s",
        tostring(_G.ActiveRoleConfig.maxChestBatches), tostring(_G.ActiveRoleConfig.keepGoodLines)))
    Log("=========================================================================")
    SaveOutput()

    -- 1. Thiết lập LoginData
    LoginData.roleId = roleId
    LoginData.roleName = roleName
    LoginData.roleLevel = roleLevel
    LoginData.createTime = createTime
    LoginData.InGame = false

    -- 2. Di chuyển hiệu ứng vòng tròn chọn (Select Effect) sang nhân vật targetIdx trong UI
    pcall(function()
        local curRoleUI = UIManager.GetUiByName("Login_LoginRoleUI")
        if curRoleUI then
            curRoleUI.loadingPanelIsLoaded = true
            if curRoleUI.RoleModelInfoTbl and curRoleUI.RoleModelInfoTbl[targetIdx] then
                curRoleUI.curRole = curRoleUI.RoleModelInfoTbl[targetIdx]
                if curRoleUI.ShowSelectEffect then curRoleUI:ShowSelectEffect() end
                if curRoleUI.ShowDeleteBtn then curRoleUI:ShowDeleteBtn() end
                if curRoleUI.ShowRoleState then curRoleUI:ShowRoleState() end
            end
        end
    end)

    -- 3. Chờ đúng DELAY (1.0s) rồi mới gửi gói tin ReqChooseRole với roleId chuẩn xác
    Timer.Start(DELAY, function()
        Log(string.format("-> GỬI LỆNH ReqChooseRole: roleId = %s (Tên: %s)...", tostring(roleId), tostring(roleName)))
        SaveOutput()
        
        if _G.networkRequest and _G.networkRequest.ReqChooseRole then
            _G.networkRequest.ReqChooseRole(roleId)
        elseif NetManager and NetManager.Send and UserMessage and UserMessage.ReqChooseRole then
            NetManager.Send(UserMessage.ReqChooseRole, { roleId = roleId })
        end
    end)
end
_G.SelectRoleByIndex = SelectRoleByIndex

SwitchToNextRoleOrAccount = function()
    local curRole = _G.CurrentRoleIndex or 1
    local curAcc = _G.CurrentAccountIndex or 1
    local totalAccs = (_G.BotAccounts and #_G.BotAccounts) or 1

    Log(string.format("[Hoàn Tất Slot %d] : Đã hoàn tất nâng cấp, mở rương và đưa nhân vật ra bãi farm bật Auto!", curRole), true)
    SaveOutput()

    -- Dừng tất cả các timer nâng cấp và quest của nhân vật hiện tại
    pcall(function()
        if _G.Global30sUpgradeTimer then
            Timer.Stop(_G.Global30sUpgradeTimer)
            _G.Global30sUpgradeTimer = nil
        end
        if _G.BotQuestMonitorTimer then
            Timer.Stop(_G.BotQuestMonitorTimer)
            _G.BotQuestMonitorTimer = nil
        end
        if _G.Bot_FarmMonitorTimer then
            Timer.Stop(_G.Bot_FarmMonitorTimer)
            _G.Bot_FarmMonitorTimer = nil
        end
    end)

    if curRole < 4 then
        -- Chuyển sang nhân vật tiếp theo trong tài khoản (Slot 1 -> Slot 2 -> Slot 3 -> Slot 4)
        _G.CurrentRoleIndex = curRole + 1
        Log(string.format("[Đổi Nhân Vật] : Hoàn tất slot %d. Đang đăng xuất chuyển sang slot %d...", curRole, _G.CurrentRoleIndex), true)
        SaveOutput()

        Timer.Start(2.0, function()
            ForceLogoutToLogin()
            Timer.Start(3.0, function()
                StartFullLoginProcess()
            end)
        end)
    else
        -- Đã xong 4 nhân vật của tài khoản hiện tại -> Chuyển sang tài khoản tiếp theo
        if curAcc < totalAccs then
            _G.CurrentAccountIndex = curAcc + 1
            _G.CurrentRoleIndex = 1
            Log(string.format("[Đổi Tài Khoản] : Đã hoàn tất cả 4 nhân vật. Đăng xuất chuyển sang Tài Khoản %d/%d...", _G.CurrentAccountIndex, totalAccs), true)
            SaveOutput()

            Timer.Start(2.0, function()
                ForceLogoutToLogin()
                Timer.Start(3.0, function()
                    StartFullLoginProcess()
                end)
            end)
        else
            Log("[Hoàn Tất] : ĐÃ HOÀN TẤT TOÀN BỘ QUY TRÌNH CHO TẤT CẢ TÀI KHOẢN VÀ NHÂN VẬT! TẤT CẢ ĐỀU ĐANG CẮM FARM TỰ ĐỘNG!", true)
            SaveOutput()
        end
    end
end
_G.SwitchToNextRoleOrAccount = SwitchToNextRoleOrAccount

-- =========================================================================
-- 9. DỊCH CHUYỂN TỚI MAP TRAIN & BẬT AUTO ĐÁNH QUÁI
-- =========================================================================
local function TriggerAutoFight()
    pcall(function()
        local pMe = _G.RoleManager and _G.RoleManager.me
        if pMe then
            if pMe.StopMove then pMe:StopMove() end
            if pMe.SetAutoFight then
                pMe:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
            end
            if pMe.meAutoFight and pMe.meAutoFight.SetAutoFightHookStart then
                pMe.meAutoFight:SetAutoFightHookStart(true)
            end
        end
        if _G.AutoTaskManage and _G.AutoTaskManage.SetCurRoleOperate then
            _G.AutoTaskManage.SetCurRoleOperate(_G.AutoTaskOperateType and _G.AutoTaskOperateType.AutoFight or 2)
        end
        if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
            _G.QiJiHelperData.SetAutoFightData(true)
        end
        if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoReturnHome then
            _G.QiJiHelperData.SetAutoReturnHome(true)
        end
        if _G.EventManager and _G.EventManager.Dispatch and _G.Event and _G.Event.CloseKillMonsterCard then
            _G.EventManager.Dispatch(_G.Event.CloseKillMonsterCard)
        end
    end)
end

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG THU HỒI TRANG BỊ RÁC TRONG TÚI (QUẦN ÁO, GIÁP, VŨ KHÍ - KHÔNG CẦN VIP)
-- Mô tả: Áp dụng chuẩn quy tắc lọc trang bị như Mở Rương Vàng:
--        - CHỈ thu hồi Quần Áo (subType 13..17: Mũ, Áo, Quần, Găng, Giày) & Vũ khí (subType 1..12, 24, 25, 56, 57, 81).
--        - TUYỆT ĐỐI KHÔNG đụng vào Cánh, Nhẫn, Dây chuyền, Ngọc, Sách kỹ năng, Bình máu/mana, Rương, Vé.
--        - Gửi gói tin ReqItemRecycle qua BlackSmith (Type 2 - không cần VIP).
-- =========================================================================
AutoRecycleBagItems = function()
    local recycledCount = 0
    pcall(function()
        if not _G.BagInfoData then return end
        local itemsList = _G.BagInfoData.TotalItems
        if not itemsList or table.count(itemsList) == 0 then
            if _G.BagInfoData.GetTotalBag then
                itemsList = _G.BagInfoData.GetTotalBag()
            end
        end
        if not itemsList then return end

        _G.BagInfoData.RecycleItemTbl = _G.BagInfoData.RecycleItemTbl or {}
        local sendItems = {}
        local itemNames = {}

        for _, item in pairs(itemsList) do
            if item and item.id and IsRecyclableEquipment(item) then
                local tblItem = item.tblItem or (item.data and item.data.tblItem) or {}
                local c = item.count or (item.data and item.data.count) or 1
                sendItems[item.id] = c
                _G.BagInfoData.RecycleItemTbl[item.bagGridIndex or 0] = {
                    id = item.id,
                    count = c,
                    sell = tblItem.sell or "1001#100",
                    bind = item.bind or 1,
                    bagIndex = item.bagGridIndex or 0
                }
                local nameStr = tblItem.name or item.name or ("Item_" .. tostring(item.id))
                table.insert(itemNames, tostring(nameStr))
            end
        end

        recycledCount = table.count(sendItems)
        if recycledCount > 0 then
            pcall(function()
                local wayType = (_G.RecycleWayType and _G.RecycleWayType.BlackSmith) or 2
                if _G.networkRequest and _G.networkRequest.ReqItemRecycle then
                    _G.networkRequest.ReqItemRecycle(sendItems, wayType)
                elseif _G.NetManager and _G.ItemRecycleMessage and _G.ItemRecycleMessage.ReqItemRecycle then
                    _G.NetManager.Send(_G.ItemRecycleMessage.ReqItemRecycle, { recycleItems = sendItems, recycleType = wayType })
                end
            end)

            if _G.UIID and _G.UIID.BagSellInfoUI and _G.UIManager and _G.UIManager.IsVisible(_G.UIID.BagSellInfoUI) then
                _G.UIManager.Hide(_G.UIID.BagSellInfoUI)
            end
            if _G.UIID and _G.UIID.PromptTipUI and _G.UIManager and _G.UIManager.IsVisible(_G.UIID.PromptTipUI) then
                _G.UIManager.Hide(_G.UIID.PromptTipUI)
            end

            Log(string.format("[Thu Hồi] : Đã thu hồi %d món trang bị rác, giải phóng túi đồ", recycledCount), true)
            SaveOutput()
        else
            Log("[Thu Hồi] : Túi đồ sạch, không có trang bị rác cần thu hồi", false)
        end

        if PerformSmeltEquipments then
            PerformSmeltEquipments()
        end
    end)
    return recycledCount
end
_G.AutoRecycleBagItems = AutoRecycleBagItems

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG CHỌN BÃI FARM PHÙ HỢP VỚI PHÒNG THỦ & DỊCH CHUYỂN TỨC THÌ
-- Mô tả: Dựa vào Map hiện tại và Chỉ số Phòng thủ thực tế của nhân vật:
--        1. Lấy chỉ số Phòng thủ hiện tại (monsterDamageAbsorptionShow).
--        2. Quét danh sách các bãi quái trong map từ ClientTable & Bảng chuẩn game.
--        3. SO SÁNH PHÒNG THỦ:
--           - Chỉ chọn bãi quái có: Thủ nhân vật >= Thủ yêu cầu (defenseBase) để TUYỆT ĐỐI KHÔNG BỊ CHẾT.
--           - Trong số các bãi an toàn, CHỌN BÃI CÓ EXP & CẤP ĐỘ CAO NHẤT để cày cấp tối đa.
--           - Nếu nhân vật chưa đủ thủ cho bất kỳ bãi nào: Chọn bãi nhỏ nhất map để giảm thiểu sát thương.
--        4. Dịch chuyển tức thì đến bãi đã chọn và bật AutoFight cày quái.
-- =========================================================================
-- 9. TỰ ĐỘNG CHỌN BÃI TRAIN THEO PHÒNG THỦ & DỊCH CHUYỂN TỨC THÌ
-- Mô tả: Bỏ hoàn toàn cấu hình cứng MapId và tọa độ xy.
--        Hệ thống tự động:
--        1. Nhận diện Map train phù hợp theo Level của nhân vật (hoặc dùng Map hiện tại nếu đang ở map train).
--        2. Quét toàn bộ các bãi quái trong map.
--        3. Đối chiếu Phòng thủ thực tế của nhân vật: Chọn bãi có EXP cao nhất mà Thủ nhân vật >= Thủ yêu cầu (defenseBase).
--        4. Dịch chuyển tức thì đến bãi quái đã chọn và bật AutoFight.
-- =========================================================================
TeleportToTrainMapAndFarm = function(onFinished)
    ApplyFovAndSpeed()
    local pMe = _G.RoleManager and _G.RoleManager.me
    local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1)
    local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
    curMap = tonumber(curMap)
    if curMap <= 0 then curMap = 1003 end

    -- 1. CHỌN MAP LUYỆN CẤP:
    -- KHI < 200: TUYỆT ĐỐI KHÔNG TỰ Ý CHUYỂN SANG MAP CAO HƠN (tránh rơi vào map chưa mở khóa).
    -- Chỉ chọn bãi quái to nhất của MAP HIỆN TẠI!
    local targetMap = curMap
    if curLvl >= 200 then
        -- Cấp >= 200 (Đã hoàn tất mạch nhiệm vụ tân thủ và mở các map cấp cao):
        if curMap < 1005 or (curMap >= 1000000) then
            if curLvl >= 260 then
                targetMap = 1012 -- Phế Tích Kanturu
            elseif curLvl >= 220 then
                targetMap = 1011 -- Icarus
            elseif curLvl >= 180 then
                targetMap = 1010 -- Aida
            elseif curLvl >= 130 then
                targetMap = 1008 -- Atlantis
            elseif curLvl >= 80 then
                targetMap = 100502 -- Lost Tower 2
            elseif curLvl >= 40 then
                targetMap = 100201 -- Dungeon 1
            else
                targetMap = 1003 -- Devias
            end
        end
    else
        -- Cấp < 200: Cố định targetMap là MAP HIỆN TẠI của nhân vật
        targetMap = curMap
    end

    Log(string.format("[Luyện Cấp] : Chọn bãi quái tối ưu tại Map %d (Cấp nhân vật: %d)", targetMap, curLvl), true)
    SaveOutput()

    -- 2. Dịch chuyển tới bãi farm tối ưu của map
    TeleportToBestFarmPoint(targetMap)

    -- 3. Bật AutoFight & Chờ 3s vào trạng thái chiến đấu ổn định trước khi đổi acc
    Timer.Start(1.5, function()
        pcall(function()
            local me = _G.RoleManager and _G.RoleManager.me
            if me and me.SetAutoFight then
                me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
            end
            if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                _G.QiJiHelperData.SetAutoFightData(true)
            end
        end)

        Timer.Start(2.0, function()
            Log("[Luyện Cấp] : Nhân vật đã vào trạng thái tự động đánh quái ổn định tại bãi farm!", true)
            SaveOutput()
            if onFinished then
                onFinished()
            else
                SwitchToNextRoleOrAccount()
            end
        end)
    end)
end
_G.TeleportToTrainMapAndFarm = TeleportToTrainMapAndFarm

-- =========================================================================
-- 10. TỰ ĐỘNG PHÂN BỔ ĐIỂM TIỀM NĂNG (ĐỀ XUẤT TĂNG ĐIỂM THÔNG MINH)
-- =========================================================================
local function AutoAddAttributePoints()
    pcall(function()
        local viewAttr = (QuickFind and QuickFind.LuaMainPlayerViewAttrData and QuickFind.LuaMainPlayerViewAttrData())
        local validPoints = (viewAttr and viewAttr.validAttributePoint) or (ViewData and ViewData.meData and ViewData.meData.validAttributePoint) or 0
        if not validPoints or validPoints <= 0 then return end

        local career = (viewAttr and viewAttr.career) or (ViewData and ViewData.meData and ViewData.meData.career) or 13
        local basicCareer = 13
        if RoleUtility and RoleUtility.GetBasicCareer then
            basicCareer = RoleUtility.GetBasicCareer(career)
        else
            basicCareer = tonumber(string.sub(tostring(career), -2)) or 13
        end

        local attrMap = {}
        if basicCareer == 13 or basicCareer == 23 or basicCareer == 33 or basicCareer == 43 then
            -- Cung Thủ (Archer): 80% Thân Pháp (Agility), 20% Sức Mạnh (Strength)
            local strPts = math.floor(validPoints * 0.2)
            local agiPts = validPoints - strPts
            if strPts > 0 then attrMap[EAttributeType.strength] = strPts end
            if agiPts > 0 then attrMap[EAttributeType.agility] = agiPts end
        elseif basicCareer == 14 or basicCareer == 24 or basicCareer == 34 or basicCareer == 44 then
            -- Ma Kỵ Sĩ (SpellSword): 60% Sức Mạnh (Strength), 40% Thân Pháp (Agility)
            local agiPts = math.floor(validPoints * 0.4)
            local strPts = validPoints - agiPts
            if strPts > 0 then attrMap[EAttributeType.strength] = strPts end
            if agiPts > 0 then attrMap[EAttributeType.agility] = agiPts end
        elseif basicCareer == 12 or basicCareer == 22 or basicCareer == 32 or basicCareer == 42 then
            -- Pháp Sư (DW): 80% Năng Lượng (Energy), 20% Thân Pháp (Agility)
            local agiPts = math.floor(validPoints * 0.2)
            local enePts = validPoints - agiPts
            if enePts > 0 then attrMap[EAttributeType.energy] = enePts end
            if agiPts > 0 then attrMap[EAttributeType.agility] = agiPts end
        else
            -- Chiến Binh (DK) / Khác: 70% Sức Mạnh (Strength), 30% Thân Pháp (Agility)
            local agiPts = math.floor(validPoints * 0.3)
            local strPts = validPoints - agiPts
            if strPts > 0 then attrMap[EAttributeType.strength] = strPts end
            if agiPts > 0 then attrMap[EAttributeType.agility] = agiPts end
        end

        if MeController and MeController.ReqAttributeModify then
            MeController.ReqAttributeModify(attrMap)
        else
            local req = {}
            for k, v in pairs(attrMap) do
                table.insert(req, {choose = k, num = v})
            end
            if NetManager and NetManager.Send and RoleMessage and RoleMessage.ReqAttributeModify then
                NetManager.Send(RoleMessage.ReqAttributeModify, {modify = req})
            end
        end

        Log(string.format("-> [ĐỀ XUẤT TĂNG ĐIỂM] Đã tự động phân bổ %d điểm tiềm năng cho Class %s!", validPoints, tostring(career)))
        SaveOutput()

        -- Đóng popup gợi ý tăng điểm nếu đang hiện
        if UIManager and UIManager.IsVisible then
            if UIID and UIID.AttributeAddTipsUI and UIManager.IsVisible(UIID.AttributeAddTipsUI) then
                UIManager.Hide(UIID.AttributeAddTipsUI)
            end
            if UIID and UIID.Role_AttributeUI and UIManager.IsVisible(UIID.Role_AttributeUI) then
                UIManager.Hide(UIID.Role_AttributeUI)
            end
        end
    end)
end

-- =========================================================================
-- [HỖ TRỢ]: KIỂM TRA & SỬ DỤNG SÁCH KỸ NĂNG CHUẨN XÁC THEO NGHỀ
-- =========================================================================
local function IsItemUsableSkillBook(item)
    if not item or not item.id or not item.tblItem then
        return false
    end

    local tblItem = item.tblItem
    local itemId = item.itemId or tblItem.id or 0
    local itemType = tblItem.type or 0
    local itemName = tostring(tblItem.name or item.name or "")

    -- A. TUYỆT ĐỐI LOẠI BỎ TRANG BỊ (EQUIPMENT)
    if itemType == 2 or (item.tblEquip ~= nil) or (item.isEquip == true) then
        return false
    end
    if _G.EItemType and _G.EItemType.Equipe and itemType == _G.EItemType.Equipe then
        return false
    end
    if _G.ItemUtility and _G.ItemUtility.IsEquipType and _G.ItemUtility.IsEquipType(itemType) then
        return false
    end
    if _G.ClientTable and _G.ClientTable.cfg_Item_equipManager and _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId) ~= nil then
        return false
    end

    -- Blacklist từ khóa trang bị & khiên
    local equipBlacklist = { "Khiên", "Kiếm", "Cung", "Nỏ", "Gậy", "Trượng", "Áo", "Quần", "Mũ", "Tay", "Giày", "Nhẫn", "Dây Chuyền", "Cánh", "Hộ Thủ", "Hộ Thân" }
    for _, kw in ipairs(equipBlacklist) do
        if string.find(itemName, kw) then
            return false
        end
    end

    -- B. TUYỆT ĐỐI LOẠI BỎ NGUYÊN LIỆU PHỤ BẢN / VÉ / ĐÁ CƯỜNG HÓA / HUỲNH QUANG
    local materialBlacklist = { "Huyết Linh", "Quỷ Vương", "Quảng Trường", "Vé", "Mảnh", "Huỳnh Quang", "Lông Vũ", "Cường Hóa", "Thuốc", "Bình", "Rương", "Huy Chương", "Quỷ Giác", "Mắt Quỷ", "Linh Hồn" }
    for _, kw in ipairs(materialBlacklist) do
        if string.find(itemName, kw) then
            return false
        end
    end

    -- C. Kiểm tra có đúng là Sách Kỹ Năng không:
    -- Trong MU Strongest/Origin: EItemType.SkillBook == 4 (hoặc itemType == 4)
    -- Dải ID sách kỹ năng: 53000000 .. 53999999
    -- Hoặc kỹ năng tân thủ cụ thể: "Tên Đa Trùng", "Sóng Rồng", "Chém Xoáy", "Liệt Quang"
    local isSkillBook = false
    if _G.EItemType and _G.EItemType.SkillBook and itemType == _G.EItemType.SkillBook then
        isSkillBook = true
    elseif itemType == 4 then
        isSkillBook = true
    elseif itemId >= 53000000 and itemId <= 53999999 then
        isSkillBook = true
    elseif string.find(itemName, "Tên Đa Trùng") or string.find(itemName, "Sóng Rồng") 
        or string.find(itemName, "Chém Xoáy") or string.find(itemName, "Liệt Quang Thiểm") then
        isSkillBook = true
    end

    if not isSkillBook then
        return false
    end

    -- D. KIỂM TRA NGHỀ NGHIỆP PHÙ HỢP (CAREER JUDGE)
    if tblItem.career and tblItem.career ~= "0" and tostring(tblItem.career) ~= "0" then
        local myCareer = 0
        pcall(function()
            if _G.QuickFind and _G.QuickFind.LuaMainPlayerViewAttrData then
                myCareer = _G.QuickFind.LuaMainPlayerViewAttrData().career or 0
            elseif _G.ViewData and _G.ViewData.meData then
                myCareer = _G.ViewData.meData.career or 0
            elseif _G.RoleManager and _G.RoleManager.me then
                myCareer = _G.RoleManager.me.career or 0
            end
        end)

        if myCareer and myCareer > 0 then
            local careerMatches = false
            local reqCareers = string.split(tostring(tblItem.career), "#")
            for _, cStr in pairs(reqCareers) do
                local cNum = tonumber(cStr)
                if cNum and cNum > 0 then
                    if _G.RoleUtility and _G.RoleUtility.CareerJudge then
                        if _G.RoleUtility.CareerJudge(myCareer, cNum) then
                            careerMatches = true
                            break
                        end
                    else
                        local myBasic = (_G.RoleUtility and _G.RoleUtility.GetBasicCareer and _G.RoleUtility.GetBasicCareer(myCareer)) or (myCareer % 10)
                        local targetBasic = (_G.RoleUtility and _G.RoleUtility.GetBasicCareer and _G.RoleUtility.GetBasicCareer(cNum)) or (cNum % 10)
                        if myBasic == targetBasic then
                            careerMatches = true
                            break
                        end
                    end
                end
            end
            if not careerMatches then
                return false
            end
        end
    end

    return true
end

-- =========================================================================
-- 11. TỰ ĐỘNG GIẢI QUYẾT CÁC NHIỆM VỤ ĐẶC BIỆT / HƯỚNG DẪN TÂN THỦ
-- =========================================================================
local function SolveNewbieSpecialTasks()
    pcall(function()
        -- 1. Xử lý Nhiệm vụ Mua Kỹ Năng / Cửa hàng Shop đang mở (Shop Vàng -> Kỹ Năng Mạnh)
        if _G.UIManager and _G.UIManager.IsVisible then
            -- A. Nếu Shop đang mở (Shop_ShopUI)
            if _G.UIID and _G.UIID.Shop and _G.UIManager.IsVisible(_G.UIID.Shop) then
                local shopUI = _G.UIManager.GetUiByName(_G.UIID.Shop)
                local goodId = nil

                if shopUI then
                    -- 1. Tìm trong args nếu game truyền subPosition hoặc itemBuyID
                    if shopUI.args and (shopUI.args.subPosition or shopUI.args.itemBuyID) then
                        goodId = shopUI.args.subPosition or shopUI.args.itemBuyID
                    end

                    -- 2. Tìm trong danh sách items đang hiển thị trong Shop
                    if not goodId and shopUI.shopCtrTbl and shopUI.shopCtrTbl.items then
                        for _, itemCtr in pairs(shopUI.shopCtrTbl.items) do
                            if itemCtr and itemCtr.buyCtr and itemCtr.buyCtr.shop then
                                local s = itemCtr.buyCtr.shop
                                local isRec = (s.recommend == 1)
                                if itemCtr.img_is_recommend and itemCtr.img_is_recommend.gameObject and itemCtr.img_is_recommend.gameObject.activeSelf then
                                    isRec = true
                                end
                                if itemCtr.eff_UI_annuikuang and itemCtr.eff_UI_annuikuang.gameObject and itemCtr.eff_UI_annuikuang.gameObject.activeSelf then
                                    isRec = true
                                end
                                if isRec then
                                    goodId = s.id
                                    if shopUI.BuyBtnOnClick then
                                        pcall(function() shopUI:BuyBtnOnClick(itemCtr.buyCtr) end)
                                    end
                                    break
                                end
                            end
                        end
                        -- Fallback: Lấy item đầu tiên nếu đang ở đúng tab kỹ năng
                        if not goodId and #shopUI.shopCtrTbl.items > 0 and shopUI.shopCtrTbl.items[1].buyCtr and shopUI.shopCtrTbl.items[1].buyCtr.shop then
                            goodId = shopUI.shopCtrTbl.items[1].buyCtr.shop.id
                            if shopUI.BuyBtnOnClick then
                                pcall(function() shopUI:BuyBtnOnClick(shopUI.shopCtrTbl.items[1].buyCtr) end)
                            end
                        end
                    end
                end

                -- Gửi lệnh mua item/kỹ năng ngay lập tức
                if goodId then
                    if _G.networkRequest and _G.networkRequest.ReqBuy then
                        _G.networkRequest.ReqBuy(goodId, 1)
                    elseif _G.NetManager and _G.ItemBuyMessage and _G.ItemBuyMessage.ReqBuy then
                        _G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, { goodId = goodId, buyCount = 1 })
                    end
                    Log(string.format("-> [AUTO SHOP]: Đã tự động MUA KỸ NĂNG/VẬT PHẨM (goodId: %s)!", tostring(goodId)), true)
                    SaveOutput()
                end

                -- Đóng giao diện Shop & Tips sau khi mua
                pcall(function()
                    _G.UIManager.Hide(_G.UIID.Shop)
                    if _G.UIID.ItemTipUI and _G.UIManager.IsVisible(_G.UIID.ItemTipUI) then
                        _G.UIManager.Hide(_G.UIID.ItemTipUI)
                    end
                    if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.TargetAvatar and _G.RoleManager.me.TargetAvatar.RoleType == _G.ERoleType.NPC then
                        _G.RoleManager.me.TargetAvatar:OnCancelTouch()
                    end
                end)
            end

            -- A2. Nếu có popup xác nhận mua Shop (Shop_BuyUI)
            if _G.UIID and _G.UIID.ShopBuyUI and _G.UIManager.IsVisible(_G.UIID.ShopBuyUI) then
                local buyUI = _G.UIManager.GetUiByName(_G.UIID.ShopBuyUI)
                if buyUI then
                    Log("-> [AUTO SHOP]: Phát hiện popup xác nhận ShopBuyUI -> Tự động xác nhận Mua!", true)
                    if buyUI.btn_comfirmOnClick and buyUI.btn_comfirm then
                        pcall(function() buyUI:btn_comfirmOnClick(buyUI.btn_comfirm) end)
                    elseif buyUI.args and buyUI.args.shopInfo and buyUI.args.shopInfo.id then
                        pcall(function() _G.networkRequest.ReqBuy(buyUI.args.shopInfo.id, 1) end)
                    end
                    pcall(function() _G.UIManager.Hide(_G.UIID.ShopBuyUI) end)
                end
            end

            -- B. Nếu có popup gợi ý mua kỹ năng (ShopSkill_TIpsUI)
            if _G.UIID and _G.UIID.ShopSkillTIpsUI and _G.UIManager.IsVisible(_G.UIID.ShopSkillTIpsUI) then
                local tipUI = _G.UIManager.GetUiByName(_G.UIID.ShopSkillTIpsUI)
                if tipUI and tipUI.btn_goBuyOnClick then
                    tipUI:btn_goBuyOnClick()
                else
                    _G.UIManager.Hide(_G.UIID.ShopSkillTIpsUI)
                end
            end

            -- C. Nếu có popup dùng nhanh (AuctionTIpsUI)
            if _G.UIID and _G.UIID.AuctionTIpsUI and _G.UIManager.IsVisible(_G.UIID.AuctionTIpsUI) then
                local aucUI = _G.UIManager.GetUiByName(_G.UIID.AuctionTIpsUI)
                if aucUI and aucUI.btn_quickAuctionOnClick and aucUI.btn_quickAuction then
                    aucUI:btn_quickAuctionOnClick(aucUI.btn_quickAuction)
                elseif aucUI and aucUI.Btn_quickAuction then
                    aucUI:Btn_quickAuction()
                else
                    _G.UIManager.Hide(_G.UIID.AuctionTIpsUI)
                end
            end

            -- D. Nếu có popup mặc đồ nhanh (EquipTIpsUI)
            if _G.UIID and _G.UIID.EquipTIpsUI and _G.UIManager.IsVisible(_G.UIID.EquipTIpsUI) then
                local eqUI = _G.UIManager.GetUiByName(_G.UIID.EquipTIpsUI)
                if eqUI and eqUI.Btn_quickequip then
                    eqUI:Btn_quickequip()
                else
                    _G.UIManager.Hide(_G.UIID.EquipTIpsUI)
                end
            end

            -- D2. NẾU CÓ POPUP CHUYỂN TRANG BỊ / KẾ THỪA CƯỜNG HÓA (Equip_ZhuanyiFastUI) -> TỰ ĐỘNG CHUYỂN NHANH
            if _G.UIID and _G.UIID.Equip_ZhuanyiFastUI and _G.UIManager.IsVisible(_G.UIID.Equip_ZhuanyiFastUI) then
                local fastUI = _G.UIManager.GetUiByName(_G.UIID.Equip_ZhuanyiFastUI)
                if fastUI then
                    Log("-> [AUTO CHUYỂN TRANG BỊ]: Phát hiện popup Kế thừa cường hóa -> Tự động xác nhận Chuyển Nhanh!", true)
                    pcall(function()
                        if _G.PlayerPrefs and _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.id then
                            _G.PlayerPrefs.SetString(tostring(_G.RoleManager.me.id), "noFirst")
                        end
                        if fastUI.btn_confirmOnClick and fastUI.btn_confirm then
                            fastUI:btn_confirmOnClick(fastUI.btn_confirm)
                        end
                        if _G.UIManager.IsVisible(_G.UIID.Equip_ZhuanyiFastUI) then
                            _G.UIManager.Hide(_G.UIID.Equip_ZhuanyiFastUI)
                        end
                    end)
                    SaveOutput()
                end
            end

            -- E. Tự động đóng giao diện Túi Đồ / Thu Hồi / Shop nếu đang mở che màn hình
            if _G.UIID and _G.UIID.BagSellInfoUI and _G.UIManager.IsVisible(_G.UIID.BagSellInfoUI) then
                pcall(function() _G.UIManager.Hide(_G.UIID.BagSellInfoUI) end)
            end
            if _G.UIID and _G.UIID.NewBagInfoUI and _G.UIManager.IsVisible(_G.UIID.NewBagInfoUI) then
                pcall(function() _G.UIManager.Hide(_G.UIID.NewBagInfoUI) end)
            end
            if _G.UIID and _G.UIID.Bag_3DBagInfoUI and _G.UIManager.IsVisible(_G.UIID.Bag_3DBagInfoUI) then
                pcall(function() _G.UIManager.Hide(_G.UIID.Bag_3DBagInfoUI) end)
            end
            if _G.UIID and _G.UIID.BagShopInfoUI and _G.UIManager.IsVisible(_G.UIID.BagShopInfoUI) then
                pcall(function() _G.UIManager.Hide(_G.UIID.BagShopInfoUI) end)
            end
            if _G.UIID and _G.UIID.Shop_ShopUI and _G.UIManager.IsVisible(_G.UIID.Shop_ShopUI) then
                pcall(function() _G.UIManager.Hide(_G.UIID.Shop_ShopUI) end)
            end
            if _G.UIID and _G.UIID.PromptTipUI and _G.UIManager.IsVisible(_G.UIID.PromptTipUI) then
                local promptUI = _G.UIManager.GetUiByName(_G.UIID.PromptTipUI)
                if promptUI and promptUI.btn_okOnClick and promptUI.btn_ok then
                    pcall(function() promptUI:btn_okOnClick(promptUI.btn_ok) end)
                end
            end

            -- F. TỰ ĐỘNG NHẬN THƯỞNG / NỘP NHIỆM VỤ KHI CÓ POPUP TASKINFOUI
            if _G.UIID and _G.UIID.TaskInfoUI and _G.UIManager.IsVisible(_G.UIID.TaskInfoUI) then
                local taskInfoUI = _G.UIManager.GetUiByName(_G.UIID.TaskInfoUI)
                if taskInfoUI then
                    local targetTaskId = nil
                    if taskInfoUI.args then
                        targetTaskId = taskInfoUI.args.taskId or (taskInfoUI.args.GetId and taskInfoUI.args:GetId())
                    end
                    if not targetTaskId and _G.TaskController and _G.TaskController.curTask then
                        targetTaskId = _G.TaskController.curTask.taskId or (_G.TaskController.curTask.GetId and _G.TaskController.curTask:GetId())
                    end
                    if not targetTaskId and _G.TaskData and _G.TaskData.GetOrderMainTask then
                        local mTask = _G.TaskData.GetOrderMainTask()
                        if mTask then targetTaskId = mTask.taskId or (mTask.GetId and mTask:GetId()) end
                    end

                    Log(string.format("-> [AUTO TASK]: Phát hiện popup TaskInfoUI (Task ID: %s) -> Tự động nộp / nhận thưởng!", tostring(targetTaskId)), true)

                    -- 1. Gửi trực tiếp toàn bộ các gói và event nộp/nhận thưởng lên Server
                    if targetTaskId then
                        pcall(function()
                            if _G.networkRequest then
                                if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(targetTaskId) end
                                if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(targetTaskId) end
                            end
                            if _G.NetManager and _G.TaskMessage then
                                if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = targetTaskId, id = targetTaskId }) end
                                if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = targetTaskId, id = targetTaskId }) end
                            end
                            if _G.EventManager and _G.Event then
                                if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, targetTaskId) end
                                if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, targetTaskId) end
                            end
                        end)
                    end

                    -- 2. Kích hoạt các callback UI
                    pcall(function()
                        if taskInfoUI.btn_rewardOnClick then taskInfoUI:btn_rewardOnClick(taskInfoUI.btn_reward) end
                    end)
                    pcall(function()
                        if taskInfoUI.btn_submitOnClick then taskInfoUI:btn_submitOnClick(taskInfoUI.btn_submit) end
                    end)
                    pcall(function()
                        if taskInfoUI.btn_acceptOnClick then taskInfoUI:btn_acceptOnClick(taskInfoUI.btn_accept) end
                    end)
                    pcall(function()
                        if taskInfoUI.TaskChangeClose then taskInfoUI:TaskChangeClose() end
                        _G.UIManager.Hide(_G.UIID.TaskInfoUI)
                    end)
                end
            end

            -- G2. Giao diện Học Kỹ Năng (Skill_SkillInfoUI & Skill_SkillUI)
            if _G.UIID and _G.UIID.Skill_SkillInfoUI and _G.UIManager.IsVisible(_G.UIID.Skill_SkillInfoUI) then
                local skInfoUI = _G.UIManager.GetUiByName(_G.UIID.Skill_SkillInfoUI)
                if skInfoUI then
                    Log("-> [AUTO SKILL]: Phát hiện popup SkillInfoUI -> Kích hoạt Học Kỹ Năng!", true)
                    pcall(function()
                        if skInfoUI.Button_UpSkillOnClick then skInfoUI:Button_UpSkillOnClick(skInfoUI.btn_upSkill) end
                    end)
                    pcall(function()
                        if skInfoUI.Button_GetSkillOnClick then skInfoUI:Button_GetSkillOnClick(skInfoUI.btn_getSkill) end
                    end)
                    pcall(function()
                        if skInfoUI.skillData and skInfoUI.skillData.id then
                            if _G.SkillController and _G.SkillController.OnReqLearnSkill then
                                _G.SkillController.OnReqLearnSkill(nil, skInfoUI.skillData.id)
                            end
                            if _G.networkRequest and _G.networkRequest.ReqLearnSkill then
                                _G.networkRequest.ReqLearnSkill(skInfoUI.skillData.id)
                            end
                            if _G.NetManager and _G.SkillMessage and _G.SkillMessage.ReqLearnSkill then
                                _G.NetManager.Send(_G.SkillMessage.ReqLearnSkill, { skillId = skInfoUI.skillData.id })
                            end
                        end
                    end)
                    pcall(function() _G.UIManager.Hide(_G.UIID.Skill_SkillInfoUI) end)
                end
            end
            if _G.UIID and _G.UIID.SkillUI and _G.UIManager.IsVisible(_G.UIID.SkillUI) then
                local skUI = _G.UIManager.GetUiByName(_G.UIID.SkillUI)
                if skUI and skUI.Button_CloseOnClick then
                    pcall(function() skUI:Button_CloseOnClick() end)
                end
            end

            -- G. Popup chuyển chức Task_TransferUI
            if _G.UIID and _G.UIID.Task_TransferUI and _G.UIManager.IsVisible(_G.UIID.Task_TransferUI) then
                local trUI = _G.UIManager.GetUiByName(_G.UIID.Task_TransferUI)
                if trUI and trUI.btn_submitOnClick and trUI.btn_submit then
                    pcall(function() trUI:btn_submitOnClick(trUI.btn_submit) end)
                end
            end

            -- H. Popup trả thưởng đặc biệt Task_TaskReward / Task_TaskStart
            if _G.UIID and _G.UIID.Task_TaskReward and _G.UIManager.IsVisible(_G.UIID.Task_TaskReward) then
                local rUI = _G.UIManager.GetUiByName(_G.UIID.Task_TaskReward)
                if rUI then
                    pcall(function()
                        if rUI.monsterList then
                            for mId, _ in pairs(rUI.monsterList) do
                                if _G.TaskController and _G.TaskController.TaskUISubmit then
                                    _G.TaskController.TaskUISubmit(nil, mId)
                                end
                            end
                        end
                        if rUI.btn_closeOnClick then rUI:btn_closeOnClick() else _G.UIManager.Hide(_G.UIID.Task_TaskReward) end
                    end)
                end
            end
            if _G.UIID and _G.UIID.Task_TaskStart and _G.UIManager.IsVisible(_G.UIID.Task_TaskStart) then
                local sUI = _G.UIManager.GetUiByName(_G.UIID.Task_TaskStart)
                if sUI then
                    pcall(function()
                        if sUI.btn_closeOnClick then sUI:btn_closeOnClick() else _G.UIManager.Hide(_G.UIID.Task_TaskStart) end
                    end)
                end
            end

            -- I. Nếu có hội thoại NPC (Dialogue_DialogueUI) -> Nhấp nút tiếp tục thay vì hủy
            if _G.UIID and _G.UIID.Dialogue_DialogueUI and _G.UIManager.IsVisible(_G.UIID.Dialogue_DialogueUI) then
                local dUI = _G.UIManager.GetUiByName(_G.UIID.Dialogue_DialogueUI)
                if dUI and dUI.btn_enterOnClick and dUI.btn_enter then
                    pcall(function() dUI:btn_enterOnClick(dUI.btn_enter) end)
                elseif dUI and dUI.ClosePanel then
                    pcall(function() dUI:ClosePanel() end)
                end
            end
            if _G.UIID and _G.UIID.DialogUI and _G.UIManager.IsVisible(_G.UIID.DialogUI) then
                local comUI = _G.UIManager.GetUiByName(_G.UIID.DialogUI)
                if comUI and comUI.BtnCloseOnClick and comUI.BtnClose then
                    pcall(function() comUI:BtnCloseOnClick(comUI.BtnClose) end)
                else
                    _G.UIManager.Hide(_G.UIID.DialogUI)
                end
            end
        end

        -- 2. Tự động kiểm tra và học/dùng các sách kỹ năng trong túi đồ chuẩn xác theo nghề
        _G.Bot_SkillCooldownDic = _G.Bot_SkillCooldownDic or {}
        pcall(function()
            if _G.BagInfoData and _G.BagInfoData.GetTotalBag then
                local bag = _G.BagInfoData.GetTotalBag()
                if bag then
                    local nowSec = os.time()
                    for _, item in pairs(bag) do
                        if IsItemUsableSkillBook(item) then
                            local itKey = tostring(item.id or item.itemId)
                            local lastTry = _G.Bot_SkillCooldownDic[itKey] or 0
                            if nowSec - lastTry >= 10 then
                                _G.Bot_SkillCooldownDic[itKey] = nowSec
                                local itemName = tostring(item.tblItem.name or item.name or "Kỹ Năng")
                                Log(string.format("-> [HỌC KỸ NĂNG]: Tự động dùng sách kỹ năng: %s (ID: %s)!", itemName, tostring(item.id)), true)
                                if _G.networkRequest and _G.networkRequest.ReqUseItem then
                                    _G.networkRequest.ReqUseItem(1, item.id)
                                elseif _G.BagInfoController and _G.BagInfoController.UseItemReq then
                                    _G.BagInfoController.UseItemReq(1, item.id, nil, item.itemId)
                                elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqUseItem then
                                    _G.NetManager.Send(_G.BagMessage.ReqUseItem, { itemId = item.id, count = 1, clientParams = {} })
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- 3. Tự động mặc trang bị nếu có trong túi
        pcall(function()
            if _G.RoleEquipUtility and _G.RoleEquipUtility.AutoWearAll then
                _G.RoleEquipUtility.AutoWearAll()
            end
        end)

        -- 4. Tự động kiểm tra và giải quyết Nhiệm Vụ Nhánh & Nhiệm Vụ Thưởng
        if SolveBranchAndRewardsTasks then
            SolveBranchAndRewardsTasks()
        end
    end)
end

-- =========================================================================
-- [HỖ TRỢ]: TỰ ĐỘNG GIẢI QUYẾT NHIỆM VỤ NHÁNH & NHIỆM VỤ THƯỞNG (BRANCH & REWARDS QUESTS)
-- =========================================================================
SolveBranchAndRewardsTasks = function()
    pcall(function()
        if not _G.TaskData then return end

        -- 1. Quét danh sách Nhiệm Vụ Nhánh (Branch Tasks - Mặc đủ Bộ Mây, Bộ Da, v.v.)
        local branchList = _G.TaskData.GetBranchTask and _G.TaskData.GetBranchTask()
        if branchList and #branchList > 0 then
            for _, bTask in ipairs(branchList) do
                if bTask then
                    local bId = bTask.taskId or (bTask.GetId and bTask:GetId()) or 0
                    local bState = (bTask.GetState and bTask:GetState()) or bTask.state or 0
                    local bName = (bTask.GetName and bTask:GetName()) or ("Branch_" .. tostring(bId))

                    -- A. Đã Hoàn Thành (State Completed: 2 hoặc 3) -> Nộp và nhận thưởng ngay
                    if bState == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or bState == 2 or bState == 3 then
                        Log(string.format("-> [NHIỆM VỤ NHÁNH]: Đã xong nhiệm vụ [%s] \"%s\" -> Nộp và nhận thưởng!", tostring(bId), tostring(bName)), true)
                        pcall(function()
                            if _G.networkRequest then
                                if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(bId) end
                                if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(bId) end
                            end
                            if _G.NetManager and _G.TaskMessage then
                                if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = bId, id = bId }) end
                                if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = bId, id = bId }) end
                            end
                            if _G.EventManager and _G.Event then
                                if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, bId) end
                                if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, bId) end
                            end
                        end)
                        SaveOutput()

                    -- B. Có thể nhận (State Acceptable: 0 hoặc 1) -> Nhận nhiệm vụ
                    elseif bState == (_G.TaskStateType and _G.TaskStateType.Acceptable or 0) or bState == 0 then
                        pcall(function()
                            if _G.networkRequest and _G.networkRequest.ReqAcceptTask then _G.networkRequest.ReqAcceptTask(bId) end
                            if _G.NetManager and _G.TaskMessage and _G.TaskMessage.ReqAcceptTask then _G.NetManager.Send(_G.TaskMessage.ReqAcceptTask, { taskId = bId, id = bId }) end
                            if _G.EventManager and _G.Event and _G.Event.Task_BtnAcceptClick then _G.EventManager.Dispatch(_G.Event.Task_BtnAcceptClick, bId) end
                        end)

                    -- C. Đang tiến hành -> Nếu là nhiệm vụ mặc trang bị (Bộ Mây / Bộ Da...), tự động mặc đồ
                    elseif bState == 1 or bState == (_G.TaskStateType and _G.TaskStateType.Accept or 1) then
                        if string.find(string.lower(bName), "mặc") or string.find(string.lower(bName), "bộ mây") or string.find(string.lower(bName), "bộ da") then
                            pcall(function()
                                if _G.RoleEquipUtility and _G.RoleEquipUtility.AutoWearAll then
                                    _G.RoleEquipUtility.AutoWearAll()
                                end
                            end)
                            pcall(function()
                                if _G.networkRequest and _G.networkRequest.ReqCompleteTask then
                                    _G.networkRequest.ReqCompleteTask(bId)
                                end
                            end)
                        end
                    end
                end
            end
        end

        -- 2. Quét danh sách Nhiệm Vụ Thưởng (Rewards Tasks)
        local rewardList = _G.TaskData.GetRewardsTask and _G.TaskData.GetRewardsTask()
        if rewardList and #rewardList > 0 then
            for _, rTask in ipairs(rewardList) do
                if rTask then
                    local rId = rTask.taskId or (rTask.GetId and rTask:GetId()) or 0
                    local rState = (rTask.GetState and rTask:GetState()) or rTask.state or 0
                    local rName = (rTask.GetName and rTask:GetName()) or ("Reward_" .. tostring(rId))
                    if rState == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or rState == 2 or rState == 3 then
                        Log(string.format("-> [NHIỆM VỤ THƯỞNG]: Đã xong nhiệm vụ [%s] \"%s\" -> Nộp thưởng!", tostring(rId), tostring(rName)), true)
                        pcall(function()
                            if _G.networkRequest then
                                if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(rId) end
                                if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(rId) end
                            end
                            if _G.NetManager and _G.TaskMessage then
                                if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = rId, id = rId }) end
                                if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = rId, id = rId }) end
                            end
                        end)
                        SaveOutput()
                    end
                end
            end
        end
    end)
end
_G.SolveBranchAndRewardsTasks = SolveBranchAndRewardsTasks

-- =========================================================================
-- 12. [AUTO GIFTCODE & CLAIM MAIL] (NHẬP 34 MÃ VÀ NHẬN HÒM THƯ)
-- =========================================================================
local GIFT_CODES = {
    "iosupdate", "MUVHNEWSV1", "MUVHNEWSV2", "MUVHNEWSV3", "MUVHNEWSV4", "MUVHNEWSV5", "MUVHNEWSV6",
    "MU1111", "MU2222", "MU3333", "MU4444", "MU5555", "MU6666", "MU7777", "MU8888", "MU9999", "MU6868", "MU2026",
    "RGM888", "MINN88", "DL8888", "HH8888", "LNP888", "BMT888", "TG8888", "VVG888", "MC8888", "BB8888",
    "OG8888", "MD8888", "AP8888", "LBY888", "THGT88", "MUVHVIPPRO"
}

RunAutoGiftcode = function(onFinished)
    local function DoGiftCodeRoutine()
        local total = #GIFT_CODES
        Log(string.format("[GIFTCODE] Bắt đầu nhập %d mã Giftcode...", total), true)
        SaveOutput()

        for i, code in ipairs(GIFT_CODES) do
            Log(string.format("[GIFTCODE] Đang nhập [%d/%d]: %s", i, total, code), true)
            pcall(function()
                if _G.NetManager and _G.BagMessage and _G.BagMessage.ReqUseCDKey then
                    _G.NetManager.Send(_G.BagMessage.ReqUseCDKey, { cdKey = code })
                elseif _G.networkRequest and _G.networkRequest.ReqUseCDKey then
                    _G.networkRequest.ReqUseCDKey(code)
                end
            end)
            SaveOutput()
            
            if Coroutine and Coroutine.Wait then 
                Coroutine.Wait(0.8) 
            end
        end

        Log("[GIFTCODE] Đã gửi xong tất cả mã code! Chờ 3s máy chủ gửi thư...", true)
        SaveOutput()
        if Coroutine and Coroutine.Wait then Coroutine.Wait(3.0) end

        Log("[GIFTCODE] Đang đồng bộ danh sách hòm thư...", true)
        SaveOutput()
        pcall(function()
            if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailList then
                _G.NetManager.Send(_G.MailMessage.ReqGetMailList, {})
            end
        end)

        if Coroutine and Coroutine.Wait then Coroutine.Wait(1.5) end

        Log("[GIFTCODE] Đang nhận tất cả quà đính kèm vào túi...", true)
        SaveOutput()
        pcall(function()
            if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailItems then
                _G.NetManager.Send(_G.MailMessage.ReqGetMailItems)
            end
        end)

        if Coroutine and Coroutine.Wait then Coroutine.Wait(1.5) end

        Log("=========================================================================")
        Log(">>> HOÀN TẤT NHẬP CODE & NHẬN QUÀ TÂN THỦ THÀNH CÔNG! <<<", true)
        Log("=========================================================================")
        SaveOutput()
        _G.AutoGiftCodeRunning = false
        if onFinished then
            pcall(function() onFinished() end)
        end
    end

    if Coroutine and Coroutine.Start then
        Coroutine.Start(DoGiftCodeRoutine)
    else
        local total = #GIFT_CODES
        local idx = 1
        Log(string.format("[GIFTCODE] Bắt đầu nhập %d mã Giftcode (Timer Mode)...", total), true)
        SaveOutput()

        local codeLoop = nil
        codeLoop = Timer.StartLoop(0.8, -1, function()
            if idx <= total then
                local code = GIFT_CODES[idx]
                Log(string.format("[GIFTCODE] Đang nhập [%d/%d]: %s", idx, total, code), true)
                pcall(function()
                    if _G.NetManager and _G.BagMessage and _G.BagMessage.ReqUseCDKey then
                        _G.NetManager.Send(_G.BagMessage.ReqUseCDKey, { cdKey = code })
                    elseif _G.networkRequest and _G.networkRequest.ReqUseCDKey then
                        _G.networkRequest.ReqUseCDKey(code)
                    end
                end)
                SaveOutput()
                idx = idx + 1
            else
                if codeLoop then Timer.Stop(codeLoop) end
                Log("[GIFTCODE] Đã gửi xong tất cả mã code! Chờ 3s máy chủ gửi thư...", true)
                SaveOutput()
                Timer.Start(3.0, function()
                    Log("[GIFTCODE] Đang đồng bộ danh sách hòm thư...", true)
                    SaveOutput()
                    pcall(function()
                        if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailList then
                            _G.NetManager.Send(_G.MailMessage.ReqGetMailList, {})
                        end
                    end)
                    Timer.Start(1.5, function()
                        Log("[GIFTCODE] Đang nhận tất cả quà đính kèm vào túi...", true)
                        SaveOutput()
                        pcall(function()
                            if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailItems then
                                _G.NetManager.Send(_G.MailMessage.ReqGetMailItems)
                            end
                        end)
                        Timer.Start(1.5, function()
                            Log("=========================================================================")
                            Log(">>> HOÀN TẤT NHẬP CODE & NHẬN QUÀ TÂN THỦ THÀNH CÔNG! <<<", true)
                            Log("=========================================================================")
                            SaveOutput()
                            _G.AutoGiftCodeRunning = false
                            if onFinished then
                                pcall(function() onFinished() end)
                            end
                        end)
                    end)
                end)
            end
        end)
    end
end
_G.RunAutoGiftcode = RunAutoGiftcode

-- =========================================================================
-- [MOD FEATURE]: TÍNH TOÁN CHỈ SỐ PHÒNG THỦ THỰC TẾ CỦA NHÂN VẬT (BASE DEFENSE)
-- =========================================================================
local function GetPlayerActualDefense()
    local myDef = 0
    pcall(function()
        if _G.QuickFind and _G.QuickFind.LuaMainPlayerData then
            local pData = _G.QuickFind.LuaMainPlayerData()
            if pData and pData.TryGetAttrValue and _G.EAttributeType and _G.EAttributeType.defenseBase then
                myDef = pData:TryGetAttrValue(_G.EAttributeType.defenseBase) or 0
            end
        end
        if (not myDef or myDef <= 0) and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.GetAttribute then
            if _G.EAttributeType and _G.EAttributeType.defenseBase then
                myDef = _G.ViewData.meData:GetAttribute(_G.EAttributeType.defenseBase) or 0
            end
        end
        if (not myDef or myDef <= 0) and _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data then
            local rData = _G.RoleManager.me.data
            if rData.GetAttribute and _G.EAttributeType and _G.EAttributeType.defenseBase then
                myDef = rData:GetAttribute(_G.EAttributeType.defenseBase) or 0
            elseif rData.attrData and rData.attrData.GetAttribute and _G.EAttributeType and _G.EAttributeType.defenseBase then
                myDef = rData.attrData:GetAttribute(_G.EAttributeType.defenseBase) or 0
            end
        end
        -- Fallback nếu defenseBase = 0 thì thử defenseShow
        if (not myDef or myDef <= 0) and _G.EAttributeType and _G.EAttributeType.defenseShow then
            if _G.QuickFind and _G.QuickFind.LuaMainPlayerData then
                local pData = _G.QuickFind.LuaMainPlayerData()
                if pData and pData.TryGetAttrValue then
                    myDef = pData:TryGetAttrValue(_G.EAttributeType.defenseShow) or 0
                end
            end
        end
    end)
    return tonumber(myDef) or 0
end
_G.GetPlayerActualDefense = GetPlayerActualDefense
_G.GetPlayerMonsterDefense = GetPlayerActualDefense

-- =========================================================================
-- [MOD FEATURE]: CHỌN BÃI FARM QUÁI TỐT NHẤT DỰA TRÊN PHÒNG THỦ NHÂN VẬT
-- =========================================================================
local FALLBACK_MAP_SPOTS = {
    [1003] = { x = 215, y = 45, name = "Devias (Lv 30)", defenseReq = 30 },
    [100201] = { x = 109, y = 247, name = "Dungeon 1 (Lv 60)", defenseReq = 80 },
    [100501] = { x = 193, y = 30, name = "Lost Tower 1 (Lv 90)", defenseReq = 140 },
    [100502] = { x = 193, y = 30, name = "Lost Tower 2 (Lv 110)", defenseReq = 180 },
    [1008] = { x = 74, y = 43, name = "Atlantis (Lv 180)", defenseReq = 300 },
    [1010] = { x = 60, y = 60, name = "Aida (Lv 200)", defenseReq = 390 },
    [1011] = { x = 15, y = 13, name = "Icarus (Lv 230)", defenseReq = 520 },
    [1012] = { x = 50, y = 50, name = "Phế Tích Kanturu (Lv 260)", defenseReq = 680 },
    [1013] = { x = 50, y = 50, name = "Di Chỉ Kanturu (Lv 290)", defenseReq = 850 },
}

GetBestMonsterFarmPoint = function(curMap)
    local bestPoint = nil
    pcall(function()
        if not curMap or curMap == 0 then
            curMap = (_G.SceneData and _G.SceneData.mapId) or 0
        end
        if not curMap or curMap == 0 then return end
        curMap = tonumber(curMap)

        local pointList = nil
        if _G.ClientTable and _G.ClientTable.cfg_Map_minimapManager and _G.ClientTable.cfg_Map_minimapManager.GetMonsterPointList then
            pointList = _G.ClientTable.cfg_Map_minimapManager:GetMonsterPointList(curMap)
        end

        local myDef = GetPlayerMonsterDefense()
        local validPoints = {}
        local lowestDefPoint = nil
        local minDefVal = 999999

        if pointList and type(pointList) == "table" and #pointList > 0 then
            for _, pt in ipairs(pointList) do
                if pt then
                    local coordStr = pt.position or pt.coord or ""
                    local coords = string.split(coordStr, "#")
                    local px = tonumber(coords[1]) or (pt.x and tonumber(pt.x)) or 0
                    local py = tonumber(coords[2]) or (pt.y and tonumber(pt.y)) or 0

                    local mId = pt.Param or pt.monsterId or 0
                    local defReq = tonumber(pt.referToDefense or pt.defenseBase or 0) or 0
                    local mName = pt.name or ""
                    local mLvl = 0
                    local mEff = 0

                    -- 1. Trích xuất cấp độ quái từ tên bãi (ví dụ "Quái Lv195" -> 195)
                    local lvStr = mName:match("[Ll][Vv]%.?%s*(%d+)")
                    if lvStr then
                        mLvl = tonumber(lvStr) or 0
                    end

                    -- 2. Trích xuất mức độ hiệu suất (sao) từ point icon (ví dụ "ico_efficiency_6" -> 6)
                    local ptStr = tostring(pt.point or "")
                    local effStr = ptStr:match("(%d+)")
                    if effStr then
                        mEff = tonumber(effStr) or 0
                    end

                    -- 3. Lấy chỉ số chính xác từ cfg_Monster_monsterManager
                    if mId > 0 and _G.ClientTable and _G.ClientTable.cfg_Monster_monsterManager then
                        local mCfg = _G.ClientTable.cfg_Monster_monsterManager:TryGetValue(mId)
                        if mCfg then
                            if defReq <= 0 then
                                if mCfg.damageAbsorption and tonumber(mCfg.damageAbsorption) > 0 then
                                    defReq = tonumber(mCfg.damageAbsorption)
                                elseif mCfg.defense and tonumber(mCfg.defense) > 0 then
                                    defReq = tonumber(mCfg.defense)
                                elseif mCfg.level and tonumber(mCfg.level) > 0 then
                                    defReq = tonumber(mCfg.level) * 1.2
                                end
                            end
                            if mLvl <= 0 and mCfg.level and tonumber(mCfg.level) > 0 then
                                mLvl = tonumber(mCfg.level)
                            end
                            if not mName or mName:find("Quái") or #mName == 0 then
                                if mCfg.name and #mCfg.name > 0 then
                                    mName = string.format("%s (Lv %d)", mCfg.name, mLvl)
                                end
                            end
                        end
                    end

                    if px > 0 and py > 0 and (mLvl > 0 or defReq > 0 or mEff > 0) then
                        local ptEntry = {
                            id = pt.id or 0,
                            name = mName,
                            x = px,
                            y = py,
                            defenseReq = defReq,
                            monsterLvl = mLvl,
                            efficiency = mEff,
                            monsterId = mId
                        }

                        if defReq < minDefVal then
                            minDefVal = defReq
                            lowestDefPoint = ptEntry
                        end

                        -- Kiểm tra nếu phòng thủ nhân vật đủ đáp ứng thủ yêu cầu của bãi
                        if myDef >= defReq then
                            table.insert(validPoints, ptEntry)
                        end
                    end
                end
            end
        end

        -- SẮP XẾP BÃI QUÁI THEO THỨ TỰ ƯU TIÊN TỐI ĐA:
        -- 1. Cấp độ quái cao nhất (monsterLvl DESC)
        -- 2. Hiệu suất mật độ quái cao nhất (efficiency DESC)
        -- 3. Phòng thủ yêu cầu cao nhất (defenseReq DESC)
        if #validPoints > 0 then
            table.sort(validPoints, function(a, b)
                if a.monsterLvl ~= b.monsterLvl then
                    return a.monsterLvl > b.monsterLvl
                end
                if a.efficiency ~= b.efficiency then
                    return a.efficiency > b.efficiency
                end
                return a.defenseReq > b.defenseReq
            end)
            bestPoint = validPoints[1]
        elseif lowestDefPoint then
            bestPoint = lowestDefPoint
        elseif FALLBACK_MAP_SPOTS[curMap] then
            local fb = FALLBACK_MAP_SPOTS[curMap]
            bestPoint = {
                id = curMap,
                name = fb.name,
                x = fb.x,
                y = fb.y,
                defenseReq = fb.defenseReq,
                monsterLvl = 100,
                efficiency = 1,
                monsterId = 0
            }
        end
    end)
    return bestPoint
end
_G.GetBestMonsterFarmPoint = GetBestMonsterFarmPoint

-- =========================================================================
-- [MOD FEATURE]: BAY SIÊU TỐC VỀ BÃI TRAIN / BÃI QUÁI BẰNG REQCALLFLAG (0ms INSTANT TELEPORT)
-- Mô tả: Sử dụng ReqCallFlag để dịch chuyển tức thì (0ms) về đúng tọa độ bãi train / bãi farm
--        tối ưu theo Phòng thủ thực tế của nhân vật, không dùng chạy bộ chậm chạp.
-- =========================================================================
TeleportToBestFarmPoint = function(curMap)
    local bestPt = GetBestMonsterFarmPoint(curMap)
    if not bestPt or not bestPt.x or not bestPt.y or bestPt.x == 0 or bestPt.y == 0 then 
        return false 
    end

    -- 1. Kiểm tra cự ly hiện tại tới bãi farm
    local pMe = _G.RoleManager and _G.RoleManager.me
    local myPos = (pMe and pMe.cellPos) or (pMe and pMe.serverCoord)
    if myPos and myPos.x and myPos.y then
        local myX = tonumber(myPos.x) or 0
        local myY = tonumber(myPos.y) or 0
        local dist = math.sqrt((myX - bestPt.x)^2 + (myY - bestPt.y)^2)
        if dist <= 5 then
            -- Đã ở ngay sát bãi farm (<= 5 ô), kích hoạt AutoFight xả skill
            pcall(function()
                if pMe.StopMove then pMe:StopMove() end
                if pMe.SetAutoFight then pMe:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
                if pMe.SetAutoHookFight then pMe:SetAutoHookFight(true) end
                if pMe.meAutoFight and pMe.meAutoFight.SetAutoFightHookStart then pMe.meAutoFight:SetAutoFightHookStart(true) end
                if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
            end)
            return false
        end
    end

    Log(string.format("-> [BAY BÃI FARM 0ms]: ReqCallFlag bay thẳng tới bãi quái: %s (Tọa độ: %d#%d | Thủ yêu cầu: %d)...", 
        tostring(bestPt.name), bestPt.x, bestPt.y, bestPt.defenseReq or 0), true)
    
    pcall(function()
        local lineId = (_G.SceneData and _G.SceneData.line) or 1

        -- 1. Gửi lệnh ReqCallFlag bay thẳng siêu tốc 0ms tới tọa độ (bestPt.x, bestPt.y)
        if _G.networkRequest and _G.networkRequest.ReqCallFlag then
            _G.networkRequest.ReqCallFlag(1, 0, curMap, lineId, bestPt.x, bestPt.y, 0)
        end
        if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
            _G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
                type = 1,
                rid = 0,
                mapId = curMap,
                line = lineId,
                x = bestPt.x,
                y = bestPt.y,
                hostId = 0
            })
        end
        if _G.networkRequest and _G.networkRequest.ReqTransmit then
            _G.networkRequest.ReqTransmit(curMap, lineId, bestPt.x, bestPt.y)
        end

        -- 2. Kích hoạt AutoFight
        local me = _G.RoleManager and _G.RoleManager.me
        if me then
            if me.StopMove then me:StopMove() end
            if me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
            if me.SetAutoHookFight then me:SetAutoHookFight(true) end
            if me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
        end
        if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
    end)
    return true
end
_G.TeleportToBestFarmPoint = TeleportToBestFarmPoint

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG CƯỜNG HÓA ĐỀU TRANG BỊ ĐANG MẶC (+5 -> +10 -> +15)
-- Mô tả: Tự động quét toàn bộ trang bị đang mặc trên người (Mũ, Áo, Quần, Găng, Giày, Vũ khí...)
--        Cường hóa đều theo từng bậc:
--        - Bậc 1: Tất cả lên +5
--        - Bậc 2: Tất cả lên +10
--        - Bậc 3: Tất cả lên +15 (hoặc tối đa cho tới khi hết Đá Chúc Phúc / Đá Linh Hồn / Vàng)
-- =========================================================================
_G.AutoEvenEnhanceRunning = false
_G.Bot_HasDoneEnhanceAfterSnowBug = _G.Bot_HasDoneEnhanceAfterSnowBug or false

local function GetEquippedItemsForEnhance()
    local equips = {}
    local equipsData = nil
    pcall(function()
        if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data and _G.RoleManager.me.data.equipsData then
            equipsData = _G.RoleManager.me.data.equipsData.Data
        end
        if not equipsData and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.equipsData then
            equipsData = _G.ViewData.meData.equipsData.Data
        end
    end)
    if not equipsData then return equips end

    for slot, eq in pairs(equipsData) do
        if eq and eq.id and (eq.tblEquip or eq.tblItem) then
            local intensifyCfg = nil
            pcall(function()
                if _G.MeEquipController and _G.MeEquipController.GetEquipIntensifyCfgByEquipData then
                    intensifyCfg = _G.MeEquipController.GetEquipIntensifyCfgByEquipData(eq)
                end
            end)
            if intensifyCfg then
                local itemName = (eq.tblItem and eq.tblItem.name) or ("Slot_" .. tostring(slot))
                local curLvl = eq.intensify or 0
                table.insert(equips, {
                    slot = slot,
                    item = eq,
                    id = eq.id,
                    name = itemName,
                    intensify = curLvl,
                    cfg = intensifyCfg
                })
            end
        end
    end

    -- Sắp xếp theo slot để thứ tự nâng đồ ổn định
    table.sort(equips, function(a, b) return a.slot < b.slot end)
    return equips
end
_G.GetEquippedItemsForEnhance = GetEquippedItemsForEnhance

local function CanEnhanceItem(eqItem)
    if not eqItem or not eqItem.id then return false, "Không có item hợp lệ" end
    local cfg = nil
    pcall(function()
        if _G.MeEquipController and _G.MeEquipController.GetEquipIntensifyCfgByEquipData then
            cfg = _G.MeEquipController.GetEquipIntensifyCfgByEquipData(eqItem)
        end
    end)
    if not cfg then return false, "Không tìm thấy cấu hình cường hóa" end
    if not cfg.cost or #cfg.cost == 0 then return false, "Không có chi phí cường hóa" end

    local parts = string.split(cfg.cost, "&")
    for _, p in ipairs(parts) do
        local sub = string.split(p, "#")
        if #sub >= 2 then
            local matId = tonumber(sub[1])
            local needCount = tonumber(sub[2])
            local haveCount = 0
            pcall(function()
                if matId == 1000021 or matId == 1001 then
                    -- Vàng khoá / vàng
                    haveCount = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(matId)) or 0
                    if haveCount < needCount and _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.data and _G.RoleManager.me.data.gold then
                        haveCount = _G.RoleManager.me.data.gold
                    end
                else
                    haveCount = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(matId)) or 0
                end
            end)
            if haveCount < needCount then
                local matName = "Nguyên liệu " .. tostring(matId)
                if matId == 6000091 then matName = "Đá Chúc Phúc"
                elseif matId == 6000101 then matName = "Đá Linh Hồn"
                elseif matId == 1000021 or matId == 1001 then matName = "Vàng Khoá"
                elseif _G.ClientTable and _G.ClientTable.cfg_Item_itemManager then
                    pcall(function()
                        local iTbl = _G.ClientTable.cfg_Item_itemManager:TryGetValue(matId)
                        if iTbl and iTbl.name then matName = iTbl.name end
                    end)
                end
                return false, string.format("Thiếu %s (Cần: %d | Có trong túi: %d)", matName, needCount, haveCount)
            end
        end
    end
    return true, "Đủ nguyên liệu"
end
_G.CanEnhanceItem = CanEnhanceItem

AutoEvenEnhanceEquipments = function(maxTargetLvl, onFinished)
    if _G.AutoEvenEnhanceRunning then
        _G.Log("-> [CƯỜNG HÓA] Đang có tiến trình cường hóa đang chạy, vui lòng đợi!", true)
        return
    end
    _G.AutoEvenEnhanceRunning = true
    maxTargetLvl = maxTargetLvl or 15

    -- Tự động mặc đồ tốt nhất trước khi cường hóa
    pcall(function()
        if _G.RoleEquipUtility and _G.RoleEquipUtility.AutoWearAll then
            _G.RoleEquipUtility.AutoWearAll()
        end
    end)

    local targetTiers = { 5, 10, 15 }
    local activeTiers = {}
    for _, t in ipairs(targetTiers) do
        if t <= maxTargetLvl then
            table.insert(activeTiers, t)
        end
    end
    if #activeTiers == 0 or activeTiers[#activeTiers] < maxTargetLvl then
        table.insert(activeTiers, maxTargetLvl)
    end

    local function DoEnhanceRoutine()
        _G.Log("=========================================================================")
        _G.Log(string.format(">>> [CƯỜNG HÓA ĐỀU] BẮT ĐẦU NÂNG CẤP TRANG BỊ (MỤC TIÊU: +5 -> +10 -> +%d) <<<", maxTargetLvl), true)
        _G.Log("=========================================================================")
        SaveOutput()

        if Coroutine and Coroutine.Wait then Coroutine.Wait(0.5) end

        -- Lấy số lượng đá chúc phúc ban đầu
        local blessCount = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000091)) or 0
        local soulCount = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000101)) or 0
        _G.Log(string.format("-> [KHO NGUYÊN LIỆU] Đá Chúc Phúc: %d viên | Đá Linh Hồn: %d viên", blessCount, soulCount))
        SaveOutput()

        for _, currentTier in ipairs(activeTiers) do
            _G.Log(string.format("-------------------------------------------------------------------------"))
            _G.Log(string.format(">>> [TIER MỤC TIÊU +%d] Bắt đầu nâng đều toàn bộ trang bị lên +%d...", currentTier, currentTier), true)
            _G.Log(string.format("-------------------------------------------------------------------------"))
            SaveOutput()

            local tierDone = false
            local loopCount = 0
            local maxTierLoops = 300

            while not tierDone and loopCount < maxTierLoops do
                loopCount = loopCount + 1

                -- 1. Quét danh sách trang bị đang mặc
                local equips = GetEquippedItemsForEnhance()
                if not equips or #equips == 0 then
                    _G.Log("-> [CƯỜNG HÓA]: Không tìm thấy trang bị nào đang mặc trên người!", true)
                    tierDone = true
                    break
                end

                -- 2. Tìm trang bị có cấp nhỏ nhất (< currentTier)
                local candidate = nil
                local minLvl = 999
                for _, eq in ipairs(equips) do
                    local curLvl = eq.item.intensify or 0
                    if curLvl < currentTier and curLvl < minLvl then
                        minLvl = curLvl
                        candidate = eq
                    end
                end

                -- Nếu toàn bộ trang bị đã >= currentTier -> Hoàn thành Tier này
                if not candidate then
                    _G.Log(string.format(">>> [TIER +%d HOÀN THÀNH]: Tất cả trang bị đã đạt +%d! <<<", currentTier, currentTier), true)
                    SaveOutput()
                    tierDone = true
                    break
                end

                -- 3. Kiểm tra nguyên liệu của candidate
                local canDo, reason = CanEnhanceItem(candidate.item)
                if not canDo then
                    _G.Log(string.format("-> [DỪNG CƯỜNG HÓA]: %s của món %s (+%d)!", reason, candidate.name, candidate.item.intensify or 0), true)
                    _G.Log(">>> Đã tối ưu hóa và sử dụng toàn bộ nguyên liệu cường hóa hiện có! <<<", true)
                    SaveOutput()
                    _G.AutoEvenEnhanceRunning = false
                    _G.Bot_HasDoneEnhanceAfterSnowBug = true
                    if onFinished then pcall(onFinished) end
                    return
                end

                -- 4. Gửi lệnh Cường hóa món đồ candidate
                local curLvl = candidate.item.intensify or 0
                local curBless = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000091)) or 0
                _G.Log(string.format("-> [ĐẬP ĐỒ]: %s (Slot %d | Cấp: +%d -> +%d | Đá Chúc Phúc còn: %d)...", 
                    candidate.name, candidate.slot, curLvl, curLvl + 1, curBless), true)

                pcall(function()
                    if _G.MeEquipController and _G.MeEquipController.ReqEquipIntensify then
                        _G.MeEquipController.ReqEquipIntensify(candidate.id)
                    elseif _G.networkRequest and _G.networkRequest.ReqEquipIntensify then
                        _G.networkRequest.ReqEquipIntensify(candidate.id)
                    elseif _G.NetManager and _G.EquipMessage and _G.EquipMessage.ReqEquipIntensify then
                        _G.NetManager.Send(_G.EquipMessage.ReqEquipIntensify, { equipId = candidate.id })
                    end
                end)

                -- Chờ server phản hồi và cập nhật equipsData
                if Coroutine and Coroutine.Wait then
                    Coroutine.Wait(0.2)
                end
            end

            if Coroutine and Coroutine.Wait then
                Coroutine.Wait(0.5)
            end
        end

        _G.Log("=========================================================================")
        _G.Log(string.format(">>> [CƯỜNG HÓA HOÀN TẤT] TOÀN BỘ TRANG BỊ ĐÃ ĐẠT +%d HOẶC ĐÃ NÂNG TỐI ĐA! <<<", maxTargetLvl), true)
        _G.Log("=========================================================================")
        SaveOutput()

        _G.AutoEvenEnhanceRunning = false
        _G.Bot_HasDoneEnhanceAfterSnowBug = true
        if onFinished then pcall(onFinished) end
    end

    if Coroutine and Coroutine.Start then
        Coroutine.Start(DoEnhanceRoutine)
    else
        -- Fallback dùng Timer nếu môi trường không hỗ trợ Coroutine
        local blessCount = (_G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId and _G.BagInfoData.GetItemTotalCountByItemId(6000091)) or 0
        _G.Log(string.format("-> [CƯỜNG HÓA TIMER] Bắt đầu (Đá Chúc Phúc: %d)...", blessCount), true)
        local curTierIdx = 1
        local enhanceTimer = nil
        enhanceTimer = Timer.StartLoop(0.25, -1, function()
            if curTierIdx > #activeTiers then
                if enhanceTimer then Timer.Stop(enhanceTimer) end
                _G.AutoEvenEnhanceRunning = false
                _G.Bot_HasDoneEnhanceAfterSnowBug = true
                _G.Log(">>> [CƯỜNG HÓA HOÀN TẤT - TIMER MODE] <<<", true)
                SaveOutput()
                if onFinished then pcall(onFinished) end
                return
            end

            local currentTier = activeTiers[curTierIdx]
            local equips = GetEquippedItemsForEnhance()
            local candidate = nil
            local minLvl = 999
            for _, eq in ipairs(equips) do
                local curLvl = eq.item.intensify or 0
                if curLvl < currentTier and curLvl < minLvl then
                    minLvl = curLvl
                    candidate = eq
                end
            end

            if not candidate then
                _G.Log(string.format("-> [TIER +%d XONG] Chuyển tier tiếp theo...", currentTier), true)
                curTierIdx = curTierIdx + 1
                return
            end

            local canDo, reason = CanEnhanceItem(candidate.item)
            if not canDo then
                if enhanceTimer then Timer.Stop(enhanceTimer) end
                _G.AutoEvenEnhanceRunning = false
                _G.Bot_HasDoneEnhanceAfterSnowBug = true
                _G.Log(string.format("-> [DỪNG CƯỜNG HÓA]: %s!", reason), true)
                SaveOutput()
                if onFinished then pcall(onFinished) end
                return
            end

            local curLvl = candidate.item.intensify or 0
            pcall(function()
                if _G.MeEquipController and _G.MeEquipController.ReqEquipIntensify then
                    _G.MeEquipController.ReqEquipIntensify(candidate.id)
                end
            end)
            _G.Log(string.format("-> [ĐẬP ĐỒ]: %s (+%d -> +%d)", candidate.name, curLvl, curLvl + 1), true)
        end)
    end
end
_G.AutoEvenEnhanceEquipments = AutoEvenEnhanceEquipments

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG MẶC TRANG BỊ MẠNH HƠN TỪ TÚI ĐỒ (AUTO EQUIP BETTER GEAR)
-- =========================================================================
AutoEquipBetterItems = function()
    pcall(function()
        if _G.RoleManager and _G.RoleManager.me then
            _G.PlayerPrefs.SetString(tostring(_G.RoleManager.me.id), "noFirst")
        end
        
        -- 1. Bấm Trang bị ngay nếu popup đang mở
        local tipUI = _G.UIManager and _G.UIID and _G.UIID.Equip_TIpsUI and _G.UIManager.GetUiByName(_G.UIID.Equip_TIpsUI)
        if tipUI and tipUI.btn_quickequip and not IsObjectNil(tipUI.btn_quickequip) and tipUI.btn_quickequip.gameObject.activeInHierarchy then
            if tipUI.Btn_quickequip then tipUI:Btn_quickequip() end
        end
        
        -- 2. Quét túi đồ tìm trang bị tăng lực chiến
        if _G.BagInfoData and _G.BagInfoData.GetTotalBag and _G.RoleEquipUtility then
            local bag = _G.BagInfoData.GetTotalBag()
            if bag then
                for _, item in pairs(bag) do
                    if item and item.id and item.tblEquip then
                        local canWear = false
                        if _G.RoleEquipUtility.CanUpFight then
                            local state = _G.RoleEquipUtility.CanUpFight(item)
                            if state == (_G.EquipUpState and _G.EquipUpState.CanWearUpFight or 1) then
                                canWear = true
                            end
                        end
                        if canWear and _G.RoleEquipUtility.OnWearEquip then
                            local iName = tostring(item.tblItem and item.tblItem.name or item.name or item.id)
                            Log(string.format("[Trang Bị] : Đang mặc món đồ xịn [%s]...", iName), true)
                            _G.RoleEquipUtility.OnWearEquip(item)
                            SaveOutput()
                        end
                    end
                end
            end
        end
        
        -- 3. Xử lý popup Chuyển Trang Bị nếu có
        local transferUI = _G.UIManager and _G.UIID and _G.UIID.Equip_ZhuanyiFastUI and _G.UIManager.GetUiByName(_G.UIID.Equip_ZhuanyiFastUI)
        if transferUI and transferUI.btn_confirm and not IsObjectNil(transferUI.btn_confirm) and transferUI.btn_confirm.gameObject.activeInHierarchy then
            if transferUI.btn_confirmOnClick then
                transferUI:btn_confirmOnClick(transferUI.btn_confirm)
            elseif transferUI.btn_confirm.OnClick then
                transferUI.btn_confirm:OnClick()
            end
            Log("[Chuyển Cường Hóa] : Đã chuyển cấp cường hóa sang trang bị mới", true)
        end
    end)
end
_G.AutoEquipBetterItems = AutoEquipBetterItems

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG NÂNG CẤP ĐỀU HUỲNH THẠCH (+1 -> +2 -> +3... -> +15)
-- Mô tả: Tự động quét toàn bộ các lỗ khảm Huỳnh Thạch trên tất cả các món đồ đang mặc.
--        Nâng cấp đều từng bậc cho đến khi hết Mảnh Thủy Huỳnh Thạch / Vàng Khoá hoặc đạt maxTargetLvl.
-- =========================================================================
_G.AutoEvenUpgradeGemsRunning = false

-- Lắng nghe phản hồi nâng cấp Huỳnh Thạch từ Server
pcall(function()
    if _G.EventManager and _G.Event and _G.Event.GemIndexDataChangeEffect then
        _G.EventManager.RegistEvent(_G.Event.GemIndexDataChangeEffect, function(id, msg)
            if msg and msg.gemIndex then
                Log(string.format(">>> [SERVER CONFIRM]: Huỳnh Thạch index %s nâng cấp %s! <<<", 
                    tostring(msg.gemIndex), tostring(msg.success and "THÀNH CÔNG" or "THẤT BẠI")), true)
                SaveOutput()
            end
        end, nil)
    end
end)

local function GetEquipIndexExtraManager()
    local gMgr = _G.gameMgr or gameMgr
    if gMgr and gMgr.GetAvatarManager and gMgr:GetAvatarManager() and gMgr:GetAvatarManager().GetMainPlayer and gMgr:GetAvatarManager():GetMainPlayer().GetEquipManager then
        local eqMgr = gMgr:GetAvatarManager():GetMainPlayer():GetEquipManager()
        if eqMgr and eqMgr.GetEquipIndexExtraDataManager then
            return eqMgr:GetEquipIndexExtraDataManager()
        end
    end
    return nil
end

local function GetAllEquippedGemsList()
    local gemList = {}
    pcall(function()
        local equipIndexExtraMgr = GetEquipIndexExtraManager()
        if not equipIndexExtraMgr then
            Log("-> [HUỲNH THẠCH DIAG]: Không tìm thấy EquipIndexExtraDataManager!")
            return gemList
        end

        local equipOrderList = (_G.ClientTable and _G.ClientTable.cfg_Item_stone_configManager and _G.ClientTable.cfg_Item_stone_configManager.GetHaveGemEquipIndexOrderList and _G.ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList())
        if not equipOrderList or #equipOrderList == 0 then
            equipOrderList = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
        end

        for _, equipIndex in ipairs(equipOrderList) do
            local equipIndexData = equipIndexExtraMgr:GetEquipIndexData(equipIndex)
            if equipIndexData then
                local gListData = equipIndexData:GetGemListData()
                if gListData then
                    local list = gListData:GetGemList()
                    if list then
                        for _, gemData in pairs(list) do
                            if gemData and gemData.stoneCellInfo and gemData.stoneCellInfo.inlayIndex then
                                local stoneName = (gemData.stoneTbl and gemData.stoneTbl.name) or ("Huỳnh Thạch " .. tostring(gemData.stoneCellInfo.inlayIndex))
                                local curLvl = gemData.stoneLevel or 0
                                table.insert(gemList, {
                                    gem = gemData,
                                    inlayIndex = gemData.stoneCellInfo.inlayIndex,
                                    equipIndex = equipIndex,
                                    level = curLvl,
                                    name = stoneName
                                })
                            end
                        end
                    end
                end
            end
        end
    end)
    return gemList
end

AutoEvenUpgradeGems = function(maxTargetLvl, onFinished)
    if _G.AutoEvenUpgradeGemsRunning then
        return
    end
    maxTargetLvl = maxTargetLvl or 15
    _G.AutoEvenUpgradeGemsRunning = true

    -- Đồng bộ trạng thái Cell nếu cần
    pcall(function()
        if _G.networkRequest and _G.networkRequest.ReqLightStoneCellState then
            _G.networkRequest.ReqLightStoneCellState()
        elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqLightStoneCellState then
            _G.NetManager.Send(_G.BagMessage.ReqLightStoneCellState)
        end
    end)

    -- Kiểm tra số lượng nguyên liệu trong túi
    local shardCount = 0
    local goldCount = 0
    pcall(function()
        if _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
            shardCount = _G.BagInfoData.GetItemTotalCountByItemId(6000641) -- Mảnh Thủy Huỳnh Thạch
            goldCount = _G.BagInfoData.GetItemTotalCountByItemId(1000021)  -- Vàng Khoá
            if goldCount == 0 and _G.BagInfoData.GetItemTotalCountByItemId(1001) then
                goldCount = _G.BagInfoData.GetItemTotalCountByItemId(1001)
            end
        end
    end)

    Log(string.format("-> [HUỲNH THẠCH CHECK]: Nguyên liệu hiện có: Mảnh Thủy Huỳnh Thạch = %d | Vàng = %d", shardCount, goldCount), true)
    SaveOutput()

    local function DoUpgradeGemsRoutine()
        local upgradeCount = 0
        local equipIndexExtraMgr = GetEquipIndexExtraManager()

        while true do
            if equipIndexExtraMgr and equipIndexExtraMgr.ResetGemCalculate then
                equipIndexExtraMgr:ResetGemCalculate()
            end

            local gemList = GetAllEquippedGemsList()
            if #gemList == 0 then
                Log("-> [HUỲNH THẠCH]: Không tìm thấy danh sách lỗ khảm Huỳnh Thạch nào!")
                break
            end

            local candidate = nil
            local minLvl = 9999
            local lackReason = ""

            for _, entry in ipairs(gemList) do
                local lvl = entry.level or 0
                if lvl < maxTargetLvl and entry.gem then
                    local canUp = false
                    if entry.gem.IsCanUpLevel then
                        canUp = entry.gem:IsCanUpLevel()
                    end

                    if canUp then
                        if lvl < minLvl then
                            minLvl = lvl
                            candidate = entry
                        end
                    else
                        if #lackReason == 0 and entry.gem.GetUpLackCostItemId then
                            local lackItem = entry.gem:GetUpLackCostItemId()
                            if lackItem then
                                lackReason = string.format("Thiếu nguyên liệu ID %s (cần %s)", tostring(lackItem.itemId), tostring(lackItem.count))
                            elseif entry.gem.CheckCondition and not entry.gem:CheckCondition() then
                                lackReason = "Chưa đủ điều kiện kích hoạt lỗ khảm"
                            elseif entry.gem.CheckIsMaxLevel and entry.gem:CheckIsMaxLevel() then
                                lackReason = "Đã đạt cấp tối đa"
                            end
                        end
                    end
                end
            end

            if not candidate then
                if upgradeCount == 0 then
                    local msg = "Không có viên nào đủ điều kiện nâng cấp"
                    if #lackReason > 0 then msg = msg .. " (" .. lackReason .. ")" end
                    Log("-> [HUỲNH THẠCH]: " .. msg, true)
                end
                break
            end

            local curLvl = candidate.level or 0
            local targetIndex = candidate.inlayIndex
            pcall(function()
                if _G.networkRequest and _G.networkRequest.ReqLightStoneLevelUp then
                    _G.networkRequest.ReqLightStoneLevelUp(targetIndex)
                elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqLightStoneLevelUp then
                    _G.NetManager.Send(_G.BagMessage.ReqLightStoneLevelUp, { index = targetIndex })
                end
            end)
            upgradeCount = upgradeCount + 1
            Log(string.format("-> [NÂNG HUỲNH THẠCH]: %s (Index: %d | Lv.%d -> Lv.%d)", candidate.name, targetIndex, curLvl, curLvl + 1), true)
            SaveOutput()

            if Coroutine and Coroutine.Wait then
                Coroutine.Wait(0.2)
            end
        end

        if upgradeCount > 0 then
            Log(string.format(">>> [HUỲNH THẠCH HOÀN TẤT] ĐÃ NÂNG CẤP THÀNH CÔNG %d LẦN! <<<", upgradeCount), true)
            SaveOutput()
        end
        _G.AutoEvenUpgradeGemsRunning = false
        if onFinished then pcall(onFinished) end
    end

    if Coroutine and Coroutine.Start then
        Coroutine.Start(DoUpgradeGemsRoutine)
    else
        local upTimer = nil
        local count = 0
        local equipIndexExtraMgr = GetEquipIndexExtraManager()

        upTimer = Timer.StartLoop(0.3, -1, function()
            if equipIndexExtraMgr and equipIndexExtraMgr.ResetGemCalculate then
                equipIndexExtraMgr:ResetGemCalculate()
            end

            local gemList = GetAllEquippedGemsList()
            local candidate = nil
            local minLvl = 9999
            local lackReason = ""

            for _, entry in ipairs(gemList) do
                local lvl = entry.level or 0
                if lvl < maxTargetLvl and entry.gem then
                    local canUp = false
                    if entry.gem.IsCanUpLevel then
                        canUp = entry.gem:IsCanUpLevel()
                    end

                    if canUp then
                        if lvl < minLvl then
                            minLvl = lvl
                            candidate = entry
                        end
                    else
                        if #lackReason == 0 and entry.gem.GetUpLackCostItemId then
                            local lackItem = entry.gem:GetUpLackCostItemId()
                            if lackItem then
                                lackReason = string.format("Thiếu nguyên liệu ID %s (cần %s)", tostring(lackItem.itemId), tostring(lackItem.count))
                            elseif entry.gem.CheckCondition and not entry.gem:CheckCondition() then
                                lackReason = "Chưa đủ điều kiện kích hoạt lỗ khảm"
                            elseif entry.gem.CheckIsMaxLevel and entry.gem:CheckIsMaxLevel() then
                                lackReason = "Đã đạt cấp tối đa"
                            end
                        end
                    end
                end
            end

            if not candidate then
                if upTimer then Timer.Stop(upTimer) end
                _G.AutoEvenUpgradeGemsRunning = false
                if count > 0 then
                    Log(string.format(">>> [HUỲNH THẠCH HOÀN TẤT - TIMER MODE] ĐÃ NÂNG CẤP %d LẦN! <<<", count), true)
                else
                    local msg = "Không có viên nào đủ điều kiện nâng cấp"
                    if #lackReason > 0 then msg = msg .. " (" .. lackReason .. ")" end
                    Log("-> [HUỲNH THẠCH]: " .. msg, true)
                end
                SaveOutput()
                if onFinished then pcall(onFinished) end
                return
            end

            local curLvl = candidate.level or 0
            local targetIndex = candidate.inlayIndex
            pcall(function()
                if _G.networkRequest and _G.networkRequest.ReqLightStoneLevelUp then
                    _G.networkRequest.ReqLightStoneLevelUp(targetIndex)
                elseif _G.NetManager and _G.BagMessage and _G.BagMessage.ReqLightStoneLevelUp then
                    _G.NetManager.Send(_G.BagMessage.ReqLightStoneLevelUp, { index = targetIndex })
                end
            end)
            count = count + 1
            Log(string.format("-> [NÂNG HUỲNH THẠCH]: %s (Index: %d | Lv.%d -> Lv.%d)", candidate.name, targetIndex, curLvl, curLvl + 1), true)
            SaveOutput()
        end)
    end
end
_G.AutoEvenUpgradeGems = AutoEvenUpgradeGems

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG MUA BÌNH MÁU & BÌNH MANA KHI THIẾU
-- Mô tả: Kiểm tra số lượng bình Máu & Mana trong túi. Nếu túi đồ chưa đồng bộ (0 vật phẩm),
--        hoãn kiểm tra để tránh mua nhầm khi mới đăng nhập game.
-- =========================================================================
local function GetPotionCountsAndShopGoods()
    local totalHp = 0
    local totalMp = 0
    local isBagReady = false

    local hpItemIds = {
        [3000020] = true, [3000030] = true, [3000040] = true,
        [3001010] = true, [3001020] = true, [3001030] = true,
        [3001040] = true, [3001050] = true, [3001060] = true,
        [3001070] = true, [3001090] = true
    }
    local mpItemIds = {
        [3000050] = true, [3000060] = true, [3000070] = true,
        [3002010] = true, [3002020] = true, [3002030] = true,
        [3002040] = true
    }

    pcall(function()
        if _G.BagInfoData and _G.BagInfoData.TotalItems then
            local totalItemCount = 0
            for _, item in pairs(_G.BagInfoData.TotalItems) do
                if item then
                    totalItemCount = totalItemCount + 1
                    local iid = item.itemId or (item.tblItem and item.tblItem.id) or (item.data and item.data.itemId) or 0
                    local count = item.count or (item.data and item.data.count) or 1
                    local nameStr = tostring((item.tblItem and item.tblItem.name) or item.name or "")
                    if hpItemIds[iid] or (_G.BagInfoData.RedMedicineItemIds and table.contains(_G.BagInfoData.RedMedicineItemIds, iid)) then
                        totalHp = totalHp + count
                    elseif mpItemIds[iid] or (_G.BagInfoData.BlueMedicineItemIds and table.contains(_G.BagInfoData.BlueMedicineItemIds, iid)) then
                        totalMp = totalMp + count
                    elseif item.tblItem and item.tblItem.type == 1 then
                        if string.find(nameStr, "Máu") or string.find(nameStr, "Chữa Trị") or string.find(nameStr, "Trị Liệu") or string.find(nameStr, "Hồi Phục") or string.find(nameStr, "HP") then
                            totalHp = totalHp + count
                        elseif string.find(nameStr, "MP") or string.find(nameStr, "Mana") or string.find(nameStr, "Ma Pháp") then
                            totalMp = totalMp + count
                        end
                    end
                end
            end

            -- Nếu trong túi có ít nhất 1 vật phẩm, tức túi đồ đã được máy chủ đồng bộ dữ liệu xong
            if totalItemCount > 0 then
                isBagReady = true
            end
        end

        if isBagReady and _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
            if totalHp == 0 and _G.BagInfoData.RedMedicineItemIds then
                for _, rId in ipairs(_G.BagInfoData.RedMedicineItemIds) do
                    totalHp = totalHp + (_G.BagInfoData.GetItemTotalCountByItemId(rId) or 0)
                end
            end
            if totalMp == 0 and _G.BagInfoData.BlueMedicineItemIds then
                for _, bId in ipairs(_G.BagInfoData.BlueMedicineItemIds) do
                    totalMp = totalMp + (_G.BagInfoData.GetItemTotalCountByItemId(bId) or 0)
                end
            end
        end
    end)

    local bestHpGood = nil
    local bestMpGood = nil

    pcall(function()
        local shopList = nil
        if _G.ShopData and _G.ShopData.GetPortableShopInfo then
            shopList = _G.ShopData.GetPortableShopInfo()
        end

        if not shopList or #shopList == 0 then
            if _G.ClientTable and _G.ClientTable.cfg_Item_buyManager and _G.ClientTable.cfg_Item_buyManager.GetDic then
                local allBuy = _G.ClientTable.cfg_Item_buyManager:GetDic()
                shopList = {}
                for _, sc in pairs(allBuy) do
                    if sc.type == 0 and (_G.ConditionManager == nil or _G.ConditionManager.Check4D == nil or _G.ConditionManager.Check4D(sc.showCondition) or string.isNullOrEmpty(sc.showCondition)) then
                        table.insert(shopList, sc)
                    end
                end
            end
        end

        if shopList then
            for _, shop in ipairs(shopList) do
                if shop and shop.reward then
                    local parts = string.split(shop.reward, "#")
                    local rewId = tonumber(parts[1])
                    local packCount = tonumber(parts[2]) or 30
                    if hpItemIds[rewId] or (_G.BagInfoData and _G.BagInfoData.RedMedicineItemIds and table.contains(_G.BagInfoData.RedMedicineItemIds, rewId)) then
                        bestHpGood = { goodId = shop.id, itemId = rewId, packCount = packCount, shop = shop }
                    elseif mpItemIds[rewId] or (_G.BagInfoData and _G.BagInfoData.BlueMedicineItemIds and table.contains(_G.BagInfoData.BlueMedicineItemIds, rewId)) then
                        bestMpGood = { goodId = shop.id, itemId = rewId, packCount = packCount, shop = shop }
                    end
                end
            end
        end
    end)

    return totalHp, totalMp, bestHpGood, bestMpGood, isBagReady
end

_G.LastPotionBuyTime = _G.LastPotionBuyTime or 0
AutoBuyPotionsIfLow = function(targetMinCount, targetRefillCount)
    targetMinCount = targetMinCount or 100
    targetRefillCount = targetRefillCount or 500

    local nowSec = os.time()
    if nowSec - _G.LastPotionBuyTime < 180 then
        return
    end

    pcall(function()
        local totalHp, totalMp, bestHpGood, bestMpGood, isBagReady = GetPotionCountsAndShopGoods()
        
        -- BẢO VỆ AN TOÀN: Nếu túi đồ chưa tải xong từ server -> Không mua để tránh nhận nhầm là 0 bình
        if not isBagReady then
            Log("-> [AUTO MUA THUỐC]: Dữ liệu túi đồ (BagInfoData) chưa tải xong -> Bỏ qua kiểm tra mua!", false)
            return
        end

        local didBuy = false

        if totalHp < targetMinCount and bestHpGood then
            local needed = math.max(0, targetRefillCount - totalHp)
            local packCount = bestHpGood.packCount or 30
            local buyPacks = math.ceil(needed / packCount)
            if buyPacks > 0 then
                didBuy = true
                Log(string.format("-> [AUTO MUA MÁU]: Số lượng Máu hiện tại %d < %d -> Mua %d gói (%d bình, goodId: %d)!", 
                    totalHp, targetMinCount, buyPacks, buyPacks * packCount, bestHpGood.goodId), true)
                if _G.networkRequest and _G.networkRequest.ReqBuy then
                    _G.networkRequest.ReqBuy(bestHpGood.goodId, buyPacks)
                elseif _G.NetManager and _G.ItemBuyMessage and _G.ItemBuyMessage.ReqBuy then
                    _G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, { goodId = bestHpGood.goodId, buyCount = buyPacks })
                end
            end
        end

        if totalMp < targetMinCount and bestMpGood then
            local needed = math.max(0, targetRefillCount - totalMp)
            local packCount = bestMpGood.packCount or 30
            local buyPacks = math.ceil(needed / packCount)
            if buyPacks > 0 then
                didBuy = true
                Log(string.format("-> [AUTO MUA MANA]: Số lượng Mana hiện tại %d < %d -> Mua %d gói (%d bình, goodId: %d)!", 
                    totalMp, targetMinCount, buyPacks, buyPacks * packCount, bestMpGood.goodId), true)
                if _G.networkRequest and _G.networkRequest.ReqBuy then
                    _G.networkRequest.ReqBuy(bestHpGood.goodId, buyPacks)
                elseif _G.NetManager and _G.ItemBuyMessage and _G.ItemBuyMessage.ReqBuy then
                    _G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, { goodId = bestMpGood.goodId, buyCount = buyPacks })
                end
            end
        end

        if didBuy then
            _G.LastPotionBuyTime = nowSec
            SaveOutput()
        end

        DismissBlockers()
    end)
end
_G.AutoBuyPotionsIfLow = AutoBuyPotionsIfLow

-- =========================================================================
-- [MOD FEATURE]: VÒNG LẶP NÂNG CẤP TỔNG HỢP ĐỊNH KỲ 30S (XUYÊN SUỐT TOÀN DIỆN)
-- Mô tả: Chạy độc lập và xuyên suốt vòng đời bot (làm tân thủ hay đã tốt nghiệp treo bãi train):
--        1. Tự động kiểm tra mua Máu (HP) & Mana (MP) nếu dưới 100 -> Mua bù lên 500 (AutoBuyPotionsIfLow)
--        2. Tự động phân bổ điểm tiềm năng (AutoAddAttributePoints)
--        3. Tự động mặc trang bị xịn hơn & Auto Chuyển Trang Bị (AutoEquipBetterItems)
--        4. Tự động thu hồi trang bị rác làm sạch túi (AutoRecycleBagItems qua BlackSmith - không cần VIP)
--        5. Tự động nhận thưởng nhiệm vụ nhánh / thưởng (SolveBranchAndRewardsTasks)
--        6. Tự động Cường Hóa Đều trang bị (+15) (AutoEvenEnhanceEquipments)
--        7. Tự động Nâng Cấp Đều Huỳnh Thạch (+15) (AutoEvenUpgradeGems)
--        8. Tự động dọn dẹp các popup, UI che màn hình (DismissBlockers & Hide Bag UIs)
-- =========================================================================
_G.Global30sUpgradeTimer = _G.Global30sUpgradeTimer or nil

RunPeriodicUpgradeCycle = function()
    pcall(function()
        Log("[Chu Kỳ Nâng Cấp] : Kiểm tra Máu/Mana, Điểm, Mặc đồ & Cường hóa", false)

        -- 0. Tự động mua bù Máu & Mana nếu < 50
        if AutoBuyPotionsIfLow then
            AutoBuyPotionsIfLow(100, 500)
        end

        -- 1. Phân bổ điểm tiềm năng
        if AutoAddAttributePoints then
            AutoAddAttributePoints()
        end

        -- 2. Tự động mặc trang bị xịn hơn & Chuyển cường hóa
        if AutoEquipBetterItems then
            AutoEquipBetterItems()
        elseif _G.RoleEquipUtility and _G.RoleEquipUtility.AutoWearAll then
            _G.RoleEquipUtility.AutoWearAll()
        end
        DismissBlockers()

        -- 3. [QUY TẮC BẮT BUỘC]: CHỜ 5 GIÂY CHO SERVER ĐỒNG BỘ CHUYỂN CƯỜNG HÓA RỒI MỚI THU HỒI RÁC
        Timer.Start(5.0, function()
            pcall(function()
                DismissBlockers()

                -- Thu hồi trang bị rác sau khi đã mặc đồ xịn và kế thừa xong
                if AutoRecycleBagItems then
                    AutoRecycleBagItems()
                end

                -- Quét nhận thưởng nhiệm vụ nhánh / thưởng
                if SolveBranchAndRewardsTasks then
                    SolveBranchAndRewardsTasks()
                end

                -- Cường hóa đều trang bị (+15) & Nâng cấp đều Huỳnh Thạch (+15)
                if not _G.AutoEvenEnhanceRunning and AutoEvenEnhanceEquipments then
                    AutoEvenEnhanceEquipments(15, function()
                        if not _G.AutoEvenUpgradeGemsRunning and AutoEvenUpgradeGems then
                            AutoEvenUpgradeGems(15)
                        end
                    end)
                elseif not _G.AutoEvenUpgradeGemsRunning and AutoEvenUpgradeGems then
                    AutoEvenUpgradeGems(15)
                end

                DismissBlockers()
            end)
        end)
    end)
end
_G.RunPeriodicUpgradeCycle = RunPeriodicUpgradeCycle

StartGlobal30sUpgradePipeline = function()
    if _G.Global30sUpgradeTimer then
        pcall(function() Timer.Stop(_G.Global30sUpgradeTimer) end)
        _G.Global30sUpgradeTimer = nil
    end

    _G.Global30sUpgradeTimer = Timer.StartLoop(30.0, -1, function()
        RunPeriodicUpgradeCycle()
    end)
    Log("-> [GLOBAL 30s UPGRADE]: Đã kích hoạt chu trình nâng cấp định kỳ 30s xuyên suốt toàn diện!", true)
    SaveOutput()
end
_G.StartGlobal30sUpgradePipeline = StartGlobal30sUpgradePipeline

-- =========================================================================
-- 13. [AUTO NHIỆM VỤ TÂN THỦ - QUÉT CAO TỐC 1s/LẦN & LƯU FLOW TIẾN ĐỘ QUEST]
-- =========================================================================
_G.Bot_QuestFlowHistory = _G.Bot_QuestFlowHistory or {}
_G.Bot_LastTrackedQuestId = _G.Bot_LastTrackedQuestId or 0
_G.Bot_LastTrackedState = _G.Bot_LastTrackedState or 0

local function RecordQuestFlow(task, curLvl)
    if not task then return end
    local taskId = task.taskId or (task.GetId and task:GetId()) or 0
    local state = (task.GetState and task:GetState()) or task.state or 0
    local taskName = (task.GetName and task:GetName()) or ("Task_" .. tostring(taskId))
    local taskDes = (task.GetDes and task:GetDes()) or ""
    local toNpc = (task.GetToNpc and task:GetToNpc()) or 0
    local fromNpc = (task.GetFromNpc and task:GetFromNpc()) or 0

    local goalInfo = ""
    pcall(function()
        local goal = task.GetTaskGola and task:GetTaskGola()
        if goal and goal.goalTbl then
            local g = goal.goalTbl
            local gType = g.type or 0
            local gTarget = g.target or ""
            local gCount = g.count or g.maxCount or 1
            goalInfo = string.format("Type: %s | Target: %s | Cần: %s", tostring(gType), tostring(gTarget), tostring(gCount))
        end
    end)

    if _G.Bot_LastTrackedQuestId ~= taskId or _G.Bot_LastTrackedState ~= state then
        _G.Bot_LastTrackedQuestId = taskId
        _G.Bot_LastTrackedState = state

        local stateStr = (state == 1 and "Có thể nhận (Acceptable)")
                      or (state == 2 and "Đang làm (Accept)")
                      or (state == 3 and "Đã xong/Chờ trả (Completed)")
                      or (state == 4 and "Đã nộp (Submitted)")
                      or tostring(state)

        local entry = {
            taskId = taskId,
            taskName = taskName,
            state = state,
            stateStr = stateStr,
            level = curLvl,
            desc = taskDes,
            goal = goalInfo,
            toNpc = toNpc,
            fromNpc = fromNpc,
            time = os.date("%H:%M:%S")
        }
        table.insert(_G.Bot_QuestFlowHistory, entry)

        Log("-------------------------------------------------------------------------")
        Log(string.format("-> [QUEST FLOW | %s] Nhiệm vụ [%d] \"%s\" | Cấp: %d/110", entry.time, taskId, taskName, curLvl), true)
        Log(string.format("   Trạng thái: %s", stateStr))
        if taskDes and #taskDes > 0 then
            Log(string.format("   Nội dung: %s", tostring(taskDes)))
        end
        if goalInfo and #goalInfo > 0 then
            Log(string.format("   Mục tiêu: %s", tostring(goalInfo)))
        end
        Log("-------------------------------------------------------------------------")
        SaveOutput()
    end
end

-- =========================================================================
-- [CẤU HÌNH NHIỆM VỤ CHUYỂN MAP TÂN THỦ] ("ĐẾN...")
-- =========================================================================
local MAP_TRAVEL_TASKS = {
    [3050] = { name = "Devias", targetMap = 1003, x = 215, y = 45, altMaps = {1003} },
    [3101] = { name = "Dungeon 1", targetMap = 100201, x = 109, y = 247, altMaps = {100201, 1002} },
    [3106] = { name = "Lost Tower", targetMap = 100501, x = 193, y = 30, altMaps = {100501, 1005} },
    [3107] = { name = "Lost Tower Tầng 2", targetMap = 100502, x = 193, y = 30, altMaps = {100502} },
    [3200] = { name = "Atlantis", targetMap = 1008, x = 72, y = 43, altMaps = {1008} },
    [3224] = { name = "Aida", targetMap = 1010, x = 60, y = 60, altMaps = {1010} },
    [3234] = { name = "Icarus", targetMap = 1011, x = 15, y = 13, altMaps = {1011, 101101} },
    [3244] = { name = "Phế Tích Kanturu", targetMap = 1012, x = 50, y = 50, altMaps = {1012} },
    [3254] = { name = "Di Chỉ Kanturu", targetMap = 1013, x = 50, y = 50, altMaps = {1013} },
}
_G.MAP_TRAVEL_TASKS = MAP_TRAVEL_TASKS

-- =========================================================================
-- [BƯỚC 5]: NHẬN THƯ > TRANG BỊ TỐT NHẤT + CHUYỂN CƯỜNG HÓA > THU HỒI RÁC > CƯỜNG HÓA (+15) & HUỲNH THẠCH (+15)
-- =========================================================================
local function StartStep5_MailAndUpgrade(onFinished)
    Log("[Bước 5] : Nhận thư > Mặc đồ tốt > Chuyển cường hóa > Chờ 5s > Thu hồi rác > Cường hóa toàn thân", true)
    SaveOutput()

    pcall(function()
        if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailList then
            _G.NetManager.Send(_G.MailMessage.ReqGetMailList, {})
        end
    end)
    Timer.Start(1.2, function()
        pcall(function()
            if _G.NetManager and _G.MailMessage and _G.MailMessage.ReqGetMailItems then
                _G.NetManager.Send(_G.MailMessage.ReqGetMailItems)
            end
        end)
        Timer.Start(1.2, function()
            -- 1. Mặc đồ tốt nhất & Kế thừa thuộc tính cường hóa
            if AutoEquipBetterItems then AutoEquipBetterItems() end
            DismissBlockers()

            Log("[Trang Bị] : Đã mặc trang bị tốt nhất. Đang chờ 5s để server đồng bộ chuyển cường hóa...", true)

            -- 2. CHỜ 5 GIÂY ĐẢM BẢO CHUYỂN CƯỜNG HÓA HOÀN TẤT TRƯỚC KHI THU HỒI
            Timer.Start(5.0, function()
                DismissBlockers()
                
                -- 3. Thu hồi trang bị rác sau 5 giây
                if AutoRecycleBagItems then AutoRecycleBagItems() end
                
                -- 4. Cường hóa toàn thân lên +15 & Huỳnh thạch lên +15
                AutoEvenEnhanceEquipments(15, function()
                    AutoEvenUpgradeGems(15, function()
                        Log("[Bước 5] : Hoàn tất nâng cấp trang bị toàn thân! -> Chuyển sang Bước 6: Mở rương vàng", true)
                        SaveOutput()
                        if onFinished then onFinished() end
                    end)
                end)
            end)
        end)
    end)
end
_G.StartStep5_MailAndUpgrade = StartStep5_MailAndUpgrade

-- =========================================================================
-- [MOD FEATURE]: TỰ ĐỘNG THAM GIA PHÓ BẢN HUYẾT LÂU & QUẢNG TRƯỜNG QUỶ (LV 110 - 199)
-- =========================================================================
_G.Mod_InstanceMonitorTimer = _G.Mod_InstanceMonitorTimer or nil
_G.Mod_IsRunningInstance = _G.Mod_IsRunningInstance or false

-- Lắng nghe sự kiện cập nhật trạng thái phó bản để bấm Mở Ngay ngay khi đếm 10s xong
pcall(function()
    if _G.EventManager and _G.Event and _G.Event.UpdateCopyDataInfo then
        _G.EventManager.RegistEvent(_G.Event.UpdateCopyDataInfo, function(id, msg)
            pcall(function()
                if _G.networkRequest and _G.networkRequest.ReqSkipWait then
                    _G.networkRequest.ReqSkipWait()
                elseif _G.NetManager and _G.MapMessage and _G.MapMessage.ReqSkipWait then
                    _G.NetManager.Send(_G.MapMessage.ReqSkipWait)
                end
                local goalUI = _G.UIManager and _G.UIID and _G.UIID.Instance_GoalUI and _G.UIManager.GetUiByName(_G.UIID.Instance_GoalUI)
                if goalUI and goalUI.btn_rightnowOnClick then
                    goalUI:btn_rightnowOnClick()
                end
            end)
        end, nil)
    end
end)

CheckAndRunBloodCastleOrDemonPlaza = function(onFinished)
    local pMe = _G.RoleManager and _G.RoleManager.me
    local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or (_G.ViewData and _G.ViewData.meData and _G.ViewData.meData.level) or 1)

    if curLvl < 110 or curLvl >= 200 then
        if onFinished then onFinished() end
        return
    end

    local curMapId = (_G.SceneData and _G.SceneData.mapId) or 0
    local isCurInBC = (curMapId >= 1012000 and curMapId <= 1012099)
    local isCurInDS = (curMapId >= 1010000 and curMapId <= 1010099)
    local isInInstance = isCurInBC or isCurInDS or (_G.TranScriptData and _G.TranScriptData.InTranscript)

    local function StartInstanceMonitorLoop()
        if _G.Mod_InstanceMonitorTimer then
            pcall(function() Timer.Stop(_G.Mod_InstanceMonitorTimer) end)
            _G.Mod_InstanceMonitorTimer = nil
        end
        _G.Mod_IsRunningInstance = true

        Log("[Phó Bản] : Đang giám sát chiến đấu & sẵn sàng bấm [Mở Ngay]...", true)
        SaveOutput()

        local monitorTicks = 0
        local hasSkippedWait = false

        -- Quét siêu nhanh 0.3s/lần để kích hoạt [Mở Ngay] ngay khi sẵn sàng
        _G.Mod_InstanceMonitorTimer = Timer.StartLoop(0.3, -1, function()
            monitorTicks = monitorTicks + 1
            local cMap = (_G.SceneData and _G.SceneData.mapId) or 0
            local inBC = (cMap >= 1012000 and cMap <= 1012099)
            local inDS = (cMap >= 1010000 and cMap <= 1010099)
            local inTrans = inBC or inDS or (_G.TranScriptData and _G.TranScriptData.InTranscript)

            if not inTrans then
                if _G.Mod_InstanceMonitorTimer then
                    Timer.Stop(_G.Mod_InstanceMonitorTimer)
                    _G.Mod_InstanceMonitorTimer = nil
                end
                _G.Mod_IsRunningInstance = false
                Log("[Phó Bản] : Đã hoàn thành phó bản! Tiếp tục làm nhiệm vụ chính...", true)
                SaveOutput()
                DismissBlockers()
                if onFinished then onFinished() end
                return
            end

            -- 1. TỰ ĐỘNG BẤM [MỞ NGAY] (REQSKIPWAIT) BỎ QUA 30s CHỜ ĐỢI
            TriggerDungeonSkipWait()
            if not hasSkippedWait and monitorTicks >= 3 then
                hasSkippedWait = true
                Log("[Phó Bản] : Đã bấm [Mở Ngay] bỏ qua 30s chờ đợi!", true)
            end

            -- 2. Tự động di chuyển tới tâm phó bản & bật Auto Fight
            pcall(function()
                local me = _G.RoleManager and _G.RoleManager.me
                if me then
                    local mx, my = 0, 0
                    if me.Position then mx, my = me.Position.x or 0, me.Position.y or 0 end
                    if inBC then
                        local dist = math.sqrt((mx - 14)^2 + (my - 33)^2)
                        if dist > 3 and me.MoveTo then me:MoveTo({ x = 14, y = 33 }, 0) end
                    elseif inDS then
                        local cx, cy = 137, 167
                        if curLvl >= 150 then cx, cy = 135, 97 end
                        local dist = math.sqrt((mx - cx)^2 + (my - cy)^2)
                        if dist > 5 and me.MoveTo then me:MoveTo({ x = cx, y = cy }, 0) end
                    end
                    if me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
                    if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
                end
            end)

            -- Thu hồi rác định kỳ mỗi 6 giây trong phó bản
            -- AutoRecycle only in 30s upgrade cycle
        end)
    end

    if isInInstance then
        Log(string.format("[Phó Bản] : Đang ở trong phó bản (Map %s)!", tostring(curMapId)), true)
        TriggerDungeonSkipWait()
        StartInstanceMonitorLoop()
        return
    end

    local checkList = {
        { name = "Huyết Lâu", subType = _G.TranScriptData.TranScriptSubType.BloodCastle, condId = 100414, maxNumId = 100404, globalCountId = 60000001 },
        { name = "Quảng Trường Quỷ", subType = _G.TranScriptData.TranScriptSubType.DemonPlaza, condId = 100408, maxNumId = 100702, globalCountId = 60000002 }
    }

    local targetInst = nil
    local targetEnterData = nil

    for _, inst in ipairs(checkList) do
        local enterData, lvlNum = nil, nil
        pcall(function()
            if _G.TranScriptData and _G.TranScriptData.GetEnterConditionData then
                enterData, lvlNum = _G.TranScriptData.GetEnterConditionData(inst.subType, inst.condId, inst.maxNumId, curLvl)
            end
        end)

        if enterData and enterData.id then
            local leftCount = 0
            pcall(function()
                local gTbl = _G.ClientTable.cfg_Global_globalManager:TryGetValue(inst.globalCountId)
                if gTbl and gTbl.effect and _G.RefreshData and _G.RefreshData.GetInstanceCount then
                    leftCount = _G.RefreshData.GetInstanceCount(tonumber(gTbl.effect)) or 0
                end
            end)

            if leftCount > 0 then
                local ticketId = 0
                local needCount = 1
                if enterData.cost then
                    local cParts = string.split(enterData.cost, "#")
                    ticketId = tonumber(cParts[1]) or 0
                    needCount = tonumber(cParts[2]) or 1
                end

                local haveTicketCount = 0
                pcall(function()
                    if ticketId > 0 and _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
                        haveTicketCount = _G.BagInfoData.GetItemTotalCountByItemId(ticketId) or 0
                    end
                end)

                if haveTicketCount >= needCount then
                    targetInst = inst
                    targetEnterData = enterData
                    Log(string.format("[Phó Bản] : Tìm thấy %s (Lượt: %d | Vé: %d/%d)", 
                        inst.name, leftCount, haveTicketCount, needCount), true)
                    break
                end
            end
        end
    end

    if not targetInst or not targetEnterData then
        if onFinished then onFinished() end
        return
    end

    Log(string.format("[Phó Bản] : Tiến vào %s (MapId: %s)", targetInst.name, tostring(targetEnterData.id)), true)
    SaveOutput()

    pcall(function()
        if _G.EventManager and _G.Event and _G.Event.Map_ChangeMap then
            _G.EventManager.Dispatch(_G.Event.Map_ChangeMap, { mapId = targetEnterData.id })
        end
        if _G.UIManager then
            if _G.UIID and _G.UIID.Instance_BloodCastleUI then _G.UIManager.Hide(_G.UIID.Instance_BloodCastleUI) end
            if _G.UIID and _G.UIID.Instance_DemonPlazaUI then _G.UIManager.Hide(_G.UIID.Instance_DemonPlazaUI) end
            if _G.UIID and _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
        end
    end)

    Timer.Start(1.5, function()
        DismissBlockers()
        TriggerDungeonSkipWait()
        StartInstanceMonitorLoop()
    end)
end
_G.CheckAndRunBloodCastleOrDemonPlaza = CheckAndRunBloodCastleOrDemonPlaza

-- =========================================================================
-- BẢNG PHÂN LOẠI HÀNH VI NHIỆM VỤ CHUẨN XÁC THEO TASK ID (DETERMINISTIC FLOW)
-- =========================================================================
local TASK_BEHAVIOR = {
    LEVEL_UP     = 1, -- Nhiệm vụ Cấp đạt X / Cày cấp -> Truyền tống bãi quái tối ưu & Bật AutoFight
    MONSTER_KILL = 2, -- Nhiệm vụ Diệt quái cụ thể (Bọ Tuyết...) -> GoTask 1 lần, chờ đánh đủ số lượng
    MAP_TRAVEL   = 3, -- Nhiệm vụ Chuyển map (Đến Devias, Dungeon...) -> Truyền tống tức thì
    SKILL_SHOP   = 4, -- Nhiệm vụ Mua & Học kỹ năng Shop
    EQUIP_WEAR   = 5, -- Nhiệm vụ Mặc trang bị
    RECYCLE      = 6, -- Nhiệm vụ Thu hồi rác
    CRAFT_ITEM   = 7, -- Nhiệm vụ Ghép vé
    DIALOGUE     = 8, -- Nhiệm vụ Đối thoại NPC -> GoTask tới NPC
}

local TASK_CONFIG_BY_ID = {
    -- 1. LEVEL UP TASKS (Cấp đạt ...) -> Teleport to best farm point & AutoFight
    [3000] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 20
    [3001] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 20
    [3102] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 60
    [3104] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 80
    [3108] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 100
    [3109] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 150
    [3150] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 150 mở CS1
    [3220] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 200
    [3230] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 250
    [3240] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 300
    [3250] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 350
    [3260] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt Chuyển 1
    [3267] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 450
    [3274] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 500
    [3281] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 550
    [3288] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 600
    [3295] = TASK_BEHAVIOR.LEVEL_UP, -- Cấp đạt 650

    -- 2. MONSTER KILL TASKS -> GoTask 1 lần, đánh đủ số lượng
    [3060] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Bọ Tuyết
    [3070] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Hàn Băng Ma
    [3080] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Lam Ma Quái
    [3090] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Kẻ Ám Sát
    [3100] = TASK_BEHAVIOR.MONSTER_KILL, -- Diệt Người Tuyết

    -- 3. MAP TRAVEL TASKS -> ReqTransmit
    [3050] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Devias
    [3101] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Dungeon
    [3106] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Lost Tower
    [3107] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Lost Tower 2
    [3200] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Atlantis
    [3224] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Aida
    [3234] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Icarus
    [3244] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Phế Tích Kanturu
    [3254] = TASK_BEHAVIOR.MAP_TRAVEL, -- Đến Di Chỉ Kanturu

    -- 4. SKILL SHOP TASKS
    [3020] = TASK_BEHAVIOR.SKILL_SHOP,
    [3030] = TASK_BEHAVIOR.SKILL_SHOP,
    [3040] = TASK_BEHAVIOR.SKILL_SHOP,
    [3041] = TASK_BEHAVIOR.SKILL_SHOP,

    -- 5. RECYCLE TASKS
    [3010] = TASK_BEHAVIOR.RECYCLE,
    [3061] = TASK_BEHAVIOR.RECYCLE,

    -- 6. EQUIP WEAR TASKS
    [3051] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3052] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3053] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3054] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3206] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3207] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3208] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3221] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3222] = TASK_BEHAVIOR.EQUIP_WEAR,
    [3223] = TASK_BEHAVIOR.EQUIP_WEAR,

    -- 7. CRAFT ITEM TASKS
    [3120] = TASK_BEHAVIOR.CRAFT_ITEM,
}

StartNewbieQuestPipeline = function()
    local pMe = _G.RoleManager and _G.RoleManager.me
    local currentLevel = (pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1

    StartGlobal30sUpgradePipeline()

    if currentLevel >= 200 then
        Log(string.format("-> [TỐT NGHIỆP CẤP ĐỘ] Nhân vật đã Level %s (>= 200) -> Chuyển sang Bước 5: Nhận thư & Nâng cấp toàn thân!", tostring(currentLevel)), true)
        SaveOutput()
        StartStep5_MailAndUpgrade(function()
            StartGoldenChestProcess(function()
                TeleportToTrainMapAndFarm()
            end)
        end)
        return
    end

    Log("=========================================================================")
    Log(string.format(">>> [BƯỚC 4: LEVEL %s/200] ƯU TIÊN LÀM QUEST CHÍNH, QUEST NHÁNH & PHÓ BẢN HL/QTQ! <<<", tostring(currentLevel)), true)
    Log("=========================================================================")
    SaveOutput()

    pcall(function()
        if _G.AutoTaskManage then
            _G.AutoTaskManage.SetAutoTask(true)
            _G.AutoTaskManage.StartCurAutoTask(true)
        end
    end)

    if SolveBranchAndRewardsTasks then SolveBranchAndRewardsTasks() end
    RunPeriodicUpgradeCycle()

    if _G.BotQuestMonitorTimer then
        pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
        _G.BotQuestMonitorTimer = nil
    end

    local loopTickCount = 0

    _G.BotQuestMonitorTimer = Timer.StartLoop(1.0, -1, function()
        pcall(function()
            if _G.Bot_PauseTask or _G.Mod_IsRunningInstance then
                return
            end

            local me = _G.RoleManager and _G.RoleManager.me
            local lvl = (me and me.level) or (me and me.data and me.data.level) or 1

            DismissBlockers()

            if lvl >= 200 then
                if _G.BotQuestMonitorTimer then
                    Timer.Stop(_G.BotQuestMonitorTimer)
                    _G.BotQuestMonitorTimer = nil
                end
                if _G.Global30sUpgradeTimer then
                    Timer.Stop(_G.Global30sUpgradeTimer)
                    _G.Global30sUpgradeTimer = nil
                end
                Log(string.format("[Tốt Nghiệp] : Nhân vật đạt cấp %d >= 200! Thực hiện nâng cấp cuối > Mở rương > Ra bãi farm > Đổi acc!", lvl), true)
                SaveOutput()
                pcall(function()
                    if _G.AutoTaskManage then _G.AutoTaskManage.SetAutoTask(false) end
                end)
                StartStep5_MailAndUpgrade(function()
                    StartGoldenChestProcess(function()
                        TeleportToTrainMapAndFarm(function()
                            SwitchToNextRoleOrAccount()
                        end)
                    end)
                end)
                return
            end

            loopTickCount = loopTickCount + 1

            if lvl >= 110 and loopTickCount % 15 == 0 and not _G.Mod_IsRunningInstance then
                CheckAndRunBloodCastleOrDemonPlaza()
            end

            AutoAddAttributePoints()

            if loopTickCount % 30 == 0 then
                RunPeriodicUpgradeCycle()
            end

            if _G.AutoEvenEnhanceRunning or _G.AutoEvenUpgradeGemsRunning or _G.Mod_IsRunningInstance then
                return
            end

            if SolveBranchAndRewardsTasks then SolveBranchAndRewardsTasks() end

            if _G.TaskData then
                local curTask = _G.TaskData.GetOrderMainTask and _G.TaskData.GetOrderMainTask()
                if curTask then
                    local taskId = curTask.taskId or (curTask.GetId and curTask:GetId()) or 0
                    local state = (curTask.GetState and curTask:GetState()) or curTask.state or 0
                    local taskDes = (curTask.GetDes and curTask:GetDes()) or ""
                    local taskName = (curTask.GetName and curTask:GetName()) or ""

                    -- 1. TRẠNG THÁI HOÀN THÀNH (Completed = 2 hoặc 3): Nộp & Nhận thưởng ngay
                    if state == (_G.TaskStateType and _G.TaskStateType.Completed or 2) or state == 2 or state == 3 then
                        _G.Bot_CurrentTaskId = 0
                        Log(string.format("-> [TRẢ THƯỞNG TASK %s]: Đã hoàn thành! Nộp và nhận thưởng...", tostring(taskId)), true)
                        pcall(function()
                            if _G.networkRequest then
                                if _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
                                if _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
                            end
                            if _G.NetManager and _G.TaskMessage then
                                if _G.TaskMessage.ReqCompleteTask then _G.NetManager.Send(_G.TaskMessage.ReqCompleteTask, { taskId = taskId, id = taskId }) end
                                if _G.TaskMessage.ReqSubmitTask then _G.NetManager.Send(_G.TaskMessage.ReqSubmitTask, { taskId = taskId, id = taskId }) end
                            end
                            if _G.EventManager and _G.Event then
                                if _G.Event.Task_BtnRewardClick then _G.EventManager.Dispatch(_G.Event.Task_BtnRewardClick, taskId) end
                                if _G.Event.Task_BtnSubmitClick then _G.EventManager.Dispatch(_G.Event.Task_BtnSubmitClick, taskId) end
                            end
                        end)
                        SaveOutput()

                    -- 2. TRẠNG THÁI CÓ THỂ NHẬN (Acceptable = 0): Gửi gói nhận nhiệm vụ
                    elseif state == (_G.TaskStateType and _G.TaskStateType.Acceptable or 0) or state == 0 then
                        pcall(function()
                            if _G.networkRequest and _G.networkRequest.ReqAcceptTask then _G.networkRequest.ReqAcceptTask(taskId) end
                            if _G.NetManager and _G.TaskMessage and _G.TaskMessage.ReqAcceptTask then _G.NetManager.Send(_G.TaskMessage.ReqAcceptTask, { taskId = taskId, id = taskId }) end
                            if _G.EventManager and _G.Event and _G.Event.Task_BtnAcceptClick then _G.EventManager.Dispatch(_G.Event.Task_BtnAcceptClick, taskId) end
                        end)

                    -- 3. TRẠNG THÁI ĐANG TIẾN HÀNH (Accept = 1)
                    elseif state == (_G.TaskStateType and _G.TaskStateType.Accept or 1) or state == 1 then
                        local behavior = TASK_CONFIG_BY_ID[taskId]
                        if not behavior then
                            -- Fallback nhận diện nếu taskId chưa khai báo trong bảng
                            local tType = (curTask.GetTaskTypeID and curTask:GetTaskTypeID()) or curTask.type or 0
                            local goal = curTask.GetTaskGola and curTask:GetTaskGola()
                            local gType = (goal and goal.goalTbl and goal.goalTbl.type) or 0
                            local lowName = string.lower(tostring(taskName or ""))
                            if tType == 15 or gType == 301 or gType == 3101 or lowName:find("cấp") or lowName:find("level") or lowName:find("lv") then
                                behavior = TASK_BEHAVIOR.LEVEL_UP
                            elseif gType == 101 or gType == 103 or gType == 113 or lowName:find("diệt") or lowName:find("đánh") then
                                behavior = TASK_BEHAVIOR.MONSTER_KILL
                            elseif MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId] then
                                behavior = TASK_BEHAVIOR.MAP_TRAVEL
                            else
                                behavior = TASK_BEHAVIOR.DIALOGUE
                            end
                        end

                        -- A. NHIỆM VỤ CHUYỂN MAP (Đến Devias, Dungeon, Lost Tower...)
                        if behavior == TASK_BEHAVIOR.MAP_TRAVEL or (MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId]) then
                            local travelCfg = MAP_TRAVEL_TASKS and MAP_TRAVEL_TASKS[taskId]
                            if travelCfg then
                                local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
                                if tonumber(curMap) ~= tonumber(travelCfg.targetMap) then
                                    _G.Bot_LastMapTravelTime = _G.Bot_LastMapTravelTime or 0
                                    local nowSec = os.time()
                                    if nowSec - _G.Bot_LastMapTravelTime >= 3 then
                                        _G.Bot_LastMapTravelTime = nowSec
                                        Log(string.format("-> [CHUYỂN MAP TASK %d]: Truyền tống sang %s (Tọa độ: %d#%d)...", taskId, travelCfg.name, travelCfg.x, travelCfg.y), true)
                                        pcall(function()
                                            if _G.networkRequest and _G.networkRequest.ReqTransmit then _G.networkRequest.ReqTransmit(travelCfg.targetMap, 1, travelCfg.x, travelCfg.y) end
                                            if _G.networkRequest and _G.networkRequest.ReqCallFlag then _G.networkRequest.ReqCallFlag(1, 0, travelCfg.targetMap, 1, travelCfg.x, travelCfg.y, 0) end
                                        end)
                                    end
                                else
                                    pcall(function()
                                        if _G.networkRequest and _G.networkRequest.ReqCompleteTask then _G.networkRequest.ReqCompleteTask(taskId) end
                                        if _G.networkRequest and _G.networkRequest.ReqSubmitTask then _G.networkRequest.ReqSubmitTask(taskId) end
                                    end)
                                end
                            end

                        -- B. NHIỆM VỤ CẤP ĐẠT / LUYỆN CẤP -> Tự động di chuyển bãi farm tối ưu & Bật AutoFight
                        elseif behavior == TASK_BEHAVIOR.LEVEL_UP then
                            local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
                            
                            local isMoving = false
                            local isFighting = false
                            pcall(function()
                                local me = _G.RoleManager and _G.RoleManager.me
                                if me and me.IsMoving and me:IsMoving() then isMoving = true end
                                if me and (me.isFightState or (me.meAutoFight and me.meAutoFight.isAutoFight)) then isFighting = true end
                                if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight then isFighting = true end
                            end)

                            _G.Bot_LastFarmTeleportTime = _G.Bot_LastFarmTeleportTime or 0
                            local nowSec = os.time()
                            
                            if (not isMoving and not isFighting) or (nowSec - _G.Bot_LastFarmTeleportTime >= 8) then
                                _G.Bot_LastFarmTeleportTime = nowSec
                                pcall(function()
                                    local hasTele = TeleportToBestFarmPoint(curMap)
                                    if hasTele then
                                        Log(string.format("[Luyện Cấp] : Nhiệm vụ [%d] \"%s\" -> Tiến vào bãi quái tối ưu Map %d để cày cấp!", taskId, tostring(taskName), curMap), true)
                                        SaveOutput()
                                    end
                                end)
                            end
                            
                            pcall(function()
                                local me = _G.RoleManager and _G.RoleManager.me
                                if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
                                if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
                                if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
                                if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
                            end)

                        -- C. NHIỆM VỤ DIỆT QUÁI (Bọ Tuyết...) & ĐỐI THOẠI NPC: GoTask 1 lần, KHÔNG spam khi đang đánh
                        else
                            local nowSec = os.time()
                            _G.Bot_CurrentTaskId = _G.Bot_CurrentTaskId or 0
                            _G.Bot_LastTaskNavTime = _G.Bot_LastTaskNavTime or 0

                            local isNewTask = (_G.Bot_CurrentTaskId ~= taskId)
                            local isIdleTooLong = (nowSec - _G.Bot_LastTaskNavTime >= 12)

                            local isMoving = false
                            local isFighting = false
                            pcall(function()
                                local me = _G.RoleManager and _G.RoleManager.me
                                if me and me.IsMoving and me:IsMoving() then isMoving = true end
                                if me and (me.isFightState or (me.meAutoFight and me.meAutoFight.isAutoFight)) then isFighting = true end
                                if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight then isFighting = true end
                            end)

                            if isNewTask or (isIdleTooLong and not isMoving and not isFighting) then
                                _G.Bot_CurrentTaskId = taskId
                                _G.Bot_LastTaskNavTime = nowSec

                                Log(string.format("-> [ĐIỀU HƯỚNG TASK %s]: Bắt đầu di chuyển tới \"%s\"... ", tostring(taskId), tostring(taskName)), true)
                                pcall(function()
                                    if _G.DirectTask and _G.DirectTask.OpenNav then
                                        _G.DirectTask.OpenNav(curTask)
                                    elseif curTask.GetNavi and not string.isNullOrEmpty(curTask:GetNavi()) and _G.NavigationUtility and _G.NavigationUtility.ClickNavigation then
                                        _G.NavigationUtility.ClickNavigation(curTask:GetNavi())
                                    end
                                end)
                                pcall(function()
                                    if _G.TaskManager and _G.TaskManager.TaskGo then
                                        _G.TaskManager.TaskGo(taskId, _G.TaskTriggeringConditionType and _G.TaskTriggeringConditionType.OnClick or 0)
                                    end
                                end)
                                pcall(function()
                                    if _G.AutoTaskManage and _G.AutoTaskManage.StartCurAutoTask then
                                        _G.AutoTaskManage.StartCurAutoTask(true)
                                    end
                                end)
                            end

                            if behavior == TASK_BEHAVIOR.MONSTER_KILL then
                                pcall(function()
                                    local me = _G.RoleManager and _G.RoleManager.me
                                    if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
                                    if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
                                    if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
                                    if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
                                end)
                            end
                        end
                    end
                else
                    -- KHÔNG CÓ NHIỆM VỤ CHÍNH -> Tự động farm bãi tối ưu của Map hiện tại
                    local curMap = (_G.SceneData and _G.SceneData.mapId) or 0
                    local isMoving = false
                    local isFighting = false
                    pcall(function()
                        local me = _G.RoleManager and _G.RoleManager.me
                        if me and me.IsMoving and me:IsMoving() then isMoving = true end
                        if me and (me.isFightState or (me.meAutoFight and me.meAutoFight.isAutoFight)) then isFighting = true end
                        if _G.QiJiHelperData and _G.QiJiHelperData.isAutoFight then isFighting = true end
                    end)

                    _G.Bot_LastFarmTeleportTime = _G.Bot_LastFarmTeleportTime or 0
                    local nowSec = os.time()
                    if (not isMoving and not isFighting) or (nowSec - _G.Bot_LastFarmTeleportTime >= 8) then
                        _G.Bot_LastFarmTeleportTime = nowSec
                        pcall(function()
                            local hasTele = TeleportToBestFarmPoint(curMap)
                            if hasTele then
                                Log(string.format("[Luyện Cấp] : Chưa có nhiệm vụ mới -> Tự động train bãi tối ưu tại Map %d!", curMap), true)
                                SaveOutput()
                            end
                        end)
                    end
                    pcall(function()
                        local me = _G.RoleManager and _G.RoleManager.me
                        if me and me.SetAutoFight then me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight") end
                        if me and me.SetAutoHookFight then me:SetAutoHookFight(true) end
                        if me and me.meAutoFight and me.meAutoFight.SetAutoFightHookStart then me.meAutoFight:SetAutoFightHookStart(true) end
                        if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then _G.QiJiHelperData.SetAutoFightData(true) end
                    end)
                end
            end
        end)
    end)
end
_G.StartNewbieQuestPipeline = StartNewbieQuestPipeline

-- =========================================================================
-- 14. HÀM LẤY THÔNG TIN MÁY CHỦ FARM CHỈ ĐỊNH (TARGET SERVER FOR CLONE FARMING)
-- Mô tả: Cố định và lấy chính xác Server Farm đã được chỉ định (hoặc do Mod UI chọn):
--        Ưu tiên: _G.TARGET_SERVER_ID -> curAcc.targetServer -> 491
-- =========================================================================
local function GetActualCurrentServerInfo()
    local curAcc = (_G.BotAccounts and _G.BotAccounts[_G.CurrentAccountIndex or 1]) or (GetCurrentAccount and GetCurrentAccount())
    local targetSid = _G.TARGET_SERVER_ID or (curAcc and curAcc.targetServer) or 491
    targetSid = tonumber(targetSid) or 491

    local targetSName = _G.TARGET_SERVER_NAME or ("S" .. tostring(targetSid))
    pcall(function()
        if _G.LoginData then
            if _G.LoginData.server and tonumber(_G.LoginData.server[5]) == targetSid and _G.LoginData.server[1] then
                targetSName = _G.LoginData.server[1]
            elseif _G.LoginData.GetServer then
                local sData = _G.LoginData.GetServer(targetSid) or _G.LoginData.GetServer(tostring(targetSid))
                if sData and sData[1] then
                    targetSName = sData[1]
                end
            end
        end
    end)

    return targetSid, targetSName
end
_G.GetActualCurrentServerInfo = GetActualCurrentServerInfo

local function GetCurrentServerId()
    local sId, _ = GetActualCurrentServerInfo()
    return sId
end
_G.GetCurrentServerId = GetCurrentServerId

local function ResolveActualTargetServer(callback)
    local curAcc = GetCurrentAccount()
    local targetSid = _G.TARGET_SERVER_ID or (curAcc and curAcc.targetServer) or 491
    targetSid = tonumber(targetSid) or 491

    local targetServerData = nil
    local detectedSource = "Target Server Config (S" .. tostring(targetSid) .. ")"

    -- 1. Tìm trong serverList / AndroidServerList
    local allLists = {
        (LoginData and LoginData.serverList) or {},
        (LoginData and LoginData.AndroidServerList) or {},
        (LoginData and LoginData.data and LoginData.data.server_lists) or {}
    }
    for _, list in ipairs(allLists) do
        for _, s in pairs(list) do
            if s and s[5] then
                local sidNum = tonumber(s[5])
                local sName = tostring(s[1] or "")
                local nameNum = string.match(sName, "[Ss](%d+)") or string.match(sName, "(%d+)")
                if (sidNum and sidNum == targetSid) or (nameNum and tonumber(nameNum) == targetSid) then
                    targetServerData = s
                    detectedSource = "serverList (" .. tostring(targetSid) .. " -> " .. sName .. ")"
                    break
                end
            end
        end
        if targetServerData then break end
    end

    -- 2. Tìm qua LoginData.GetServer
    if not targetServerData and LoginData and LoginData.GetServer then
        targetServerData = LoginData.GetServer(targetSid) or LoginData.GetServer(tostring(targetSid))
        if targetServerData then
            detectedSource = "LoginData.GetServer(" .. tostring(targetSid) .. ")"
        end
    end

    -- 3. Nếu server đang chọn trong LoginData trùng targetSid
    if not targetServerData and LoginData and LoginData.server and LoginData.server[5] and tonumber(LoginData.server[5]) == targetSid then
        targetServerData = LoginData.server
        detectedSource = "LoginData.server Current Selected (" .. tostring(targetServerData[1] or targetServerData[5]) .. ")"
    end

    -- 4. Fallback tự tạo data chuẩn cho targetServer
    if not targetServerData then
        targetServerData = {
            [1] = "VĨNH HẰNG " .. tostring(targetSid),
            [2] = "",
            [3] = (EServerState and EServerState.NewServer) or 2,
            [4] = "",
            [5] = targetSid,
            [6] = ""
        }
        detectedSource = "Generated TargetServer (S" .. tostring(targetSid) .. ")"
    end

    Log(string.format("-> [CHỈ ĐỊNH MÁY CHỦ FARM]: %s (ID: %s) [Nguồn: %s]", 
        tostring(targetServerData[1]), tostring(targetServerData[5]), tostring(detectedSource)))

    -- Đồng bộ lại targetServer trong account config
    curAcc.targetServer = targetServerData[5]
    if _G.BotAccounts and _G.BotAccounts[_G.CurrentAccountIndex or 1] then
        _G.BotAccounts[_G.CurrentAccountIndex or 1].targetServer = targetServerData[5]
    end

    if callback then callback(targetServerData) end
end

ConnectToTargetServer = function()
    ResolveActualTargetServer(function(targetServerData)
        if not targetServerData then
            Log("LỖI: Không tìm thấy máy chủ hợp lệ trong danh sách!")
            SaveOutput()
            return
        end

        local serverName = tostring(targetServerData[1] or ("Server " .. tostring(targetServerData[5])))
        local serverId = targetServerData[5]

        Log(string.format("--- [BƯỚC 4] KẾT NỐI MÁY CHỦ %s (ID: %s) (ACC %d/%d: %s | ROLE %d/4) ---", 
            serverName, tostring(serverId), _G.CurrentAccountIndex or 1, #_G.BotAccounts, tostring(GetCurrentAccount().account), _G.CurrentRoleIndex or 1))

        -- 1. Thiết lập Server trong LoginData
        LoginData.SetServer(targetServerData)
        LoginData.equipmentList = nil
        pcall(function()
            if LoginData.ChangeOftenServer then
                LoginData.ChangeOftenServer()
            end
        end)

        -- 2. Cập nhật Text & State hiển thị trên Login_LoginUI
        pcall(function()
            local loginUI = nil
            if UIManager and UIManager.GetUiByName then
                loginUI = UIManager.GetUiByName("Login_LoginUI")
            end
            if loginUI then
                if loginUI.lab_connectServerName and loginUI.lab_connectServerName.SetText then
                    loginUI.lab_connectServerName:SetText(serverName)
                end
                if loginUI.img_connectServerState and loginUI.img_connectServerState.image and EServerStateColor and targetServerData[3] then
                    loginUI.img_connectServerState.image.color = EServerStateColor[tonumber(targetServerData[3])]
                end
            end
        end)

        -- 3. Hủy đăng ký listener cũ trước khi đăng ký mới
        if _G.TestEventContainer then
            pcall(function() _G.TestEventContainer:UnRegistAll() end)
        end
        _G.TestEventContainer = EventContainer(EventManager)

        _G.TestEventContainer:Regist(Event.Net_ConnectSuccess, function()
            Log("[EVENT] Net_ConnectSuccess -> TCP Đã kết nối!")
            SaveOutput()
        end)

        _G.TestEventContainer:Regist(Event.Login_ConnectSuccess, function()
            Log("[EVENT] Login_ConnectSuccess -> Đăng nhập máy chủ thành công!")
            SaveOutput()
        end)

        _G.TestEventContainer:Regist(Event.Login_ResGetRoleList, function()
            Log("[EVENT] Login_ResGetRoleList -> ĐÃ NHẬN DANH SÁCH NHÂN VẬT!")
            DismissBlockers()

            local roles = LoginData.roleList or {}
            _G.TotalRolesInCurrentAccount = #roles
            Log(">>> TỔNG SỐ NHÂN VẬT HIỆN CÓ TRONG TÀI KHOẢN: " .. tostring(#roles))
            for i, r in ipairs(roles) do
                local roleInfo = r.info or r.data or r or {}
                local rId = roleInfo.roleId or roleInfo.id or r.roleId or r.id
                Log(string.format("   [%d] ID: %s | Tên: %s | Level: %s", i, tostring(rId), tostring(roleInfo.name), tostring(roleInfo.level)))
            end
            SaveOutput()

            local targetIdx = _G.CurrentRoleIndex or 1
            Timer.Start(DELAY, function()
                SelectRoleByIndex(targetIdx)
            end)
        end)

        _G.TestEventContainer:Regist(Event.GamePlay_Enter, function()
            Log("[EVENT] GamePlay_Enter -> ĐÃ VÀO THẾ GIỚI TRONG GAME THÀNH CÔNG!")
            if _G.Bot_IsInGameWorld then
                ApplyFovAndSpeed()
                return
            end
            _G.Bot_IsInGameWorld = true

            -- Dừng bất kỳ Timer Quest cũ nào nếu có
            if _G.BotQuestMonitorTimer then
                pcall(function() Timer.Stop(_G.BotQuestMonitorTimer) end)
                _G.BotQuestMonitorTimer = nil
            end

            Timer.Start(DELAY, function()
                DismissBlockers()
                ApplyFovAndSpeed()
                local pMe = _G.RoleManager and _G.RoleManager.me
                local currentLevel = (pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1
                Log(string.format("-> Level nhân vật hiện tại: %s", tostring(currentLevel)), true)
                SaveOutput()

                -- ĐIỀU HƯỚNG THEO CẤP ĐỘ NHÂN VẬT:
                StartGlobal30sUpgradePipeline()

                if currentLevel >= 200 then
                    Log("=========================================================================")
                    Log(string.format(">>> NHÂN VẬT ĐÃ ĐẠT LEVEL %s >= 200 -> ĐÃ TỐT NGHIỆP HOÀN TOÀN! <<<", tostring(currentLevel)), true)
                    Log("=========================================================================")
                    SaveOutput()
                    RunPeriodicUpgradeCycle()
                    Timer.Start(DELAY, function()
                        StartGoldenChestProcess(function()
                            Timer.Start(DELAY, function()
                                TeleportToTrainMapAndFarm()
                            end)
                        end)
                    end)
                elseif currentLevel >= 110 then
                    Log("=========================================================================")
                    Log(string.format(">>> NHÂN VẬT LEVEL %s (110 - 199) -> KIỂM TRA PHÓ BẢN HUYẾT LÂU / QUẢNG TRƯỜNG QUỶ! <<<", tostring(currentLevel)), true)
                    Log("=========================================================================")
                    SaveOutput()
                    RunPeriodicUpgradeCycle()
                    Timer.Start(DELAY, function()
                        CheckAndRunBloodCastleOrDemonPlaza(function()
                            StartGoldenChestProcess(function()
                                Timer.Start(DELAY, function()
                                    TeleportToTrainMapAndFarm()
                                end)
                            end)
                        end)
                    end)
                else
                    Log("=========================================================================")
                    Log(string.format(">>> NHÂN VẬT LEVEL %s (< 110) -> TIẾN HÀNH CHU TRÌNH CÀY TÂN THỦ! <<<", tostring(currentLevel)), true)
                    Log("=========================================================================")
                    SaveOutput()

                    -- Chỉ nhập code nếu Level <= 3 (tài khoản mới tạo), nếu > 3 thì bỏ qua vì đã nhập trước đó
                    if currentLevel <= 3 and _G.RunAutoGiftcode then
                        Log("=========================================================================")
                        Log(">>> [LEVEL <= 3] TỰ ĐỘNG NHẬP 34 CODE & NHẬN HÒM THƯ TRƯỚC TIÊN... <<<", true)
                        Log("=========================================================================")
                        SaveOutput()
                        _G.RunAutoGiftcode(function()
                            Log("=========================================================================")
                            Log(">>> ĐÃ NHẬN CODE & HÒM THƯ XONG! BẮT ĐẦU AUTO NHIỆM VỤ TÂN THỦ (1s/LẦN)... <<<", true)
                            Log("=========================================================================")
                            SaveOutput()
                            StartNewbieQuestPipeline()
                        end)
                    else
                        if currentLevel > 3 then
                            Log(string.format("-> [LEVEL %d > 3] Đã từng nhận code -> BỎ QUA NHẬP CODE & ĐI THẲNG VÀO LÀM TIẾP NHIỆM VỤ TÂN THỦ!", currentLevel), true)
                            SaveOutput()
                        end
                        StartNewbieQuestPipeline()
                    end
                end
            end)
        end)

        Log("2. Kích hoạt kết nối Server " .. serverName .. " (ID: " .. tostring(serverId) .. ")...")
        ReconnectManager.OnConnect()
        SaveOutput()
    end)
end

-- =========================================================================
-- 14. ĐẢM BẢO DANH SÁCH SERVER & ROLEDATA
-- =========================================================================
EnsureServerListLoaded = function(onSuccess)
    local hasList = false
    if LoginData and LoginData.serverList and #LoginData.serverList > 0 then
        hasList = true
    elseif LoginData and LoginData.data and LoginData.data.server_lists and #LoginData.data.server_lists > 0 then
        hasList = true
    end

    local function OnListReady()
        pcall(function()
            if LoginData and LoginData.InitOftenServer then
                LoginData.InitOftenServer()
            end
            if RoleDeclareManager and RoleDeclareManager.GetRoleInformation then
                RoleDeclareManager.GetRoleInformation()
            end
        end)
        if onSuccess then onSuccess() end
    end

    if hasList then
        OnListReady()
        return
    end

    Log("--- [BƯỚC 3] Đang tải danh sách Server... ---")
    local url = LoginData.GetUrlByNet()
    Http.Request(url, function(text)
        if string.isNullOrEmpty(text) then
            Log("LỖI: Không thể tải danh sách server!")
            SaveOutput()
            return
        end

        local server_lists_initial = text
        if LoginData.isNeedDeEncrypConfig then
            server_lists_initial = CS.Encryption.ReplaceValue(text)
        end
        local parsed = json.decode(server_lists_initial)
        if parsed and parsed.server_lists then
            LoginData.data = parsed
            LoginData.SetServerList(parsed.server_lists)
            if parsed.recommend then LoginData.SetServiceRecommend(parsed.recommend) end
            if parsed.equipment_lists then LoginData.SetEquipmentList(parsed.equipment_lists) end
            LoginData.InitOftenServer()
            LoginData.SortOutServerList()
            Log("-> Đã tải xong danh sách (" .. tostring(#parsed.server_lists) .. " servers)!")
            Timer.Start(DELAY, function() OnListReady() end)
        else
            Log("LỖI: Định dạng danh sách server không hợp lệ!")
            SaveOutput()
        end
    end)
end

-- =========================================================================
-- 12. SDK AUTHENTICATION + GAME CHECK LOGIN
-- =========================================================================
StartFullLoginProcess = function()
    local curAcc = GetCurrentAccount()
    local username = curAcc.account or "accmuvh0001@gmail.com"
    local password = curAcc.password or "12345ZXC"
    Log(string.format("--- [BƯỚC 2] GỬI SDK AUTH (ACC %d/%d: %s | SERVER %s | ROLE %d/4) ---", 
        _G.CurrentAccountIndex or 1, #_G.BotAccounts, tostring(username), tostring(curAcc.targetServer or (_G.GetCurrentServerId and _G.GetCurrentServerId()) or 'Auto'), _G.CurrentRoleIndex or 1))
    local equip = MD5("muvh_bot_device_equip_uuid_001")
    
    local params = {
        username = username,
        pass = MD5(password),
        appid = "300270",
        equip = equip,
        device_id = equip,
        device_name = "SM-G975F",
        reg_from = "1",
        reg_type = "0",
        ad_id = "0",
        app_version = "1.0.0",
        sdk_version = "1.0.7",
        token = "",
        package_name = "com.vnyh.gp",
        _af = UrlEncode("appid=300270&gps_adid=&appsflyer_id="),
        _dana_v2 = UrlEncode("terminal=android&bundle_name=MU Vĩnh Hằng&bundle_id=com.vnyh.gp&appid=300270&did=" .. equip),
        __hw = UrlEncode("_res=1920*1080&bundle_name=MU Vĩnh Hằng&did=" .. equip)
    }
    
    local signKeys = {}
    for k, _ in pairs(params) do
        if k ~= "sign" and not string.find(k, "__") then
            table.insert(signKeys, k)
        end
    end
    table.sort(signKeys)
    local signItems = {}
    for _, k in ipairs(signKeys) do
        table.insert(signItems, k .. "=" .. UrlEncode(tostring(params[k])))
    end
    local signRaw = SDK_SALT .. table.concat(signItems, "&")
    params.sign = MD5(signRaw)
    
    local allKeys = {}
    for k, _ in pairs(params) do
        table.insert(allKeys, k)
    end
    table.sort(allKeys)
    local allItems = {}
    for _, k in ipairs(allKeys) do
        table.insert(allItems, UrlEncode(k) .. "=" .. UrlEncode(tostring(params[k])))
    end
    local safeSignStr = table.concat(allItems, "&")
    
    local t = tostring(os.time())
    local keyStr = MD5(SDK_SIGNATURE .. t)
    local encBytes = XXTEA_Encrypt(safeSignStr, keyStr)
    local o_b64 = Base64Encode(encBytes)
    
    local form = CS.UnityEngine.WWWForm()
    form:AddField("t", t)
    form:AddField("o", o_b64)
    
    local headers = {
        ["encrypt-type"] = "xxtea",
        ["Accept"] = "application/json"
    }
    
    Http.RequestHaveHandleArg("https://user.muvh.vn/vie/user_login", form, headers, function(text)
        if string.isNullOrEmpty(text) then
            Log("LỖI: Máy chủ SDK không phản hồi!")
            SaveOutput()
            return
        end
        
        local resp = json.decode(text)
        if not (resp and resp.ret == 0 and resp.data) then
            Log("LỖI: SDK Login thất bại: " .. tostring(resp and (resp.msg or resp.ret)))
            SaveOutput()
            return
        end

        Log("-> [SDK] Login Thành Công! UID: " .. tostring(resp.data.user_id))
        
        local sdkData = {
            userId = tostring(resp.data.user_id),
            name = tostring(resp.data.username or username),
            token = tostring(resp.data.access_token),
            time = tostring(resp.data.server_ts),
            gid = "1320",
            pid = "1320",
            ext = tostring(resp.data.login_verify_sign),
            opName = "v3koreagoogleyace_apk",
            serviceCode = "",
            loginType = "10"
        }
        
        LoginData.sdkUserId = sdkData.userId
        LoginData.neckName = sdkData.name
        LoginData.token = sdkData.token
        LoginData.gid = sdkData.gid
        LoginData.pId = sdkData.pid
        LoginData.loginExt = sdkData.ext
        LoginData.isSdkLogging = true
        LoginData.opName = sdkData.opName
        LoginData.loginType = sdkData.loginType
        LoginData.roleName = ""
        LoginData.roleLevel = 1
        LoginData.createTime = 1
        LoginData.equipmentList = nil
        
        local ckForm = CS.UnityEngine.WWWForm()
        ckForm:AddField("gid", tostring(LoginData.gid))
        ckForm:AddField("time", tostring(sdkData.time))
        ckForm:AddField("token", tostring(LoginData.token))
        ckForm:AddField("uid", tostring(LoginData.sdkUserId))
        ckForm:AddField("pid", tostring(LoginData.pId))
        ckForm:AddField("login_token", tostring(LoginData.token))
        ckForm:AddField("game_account_no", tostring(LoginData.sdkUserId))
        ckForm:AddField("username", tostring(LoginData.neckName))
        ckForm:AddField("login_verify_sign", tostring(LoginData.loginExt))
        
        local ckUrl = string.format(PlatformData.GetCKUrl(), LoginData.opName)
        Log("--- XÁC THỰC GAME CHECK LOGIN: " .. ckUrl .. " ---")
        
        Http.RequestHaveArg(ckUrl, ckForm, function(ckText)
            if string.isNullOrEmpty(ckText) then
                Log("LỖI: Game Auth Server không phản hồi!")
                SaveOutput()
                return
            end

            local backData = json.decode(ckText)
            if backData and not backData.errno then
                Log("-> [GAME AUTH] Thành Công!")
                Log("   - loginName: " .. tostring(backData.loginName))
                Log("   - sign: " .. tostring(backData.sign))

                LoginData.sign = backData.sign
                LoginData.userName = backData.loginName
                LoginData.time = backData.time
                LoginData.accessToken = backData.token
                
                local infos = string.split(backData.loginName, ":")
                LoginData.operId = tonumber(infos[1])
                LoginData.pId = tonumber(infos[2])
                LoginData.panelState = 3
                LoginData.equipmentList = nil
                
                if not string.isNullOrEmpty(LoginData.accessToken) and CS.MuInterface and CS.MuInterface.Instance then
                    CS.MuInterface.Instance:SendToken(LoginData.accessToken)
                end
                
                EventManager.Dispatch(Event.Login_LoginSuccess)
                SaveOutput()

                Timer.Start(DELAY, function()
                    EnsureServerListLoaded(function()
                        Timer.Start(DELAY, function()
                            ConnectToTargetServer()
                        end)
                    end)
                end)
            else
                Log("LỖI: Game Check Login thất bại: " .. tostring(backData and backData.msg))
                SaveOutput()
            end
        end)
    end)
end

-- =========================================================================
-- KHỞI ĐỘNG CHU TRÌNH: TỰ ĐỘNG PHÁT HIỆN ĐANG TRONG GAME HAY PHẢI ĐĂNG NHẬP
-- =========================================================================
local pMe = _G.RoleManager and _G.RoleManager.me
local isInGame = (_G.LoginData and _G.LoginData.InGame) or (pMe ~= nil and (pMe.level or (pMe.data and pMe.data.level)))

if isInGame then
    local curLvl = tonumber((pMe and pMe.level) or (pMe and pMe.data and pMe.data.level) or 1)
    local curRoleName = tostring((pMe and pMe.name) or (pMe and pMe.data and pMe.data.name) or "Me")
    local curServerId, curServerName = nil, "S491"
    pcall(function()
        if _G.GetActualCurrentServerInfo then
            curServerId, curServerName = _G.GetActualCurrentServerInfo()
        end
    end)
    curServerName = curServerName or "VĨNH HẰNG 491"

    local execTime = os.date("%H:%M:%S")
    Log("=========================================================================")
    Log(string.format(">>> [NẠP SCRIPT %s] NV: %s (Lv %d) <<<", execTime, curRoleName, curLvl), true)
    Log("=========================================================================")
    SaveOutput()
    ApplyFovAndSpeed()
    DismissBlockers()

    if AutoBuyPotionsIfLow then
        AutoBuyPotionsIfLow(50, 100)
    end

    if curLvl >= 200 then
        Log(string.format("[Cấp Độc %d >= 200] : Thực hiện chu trình nâng cấp 1 lần > Mở rương > Ra bãi farm > Đổi nhân vật / acc!", curLvl), true)
        SaveOutput()
        StartStep5_MailAndUpgrade(function()
            StartGoldenChestProcess(function()
                TeleportToTrainMapAndFarm(function()
                    SwitchToNextRoleOrAccount()
                end)
            end)
        end)
    else
        Log(string.format(">>> [CẤP ĐỘ %d < 200] BƯỚC 4: ƯU TIÊN LÀM QUEST CHÍNH, QUEST NHÁNH & PHÓ BẢN HL/QTQ! <<<", curLvl), true)
        SaveOutput()
        StartNewbieQuestPipeline()
    end
else
    ForceLogoutToLogin()
    Log("-> Đang đợi " .. tostring(DELAY * 2) .. "s để dọn dẹp game và nạp lại Login Scene...")
    Timer.Start(DELAY * 2, function()
        DismissBlockers()
        StartFullLoginProcess()
    end)
end

SaveOutput()
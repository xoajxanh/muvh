---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global
---@diagnostic disable: duplicate-set-field
-- =========================================================================
-- [MU ORIGIN - AUTO FARM CLIENT BOT]
-- Phiên bản: modified_lua_dev_farm
-- Tính năng:
--  - Nút EXEC nổi (Chạy test script nhanh từ input.luac / input.txt)
--  - Nút BOT STATE nổi (Toggle Running / Pause cho toàn bộ tiến trình)
--  - Banner thông báo On-Screen (Hiển thị trực tiếp State & Log trên màn hình)
--  - Vô hiệu hóa hoàn toàn SDK Native Login Popup
--  - Direct SDK HTTP Login (Gửi trực tiếp request đăng nhập SDK và Game Auth)
--  - Tự động đóng toàn bộ Popup Thông báo (go_notice, go_privacyPolicy, go_AgeNotice, OnHook_ProfitUI)
--  - Tự động chọn Server 397 & Auto Select Role (Gamer22) vào Game
--  - Tự động mở Rương Vàng theo đợt (Mở 20 -> Hút sạch đồ rơi -> Thu hồi/Tách sạch 20 đồ -> Mở tiếp 20)
--  - Lọc Giữ Dòng Ngon (HP + Phản DMG, Tốc + Tấn Công,...)
--  - Tự động dịch chuyển siêu tốc về bãi train Map 101093 @ 170#103 & Auto Combat
--  - FOV = 65, Tốc độ chạy = 2.5x (Chống giật lùi / Rollback)
-- =========================================================================

EmmyluaDebug = {}

-- =========================================================================
-- CẤU HÌNH BIẾN DELAY CHỜ GIỮA CÁC STEP (MẶC ĐỊNH = 1.0s, CÓ THỂ ĐỔI THÀNH 0.5s KHI CHẠY MƯỢT)
-- =========================================================================
_G.BOT_STEP_DELAY = 1.0
local DELAY = _G.BOT_STEP_DELAY or 1.0

-- =========================================================================
-- 1. CẤU HÌNH BOT MỤC TIÊU & GLOBAL STATE (HỖ TRỢ NHIỀU TÀI KHOẢN & VÒNG LẶP VÔ TẬN)
-- =========================================================================
_G.BotAccounts = {
    [1] = {
        account = "chila1caiten26@gmail.com",
        password = "alo123456",
        targetServer = 400,
        roles = {
            [1] = {
                name = "zMINHz",
                targetMapId = 101094,
                trainCoord = "172#156",
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3, -- Mở tối đa 3 đợt (3x20 = 60 rương) trong bản test
            },
            [2] = {
                name = "zANGELz",
                targetMapId = 101094,
                trainCoord = "172#156",
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            },
            [3] = {
                name = "zMiNHz",
                targetMapId = 101094,
                trainCoord = "172#156",
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            },
            [4] = {
                name = "xANGELx",
                targetMapId = 101094,
                trainCoord = "172#156",
                autoRecycleExcellence = true,
                autoSmeltExcellenceAccessory = true,
                autoSmeltSuit = true,
                keepGoodLines = false,
                maxChestBatches = 3,
            }
        }
    },
    -- Bạn có thể thêm tài khoản 2, 3... vào đây (Tự động lặp lại từ Tài khoản 1 khi chạy hết)
    -- [2] = {
    --     account = "dongsam14@gmail.com",
    --     password = "12345ZXC",
    --     targetServer = 397,
    --     fov = 65,
    --     runSpeedMultiplier = 2.5,
    --     roles = {
    --         [1] = { targetMapId = 101093, trainCoord = "170#103", autoRecycleExcellence = true, autoSmeltExcellenceAccessory = true, autoSmeltSuit = true, keepGoodLines = false, maxChestBatches = 3 },
    --         [2] = { targetMapId = 101093, trainCoord = "170#103", autoRecycleExcellence = true, autoSmeltExcellenceAccessory = true, autoSmeltSuit = true, keepGoodLines = false, maxChestBatches = 3 },
    --         [3] = { targetMapId = 101093, trainCoord = "170#103", autoRecycleExcellence = true, autoSmeltExcellenceAccessory = true, autoSmeltSuit = true, keepGoodLines = false, maxChestBatches = 3 },
    --         [4] = { targetMapId = 101093, trainCoord = "170#103", autoRecycleExcellence = true, autoSmeltExcellenceAccessory = true, autoSmeltSuit = true, keepGoodLines = false, maxChestBatches = 3 }
    --     }
    -- }
}

_G.CurrentAccountIndex = _G.CurrentAccountIndex or 1
_G.CurrentRoleIndex = _G.CurrentRoleIndex or 1
_G.TotalRolesInCurrentAccount = _G.TotalRolesInCurrentAccount or 4

local function GetCurrentAccount()
    if not _G.BotAccounts or #_G.BotAccounts == 0 then
        return {
            account = "chila1caiten26@gmail.com",
            password = "alo123456",
            targetServer = 400,
            fov = 65,
            runSpeedMultiplier = 2.5,
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

-- Hàm lấy cấu hình hợp nhất cho Role hiện tại
local function GetCurrentRoleConfig(roleIndex, roleName)
    local curAcc = GetCurrentAccount()
    local cfg = nil
    if curAcc.roles then
        if roleIndex and curAcc.roles[roleIndex] then
            cfg = curAcc.roles[roleIndex]
        elseif roleName and curAcc.roles[roleName] then
            cfg = curAcc.roles[roleName]
        elseif curAcc.roles[1] then
            cfg = curAcc.roles[1]
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

_G.Bot_Running = false
_G.Bot_LastMsg = ""
_G.Bot_OpenedChestBatches = 0
_G.ModFarmCanvasGo = nil
_G.Bot_StatusTextComp = nil
_G.Bot_IsLoggingIn = false

_G.Mod_GoldenChestState = "OPEN"
_G.Mod_GoldenChestWaitTime = 0
_G.Mod_GoldenChestBatchIds = {}
_G.Bot_HasFinishedChests = false
_G.Bot_IsTeleportedToTrain = false

local SDK_SALT = "oxKddFw0opc2ayAqm-WJCfzwdukeFwMFxPy6ClJWe_s"
local SDK_SIGNATURE = "YhAY9FjSeo2WC7oeyhhoGZupa8g"

-- Vô hiệu hóa SDK Native Popup ngay từ đầu
pcall(function()
    if CS and CS.MuInterface and CS.MuInterface.Instance then
        CS.MuInterface.Instance.Login = function(self, ...)
            print("[BotFarm] Bypassed SDK Login native popup.")
        end
        CS.MuInterface.Instance.LogoutAccount = function(self, ...)
            print("[BotFarm] Bypassed SDK Logout.")
        end
        if CS.MuInterface.Instance.HideView then
            CS.MuInterface.Instance:HideView()
        end
    end
end)

-- Helper kiểm tra GameObject nil an toàn
local function IsObjectNil(obj)
    if obj == nil then return true end
    local ok, res = pcall(function() return obj:Equals(nil) end)
    if ok and res then return true end
    return false
end

-- Helper lấy Font an toàn tuyệt đối
local function GetSafeFont()
    local font = nil
    pcall(function()
        font = CS.UnityEngine.Resources.GetBuiltinResource(typeof(CS.UnityEngine.Font), "Arial.ttf")
    end)
    if not font then
        pcall(function()
            local allTexts = CS.UnityEngine.Object.FindObjectsOfType(typeof(CS.UnityEngine.UI.Text))
            if allTexts and allTexts.Length > 0 then
                for i = 0, allTexts.Length - 1 do
                    if allTexts[i] and allTexts[i].font then
                        font = allTexts[i].font
                        break
                    end
                end
            end
        end)
    end
    return font
end

-- =========================================================================
-- 2. FOV & TỐC ĐỘ CHẠY (FOV = 65 MẶC ĐỊNH TOÀN GAME, SPEED = 2.0X CHUẨN KHÔNG NHÂN DỒN)
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
                    -- Luôn lấy tốc độ gốc chuẩn từ thuộc tính nhân vật (Chống nhân dồn lũy kế 2.0x * 2.0x...)
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
_G.ApplyFovAndSpeed = ApplyFovAndSpeed

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
-- 3. HOOK TỰ ĐỘNG NHẶT TỨC THÌ KHI MỞ RƯƠNG VÀNG (INSTANT BATCH LOOT HOOK)
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

                        if _G.PickupManager.ReqPickUpMapItems then
                            _G.PickupManager.ReqPickUpMapItems(_G.Mod_GoldenChestBatchIds)
                        elseif _G.networkRequest and _G.networkRequest.ReqPickUpMapItems then
                            _G.networkRequest.ReqPickUpMapItems(_G.Mod_GoldenChestBatchIds)
                        elseif _G.PickupManager.ReqPickUpMapItem then
                            _G.PickupManager.ReqPickUpMapItem(objId)
                        end
                    end
                end)
            end
        end
    end
end)

local function VacuumAllMapDropItems()
    pcall(function()
        local allIds = {}
        if _G.Mod_GoldenChestBatchIds then
            for _, id in ipairs(_G.Mod_GoldenChestBatchIds) do
                table.insert(allIds, id)
            end
        end
        if _G.DropItemManager and _G.DropItemManager.GetDropItemById then
            local _, val = debug.getupvalue(_G.DropItemManager.GetDropItemById, 1)
            if type(val) == "table" then
                for id, dItem in pairs(val) do
                    if id then table.insert(allIds, id) end
                end
            end
        end
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
_G.VacuumAllMapDropItems = VacuumAllMapDropItems

-- =========================================================================
-- 4. DỌN DẸP POPUP & LOGOUT HELPERS
-- =========================================================================
local function DismissAllLoginAndSdkViews()
    pcall(function()
        if _G.LoginData then
            _G.LoginData.equipmentList = nil
        end
        local loginUI = nil
        if _G.UIManager and _G.UIManager.GetUiByName then
            loginUI = _G.UIManager.GetUiByName("Login_LoginUI")
        end
        if loginUI then
            if loginUI.go_notice then loginUI.go_notice:SetActive(false) end
            if loginUI.go_privacyPolicy then loginUI.go_privacyPolicy:SetActive(false) end
            if loginUI.go_AgeNotice then loginUI.go_AgeNotice:SetActive(false) end
            if loginUI.go_LoginInput and _G.LoginData and not string.isNullOrEmpty(_G.LoginData.accessToken) then
                loginUI.go_LoginInput:SetActive(false)
            end
        end
        if _G.UIManager then
            if _G.UIID and _G.UIID.WaitingUI then _G.UIManager.Hide(_G.UIID.WaitingUI) end
            if _G.UIID and _G.UIID.PromptTipUI then _G.UIManager.Hide(_G.UIID.PromptTipUI) end
            if _G.UIID and _G.UIID.OnHookProfitUI then _G.UIManager.Hide(_G.UIID.OnHookProfitUI) end
            _G.UIManager.Hide("OnHook_ProfitUI")
            _G.UIManager.Hide("AutoPopUIManager")
            _G.UIManager.Hide("DailySignUI")
            _G.UIManager.Hide("Welfare_WelfareUI")
        end
        if _G.MuInterfaceLua and _G.MuInterfaceLua.Instance and _G.MuInterfaceLua.Instance.HideView then
            _G.MuInterfaceLua.Instance:HideView()
        end
        if CS and CS.MuInterface and CS.MuInterface.Instance and CS.MuInterface.Instance.HideView then
            CS.MuInterface.Instance:HideView()
        end
        if CS and CS.LauncherUI and CS.LauncherUI.Close then
            CS.LauncherUI.Close()
        end
    end)
end
_G.DismissAllLoginAndSdkViews = DismissAllLoginAndSdkViews

local function Bot_ForceLogout()
    DismissAllLoginAndSdkViews()
    pcall(function()
        if _G.NetManager and _G.NetManager.IsConnect and _G.NetManager.IsConnect() then
            _G.NetManager.Send(_G.UserMessage.ReqLogout, { reason = 5 })
        end
    end)
    pcall(function()
        if _G.gameMgr and _G.gameMgr.Logout then
            _G.gameMgr:Logout()
        end
    end)
    pcall(function()
        if _G.NetManager and _G.NetManager.Close then
            _G.NetManager.Close()
        end
    end)
    pcall(function()
        if _G.EventManager and _G.EventManager.Dispatch then
            _G.EventManager.Dispatch(_G.Event.GamePlay_Leave)
        end
    end)
    pcall(function()
        if _G.Scene and _G.Scene.EnterLogin then
            _G.Scene.EnterLogin()
        end
    end)
    pcall(function()
        if _G.LoginData then
            _G.LoginData.InGame = false
            _G.LoginData.roleId = 0
            _G.LoginData.accessToken = ""
            _G.LoginData.sign = ""
            _G.LoginData.equipmentList = nil
            _G.LoginData.roleList = {}
        end
    end)
    _G.Bot_HasFinishedChests = false
    _G.Bot_IsTeleportedToTrain = false
    _G.Mod_GoldenChestState = "OPEN"
end
_G.Bot_ForceLogout = Bot_ForceLogout

local function SwitchToNextRoleOrAccount()
    local totalRoles = _G.TotalRolesInCurrentAccount or 4
    if totalRoles < 1 then totalRoles = 4 end
    
    local nextRole = (_G.CurrentRoleIndex or 1) + 1
    if nextRole > totalRoles or nextRole > 4 then
        -- Đã xong toàn bộ nhân vật trong account hiện tại -> Chuyển sang account tiếp theo
        _G.CurrentRoleIndex = 1
        local nextAcc = (_G.CurrentAccountIndex or 1) + 1
        if nextAcc > #_G.BotAccounts then
            _G.CurrentAccountIndex = 1
            Bot_Log("HOÀN THÀNH TẤT CẢ TÀI KHOẢN! VÒNG LẶP VÔ TẬN: QUAY LẠI TÀI KHOẢN 1")
        else
            _G.CurrentAccountIndex = nextAcc
            Bot_Log(string.format("CHUYỂN SANG TÀI KHOẢN [%d/%d]", _G.CurrentAccountIndex, #_G.BotAccounts))
        end
    else
        _G.CurrentRoleIndex = nextRole
        Bot_Log(string.format("CHUYỂN SANG NHÂN VẬT [%d/%d] CỦA TÀI KHOẢN %d", _G.CurrentRoleIndex, totalRoles, _G.CurrentAccountIndex or 1))
    end
    
    Bot_ForceLogout()
end
_G.SwitchToNextRoleOrAccount = SwitchToNextRoleOrAccount

local function Bot_Log(msg)
    if not msg then return end
    _G.Bot_LastMsg = tostring(msg)
    print("[BotFarm] " .. _G.Bot_LastMsg)

    pcall(function()
        if _G.Bot_StatusTextComp and not IsObjectNil(_G.Bot_StatusTextComp) then
            _G.Bot_StatusTextComp.text = "[BOT]: " .. _G.Bot_LastMsg
        end
    end)
end
_G.Bot_Log = Bot_Log

-- =========================================================================
-- 5. CÁC HÀM MÃ HÓA & GỬI HTTP SDK AUTHENTICATION
-- =========================================================================
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

local function PerformDirectSdkLogin(username, password, callback)
    if _G.Bot_IsLoggingIn then return end
    _G.Bot_IsLoggingIn = true
    Bot_Log("Đang gửi yêu cầu đăng nhập SDK: " .. username .. "...")
    
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
    
    _G.Http.RequestHaveHandleArg("https://user.muvh.vn/vie/user_login", form, headers, function(text)
        if string.isNullOrEmpty(text) then
            _G.Bot_IsLoggingIn = false
            Bot_Log("LỖI: Máy chủ SDK không phản hồi!")
            if callback then callback(false) end
            return
        end
        
        local resp = json.decode(text)
        if resp and resp.ret == 0 and resp.data then
            Bot_Log("Xác thực SDK thành công -> Gửi Game Auth...")
            
            local sdkData = {
                userId = resp.data.user_id,
                name = resp.data.username,
                token = resp.data.access_token,
                time = resp.data.server_ts,
                gid = "1320",
                pid = "1320",
                ext = resp.data.login_verify_sign,
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
            
            _G.Http.RequestHaveArg(ckUrl, ckForm, function(ckText)
                _G.Bot_IsLoggingIn = false
                if string.isNullOrEmpty(ckText) then
                    Bot_Log("LỖI: Game Auth server không phản hồi!")
                    if callback then callback(false) end
                    return
                end
                
                local backData = json.decode(ckText)
                if not backData.errno then
                    Bot_Log("ĐĂNG NHẬP THÀNH CÔNG: " .. username .. "!")
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

                    pcall(function()
                        local loginUI = UIManager.GetUiByName("Login_LoginUI")
                        if loginUI then
                            DismissAllLoginAndSdkViews()
                            if loginUI.go_LoginInput then loginUI.go_LoginInput:SetActive(false) end
                            if loginUI.go_ConnectServer then loginUI.go_ConnectServer:SetActive(true) end
                            if loginUI.OnLoginSuccess then loginUI:OnLoginSuccess() end
                            if loginUI.SetState then loginUI:SetState(3) end
                        end
                    end)

                    if callback then callback(true) end
                else
                    Bot_Log("Game Auth thất bại: errno=" .. tostring(backData and backData.errno) .. " msg=" .. tostring(backData and backData.msg))
                    if callback then callback(false) end
                end
            end)
        else
            _G.Bot_IsLoggingIn = false
            Bot_Log("Lỗi SDK Login: " .. tostring(resp and resp.msg))
            if callback then callback(false) end
        end
    end)
end
_G.PerformDirectSdkLogin = PerformDirectSdkLogin

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

        if recycleCount > 0 and _G.networkRequest and _G.networkRequest.ReqItemRecycle then
            local RecycleWayType = _G.RecycleWayType and _G.RecycleWayType.Bag or 1
            pcall(function() _G.networkRequest.ReqItemRecycle(recycleMap, RecycleWayType) end)
            Bot_Log("Đã thu hồi " .. tostring(recycleCount) .. " món Trác Việt rác!")
        end
    end)
end

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
            Bot_Log("Đã tách " .. tostring(batchCount) .. " món Đồ Bộ & Trang Sức!")
        end
    end)
end

-- =========================================================================
-- CHUYỂN NHÂN VẬT (1->2->3->4) & TÀI KHOẢN (VÒNG LẶP VÔ TẬN)
-- =========================================================================
local function ForceLogoutToLogin()
    Bot_Log("--- THỰC HIỆN ĐĂNG XUẤT RA MÀN HÌNH LOGIN ---")
    DismissAllLoginAndSdkViews()
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
    _G.Bot_HasFinishedChests = false
    _G.Bot_IsTeleportedToTrain = false
    _G.Bot_OpenedChestBatches = 0
end

local function SwitchToNextRoleOrAccount()
    local totalRoles = _G.TotalRolesInCurrentAccount or 4
    if totalRoles < 1 then totalRoles = 4 end
    
    local curRole = _G.CurrentRoleIndex or 1
    local nextRole = curRole + 1

    Bot_Log(string.format(">>> HOÀN TẤT CHO NHÂN VẬT [%d/%d] (ACC %d/%d) <<<", 
        curRole, totalRoles, _G.CurrentAccountIndex or 1, #_G.BotAccounts))
    
    if nextRole > totalRoles or nextRole > 4 then
        -- Đã chạy hết toàn bộ nhân vật của tài khoản hiện tại -> Chuyển sang tài khoản tiếp theo
        _G.CurrentRoleIndex = 1
        local nextAcc = (_G.CurrentAccountIndex or 1) + 1
        if nextAcc > #_G.BotAccounts then
            Bot_Log(">>> HOÀN THÀNH TẤT CẢ TÀI KHOẢN! QUAY LẠI TÀI KHOẢN 1 <<<")
            _G.CurrentAccountIndex = 1
        else
            _G.CurrentAccountIndex = nextAcc
            Bot_Log(string.format(">>> CHUYỂN SANG TÀI KHOẢN TIẾP THEO [%d/%d] <<<", _G.CurrentAccountIndex, #_G.BotAccounts))
        end

        _G.Bot_HasFinishedChests = false
        _G.Bot_IsTeleportedToTrain = false
        _G.Bot_OpenedChestBatches = 0

        -- Chuyển tài khoản: Logout ra Login Scene và Login SDK tài khoản mới
        Bot_Log("-> Đang đăng xuất để đổi tài khoản mới...")
        Timer.Start(1.0, function()
            ForceLogoutToLogin()
        end)
    else
        -- Cùng tài khoản: Chuyển sang nhân vật tiếp theo (Role 2, Role 3, Role 4)
        _G.CurrentRoleIndex = nextRole
        _G.Bot_HasFinishedChests = false
        _G.Bot_IsTeleportedToTrain = false
        _G.Bot_OpenedChestBatches = 0

        Bot_Log(string.format(">>> CHUYỂN SANG NHÂN VẬT TIẾP THEO [%d/%d] CỦA TÀI KHOẢN %d <<<", 
            _G.CurrentRoleIndex, totalRoles, _G.CurrentAccountIndex or 1))

        -- Đổi nhân vật siêu tốc: Back2Choose Role (Không cần Login lại SDK!)
        Bot_Log("-> Đang gửi lệnh đổi nhân vật tức thì (Back2Choose)...")
        Timer.Start(1.0, function()
            DismissAllLoginAndSdkViews()
            pcall(function()
                if EventManager and EventManager.Dispatch and Event and Event.GamePlay_Back2Choose then
                    EventManager.Dispatch(Event.GamePlay_Back2Choose)
                elseif NetManager and NetManager.Send and UserMessage and UserMessage.ReqGetRoleList then
                    NetManager.Send(UserMessage.ReqGetRoleList)
                else
                    ForceLogoutToLogin()
                end
            end)
        end)
    end
end
_G.SwitchToNextRoleOrAccount = SwitchToNextRoleOrAccount

-- =========================================================================
-- 7. GIAO DIỆN NỔI (BANNER LOG, EXEC & BOT STATE BUTTON)
-- =========================================================================
local function EnsureModUI()
    pcall(function()
        if not IsObjectNil(_G.ModFarmCanvasGo) then
            if _G.Bot_UpdateUI then _G.Bot_UpdateUI() end
            return
        end

        local GameObject = CS.UnityEngine.GameObject
        local RectTransform = CS.UnityEngine.RectTransform
        local Canvas = CS.UnityEngine.Canvas
        local CanvasScaler = CS.UnityEngine.UI.CanvasScaler
        local GraphicRaycaster = CS.UnityEngine.UI.GraphicRaycaster
        local Vector2 = CS.UnityEngine.Vector2
        local Color = CS.UnityEngine.Color
        local Image = CS.UnityEngine.UI.Image
        local Text = CS.UnityEngine.UI.Text
        local Button = CS.UnityEngine.UI.Button
        local TextAnchor = CS.UnityEngine.TextAnchor
        local RenderMode = CS.UnityEngine.RenderMode

        local defaultFont = GetSafeFont()

        local modRoot = GameObject("MySuperFarmCanvas")
        _G.ModFarmCanvasGo = modRoot
        CS.UnityEngine.Object.DontDestroyOnLoad(modRoot)

        local canvas = modRoot:AddComponent(typeof(Canvas))
        canvas.renderMode = RenderMode.ScreenSpaceOverlay
        canvas.sortingOrder = 32767

        local scaler = modRoot:AddComponent(typeof(CanvasScaler))
        scaler.uiScaleMode = CS.UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
        scaler.referenceResolution = Vector2(1920, 1080)

        modRoot:AddComponent(typeof(GraphicRaycaster))

        local bannerGo = GameObject("BotStatusBanner")
        bannerGo.transform:SetParent(modRoot.transform, false)
        local bannerRt = bannerGo:AddComponent(typeof(RectTransform))
        bannerRt.anchorMin = Vector2(0.5, 1)
        bannerRt.anchorMax = Vector2(0.5, 1)
        bannerRt.pivot = Vector2(0.5, 1)
        bannerRt.anchoredPosition = Vector2(0, -10)
        bannerRt.sizeDelta = Vector2(1000, 50)

        local bannerImg = bannerGo:AddComponent(typeof(Image))
        bannerImg.color = Color(0, 0, 0, 0.75)

        local bannerTxtGo = GameObject("BotStatusText")
        bannerTxtGo.transform:SetParent(bannerGo.transform, false)
        local bannerTxtRt = bannerTxtGo:AddComponent(typeof(RectTransform))
        bannerTxtRt.anchorMin = Vector2(0, 0)
        bannerTxtRt.anchorMax = Vector2(1, 1)
        bannerTxtRt.sizeDelta = Vector2(-20, 0)
        local bannerTxt = bannerTxtGo:AddComponent(typeof(Text))
        bannerTxt.text = "[BOT]: Sẵn sàng (Bấm BOT [RUN] để bắt đầu)"
        bannerTxt.color = Color(1, 0.9, 0.2, 1)
        bannerTxt.fontSize = 20
        bannerTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then bannerTxt.font = defaultFont end
        _G.Bot_StatusTextComp = bannerTxt

        local execBtnGo = GameObject("FloatingExecBtn")
        execBtnGo.transform:SetParent(modRoot.transform, false)
        local execRt = execBtnGo:AddComponent(typeof(RectTransform))
        execRt.anchorMin = Vector2(0, 0)
        execRt.anchorMax = Vector2(0, 0)
        execRt.pivot = Vector2(0, 0)
        execRt.anchoredPosition = Vector2(10, 240)
        execRt.sizeDelta = Vector2(70, 60)

        local execImg = execBtnGo:AddComponent(typeof(Image))
        execImg.color = Color(0.8, 0.2, 0.2, 1.0)

        local execTxtGo = GameObject("ExecTxt")
        execTxtGo.transform:SetParent(execBtnGo.transform, false)
        local execTxtRt = execTxtGo:AddComponent(typeof(RectTransform))
        execTxtRt.anchorMin = Vector2(0, 0)
        execTxtRt.anchorMax = Vector2(1, 1)
        execTxtRt.sizeDelta = Vector2(0, 0)
        local execTxt = execTxtGo:AddComponent(typeof(Text))
        execTxt.text = "EXEC"
        execTxt.color = Color.white
        execTxt.fontSize = 16
        execTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then execTxt.font = defaultFont end

        local execBtnComp = execBtnGo:AddComponent(typeof(Button))
        execBtnComp.onClick:AddListener(function()
            pcall(function()
                local path = CS.UnityEngine.Application.persistentDataPath .. "/input.luac"
                if not CS.System.IO.File.Exists(path) then
                    path = "/storage/emulated/0/Android/data/com.vnyh.gp/files/input.luac"
                end
                if CS.System.IO.File.Exists(path) then
                    local bytes = CS.System.IO.File.ReadAllBytes(path)
                    local func, err = load(bytes)
                    if func then
                        local ok, res = pcall(func)
                        if ok then
                            Bot_Log("Thực thi input.luac thành công!")
                        else
                            Bot_Log("Lỗi script: " .. tostring(res))
                        end
                    else
                        Bot_Log("Lỗi load bytecode: " .. tostring(err))
                    end
                else
                    Bot_Log("Không tìm thấy input.luac!")
                end
            end)
        end)

        local botBtnGo = GameObject("FloatingBotStateBtn")
        botBtnGo.transform:SetParent(modRoot.transform, false)
        local botRt = botBtnGo:AddComponent(typeof(RectTransform))
        botRt.anchorMin = Vector2(0, 0)
        botRt.anchorMax = Vector2(0, 0)
        botRt.pivot = Vector2(0, 0)
        botRt.anchoredPosition = Vector2(10, 165)
        botRt.sizeDelta = Vector2(75, 60)

        local botImg = botBtnGo:AddComponent(typeof(Image))
        botImg.color = _G.Bot_Running and Color(0.18, 0.65, 0.18, 1.0) or Color(0.65, 0.2, 0.2, 1.0)

        local botTxtGo = GameObject("BotTxt")
        botTxtGo.transform:SetParent(botBtnGo.transform, false)
        local botTxtRt = botTxtGo:AddComponent(typeof(RectTransform))
        botTxtRt.anchorMin = Vector2(0, 0)
        botTxtRt.anchorMax = Vector2(1, 1)
        botTxtRt.sizeDelta = Vector2(0, 0)
        local botTxt = botTxtGo:AddComponent(typeof(Text))
        botTxt.text = _G.Bot_Running and "BOT\n[RUN]" or "BOT\n[PAUSE]"
        botTxt.color = Color.white
        botTxt.fontSize = 14
        botTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then botTxt.font = defaultFont end

        _G.Bot_UpdateUI = function()
            if not IsObjectNil(botImg) and not IsObjectNil(botTxt) then
                if _G.Bot_Running then
                    botImg.color = Color(0.18, 0.65, 0.18, 1.0)
                    botTxt.text = "BOT\n[RUN]"
                else
                    botImg.color = Color(0.65, 0.2, 0.2, 1.0)
                    botTxt.text = "BOT\n[PAUSE]"
                end
            end
        end

        local botBtnComp = botBtnGo:AddComponent(typeof(Button))
        botBtnComp.onClick:AddListener(function()
            _G.Bot_Running = not _G.Bot_Running
            if _G.Bot_UpdateUI then _G.Bot_UpdateUI() end
            if _G.Bot_Running then
                Bot_Log("BẬT (RUNNING) -> Bắt đầu tiến trình tự động!")
            else
                Bot_Log("TẮT (PAUSED) -> Đã tạm dừng tiến trình!")
            end
        end)
    end)
end
_G.EnsureModUI = EnsureModUI

-- =========================================================================
-- 8. STATE MACHINE: TỰ ĐỘNG ĐĂNG NHẬP, MỞ RƯƠNG 20/20 & FARM (FULL TICK LOOP)
-- =========================================================================
local lastStepActionTime = 0

local function Bot_Tick()
    if not _G.Bot_Running or _G.Mod_IsInputScriptRunning then return end
    EnsureModUI()

    -- 1. Nếu đã trong game thế giới
    if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.id then
        local hero = _G.RoleManager.me
        DismissAllLoginAndSdkViews()
        ApplyFovAndSpeed()

        if not _G.Bot_Running then return end

        local nowTime = (CS.UnityEngine.Time and CS.UnityEngine.Time.realtimeSinceStartup) or os.clock()

        -- A. Tiến trình Mở Rương Vàng (Máy trạng thái 5 pha 20/20)
        if not _G.Bot_HasFinishedChests then
            _G.Mod_AutoOpenGoldenChest_Enabled = true

            -- 1. Dọn dẹp túi ban đầu trước khi mở đợt đầu tiên
            if _G.Mod_GoldenChestState == "INIT_CLEAN" then
                Bot_Log("Dọn sạch túi đồ rác trước khi mở rương...")
                PerformRecycleExcellence()
                PerformSmeltEquipments()
                VacuumAllMapDropItems()
                _G.Mod_GoldenChestWaitTime = nowTime + 0.8
                _G.Mod_GoldenChestState = "WAIT_INIT"

            elseif _G.Mod_GoldenChestState == "WAIT_INIT" then
                VacuumAllMapDropItems()
                if nowTime >= (_G.Mod_GoldenChestWaitTime or 0) then
                    _G.Mod_GoldenChestState = "OPEN"
                end

            -- 2. Tìm rương vàng trong túi và mở tối đa 20 cái
            elseif _G.Mod_GoldenChestState == "OPEN" then
                -- Kiểm tra giới hạn số lần mở đợt trong bản test (theo config của nhân vật)
                local activeCfg = GetActiveConfig()
                local maxBatches = activeCfg.maxChestBatches or _G.BotConfig.maxChestBatches or 3
                if (_G.Bot_OpenedChestBatches or 0) >= maxBatches then
                    _G.Bot_HasFinishedChests = true
                    _G.Mod_AutoOpenGoldenChest_Enabled = false
                    Bot_Log(string.format("ĐÃ HOÀN THÀNH %d ĐỢT MỞ RƯƠNG VÀNG! Dừng mở để giữ rương test tiếp...", _G.Bot_OpenedChestBatches or 0))
                    VacuumAllMapDropItems()
                    PerformRecycleExcellence()
                    PerformSmeltEquipments()
                    _G.Mod_GoldenChestState = "OPEN"
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

                if not targetChestId or targetChestCount == 0 then
                    _G.Bot_HasFinishedChests = true
                    _G.Mod_AutoOpenGoldenChest_Enabled = false
                    Bot_Log("ĐÃ MỞ HẾT SẠCH RƯƠNG VÀNG! Chuẩn bị dịch chuyển...")
                    VacuumAllMapDropItems()
                    PerformRecycleExcellence()
                    PerformSmeltEquipments()
                    _G.Mod_GoldenChestState = "OPEN"
                    return
                end

                -- Mở tối đa 20 rương
                local openBatch = math.min(20, targetChestCount)
                _G.Bot_OpenedChestBatches = (_G.Bot_OpenedChestBatches or 0) + 1
                Bot_Log(string.format("[ĐỢT %d/%d] Mở %d Rương Vàng (Còn: %d)...", _G.Bot_OpenedChestBatches, maxBatches, openBatch, targetChestCount - openBatch))
                _G.Mod_GoldenChestBatchIds = {}
                if _G.networkRequest and _G.networkRequest.ReqUseItem then
                    _G.networkRequest.ReqUseItem(openBatch, targetChestId)
                end

                _G.Mod_GoldenChestWaitTime = nowTime + 1.2
                _G.Mod_GoldenChestState = "WAIT_DROP"

            -- 3. Chờ 1.2s cho 20 món đồ rớt ra và liên tục hút sạch vào túi
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
                _G.Mod_GoldenChestWaitTime = nowTime + 0.8
                _G.Mod_GoldenChestState = "WAIT_SYNC"

            -- 5. Chờ 0.8s cho túi đồ đồng bộ dọn chỗ trống rồi mới mở tiếp 20 rương đợt sau
            elseif _G.Mod_GoldenChestState == "WAIT_SYNC" then
                VacuumAllMapDropItems()
                if nowTime >= (_G.Mod_GoldenChestWaitTime or 0) then
                    _G.Mod_GoldenChestState = "OPEN"
                end
            end
            return
        end

        -- B. Dịch chuyển tới Map Train
        if _G.Bot_HasFinishedChests and not _G.Bot_IsTeleportedToTrain then
            local nowSec = os.time()
            if nowSec - lastStepActionTime < 1 then return end

            local activeCfg = GetActiveConfig()
            local targetMap = activeCfg.targetMapId or 101094
            local coordStr = activeCfg.trainCoord or "172#156"
            local parts = {}
            for p in string.gmatch(coordStr, "[^#]+") do table.insert(parts, p) end
            local tx, ty = tonumber(parts[1]) or 172, tonumber(parts[2]) or 156

            local curMap = _G.SceneData and _G.SceneData.mapId or 0
            local meX, meY = 0, 0
            if hero.cellPos then
                meX, meY = hero.cellPos.x, hero.cellPos.y
            elseif hero.serverCoord then
                meX, meY = hero.serverCoord.x, hero.serverCoord.y
            end

            local dx = meX - tx
            local dy = meY - ty
            local dist = math.sqrt(dx * dx + dy * dy)

            if curMap == targetMap and dist <= 5 then
                _G.Bot_IsTeleportedToTrain = true
                Bot_Log("ĐÃ ĐẾN VỊ TRÍ FARM (" .. meX .. ", " .. meY .. ")!")
                pcall(function()
                    if hero.StopMove then hero:StopMove() end
                    if hero.SetAutoFight then
                        hero:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
                    end
                    if hero.meAutoFight and hero.meAutoFight.SetAutoFightHookStart then
                        hero.meAutoFight:SetAutoFightHookStart(true)
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
                lastStepActionTime = nowSec + 3
                Bot_Log("-> Đang chờ 3.0s để ổn định bãi farm trước khi chuyển nhân vật/tài khoản...")
                Timer.Start(3.0, function()
                    SwitchToNextRoleOrAccount()
                end)
                return
            else
                Bot_Log("Đang dịch chuyển tới Map " .. targetMap .. " (" .. tx .. ", " .. ty .. ")...")
                lastStepActionTime = nowSec
                if _G.NetManager and _G.MapMessage and _G.MapMessage.ReqCallFlag then
                    _G.NetManager.Send(_G.MapMessage.ReqCallFlag, {
                        mapId = targetMap,
                        line = 1,
                        x = tx,
                        y = ty
                    })
                end
                return
            end
        end

        return
    end

    -- 2. Nếu Bot chưa bật thì không làm gì
    if not _G.Bot_Running then return end

    local nowSec = os.time()
    if nowSec - lastStepActionTime < 1 then return end

    -- ---------------------------------------------------------------------
    -- Xử lý màn hình Login & Server (Login_LoginUI)
    -- ---------------------------------------------------------------------
    local isLoginUIVisible = false
    local loginUI = nil
    if _G.UIManager then
        if _G.UIManager.IsVisible and _G.UIManager.IsVisible("Login_LoginUI") then
            isLoginUIVisible = true
        end
        if _G.UIManager.GetUiByName then
            loginUI = _G.UIManager.GetUiByName("Login_LoginUI")
        end
    end

    if isLoginUIVisible and loginUI then
        DismissAllLoginAndSdkViews()

        local curAcc = GetCurrentAccount()
        local panelState = _G.LoginData and _G.LoginData.panelState or 0
        local hasToken = _G.LoginData and not string.isNullOrEmpty(_G.LoginData.accessToken)

        if not hasToken or panelState == 1 then
            if not _G.Bot_IsLoggingIn then
                lastStepActionTime = nowSec
                PerformDirectSdkLogin(curAcc.account, curAcc.password)
            end
            return
        end

        if panelState == 2 then
            lastStepActionTime = nowSec
            if loginUI.btn_closeSelectServerOnClick then
                pcall(function() loginUI:btn_closeSelectServerOnClick() end)
            end
            return
        end

        if panelState == 3 or (loginUI.go_ConnectServer and loginUI.go_ConnectServer.gameObject and loginUI.go_ConnectServer.gameObject.activeSelf) then
            local targetSid = tonumber(curAcc.targetServer or 400)
            local isTargetServer = false
            if _G.LoginData and _G.LoginData.server then
                local curSid = tonumber(_G.LoginData.server[5])
                local curSName = tostring(_G.LoginData.server[1] or "")
                if curSid == targetSid or string.find(curSName, tostring(targetSid)) then
                    isTargetServer = true
                end
            end

            if not isTargetServer then
                local targetServerData = nil
                local allLists = {
                    (_G.LoginData and _G.LoginData.serverList) or {},
                    (_G.LoginData and _G.LoginData.AndroidServerList) or {},
                    (_G.LoginData and _G.LoginData.data and _G.LoginData.data.server_lists) or {}
                }
                for _, list in ipairs(allLists) do
                    for _, s in pairs(list) do
                        if s and (tonumber(s[5]) == targetSid or (s[1] and string.find(tostring(s[1]), tostring(targetSid)))) then
                            targetServerData = s
                            break
                        end
                    end
                    if targetServerData then break end
                end

                if targetServerData then
                    if _G.LoginData.SetServer then _G.LoginData.SetServer(targetServerData) end
                    _G.LoginData.equipmentList = nil
                    if loginUI.lab_connectServerName and loginUI.lab_connectServerName.SetText then
                        loginUI.lab_connectServerName:SetText(targetServerData[1] or ("Server " .. targetSid))
                    end
                    Bot_Log("Đã chọn Server mục tiêu: " .. tostring(targetServerData[1] or targetSid))
                    isTargetServer = true
                else
                    Bot_Log("Đang tải danh sách Server để tìm Server " .. targetSid .. "...")
                    lastStepActionTime = nowSec
                    if loginUI.GetServerInfo then
                        pcall(function() loginUI:GetServerInfo(0) end)
                    end
                    return
                end
            end

            if isTargetServer then
                Bot_Log("Đang bấm Bắt Đầu kết nối vào Server " .. tostring(targetSid) .. "...")
                lastStepActionTime = nowSec
                DismissAllLoginAndSdkViews()
                _G.LoginData.equipmentList = nil
                if loginUI.btn_connectOnClick then
                    pcall(function() loginUI:btn_connectOnClick() end)
                end
            end
            return
        end
    end

    -- ---------------------------------------------------------------------
    -- Xử lý màn hình Chọn nhân vật (Login_LoginRoleUI)
    -- ---------------------------------------------------------------------
    local isRoleUIVisible = false
    local roleUI = nil
    if _G.UIManager then
        if _G.UIManager.IsVisible and _G.UIManager.IsVisible("Login_LoginRoleUI") then
            isRoleUIVisible = true
        end
        if _G.UIManager.GetUiByName then
            roleUI = _G.UIManager.GetUiByName("Login_LoginRoleUI")
        end
    end

    if isRoleUIVisible and roleUI then
        DismissAllLoginAndSdkViews()
        if roleUI.loadingPanelIsLoaded then
            if not roleUI.isNoRole and roleUI.RoleModelInfoTbl and #roleUI.RoleModelInfoTbl > 0 then
                local roles = roleUI.RoleModelInfoTbl
                _G.TotalRolesInCurrentAccount = #roles
                local targetIdx = _G.CurrentRoleIndex or 1
                if targetIdx > #roles then
                    Bot_Log(string.format("Tài khoản có %d nhân vật (Target: %d) -> Chuyển sang tài khoản tiếp theo!", #roles, targetIdx))
                    _G.CurrentRoleIndex = 4
                    SwitchToNextRoleOrAccount()
                    return
                end
                local chosenRole = roles[targetIdx]
                roleUI.curRole = chosenRole
                local info = (chosenRole and chosenRole.data) or chosenRole or {}
                local roleId = tonumber(info.id or info.roleId or (chosenRole and chosenRole.id))
                local roleName = tostring(info.name or info.roleName or ("Role_" .. targetIdx))
                local roleLevel = tonumber(info.level or 1)
                local createTime = tonumber(info.createTime or 1)
                
                _G.ActiveRoleIndex = targetIdx
                _G.ActiveRoleConfig = GetCurrentRoleConfig(targetIdx, roleName)

                Bot_Log(string.format("Đang chọn nhân vật [%d/%d]: %s (ID: %s | Cấp: %s) để vào game...", 
                    targetIdx, #roles, tostring(roleName), tostring(roleId), tostring(roleLevel)))
                lastStepActionTime = nowSec

                -- Cập nhật LoginData
                LoginData.roleId = roleId
                LoginData.roleName = roleName
                LoginData.roleLevel = roleLevel
                LoginData.createTime = createTime
                LoginData.InGame = false

                -- Di chuyển hiệu ứng chọn
                pcall(function()
                    if roleUI.ShowSelectEffect then roleUI:ShowSelectEffect() end
                    if roleUI.ShowDeleteBtn then roleUI:ShowDeleteBtn() end
                    if roleUI.ShowRoleState then roleUI:ShowRoleState() end
                end)

                -- Gửi gói tin chọn nhân vật
                if _G.networkRequest and _G.networkRequest.ReqChooseRole then
                    _G.networkRequest.ReqChooseRole(roleId)
                elseif NetManager and NetManager.Send and UserMessage and UserMessage.ReqChooseRole then
                    NetManager.Send(UserMessage.ReqChooseRole, { roleId = roleId })
                end
            elseif roleUI.isNoRole then
                Bot_Log("Chưa có nhân vật -> Sang tài khoản tiếp theo...")
                _G.CurrentRoleIndex = 4
                SwitchToNextRoleOrAccount()
            end
        end
        return
    end

    -- ---------------------------------------------------------------------
    -- Xử lý màn hình Tạo nhân vật (Login_LoginCreateRoleUI)
    -- ---------------------------------------------------------------------
    local isCreateUIVisible = false
    local createUI = nil
    if _G.UIManager then
        if _G.UIManager.IsVisible and _G.UIManager.IsVisible("Login_LoginCreateRoleUI") then
            isCreateUIVisible = true
        end
        if _G.UIManager.GetUiByName then
            createUI = _G.UIManager.GetUiByName("Login_LoginCreateRoleUI")
        end
    end
    if isCreateUIVisible and createUI then
        DismissAllLoginAndSdkViews()
        Bot_Log("Đang bấm tạo nhân vật và vào game...")
        lastStepActionTime = nowSec
        if createUI.Btn_EnterOnClick then
            pcall(function() createUI:Btn_EnterOnClick() end)
        end
        return
    end
end
_G.Bot_Tick = Bot_Tick

-- =========================================================================
-- 9. KHỞI TẠO & HOOK
-- =========================================================================
function EmmyluaDebug.InitEmmyluaDebug(obj)
    _G.Mod_IsAdmin = true
    _G.Mod_IsDebug = true

    pcall(function()
        local Application = CS.UnityEngine.Application
        local Directory = CS.System.IO.Directory
        local File = CS.System.IO.File

        local function DeleteDummyDir(path)
            if Directory.Exists(path) then Directory.Delete(path, true) end
            if File.Exists(path) then File.Delete(path) end
        end
        local rootDir = Application.persistentDataPath
        DeleteDummyDir(rootDir .. "/lua.mu2")
        DeleteDummyDir(rootDir .. "/bundles.txt")
        DeleteDummyDir(rootDir .. "/Bundles/lua.mu2")
        DeleteDummyDir(rootDir .. "/Bundles/bundles.txt")
        DeleteDummyDir(rootDir .. "/bundles/lua.mu2")
        DeleteDummyDir(rootDir .. "/bundles/bundles.txt")
    end)

    EnsureModUI()
    DismissAllLoginAndSdkViews()

    if _G.EventManager and _G.EventManager.Regist and _G.Event and _G.Event.Game_SceneLoaded then
        pcall(function()
            _G.EventManager.Regist(_G.Event.Game_SceneLoaded, function()
                EnsureModUI()
                if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.id then
                    DismissAllLoginAndSdkViews()
                    ApplyFovAndSpeed()
                end
            end)
        end)
    end
end

pcall(function()
    if _G.Timer and _G.Timer.StartLoopForever then
        _G.Timer.StartLoopForever(0.5, function()
            pcall(Bot_Tick)
        end)
    elseif _G.Timer and _G.Timer.StartLoop then
        _G.Timer.StartLoop(0.5, -1, function()
            pcall(Bot_Tick)
        end)
    end
end)

return EmmyluaDebug

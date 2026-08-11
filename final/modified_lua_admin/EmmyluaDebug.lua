-- EmmyluaDebug.lua
-- Bắt buộc phải có để Main.lua gọi không bị lỗi
EmmyluaDebug = {}

--------------------------------------------------------------------------------
-- ACTIVE SYSTEM CORE (Remote Config & Active Validation)
--------------------------------------------------------------------------------
_G.Mod_IsActive = false
_G.Mod_ActiveConfig = nil
_G.Mod_HasFetchedConfig = false
_G.Mod_RawConfigPayload = ""
_G.Mod_ActiveStatusMsg = "Bản Mod chưa được kích hoạt!"

_G.Mod_Config_FOV_Min = 30
_G.Mod_Config_FOV_Max = 50
_G.Mod_Config_BossRefresh_Min = 3
_G.Mod_Config_BossRefresh_Max = 60
_G.Mod_Config_MaxMoveSpeed = 1.5
_G.Mod_Config_MaxAttackSpeed = 2.0
_G.Mod_Config_MaxMonsterRange = 12
_G.Mod_Config_MaxPickupCount = 5
_G.Mod_Config_PickupDelay_Min = 100
_G.Mod_Config_PickupDelay_Max = 500
_G.Mod_Config_ActiveBasicTab = true
_G.Mod_Config_ActiveAdvancedTab = true
_G.Mod_Config_ActiveAutoFarmTab = true
_G.Mod_Config_CurrentRebirth = 0
_G.Mod_Config_AdminTelegram = {"legend92vn"}

local SECRET_SALT = "MUVH_SECRET_SALT_XOAI"

local function Mod_CalculateMD5(str)
    if not str or str == "" then return "" end
    local ok1, pcRes = pcall(function()
        if CS.PCUtility and CS.PCUtility.Md5 then
            return string.lower(tostring(CS.PCUtility.Md5(str)))
        end
    end)
    if ok1 and pcRes and pcRes ~= "" and pcRes ~= "nil" then return pcRes end

    local ok2, res = pcall(function()
        local md5 = CS.System.Security.Cryptography.MD5.Create()
        local bytes = CS.System.Text.Encoding.UTF8:GetBytes(str)
        local hash = md5:ComputeHash(bytes)
        local hexTbl = {}
        for i = 0, hash.Length - 1 do
            table.insert(hexTbl, string.format("%02x", hash[i]))
        end
        return table.concat(hexTbl)
    end)
    if ok2 and res then return res end
    return ""
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Mod_Base64Decode(b64Str)
    if not b64Str or b64Str == "" then return nil end
    local ok1, res1 = pcall(function()
        local bytes = CS.System.Convert.FromBase64String(b64Str)
        return CS.System.Text.Encoding.UTF8:GetString(bytes)
    end)
    if ok1 and res1 and res1 ~= "" and res1 ~= "nil" then return res1 end

    local ok2, res2 = pcall(function()
        local data = string.gsub(b64Str, '[^'..b64chars..'=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b64chars:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end))
    end)
    if ok2 and res2 then return res2 end
    return nil
end

local function Mod_ParseJSON(str)
    if not str or str == "" then return nil end
    local function parseValue(valStr)
        valStr = string.gsub(valStr, "^%s*(.-)%s*$", "%1")
        if valStr == "true" then return true end
        if valStr == "false" then return false end
        if valStr == "null" then return nil end
        if string.sub(valStr, 1, 1) == '"' and string.sub(valStr, -1) == '"' then
            return string.sub(valStr, 2, -2)
        end
        local num = tonumber(valStr)
        if num then return num end
        return valStr
    end
    local result = {}
    for k, v in string.gmatch(str, '"([^"]+)":%s*([^,{}%]]+)') do
        result[k] = parseValue(v)
    end
    local arrKey, arrBody = string.match(str, '"([^"]+)":%s*%[([^%]]+)%]')
    if arrKey and arrBody then
        local arr = {}
        for item in string.gmatch(arrBody, '"([^"]+)"') do
            table.insert(arr, item)
        end
        result[arrKey] = arr
    end
    return result
end

local function Mod_GetDeviceSerialMD5()
    local rawSerial = ""
    pcall(function()
        rawSerial = CS.UnityEngine.SystemInfo.deviceUniqueIdentifier
    end)
    if not rawSerial or rawSerial == "" then rawSerial = "UNKNOWN_DEVICE_ID" end
    return Mod_CalculateMD5(rawSerial)
end

local function Mod_GetCharacterUID()
    local uid = ""
    pcall(function()
        if _G.LoginData and _G.LoginData.sdk_pid and tostring(_G.LoginData.sdk_pid) ~= "" then
            uid = tostring(_G.LoginData.sdk_pid)
        end
        if uid == "" and _G.LoginData and _G.LoginData.account and tostring(_G.LoginData.account) ~= "" then
            uid = tostring(_G.LoginData.account)
        end
        if uid == "" and _G.RoleManager and _G.RoleManager.me then
            if _G.RoleManager.me.roleId then uid = tostring(_G.RoleManager.me.roleId) end
            if uid == "" and _G.RoleManager.me.id then uid = tostring(_G.RoleManager.me.id) end
        end
        if uid == "" and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.id then
            uid = tostring(_G.ViewData.meData.id)
        end
    end)
    return uid
end

local function Mod_DecryptPayload(payloadB64)
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 4.1] Giai ma Base64 Envelope, Do dai = " .. tostring(#payloadB64)) end
    if not payloadB64 or payloadB64 == "" then return nil, "Payload rỗng" end
    local decoded = Mod_Base64Decode(payloadB64)
    if not decoded then
        if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI] Mod_Base64Decode giai ma thoi ban Base64 that bai!") end
        return nil, "Không thể giải mã Base64"
    end
    local jsonStr, signature = string.match(decoded, "^(.*)|([a-fA-F0-9]+)$")
    if not jsonStr or not signature then
        if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI] Cau truc Envelope khong chua ky tu '|' va MD5 signature!") end
        return nil, "Cấu trúc Payload không hợp lệ"
    end
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 4.2] Tách JSON String len = " .. tostring(#jsonStr) .. ", Signature = " .. tostring(signature)) end
    local expectedSig = Mod_CalculateMD5(jsonStr .. SECRET_SALT)
    if string.lower(expectedSig) ~= string.lower(signature) then
        if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI CHU KY] Expected MD5=" .. tostring(expectedSig) .. " != Server Signature=" .. tostring(signature)) end
        return nil, "Chữ ký MD5 không hợp lệ!"
    end
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 4.3] Chu ky MD5 Salt TRUNG KHOP 100%! Dang parse Config JSON...") end
    local configObj = Mod_ParseJSON(jsonStr)
    if not configObj then return nil, "Không thể đọc dữ liệu JSON" end
    return configObj, nil
end

local API_BASE_URL = "http://g3events.asia/api/v1/config"

local function Mod_ValidateConfig(config)
    if not config then return false, "Chưa có cấu hình kích hoạt!" end
    local currentTime = os.time()
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [VALIDATE 1] Kiem tra expire_time: config=" .. tostring(config.expire_time) .. ", os.time()=" .. tostring(currentTime)) end
    if config.expire_time and currentTime > tonumber(config.expire_time) then
        if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI HET HAN] Tai khoan / Cau hinh da het han su dung!") end
        return false, "Tài khoản / Cấu hình đã hết hạn sử dụng!"
    end
    local currentSerialMD5 = Mod_GetDeviceSerialMD5()
    local cfgSN = config.device_sn_hash or config.serial_number
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [VALIDATE 2] Kiem tra Device Serial: config=" .. tostring(cfgSN) .. ", current=" .. tostring(currentSerialMD5)) end
    if cfgSN and tostring(cfgSN) ~= "" then
        local cfgSNStr = tostring(cfgSN)
        local cfgSNMD5 = Mod_CalculateMD5(cfgSNStr)
        if cfgSNStr ~= currentSerialMD5 and cfgSNMD5 ~= currentSerialMD5 then
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI SERIAL] Device Serial mismatch!") end
            return false, "Mã thiết bị (Serial MD5) không trùng khớp!"
        end
    end
    local cfgUID = config.character_uid or config.uid
    local currentUID = Mod_GetCharacterUID()
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [VALIDATE 3] Kiem tra Character UID: config=" .. tostring(cfgUID) .. ", current=" .. tostring(currentUID)) end
    if cfgUID and tostring(cfgUID) ~= "" then
        if currentUID == "" then
            return false, "Vui lòng đăng nhập nhân vật trong game để xác thực UID!"
        end
        if tostring(cfgUID) ~= currentUID then
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] [LOI UID] Character UID mismatch!") end
            return false, "Mã nhân vật (UID) không trùng khớp!"
        end
    end
    if _G.WriteLog then _G.WriteLog("[ActiveCheck] [VALIDATE SUCCESS] Tat ca thong so hop le 100%!") end
    return true, "OK"
end

local function Mod_FormatExpireDate(ts)
    if not ts then return "Không giới hạn" end
    local num = tonumber(ts)
    if not num or num <= 0 then return "Không giới hạn" end
    local ok, res = pcall(function()
        return os.date("%d/%m/%Y %H:%M", num)
    end)
    if ok and res then return res end
    return tostring(ts)
end

local function Mod_ValidateConfig(config)
    if not config then return false, "Config rỗng!" end
    if config.expire_time then
        local expNum = tonumber(config.expire_time)
        if expNum and expNum > 0 then
            local now = os.time()
            if now > expNum then
                return false, "Bản quyền đã hết hạn!"
            end
        end
    end
    return true, "OK"
end

local function SetCameraFOV(fov)
    if not fov then return end
    local maxFov = _G.Mod_Config_FOV_Max or 50
    local minFov = _G.Mod_Config_FOV_Min or 35
    fov = math.max(minFov, math.min(maxFov, fov))
    _G.currentFOV = fov
    _G.SavedFOV = fov
    pcall(function()
        local cam = CS.UnityEngine.Camera.main
        if cam then
            cam.fieldOfView = fov
        end
        CS.UnityEngine.PlayerPrefs.SetFloat("Mod_FOV", fov)
        CS.UnityEngine.PlayerPrefs.Save()
    end)
end
_G.SetCameraFOV = SetCameraFOV

_G.Mod_ResetSavedModConfigs = function()
    _G.Mod_AutoFarmBoss_Config = {}
    _G.Mod_SmeltConfig = {}
    _G.Mod_AutoFarmBoss_Target = nil
    pcall(function()
        local modKeys = {
            "Mod_AutoPick_Limit", "Mod_FOV", "Mod_AutoRefresh", "Mod_RefreshInterval",
            "Mod_ShowKundunHP", "Mod_AutoGuildPK_Enabled", "Mod_LockTarget_Enabled", "Mod_LockTarget_Name",
            "ModAutoBossConfigTab", "Mod_AutoFarmBoss_EnterHiddenMap_Diamond"
        }
        for _, k in ipairs(modKeys) do
            CS.UnityEngine.PlayerPrefs.DeleteKey(k)
        end
        CS.UnityEngine.PlayerPrefs.Save()
    end)
    if _G.WriteLog then _G.WriteLog("[Mod] Reset complete Mod_AutoFarmBoss_Config, Mod_SmeltConfig & safe Mod keys!") end
end

local function Mod_ApplyConfig(config)
    _G.Mod_ActiveConfig = config
    _G.Mod_IsActive = true
    if config.fov_min then _G.Mod_Config_FOV_Min = tonumber(config.fov_min) end
    if config.fov_max then _G.Mod_Config_FOV_Max = tonumber(config.fov_max) end
    if config.boss_refresh_min then _G.Mod_Config_BossRefresh_Min = tonumber(config.boss_refresh_min) end
    if config.boss_refresh_max then _G.Mod_Config_BossRefresh_Max = tonumber(config.boss_refresh_max) end
    if config.max_move_speed then _G.Mod_Config_MaxMoveSpeed = tonumber(config.max_move_speed) end
    if config.max_attack_speed then _G.Mod_Config_MaxAttackSpeed = tonumber(config.max_attack_speed) end
    if config.max_monster_range then _G.Mod_Config_MaxMonsterRange = tonumber(config.max_monster_range) end
    if config.max_pickup_count then _G.Mod_Config_MaxPickupCount = tonumber(config.max_pickup_count) end
    if config.pickup_delay_min then _G.Mod_Config_PickupDelay_Min = tonumber(config.pickup_delay_min) end
    if config.pickup_delay_max then _G.Mod_Config_PickupDelay_Max = tonumber(config.pickup_delay_max) end
    
    if config.active_basic_tab ~= nil then _G.Mod_Config_ActiveBasicTab = config.active_basic_tab
    elseif config.active_tab_basic ~= nil then _G.Mod_Config_ActiveBasicTab = config.active_tab_basic end
    
    if config.active_advanced_tab ~= nil then _G.Mod_Config_ActiveAdvancedTab = config.active_advanced_tab
    elseif config.active_tab_advanced ~= nil then _G.Mod_Config_ActiveAdvancedTab = config.active_tab_advanced end
    
    if config.active_autofarm_tab ~= nil then _G.Mod_Config_ActiveAutoFarmTab = config.active_autofarm_tab
    elseif config.active_tab_autofarm ~= nil then _G.Mod_Config_ActiveAutoFarmTab = config.active_tab_autofarm end

    _G.Mod_AutoFarmBoss_Config = {}
    _G.Mod_SmeltConfig = {}
    _G.Mod_AutoFarmBoss_Target = nil

    if config.character_reincarnation then
        local reb = tonumber(config.character_reincarnation)
        if reb and reb >= 3 and reb <= 12 then
            _G.Mod_Config_CurrentRebirth = reb
            _G.ModBossTab = "C" .. tostring(reb)
            _G.ModAutoBossConfigTab = "C" .. tostring(reb)
        end
    end

    if _G.RunSpeedMultiplier and _G.Mod_Config_MaxMoveSpeed then
        _G.RunSpeedMultiplier = math.min(_G.RunSpeedMultiplier, _G.Mod_Config_MaxMoveSpeed)
    end
    if _G.AtkSpeedMultiplier and _G.Mod_Config_MaxAttackSpeed then
        _G.AtkSpeedMultiplier = math.min(_G.AtkSpeedMultiplier, _G.Mod_Config_MaxAttackSpeed)
    end
    if _G.Mod_CustomAttackRange and _G.Mod_Config_MaxMonsterRange then
        _G.Mod_CustomAttackRange = math.min(_G.Mod_CustomAttackRange, _G.Mod_Config_MaxMonsterRange)
    end
    if _G.AutoPick_Limit and _G.Mod_Config_MaxPickupCount then
        _G.AutoPick_Limit = math.min(_G.AutoPick_Limit, _G.Mod_Config_MaxPickupCount)
    end

    -- Clamping current FOV to new remote config boundaries
    local maxFov = _G.Mod_Config_FOV_Max or 50
    local minFov = _G.Mod_Config_FOV_Min or 35
    _G.currentFOV = _G.currentFOV or maxFov
    if _G.currentFOV > maxFov then _G.currentFOV = maxFov end
    if _G.currentFOV < minFov then _G.currentFOV = minFov end
    if _G.fovValTxt and not _G.fovValTxt:Equals(nil) then
        _G.fovValTxt.text = "FOV: " .. tostring(_G.currentFOV)
    end
    if _G.SetCameraFOV then _G.SetCameraFOV(_G.currentFOV) end
    if _G.RefreshMainTabs then _G.RefreshMainTabs() end
    if _G.ParseBossData then pcall(_G.ParseBossData) end
    if _G.UpdateBossWatchUIText then pcall(_G.UpdateBossWatchUIText) end
    if _G.ModUpdateKundunUI then pcall(_G.ModUpdateKundunUI) end
    if _G.ModRefreshAutoBossConfigUI then pcall(_G.ModRefreshAutoBossConfigUI) end

    local expireStr = Mod_FormatExpireDate(config.expire_time)
    _G.Mod_ActiveStatusMsg = "Đã kích hoạt thành công! Hạn dùng: " .. expireStr .. " | FOV Max: " .. tostring(_G.Mod_Config_FOV_Max) .. " | Tốc đánh: " .. tostring(_G.Mod_Config_MaxAttackSpeed)

    if _G.WriteLog then
        _G.WriteLog("[ActiveCheck] GIAI MA THANH CONG! Hạn dùng: " .. expireStr .. " | FOV: " .. tostring(_G.Mod_Config_FOV_Min) .. "-" .. tostring(_G.Mod_Config_FOV_Max) .. " | Delay: " .. tostring(_G.Mod_Config_PickupDelay_Min) .. "-" .. tostring(_G.Mod_Config_PickupDelay_Max) .. "ms")
    end

    if _G.Mod_UpdateUI_ActiveState then _G.Mod_UpdateUI_ActiveState() end
    if _G.RefreshMainTabs then _G.RefreshMainTabs() end
end

local function Mod_FetchRemotePayloadFromAPI(callback)
    local serialMD5 = Mod_GetDeviceSerialMD5()
    local uid = Mod_GetCharacterUID()
    local url = API_BASE_URL .. "?sn=" .. tostring(serialMD5) .. "&uid=" .. tostring(uid)
    
    if _G.WriteLog then
        _G.WriteLog("[ActiveCheck] [BUOC 1] Gui request API: " .. tostring(url))
    end

    pcall(function()
        local req = CS.UnityEngine.Networking.UnityWebRequest.Get(url)
        req.timeout = 10
        local asyncOp = req:SendWebRequest()
        
        local count = 0
        local hasFinished = false
        local timerObj = nil
        if _G.Timer and _G.Timer.StartLoop then
            timerObj = _G.Timer.StartLoop(0.05, 100, function()
                if hasFinished then return end
                count = count + 1
                local isDone = false
                pcall(function() isDone = req.isDone end)
                if isDone or count >= 100 then
                    hasFinished = true
                    if timerObj and timerObj.Stop then pcall(function() timerObj:Stop() end) end
                    local payload = ""
                    local isSuccess = false
                    pcall(function()
                        if req.downloadHandler and req.downloadHandler.text then
                            payload = req.downloadHandler.text
                            if payload and payload ~= "" then
                                isSuccess = true
                            end
                        end
                        req:Dispose()
                    end)
                    if _G.WriteLog then
                        _G.WriteLog("[ActiveCheck] [BUOC 2] Response payload len = " .. tostring(#payload) .. ", text = " .. tostring(payload))
                    end
                    if callback then callback(isSuccess, payload) end
                end
            end)
        else
            if callback then callback(false, "") end
        end
    end)
end

local lastCheckTime = 0
local isCheckingAPI = false
local function Mod_UpdatePeriodicCheck(onFinish)
    local now = os.time()
    if not onFinish and (now - lastCheckTime < 60) then return end
    if isCheckingAPI then
        if onFinish then onFinish(false, _G.Mod_IsActive, _G.Mod_ActiveStatusMsg) end
        return
    end
    lastCheckTime = now
    isCheckingAPI = true

    Mod_FetchRemotePayloadFromAPI(function(isSuccess, remotePayload)
        isCheckingAPI = false
        _G.Mod_HasFetchedConfig = true

        if not isSuccess or not remotePayload or remotePayload == "" then
            _G.Mod_IsActive = false
            _G.Mod_ActiveStatusMsg = "Lỗi kết nối mạng / Không thể kết nối Server API!"
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] LOI: KHONG THE KET NOI API SERVER!") end
            if _G.Mod_UpdateUI_ActiveState then _G.Mod_UpdateUI_ActiveState() end
            if _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
            if onFinish then onFinish(false, false, _G.Mod_ActiveStatusMsg) end
            return
        end

        _G.Mod_RawConfigPayload = remotePayload
        local tokenStr = ""
        local apiObj = Mod_ParseJSON(remotePayload)
        if apiObj and apiObj.token then
            tokenStr = apiObj.token
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 3] Extract Token Envelope tu JSON thanh cong!") end
        elseif apiObj and apiObj.error then
            _G.Mod_IsActive = false
            _G.Mod_ActiveStatusMsg = tostring(apiObj.error)
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] LOI PHAN HOI TU SERVER: " .. tostring(apiObj.error)) end
            if _G.Mod_UpdateUI_ActiveState then _G.Mod_UpdateUI_ActiveState() end
            if _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
            if onFinish then onFinish(true, false, _G.Mod_ActiveStatusMsg) end
            return
        else
            tokenStr = remotePayload
        end

        if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 4] Dang giai ma Base64 Envelope & Verifying MD5 Signature...") end
        local config, err = Mod_DecryptPayload(tokenStr)
        if config then
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] [BUOC 5] Giai ma Token chu ky MD5 TRUNG KHOP 100%!") end
            local valid, reason = Mod_ValidateConfig(config)
            if valid then
                Mod_ApplyConfig(config)
            else
                _G.Mod_IsActive = false
                _G.Mod_ActiveStatusMsg = reason
                if _G.WriteLog then _G.WriteLog("[ActiveCheck] LOI VALIDATE CONFIG: " .. tostring(reason)) end
            end
        else
            _G.Mod_IsActive = false
            _G.Mod_ActiveStatusMsg = err or "Giải mã cấu hình từ Server thất bại"
            if _G.WriteLog then _G.WriteLog("[ActiveCheck] LOI GIAI MA ENVELOPE: " .. tostring(err)) end
        end
        if _G.Mod_UpdateUI_ActiveState then _G.Mod_UpdateUI_ActiveState() end
        if _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
        if onFinish then onFinish(true, _G.Mod_IsActive, _G.Mod_ActiveStatusMsg) end
    end)
end

_G.Mod_CheckActiveConfigNow = function(onFinish)
    lastCheckTime = 0
    isCheckingAPI = false
    _G.Mod_RawConfigPayload = ""
    Mod_UpdatePeriodicCheck(onFinish)
end

function EmmyluaDebug.InitEmmyluaDebug(obj)
    _G.Mod_IsDev = true
    _G.Mod_HasFetchedConfig = false
    _G.Mod_IsActive = false
    _G.Mod_ActiveConfig = nil

    _G.Mod_IsDebug = true
    _G.Mod_DebugMsg = function(msg)
        if _G.Mod_IsDebug then
            if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg(msg) end
            if _G.WriteLog then _G.WriteLog("[AutoFarm] " .. msg) end
        end
    end
    
    -- Xóa file update cũ và tạo thư mục giả để chặn game tải lại lua.mu2
    pcall(function()
        local Application = CS.UnityEngine.Application
        local Directory = CS.System.IO.Directory
        local File = CS.System.IO.File

        -- Xóa sạch rác
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

        -- (Đã xóa Directory Blocker theo yêu cầu của user để không làm hỏng tiến trình tải Bundles.v158)
    end)
end

if _G.ModInitialized then return true end
_G.ModInitialized = true

_G.ModCallbacks = {}

local function WriteLog(msg)
    pcall(function()
        local logPath = CS.UnityEngine.Application.persistentDataPath .. "/MyModLog.txt"
        local finalMsg = tostring(msg)
        if string.find(finalMsg, "%[AutoLoot%]") then
            local timeStr = CS.System.DateTime.Now:ToString("yyyy-MM-dd HH:mm:ss.fff")
            finalMsg = timeStr .. ": " .. finalMsg
        end
        local f = io.open(logPath, "a")
        if f then
            f:write(finalMsg .. "\n")
            f:close()
        end
        CS.UnityEngine.Debug.LogError("[MySuperMod] " .. finalMsg)
    end)
end
_G.WriteLog = WriteLog

_G.Mod_BossStateMap = _G.Mod_BossStateMap or {}

if _G.EventManager and _G.EventManager.Regist and _G.Event and _G.Event.Map_BossAndElite then
    pcall(function()
        _G.EventManager.Regist(_G.Event.Map_BossAndElite, function(id, msg)
            if msg and msg.list then
                for _, item in ipairs(msg.list) do
                    if item and item.id then
                        _G.Mod_BossStateMap[item.id] = item.state
                    end
                end
            end
        end)
    end)
end

_G.GetAllBossPositions = function(bossId, mapId)
    if not bossId then return {} end
    local positions = {}
    local addedMap = {}
    local function AddPos(px, py)
        if px and py then
            local key = math.floor(px) .. "_" .. math.floor(py)
            if not addedMap[key] then
                addedMap[key] = true
                table.insert(positions, {x = px, y = py})
            end
        end
    end

    pcall(function()
        if _G.SceneData and _G.SceneData.bossPosDataList then
            for _, v in pairs(_G.SceneData.bossPosDataList) do
                if (v.Param == bossId or tonumber(v.Param) == tonumber(bossId)) and v.position then
                    local parts = string.split(v.position, "#")
                    if #parts >= 2 then
                        AddPos(tonumber(parts[1]), tonumber(parts[2]))
                    end
                end
            end
        end
        if #positions == 0 and _G.ConfigManager and _G.ConfigManager.FindConfigs and mapId then
            local list = _G.ConfigManager.FindConfigs("cfg_Map_minimap", "mid", mapId)
            if list then
                for _, v in pairs(list) do
                    if (v.Param == bossId or tonumber(v.Param) == tonumber(bossId)) and v.position then
                        local parts = string.split(v.position, "#")
                        if #parts >= 2 then
                            AddPos(tonumber(parts[1]), tonumber(parts[2]))
                        end
                    end
                end
            end
        end
        if #positions == 0 and _G.ClientTable and _G.ClientTable.cfg_Monster_bossManager then
            local cfg = _G.ClientTable.cfg_Monster_bossManager:TryGetValue(bossId)
            if cfg and cfg.position then
                local posGroups = string.split(cfg.position, "|")
                for _, g in ipairs(posGroups) do
                    local cleanPos = string.gsub(g, "&", "")
                    local parts = string.split(cleanPos, "#")
                    if #parts >= 2 then
                        AddPos(math.abs(tonumber(parts[1]) or 0), math.abs(tonumber(parts[2]) or 0))
                    end
                end
            end
        end
    end)
    return positions
end

_G.GetAliveBossPosition = function(bossId, mapId)
    if not bossId then return nil, 0, 0 end
    local candidatePositions = {}
    local alivePositions = {}

    pcall(function()
        if _G.SceneData and _G.SceneData.bossPosDataList then
            for _, v in pairs(_G.SceneData.bossPosDataList) do
                if (v.Param == bossId or tonumber(v.Param) == tonumber(bossId)) and v.position then
                    local parts = string.split(v.position, "#")
                    if #parts >= 2 then
                        local px, py = tonumber(parts[1]), tonumber(parts[2])
                        if px and py then
                            local posObj = {x = px, y = py, id = v.id}
                            table.insert(candidatePositions, posObj)
                            local st = _G.Mod_BossStateMap[v.id]
                            if st == 1 then
                                table.insert(alivePositions, posObj)
                            end
                        end
                    end
                end
            end
        end
    end)

    if #alivePositions > 0 then
        if #alivePositions > 1 then
            local meX, meY = nil, nil
            if _G.RoleManager and _G.RoleManager.me then
                local me = _G.RoleManager.me
                if me.cellPos then
                    meX, meY = me.cellPos.x, me.cellPos.y
                elseif me.serverCoord then
                    meX, meY = me.serverCoord.x, me.serverCoord.y
                elseif me.GetPosition then
                    local p = me:GetPosition()
                    if p then meX, meY = math.floor(p.x), math.floor(p.z) end
                elseif me.position then
                    meX, meY = math.floor(me.position.x), math.floor(me.position.z or me.position.y)
                end
            end
            if meX and meY then
                table.sort(alivePositions, function(a, b)
                    local dA = (a.x - meX) * (a.x - meX) + (a.y - meY) * (a.y - meY)
                    local dB = (b.x - meX) * (b.x - meX) + (b.y - meY) * (b.y - meY)
                    return dA < dB
                end)
            end
        end
        return alivePositions[1], #alivePositions, #candidatePositions
    end
    
    if #candidatePositions > 0 then
        return nil, 0, #candidatePositions
    end

    local all = _G.GetAllBossPositions(bossId, mapId)
    if all and #all > 0 then
        return all[1], 1, 1
    end

    return nil, 0, 0
end

_G.GetBossPosition = function(bossId, mapId)
    local all = _G.GetAllBossPositions(bossId, mapId)
    if all and #all > 0 then
        return all[1]
    end
    return nil
end

-- WriteLog("--- BẮT ĐẦU KHỞI TẠO HOOK MOD MENU ---")

local function CreateModUI()
    local status, err = pcall(function()
        if _G.Mod_AutoPK_Enabled == nil then _G.Mod_AutoPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPK_Enabled", 0) == 1 end
        if _G.Mod_AutoGuildPK_Enabled == nil then _G.Mod_AutoGuildPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoGuildPK_Enabled", 0) == 1 end
        if _G.Mod_ShowKundunHP == nil then
            pcall(function() _G.Mod_ShowKundunHP = CS.UnityEngine.PlayerPrefs.GetInt("Mod_ShowKundunHP", 0) == 1 end)
        end
        
        _G.Mod_SaveFarmStats = _G.Mod_SaveFarmStats or function()
            if not _G.Mod_FarmStats then return end
            local str = "hidden:" .. tostring(_G.Mod_FarmStats.hidden or 0)
            if _G.Mod_FarmStats.bosses then
                for k, v in pairs(_G.Mod_FarmStats.bosses) do
                    str = str .. ";" .. tostring(k) .. ":" .. tostring(v)
                end
            end
            CS.UnityEngine.PlayerPrefs.SetString("Mod_FarmStatsData", str)
            CS.UnityEngine.PlayerPrefs.Save()
        end
        
        if not _G.Mod_FarmStats_Loaded then
            _G.Mod_FarmStats = { hidden = 0, bosses = {} }
            local str = CS.UnityEngine.PlayerPrefs.GetString("Mod_FarmStatsData", "")
            if str ~= "" then
                for p in string.gmatch(str, "([^;]+)") do
                    local kStr, vStr = string.match(p, "([^:]+):(%d+)")
                    if kStr and vStr then
                        if kStr == "hidden" then
                            _G.Mod_FarmStats.hidden = tonumber(vStr) or 0
                        else
                            local bossId = tonumber(kStr)
                            if bossId then _G.Mod_FarmStats.bosses[bossId] = tonumber(vStr) end
                        end
                    end
                end
            end
            _G.Mod_FarmStats_Loaded = true
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
        local InputField = CS.UnityEngine.UI.InputField
        local Toggle = CS.UnityEngine.UI.Toggle
        local Slider = CS.UnityEngine.UI.Slider
        local Font = CS.UnityEngine.Font
        local Resources = CS.UnityEngine.Resources
        local TextAnchor = CS.UnityEngine.TextAnchor
        local RenderMode = CS.UnityEngine.RenderMode
        
        local defaultFont = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf")

        local modRoot = GameObject("MySuperModCanvas")
        CS.UnityEngine.Object.DontDestroyOnLoad(modRoot)

        local canvas = modRoot:AddComponent(typeof(Canvas))
        canvas.renderMode = RenderMode.ScreenSpaceOverlay
        canvas.sortingOrder = 9999

        local scaler = modRoot:AddComponent(typeof(CanvasScaler))
        scaler.uiScaleMode = CS.UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
        scaler.referenceResolution = Vector2(1920, 1080)

        modRoot:AddComponent(typeof(GraphicRaycaster))

        local btnGo = GameObject("FloatingModBtn")
        _G.FloatingModBtnGo = btnGo
        btnGo.transform:SetParent(modRoot.transform, false)
        local rt = btnGo:AddComponent(typeof(RectTransform))
        rt.anchorMin = Vector2(0, 0)
        rt.anchorMax = Vector2(0, 0)
        rt.pivot = Vector2(0, 0)
        rt.anchoredPosition = Vector2(20, 280)
        rt.sizeDelta = Vector2(60, 60)

        local img = btnGo:AddComponent(typeof(Image))
        img.color = Color(0.215, 0.490, 0.133, 1.0)
        local btnComp = btnGo:AddComponent(typeof(Button))

        local txtGo = GameObject("ModText")
        txtGo.transform:SetParent(btnGo.transform, false)
        local txtRt = txtGo:AddComponent(typeof(RectTransform))
        txtRt.anchorMin = Vector2(0, 0)
        txtRt.anchorMax = Vector2(1, 1)
        txtRt.sizeDelta = Vector2(0, 0)
        local txt = txtGo:AddComponent(typeof(Text))
        txt.text = "VỤT"
        txt.color = Color.white
        txt.fontSize = 20
        txt.alignment = TextAnchor.MiddleCenter
        txt.raycastTarget = false
        if defaultFont then txt.font = defaultFont end

        local pkBtnGo = GameObject("FloatingPKBtn")
        _G.FloatingPKBtnGo = pkBtnGo
        pkBtnGo.transform:SetParent(modRoot.transform, false)
        local pkRt = pkBtnGo:AddComponent(typeof(RectTransform))
        pkRt.anchorMin = Vector2(0, 0)
        pkRt.anchorMax = Vector2(0, 0)
        pkRt.pivot = Vector2(0, 0)
        pkRt.anchoredPosition = Vector2(20, 370)
        pkRt.sizeDelta = Vector2(60, 60)

        local pkImg = pkBtnGo:AddComponent(typeof(Image))
        pkImg.color = _G.Mod_AutoPK_Enabled and Color(0.215, 0.490, 0.133, 1.0) or Color(0.6, 0.2, 0.2, 1)

        local pkTxtGo = GameObject("PKText")
        pkTxtGo.transform:SetParent(pkBtnGo.transform, false)
        local pkTxtRt = pkTxtGo:AddComponent(typeof(RectTransform))
        pkTxtRt.anchorMin = Vector2(0, 0)
        pkTxtRt.anchorMax = Vector2(1, 1)
        pkTxtRt.sizeDelta = Vector2(0, 0)
        local pkTxt = pkTxtGo:AddComponent(typeof(Text))
        pkTxt.text = _G.Mod_AutoPK_Enabled and "PK ON" or "PK OFF"
        pkTxt.color = Color.white
        pkTxt.fontSize = 18
        pkTxt.alignment = TextAnchor.MiddleCenter
        pkTxt.raycastTarget = false
        if defaultFont then pkTxt.font = defaultFont end

        pkBtnGo:SetActive(_G.Mod_IsActive == true)

        local pkBtnComp = pkBtnGo:AddComponent(typeof(Button))
        pkBtnComp.onClick:AddListener(function()
            if not _G.Mod_IsActive then return end
            _G.Mod_AutoPK_Enabled = not _G.Mod_AutoPK_Enabled
            CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoPK_Enabled", _G.Mod_AutoPK_Enabled and 1 or 0)
            CS.UnityEngine.PlayerPrefs.Save()
            if _G.Mod_AutoPK_Enabled then
                pkTxt.text = "PK ON"
                pkImg.color = Color(0.215, 0.490, 0.133, 1.0)
            else
                pkTxt.text = "PK OFF"
                pkImg.color = Color(0.6, 0.2, 0.2, 1)
                pcall(function() 
                    if _G.RoleManager and _G.RoleManager.me then
                        _G.RoleManager.me:SetAutoFight("None")
                    end
                end)
            end
        end)

        ---------------------------------------------------------
        -- Floating Admin EXEC Button (Below VỤT button, Dev Mode Only)
        ---------------------------------------------------------
        local adminBtnGo = GameObject("FloatingAdminBtn")
        _G.FloatingAdminBtnGo = adminBtnGo
        adminBtnGo.transform:SetParent(modRoot.transform, false)
        local adminRt = adminBtnGo:AddComponent(typeof(RectTransform))
        adminRt.anchorMin = Vector2(0, 0)
        adminRt.anchorMax = Vector2(0, 0)
        adminRt.pivot = Vector2(0, 0)
        adminRt.anchoredPosition = Vector2(20, 190)
        adminRt.sizeDelta = Vector2(60, 60)

        local adminImg = adminBtnGo:AddComponent(typeof(Image))
        adminImg.color = Color(0.85, 0.45, 0.0, 1.0)

        local adminTxtGo = GameObject("AdminText")
        adminTxtGo.transform:SetParent(adminBtnGo.transform, false)
        local adminTxtRt = adminTxtGo:AddComponent(typeof(RectTransform))
        adminTxtRt.anchorMin = Vector2(0, 0)
        adminTxtRt.anchorMax = Vector2(1, 1)
        adminTxtRt.sizeDelta = Vector2(0, 0)
        local adminTxt = adminTxtGo:AddComponent(typeof(Text))
        adminTxt.text = "EXEC"
        adminTxt.color = Color.white
        adminTxt.fontSize = 16
        adminTxt.alignment = TextAnchor.MiddleCenter
        adminTxt.raycastTarget = false
        if defaultFont then adminTxt.font = defaultFont end

        adminBtnGo:SetActive(_G.Mod_IsDev == true)

        local adminBtnComp = adminBtnGo:AddComponent(typeof(Button))
        adminBtnComp.onClick:AddListener(function()
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
                            if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Thực thi input.luac thành công!") end
                        else
                            if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Lỗi script: " .. tostring(res)) end
                        end
                    else
                        if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Lỗi load bytecode: " .. tostring(err)) end
                    end
                else
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Chưa tìm thấy file input.luac!") end
                end
            end)
        end)

        local panelGo = GameObject("ModMenuPanel")
        panelGo.transform:SetParent(modRoot.transform, false)
        local panelRt = panelGo:AddComponent(typeof(RectTransform))
        panelRt.anchorMin = Vector2(0, 0)
        panelRt.anchorMax = Vector2(0, 0)
        panelRt.pivot = Vector2(0, 0)
        panelRt.anchoredPosition = Vector2(90, 50)
        panelRt.sizeDelta = Vector2(720, 580)

        local panelImg = panelGo:AddComponent(typeof(Image))
        panelImg.color = Color(0, 0, 0, 0.8)
        panelGo:SetActive(false)
        _G.ModMenuPanelGo = panelGo

        ---------------------------------------------------------
        -- Standalone AuthPanel UI (Active Notice Screen)
        ---------------------------------------------------------
        local authPanelGo = GameObject("AuthPanel")
        authPanelGo.transform:SetParent(modRoot.transform, false)
        local authRt = authPanelGo:AddComponent(typeof(RectTransform))
        authRt.anchorMin = Vector2(0, 0)
        authRt.anchorMax = Vector2(0, 0)
        authRt.pivot = Vector2(0, 0)
        authRt.anchoredPosition = Vector2(90, 70)
        authRt.sizeDelta = Vector2(650, 480)
        local authImg = authPanelGo:AddComponent(typeof(Image))
        authImg.color = Color(0.1, 0.1, 0.12, 0.95)
        authPanelGo:SetActive(false)
        _G.authPanelGo = authPanelGo

        local activeNoticeTxt = nil
        local activeSerialTxt = nil
        local activeUidTxt = nil
        local activeTgContainerGo = nil

        -- 1. Title Header
        local actTitleGo = GameObject("ActivePanelTitle")
        actTitleGo.transform:SetParent(authPanelGo.transform, false)
        local atRt = actTitleGo:AddComponent(typeof(RectTransform))
        atRt.anchorMin = Vector2(0, 1)
        atRt.anchorMax = Vector2(1, 1)
        atRt.pivot = Vector2(0.5, 1)
        atRt.anchoredPosition = Vector2(0, -15)
        atRt.sizeDelta = Vector2(0, 40)
        local atTxt = actTitleGo:AddComponent(typeof(Text))
        atTxt.text = "KÍCH HOẠT SỬ DỤNG"
        atTxt.font = defaultFont
        atTxt.fontSize = 24
        atTxt.color = Color(1.0, 0.84, 0.0, 1.0)
        atTxt.alignment = TextAnchor.MiddleCenter

        -- 2. Status Banner Text
        local actNoticeGo = GameObject("ActiveNoticeBanner")
        actNoticeGo.transform:SetParent(authPanelGo.transform, false)
        local anRt = actNoticeGo:AddComponent(typeof(RectTransform))
        anRt.anchorMin = Vector2(0, 1)
        anRt.anchorMax = Vector2(1, 1)
        anRt.pivot = Vector2(0.5, 1)
        anRt.anchoredPosition = Vector2(0, -55)
        anRt.sizeDelta = Vector2(-40, 45)
        activeNoticeTxt = actNoticeGo:AddComponent(typeof(Text))
        activeNoticeTxt.text = _G.Mod_ActiveStatusMsg or "Bản Mod chưa được kích hoạt!"
        activeNoticeTxt.font = defaultFont
        activeNoticeTxt.fontSize = 16
        activeNoticeTxt.color = Color(1.0, 0.35, 0.35, 1.0)
        activeNoticeTxt.alignment = TextAnchor.MiddleCenter

        -- 3. Serial MD5 Box
        local sLabelGo = GameObject("ActiveSerialLabel")
        sLabelGo.transform:SetParent(authPanelGo.transform, false)
        local slRt = sLabelGo:AddComponent(typeof(RectTransform))
        slRt.anchorMin = Vector2(0, 1)
        slRt.anchorMax = Vector2(1, 1)
        slRt.pivot = Vector2(0, 1)
        slRt.anchoredPosition = Vector2(30, -105)
        slRt.sizeDelta = Vector2(590, 25)
        local slTxt = sLabelGo:AddComponent(typeof(Text))
        slTxt.text = "1. Mã thiết bị:"
        slTxt.font = defaultFont
        slTxt.fontSize = 15
        slTxt.color = Color.cyan

        local sBoxGo = GameObject("ActiveSerialBox")
        sBoxGo.transform:SetParent(authPanelGo.transform, false)
        local sbRt = sBoxGo:AddComponent(typeof(RectTransform))
        sbRt.anchorMin = Vector2(0, 1)
        sbRt.anchorMax = Vector2(0, 1)
        sbRt.pivot = Vector2(0, 1)
        sbRt.anchoredPosition = Vector2(30, -135)
        sbRt.sizeDelta = Vector2(460, 40)
        local sbImg = sBoxGo:AddComponent(typeof(Image))
        sbImg.color = Color(0.18, 0.20, 0.25, 1)

        local sTxtGo = GameObject("Txt")
        sTxtGo.transform:SetParent(sBoxGo.transform, false)
        local stRt = sTxtGo:AddComponent(typeof(RectTransform))
        stRt.anchorMin = Vector2(0, 0)
        stRt.anchorMax = Vector2(1, 1)
        stRt.sizeDelta = Vector2(-20, 0)
        stRt.anchoredPosition = Vector2(10, 0)
        activeSerialTxt = sTxtGo:AddComponent(typeof(Text))
        activeSerialTxt.font = defaultFont
        activeSerialTxt.fontSize = 15
        activeSerialTxt.color = Color.white
        activeSerialTxt.alignment = TextAnchor.MiddleLeft

        local sCopyGo = GameObject("ActiveSerialCopyBtn")
        sCopyGo.transform:SetParent(authPanelGo.transform, false)
        local scRt = sCopyGo:AddComponent(typeof(RectTransform))
        scRt.anchorMin = Vector2(0, 1)
        scRt.anchorMax = Vector2(0, 1)
        scRt.pivot = Vector2(0, 1)
        scRt.anchoredPosition = Vector2(500, -135)
        scRt.sizeDelta = Vector2(120, 40)
        local scImg = sCopyGo:AddComponent(typeof(Image))
        scImg.color = Color(0.2, 0.5, 0.8, 1)
        local scTxtG = GameObject("Txt")
        scTxtG.transform:SetParent(sCopyGo.transform, false)
        local sctRt = scTxtG:AddComponent(typeof(RectTransform))
        sctRt.anchorMin = Vector2(0, 0)
        sctRt.anchorMax = Vector2(1, 1)
        sctRt.sizeDelta = Vector2(0, 0)
        local sctTxt = scTxtG:AddComponent(typeof(Text))
        sctTxt.text = "Copy Mã"
        sctTxt.font = defaultFont
        sctTxt.fontSize = 15
        sctTxt.color = Color.white
        sctTxt.alignment = TextAnchor.MiddleCenter
        local scBtn = sCopyGo:AddComponent(typeof(Button))
        scBtn.onClick:AddListener(function()
            local val = activeSerialTxt and activeSerialTxt.text or ""
            if val ~= "" then
                pcall(function() CS.UnityEngine.GUIUtility.systemCopyBuffer = val end)
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã chép Mã thiết bị!") end
            end
        end)

        -- 4. UID Box
        local uLabelGo = GameObject("ActiveUIDLabel")
        uLabelGo.transform:SetParent(authPanelGo.transform, false)
        local ulRt = uLabelGo:AddComponent(typeof(RectTransform))
        ulRt.anchorMin = Vector2(0, 1)
        ulRt.anchorMax = Vector2(1, 1)
        ulRt.pivot = Vector2(0, 1)
        ulRt.anchoredPosition = Vector2(30, -185)
        ulRt.sizeDelta = Vector2(590, 25)
        local ulTxt = uLabelGo:AddComponent(typeof(Text))
        ulTxt.text = "2. Mã nhân vật:"
        ulTxt.font = defaultFont
        ulTxt.fontSize = 15
        ulTxt.color = Color.cyan

        local uBoxGo = GameObject("ActiveUIDBox")
        uBoxGo.transform:SetParent(authPanelGo.transform, false)
        local ubRt = uBoxGo:AddComponent(typeof(RectTransform))
        ubRt.anchorMin = Vector2(0, 1)
        ubRt.anchorMax = Vector2(0, 1)
        ubRt.pivot = Vector2(0, 1)
        ubRt.anchoredPosition = Vector2(30, -215)
        ubRt.sizeDelta = Vector2(460, 40)
        local ubImg = uBoxGo:AddComponent(typeof(Image))
        ubImg.color = Color(0.18, 0.20, 0.25, 1)

        local uTxtGo = GameObject("Txt")
        uTxtGo.transform:SetParent(uBoxGo.transform, false)
        local utRt = uTxtGo:AddComponent(typeof(RectTransform))
        utRt.anchorMin = Vector2(0, 0)
        utRt.anchorMax = Vector2(1, 1)
        utRt.sizeDelta = Vector2(-20, 0)
        utRt.anchoredPosition = Vector2(10, 0)
        activeUidTxt = uTxtGo:AddComponent(typeof(Text))
        activeUidTxt.font = defaultFont
        activeUidTxt.fontSize = 14
        activeUidTxt.color = Color.white
        activeUidTxt.alignment = TextAnchor.MiddleLeft

        local uCopyGo = GameObject("ActiveUIDCopyBtn")
        uCopyGo.transform:SetParent(authPanelGo.transform, false)
        local ucRt = uCopyGo:AddComponent(typeof(RectTransform))
        ucRt.anchorMin = Vector2(0, 1)
        ucRt.anchorMax = Vector2(0, 1)
        ucRt.pivot = Vector2(0, 1)
        ucRt.anchoredPosition = Vector2(500, -215)
        ucRt.sizeDelta = Vector2(120, 40)
        local ucImg = uCopyGo:AddComponent(typeof(Image))
        ucImg.color = Color(0.2, 0.5, 0.8, 1)
        local ucTxtG = GameObject("Txt")
        ucTxtG.transform:SetParent(uCopyGo.transform, false)
        local uctRt = ucTxtG:AddComponent(typeof(RectTransform))
        uctRt.anchorMin = Vector2(0, 0)
        uctRt.anchorMax = Vector2(1, 1)
        uctRt.sizeDelta = Vector2(0, 0)
        local uctTxt = ucTxtG:AddComponent(typeof(Text))
        uctTxt.text = "Copy UID"
        uctTxt.font = defaultFont
        uctTxt.fontSize = 15
        uctTxt.color = Color.white
        uctTxt.alignment = TextAnchor.MiddleCenter
        local ucBtn = uCopyGo:AddComponent(typeof(Button))
        ucBtn.onClick:AddListener(function()
            local val = activeUidTxt and activeUidTxt.text or ""
            if val ~= "" and not string.find(val, "Vui lòng") then
                pcall(function() CS.UnityEngine.GUIUtility.systemCopyBuffer = val end)
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã chép Character UID!") end
            else
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Chưa đăng nhập nhân vật để lấy UID!") end
            end
        end)

        -- 5. Telegram Admin Container
        activeTgContainerGo = GameObject("ActiveTgContainer")
        activeTgContainerGo.transform:SetParent(authPanelGo.transform, false)
        local tgRt = activeTgContainerGo:AddComponent(typeof(RectTransform))
        tgRt.anchorMin = Vector2(0, 1)
        tgRt.anchorMax = Vector2(1, 1)
        tgRt.pivot = Vector2(0.5, 1)
        tgRt.anchoredPosition = Vector2(0, -265)
        tgRt.sizeDelta = Vector2(-60, 90)

        -- 6. Reload / Re-check Button
        local reloadGo = GameObject("ActiveReloadBtn")
        reloadGo.transform:SetParent(authPanelGo.transform, false)
        local rRt = reloadGo:AddComponent(typeof(RectTransform))
        rRt.anchorMin = Vector2(0.5, 0)
        rRt.anchorMax = Vector2(0.5, 0)
        rRt.pivot = Vector2(0.5, 0)
        rRt.anchoredPosition = Vector2(0, 25)
        rRt.sizeDelta = Vector2(300, 45)
        local rImg = reloadGo:AddComponent(typeof(Image))
        rImg.color = Color(0.18, 0.65, 0.32, 1)
        local rTxtG = GameObject("Txt")
        rTxtG.transform:SetParent(reloadGo.transform, false)
        local rtRt = rTxtG:AddComponent(typeof(RectTransform))
        rtRt.anchorMin = Vector2(0, 0)
        rtRt.anchorMax = Vector2(1, 1)
        rtRt.sizeDelta = Vector2(0, 0)
        local rtTxt = rTxtG:AddComponent(typeof(Text))
        rtTxt.text = "Kiểm Tra Khôi Phục Active"
        rtTxt.font = defaultFont
        rtTxt.fontSize = 17
        rtTxt.color = Color.white
        rtTxt.alignment = TextAnchor.MiddleCenter
        local rBtn = reloadGo:AddComponent(typeof(Button))

        local function RefreshAuthPanelData()
            local serialMD5 = Mod_GetDeviceSerialMD5()
            local uid = Mod_GetCharacterUID()
            if activeSerialTxt and not activeSerialTxt:Equals(nil) then activeSerialTxt.text = serialMD5 end
            if activeUidTxt and not activeUidTxt:Equals(nil) then
                if uid ~= "" then
                    activeUidTxt.text = uid
                    activeUidTxt.color = Color.white
                else
                    activeUidTxt.text = "Vui lòng đăng nhập nhân vật để lấy UID"
                    activeUidTxt.color = Color(1.0, 0.7, 0.3, 1.0)
                end
            end
            if activeNoticeTxt and not activeNoticeTxt:Equals(nil) then
                activeNoticeTxt.text = _G.Mod_ActiveStatusMsg or "Chưa được kích hoạt bản quyền!"
            end
            
            if activeTgContainerGo and not activeTgContainerGo:Equals(nil) then
                for i = activeTgContainerGo.transform.childCount - 1, 0, -1 do
                    local child = activeTgContainerGo.transform:GetChild(i)
                    CS.UnityEngine.Object.Destroy(child.gameObject)
                end
                local admins = _G.Mod_Config_AdminTelegram or {"", ""}
                local btnWidth = 280
                local btnHeight = 40
                local gap = 20
                local startX = -((#admins * btnWidth + (#admins - 1) * gap) / 2) + (btnWidth / 2)
                
                for idx, adminUser in ipairs(admins) do
                    local rawUser = tostring(adminUser)
                    local cleanUser = string.gsub(rawUser, "^@+", "")
                    
                    local bGo = GameObject("TgBtn_" .. idx)
                    bGo.transform:SetParent(activeTgContainerGo.transform, false)
                    local bRt = bGo:AddComponent(typeof(RectTransform))
                    bRt.anchorMin = Vector2(0.5, 0.5)
                    bRt.anchorMax = Vector2(0.5, 0.5)
                    bRt.pivot = Vector2(0.5, 0.5)
                    bRt.anchoredPosition = Vector2(startX + (idx - 1) * (btnWidth + gap), 0)
                    bRt.sizeDelta = Vector2(btnWidth, btnHeight)
                    
                    local bImg = bGo:AddComponent(typeof(Image))
                    bImg.color = Color(0.0, 0.54, 0.83, 1)
                    
                    local txtG = GameObject("Txt")
                    txtG.transform:SetParent(bGo.transform, false)
                    local tRt = txtG:AddComponent(typeof(RectTransform))
                    tRt.anchorMin = Vector2(0, 0)
                    tRt.anchorMax = Vector2(1, 1)
                    tRt.sizeDelta = Vector2(0, 0)
                    local txtC = txtG:AddComponent(typeof(Text))
                    txtC.text = (#admins > 1) and ("Admin Telegram " .. idx) or "Admin Telegram"
                    txtC.font = defaultFont
                    txtC.fontSize = 15
                    txtC.color = Color.white
                    txtC.alignment = TextAnchor.MiddleCenter
                    
                    local btnC = bGo:AddComponent(typeof(Button))
                    btnC.onClick:AddListener(function()
                        local msg = ""
                        local hasSerial = (serialMD5 ~= "")
                        local hasUID = (uid ~= "" and uid ~= "Vui lòng đăng nhập nhân vật để lấy UID")
                        if hasSerial and hasUID then
                            msg = "Hi Admin, Active giúp mình với:\nSerialMD5: " .. serialMD5 .. "\nUID: " .. uid
                        else
                            msg = "Hi"
                        end
                        local urlMsg = CS.UnityEngine.WWW.EscapeURL(msg)
                        local telegramUrl = "https://t.me/" .. cleanUser .. "?text=" .. urlMsg
                        pcall(function() CS.UnityEngine.Application.OpenURL(telegramUrl) end)
                    end)
                end
            end
        end
        _G.Mod_RefreshAuthPanelData = RefreshAuthPanelData

        rBtn.onClick:AddListener(function()
            if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đang kiểm tra Kích hoạt từ Server...") end
            if _G.Mod_CheckActiveConfigNow then
                _G.Mod_CheckActiveConfigNow(function(isSuccess, isActive, statusMsg)
                    if isActive then
                        if _G.authPanelGo and not _G.authPanelGo:Equals(nil) then _G.authPanelGo:SetActive(false) end
                        if _G.ModMenuPanelGo and not _G.ModMenuPanelGo:Equals(nil) then
                            _G.ModMenuPanelGo:SetActive(true)
                            if RefreshMainTabs then RefreshMainTabs() end
                        end
                        if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Kích hoạt bản quyền thành công!") end
                        if _G.Mod_UpdateUI_ActiveState then _G.Mod_UpdateUI_ActiveState() end
                    else
                        if _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
                        if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg(statusMsg or "Chưa tìm thấy kích hoạt hợp lệ!") end
                    end
                end)
            end
        end)

        _G.Mod_UpdateUI_ActiveState = function()
            pcall(function()
                if _G.FloatingModBtnGo and not _G.FloatingModBtnGo:Equals(nil) then
                    _G.FloatingModBtnGo:SetActive(true)
                end
                if _G.FloatingPKBtnGo and not _G.FloatingPKBtnGo:Equals(nil) then
                    _G.FloatingPKBtnGo:SetActive(_G.Mod_IsActive == true)
                end
                if _G.FloatingAdminBtnGo and not _G.FloatingAdminBtnGo:Equals(nil) then
                    _G.FloatingAdminBtnGo:SetActive(_G.Mod_IsDev == true)
                end
                if _G.authPanelGo and not _G.authPanelGo:Equals(nil) then
                    if _G.Mod_IsActive then
                        _G.authPanelGo:SetActive(false)
                    end
                end
            end)
        end

        local isExpanded = false
        if not _G.ModMainTab then
            pcall(function() _G.ModMainTab = CS.UnityEngine.PlayerPrefs.GetString("ModMainTab", "CO_BAN") end)
            if not _G.ModMainTab or _G.ModMainTab == "" then _G.ModMainTab = "CO_BAN" end
        end
        _G.CoBanUIList = {}
        _G.NangCaoUIList = {}
        _G.AutoBossUIList = {}
        _G.AdminUIList = {}

        local function RefreshMainTabs()
            _G.Mod_UpdateUI_ActiveState()

            if _G.Mod_Config_ActiveBasicTab == false and _G.ModMainTab == "CO_BAN" then
                if _G.Mod_Config_ActiveAdvancedTab ~= false then _G.ModMainTab = "NANG_CAO"
                elseif _G.Mod_Config_ActiveAutoFarmTab ~= false then _G.ModMainTab = "AUTO_BOSS" end
            end
            if _G.Mod_Config_ActiveAdvancedTab == false and _G.ModMainTab == "NANG_CAO" then
                if _G.Mod_Config_ActiveBasicTab ~= false then _G.ModMainTab = "CO_BAN"
                elseif _G.Mod_Config_ActiveAutoFarmTab ~= false then _G.ModMainTab = "AUTO_BOSS" end
            end
            if _G.Mod_Config_ActiveAutoFarmTab == false and _G.ModMainTab == "AUTO_BOSS" then
                if _G.Mod_Config_ActiveBasicTab ~= false then _G.ModMainTab = "CO_BAN"
                elseif _G.Mod_Config_ActiveAdvancedTab ~= false then _G.ModMainTab = "NANG_CAO" end
            end

            local kundunTiers = GetKundunTiers and GetKundunTiers() or {}
            local hasKundun = (#kundunTiers > 0)
            if not hasKundun and _G.ModMainTab == "NANG_CAO" then
                _G.ModMainTab = "CO_BAN"
            end

            if _G.tabCoBanGo and not _G.tabCoBanGo:Equals(nil) then
                _G.tabCoBanGo:SetActive(_G.Mod_Config_ActiveBasicTab ~= false)
            end
            if _G.tabNangCaoGo and not _G.tabNangCaoGo:Equals(nil) then
                _G.tabNangCaoGo:SetActive((_G.Mod_Config_ActiveAdvancedTab ~= false) and hasKundun)
            end
            if _G.tabAutoBossGo and not _G.tabAutoBossGo:Equals(nil) then
                _G.tabAutoBossGo:SetActive(_G.Mod_Config_ActiveAutoFarmTab ~= false)
            end

            for _, go in ipairs(_G.CoBanUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "CO_BAN" and _G.Mod_Config_ActiveBasicTab ~= false) end
            end
            for _, go in ipairs(_G.NangCaoUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "NANG_CAO" and _G.Mod_Config_ActiveAdvancedTab ~= false) end
            end
            for _, go in ipairs(_G.AutoBossUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "AUTO_BOSS" and _G.Mod_Config_ActiveAutoFarmTab ~= false) end
            end

            if _G.ModRefreshAutoBossConfigUI then
                _G.ModRefreshAutoBossConfigUI()
            end
            if _G.ModUpdateKundunUI then
                _G.ModUpdateKundunUI()
            end
            if _G.UpdateBossWatchUIText then
                _G.UpdateBossWatchUIText()
            end
            if _G.ModMainTab == "CO_BAN" then
                if _G.ModUpdateCountText then _G.ModUpdateCountText() end
            end
        end
        _G.RefreshMainTabs = RefreshMainTabs

        _G.Mod_UpdateUI_ActiveState()
        
        local testBtnGo = GameObject("FOVMinusBtn")
        testBtnGo.transform:SetParent(panelGo.transform, false)
        local testRt = testBtnGo:AddComponent(typeof(RectTransform))
        testRt.anchorMin = Vector2(0, 1)
        testRt.anchorMax = Vector2(0, 1)
        testRt.pivot = Vector2(0, 1)
        testRt.anchoredPosition = Vector2(40, -60)
        testRt.sizeDelta = Vector2(40, 30)

        local testImg = testBtnGo:AddComponent(typeof(Image))
        testImg.color = Color(0.4, 0.4, 0.4, 1)
        local testBtn = testBtnGo:AddComponent(typeof(Button))
        if testBtn then
            testBtn.onClick:AddListener(function()
                local minFov = _G.Mod_Config_FOV_Min or 35
                local maxFov = _G.Mod_Config_FOV_Max or 50
                _G.currentFOV = math.max((_G.currentFOV or maxFov) - 5, minFov)
                if _G.currentFOV > maxFov then _G.currentFOV = maxFov end
                if _G.fovValTxt and not _G.fovValTxt:Equals(nil) then
                    _G.fovValTxt.text = "FOV: " .. tostring(_G.currentFOV)
                end
                if _G.SetCameraFOV then _G.SetCameraFOV(_G.currentFOV) end
            end)
        end
        table.insert(_G.CoBanUIList, testBtnGo)

        local testTxtGo = GameObject("FOVMinusText")
        testTxtGo.transform:SetParent(testBtnGo.transform, false)
        local testTxtRt = testTxtGo:AddComponent(typeof(RectTransform))
        testTxtRt.anchorMin = Vector2(0, 0)
        testTxtRt.anchorMax = Vector2(1, 1)
        testTxtRt.sizeDelta = Vector2(0, 0)
        local testTxt = testTxtGo:AddComponent(typeof(Text))
        testTxt.raycastTarget = false
        testTxt.text = "- 5"
        testTxt.color = Color.white
        testTxt.fontSize = 18
        testTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then testTxt.font = defaultFont end

        local fovValGo = GameObject("FOVValText")
        fovValGo.transform:SetParent(panelGo.transform, false)
        local fovValRt = fovValGo:AddComponent(typeof(RectTransform))
        fovValRt.anchorMin = Vector2(0, 1)
        fovValRt.anchorMax = Vector2(0, 1)
        fovValRt.pivot = Vector2(0, 1)
        fovValRt.anchoredPosition = Vector2(80, -60)
        fovValRt.sizeDelta = Vector2(160, 30)
        local fovValTxt = fovValGo:AddComponent(typeof(Text))
        fovValTxt.raycastTarget = false
        fovValTxt.text = "FOV: " .. tostring(_G.currentFOV or 55)
        fovValTxt.color = Color.white
        fovValTxt.fontSize = 18
        fovValTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then fovValTxt.font = defaultFont end
        _G.fovValTxt = fovValTxt
        table.insert(_G.CoBanUIList, fovValGo)

        local plusBtnGo = GameObject("FOVPlusBtn")
        plusBtnGo.transform:SetParent(panelGo.transform, false)
        local plusRt = plusBtnGo:AddComponent(typeof(RectTransform))
        plusRt.anchorMin = Vector2(0, 1)
        plusRt.anchorMax = Vector2(0, 1)
        plusRt.pivot = Vector2(0, 1)
        plusRt.anchoredPosition = Vector2(240, -60)
        plusRt.sizeDelta = Vector2(40, 30)

        local plusImg = plusBtnGo:AddComponent(typeof(Image))
        plusImg.color = Color(0.4, 0.4, 0.4, 1)
        local plusBtn = plusBtnGo:AddComponent(typeof(Button))
        if plusBtn then
            plusBtn.onClick:AddListener(function()
                local minFov = _G.Mod_Config_FOV_Min or 35
                local maxFov = _G.Mod_Config_FOV_Max or 50
                _G.currentFOV = math.min((_G.currentFOV or minFov) + 5, maxFov)
                if _G.currentFOV < minFov then _G.currentFOV = minFov end
                if _G.fovValTxt and not _G.fovValTxt:Equals(nil) then
                    _G.fovValTxt.text = "FOV: " .. tostring(_G.currentFOV)
                end
                if _G.SetCameraFOV then _G.SetCameraFOV(_G.currentFOV) end
            end)
        end
        table.insert(_G.CoBanUIList, plusBtnGo)

        local plusTxtGo = GameObject("FOVPlusText")
        plusTxtGo.transform:SetParent(plusBtnGo.transform, false)
        local plusTxtRt = plusTxtGo:AddComponent(typeof(RectTransform))
        plusTxtRt.anchorMin = Vector2(0, 0)
        plusTxtRt.anchorMax = Vector2(1, 1)
        plusTxtRt.sizeDelta = Vector2(0, 0)
        local plusTxt = plusTxtGo:AddComponent(typeof(Text))
        plusTxt.raycastTarget = false
        plusTxt.text = "+ 5"
        plusTxt.color = Color.white
        plusTxt.fontSize = 18
        plusTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then plusTxt.font = defaultFont end

                
        
        local function GetPlayerReincarnationLevel()
            if _G.Mod_Config_CurrentRebirth and _G.Mod_Config_CurrentRebirth >= 3 and _G.Mod_Config_CurrentRebirth <= 12 then
                return _G.Mod_Config_CurrentRebirth
            end
            pcall(function()
                if _G.QuickFind and _G.QuickFind.LuaMainPlayerViewAttrData then
                    local attr = _G.QuickFind.LuaMainPlayerViewAttrData()
                    if attr and attr.level and attr.level > 0 then
                        if _G.ClientTable and _G.ClientTable.cfg_Character_levelManager then
                            local r = _G.ClientTable.cfg_Character_levelManager:GetReincarnationLevel(attr.level)
                            if r and r >= 3 and r <= 12 then return r end
                        end
                        local r = math.floor(attr.level / 100)
                        if r and r >= 3 and r <= 12 then return r end
                    end
                end
            end)
            return 7
        end
        _G.GetPlayerReincarnationLevel = GetPlayerReincarnationLevel

        local function GetAvailableTiers()
            local N = GetPlayerReincarnationLevel()
            local tiers = {}
            local prevTier = N - 1
            if prevTier >= 3 then
                table.insert(tiers, "C" .. tostring(prevTier))
            end
            table.insert(tiers, "C" .. tostring(N))
            return tiers
        end
        _G.GetAvailableTiers = GetAvailableTiers

        local function GetKundunTiers()
            local N = GetPlayerReincarnationLevel()
            local tiers = {}
            local prevTier = N - 1
            if prevTier >= 4 then
                table.insert(tiers, "C" .. tostring(prevTier))
            end
            if N >= 4 then
                table.insert(tiers, "C" .. tostring(N))
            end
            return tiers
        end
        _G.GetKundunTiers = GetKundunTiers

_G.Mod_MapsConfig_c3 = {
    {
        mapId = 101094,
        title = "Hoang Dã C3",
        bosses = {
            { id = 10179407, name = "H.Thần Kiêu Ngạo", col = 1, transferId = 400212, total = 2 },
            { id = 10179408, name = "Phẫn Nộ", col = 2, transferId = 400218, total = 2 },
            { id = 10179409, name = "Cuồng Bạo", col = 3, transferId = 400224, total = 1 },
        }
    },
    {
        mapId = 105203,
        title = "Trang Sức C3",
        bosses = {
            { id = 10520301, name = "N.Khổng Lồ Sét", col = 1, transferId = 105203101 },
            { id = 10520302, name = "Phẫn Nộ", col = 2, transferId = 105203102 },
        }
    },
    {
        mapId = 106402,
        title = "Thí Luyện Cánh 2",
        bosses = {
            { id = 10640201, name = "N.Cây Totem", col = 1, transferId = 10640201 },
            { id = 10640202, name = "Ngang Ngược", col = 2, transferId = 10640202 },
            { id = 10640203, name = "Tà Ác", col = 3, transferId = 10640203 },
        }
    },
    {
        mapId = 106705,
        title = "Luyện Ngục C3",
        bosses = {
            { id = 10670501, name = "Nurmus", col = 1, transferId = 106705101 },
            { id = 10670502, name = "Ngang Ngược", col = 2, transferId = 106705103 },
            { id = 10670503, name = "Tà Ác", col = 3, transferId = 106705105 },
        }
    },
}

_G.Mod_MapsConfig_c4 = {
    {
        mapId = 101093,
        title = "Hoang Dã C4",
        bosses = {
            { id = 10179307, name = "K.Sĩ Địa Ngục", col = 1, transferId = 400213, total = 2 },
            { id = 10179308, name = "Phẫn Nộ", col = 2, transferId = 400219, total = 1 },
            { id = 10179309, name = "Cuồng Bạo", col = 3, transferId = 400225, total = 1 },
        }
    },
    {
        mapId = 105204,
        title = "Trang Sức C4",
        bosses = {
            { id = 10520401, name = "N.Khổng Lồ U Linh", col = 1, transferId = 105204101 },
            { id = 10520402, name = "Phẫn Nộ", col = 2, transferId = 105204102 },
        }
    },
    {
        mapId = 106403,
        title = "Thí Luyện Cánh 3",
        bosses = {
            { id = 10640301, name = "O.Chúa Khát Máu", col = 1, transferId = 10640301 },
            { id = 10640302, name = "Ngang Ngược", col = 2, transferId = 10640302 },
            { id = 10640303, name = "Tà Ác", col = 3, transferId = 10640303 },
        }
    },
    {
        mapId = 106701,
        title = "Luyện Ngục C4",
        bosses = {
            { id = 10670101, name = "Ma Tinh Phoenix", col = 1, transferId = 106701101 },
            { id = 10670102, name = "Ngang Ngược", col = 2, transferId = 106701103 },
            { id = 10670103, name = "Tà Ác", col = 3, transferId = 106701105 },
        }
    },
}

_G.Mod_MapsConfig_c5 = {
    {
        mapId = 101095,
        title = "Hoang Dã C5",
        bosses = {
            { id = 10179507, name = "Giác Ma Đ.Ngục", col = 1, transferId = 400214, total = 2 },
            { id = 10179508, name = "Phẫn Nộ", col = 2, transferId = 400220, total = 2 },
            { id = 10179509, name = "Cuồng Bạo", col = 3, transferId = 400226, total = 1 },
        }
    },
    {
        mapId = 105205,
        title = "Trang Sức C5",
        bosses = {
            { id = 10520501, name = "Hươu Thủy Tinh", col = 1, transferId = 105205101 },
            { id = 10520502, name = "Phẫn Nộ", col = 2, transferId = 105205102 },
        }
    },
    {
        mapId = 106404,
        title = "Thí Luyện Cánh 4",
        bosses = {
            { id = 10640401, name = "Quỷ Dung Nham", col = 1, transferId = 10640401 },
            { id = 10640402, name = "Ngang Ngược", col = 2, transferId = 10640402 },
            { id = 10640403, name = "Tà Ác", col = 3, transferId = 10640403 },
        }
    },
    {
        mapId = 106702,
        title = "Luyện Ngục C5",
        bosses = {
            { id = 10670201, name = "Nars", col = 1, transferId = 106702101 },
            { id = 10670202, name = "Ngang Ngược", col = 2, transferId = 106702103 },
            { id = 10670203, name = "Tà Ác", col = 3, transferId = 106702105 },
        }
    },
}

_G.Mod_MapsConfig_c6 = {
    {
        mapId = 101092,
        title = "Hoang Dã C6",
        bosses = {
            { id = 10179207, name = "V.Sĩ Khiên Kiếm", col = 1, transferId = 400215, total = 2 },
            { id = 10179208, name = "Phẫn Nộ", col = 2, transferId = 400221, total = 2 },
            { id = 10179209, name = "Cuồng Bạo", col = 3, transferId = 400227, total = 2 },
        }
    },
    {
        mapId = 105206,
        title = "Trang Sức C6",
        bosses = {
            { id = 10520601, name = "H.Thần Kiêu Ngạo", col = 1, transferId = 105206101 },
            { id = 10520602, name = "Phẫn Nộ", col = 2, transferId = 105206102 },
        }
    },
    {
        mapId = 106405,
        title = "Thí Luyện Cánh 5",
        bosses = {
            { id = 10640501, name = "Q.Vương L.Ngục", col = 1, transferId = 10640501 },
            { id = 10640502, name = "Ngang Ngược", col = 2, transferId = 10640502 },
            { id = 10640503, name = "Tà Ác", col = 3, transferId = 10640503 },
        }
    },
    {
        mapId = 106703,
        title = "Luyện Ngục C6",
        bosses = {
            { id = 10670301, name = "Q.Chủ L.Ngục", col = 1, transferId = 106703101 },
            { id = 10670302, name = "Ngang Ngược", col = 2, transferId = 106703103 },
            { id = 10670303, name = "Tà Ác", col = 3, transferId = 106703104 },
        }
    },
}

_G.Mod_MapsConfig_c7 = {
    {
        mapId = 101096,
        title = "Hoang Dã C7",
        bosses = {
            { id = 10179607, name = "Tektus", col = 1, transferId = 400216, total = 2 },
            { id = 10179608, name = "Phẫn Nộ", col = 2, transferId = 400222, total = 2 },
            { id = 10179609, name = "Cuồng Bạo", col = 3, transferId = 400228, total = 2 },
        }
    },
    {
        mapId = 105207,
        title = "Trang Sức C7",
        bosses = {
            { id = 10520701, name = "Tektus", col = 1, transferId = 105207101 },
            { id = 10520702, name = "Phẫn Nộ", col = 2, transferId = 105207102 },
        }
    },
    {
        mapId = 106406,
        title = "Thí Luyện Cánh 6",
        bosses = {
            { id = 10640601, name = "CS Rìu To", col = 1, transferId = 10640601 },
            { id = 10640602, name = "Ngang Ngược", col = 2, transferId = 10640602 },
            { id = 10640603, name = "Tà Ác", col = 3, transferId = 10640603 },
        }
    },
    {
        mapId = 106704,
        title = "Luyện Ngục C7",
        bosses = {
            { id = 10670401, name = "Tướng Quân LN", col = 1, transferId = 106704101 },
            { id = 10670402, name = "Ngang Ngược", col = 2, transferId = 106704102 },
            { id = 10670403, name = "Tà Ác", col = 3, transferId = 106704103 },
        }
    },
}

_G.Mod_MapsConfig_c8 = {
    {
        mapId = 1074,
        title = "Hoang Dã C8",
        bosses = {
            { id = 107407, name = "K.Sĩ Tử Vong", col = 1, transferId = 400229, total = 2 },
            { id = 107408, name = "Phẫn Nộ", col = 2, transferId = 400230, total = 2 },
            { id = 107409, name = "Cuồng Bạo", col = 3, transferId = 400231, total = 2 },
        }
    },
    {
        mapId = 105208,
        title = "Trang Sức C8",
        bosses = {
            { id = 10520801, name = "K.Sĩ Tử Vong", col = 1, transferId = 105208101 },
            { id = 10520802, name = "Phẫn Nộ", col = 2, transferId = 105208102 },
        }
    },
    {
        mapId = 106407,
        title = "Thí Luyện Cánh 7",
        bosses = {
            { id = 10640701, name = "T.Vệ Giáo Dài", col = 1, transferId = 10640701 },
            { id = 10640702, name = "Ngang Ngược", col = 2, transferId = 10640702 },
            { id = 10640703, name = "Tà Ác", col = 3, transferId = 10640703 },
        }
    },
    {
        mapId = 106706,
        title = "Luyện Ngục C8",
        bosses = {
            { id = 10670601, name = "Ma Đạo Phủ", col = 1, transferId = 106706101 },
            { id = 10670602, name = "Ngang Ngược", col = 2, transferId = 106706102 },
            { id = 10670603, name = "Tà Ác", col = 3, transferId = 106706103 },
        }
    },
}

_G.Mod_MapsConfig_c9 = {
    {
        mapId = 1075,
        title = "Hoang Dã C9",
        bosses = {
            { id = 107507, name = "S.Giả Ác Ma", col = 1, transferId = 400232, total = 2 },
            { id = 107508, name = "Phẫn Nộ", col = 2, transferId = 400233, total = 2 },
            { id = 107509, name = "Cuồng Bạo", col = 3, transferId = 400234, total = 2 },
        }
    },
    {
        mapId = 105209,
        title = "Trang Sức C9",
        bosses = {
            { id = 10520901, name = "S.Giả Ác Ma", col = 1, transferId = 105209101 },
            { id = 10520902, name = "Phẫn Nộ", col = 2, transferId = 105209102 },
        }
    },
    {
        mapId = 106408,
        title = "Thí Luyện Cánh 8",
        bosses = {
            { id = 10640801, name = "T.Vệ Loan Đao", col = 1, transferId = 10640801 },
            { id = 10640802, name = "Ngang Ngược", col = 2, transferId = 10640802 },
            { id = 10640803, name = "Tà Ác", col = 3, transferId = 10640803 },
        }
    },
    {
        mapId = 106707,
        title = "Luyện Ngục C9",
        bosses = {
            { id = 10670701, name = "Quỷ Biển", col = 1, transferId = 106707101 },
            { id = 10670702, name = "Ngang Ngược", col = 2, transferId = 106707102 },
            { id = 10670703, name = "Tà Ác", col = 3, transferId = 106707103 },
        }
    },
}

_G.Mod_MapsConfig_c10 = {
    {
        mapId = 1076,
        title = "Hoang Dã C10",
        bosses = {
            { id = 107607, name = "C.Sĩ Cuồng Nộ", col = 1, transferId = 400235, total = 2 },
            { id = 107608, name = "Phẫn Nộ", col = 2, transferId = 400236, total = 2 },
            { id = 107609, name = "Cuồng Bạo", col = 3, transferId = 400237, total = 2 },
        }
    },
    {
        mapId = 105210,
        title = "Trang Sức C10",
        bosses = {
            { id = 10521001, name = "C.Sĩ Cuồng Nộ", col = 1, transferId = 105210101 },
            { id = 10521002, name = "Phẫn Nộ", col = 2, transferId = 105210102 },
        }
    },
    {
        mapId = 106409,
        title = "Thí Luyện Cánh 9",
        bosses = {
            { id = 10640901, name = "T.Vệ Lam Tinh", col = 1, transferId = 10640901 },
            { id = 10640902, name = "Ngang Ngược", col = 2, transferId = 10640902 },
            { id = 10640903, name = "Tà Ác", col = 3, transferId = 10640903 },
        }
    },
    {
        mapId = 106708,
        title = "Luyện Ngục C10",
        bosses = {
            { id = 10670801, name = "Mị Ma", col = 1, transferId = 106708101 },
            { id = 10670802, name = "Ngang Ngược", col = 2, transferId = 106708102 },
            { id = 10670803, name = "Tà Ác", col = 3, transferId = 106708103 },
        }
    },
}

_G.Mod_MapsConfig_c11 = {
    {
        mapId = 10123,
        title = "Hoang Dã C11",
        bosses = {
            { id = 1012307, name = "Thủy Ma Navos", col = 1, transferId = 400238, total = 2 },
            { id = 1012308, name = "Phẫn Nộ", col = 2, transferId = 400239, total = 2 },
            { id = 1012309, name = "Cuồng Bạo", col = 3, transferId = 400240, total = 2 },
        }
    },
    {
        mapId = 105211,
        title = "Trang Sức C11",
        bosses = {
            { id = 10521101, name = "Ma Thủy Navos", col = 1, transferId = 105211101 },
            { id = 10521102, name = "Phẫn Nộ", col = 2, transferId = 105211102 },
        }
    },
    {
        mapId = 106410,
        title = "Thí Luyện Cánh 10",
        bosses = {
            { id = 10641001, name = "Vua Biển Băng Tinh", col = 1, transferId = 10641001 },
            { id = 10641002, name = "Ngang Ngược", col = 2, transferId = 10641002 },
            { id = 10641003, name = "Tà Ác", col = 3, transferId = 10641003 },
        }
    },
    {
        mapId = 106709,
        title = "Luyện Ngục C11",
        bosses = {
            { id = 10670901, name = "Thợ Mỏ Ma Tinh", col = 1, transferId = 106709101 },
            { id = 10670902, name = "Ngang Ngược", col = 2, transferId = 106709102 },
            { id = 10670903, name = "Tà Ác", col = 3, transferId = 106709103 },
        }
    },
}

_G.Mod_MapsConfig_c12 = {
    {
        mapId = 1012301,
        title = "Hoang Dã C12",
        bosses = {
            { id = 101230107, name = "Thần Hắc Ám", col = 1, transferId = 400241, total = 2 },
            { id = 101230108, name = "Phẫn Nộ", col = 2, transferId = 400242, total = 2 },
            { id = 101230109, name = "Cuồng Bạo", col = 3, transferId = 400243, total = 2 },
        }
    },
    {
        mapId = 105212,
        title = "Trang Sức C12",
        bosses = {
            { id = 10521201, name = "Thần Hắc Ám", col = 1, transferId = 105212101 },
            { id = 10521202, name = "Phẫn Nộ", col = 2, transferId = 105212102 },
        }
    },
    {
        mapId = 106411,
        title = "Thí Luyện Cánh 11",
        bosses = {
            { id = 10641101, name = "N.Cá Shaman", col = 1, transferId = 10641101 },
            { id = 10641102, name = "Ngang Ngược", col = 2, transferId = 10641102 },
            { id = 10641103, name = "Tà Ác", col = 3, transferId = 10641103 },
        }
    },
    {
        mapId = 106710,
        title = "Luyện Ngục C12",
        bosses = {
            { id = 10671001, name = "N.Khai Thác", col = 1, transferId = 106710101 },
            { id = 10671002, name = "Ngang Ngược", col = 2, transferId = 106710102 },
            { id = 10671003, name = "Tà Ác", col = 3, transferId = 106710103 },
        }
    },
}

        local function GetMapsConfigByTier(tierTag)
            if not tierTag then return _G.Mod_MapsConfig_c7 or {} end
            local tagLower = string.lower(tierTag)
            return _G["Mod_MapsConfig_" .. tagLower] or {}
        end
        _G.GetMapsConfigByTier = GetMapsConfigByTier

        _G.ModBossTab = _G.ModBossTab or "C7"

        local mapBosses = {}
        local titleUIPool = {}
        local rowUIPool = {}
        local btnUIPool = {}
        local sepUIPool = {}

        local function GetDashedLine(index, posY)
            if not sepUIPool[index] then
                local sepGo = GameObject("Separator_" .. index)
                sepGo.transform:SetParent(panelGo.transform, false)
                local rt = sepGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.sizeDelta = Vector2(700, 20)
                local txt = sepGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color(0.4, 0.4, 0.4, 1)
                txt.fontSize = 16
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                txt.text = "--------------------------------------------------------------------------------------------------------------------------"
                sepUIPool[index] = { go = sepGo, txt = txt, rt = rt }
                table.insert(_G.CoBanUIList, sepGo)
            end
            sepUIPool[index].rt.anchoredPosition = Vector2(40, posY)
            return sepUIPool[index]
        end

        
        local function GetTitleLabel(index, posY)
            if not titleUIPool[index] then
                local titleGo = GameObject("MapTitle_" .. index)
                titleGo.transform:SetParent(panelGo.transform, false)
                local rt = titleGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.sizeDelta = Vector2(720, 30)
                local txt = titleGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color(1, 0.8, 0, 1)
                txt.fontSize = 18
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                titleUIPool[index] = { go = titleGo, txt = txt, rt = rt }
                table.insert(_G.CoBanUIList, titleGo)
            end
            titleUIPool[index].rt.anchoredPosition = Vector2(40, posY)
            return titleUIPool[index]
        end
        
        local function GetRowLabel(rowIndex, posX, posY)
            if not rowUIPool[rowIndex] then
                local rowGo = GameObject("BossRow_" .. rowIndex)
                rowGo.transform:SetParent(panelGo.transform, false)
                local rt = rowGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.sizeDelta = Vector2(135, 30)
                local txt = rowGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color.white
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                rowUIPool[rowIndex] = { go = rowGo, txt = txt, rt = rt }
                table.insert(_G.CoBanUIList, rowGo)
            end
            rowUIPool[rowIndex].rt.anchoredPosition = Vector2(posX, posY)
            return rowUIPool[rowIndex]
        end
        
        local function GetLineButton(btnIndex, posX, posY, width, height)
            height = height or 30
            if not btnUIPool[btnIndex] then
                local btnGo = GameObject("LineBtn_" .. btnIndex)
                btnGo.transform:SetParent(panelGo.transform, false)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.sizeDelta = Vector2(width, height)
                
                local img = btnGo:AddComponent(typeof(CS.UnityEngine.UI.Image))
                img.color = CS.UnityEngine.Color(1, 1, 1, 0) -- Invisible graphic for raycasting
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin = Vector2(0, 0)
                txtRt.anchorMax = Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color.white
                txt.fontSize = 15
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                btnUIPool[btnIndex] = { go = btnGo, txt = txt, btn = btn, rt = rt }
                table.insert(_G.CoBanUIList, btnGo)
            end
            btnUIPool[btnIndex].rt.anchoredPosition = Vector2(posX, posY)
            btnUIPool[btnIndex].rt.sizeDelta = Vector2(width, height)
            return btnUIPool[btnIndex]
        end

        local function UpdateBossWatchUIText()
            pcall(function()
                if not isExpanded then return end
                local currentSec = (_G.Time and _G.Time.GetServerSecondTime and _G.Time.GetServerSecondTime()) or os.time()
                local currentPosY = -140
                local titleIdx = 1
                local rowIdx = 1
                local btnIdx = 1
                local sepIdx = 1
                
                local tierTags = GetAvailableTiers and GetAvailableTiers() or {"C7", "C8"}
                local isTabValid = false
                for _, tag in ipairs(tierTags) do
                    if _G.ModBossTab == tag then isTabValid = true; break end
                end
                if not isTabValid and #tierTags > 0 then
                    _G.ModBossTab = tierTags[#tierTags]
                end
                for tIdx, tag in ipairs(tierTags) do
                    local tBtn = GetLineButton(btnIdx, 40 + (tIdx - 1) * 110, currentPosY, 100, 28)
                    tBtn.go:SetActive(_G.ModMainTab == "CO_BAN")
                    tBtn.txt.alignment = TextAnchor.MiddleCenter
                    tBtn.txt.text = "<color=" .. (_G.ModBossTab == tag and "#00FF00" or "#FFFFFF") .. ">[ BOSS " .. tag .. " ]</color>"
                    tBtn.txt.fontSize = 16
                    tBtn.btn.onClick:RemoveAllListeners()
                    local thisTag = tag
                    tBtn.btn.onClick:AddListener(function()
                        _G.ModBossTab = thisTag
                        UpdateBossWatchUIText()
                    end)
                    btnIdx = btnIdx + 1
                end
                currentPosY = currentPosY - 25

                local mapsConfig = GetMapsConfigByTier(_G.ModBossTab)
                for i, mapCfg in ipairs(mapsConfig) do
                    local sep = GetDashedLine(sepIdx, currentPosY)
                    sep.go:SetActive(_G.ModMainTab == "CO_BAN")
                    sepIdx = sepIdx + 1
                    currentPosY = currentPosY - 25

                    local title = GetTitleLabel(titleIdx, currentPosY)
                    title.go:SetActive(_G.ModMainTab == "CO_BAN")
                    title.txt.text = mapCfg.title
                    
                    titleIdx = titleIdx + 1
                    currentPosY = currentPosY - 25
                    
                    local colBosses = { {}, {}, {} }
                    for _, cfg in ipairs(mapCfg.bosses) do
                        local c = cfg.col or 1
                        if c > 3 then c = 3 end
                        table.insert(colBosses[c], cfg)
                    end
                    
                    if string.find(mapCfg.title or "", "Trang Sức") and #colBosses[3] == 0 then
                        table.insert(colBosses[3], { isExitBtn = true, name = "THOÁT PB", col = 3 })
                    end
                    
                    local maxRows = math.max(#colBosses[1], #colBosses[2], #colBosses[3])
                    
                    for r = 1, maxRows do
                        for c = 1, 3 do
                            local cfg = colBosses[c][r]
                            if cfg then
                                local startX = 40 + (c - 1) * 220
                                local yPos = currentPosY - (r - 1) * 48
                                
                                local uiBtn = GetLineButton(btnIdx, startX, yPos, 215, 42)
                                uiBtn.go:SetActive(_G.ModMainTab == "CO_BAN")
                                uiBtn.txt.alignment = TextAnchor.MiddleCenter
                                
                                if cfg.isExitBtn then
                                    uiBtn.txt.text = "<color=#FF5555><b>THOÁT PB</b></color>\n<color=#FFD700>[ Rời phó bản ]</color>"
                                    uiBtn.txt.fontSize = 15
                                    uiBtn.btn.onClick:RemoveAllListeners()
                                    uiBtn.btn.onClick:AddListener(function()
                                        pcall(function()
                                            if _G.TranScriptController then
                                                if _G.TranScriptController.ReqExitInstance then _G.TranScriptController.ReqExitInstance() end
                                                if _G.TranScriptController.ReqExitAllGods then _G.TranScriptController.ReqExitAllGods() end
                                                if _G.TranScriptController.ReqExitUnionMap then _G.TranScriptController.ReqExitUnionMap() end
                                            end
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg("Đã gửi lệnh Thoát Phó Bản!")
                                            end
                                        end)
                                    end)
                                else
                                    local bossData = mapBosses[mapCfg.mapId] and mapBosses[mapCfg.mapId][cfg.id]
                                    local statusStr = "<color=#AAAAAA>(--:--)</color>"
                                local prefix = ""
                                local validLineNum = 1
                                
                                if bossData then
                                    local bestLine = nil
                                    for _, lineNum in ipairs(bossData.lineNums) do
                                        local totalAlive = bossData.aliveCount[lineNum] or 0
                                        local deadList = bossData.deadTimes[lineNum] or {}
                                        
                                        if totalAlive > 0 or #deadList > 0 then
                                            bestLine = lineNum
                                            if totalAlive > 0 then
                                                statusStr = "<color=#00FF00>[ xuất hiện ]</color>"
                                            elseif #deadList > 0 then
                                                local rt = deadList[1]
                                                local remain = math.floor(rt - currentSec)
                                                if remain <= 0 then
                                                    statusStr = "<color=#00FF00>[ xuất hiện ]</color>"
                                                else
                                                    local m = math.floor((remain % 3600) / 60)
                                                    local s = remain % 60
                                                    statusStr = string.format("<color=#AAAAAA>(%02d:%02d)</color>", m, s)
                                                end
                                            end
                                            break
                                        end
                                    end
                                    
                                    if bestLine then
                                        validLineNum = bestLine
                                    end
                                end
                                
                                uiBtn.txt.text = "<b>" .. cfg.name .. "</b>\n" .. statusStr
                                uiBtn.txt.fontSize = 15
                                
                                uiBtn.btn.onClick:RemoveAllListeners()
                                local targetMapId = mapCfg.mapId
                                local targetTransferId = cfg.transferId
                                local targetBossId = cfg.id
                                local targetLine = validLineNum
                                local targetBossName = cfg.name
                                local staticPosX = cfg.posX
                                local staticPosY = cfg.posY

                                uiBtn.btn.onClick:AddListener(function()
                                    pcall(function()
                                        local currentMapId = _G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId) or 0
                                        local currentLine = _G.SceneData and (_G.SceneData.line or _G.SceneData.cline) or 1

                                        if currentMapId ~= targetMapId or currentLine ~= targetLine then
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg("Dịch chuyển tới " .. targetBossName .. "...")
                                            end
                                            
                                            local transId = (_G.PathFinderManager and _G.PathFinderManager.GetTransIdByGroupId and _G.PathFinderManager.GetTransIdByGroupId(targetMapId)) or targetTransferId or targetMapId
                                            if transId and _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                                _G.SceneController.OnReqTransferTransmitMap(nil, { mapId = transId, line = targetLine, changeLine = true })
                                            elseif _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                                                local initialPos = (staticPosX and staticPosY and {x = staticPosX, y = staticPosY}) or {x = 100, y = 100}
                                                _G.PathFinderManager.MoveToLinePos(targetMapId, initialPos, transId, targetLine, nil, nil, nil, nil, true)
                                            end
                                        else
                                            -- Đã ở cùng Map & Line -> Tìm vị trí con Boss SỐNG gần nhất
                                            local alivePos, aliveCount = nil, 0
                                            if _G.GetAliveBossPosition then
                                                alivePos, aliveCount = _G.GetAliveBossPosition(targetBossId, targetMapId)
                                            end
                                            
                                            local targetPos = alivePos or (staticPosX and staticPosY and {x = staticPosX, y = staticPosY}) or (_G.GetBossPosition and _G.GetBossPosition(targetBossId, targetMapId))
                                            
                                            if targetPos then
                                                if _G.FloatingWordUtility then
                                                    _G.FloatingWordUtility.QuickMsg("Di chuyển đến " .. targetBossName .. " (" .. targetPos.x .. ", " .. targetPos.y .. ")...")
                                                end
                                                
                                                if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.MoveTo then
                                                    _G.RoleManager.me:MoveTo({x = targetPos.x, y = targetPos.y}, 0)
                                                elseif _G.PathFinderManager and _G.PathFinderManager.JumpMapToMoveToPos then
                                                    local targetVector = Vector2(targetPos.x, targetPos.y)
                                                    _G.PathFinderManager.JumpMapToMoveToPos(targetMapId, targetVector, nil, targetLine, nil, Purpose.None, nil, 3, true)
                                                end
                                            else
                                                if _G.FloatingWordUtility then
                                                    _G.FloatingWordUtility.QuickMsg("Chưa có tọa độ Boss " .. targetBossName)
                                                end
                                            end
                                        end
                                    end)
                                end)
                                end
                                
                                rowIdx = rowIdx + 1
                                btnIdx = btnIdx + 1
                            end
                        end
                    end
                    
                    if maxRows > 0 then
                        currentPosY = currentPosY - (maxRows * 48) - 10
                    else
                        currentPosY = currentPosY - 10
                    end
                end
                
                for i = titleIdx, #titleUIPool do
                    if titleUIPool[i] and titleUIPool[i].go then titleUIPool[i].go:SetActive(false) end
                end
                for i = rowIdx, #rowUIPool do
                    if rowUIPool[i] and rowUIPool[i].go then rowUIPool[i].go:SetActive(false) end
                end
                for i = btnIdx, #btnUIPool do
                    if btnUIPool[i] and btnUIPool[i].go then btnUIPool[i].go:SetActive(false) end
                end
                for i = sepIdx, #sepUIPool do
                    if sepUIPool[i] and sepUIPool[i].go then sepUIPool[i].go:SetActive(false) end
                end
                
                local requiredHeight = math.abs(currentPosY) + 20
                if requiredHeight < 500 then requiredHeight = 500 end
                panelRt.sizeDelta = Vector2(720, 580)
                if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
            end)
        end

        local function ParseBossData()
            pcall(function()
                if not _G.SceneData or not _G.SceneData.MonsterMapData then return end
                
                local tempBosses = {}
                for _, md in ipairs(_G.SceneData.MonsterMapData) do
                    if md.mapCount then
                        for _, v in ipairs(md.mapCount) do
                            local mapId = v.mapId
                            if not tempBosses[mapId] then tempBosses[mapId] = {} end
                            
                            local deadTimes = {}
                            if v.bossState then
                                for _, state in ipairs(v.bossState) do
                                    if state.reliveTime and state.reliveTime > 0 then
                                        table.insert(deadTimes, state.reliveTime)
                                    end
                                end
                                -- Sort deadTimes ascending so it shows smaller time first
                                table.sort(deadTimes)
                            end
                            
                            local lineNum = v.line or 1
                            if not tempBosses[mapId][md.bossId] then
                                tempBosses[mapId][md.bossId] = { lines = {}, lineNums = {}, aliveCount = {}, deadTimes = {} }
                            end
                            local bData = tempBosses[mapId][md.bossId]
                            if not bData.lines[lineNum] then
                                bData.lines[lineNum] = true
                                table.insert(bData.lineNums, lineNum)
                            end
                            bData.aliveCount[lineNum] = v.count or 0
                            bData.deadTimes[lineNum] = deadTimes
                        end
                    end
                end
                
                mapBosses = tempBosses
                _G.Mod_MapBosses = mapBosses
                UpdateBossWatchUIText()
                if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
            end)
        end
        _G.ParseBossData = ParseBossData
        ParseBossData()
        
        if _G.SavedFOV == nil then
            pcall(function()
                _G.SavedFOV = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_FOV", 35)
                _G.IsAutoRefresh = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoRefresh", 0) == 1
                _G.AutoRefreshInterval = CS.UnityEngine.PlayerPrefs.GetInt("Mod_RefreshInterval", 5)
                _G.LastRefreshSec = 0
            end)
        end

        if not _G.BossHooked then
            _G.BossHooked = true
            
            -- Tốc Chạy Hook
            local original_SetMoveSpeed = _G.Role.SetMoveSpeed
            if original_SetMoveSpeed and not _G.ModSpeedRunHooked then
                _G.ModSpeedRunHooked = true
                _G.Role.SetMoveSpeed = function(self, moveSpeed)
                    if self.isMe and _G.RunSpeedMultiplier and _G.RunSpeedMultiplier > 1.0 then
                        moveSpeed = moveSpeed * _G.RunSpeedMultiplier
                    end
                    original_SetMoveSpeed(self, moveSpeed)
                end
            end
            
            -- Tốc Đánh Cốt Lõi Hook (Can thiệp sâu vào MeData)
            local original_InitFinalAttribute = _G.MeData.InitFinalAttribute
            if original_InitFinalAttribute and not _G.ModMeDataAtkSpeedHooked then
                _G.ModMeDataAtkSpeedHooked = true
                _G.MeData.InitFinalAttribute = function(self)
                    original_InitFinalAttribute(self)
                    if _G.AtkSpeedMultiplier and _G.AtkSpeedMultiplier > 1.0 then
                                                local speedKey = _G.EAttributeType and _G.EAttributeType.attackSpeedCalculateValue
                        if speedKey and self.attributeMap and self.attributeMap[speedKey] then
                            self.attributeMap[speedKey] = math.floor(self.attributeMap[speedKey] * _G.AtkSpeedMultiplier)
                        end
                        local speedIncKey = _G.EAttributeType and _G.EAttributeType.attackSpeedIncrease
                        if speedIncKey and self.attributeMap then
                            local currentInc = self.attributeMap[speedIncKey] or 10000
                            if currentInc == 0 then currentInc = 10000 end
                            self.attributeMap[speedIncKey] = math.floor(currentInc * _G.AtkSpeedMultiplier)
                        end
                    end
                end
            end

            _G.DumpTable = function(node, depth, maxDepth)
                if depth > maxDepth then return tostring(node) end
                local t = type(node)
                if t == "table" then
                    local s = "{"
                    local ok, err = pcall(function()
                        for k, v in pairs(node) do
                            s = s .. tostring(k) .. ":" .. _G.DumpTable(v, depth + 1, maxDepth) .. ", "
                        end
                    end)
                    if not ok then s = s .. "<pairs err>" end
                    return s .. "}"
                else
                    return tostring(node)
                end
            end
            
            if not _G.Mod_Hooked_QuickShowPrompt and _G.TipUtility and _G.TipUtility.QuickShowPrompt then
                _G.Mod_Hooked_QuickShowPrompt = true
                local old_QuickShowPrompt = _G.TipUtility.QuickShowPrompt
                _G.TipUtility.QuickShowPrompt = function(commonData)
                    if commonData and commonData.id == 10 then
                        if _G.Mod_AutoFarmBoss_Enabled and _G.Mod_AutoFarmBoss_EnterHiddenMap then
                            _G.Mod_HiddenMapEnterAction = commonData.okAction
                        end
                    end
                    return old_QuickShowPrompt(commonData)
                end
            end

            local original_MonsterMapDataInit = _G.SceneData.MonsterMapDataInit
            _G.SceneData.MonsterMapDataInit = function(data)
                if original_MonsterMapDataInit then original_MonsterMapDataInit(data) end
                ParseBossData()
            end
            
            _G.Mod_AutoFarmBoss_State = _G.Mod_AutoFarmBoss_State or 0
            _G.Mod_AutoFarmBoss_Target = _G.Mod_AutoFarmBoss_Target or nil
            _G.Mod_AutoFarmBoss_NextReqTime = _G.Mod_AutoFarmBoss_NextReqTime or 0
            _G.Mod_AutoFarmBoss_WaitTime = _G.Mod_AutoFarmBoss_WaitTime or 0

            local function ExitDungeon()
                if _G.TranScriptData and _G.TranScriptData.InTranscript then
                    if _G.TranScriptController then
                        if _G.TranScriptController.ReqExitInstance then _G.TranScriptController.ReqExitInstance() end
                        if _G.TranScriptController.ReqExitAllGods then _G.TranScriptController.ReqExitAllGods() end
                    if _G.TranScriptController.ReqExitUnionMap then _G.TranScriptController.ReqExitUnionMap() end
                    end
                    --_G.Mod_DebugMsg("Đang thoát phó bản Boss...")
                    return true
                end
                return false
            end

            _G.Mod_AutoFarmBoss_Ignore = _G.Mod_AutoFarmBoss_Ignore or {}
            
            local function LogMsg(msg)
                local noWriteLog = true
                if noWriteLog then
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg(msg) end
                else
                    local t = os.date("%H:%M:%S")
                    _G.Mod_DebugMsg("[" .. t .. "] " .. msg)
                end
            end
            
            local function GetMapName(mapId)
                if not mapId then return "Unknown" end
                if _G.ConfigManager and _G.ConfigManager.MapConfig and _G.ConfigManager.MapConfig[mapId] then
                    return _G.ConfigManager.MapConfig[mapId].name or tostring(mapId)
                end
                return tostring(mapId)
            end
            _G.Mod_ExecuteAutoSmelt = function()
                local items = _G.BagInfoData and _G.BagInfoData.TotalItems
                if not items then return end
                
                local recycleItems = {}
                for k, item in pairs(items) do
                    if item and item.tblItem then
                        local subType = item.tblItem.subType or 0
                        local quality = item.tblItem.quality or 0
                        local isExcellent = false
                        
                        if item.serverInfo and item.serverInfo.excellentList and #item.serverInfo.excellentList > 0 then
                            isExcellent = true
                        end
                        if quality >= 5 then isExcellent = true end
                        
                        if isExcellent then
                            local shouldSmelt = false
                            if subType == 18 then
                                if quality == 6 and _G.Mod_SmeltConfig.Ring_C6 then shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Ring_C7 then shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Ring_C8 then shouldSmelt = true end
                            elseif subType == 19 then
                                if quality == 6 and _G.Mod_SmeltConfig.Necklace_C6 then shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Necklace_C7 then shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Necklace_C8 then shouldSmelt = true end
                            elseif subType == 26 then
                                if quality == 6 and _G.Mod_SmeltConfig.Earring_C6 then shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Earring_C7 then shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Earring_C8 then shouldSmelt = true end
                            end
                            
                            if shouldSmelt then
                                table.insert(recycleItems, item.id)
                            end
                        end
                    end
                end
                
                if #recycleItems > 0 then
                    local batch = {}
                    local batchSize = 0
                    for i, id in ipairs(recycleItems) do
                        table.insert(batch, id)
                        batchSize = batchSize + 1
                        if batchSize >= 4 or i == #recycleItems then
                            if _G.networkRequest and _G.networkRequest.ReqEquipDecompose then
                                _G.networkRequest.ReqEquipDecompose(batch)
                                LogMsg("Đã gửi yêu cầu tách " .. tostring(batchSize) .. " món trang sức Trác Việt!")
                            end
                            batch = {}
                            batchSize = 0
                        end
                    end
                end
            end

            _G.Mod_AutoFarmBoss_Update = function()
                if not _G.Mod_IsActive then
        _G.Mod_AutoFarmBoss_State = 0
        _G.Mod_AutoFarmBoss_Target = nil
        return
    end

    if not _G.Mod_AutoFarmBoss_Enabled then 
        if _G.Mod_AutoFarmBoss_State ~= 0 then
            _G.Mod_AutoFarmBoss_State = 0
            _G.Mod_AutoFarmBoss_Target = nil
            LogMsg("Đã TẮT Auto Farm.")
        end
        return 
    end
    
    local currentMapId = _G.SceneData and _G.SceneData.mapId
    local currentSec = _G.Time.GetServerSecondTime and _G.Time.GetServerSecondTime() or os.time()
    
    if currentMapId ~= 240001 then
        _G.Mod_MapAn_Recorded = false
        if _G.Mod_MapAn_SingleSkillsDisabled then
            if _G.QiJiHelperController and _G.QiJiHelperController.SetSelfSelSkill then
                for skillId, _ in pairs(_G.Mod_MapAn_SingleSkillsDisabled) do
                    _G.QiJiHelperController.SetSelfSelSkill(skillId, true)
                end
                if _G.QiJiHelperController.Save then _G.QiJiHelperController.Save() end
                if _G.UIManager and _G.UIManager.GetUiByName then
                    local ui = _G.UIManager.GetUiByName("Preference_QiJiHelperUI")
                    if ui and ui.Refresh then ui:Refresh() end
                end
            end
            _G.Mod_MapAn_SingleSkillsDisabled = nil
            LogMsg("[MAP ẨN] Đã bật lại các Skill Đơn mục tiêu")
        end
    end
    
    -- PRIORITY 0: BOSS ẨN
    if _G.UIManager and _G.UIManager.IsVisible then
        if _G.UIManager.IsVisible("Tip_MonsterTipUI") then
            if _G.Mod_AutoFarmBoss_State == 5 or _G.Mod_AutoFarmBoss_State == 6 then 
                -- Do nothing, let the state machine run below so it can finish picking up items
            else
                if not _G.Mod_MapAn_UI_SeenTime then
                    _G.Mod_MapAn_UI_SeenTime = currentSec
                end
                
                if currentSec < _G.Mod_MapAn_UI_SeenTime + 3 then
                    return -- Chờ 3 giây trước khi click vào, TẠM DỪNG các state khác
                end
                
                _G.Mod_MapAn_UI_SeenTime = nil
                
                local tipUi = _G.UIManager.GetUiByName and _G.UIManager.GetUiByName("Tip_MonsterTipUI")
                if tipUi and tipUi.DimensionalCracksData then
                    if _G.Mod_AutoFarmBoss_EnterHiddenMap then
                        local costType = _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond and 2 or 1
                        local modeStr = _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond and "Kim Cương" or "Vàng/Thường"
                        LogMsg("[BOSS ẨN] Phát hiện Cổng Map Ẩn! Triệu hồi chế độ " .. modeStr .. "...")
                        if _G.networkRequest and _G.networkRequest.ReqCallBoss then
                            _G.networkRequest.ReqCallBoss(tipUi.DimensionalCracksData.id, tipUi.DimensionalCracksData.mid, costType)
                        end
                        if _G.UIManager.Hide then _G.UIManager.Hide("Tip_MonsterTipUI") end
                        
                        _G.Mod_AutoFarmBoss_State = 0
                        _G.Mod_AutoFarmBoss_Target = nil
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                    else
                        LogMsg("[BOSS ẨN] Tính năng Tự vào Map Ẩn đang TẮT")
                        if _G.UIManager.Hide then _G.UIManager.Hide("Tip_MonsterTipUI") end
                    end
                end
                return
            end
        else
            _G.Mod_MapAn_UI_SeenTime = nil
        end
    end
    
    -- PRIORITY 1: THEO DÕI VÀ DỌN QUÁI TRONG MAP ẨN
    if _G.TranScriptData and _G.TranScriptData.InTranscript and currentMapId == 240001 then
        if not _G.Mod_MapAn_Recorded then
            _G.Mod_MapAn_Recorded = true
            _G.Mod_FarmStats = _G.Mod_FarmStats or { hidden = 0, bosses = {} }
            _G.Mod_FarmStats.hidden = _G.Mod_FarmStats.hidden + 1
            if _G.Mod_SaveFarmStats then _G.Mod_SaveFarmStats() end
            if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
            LogMsg("[MAP ẨN] Đã vào Map Ẩn! Ghi nhận thống kê +1 Map.")
        end
        
        if not _G.Mod_MapAn_SingleSkillsDisabled then
            _G.Mod_MapAn_SingleSkillsDisabled = {}
            local toggledAny = false
            if _G.QiJiHelperController and _G.QiJiHelperData and _G.ClientTable and _G.ViewData and _G.ViewData.meData and _G.ViewData.meData.skills then
                for _, v in pairs(_G.ViewData.meData.skills) do
                    local skillData = _G.ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
                    if skillData and skillData.autoSkillType == 8 then -- AutoSkillEnum.SelfSelIndSkill
                        local selfSelSkill = _G.QiJiHelperData.GetSelfSelSkill(tostring(skillData.groupId))
                        if selfSelSkill and selfSelSkill.isOpen then
                            _G.Mod_MapAn_SingleSkillsDisabled[v.sid] = true
                            _G.QiJiHelperController.SetSelfSelSkill(v.sid, false)
                            toggledAny = true
                        end
                    end
                end
            end
            if toggledAny then
                if _G.QiJiHelperController.Save then _G.QiJiHelperController.Save() end
                if _G.UIManager and _G.UIManager.GetUiByName then
                    local ui = _G.UIManager.GetUiByName("Preference_QiJiHelperUI")
                    if ui and ui.Refresh then ui:Refresh() end
                end
                LogMsg("[MAP ẨN] Đã tắt tạm các Skill Đơn mục tiêu (Chỉ dùng AOE)")
            end
        end

        if currentSec >= (_G.Mod_MapAn_LastScanTime or 0) + 5 then
            _G.Mod_MapAn_LastScanTime = currentSec
            
            local quaiThuong = 0
            local quaiBoss = 0
            local hpBoss = 0
            
            if _G.RoleManager then
                local monsters = _G.RoleManager.GetRolesByType(1) or {}
                for _, role in pairs(monsters) do
                    if role.hp and role.hp > 0 then quaiThuong = quaiThuong + 1 end
                end
                
                local bosses = _G.RoleManager.GetRolesByType(2) or {}
                for _, role in pairs(bosses) do
                    if role.hp and role.hp > 0 then 
                        quaiBoss = quaiBoss + 1 
                        hpBoss = role.hp
                    end
                end
                
                local elites = _G.RoleManager.GetRolesByType(3) or {}
                for _, role in pairs(elites) do
                    if role.hp and role.hp > 0 then 
                        quaiBoss = quaiBoss + 1 
                        hpBoss = role.hp
                    end
                end
            end
            
            _G.Mod_MapAn_LastQuaiThuong = quaiThuong
            _G.Mod_MapAn_LastQuaiBoss = quaiBoss
            _G.Mod_MapAn_LastHpBoss = hpBoss
        end
        
        local quaiThuong = _G.Mod_MapAn_LastQuaiThuong or 0
        local quaiBoss = _G.Mod_MapAn_LastQuaiBoss or 0
        local hpBoss = _G.Mod_MapAn_LastHpBoss or 0
        
        if quaiBoss > 0 or quaiThuong > 0 then
            _G.Mod_MapAn_ClearTime = nil
            
            -- Log mỗi 5s độc lập với hàm Scan
            if currentSec >= (_G.Mod_MapAn_LastLogTime or 0) + 5 then
                LogMsg(string.format("[MAP ẨN] Boss: %d", quaiBoss))
                _G.Mod_MapAn_LastLogTime = currentSec
            end
            
            if _G.RoleManager.me and _G.RoleManager.me.isAutoTaskFight and _G.RoleManager.me.isAutoTaskFight ~= "None" then
                if _G.RoleManager.me.SetAutoTaskFight then 
                    _G.RoleManager.me:SetAutoTaskFight("None") 
                end
            end
            
            if _G.RoleManager.me and _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight then
                if _G.RoleManager.me.SetAutoFight then
                    _G.RoleManager.me:SetAutoFight("AutoFight")
                end
            end
        else
            if not _G.Mod_MapAn_ClearTime then
                _G.Mod_MapAn_ClearTime = currentSec + 5
                LogMsg("[MAP ẨN] Sạch bóng quân thù! Chờ 5s nhặt đồ rồi rời đi...")
            elseif currentSec >= _G.Mod_MapAn_ClearTime then
                if _G.RoleManager.me then
                    if _G.RoleManager.me.isAutoTaskFight and _G.RoleManager.me.isAutoTaskFight ~= "None" then
                        if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
                    end
                    if _G.RoleManager.me.isAutoFight then
                        if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("None") end
                    end
                    if _G.RoleManager.me.StopMove then _G.RoleManager.me:StopMove() end
                end
                if ExitDungeon() then
                    LogMsg("[MAP ẨN] Đã tắt Auto Fight và thoát phó bản Boss Ẩn thành công!")
                end
                _G.Mod_MapAn_ClearTime = currentSec + 10 -- Tránh spam lệnh
            end
        end
        return -- DỪNG TẠI ĐÂY KHI ĐANG TRONG MAP ẨN, KHÔNG CHO CHẠY TIẾP XUỐNG LOGIC BOSS BÌNH THƯỜNG
    end
    
    if _G.Mod_AutoFarmBoss_LastState ~= _G.Mod_AutoFarmBoss_State or _G.Mod_AutoFarmBoss_LastMap ~= currentMapId then
        local mapName = GetMapName(currentMapId)
        --LogMsg(string.format("[FSM Tracker] State: %s | Map: %s (%s)", tostring(_G.Mod_AutoFarmBoss_State), tostring(currentMapId), mapName))
        _G.Mod_AutoFarmBoss_LastState = _G.Mod_AutoFarmBoss_State
        _G.Mod_AutoFarmBoss_LastMap = currentMapId
    end
    
    -- LIÊN TỤC CHẶN NATIVE AUTO-PATHING Ở CÁC STATE KHÔNG PHẢI COMBAT VÀ KHÔNG PHẢI DI CHUYỂN
    -- if _G.RoleManager.me then
    --     if _G.Mod_AutoFarmBoss_State ~= 0 and _G.Mod_AutoFarmBoss_State ~= 3 and _G.Mod_AutoFarmBoss_State ~= 4 and _G.Mod_AutoFarmBoss_State ~= 5 then
    --         if _G.RoleManager.me.isAutoTaskFight and _G.RoleManager.me.isAutoTaskFight ~= "None" then
    --             if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
    --         end
    --         if _G.RoleManager.me.isAutoFight then
    --             if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("None") end
    --         end
    --     end
    -- end
    
    if currentSec < (_G.Mod_AutoFarmBoss_WaitTime or 0) then 
        -- Đột phá WaitTime: Nếu đang đợi về Lorencia mà đã load xong Map 1001, cho đi tiếp luôn!
        if _G.Mod_AutoFarmBoss_State == 1 and currentMapId == 1001 then
            _G.Mod_AutoFarmBoss_State = 2
            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
        end
        return 
    end
    
    local status, err = pcall(function()
        -- STATE 0: BOOT & COMBAT CHECK
        if _G.Mod_AutoFarmBoss_State == 0 then
            local foundCombatBoss = nil
            if _G.RoleManager and _G.RoleManager.GetRolesByType then
                local monsterRoles = _G.RoleManager.GetRolesByType(2)
                if monsterRoles then
                    for lid, role in pairs(monsterRoles) do
                        local d = role.data
                        local mId = d and (d.configId or d.monsterId or d.templateId)
                        if mId and role.hp and role.hp > 0 then
                            local function CheckList(list)
                                if not list then return end
                                for _, mCfg in ipairs(list) do
                                    if mCfg.mapId == currentMapId and mCfg.bosses then
                                        for _, cfg in ipairs(mCfg.bosses) do
                                            if tostring(mId) == tostring(cfg.id) and _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                                return { cfg = cfg, mapCfg = mCfg, line = _G.SceneData and (_G.SceneData.line or _G.SceneData.cline) or 1 }
                                            end
                                        end
                                    end
                                end
                            end
                            local currentTiers = GetAvailableTiers and GetAvailableTiers() or {"C6", "C7"}
                            for _, tag in ipairs(currentTiers) do
                                local mapsConfig = GetMapsConfigByTier and GetMapsConfigByTier(tag)
                                if mapsConfig then
                                    foundCombatBoss = CheckList(mapsConfig)
                                    if foundCombatBoss then break end
                                end
                            end
                            if foundCombatBoss then break end
                        end
                    end
                end
            end
            
            if foundCombatBoss then
                LogMsg("Đang ở cạnh Boss " .. tostring(foundCombatBoss.cfg.name) .. ", đập luôn!")
                _G.Mod_AutoFarmBoss_Target = foundCombatBoss
                _G.Mod_AutoFarmBoss_State = 5
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
            else
                LogMsg("Bắt đầu lấy dữ liệu Boss...")
                _G.Mod_AutoFarmBoss_State = 2
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
            end
            
        -- STATE 1: IDLE / RETURN HOME (Lorencia)
        elseif _G.Mod_AutoFarmBoss_State == 1 then
            if currentMapId == 1001 then
                _G.Mod_AutoFarmBoss_State = 2
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                return
            end
            
            if ExitDungeon() then
                LogMsg("Đang thoát phó bản...")
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                return
            end
            
            local foundScroll = false
            if _G.BagInfoData and _G.BagInfoData.TotalItems then
                for _, itemData in pairs(_G.BagInfoData.TotalItems) do
                    if itemData and itemData.itemId == 20000021 then
                        if _G.networkRequest and _G.networkRequest.ReqUseItem then
                            _G.networkRequest.ReqUseItem(1, itemData.id)
                            foundScroll = true
                        end
                        break
                    end
                end
            end
            
            if not foundScroll then
                LogMsg("Không có Bùa Về Thành! Đợi 10s...")
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 10
            else
                LogMsg("Dùng Bùa Về Thành quay về Lorencia...")
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
            end
            
        -- STATE 2: FETCH DATA & FIND TARGET
        elseif _G.Mod_AutoFarmBoss_State == 2 then
            if currentSec > (_G.Mod_AutoFarmBoss_NextReqTime or 0) then
                LogMsg("Gửi yêu cầu lấy Data Boss từ Server...")
                if _G.NetManager and _G.MapMessage then
                    _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
                    _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 16})
                    _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 17})
                    _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, {type = 1})
                    _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, {type = 2})
                    _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, {type = 3})
                end
                _G.Mod_AutoFarmBoss_NextReqTime = currentSec + 15
                _G.Mod_AutoFarmBoss_ReqSentTime = currentSec
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 2
                return
            end
            
            if _G.Mod_MapBosses ~= _G.Mod_LastMapBossesRef then
                _G.Mod_LastMapBossesRef = _G.Mod_MapBosses
                _G.Mod_MapBosses_UpdateTime = currentSec
            end
            
            local timeSinceReq = currentSec - (_G.Mod_AutoFarmBoss_ReqSentTime or 0)
            local dataFresh = (_G.Mod_MapBosses_UpdateTime and _G.Mod_MapBosses_UpdateTime >= (_G.Mod_AutoFarmBoss_ReqSentTime or 0))
            
            if not dataFresh and timeSinceReq < 10 then
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                return
            elseif not dataFresh then
                LogMsg("Server phản hồi chậm. Bắt buộc dùng Data cũ...")
            end
            
            local bestBoss = nil
            local bestScore = -1
            local mapBosses = _G.Mod_MapBosses or {}
            
            local candidates = {}
            
            local function CheckConfig(mapsConfig, tierScore)
                if not mapsConfig then return end
                for _, mapCfg in ipairs(mapsConfig) do
                    if mapCfg.bosses then
                        for _, cfg in ipairs(mapCfg.bosses) do
                            if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                local ignoreKey = cfg.id .. "_" .. mapCfg.mapId
                                local ignoreUntil = _G.Mod_AutoFarmBoss_Ignore[ignoreKey] or 0
                                if currentSec > ignoreUntil then
                                    local baseScore = tierScore + math.random(1, 100)
                                    local bossData = mapBosses[mapCfg.mapId] and mapBosses[mapCfg.mapId][cfg.id]
                                    if bossData then
                                        local bestLine = nil
                                        local isAlive = false
                                        local respawnWait = 9999
                                        
                                        for _, lineNum in ipairs(bossData.lineNums) do
                                            local totalAlive = bossData.aliveCount[lineNum] or 0
                                            if totalAlive > 0 then
                                                bestLine = lineNum
                                                isAlive = true
                                                respawnWait = 0
                                                break
                                            end
                                            
                                            local deadList = bossData.deadTimes[lineNum] or {}
                                            if not isAlive and #deadList > 0 then
                                                local rt = deadList[1]
                                                if rt <= currentSec + 60 then
                                                    bestLine = lineNum
                                                    respawnWait = rt - currentSec
                                                    break
                                                end
                                            end
                                        end
                                        
                                        if bestLine then
                                            local finalScore = baseScore
                                            if isAlive then 
                                                finalScore = finalScore + 10000 
                                            else
                                                finalScore = finalScore + (60 - respawnWait) * 30
                                            end
                                            
                                            if currentMapId == mapCfg.mapId and (_G.SceneData and _G.SceneData.lineIndex == bestLine) then
                                                finalScore = finalScore + 5000
                                            end
                                            
                                            table.insert(candidates, { 
                                                name = cfg.name, id = cfg.id, 
                                                score = finalScore, isAlive = isAlive, wait = respawnWait,
                                                mapName = GetMapName(mapCfg.mapId), mapId = mapCfg.mapId,
                                                obj = { cfg = cfg, mapCfg = mapCfg, line = bestLine, isAlive = isAlive, wait = respawnWait }
                                            })
                                            
                                            if finalScore > bestScore then
                                                bestScore = finalScore
                                                bestBoss = { cfg = cfg, mapCfg = mapCfg, line = bestLine, isAlive = isAlive, wait = respawnWait }
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            local currentTiers = GetAvailableTiers and GetAvailableTiers() or {"C6", "C7"}
            for idx, tag in ipairs(currentTiers) do
                local mapsConfig = GetMapsConfigByTier and GetMapsConfigByTier(tag)
                if mapsConfig then
                    CheckConfig(mapsConfig, idx * 1000)
                end
            end
            
            if #candidates > 0 then
                table.sort(candidates, function(a, b) return a.score > b.score end)
                LogMsg("--- TOP 3 BOSSES SCORE ---")
                for i=1, math.min(3, #candidates) do
                    local c = candidates[i]
                    local st = c.isAlive and "SỐNG" or ("Chết (Còn "..c.wait.."s)")
                    LogMsg(string.format("%d. %s (ID:%s, Map:%s) | Điểm: %d | %s", i, c.name, c.id, c.mapName, c.score, st))
                end
            else
                LogMsg("--- Không có Boss phù hợp Farm ---")
                local countConfig = 0
                local countNoData = 0
                local function DebugConfig(mapsConfig)
                    if not mapsConfig then return end
                    for _, mapCfg in ipairs(mapsConfig) do
                        if mapCfg.bosses then
                            for _, cfg in ipairs(mapCfg.bosses) do
                                if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                    countConfig = countConfig + 1
                                    local ignoreKey = cfg.id .. "_" .. mapCfg.mapId
                                    local ignoreUntil = _G.Mod_AutoFarmBoss_Ignore[ignoreKey] or 0
                                    if currentSec <= ignoreUntil then
                                        LogMsg(string.format("- Bỏ qua: %s (Map %s) đang bị Block %ds", cfg.name, GetMapName(mapCfg.mapId), ignoreUntil - currentSec))
                                    else
                                        local bossData = mapBosses[mapCfg.mapId] and mapBosses[mapCfg.mapId][cfg.id]
                                        if not bossData then
                                            countNoData = countNoData + 1
                                        else
                                            for _, lineNum in ipairs(bossData.lineNums) do
                                                local totalAlive = bossData.aliveCount[lineNum] or 0
                                                local deadList = bossData.deadTimes[lineNum] or {}
                                                if totalAlive == 0 and #deadList > 0 then
                                                    local rt = deadList[1]
                                                    LogMsg(string.format("- Từ chối: %s (Còn %ds nữa mới hồi sinh)", cfg.name, rt - currentSec))
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                for _, tag in ipairs(currentTiers) do
                    local mapsConfig = GetMapsConfigByTier and GetMapsConfigByTier(tag)
                    if mapsConfig then
                        DebugConfig(mapsConfig)
                    end
                end
                --LogMsg(string.format("Tổng theo dõi: %d Boss. (Không có data từ Server cho %d Boss)", countConfig, countNoData))
            end
            
            if bestBoss then
                _G.Mod_AutoFarmBoss_Target = bestBoss
                if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                if bestBoss.isAlive or (bestBoss.wait and bestBoss.wait <= 30) then
                    LogMsg(string.format("Bắt đầu săn: %s (Map: %s)", bestBoss.cfg.name, GetMapName(bestBoss.mapCfg.mapId)))
                    _G.Mod_AutoFarmBoss_Target = bestBoss
                    if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                    
                    local currentLine = _G.SceneData and (_G.SceneData.line or _G.SceneData.cline) or 1
                    if currentMapId == bestBoss.mapCfg.mapId and currentLine == bestBoss.line then
                        _G.Mod_AutoFarmBoss_State = 4
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    else
                        _G.Mod_AutoFarmBoss_State = 3
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    end
                else
                    LogMsg(string.format("Chưa có Boss! Gần nhất: %s còn %ds", bestBoss.cfg.name, bestBoss.wait))
                    _G.Mod_AutoFarmBoss_Target = nil
                    if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                end
            else
                _G.Mod_AutoFarmBoss_Target = nil
                if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                if currentMapId == 1001 then
                    LogMsg("Không có Boss! Chờ ở Lorencia...")
                    _G.Mod_AutoFarmBoss_State = 2
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                    
                    if _G.Mod_ExecuteAutoSmelt then
                        _G.Mod_ExecuteAutoSmelt()
                    end
                else
                    if currentSec - (_G.Mod_AutoFarmBoss_ReqSentTime or 0) < 15 then
                        LogMsg("Không có Boss quanh đây. Chờ check lại...")
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                    else
                        LogMsg("Hoàn toàn không có Boss! Rút về Lorencia")
                        _G.Mod_AutoFarmBoss_State = 1
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    end
                end
            end
            
        -- STATE 3: MOVE TO BOSS (PATHFINDING / WALKING)
        elseif _G.Mod_AutoFarmBoss_State == 3 then
            local target = _G.Mod_AutoFarmBoss_Target
            if not target then
                _G.Mod_AutoFarmBoss_State = 1
                return
            end
            
            if currentMapId ~= target.mapCfg.mapId and ExitDungeon() then
                LogMsg("Đang thoát phó bản cũ trước khi di chuyển tới Boss mới...")
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                return
            end
            
            -- Bước A: Nếu chưa ở trong Map Boss, chuyển Map sang Map Boss trước
            if currentMapId ~= target.mapCfg.mapId then
                LogMsg(string.format("Đang di chuyển tới Map Boss: %s, Line %d...", GetMapName(target.mapCfg.mapId), target.line))
                _G.Mod_AutoFarmBoss_ReqIconSentMap = nil
                
                local transId = (_G.PathFinderManager and _G.PathFinderManager.GetTransIdByGroupId and _G.PathFinderManager.GetTransIdByGroupId(target.mapCfg.mapId)) or target.cfg.transferId or target.mapCfg.mapId
                if transId and _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                    _G.SceneController.OnReqTransferTransmitMap(nil, { mapId = transId, line = target.line, changeLine = true })
                elseif _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                    local initialPos = (target.cfg.posX and target.cfg.posY and {x = target.cfg.posX, y = target.cfg.posY}) or {x = 100, y = 100}
                    _G.PathFinderManager.MoveToLinePos(target.mapCfg.mapId, initialPos, transId, target.line, nil, nil, nil, nil, true)
                end
                
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                return
            end

            -- Bước B1: Vừa vào Map Boss -> Phát gói tin ReqBossIcon và chờ 2 giây để nhận dữ liệu mạng từ Server
            if _G.Mod_AutoFarmBoss_ReqIconSentMap ~= currentMapId then
                _G.Mod_AutoFarmBoss_ReqIconSentMap = currentMapId
                
                if _G.SceneData and _G.SceneData.SetMiniMapData then
                    pcall(function() _G.SceneData.SetMiniMapData(_G.SceneData.mapId or target.mapCfg.mapId, _G.SceneData.groupId or target.mapCfg.mapId) end)
                end

                if _G.NetManager and _G.NetManager.Send and _G.MapMessage and _G.MapMessage.ReqBossIcon then
                    pcall(function() _G.NetManager.Send(_G.MapMessage.ReqBossIcon) end)
                end

                LogMsg(string.format("Đã tới Map %s! Đang xin dữ liệu Minimap trạng thái Boss...", GetMapName(target.mapCfg.mapId)))
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 2
                return
            end

            -- Bước B2: Sau khi đã chờ 2s nhận dữ liệu Minimap -> Đọc vị trí Boss SỐNG
            local alivePos, aliveCount, totalCandidates = _G.GetAliveBossPosition(target.cfg.id, target.mapCfg.mapId)
            
            if totalCandidates > 0 and aliveCount == 0 then
                LogMsg(string.format("Minimap xác nhận tất cả điểm của Boss %s đã bị hạ. Trở về State 1...", target.cfg.name or ""))
                _G.Mod_AutoFarmBoss_Target = nil
                _G.Mod_AutoFarmBoss_State = 1
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                return
            end

            target.currentPos = alivePos or (target.cfg.posX and target.cfg.posY and {x = target.cfg.posX, y = target.cfg.posY}) or _G.GetBossPosition(target.cfg.id, target.mapCfg.mapId)
            local posLog = target.currentPos and string.format("(%d, %d)", target.currentPos.x, target.currentPos.y) or "(cổng)"
            
            if alivePos then
                LogMsg(string.format("Minimap báo Boss %s SỐNG tại %s! Đang chạy bộ tới mục tiêu...", target.cfg.name or "", posLog))
            else
                LogMsg(string.format("Đang chạy bộ tới tọa độ Boss: %s %s, Line %d...", GetMapName(target.mapCfg.mapId), posLog, target.line))
            end
            
            _G.Mod_AutoFarmBoss_ArrivedAtPos = false
            local onArrive = function()
                _G.Mod_AutoFarmBoss_ArrivedAtPos = true
            end

            local moved = false
            if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.MoveTo and target.currentPos then
                local cellPos = {x = target.currentPos.x, y = target.currentPos.y}
                _G.RoleManager.me:MoveTo(cellPos, 0, function(status)
                    _G.Mod_AutoFarmBoss_ArrivedAtPos = true
                end)
                moved = true
            end

            if not moved then
                local targetVector = target.currentPos and Vector2(target.currentPos.x, target.currentPos.y) or nil
                if _G.PathFinderManager and _G.PathFinderManager.JumpMapToMoveToPos then
                    _G.PathFinderManager.JumpMapToMoveToPos(target.mapCfg.mapId, targetVector, nil, target.line, nil, Purpose.None, onArrive, 3, true)
                elseif _G.JumpMapToPos and _G.JumpMapToPos.MapMoveToPos then
                    _G.JumpMapToPos.MapMoveToPos(target.mapCfg.mapId, targetVector, nil, target.line, nil, Purpose.None, onArrive)
                end
            end
            
            _G.Mod_AutoFarmBoss_State = 4
            _G.Mod_AutoFarmBoss_TargetWait = 0
            _G.Mod_AutoFarmBoss_BossWait = 0
            _G.Mod_AutoFarmBoss_DidJiggle = false
            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
            
        -- STATE 4: WAIT & VALIDATE & COMBAT
        elseif _G.Mod_AutoFarmBoss_State == 4 then
            local target = _G.Mod_AutoFarmBoss_Target
            if not target then
                _G.Mod_AutoFarmBoss_State = 1
                return
            end
            
            local currentLine = _G.SceneData and (_G.SceneData.line or _G.SceneData.cline) or 1
            if currentMapId ~= target.mapCfg.mapId or (target.line and currentLine ~= target.line) then
                _G.Mod_AutoFarmBoss_TargetWait = (_G.Mod_AutoFarmBoss_TargetWait or 0) + 1
                if _G.Mod_AutoFarmBoss_TargetWait > 15 then
                    LogMsg("Lỗi: Không thể di chuyển tới Map/Line Boss. Bỏ qua điểm này 60s")
                    _G.Mod_AutoFarmBoss_Ignore[target.cfg.id .. "_" .. target.mapCfg.mapId] = currentSec + 60
                    _G.Mod_AutoFarmBoss_Target = nil
                    _G.Mod_AutoFarmBoss_State = 1
                    _G.Mod_AutoFarmBoss_TargetWait = 0
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                else
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                end
                return
            end
            
            local foundBoss = false
            local isHighHp = false
            
            if _G.RoleManager and _G.RoleManager.GetRolesByType then
                local monsterRoles = _G.RoleManager.GetRolesByType(2)
                if monsterRoles then
                    for lid, role in pairs(monsterRoles) do
                        local d = role.data
                        local mId = d and (d.configId or d.monsterId or d.templateId) or "none"
                        
                        local nameMatch = (d and d.name and target.cfg.name and string.find(string.lower(d.name), string.lower(target.cfg.name), 1, true))
                        local idMatch = (tonumber(mId) ~= nil and tonumber(target.cfg.id) ~= nil and tonumber(mId) == tonumber(target.cfg.id))
                        
                        if role.hp and role.hp > 0 and (idMatch or nameMatch) then
                            foundBoss = true
                            local maxHp = role.maxHp or role.maxHP
                            if not maxHp or maxHp <= 0 then maxHp = role.hp end
                            
                            local isMine = (d and d.owner and _G.RoleManager.me and tostring(d.owner) == tostring(_G.RoleManager.me.id))
                            local isUnowned = (d and (tostring(d.owner) == "0" or d.owner == nil))
                            
                            if maxHp > 0 then
                                local hpPct = (role.hp / maxHp) * 100
                                LogMsg(string.format("Tìm thấy Boss %s - HP: %.2f%%", tostring(target.cfg.name or ""), hpPct))
                                
                                if hpPct >= 90 or isMine or isUnowned then
                                    isHighHp = true
                                end
                            else
                                isHighHp = true
                            end
                            break
                        end
                    end
                end
            end
            
            if foundBoss then
                if isHighHp then
                    if _G.RoleManager.me and _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("AutoFight") end
                    _G.Mod_AutoFarmBoss_State = 5
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    LogMsg("Đủ điều kiện, Bật Auto Fight")
                else
                    LogMsg("Boss bị Ks (HP < 90%). Bỏ qua 6 phút")
                    _G.Mod_AutoFarmBoss_Ignore[target.cfg.id .. "_" .. target.mapCfg.mapId] = currentSec + 360
                    _G.Mod_AutoFarmBoss_Target = nil
                    _G.Mod_AutoFarmBoss_State = 1
                    _G.Mod_AutoFarmBoss_TargetWait = 0
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                end
            else
                -- Kiểm tra khoảng cách thực tế ô lưới hoặc sự kiện OnArrive của game
                local px, py = nil, nil
                if _G.RoleManager and _G.RoleManager.me then
                    local me = _G.RoleManager.me
                    if me.cellPos then
                        px, py = me.cellPos.x, me.cellPos.y
                    elseif me.serverCoord then
                        px, py = me.serverCoord.x, me.serverCoord.y
                    elseif me.GetPosition then
                        local p = me:GetPosition()
                        if p then px, py = math.floor(p.x), math.floor(p.z) end
                    elseif me.position then
                        px, py = math.floor(me.position.x), math.floor(me.position.z or me.position.y)
                    end
                end
                
                local targetPos = target.currentPos
                local dist = 9999
                if px and py and targetPos and targetPos.x and targetPos.y then
                    local dx = px - targetPos.x
                    local dy = py - targetPos.y
                    dist = math.sqrt(dx * dx + dy * dy)
                end
                
                local hasArrived = _G.Mod_AutoFarmBoss_ArrivedAtPos or (dist <= 1.5)
                
                -- Nếu chưa thực sự tới nơi (khoảng cách > 5m và chưa nổ event OnArrive): ĐANG CHẠY BỘ BẰNG CHÂN!
                if not hasArrived then
                    _G.Mod_AutoFarmBoss_BossWait = 0
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                else
                    -- Đã thực sự đến nơi (OnArrive nổ hoặc khoảng cách <= 5m)
                    _G.Mod_AutoFarmBoss_BossWait = (_G.Mod_AutoFarmBoss_BossWait or 0) + 1
                    if _G.Mod_AutoFarmBoss_BossWait > 5 then
                        LogMsg(string.format("Đã đến tận nơi tọa độ %s nhưng không thấy Boss. Trở về State 1...", target.currentPos and string.format("(%d, %d)", target.currentPos.x, target.currentPos.y) or ""))
                        _G.Mod_AutoFarmBoss_BossWait = 0
                        _G.Mod_AutoFarmBoss_Target = nil
                        _G.Mod_AutoFarmBoss_State = 1
                        _G.Mod_AutoFarmBoss_TargetWait = 0
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    else
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                    end
                end
            end
            
        -- STATE 5: COMBAT
        elseif _G.Mod_AutoFarmBoss_State == 5 then
            local target = _G.Mod_AutoFarmBoss_Target
            if not target then
                _G.Mod_AutoFarmBoss_State = 1
                return
            end
            
            -- Đảm bảo chỉ tắt Auto Task Fight nếu nó đang bật (để không bị nháy liên tục)
            if _G.RoleManager.me and _G.RoleManager.me.isAutoTaskFight and _G.RoleManager.me.isAutoTaskFight ~= "None" then
                if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
            end
            
            -- Đảm bảo Auto Fight đang bật
            if _G.RoleManager.me and _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight then
                if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("AutoFight") end
            end
            
            local foundBoss = false
            if _G.RoleManager and _G.RoleManager.GetRolesByType then
                local monsterRoles = _G.RoleManager.GetRolesByType(2)
                if monsterRoles then
                    for lid, role in pairs(monsterRoles) do
                        local d = role.data
                        local mId = d and (d.configId or d.monsterId or d.templateId) or "none"
                        local nameMatch = (d and d.name and target.cfg.name and string.find(string.lower(d.name), string.lower(target.cfg.name), 1, true))
                        local isTarget = (_G.RoleManager.me and _G.RoleManager.me.TargetAvatar and _G.RoleManager.me.TargetAvatar == role)
                        local idMatch = (tonumber(mId) ~= nil and tonumber(target.cfg.id) ~= nil and tonumber(mId) == tonumber(target.cfg.id))
                        
                        if role.hp and role.hp > 0 and (idMatch or isTarget or nameMatch) then
                            foundBoss = true
                            local maxHp = role.maxHp or role.maxHP or role.hp or 1
                            local hpPct = (role.hp / maxHp) * 100
                            LogMsg(string.format("Đang đánh %s - HP: %.2f%%", d.name or target.cfg.name, hpPct))
                            break
                        end
                    end
                end
            end
            
            if not foundBoss then
                _G.Mod_AutoFarmBoss_TargetWait = (_G.Mod_AutoFarmBoss_TargetWait or 0) + 1
                if _G.Mod_AutoFarmBoss_TargetWait >= 2 then
                    LogMsg("Boss chết hoặc biến mất! Chờ nhặt đồ...")
                    
                    _G.Mod_FarmStats = _G.Mod_FarmStats or { hidden = 0, bosses = {} }
                    _G.Mod_FarmStats.bosses[target.cfg.id] = (_G.Mod_FarmStats.bosses[target.cfg.id] or 0) + 1
                    if _G.Mod_SaveFarmStats then _G.Mod_SaveFarmStats() end
                    if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                    
                    _G.Mod_AutoFarmBoss_TargetWait = 0
                    _G.Mod_AutoFarmBoss_State = 6
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                else
                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 2
                end
            else
                _G.Mod_AutoFarmBoss_TargetWait = 0
                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
            end
            
        -- STATE 6: LOOT WAIT
        elseif _G.Mod_AutoFarmBoss_State == 6 then
            LogMsg("Đang chờ 5s nhặt đồ rồi rút về Lorencia...")
            _G.Mod_AutoFarmBoss_Target = nil
            _G.Mod_AutoFarmBoss_State = 1 -- Đổi về 1 để bắt buộc bay về Lorencia
            _G.Mod_AutoFarmBoss_TargetWait = 0
            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
        end
    end)
    if not status then
        LogMsg("LỖI AUTO FARM: " .. tostring(err))
    end
end

            if _G.Timer and _G.Timer.StartLoop then
                _G.Timer.StartLoop(0.1, -1, function()
                    if _G.Mod_PendingManualMove then
                        pcall(function()
                            local pMove = _G.Mod_PendingManualMove
                            local currentSec = (_G.Time and _G.Time.GetServerSecondTime and _G.Time.GetServerSecondTime()) or os.time()
                            if currentSec > pMove.expireTime then
                                _G.Mod_PendingManualMove = nil
                            else
                                local curMapId = _G.SceneData and (_G.SceneData.mapId or _G.SceneData.groupId) or 0
                                local curLine = _G.SceneData and (_G.SceneData.line or _G.SceneData.cline) or 1
                                if curMapId == pMove.mapId and curLine == pMove.line then
                                    if pMove.reqSent ~= curMapId then
                                        pMove.reqSent = curMapId
                                        if _G.NetManager and _G.NetManager.Send and _G.MapMessage and _G.MapMessage.ReqBossIcon then
                                            pcall(function() _G.NetManager.Send(_G.MapMessage.ReqBossIcon) end)
                                        end
                                        pMove.waitTill = currentSec + 1
                                    elseif currentSec >= (pMove.waitTill or 0) then
                                        local alivePos, aliveCount = nil, 0
                                        if _G.GetAliveBossPosition then
                                            alivePos, aliveCount = _G.GetAliveBossPosition(pMove.bossId, pMove.mapId)
                                        end
                                        local targetPos = alivePos or (pMove.posX and pMove.posY and {x = pMove.posX, y = pMove.posY}) or (_G.GetBossPosition and _G.GetBossPosition(pMove.bossId, pMove.mapId))
                                        if targetPos and _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.MoveTo then
                                            _G.RoleManager.me:MoveTo({x = targetPos.x, y = targetPos.y}, 0)
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg("Đã tới Map! Tự động chạy tới " .. pMove.bossName .. " (" .. targetPos.x .. ", " .. targetPos.y .. ")...")
                                            end
                                            _G.Mod_PendingManualMove = nil
                                        end
                                    end
                                end
                            end
                        end)
                    end

                    if _G.Mod_CustomAttackRange and _G.Mod_CustomAttackRange > 0 then
                        if _G.QiJiHelperData and _G.QiJiHelperData.SettingData then
                            if _G.QiJiHelperData.SettingData.KillMonsterScope ~= _G.Mod_CustomAttackRange then
                                _G.QiJiHelperData.SettingData.KillMonsterScope = _G.Mod_CustomAttackRange
                            end
                        end
                    end
                    
                    if _G.Mod_ShowKundunHP then
                        local currentSec = _G.Time.GetServerSecondTime and _G.Time.GetServerSecondTime() or os.time()
                        if currentSec > (_G.Mod_LastKundunHPTime or 0) then
                            if _G.RoleManager and _G.RoleManager.GetRolesByType then
                                local monsterRoles = _G.RoleManager.GetRolesByType(2)
                                if monsterRoles then
                                    for lid, role in pairs(monsterRoles) do
                                        local d = role.data
                                        if d and d.name and string.find(string.lower(d.name), "kundun") then
                                            if role.hp and role.hp > 0 then
                                                local maxHp = role.maxHp or role.maxHP or role.hp or 1
                                                local hpPct = (role.hp / maxHp) * 100
                                                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg(string.format("%s HP: %.2f%%", d.name, hpPct)) end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            _G.Mod_LastKundunHPTime = currentSec + 3
                        end
                    end
                    
                    if _G.Mod_AutoFarmBoss_Update then
                        _G.Mod_AutoFarmBoss_Update()
                    end
                end)
            end

            local original_RefreshAncientBossData = _G.SceneData.RefreshAncientBossData
            _G.SceneData.RefreshAncientBossData = function(self, tblData)
                if original_RefreshAncientBossData then original_RefreshAncientBossData(self, tblData) end
                if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
            end
            
            if _G.Timer and _G.Timer.StartLoop then
                _G.Timer.StartLoop(0.2, -1, function()
                    pcall(function()
                        if _G.Mod_AutoAoE_BossAn then
                                local mapId = _G.SceneData and _G.SceneData.mapId or 0
                                if tonumber(mapId) == 240001 then
                                    local me = _G.RoleManager and _G.RoleManager.me
                                    local target = me and me.TargetAvatar
                                    if target and not target.isDead and me.skills then
                                        local allowedAoEPrefixes = {
                                            ["140401"] = true, -- Ma Ky Sy: Set Danh
                                        }
                                        for _, skill in pairs(me.skills) do
                                            local sid = skill.sid or skill.id or skill.skillId
                                            if sid then
                                                local prefix = tostring(sid):sub(1, 6)
                                                if allowedAoEPrefixes[prefix] then
                                                    local tblSkill = _G.ClientTable and _G.ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
                                                if tblSkill then
                                                    local cdMsg = me.cd and me.cd[tblSkill.groupId]
                                                    local endTime = cdMsg and cdMsg.endTime or 0
                                                    local publicCdMsg = me.cd and me.cd[1]
                                                    local publicEndTime = publicCdMsg and publicCdMsg.endTime or 0
                            local finalEndTime = math.max(endTime, publicEndTime)
                                                    
                                                    if _G.Time and finalEndTime <= _G.Time.GetServerTime() then
                                                        local tblaction = _G.ConfigManager and _G.ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
                                                        if tblaction and _G.SkillMgr and _G.SkillMgr.SendSkillMessage then
                                                            local coord = target.serverCoord or me.serverCoord
                                                            _G.SkillMgr.SendSkillMessage(tblSkill, tblaction, target.id, coord)
                                                            break
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end)

            _G.Timer.StartLoop(1, -1, function()
                    pcall(function()
                        local targetFov = _G.currentFOV or _G.SavedFOV or _G.Mod_Config_FOV_Max or 50
                        local cam = CS.UnityEngine.Camera.main
                        if cam and math.abs(cam.fieldOfView - targetFov) > 0.5 then
                            cam.fieldOfView = targetFov
                        end
                    end)
                    

                    
                    pcall(function()
                        if _G.AutoFightFindTargetManager and not _G.Mod_HookedAutoFightTarget then
                            _G.Mod_HookedAutoFightTarget = true
                            local original_GetMostMonster = _G.AutoFightFindTargetManager.GetMostMonsterInMonsterList
                            if original_GetMostMonster then
                                _G.AutoFightFindTargetManager.GetMostMonsterInMonsterList = function(skillRange, roleTypes, autoDoubleSkillType)
                                    if _G.Mod_AutoAoE_BossAn then
                                        local mapId = _G.SceneData and _G.SceneData.mapId or 0
                                        if tonumber(mapId) == 240001 then
                                            local target = _G.RoleManager.me.TargetAvatar
                                            if target then
                                                return target
                                            end
                                        local monsterRange = 8
                                        local monsters = _G.RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, monsterRange, _G.RoleTargetManager.GetCanAttackRole)
                                        for _, v in pairs(monsters) do
                                            if v and v.hp and v.hp > 0 then
                                                return v
                                            end
                                        end
                                        end
                                    end
                                    return original_GetMostMonster(skillRange, roleTypes, autoDoubleSkillType)
                                end
                            end
                            
                            local original_GetSpecifyMonster = _G.AutoFightFindTargetManager.GetSpecifyMonsterIntersectionNew
                            if original_GetSpecifyMonster then
                                _G.AutoFightFindTargetManager.GetSpecifyMonsterIntersectionNew = function(skillRange, specifyMonster, roleTypes)
                                    if _G.Mod_AutoAoE_BossAn then
                                        local mapId = _G.SceneData and _G.SceneData.mapId or 0
                                        if tonumber(mapId) == 240001 then
                                            return true
                                        end
                                    end
                                    return original_GetSpecifyMonster(skillRange, specifyMonster, roleTypes)
                                end
                            end
                        end
                    end)
                    
                    -- Auto PK Logic
                    if _G.Mod_AutoPK_Enabled and _G.RoleManager and _G.RoleManager.me then
                        local function modSortRole(a, b)
                            local distA = a.tempPathFindingDistance or 9999
                            local distB = b.tempPathFindingDistance or 9999
                            return distA < distB
                        end
                        local players = _G.RoleManager.GetRolesByTypeAndRangeAlive(1, 15, _G.RoleTargetManager.GetCanAttackRole)
                        if players and #players > 0 then
                            local target = nil
                            if _G.Mod_LockTarget_Enabled and _G.Mod_LockTarget_Name and _G.Mod_LockTarget_Name ~= "" then
                                for _, p in ipairs(players) do
                                    if p.name == _G.Mod_LockTarget_Name then
                                        target = p
                                        break
                                    end
                                end
                            elseif not _G.Mod_LockTarget_Enabled then
                                table.sort(players, modSortRole)
                                target = players[1]
                            end
                            
                            if target then
                                if _G.RoleManager.me.SetTarget then
                                    _G.RoleManager.me:SetTarget(target)
                                else
                                    _G.RoleManager.me.TargetAvatar = target
                                end
                                if _G.RoleManager.me.SetAutoFight then
                                    _G.RoleManager.me:SetAutoFight("ReleaseSkill")
                                end
                            end
                        end
                    end
                    
                    -- Auto PK Guild Logic
                    if _G.Mod_AutoGuildPK_Enabled and _G.RoleManager and _G.RoleManager.me and _G.NetManager and _G.RoleMessage then
                        if _G.RoleManager.me.PKMode ~= 2 then -- 2 is Guild mode
                            _G.NetManager.Send(_G.RoleMessage.ReqSetPKMode, { param = 2 })
                        end
                    end

                    if isExpanded then
                        UpdateBossWatchUIText()
                        if _G.ModUpdateCountText then _G.ModUpdateCountText() end
                        if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
                        
                        if _G.IsAutoRefresh then
                            local currentSec = _G.Time.GetServerSecondTime()
                            if currentSec - _G.LastRefreshSec >= _G.AutoRefreshInterval then
                                _G.LastRefreshSec = currentSec
                                if _G.NetManager and _G.MapMessage then
                                    _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
                                    _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 16})
                                    _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 17})
                                end
                            end
                        end
                    end
                end)
            end
        end

        local function SaveFOV(fov)
            pcall(function()
                _G.SavedFOV = fov
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_FOV", fov)
                CS.UnityEngine.PlayerPrefs.Save()
            end)
        end

        local function SaveRefreshSettings()
            pcall(function()
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoRefresh", _G.IsAutoRefresh and 1 or 0)
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_RefreshInterval", _G.AutoRefreshInterval)
                CS.UnityEngine.PlayerPrefs.Save()
            end)
        end

        local function UpdateFOVLabel()
            pcall(function()
                local cam = CS.UnityEngine.Camera.main
                if cam then
                    fovValTxt.text = "FOV: " .. tostring(math.floor(cam.fieldOfView))
                end
            end)
        end

        -- Auth UI
        local function CreateAuthUI()
            local authPanelGo = GameObject("AuthPanel")
            authPanelGo.transform:SetParent(modRoot.transform, false)
            local authRt = authPanelGo:AddComponent(typeof(RectTransform))
            authRt.anchorMin, authRt.anchorMax, authRt.pivot = Vector2(0, 0), Vector2(0, 0), Vector2(0, 0)
            authRt.anchoredPosition = Vector2(90, 70)
            authRt.sizeDelta = Vector2(600, 350)
            local authImg = authPanelGo:AddComponent(typeof(Image))
            authImg.color = Color(0.1, 0.1, 0.1, 0.95)
            authPanelGo:SetActive(false)
            _G.authPanelGo = authPanelGo
            
            local function GetMD5(str)
                local status, res = pcall(function()
                    return string.lower(tostring(CS.PCUtility.Md5(str)))
                end)
                return status and res or "ERROR_MD5"
            end
            
            local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            local function Base64Decode(data)
                local status, res = pcall(function()
                    data = string.gsub(data, '[^'..b64chars..'=]', '')
                    return (data:gsub('.', function(x)
                        if (x == '=') then return '' end
                        local r,f='',(b64chars:find(x)-1)
                        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
                        return r;
                    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
                        if (#x ~= 8) then return '' end
                        local c=0
                        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
                        return string.char(c)
                    end))
                end)
                return status and res or ""
            end

            local function FormatTokenDisplay(tok, emptyText)
                if not tok or tok == "" then return emptyText end
                if string.len(tok) <= 20 then return "Token: " .. tok end
                return "Token: " .. string.sub(tok, 1, 10) .. "..." .. string.sub(tok, -10)
            end
            
            local deviceId = CS.UnityEngine.SystemInfo.deviceUniqueIdentifier
            local deviceCode = GetMD5(deviceId .. "XOAI")
            
            local titleGo = GameObject("AuthTitle")
            titleGo.transform:SetParent(authPanelGo.transform, false)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            titleRt.anchoredPosition = Vector2(0, -20)
            titleRt.sizeDelta = Vector2(500, 40)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.text = "KÍCH HOẠT BẢN QUYỀN MOD"
            titleTxt.color, titleTxt.fontSize, titleTxt.alignment = Color.yellow, 24, TextAnchor.MiddleCenter
            if defaultFont then titleTxt.font = defaultFont end
            
            local codeGo = GameObject("AuthCodeTxt")
            codeGo.transform:SetParent(authPanelGo.transform, false)
            local codeRt = codeGo:AddComponent(typeof(RectTransform))
            codeRt.anchorMin, codeRt.anchorMax, codeRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            codeRt.anchoredPosition = Vector2(20, -70)
            codeRt.sizeDelta = Vector2(450, 60)
            local codeTxt = codeGo:AddComponent(typeof(Text))
            codeTxt.text = "Mã thiết bị (Copy gửi cho Admin):\n<color=yellow>" .. deviceCode .. "</color>"
            codeTxt.color, codeTxt.fontSize = Color.white, 16
            if defaultFont then codeTxt.font = defaultFont end
            
            local copyBtnGo = GameObject("AuthCopyBtn")
            copyBtnGo.transform:SetParent(authPanelGo.transform, false)
            local copyRt = copyBtnGo:AddComponent(typeof(RectTransform))
            copyRt.anchorMin, copyRt.anchorMax, copyRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
            copyRt.anchoredPosition = Vector2(-20, -75)
            copyRt.sizeDelta = Vector2(120, 40)
            local copyImg = copyBtnGo:AddComponent(typeof(Image))
            copyImg.color = Color(0.2, 0.6, 1, 1)
            local copyBtn = copyBtnGo:AddComponent(typeof(Button))
            local copyTxtGo = GameObject("CopyTxt")
            copyTxtGo.transform:SetParent(copyBtnGo.transform, false)
            local cTxtRt = copyTxtGo:AddComponent(typeof(RectTransform))
            cTxtRt.anchorMin, cTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            cTxtRt.offsetMin, cTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local cTxt = copyTxtGo:AddComponent(typeof(Text))
            cTxt.text = "Copy Code"
            cTxt.color, cTxt.fontSize, cTxt.alignment = Color.white, 18, TextAnchor.MiddleCenter
            if defaultFont then cTxt.font = defaultFont end
            
            copyBtn.onClick:AddListener(function()
                CS.UnityEngine.GUIUtility.systemCopyBuffer = deviceCode
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã copy mã thiết bị!") end
            end)
            
            -- Auth Token Label
            local tokenLblGo = GameObject("AuthTokenLbl")
            tokenLblGo.transform:SetParent(authPanelGo.transform, false)
            local tokenLblRt = tokenLblGo:AddComponent(typeof(RectTransform))
            tokenLblRt.anchorMin, tokenLblRt.anchorMax, tokenLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tokenLblRt.anchoredPosition = Vector2(20, -150)
            tokenLblRt.sizeDelta = Vector2(400, 20)
            local tokenLblTxt = tokenLblGo:AddComponent(typeof(Text))
            tokenLblTxt.text = "Nhập Token:"
            tokenLblTxt.color, tokenLblTxt.fontSize = Color.white, 16
            if defaultFont then tokenLblTxt.font = defaultFont end

            local tokenGo = GameObject("AuthTokenInput")
            tokenGo.transform:SetParent(authPanelGo.transform, false)
            local tokenRt = tokenGo:AddComponent(typeof(RectTransform))
            tokenRt.anchorMin, tokenRt.anchorMax, tokenRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tokenRt.anchoredPosition = Vector2(20, -170)
            tokenRt.sizeDelta = Vector2(550, 35)
            local tokenImg = tokenGo:AddComponent(typeof(Image))
            tokenImg.color = Color(1, 1, 1, 1)
            
            local textGo = GameObject("Text")
            textGo.transform:SetParent(tokenGo.transform, false)
            local txtRt = textGo:AddComponent(typeof(RectTransform))
            txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRt.offsetMin, txtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local tokenTxt = textGo:AddComponent(typeof(Text))
            local savedToken = CS.UnityEngine.PlayerPrefs.GetString("Mod_AuthToken", "")
            tokenTxt.text = savedToken
            tokenTxt.color, tokenTxt.fontSize = Color.black, 16
            tokenTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then tokenTxt.font = defaultFont end
            
            local inputField = tokenGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
            inputField.textComponent = tokenTxt
            inputField.text = savedToken
            
            inputField.onValueChanged:AddListener(function(val)
                savedToken = val
            end)
            
            local pasteBtnGo = GameObject("AuthPasteBtn")
            pasteBtnGo.transform:SetParent(authPanelGo.transform, false)
            local pasteRt = pasteBtnGo:AddComponent(typeof(RectTransform))
            pasteRt.anchorMin, pasteRt.anchorMax, pasteRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
            pasteRt.anchoredPosition = Vector2(-20, -170)
            pasteRt.sizeDelta = Vector2(120, 35)
            local pasteImg = pasteBtnGo:AddComponent(typeof(Image))
            pasteImg.color = Color(0.8, 0.4, 0, 1)
            local pasteBtn = pasteBtnGo:AddComponent(typeof(Button))
            local pasteTxtGo = GameObject("PasteTxt")
            pasteTxtGo.transform:SetParent(pasteBtnGo.transform, false)
            local pTxtRt = pasteTxtGo:AddComponent(typeof(RectTransform))
            pTxtRt.anchorMin, pTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            pTxtRt.offsetMin, pTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local pTxt = pasteTxtGo:AddComponent(typeof(Text))
            pTxt.text = "Paste Token"
            pTxt.color, pTxt.fontSize, pTxt.alignment = Color.white, 18, TextAnchor.MiddleCenter
            if defaultFont then pTxt.font = defaultFont end
            
            pasteBtn.onClick:AddListener(function()
                savedToken = CS.UnityEngine.GUIUtility.systemCopyBuffer or ""
                inputField.text = savedToken
            end)
            
            local errGo = GameObject("AuthErrTxt")
            errGo.transform:SetParent(authPanelGo.transform, false)
            local errRt = errGo:AddComponent(typeof(RectTransform))
            errRt.anchorMin, errRt.anchorMax, errRt.pivot = Vector2(0.5, 0), Vector2(0.5, 0), Vector2(0.5, 0)
            errRt.anchoredPosition = Vector2(0, 30)
            errRt.sizeDelta = Vector2(500, 30)
            local errTxt = errGo:AddComponent(typeof(Text))
            errTxt.text = ""
            errTxt.color, errTxt.fontSize, errTxt.alignment = Color.red, 18, TextAnchor.MiddleCenter
            if defaultFont then errTxt.font = defaultFont end
            
            local actBtnGo = GameObject("AuthActBtn")
            actBtnGo.transform:SetParent(authPanelGo.transform, false)
            local actRt = actBtnGo:AddComponent(typeof(RectTransform))
            actRt.anchorMin, actRt.anchorMax, actRt.pivot = Vector2(0.5, 0), Vector2(0.5, 0), Vector2(0.5, 0)
            actRt.anchoredPosition = Vector2(0, 80)
            actRt.sizeDelta = Vector2(200, 50)
            local actImg = actBtnGo:AddComponent(typeof(Image))
            actImg.color = Color(0, 0.8, 0, 1)
            local actBtn = actBtnGo:AddComponent(typeof(Button))
            local actTxtGo = GameObject("ActTxt")
            actTxtGo.transform:SetParent(actBtnGo.transform, false)
            local aTxtRt = actTxtGo:AddComponent(typeof(RectTransform))
            aTxtRt.anchorMin, aTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            aTxtRt.offsetMin, aTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local aTxt = actTxtGo:AddComponent(typeof(Text))
            aTxt.text = "KÍCH HOẠT"
            aTxt.color, aTxt.fontSize, aTxt.alignment = Color.white, 22, TextAnchor.MiddleCenter
            if defaultFont then aTxt.font = defaultFont end
            
            _G.CheckModAuth = function(tokenStr, isSilent)
                if not tokenStr or tokenStr == "" then
                    if not isSilent then errTxt.text = "Token không được để trống!" end
                    return false
                end
                local decoded = Base64Decode(tokenStr)
                if not decoded or decoded == "" then
                    if not isSilent then errTxt.text = "Token sai định dạng!" end
                    return false
                end
                local parts = {}
                for part in string.gmatch(decoded, "[^|]+") do
                    table.insert(parts, part)
                end
                if #parts ~= 4 then
                    if not isSilent then errTxt.text = "Token không hợp lệ!" end
                    return false
                end
                local pCode, pDuration, pTime, pSig = parts[1], tonumber(parts[2]), tonumber(parts[3]), parts[4]
                if pCode ~= deviceCode then
                    if not isSilent then errTxt.text = "Token không dành cho thiết bị này!" end
                    return false
                end
                local dataToHash = pCode .. "|" .. tostring(pDuration) .. "|" .. tostring(pTime) .. "MUVH_SECRET_SALT_XOAI"
                local expectedSig = GetMD5(dataToHash)
                if expectedSig ~= pSig then
                    if not isSilent then errTxt.text = "Token đã bị giả mạo!" end
                    return false
                end
                
                local currentUnixTime = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or os.time()
                local expireTime = pTime + (pDuration * 86400)
                if currentUnixTime > expireTime then
                    if not isSilent then errTxt.text = "Token đã hết hạn!" end
                    return false
                end
                
                CS.UnityEngine.PlayerPrefs.SetString("Mod_AuthToken", tokenStr)
                CS.UnityEngine.PlayerPrefs.Save()
                _G.ModAuthValid = true
                return true
            end
            
            actBtn.onClick:AddListener(function()
                if _G.CheckModAuth(savedToken, false) then
                    authPanelGo:SetActive(false)
                    if panelGo then 
                        isExpanded = true
                        panelGo:SetActive(true) 
                    end
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Kích hoạt thành công!") end
                end
            end)
            
            if savedToken ~= "" then
                if not _G.CheckModAuth(savedToken, true) then
                    errTxt.text = "Token đã lưu không hợp lệ hoặc hết hạn!"
                end
            end
        end
        _G.ModCallbacks.OnToggleMenu = function()
            pcall(function()
                if _G.Mod_IsActive then
                    if _G.authPanelGo and _G.authPanelGo.activeSelf then _G.authPanelGo:SetActive(false) end
                    isExpanded = not isExpanded
                    panelGo:SetActive(isExpanded)
                    if isExpanded then 
                        if UpdateFOVLabel then UpdateFOVLabel() end
                        RefreshMainTabs()
                        if _G.NetManager and _G.MapMessage then
                            _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
                            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 16})
                            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 17})
                        end
                    end
                else
                    if panelGo and panelGo.activeSelf then panelGo:SetActive(false) end
                    if _G.authPanelGo then
                        local showAuth = not _G.authPanelGo.activeSelf
                        _G.authPanelGo:SetActive(showAuth)
                        if showAuth and RefreshAuthPanelData then RefreshAuthPanelData() end
                    end
                end
            end)
        end
        btnComp.onClick:AddListener(_G.ModCallbacks.OnToggleMenu)

        -- Thêm UI Auto Refresh
        local refreshMinusBtnGo = GameObject("RefreshMinusBtn")
        refreshMinusBtnGo.transform:SetParent(panelGo.transform, false)
        local rmRt = refreshMinusBtnGo:AddComponent(typeof(RectTransform))
        rmRt.anchorMin = Vector2(0, 1)
        rmRt.anchorMax = Vector2(0, 1)
        rmRt.pivot = Vector2(0, 1)
        rmRt.anchoredPosition = Vector2(40, -100)
        rmRt.sizeDelta = Vector2(40, 30)
        local rmImg = refreshMinusBtnGo:AddComponent(typeof(Image))
        rmImg.color = Color(0.2, 0.2, 0.2, 1)
        table.insert(_G.CoBanUIList, refreshMinusBtnGo)
        local rmTxt = GameObject("Text"):AddComponent(typeof(Text))
        rmTxt.raycastTarget = false
        rmTxt.transform:SetParent(refreshMinusBtnGo.transform, false)
        rmTxt.text = "-"
        rmTxt.alignment = TextAnchor.MiddleCenter
        rmTxt.color = Color.white
        rmTxt.fontSize = 20
        if defaultFont then rmTxt.font = defaultFont end

        local refreshPlusBtnGo = GameObject("RefreshPlusBtn")
        refreshPlusBtnGo.transform:SetParent(panelGo.transform, false)
        local rpRt = refreshPlusBtnGo:AddComponent(typeof(RectTransform))
        rpRt.anchorMin = Vector2(0, 1)
        rpRt.anchorMax = Vector2(0, 1)
        rpRt.pivot = Vector2(0, 1)
        rpRt.anchoredPosition = Vector2(240, -100)
        rpRt.sizeDelta = Vector2(40, 30)
        local rpImg = refreshPlusBtnGo:AddComponent(typeof(Image))
        rpImg.color = Color(0.2, 0.2, 0.2, 1)
        table.insert(_G.CoBanUIList, refreshPlusBtnGo)
        local rpTxt = GameObject("Text"):AddComponent(typeof(Text))
        rpTxt.raycastTarget = false
        rpTxt.transform:SetParent(refreshPlusBtnGo.transform, false)
        rpTxt.text = "+"
        rpTxt.alignment = TextAnchor.MiddleCenter
        rpTxt.color = Color.white
        rpTxt.fontSize = 20
        if defaultFont then rpTxt.font = defaultFont end

        local refreshToggleGo = GameObject("RefreshToggleBtn")
        refreshToggleGo.transform:SetParent(panelGo.transform, false)
        local tgRt = refreshToggleGo:AddComponent(typeof(RectTransform))
        tgRt.anchorMin = Vector2(0, 1)
        tgRt.anchorMax = Vector2(0, 1)
        tgRt.pivot = Vector2(0, 1)
        tgRt.anchoredPosition = Vector2(80, -100)
        tgRt.sizeDelta = Vector2(160, 30)
        local rtImg = refreshToggleGo:AddComponent(typeof(Image))
        rtImg.color = Color(0.2, 0.2, 0.2, 0)
        table.insert(_G.CoBanUIList, refreshToggleGo)
        local rtTxt = GameObject("Text"):AddComponent(typeof(Text))
        rtTxt.raycastTarget = false
        rtTxt.transform:SetParent(refreshToggleGo.transform, false)
        rtTxt.text = "[ ] Lặp: 5s"
        rtTxt.alignment = TextAnchor.MiddleCenter
        rtTxt.color = Color(0.8, 1, 0.8, 1)
        rtTxt.fontSize = 18
        if defaultFont then rtTxt.font = defaultFont end

        local function UpdateRefreshLabel()
            pcall(function()
                if _G.IsAutoRefresh then
                    rtTxt.text = "[X] Tự làm mới: " .. _G.AutoRefreshInterval .. "s"
                else
                    rtTxt.text = "[ ] Tự làm mới: " .. _G.AutoRefreshInterval .. "s"
                end
            end)
        end
        UpdateRefreshLabel()
        RefreshMainTabs()

        local rmBtnComp = refreshMinusBtnGo:AddComponent(typeof(Button))
        rmBtnComp.onClick:AddListener(function()
            pcall(function()
                _G.AutoRefreshInterval = _G.AutoRefreshInterval - 1
                if _G.AutoRefreshInterval < 3 then _G.AutoRefreshInterval = 3 end
                UpdateRefreshLabel()
                SaveRefreshSettings()
            end)
        end)
        
        local rpBtnComp = refreshPlusBtnGo:AddComponent(typeof(Button))
        rpBtnComp.onClick:AddListener(function()
            pcall(function()
                _G.AutoRefreshInterval = _G.AutoRefreshInterval + 1
                if _G.AutoRefreshInterval > 30 then _G.AutoRefreshInterval = 30 end
                UpdateRefreshLabel()
                SaveRefreshSettings()
            end)
        end)
        
        local rtBtnComp = refreshToggleGo:AddComponent(typeof(Button))
        rtBtnComp.onClick:AddListener(function()
            pcall(function()
                _G.IsAutoRefresh = not _G.IsAutoRefresh
                _G.LastRefreshSec = _G.Time.GetServerSecondTime()
                UpdateRefreshLabel()
                SaveRefreshSettings()
            end)
        end)

        -- UI State Variables Initialization
        if _G.RunSpeedMultiplier == nil then _G.RunSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_RunSpeedMultiplier", 1.0) end
        if _G.AtkSpeedMultiplier == nil then _G.AtkSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_AtkSpeedMultiplier", 1.0) end
        if _G.Mod_CustomAttackRange == nil then _G.Mod_CustomAttackRange = CS.UnityEngine.PlayerPrefs.GetInt("Mod_CustomAttackRange", 0) end
        if _G.Mod_AntiCC == nil then _G.Mod_AntiCC = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AntiCC", 0) == 1 end
        if _G.AutoPick_FilterNormal == nil then _G.AutoPick_FilterNormal = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPick_FilterNormal", 0) == 1 end
        if _G.AutoPick_Limit == nil then _G.AutoPick_Limit = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPick_Limit", 2) end
        if _G.AutoPick_Limit == 0 then _G.AutoPick_Limit = 2 end
        _G.AutoPick_Count = 0
        _G.Mod_PickedItems = {}

        local function CreateSpeedControl(startX, yPos, prefix, valueVarName, step)
            local centerX = startX + 90
            local valGo = GameObject(valueVarName .. "_Val")
            valGo.transform:SetParent(panelGo.transform, false)
            local vRt = valGo:AddComponent(typeof(RectTransform))
            vRt.anchorMin = Vector2(0, 1)
            vRt.anchorMax = Vector2(0, 1)
            vRt.pivot = Vector2(0, 1)
            vRt.anchoredPosition = Vector2(centerX - 80, yPos)
            vRt.sizeDelta = Vector2(160, 30)
            local vTxt = valGo:AddComponent(typeof(Text))
            table.insert(_G.CoBanUIList, valGo)
            vTxt.raycastTarget = false
            vTxt.text = string.format("%s%.1fx", prefix, _G[valueVarName])
            vTxt.alignment = TextAnchor.MiddleCenter
            vTxt.color = Color(0.8, 1, 0.8, 1)
            vTxt.fontSize = 18
            if defaultFont then vTxt.font = defaultFont end

            local function createBtn(nameSuffix, offsetX, w, h, text, color)
                local btnGo = GameObject(valueVarName .. nameSuffix)
                btnGo.transform:SetParent(panelGo.transform, false)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.anchoredPosition = Vector2(centerX + offsetX, yPos)
                rt.sizeDelta = Vector2(w, h)
                local img = btnGo:AddComponent(typeof(Image))
                img.color = color
                local txtGo = GameObject(valueVarName .. nameSuffix .. "Txt")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin = Vector2(0, 0)
                txtRt.anchorMax = Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.text = text
                txt.color = Color.white
                txt.fontSize = 18
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                table.insert(_G.CoBanUIList, btnGo)
                return btnGo:AddComponent(typeof(Button))
            end

            local mBtnComp = createBtn("_Minus", -120, 40, 30, "-", Color(0.3, 0.3, 0.3, 1))
            local pBtnComp = createBtn("_Plus", 80, 40, 30, "+", Color(0.3, 0.3, 0.3, 1))
            local m5BtnComp = createBtn("_Minus5", -165, 40, 30, "-5", Color(0.5, 0.2, 0.2, 1))
            local p5BtnComp = createBtn("_Plus5", 125, 40, 30, "+5", Color(0.2, 0.5, 0.2, 1))

            local function UpdateLabel()
                vTxt.text = string.format("%s%.1fx", prefix, _G[valueVarName])
            end

            mBtnComp.onClick:AddListener(function()
                _G[valueVarName] = math.max(0.1, _G[valueVarName] - step)
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_" .. valueVarName, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            pBtnComp.onClick:AddListener(function()
                local maxCap = 10.0
                if valueVarName == "RunSpeedMultiplier" then maxCap = _G.Mod_Config_MaxMoveSpeed or 2.5
                elseif valueVarName == "AtkSpeedMultiplier" then maxCap = _G.Mod_Config_MaxAttackSpeed or 2.5 end
                _G[valueVarName] = math.min(maxCap, _G[valueVarName] + step)
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_" .. valueVarName, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            m5BtnComp.onClick:AddListener(function()
                _G[valueVarName] = math.max(0.1, _G[valueVarName] - (step * 5))
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_" .. valueVarName, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            p5BtnComp.onClick:AddListener(function()
                local maxCap = 10.0
                if valueVarName == "RunSpeedMultiplier" then maxCap = _G.Mod_Config_MaxMoveSpeed or 2.5
                elseif valueVarName == "AtkSpeedMultiplier" then maxCap = _G.Mod_Config_MaxAttackSpeed or 2.5 end
                _G[valueVarName] = math.min(maxCap, _G[valueVarName] + (step * 5))
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_" .. valueVarName, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
        end

        CreateSpeedControl(415, -60, "Tốc Chạy: ", "RunSpeedMultiplier", 0.1)
        CreateSpeedControl(415, -100, "Tốc Đánh: ", "AtkSpeedMultiplier", 0.1)

        local function CreateRangeControl(startX, yPos, prefix, valueVarName, step)
            local centerX = startX + 90
            local valGo = GameObject(valueVarName .. "_Val")
            valGo.transform:SetParent(panelGo.transform, false)
            local vRt = valGo:AddComponent(typeof(RectTransform))
            vRt.anchorMin, vRt.anchorMax, vRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            vRt.anchoredPosition = Vector2(centerX - 80, yPos)
            vRt.sizeDelta = Vector2(160, 30)
            local vTxt = valGo:AddComponent(typeof(Text))
            table.insert(_G.CoBanUIList, valGo)
            vTxt.raycastTarget = false
            vTxt.text = string.format("%s%d", prefix, _G[valueVarName] or 0)
            vTxt.alignment = TextAnchor.MiddleCenter
            vTxt.color = Color(0.8, 1, 0.8, 1)
            vTxt.fontSize = 18
            if defaultFont then vTxt.font = defaultFont end

            local function createBtn(nameSuffix, offsetX, w, h, text, color)
                local btnGo = GameObject(valueVarName .. nameSuffix)
                btnGo.transform:SetParent(panelGo.transform, false)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(centerX + offsetX, yPos)
                rt.sizeDelta = Vector2(w, h)
                local img = btnGo:AddComponent(typeof(Image))
                img.color = color
                local txtGo = GameObject(valueVarName .. nameSuffix .. "Txt")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax, txtRt.sizeDelta = Vector2(0, 0), Vector2(1, 1), Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget, txt.text, txt.color, txt.fontSize, txt.alignment = false, text, Color.white, 18, TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                table.insert(_G.CoBanUIList, btnGo)
                return btnGo:AddComponent(typeof(Button))
            end

            local mBtnComp = createBtn("_Minus", -120, 40, 30, "-", Color(0.3, 0.3, 0.3, 1))
            local pBtnComp = createBtn("_Plus", 80, 40, 30, "+", Color(0.3, 0.3, 0.3, 1))
            local m5BtnComp = createBtn("_Minus5", -165, 40, 30, "-5", Color(0.5, 0.2, 0.2, 1))
            local p5BtnComp = createBtn("_Plus5", 125, 40, 30, "+5", Color(0.2, 0.5, 0.2, 1))

            local function UpdateLabel()
                vTxt.text = string.format("%s%d", prefix, _G[valueVarName])
            end

            mBtnComp.onClick:AddListener(function()
                _G[valueVarName] = math.max(0, _G[valueVarName] - step)
                local prefKey = string.sub(valueVarName, 1, 4) == "Mod_" and valueVarName or ("Mod_" .. valueVarName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            pBtnComp.onClick:AddListener(function()
                local maxCap = _G.Mod_Config_MaxMonsterRange or 12
                _G[valueVarName] = math.min(maxCap, _G[valueVarName] + step)
                local prefKey = string.sub(valueVarName, 1, 4) == "Mod_" and valueVarName or ("Mod_" .. valueVarName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            m5BtnComp.onClick:AddListener(function()
                _G[valueVarName] = math.max(0, _G[valueVarName] - (step * 5))
                local prefKey = string.sub(valueVarName, 1, 4) == "Mod_" and valueVarName or ("Mod_" .. valueVarName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
            p5BtnComp.onClick:AddListener(function()
                local maxCap = _G.Mod_Config_MaxMonsterRange or 12
                _G[valueVarName] = math.min(maxCap, _G[valueVarName] + (step * 5))
                local prefKey = string.sub(valueVarName, 1, 4) == "Mod_" and valueVarName or ("Mod_" .. valueVarName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[valueVarName])
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
        end
        CreateRangeControl(415, -140, "Phạm Vi Bot: ", "Mod_CustomAttackRange", 1)




        local function CreateToggle(label, varName, xPos, yPos)
            local tGo = GameObject(varName .. "_Toggle")
            tGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, tGo)
            
            local tRt = tGo:AddComponent(typeof(RectTransform))
            tRt.anchorMin, tRt.anchorMax, tRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tRt.anchoredPosition = Vector2(xPos, yPos)
            tRt.sizeDelta = Vector2(280, 35)

            local bg = GameObject("Bg")
            bg.transform:SetParent(tGo.transform, false)
            local bgRt = bg:AddComponent(typeof(RectTransform))
            bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bgRt.sizeDelta = Vector2(0, 0)
            local bgImg = bg:AddComponent(typeof(Image))

            local txtGo = GameObject("Text")
            txtGo.transform:SetParent(tGo.transform, false)
            local txtRt = txtGo:AddComponent(typeof(RectTransform))
            txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRt.sizeDelta = Vector2(0, 0)
            local txt = txtGo:AddComponent(typeof(Text))
            txt.raycastTarget = false
            txt.fontSize = 16
            txt.alignment = TextAnchor.MiddleCenter
            if defaultFont then txt.font = defaultFont end

            local btn = tGo:AddComponent(typeof(Button))

            local function UpdateLabel()
                local extra = ""
                if varName == "AutoPick_Enabled" then
                    extra = " (" .. tostring(_G.AutoPick_Count or 0) .. ")"
                end
                if _G[varName] then
                    bgImg.color = Color(0.2, 0.6, 0.2, 1)
                    txt.text = label .. ": ON" .. extra
                    txt.color = Color.white
                else
                    bgImg.color = Color(0.5, 0.2, 0.2, 1)
                    txt.text = label .. ": OFF" .. extra
                    txt.color = Color.white
                end
            end
            UpdateLabel()

            if varName == "AutoPick_Enabled" then
                _G.ModUpdateCountText = function()
                    pcall(UpdateLabel)
                end
            end

            btn.onClick:AddListener(function()
                _G[varName] = not _G[varName]
                if varName == "AutoPick_Enabled" and _G[varName] then
                    _G.AutoPick_Count = 0
                    _G.LastPickupTime = 0
                    _G.Mod_IgnoredDropItems = {}
                    _G.Mod_AllDropItems = {}
                    _G.Mod_PickedItems = {}
                end
                
                local prefKey = string.sub(varName, 1, 4) == "Mod_" and varName or ("Mod_" .. varName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[varName] and 1 or 0)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
                pcall(function()
                    if _G.EventManager and _G.Event and _G.Event.QiJiHelper_SetAutoPickup then
                        _G.EventManager.Dispatch(_G.Event.QiJiHelper_SetAutoPickup)
                    end
                end)
            end)
        end

        local function CreateSmallToggle(label, varName, xPos, yPos, width)
            local tGo = GameObject(varName .. "_Toggle")
            tGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, tGo)
            
            local tRt = tGo:AddComponent(typeof(RectTransform))
            tRt.anchorMin, tRt.anchorMax, tRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tRt.anchoredPosition = Vector2(xPos, yPos)
            tRt.sizeDelta = Vector2(width, 30)

            local bg = GameObject("Bg")
            bg.transform:SetParent(tGo.transform, false)
            local bgRt = bg:AddComponent(typeof(RectTransform))
            bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bgRt.sizeDelta = Vector2(0, 0)
            local bgImg = bg:AddComponent(typeof(Image))

            local txtGo = GameObject("Text")
            txtGo.transform:SetParent(tGo.transform, false)
            local txtRt = txtGo:AddComponent(typeof(RectTransform))
            txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRt.sizeDelta = Vector2(0, 0)
            local txt = txtGo:AddComponent(typeof(Text))
            txt.raycastTarget = false
            txt.fontSize = 15
            txt.alignment = TextAnchor.MiddleCenter
            if defaultFont then txt.font = defaultFont end

            local btn = tGo:AddComponent(typeof(Button))

            local function UpdateLabel()
                if _G[varName] then
                    bgImg.color = Color(0.2, 0.5, 0.2, 1)
                    txt.text = label
                    txt.color = Color.white
                else
                    bgImg.color = Color(0.3, 0.3, 0.3, 1)
                    txt.text = label
                    txt.color = Color(0.7, 0.7, 0.7, 1)
                end
            end
            UpdateLabel()

            btn.onClick:AddListener(function()
                _G[varName] = not _G[varName]
                local prefKey = string.sub(varName, 1, 4) == "Mod_" and varName or ("Mod_" .. varName)
                CS.UnityEngine.PlayerPrefs.SetInt(prefKey, _G[varName] and 1 or 0)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLabel()
            end)
        end

        local function CreateAutoLootUI()
            local currentY = -60
            local rightColX = 20

            local titleGo = GameObject("AutoLootTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX + 10, currentY)
            titleRt.sizeDelta = Vector2(300, 20)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ NHẶT ĐỒ SIÊU TỐC ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end
            
            currentY = currentY - 45

            CreateToggle("TỰ ĐỘNG NHẶT", "AutoPick_Enabled", rightColX, currentY)
            currentY = currentY - 45

            -- Limit Control
            local lValGo = GameObject("LimitValText")
            lValGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, lValGo)
            local lvRt = lValGo:AddComponent(typeof(RectTransform))
            lvRt.anchorMin = Vector2(0, 1)
            lvRt.anchorMax = Vector2(0, 1)
            lvRt.pivot = Vector2(0, 1)
            lvRt.anchoredPosition = Vector2(rightColX, currentY)
            lvRt.sizeDelta = Vector2(180, 30)
            local lvTxt = lValGo:AddComponent(typeof(Text))
            lvTxt.raycastTarget = false
            lvTxt.text = "SỐ LƯỢNG NHẶT: " .. tostring(_G.AutoPick_Limit)
            lvTxt.color = Color.white
            lvTxt.fontSize = 18
            lvTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then lvTxt.font = defaultFont end

            local lMinusGo = GameObject("LimitMinusBtn")
            lMinusGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, lMinusGo)
            local lmRt = lMinusGo:AddComponent(typeof(RectTransform))
            lmRt.anchorMin = Vector2(0, 1)
            lmRt.anchorMax = Vector2(0, 1)
            lmRt.pivot = Vector2(0, 1)
            lmRt.anchoredPosition = Vector2(rightColX + 190, currentY)
            lmRt.sizeDelta = Vector2(40, 30)
            local lmImg = lMinusGo:AddComponent(typeof(Image))
            lmImg.color = Color(0.4, 0.4, 0.4, 1)
            local lmTxtGo = GameObject("LimitMinusText")
            lmTxtGo.transform:SetParent(lMinusGo.transform, false)
            local lmTxtRt = lmTxtGo:AddComponent(typeof(RectTransform))
            lmTxtRt.anchorMin = Vector2(0, 0)
            lmTxtRt.anchorMax = Vector2(1, 1)
            lmTxtRt.sizeDelta = Vector2(0, 0)
            local lmTxt = lmTxtGo:AddComponent(typeof(Text))
            lmTxt.raycastTarget = false
            lmTxt.text = "-"
            lmTxt.color = Color.white
            lmTxt.fontSize = 18
            lmTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then lmTxt.font = defaultFont end

            local lPlusGo = GameObject("LimitPlusBtn")
            lPlusGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, lPlusGo)
            local lpRt = lPlusGo:AddComponent(typeof(RectTransform))
            lpRt.anchorMin = Vector2(0, 1)
            lpRt.anchorMax = Vector2(0, 1)
            lpRt.pivot = Vector2(0, 1)
            lpRt.anchoredPosition = Vector2(rightColX + 240, currentY)
            lpRt.sizeDelta = Vector2(40, 30)
            local lpImg = lPlusGo:AddComponent(typeof(Image))
            lpImg.color = Color(0.4, 0.4, 0.4, 1)
            local lpTxtGo = GameObject("LimitPlusText")
            lpTxtGo.transform:SetParent(lPlusGo.transform, false)
            local lpTxtRt = lpTxtGo:AddComponent(typeof(RectTransform))
            lpTxtRt.anchorMin = Vector2(0, 0)
            lpTxtRt.anchorMax = Vector2(1, 1)
            lpTxtRt.sizeDelta = Vector2(0, 0)
            local lpTxt = lpTxtGo:AddComponent(typeof(Text))
            lpTxt.raycastTarget = false
            lpTxt.text = "+"
            lpTxt.color = Color.white
            lpTxt.fontSize = 18
            lpTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then lpTxt.font = defaultFont end

            local lmBtnComp = lMinusGo:AddComponent(typeof(Button))
            lmBtnComp.onClick:AddListener(function()
                if _G.AutoPick_Limit > 1 then
                    _G.AutoPick_Limit = _G.AutoPick_Limit - 1
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoPick_Limit", _G.AutoPick_Limit)
                    CS.UnityEngine.PlayerPrefs.Save()
                    lvTxt.text = "SỐ LƯỢNG NHẶT: " .. tostring(_G.AutoPick_Limit)
                end
            end)
            
            local lpBtnComp = lPlusGo:AddComponent(typeof(Button))
            lpBtnComp.onClick:AddListener(function()
                local maxCap = _G.Mod_Config_MaxPickupCount or 5
                if (_G.AutoPick_Limit or 0) < maxCap then
                    _G.AutoPick_Limit = (_G.AutoPick_Limit or 0) + 1
                else
                    _G.AutoPick_Limit = maxCap
                end
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoPick_Limit", _G.AutoPick_Limit)
                CS.UnityEngine.PlayerPrefs.Save()
                lvTxt.text = "SỐ LƯỢNG NHẶT: " .. tostring(_G.AutoPick_Limit)
            end)


            -- Move options from Kundun UI
            local rightColX2 = 20
            currentY = currentY - 25
            local sep2Go = GameObject("BossThapSeparator")
            sep2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, sep2Go)
            local sep2Rt = sep2Go:AddComponent(typeof(RectTransform))
            sep2Rt.anchorMin = Vector2(0, 1)
            sep2Rt.anchorMax = Vector2(0, 1)
            sep2Rt.pivot = Vector2(0, 1)
            sep2Rt.anchoredPosition = Vector2(rightColX, currentY)
            sep2Rt.sizeDelta = Vector2(310, 20)
            local sep2Txt = sep2Go:AddComponent(typeof(Text))
            sep2Txt.raycastTarget = false
            sep2Txt.color = Color(0.4, 0.4, 0.4, 1)
            sep2Txt.fontSize = 16
            sep2Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sep2Txt.font = defaultFont end
            sep2Txt.text = "------------------------------------------------------------------------------------------"
            
            currentY = currentY - 25
            local titleGo = GameObject("KundunTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin = Vector2(0, 1)
            titleRt.anchorMax = Vector2(0, 1)
            titleRt.pivot = Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX2 + 10, currentY)
            titleRt.sizeDelta = Vector2(270, 20)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ INFO KUNDUN BOSS ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end
            

            currentY = currentY - 35

            -- Tab C7 / C8
            local function CreateTabBtn(label, tabName, xPos, yPos)
                local btnGo = GameObject("NangCaoTab_" .. tabName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, yPos)
                rt.sizeDelta = Vector2(110, 30)
                
                local img = btnGo:AddComponent(typeof(CS.UnityEngine.UI.Image))
                img.color = CS.UnityEngine.Color(1, 1, 1, 0)
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color.white
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                btn.onClick:AddListener(function()
                    _G.ModBossTab = tabName
                    if _G.UpdateBossWatchUIText then _G.UpdateBossWatchUIText() end
                    if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
                end)
                return { go = btnGo, txt = txt, btn = btn }
            end
            
            local kundunTabY = currentY
            local tierTags = {"C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"}
            _G.NangCaoTabBtns = {}
            for tIdx, tag in ipairs(tierTags) do
                local tabBtn = CreateTabBtn("[ BOSS " .. tag .. " ]", tag, rightColX2 + (tIdx - 1) * 110, kundunTabY)
                tabBtn.txt.fontSize = 17
                _G.NangCaoTabBtns[tag] = tabBtn
            end
            
            currentY = kundunTabY - 30

            local rightColX3 = 20
            local sep3Go = GameObject("BossThapSeparator")
            sep3Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, sep3Go)
            local sep3Rt = sep3Go:AddComponent(typeof(RectTransform))
            sep3Rt.anchorMin = Vector2(0, 1)
            sep3Rt.anchorMax = Vector2(0, 1)
            sep3Rt.pivot = Vector2(0, 1)
            sep3Rt.anchoredPosition = Vector2(rightColX, currentY)
            sep3Rt.sizeDelta = Vector2(220, 20)
            local sep3Txt = sep3Go:AddComponent(typeof(Text))
            sep3Txt.raycastTarget = false
            sep3Txt.color = Color(0.4, 0.4, 0.4, 1)
            sep3Txt.fontSize = 16
            sep3Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sep3Txt.font = defaultFont end
            sep3Txt.text = "-------------------------------------------"

            currentY = currentY - 20
            _G.KundunUILabelPool = {}
            for i = 1, 2 do
                local rowGo = GameObject("KundunRow_" .. i)
                rowGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, rowGo)
                local rt = rowGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.anchoredPosition = Vector2(rightColX2, currentY)
                rt.sizeDelta = Vector2(260, 25)
                local txt = rowGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color.white
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                txt.text = ""
                
                table.insert(_G.KundunUILabelPool, txt)
                currentY = currentY - 30
            end

            _G.ModUpdateKundunUI = function()
                pcall(function()
                    if _G.ModMainTab ~= "NANG_CAO" then return end
                    
                    local kundunTiers = GetKundunTiers and GetKundunTiers() or {"C7", "C8"}
                    local isKundunTabValid = false
                    for _, tag in ipairs(kundunTiers) do
                        if _G.ModBossTab == tag then isKundunTabValid = true; break end
                    end
                    if not isKundunTabValid and #kundunTiers > 0 then
                        _G.ModBossTab = kundunTiers[#kundunTiers]
                    end
                    if _G.NangCaoTabBtns then
                        local activeIdx = 0
                        for _, tag in ipairs(kundunTiers) do
                            local tBtn = _G.NangCaoTabBtns[tag]
                            if tBtn then
                                tBtn.go:SetActive(true)
                                local isSel = (_G.ModBossTab == tag)
                                tBtn.txt.text = "<color=" .. (isSel and "#00FF00" or "#FFFFFF") .. ">[ BOSS " .. tag .. " ]</color>"
                                tBtn.txt.fontSize = 17
                                local rt = tBtn.go:GetComponent(typeof(CS.UnityEngine.RectTransform))
                                if rt then
                                    rt.anchoredPosition = Vector2(rightColX2 + activeIdx * 110, kundunTabY)
                                    rt.sizeDelta = Vector2(100, 30)
                                end
                                activeIdx = activeIdx + 1
                            end
                        end
                        for _, tag in ipairs(tierTags) do
                            local inKundun = false
                            for _, kt in ipairs(kundunTiers) do if kt == tag then inKundun = true; break end end
                            if not inKundun and _G.NangCaoTabBtns[tag] and _G.NangCaoTabBtns[tag].go then
                                _G.NangCaoTabBtns[tag].go:SetActive(false)
                            end
                        end
                    end
                    
                    if not _G.KundunUILabelPool then return end
                    
                    local tierNum = tonumber(string.match(_G.ModBossTab or "C8", "%d+")) or 8
                    local kundunConfigs = {}
                    if tierNum >= 4 then
                        table.insert(kundunConfigs, { name = "THÁNH CỐT:", bossType = 16, bossId = 20201000 + tierNum, limit = 70 })
                    end
                    if tierNum >= 6 then
                        local limit17 = (tierNum >= 8) and 400 or 300
                        table.insert(kundunConfigs, { name = "PHÙ VĂN:", bossType = 17, bossId = 20211000 + tierNum, limit = limit17 })
                    end
                    
                    for i = 1, 2 do
                        local txt = _G.KundunUILabelPool[i]
                        local cfg = kundunConfigs[i]
                        if txt then
                            if cfg then
                                txt.gameObject:SetActive(true)
                                local count = 0
                                local rCount = 0
                                if _G.SceneData and _G.SceneData.GetAncientBossData then
                                    local isSatisfy, info = _G.SceneData:GetAncientBossData(cfg.bossType, cfg.bossId)
                                    if info and info.refreshCount then
                                        rCount = info.refreshCount
                                    end
                                    if isSatisfy == true then
                                        count = cfg.limit
                                    elseif isSatisfy == false and info and info.count then
                                        count = info.count
                                    end
                                end
                                
                                local threshold = (cfg.bossType == 17) and 15 or 5
                                local isGreen = (cfg.limit - count <= threshold)

                                local colorTag = isGreen and "<color=#00FF00>" or "<color=#FFFFFF>"
                                if count >= cfg.limit then
                                    txt.text = cfg.name .. string.format(" %s%d / %d</color> (Hiện)", colorTag, count, cfg.limit)
                                else
                                    txt.text = cfg.name .. string.format(" %s%d / %d</color> (%d)", colorTag, count, cfg.limit, rCount)
                                end
                            else
                                txt.gameObject:SetActive(false)
                            end
                        end
                    end
                end)
            end
        end 

        CreateAutoLootUI()

        if not _G.ModAutoBossConfigTab then
            pcall(function() _G.ModAutoBossConfigTab = CS.UnityEngine.PlayerPrefs.GetString("ModAutoBossConfigTab", "C7") end)
            if not _G.ModAutoBossConfigTab or _G.ModAutoBossConfigTab == "" then _G.ModAutoBossConfigTab = "C7" end
        end
        _G.Mod_AutoFarmBoss_Config = _G.Mod_AutoFarmBoss_Config or {}
        
        local function CreateAutoBossUI()
            local startX = 20
            local UpdateTierTabs
            -- Column 1: AUTO FARM (X = 20, Y = -70)
            local masterToggleGo = GameObject("AutoFarmBossToggle")
            masterToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, masterToggleGo)
            local mtRt = masterToggleGo:AddComponent(typeof(RectTransform))
            mtRt.anchorMin, mtRt.anchorMax, mtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            mtRt.anchoredPosition = Vector2(startX, -70)
            mtRt.sizeDelta = Vector2(210, 35)
            
            local mtBg = GameObject("Bg")
            mtBg.transform:SetParent(masterToggleGo.transform, false)
            local mtBgRt = mtBg:AddComponent(typeof(RectTransform))
            mtBgRt.anchorMin, mtBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            mtBgRt.sizeDelta = Vector2(0, 0)
            local mtBgImg = mtBg:AddComponent(typeof(Image))
            
            local mtTxtGo = GameObject("Text")
            mtTxtGo.transform:SetParent(masterToggleGo.transform, false)
            local mtTxtRt = mtTxtGo:AddComponent(typeof(RectTransform))
            mtTxtRt.anchorMin, mtTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            mtTxtRt.sizeDelta = Vector2(0, 0)
            local mtTxt = mtTxtGo:AddComponent(typeof(Text))
            mtTxt.raycastTarget = false
            mtTxt.fontSize = 17
            mtTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then mtTxt.font = defaultFont end
            
            local mtBtn = masterToggleGo:AddComponent(typeof(Button))
            
            local function UpdateMasterToggle()
                if _G.Mod_AutoFarmBoss_Enabled then
                    mtBgImg.color = Color(0.2, 0.6, 0.2, 1)
                    mtTxt.text = "AUTO FARM: ON"
                    mtTxt.color = Color.white
                else
                    mtBgImg.color = Color(0.5, 0.2, 0.2, 1)
                    mtTxt.text = "AUTO FARM: OFF"
                    mtTxt.color = Color(0.9, 0.9, 0.9, 1)
                end
            end
            
            if _G.Mod_AutoFarmBoss_Enabled == nil then
                _G.Mod_AutoFarmBoss_Enabled = false
            end
            UpdateMasterToggle()
            
            mtBtn.onClick:AddListener(function()
                _G.Mod_AutoFarmBoss_Enabled = not _G.Mod_AutoFarmBoss_Enabled
                UpdateMasterToggle()
            end)
            
            -- Column 2: TỰ VÀO MAP ẨN & VÀO ẨN KC (X = 245)
            local hiddenToggleGo = GameObject("AutoHiddenMapToggle")
            hiddenToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, hiddenToggleGo)
            local htRt = hiddenToggleGo:AddComponent(typeof(RectTransform))
            htRt.anchorMin, htRt.anchorMax, htRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            htRt.anchoredPosition = Vector2(245, -70)
            htRt.sizeDelta = Vector2(210, 35)
            
            local htBg = GameObject("Bg")
            htBg.transform:SetParent(hiddenToggleGo.transform, false)
            local htBgRt = htBg:AddComponent(typeof(RectTransform))
            htBgRt.anchorMin, htBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            htBgRt.sizeDelta = Vector2(0, 0)
            local htBgImg = htBg:AddComponent(typeof(Image))
            
            local htTxtGo = GameObject("Text")
            htTxtGo.transform:SetParent(hiddenToggleGo.transform, false)
            local htTxtRt = htTxtGo:AddComponent(typeof(RectTransform))
            htTxtRt.anchorMin, htTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            htTxtRt.sizeDelta = Vector2(0, 0)
            local htTxt = htTxtGo:AddComponent(typeof(Text))
            htTxt.raycastTarget = false
            htTxt.fontSize = 15
            htTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then htTxt.font = defaultFont end
            
            local htBtn = hiddenToggleGo:AddComponent(typeof(Button))
            
            local function UpdateHiddenToggle()
                if _G.Mod_AutoFarmBoss_EnterHiddenMap then
                    htBgImg.color = Color(0.2, 0.4, 0.6, 1)
                    htTxt.text = "TỰ VÀO MAP ẨN: BẬT"
                    htTxt.color = Color.white
                else
                    htBgImg.color = Color(0.3, 0.3, 0.3, 1)
                    htTxt.text = "TỰ VÀO MAP ẨN: TẮT"
                    htTxt.color = Color(0.8, 0.8, 0.8, 1)
                end
            end
            
            if _G.Mod_AutoFarmBoss_EnterHiddenMap == nil then
                pcall(function()
                    _G.Mod_AutoFarmBoss_EnterHiddenMap = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoFarmBoss_EnterHiddenMap", 0) == 1)
                end)
                if _G.Mod_AutoFarmBoss_EnterHiddenMap == nil then _G.Mod_AutoFarmBoss_EnterHiddenMap = false end
            end
            UpdateHiddenToggle()
            
            htBtn.onClick:AddListener(function()
                _G.Mod_AutoFarmBoss_EnterHiddenMap = not _G.Mod_AutoFarmBoss_EnterHiddenMap
                pcall(function()
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoFarmBoss_EnterHiddenMap", _G.Mod_AutoFarmBoss_EnterHiddenMap and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
                UpdateHiddenToggle()
            end)

            -- Column 2 Sub-toggle: VÀO ẨN KC (X = 245, Y = -115)
            local diamondToggleGo = GameObject("AutoHiddenDiamondToggle")
            diamondToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, diamondToggleGo)
            local dtRt = diamondToggleGo:AddComponent(typeof(RectTransform))
            dtRt.anchorMin, dtRt.anchorMax, dtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            dtRt.anchoredPosition = Vector2(245, -115)
            dtRt.sizeDelta = Vector2(210, 35)
            
            local dtBg = GameObject("Bg")
            dtBg.transform:SetParent(diamondToggleGo.transform, false)
            local dtBgRt = dtBg:AddComponent(typeof(RectTransform))
            dtBgRt.anchorMin, dtBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            dtBgRt.sizeDelta = Vector2(0, 0)
            local dtBgImg = dtBg:AddComponent(typeof(Image))
            
            local dtTxtGo = GameObject("Text")
            dtTxtGo.transform:SetParent(diamondToggleGo.transform, false)
            local dtTxtRt = dtTxtGo:AddComponent(typeof(RectTransform))
            dtTxtRt.anchorMin, dtTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            dtTxtRt.sizeDelta = Vector2(0, 0)
            local dtTxt = dtTxtGo:AddComponent(typeof(Text))
            dtTxt.raycastTarget = false
            dtTxt.fontSize = 15
            dtTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then dtTxt.font = defaultFont end
            
            local dtBtn = diamondToggleGo:AddComponent(typeof(Button))
            
            local function UpdateDiamondToggle()
                if _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond then
                    dtBgImg.color = Color(0.5, 0.2, 0.6, 1)
                    dtTxt.text = "VÀO ẨN KC: BẬT"
                    dtTxt.color = Color.white
                else
                    dtBgImg.color = Color(0.3, 0.3, 0.3, 1)
                    dtTxt.text = "VÀO ẨN KC: TẮT"
                    dtTxt.color = Color(0.8, 0.8, 0.8, 1)
                end
            end
            
            if _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond == nil then
                pcall(function()
                    _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoFarmBoss_EnterHiddenMap_Diamond", 0) == 1)
                end)
                if _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond == nil then _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond = false end
            end
            UpdateDiamondToggle()
            
            dtBtn.onClick:AddListener(function()
                _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond = not _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond
                pcall(function()
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoFarmBoss_EnterHiddenMap_Diamond", _G.Mod_AutoFarmBoss_EnterHiddenMap_Diamond and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
                UpdateDiamondToggle()
            end)

            -- Column 3: AUTO SMELT (X = 470, Y = -70, -100, -130)
            local smeltStartX = 470
            local smeltY = -70
            
            local smeltRowsData = {
                { label = "TÁCH NHẪN", prefix = "Ring", y = smeltY },
                { label = "TÁCH DÂY", prefix = "Necklace", y = smeltY - 30 },
                { label = "TÁCH KHUYÊN", prefix = "Earring", y = smeltY - 60 }
            }
            local smeltTogglePool = {}

            for _, rData in ipairs(smeltRowsData) do
                local lblGo = GameObject("SmeltLbl_" .. rData.prefix)
                lblGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, lblGo)
                local lblRt = lblGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(smeltStartX, rData.y)
                lblRt.sizeDelta = Vector2(100, 25)
                local lblTxt = lblGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = rData.label
                lblTxt.color = Color.white
                lblTxt.fontSize = 14
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end
            end

            local function CreateSmeltToggle(idx)
                local btnGo = GameObject("SmeltToggle_" .. idx)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                
                local bgImg = btnGo:AddComponent(typeof(CS.UnityEngine.UI.Image))
                bgImg.raycastTarget = true
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 14
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, rt = rt, bgImg = bgImg, txt = txt, btn = btn }
            end

            local function GetSmeltTiers()
                local x = GetPlayerReincarnationLevel and GetPlayerReincarnationLevel() or 7
                local tiers = {}
                if x - 2 >= 3 then table.insert(tiers, "C" .. tostring(x - 2)) end
                if x - 1 >= 3 then table.insert(tiers, "C" .. tostring(x - 1)) end
                table.insert(tiers, "C" .. tostring(x))
                return tiers
            end

            local function UpdateSmeltToggles()
                local smeltTiers = GetSmeltTiers()
                local poolIdx = 1
                for _, rData in ipairs(smeltRowsData) do
                    for sIdx, tag in ipairs(smeltTiers) do
                        local varName = rData.prefix .. "_" .. tag
                        local bData = smeltTogglePool[poolIdx]
                        if not bData then
                            bData = CreateSmeltToggle(poolIdx)
                            table.insert(smeltTogglePool, bData)
                        end
                        bData.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                        bData.rt.anchoredPosition = Vector2(smeltStartX + 102 + (sIdx - 1) * 40, rData.y)
                        bData.rt.sizeDelta = Vector2(36, 25)
                        bData.txt.text = tag
                        
                        if _G.Mod_SmeltConfig == nil then _G.Mod_SmeltConfig = {} end
                        if _G.Mod_SmeltConfig[varName] == nil then
                            pcall(function() _G.Mod_SmeltConfig[varName] = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_Smelt_" .. varName, 0) == 1) end)
                            if _G.Mod_SmeltConfig[varName] == nil then _G.Mod_SmeltConfig[varName] = false end
                        end
                        
                        local function updateVisual()
                            if _G.Mod_SmeltConfig[varName] then
                                bData.bgImg.color = Color(0.2, 0.6, 0.2, 1)
                                bData.txt.color = Color.white
                            else
                                bData.bgImg.color = Color(0.3, 0.3, 0.3, 1)
                                bData.txt.color = Color(0.8, 0.8, 0.8, 1)
                            end
                        end
                        updateVisual()
                        
                        bData.btn.onClick:RemoveAllListeners()
                        bData.btn.onClick:AddListener(function()
                            _G.Mod_SmeltConfig[varName] = not _G.Mod_SmeltConfig[varName]
                            pcall(function()
                                CS.UnityEngine.PlayerPrefs.SetInt("Mod_Smelt_" .. varName, _G.Mod_SmeltConfig[varName] and 1 or 0)
                                CS.UnityEngine.PlayerPrefs.Save()
                            end)
                            updateVisual()
                        end)
                        poolIdx = poolIdx + 1
                    end
                end
                for i = poolIdx, #smeltTogglePool do
                    if smeltTogglePool[i] and smeltTogglePool[i].go then
                        smeltTogglePool[i].go:SetActive(false)
                    end
                end
            end
            
            local currentY = -170
            
            local sepAutoTopGo = GameObject("AutoBossTopSeparator")
            sepAutoTopGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, sepAutoTopGo)
            local sepAutoTopRt = sepAutoTopGo:AddComponent(typeof(RectTransform))
            sepAutoTopRt.anchorMin, sepAutoTopRt.anchorMax, sepAutoTopRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            sepAutoTopRt.anchoredPosition = Vector2(startX, -150)
            sepAutoTopRt.sizeDelta = Vector2(700, 20)
            local sepAutoTopTxt = sepAutoTopGo:AddComponent(typeof(Text))
            sepAutoTopTxt.raycastTarget = false
            sepAutoTopTxt.color = Color(0.4, 0.4, 0.4, 1)
            sepAutoTopTxt.fontSize = 16
            sepAutoTopTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sepAutoTopTxt.font = defaultFont end
            sepAutoTopTxt.text = "--------------------------------------------------------------------------------------------------------------------------"

            -- Tier Tabs (C3-C12)
            local function CreateTierTab(label, tabName, xPos)
                local btnGo = GameObject("AutoBossTier_" .. tabName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, currentY)
                rt.sizeDelta = Vector2(100, 30)
                
                local img = btnGo:AddComponent(typeof(CS.UnityEngine.UI.Image))
                img.color = Color(1, 1, 1, 0)
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                btn.onClick:AddListener(function()
                    _G.ModAutoBossConfigTab = tabName
                    pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModAutoBossConfigTab", tabName) end)
                    if UpdateTierTabs then UpdateTierTabs() end
                end)
                return { go = btnGo, txt = txt, btn = btn }
            end
            
            local tierTags = {"C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"}
            local tierTabBtns = {}
            for tIdx, tag in ipairs(tierTags) do
                local tBtn = CreateTierTab("[ BOSS " .. tag .. " ]", tag, startX + (tIdx - 1) * 110)
                tierTabBtns[tag] = tBtn
            end
            
            currentY = currentY - 40
            local gridStartY = currentY
            
            local configPool = {}
            
            local function CreateConfigBtn(idx)
                local btnGo = GameObject("AutoBossConfig_" .. idx)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                
                local img = btnGo:AddComponent(typeof(CS.UnityEngine.UI.Image))
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 17
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, rt = rt, img = img, txt = txt, btn = btn }
            end
            
            UpdateTierTabs = function()
                if _G.ModMainTab ~= "AUTO_BOSS" then return end
                
                if UpdateSmeltToggles then UpdateSmeltToggles() end
                
                local currentTiers = GetAvailableTiers and GetAvailableTiers() or {"C6", "C7"}
                local isTabValid = false
                for _, tag in ipairs(currentTiers) do
                    if _G.ModAutoBossConfigTab == tag then isTabValid = true; break end
                end
                if not isTabValid and #currentTiers > 0 then
                    _G.ModAutoBossConfigTab = currentTiers[#currentTiers]
                end
                local activeIdx = 0
                for _, tag in ipairs(currentTiers) do
                    local tBtn = tierTabBtns[tag]
                    if tBtn then
                        tBtn.go:SetActive(true)
                        local isSel = (_G.ModAutoBossConfigTab == tag)
                        tBtn.txt.text = "<color=" .. (isSel and "#00FF00" or "#FFFFFF") .. ">[ BOSS " .. tag .. " ]</color>"
                        tBtn.txt.fontSize = 17
                        local rt = tBtn.go:GetComponent(typeof(CS.UnityEngine.RectTransform))
                        if rt then
                            rt.anchoredPosition = Vector2(startX + activeIdx * 110, -170)
                            rt.sizeDelta = Vector2(100, 30)
                        end
                        activeIdx = activeIdx + 1
                    end
                end
                for _, tag in ipairs(tierTags) do
                    local inAvailable = false
                    for _, ct in ipairs(currentTiers) do if ct == tag then inAvailable = true; break end end
                    if not inAvailable and tierTabBtns[tag] and tierTabBtns[tag].go then
                        tierTabBtns[tag].go:SetActive(false)
                    end
                end
                
                -- Hide all config toggles
                for _, btnData in ipairs(configPool) do
                    btnData.go:SetActive(false)
                end
                
                -- Render the current tier's bosses
                local mapsConfig = GetMapsConfigByTier and GetMapsConfigByTier(_G.ModAutoBossConfigTab) or {}
                local py = gridStartY
                local poolIdx = 1
                
                if mapsConfig and #mapsConfig > 0 then
                    for _, mapCfg in ipairs(mapsConfig) do
                        -- Title
                        local btnData = configPool[poolIdx]
                        if not btnData then
                            btnData = CreateConfigBtn(poolIdx)
                            table.insert(configPool, btnData)
                        end
                        btnData.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                        btnData.rt.anchoredPosition = Vector2(startX, py)
                        btnData.rt.sizeDelta = Vector2(680, 25)
                        
                        local mapTotalKilled = 0
                        if _G.Mod_FarmStats and _G.Mod_FarmStats.bosses and mapCfg.bosses then
                            for _, cfg in ipairs(mapCfg.bosses) do
                                mapTotalKilled = mapTotalKilled + (_G.Mod_FarmStats.bosses[cfg.id] or 0)
                            end
                        end
                        local titleStr = mapCfg.title
                        if mapTotalKilled > 0 then
                            titleStr = titleStr .. " (" .. mapTotalKilled .. ")"
                        end
                        
                        btnData.txt.text = "<color=#FFFF00>--- " .. titleStr .. " ---</color>"
                        btnData.txt.alignment = TextAnchor.MiddleCenter
                        btnData.img.color = Color(1, 1, 1, 0)
                        btnData.btn.onClick:RemoveAllListeners()
                        poolIdx = poolIdx + 1
                        py = py - 30
                        
                        -- Bosses in columns
                        local colBosses = { {}, {}, {} }
                        for _, cfg in ipairs(mapCfg.bosses) do
                            local c = cfg.col or 1
                            if c > 3 then c = 3 end
                            table.insert(colBosses[c], cfg)
                        end
                        local maxRows = math.max(#colBosses[1], #colBosses[2], #colBosses[3])
                        for r = 1, maxRows do
                            for c = 1, 3 do
                                local cfg = colBosses[c][r]
                                if cfg then
                                    local px = startX + (c - 1) * 220
                                    local bData = configPool[poolIdx]
                                    if not bData then
                                        bData = CreateConfigBtn(poolIdx)
                                        table.insert(configPool, bData)
                                    end
                                    bData.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                                    bData.rt.anchoredPosition = Vector2(px, py)
                                    bData.rt.sizeDelta = Vector2(210, 30)
                                    bData.txt.alignment = TextAnchor.MiddleCenter
                                    
                                    -- Load State
                                    if _G.Mod_AutoFarmBoss_Config[cfg.id] == nil then
                                        _G.Mod_AutoFarmBoss_Config[cfg.id] = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoBoss_" .. cfg.id, 0) == 1
                                    end
                                    
                                    local function updateBossBtnColor()
                                        local isTarget = _G.Mod_AutoFarmBoss_Target and _G.Mod_AutoFarmBoss_Target.cfg.id == cfg.id
                                        
                                        local killedCount = (_G.Mod_FarmStats and _G.Mod_FarmStats.bosses and _G.Mod_FarmStats.bosses[cfg.id]) or 0
                                        local btnLabel = cfg.name
                                        if killedCount > 0 then btnLabel = btnLabel .. " (" .. killedCount .. ")" end
                                        
                                        if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                            bData.img.color = Color(0.2, 0.5, 0.2, 1)
                                            if isTarget then
                                                bData.txt.text = "<color=#FF0000>=> " .. btnLabel .. "</color>"
                                            else
                                                bData.txt.text = btnLabel
                                            end
                                            bData.txt.color = Color.white
                                        else
                                            bData.img.color = Color(0.3, 0.3, 0.3, 1)
                                            bData.txt.text = btnLabel
                                            bData.txt.color = Color(0.7, 0.7, 0.7, 1)
                                        end
                                    end
                                    updateBossBtnColor()
                                    
                                    bData.btn.onClick:RemoveAllListeners()
                                    bData.btn.onClick:AddListener(function()
                                        _G.Mod_AutoFarmBoss_Config[cfg.id] = not _G.Mod_AutoFarmBoss_Config[cfg.id]
                                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoBoss_" .. cfg.id, _G.Mod_AutoFarmBoss_Config[cfg.id] and 1 or 0)
                                        CS.UnityEngine.PlayerPrefs.Save()
                                        updateBossBtnColor()
                                    end)
                                    
                                    poolIdx = poolIdx + 1
                                end
                            end
                            py = py - 35
                        end
                        py = py - 10
                    end
                end
                
                if not _G.Mod_FarmStatsUI then
                    local containerGo = GameObject("FarmStatsContainer")
                    containerGo.transform:SetParent(panelGo.transform, false)
                    table.insert(_G.AutoBossUIList, containerGo)
                    local rt = containerGo:AddComponent(typeof(RectTransform))
                    rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                    _G.Mod_FarmStatsUI = { go = containerGo, rt = rt }
                    
                    local resetBtnGo = GameObject("ResetBtn")
                    resetBtnGo.transform:SetParent(containerGo.transform, false)
                    local rBtnRt = resetBtnGo:AddComponent(typeof(RectTransform))
                    rBtnRt.anchorMin, rBtnRt.anchorMax, rBtnRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                    rBtnRt.anchoredPosition = Vector2(0, 0)
                    rBtnRt.sizeDelta = Vector2(130, 30)
                    local rBtnImg = resetBtnGo:AddComponent(typeof(Image))
                    rBtnImg.color = Color(0.6, 0.2, 0.2, 1)
                    local rBtnTxtGo = GameObject("Text")
                    rBtnTxtGo.transform:SetParent(resetBtnGo.transform, false)
                    local rBtnTxtRt = rBtnTxtGo:AddComponent(typeof(RectTransform))
                    rBtnTxtRt.anchorMin, rBtnTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                    rBtnTxtRt.sizeDelta = Vector2(0, 0)
                    local rBtnTxt = rBtnTxtGo:AddComponent(typeof(Text))
                    rBtnTxt.raycastTarget = false
                    rBtnTxt.text = "RESET THỐNG KÊ"
                    rBtnTxt.color = Color.white
                    rBtnTxt.fontSize = 14
                    rBtnTxt.alignment = TextAnchor.MiddleCenter
                    if defaultFont then rBtnTxt.font = defaultFont end
                    local rBtn = resetBtnGo:AddComponent(typeof(Button))
                    rBtn.onClick:AddListener(function()
                        _G.Mod_FarmStats = { hidden = 0, bosses = {} }
                        if _G.Mod_SaveFarmStats then _G.Mod_SaveFarmStats() end
                        if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                    end)
                    
                    local statTxtGo = GameObject("StatText")
                    statTxtGo.transform:SetParent(containerGo.transform, false)
                    local sTxtRt = statTxtGo:AddComponent(typeof(RectTransform))
                    sTxtRt.anchorMin, sTxtRt.anchorMax, sTxtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                    sTxtRt.anchoredPosition = Vector2(150, 0)
                    sTxtRt.sizeDelta = Vector2(500, 30)
                    local sTxt = statTxtGo:AddComponent(typeof(Text))
                    sTxt.raycastTarget = false
                    sTxt.color = Color(1, 0.8, 0, 1)
                    sTxt.fontSize = 15
                    sTxt.alignment = TextAnchor.MiddleLeft
                    if defaultFont then sTxt.font = defaultFont end
                    _G.Mod_FarmStatsUI.sTxt = sTxt
                end
                
                _G.Mod_FarmStatsUI.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                _G.Mod_FarmStatsUI.rt.anchoredPosition = Vector2(startX, py - 10)
                
                _G.Mod_FarmStats = _G.Mod_FarmStats or { hidden = 0, bosses = {} }
                local currentTiers = GetAvailableTiers and GetAvailableTiers() or {"C7", "C8"}
                local prevTag = currentTiers[1] or "C7"
                local currTag = currentTiers[2] or prevTag

                local prevCfg = GetMapsConfigByTier and GetMapsConfigByTier(prevTag) or {}
                local currCfg = (currTag ~= prevTag and GetMapsConfigByTier) and GetMapsConfigByTier(currTag) or {}

                local totalPrev, totalCurr = 0, 0
                if _G.Mod_FarmStats.bosses then
                    for id, count in pairs(_G.Mod_FarmStats.bosses) do
                        local inPrev = false
                        for _, map in ipairs(prevCfg) do
                            if map.bosses then
                                for _, b in ipairs(map.bosses) do
                                    if b.id == id then inPrev = true; break end
                                end
                            end
                            if inPrev then break end
                        end
                        if inPrev then
                            totalPrev = totalPrev + count
                        else
                            local inCurr = false
                            for _, map in ipairs(currCfg) do
                                if map.bosses then
                                    for _, b in ipairs(map.bosses) do
                                        if b.id == id then inCurr = true; break end
                                    end
                                end
                                if inCurr then break end
                            end
                            if inCurr then
                                totalCurr = totalCurr + count
                            end
                        end
                    end
                end

                local hiddenCount = _G.Mod_FarmStats.hidden or 0
                if prevTag ~= currTag then
                    _G.Mod_FarmStatsUI.sTxt.text = string.format("BOSS ẨN: %d       TỔNG BOSS %s: %d       TỔNG BOSS %s: %d", hiddenCount, prevTag, totalPrev, currTag, totalCurr)
                else
                    _G.Mod_FarmStatsUI.sTxt.text = string.format("BOSS ẨN: %d       TỔNG BOSS %s: %d", hiddenCount, prevTag, totalPrev)
                end
            end
            
            _G.ModRefreshAutoBossConfigUI = function()
                if _G.ModMainTab == "AUTO_BOSS" then
                    UpdateTierTabs()
                end
            end
            UpdateTierTabs()
        end
        CreateAutoBossUI()

        local function CreateKundunUI()
            local currentY = -60
            local rightColX2 = 380
            
            -- Vạch dọc phân cách
            local vLineGo = GameObject("VerticalSeparator")
            vLineGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, vLineGo)
            local vLineRt = vLineGo:AddComponent(typeof(RectTransform))
            vLineRt.anchorMin, vLineRt.anchorMax, vLineRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            vLineRt.anchoredPosition = Vector2(360, -45)
            vLineRt.sizeDelta = Vector2(2, 535)
            local vLineImg = vLineGo:AddComponent(typeof(Image))
            vLineImg.color = Color(0.4, 0.4, 0.4, 1)

            local ChucNangTitle = GameObject("ChucNangTitle")
            ChucNangTitle.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, ChucNangTitle)
            local titleRt = ChucNangTitle:AddComponent(typeof(RectTransform))
            titleRt.anchorMin = Vector2(0, 1)
            titleRt.anchorMax = Vector2(0, 1)
            titleRt.pivot = Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX2 + 10, currentY)
            titleRt.sizeDelta = Vector2(250, 20)
            local ChucNangTitleTxt = ChucNangTitle:AddComponent(typeof(Text))
            ChucNangTitleTxt.raycastTarget = false
            ChucNangTitleTxt.text = "[ CHỨC NĂNG HỖ TRỢ ]"
            ChucNangTitleTxt.color = Color(1, 0.8, 0, 1)
            ChucNangTitleTxt.fontSize = 18
            ChucNangTitleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then ChucNangTitleTxt.font = defaultFont end
            
            currentY = currentY - 45
            
            CreateToggle("HIỆN MÁU KUNDUN", "Mod_ShowKundunHP", rightColX2, currentY)
            currentY = currentY - 45
            
            CreateToggle("AUTO PK GUILD", "Mod_AutoGuildPK_Enabled", rightColX2, currentY)
            currentY = currentY - 45

            -- Toggle KHÓA MỤC TIÊU
            local tGoLock = GameObject("Mod_LockTarget_Enabled_Toggle")
            tGoLock.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, tGoLock)
            
            local tRtLock = tGoLock:AddComponent(typeof(RectTransform))
            tRtLock.anchorMin, tRtLock.anchorMax, tRtLock.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tRtLock.anchoredPosition = Vector2(rightColX2, currentY)
            tRtLock.sizeDelta = Vector2(140, 30)

            local bgLock = GameObject("Bg")
            bgLock.transform:SetParent(tGoLock.transform, false)
            local bgRtLock = bgLock:AddComponent(typeof(RectTransform))
            bgRtLock.anchorMin, bgRtLock.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bgRtLock.sizeDelta = Vector2(0, 0)
            local bgImgLock = bgLock:AddComponent(typeof(Image))

            local txtGoLock = GameObject("Text")
            txtGoLock.transform:SetParent(tGoLock.transform, false)
            local txtRtLock = txtGoLock:AddComponent(typeof(RectTransform))
            txtRtLock.anchorMin, txtRtLock.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRtLock.sizeDelta = Vector2(0, 0)
            local txtLock = txtGoLock:AddComponent(typeof(Text))
            txtLock.raycastTarget = false
            txtLock.fontSize = 15
            txtLock.alignment = TextAnchor.MiddleCenter
            if defaultFont then txtLock.font = defaultFont end

            local btnLock = tGoLock:AddComponent(typeof(Button))
            
            if _G.Mod_LockTarget_Enabled == nil then
                _G.Mod_LockTarget_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_LockTarget_Enabled", 0) == 1
            end

            local function UpdateLockLabel()
                if _G.Mod_LockTarget_Enabled then
                    bgImgLock.color = Color(0.2, 0.5, 0.2, 1)
                    txtLock.text = "KHÓA MỤC TIÊU"
                    txtLock.color = Color.white
                else
                    bgImgLock.color = Color(0.3, 0.3, 0.3, 1)
                    txtLock.text = "KHÓA MỤC TIÊU"
                    txtLock.color = Color(0.7, 0.7, 0.7, 1)
                end
            end
            UpdateLockLabel()

            btnLock.onClick:AddListener(function()
                _G.Mod_LockTarget_Enabled = not _G.Mod_LockTarget_Enabled
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_LockTarget_Enabled", _G.Mod_LockTarget_Enabled and 1 or 0)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateLockLabel()
            end)

            -- Text Field cho Khóa mục tiêu
            local lockTgtGo = GameObject("LockTargetInput")
            lockTgtGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, lockTgtGo)
            local lockRt = lockTgtGo:AddComponent(typeof(RectTransform))
            lockRt.anchorMin, lockRt.anchorMax, lockRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            lockRt.anchoredPosition = Vector2(rightColX2 + 145, currentY)
            lockRt.sizeDelta = Vector2(115, 30)
            
            local lockBg = GameObject("Bg")
            lockBg.transform:SetParent(lockTgtGo.transform, false)
            local lockBgRt = lockBg:AddComponent(typeof(RectTransform))
            lockBgRt.anchorMin, lockBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            lockBgRt.sizeDelta = Vector2(0, 0)
            local lockImg = lockBg:AddComponent(typeof(Image))
            lockImg.color = Color(0.1, 0.1, 0.1, 1)
            
            local lockTxtGo = GameObject("Text")
            lockTxtGo.transform:SetParent(lockTgtGo.transform, false)
            local lockTxtRt = lockTxtGo:AddComponent(typeof(RectTransform))
            lockTxtRt.anchorMin, lockTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            lockTxtRt.offsetMin, lockTxtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local lockTxt = lockTxtGo:AddComponent(typeof(Text))
            
            if _G.Mod_LockTarget_Name == nil then
                _G.Mod_LockTarget_Name = CS.UnityEngine.PlayerPrefs.GetString("Mod_LockTarget_Name", "")
            end
            
            lockTxt.text = _G.Mod_LockTarget_Name
            lockTxt.color, lockTxt.fontSize = Color.white, 15
            lockTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then lockTxt.font = defaultFont end
            
            pcall(function()
                local InputFieldType = InputField or (CS.UnityEngine.UI and CS.UnityEngine.UI.InputField)
                if InputFieldType then
                    local lockField = lockTgtGo:AddComponent(typeof(InputFieldType))
                    if lockField then
                        lockField.textComponent = lockTxt
                        lockField.text = _G.Mod_LockTarget_Name
                        if lockField.onValueChanged then
                            lockField.onValueChanged:AddListener(function(val)
                                _G.Mod_LockTarget_Name = val
                                pcall(function()
                                    CS.UnityEngine.PlayerPrefs.SetString("Mod_LockTarget_Name", val)
                                    CS.UnityEngine.PlayerPrefs.Save()
                                end)
                            end)
                        end
                    end
                end
            end)
        end
        CreateKundunUI()

        -- Main Tab Buttons
        local width = 220
        
        local tabCoBanGo = GameObject("TabCoBanBtn")
        _G.tabCoBanGo = tabCoBanGo
        tabCoBanGo.transform:SetParent(panelGo.transform, false)
        local tabCoBanRt = tabCoBanGo:AddComponent(typeof(RectTransform))
        tabCoBanRt.anchorMin, tabCoBanRt.anchorMax, tabCoBanRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tabCoBanRt.anchoredPosition = Vector2(10, -10)
        tabCoBanRt.sizeDelta = Vector2(width, 40)
        local tabCoBanImg = tabCoBanGo:AddComponent(typeof(Image))
        
        local tabCoBanTxtGo = GameObject("Text")
        tabCoBanTxtGo.transform:SetParent(tabCoBanGo.transform, false)
        local tabCoBanTxtRt = tabCoBanTxtGo:AddComponent(typeof(RectTransform))
        tabCoBanTxtRt.anchorMin, tabCoBanTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        tabCoBanTxtRt.sizeDelta = Vector2(0, 0)
        local tabCoBanTxt = tabCoBanTxtGo:AddComponent(typeof(Text))
        tabCoBanTxt.raycastTarget, tabCoBanTxt.fontSize, tabCoBanTxt.alignment = false, 20, TextAnchor.MiddleCenter
        if defaultFont then tabCoBanTxt.font = defaultFont end
        local tabCoBanBtn = tabCoBanGo:AddComponent(typeof(Button))

        local tabNangCaoGo = GameObject("TabNangCaoBtn")
        _G.tabNangCaoGo = tabNangCaoGo
        tabNangCaoGo.transform:SetParent(panelGo.transform, false)
        local tabNangCaoRt = tabNangCaoGo:AddComponent(typeof(RectTransform))
        tabNangCaoRt.anchorMin, tabNangCaoRt.anchorMax, tabNangCaoRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tabNangCaoRt.anchoredPosition = Vector2(10 + width + 10, -10)
        tabNangCaoRt.sizeDelta = Vector2(width, 40)
        local tabNangCaoImg = tabNangCaoGo:AddComponent(typeof(Image))
        
        local tabNangCaoTxtGo = GameObject("Text")
        tabNangCaoTxtGo.transform:SetParent(tabNangCaoGo.transform, false)
        local tabNangCaoTxtRt = tabNangCaoTxtGo:AddComponent(typeof(RectTransform))
        tabNangCaoTxtRt.anchorMin, tabNangCaoTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        tabNangCaoTxtRt.sizeDelta = Vector2(0, 0)
        local tabNangCaoTxt = tabNangCaoTxtGo:AddComponent(typeof(Text))
        tabNangCaoTxt.raycastTarget, tabNangCaoTxt.fontSize, tabNangCaoTxt.alignment = false, 20, TextAnchor.MiddleCenter
        if defaultFont then tabNangCaoTxt.font = defaultFont end
        local tabNangCaoBtn = tabNangCaoGo:AddComponent(typeof(Button))

        local tabAutoBossGo = GameObject("TabAutoBossBtn")
        _G.tabAutoBossGo = tabAutoBossGo
        tabAutoBossGo.transform:SetParent(panelGo.transform, false)
        local tabAutoBossRt = tabAutoBossGo:AddComponent(typeof(RectTransform))
        tabAutoBossRt.anchorMin, tabAutoBossRt.anchorMax, tabAutoBossRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tabAutoBossRt.anchoredPosition = Vector2(10 + (width + 10) * 2, -10)
        tabAutoBossRt.sizeDelta = Vector2(width, 40)
        local tabAutoBossImg = tabAutoBossGo:AddComponent(typeof(Image))
        
        local tabAutoBossTxtGo = GameObject("Text")
        tabAutoBossTxtGo.transform:SetParent(tabAutoBossGo.transform, false)
        local tabAutoBossTxtRt = tabAutoBossTxtGo:AddComponent(typeof(RectTransform))
        tabAutoBossTxtRt.anchorMin, tabAutoBossTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        tabAutoBossTxtRt.sizeDelta = Vector2(0, 0)
        local tabAutoBossTxt = tabAutoBossTxtGo:AddComponent(typeof(Text))
        tabAutoBossTxt.raycastTarget, tabAutoBossTxt.fontSize, tabAutoBossTxt.alignment = false, 20, TextAnchor.MiddleCenter
        if defaultFont then tabAutoBossTxt.font = defaultFont end
        local tabAutoBossBtn = tabAutoBossGo:AddComponent(typeof(Button))

        local function UpdateTabColors()
            tabCoBanImg.color = Color(0.2, 0.2, 0.2, 1)
            tabNangCaoImg.color = Color(0.2, 0.2, 0.2, 1)
            tabAutoBossImg.color = Color(0.2, 0.2, 0.2, 1)
            
            tabCoBanTxt.color = Color(0.6, 0.6, 0.6, 1)
            tabNangCaoTxt.color = Color(0.6, 0.6, 0.6, 1)
            tabAutoBossTxt.color = Color(0.6, 0.6, 0.6, 1)

            tabCoBanTxt.text = "CƠ BẢN"
            tabNangCaoTxt.text = "NÂNG CAO"
            tabAutoBossTxt.text = "AUTO BOSS"

            if _G.ModMainTab == "CO_BAN" then
                tabCoBanImg.color = Color(0.2, 0.6, 0.2, 1)
                tabCoBanTxt.color = Color.white
                tabCoBanTxt.text = "[ CƠ BẢN ]"
            elseif _G.ModMainTab == "NANG_CAO" then
                tabNangCaoImg.color = Color(0.2, 0.6, 0.2, 1)
                tabNangCaoTxt.color = Color.white
                tabNangCaoTxt.text = "[ NÂNG CAO ]"
            elseif _G.ModMainTab == "AUTO_BOSS" then
                tabAutoBossImg.color = Color(0.2, 0.6, 0.2, 1)
                tabAutoBossTxt.color = Color.white
                tabAutoBossTxt.text = "[ AUTO BOSS ]"
            end
        end
        UpdateTabColors()

        tabCoBanBtn.onClick:AddListener(function()
            _G.ModMainTab = "CO_BAN"
            pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
            UpdateTabColors()
            RefreshMainTabs()
        end)
        tabNangCaoBtn.onClick:AddListener(function()
            _G.ModMainTab = "NANG_CAO"
            pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
            UpdateTabColors()
            RefreshMainTabs()
        end)
        
        tabAutoBossBtn.onClick:AddListener(function()
            _G.ModMainTab = "AUTO_BOSS"
            pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
            UpdateTabColors()
            RefreshMainTabs()
        end)


        -- Watermark
        local watermarkGo = GameObject("WatermarkText")
        watermarkGo.transform:SetParent(panelGo.transform, false)
        local wmRt = watermarkGo:AddComponent(typeof(RectTransform))
        wmRt.anchorMin = Vector2(1, 0)
        wmRt.anchorMax = Vector2(1, 0)
        wmRt.pivot = Vector2(1, 0)
        wmRt.anchoredPosition = Vector2(-20, 10)
        wmRt.sizeDelta = Vector2(200, 30)
        local wmTxt = watermarkGo:AddComponent(typeof(Text))
        wmTxt.raycastTarget = false
        wmTxt.text = "<i>Modded by VỤT Team</i>"
        wmTxt.color = Color(0.215, 0.490, 0.133, 1.0)
        wmTxt.fontSize = 16
        wmTxt.alignment = TextAnchor.LowerRight
        if defaultFont then wmTxt.font = defaultFont end

        -- Auto-Loot DropItem Hook
        _G.LastPickupTime = _G.LastPickupTime or 0
        _G.Mod_AllDropItems = _G.Mod_AllDropItems or {}
        _G.Mod_PickedItems = _G.Mod_PickedItems or {}

        if _G.PickupManager then
            local original_AddDropSceneCellPos = _G.PickupManager.AddDropSceneCellPos
            _G.PickupManager.AddDropSceneCellPos = function(item)
                original_AddDropSceneCellPos(item)
                
                if not (item and item.data) then return end
                local dropItemData = item.data

                if _G.Mod_AutoPick_KTD then
                    local mapId = 0
                    if _G.SceneData and _G.SceneData.mapId then
                        mapId = _G.SceneData.mapId
                    elseif _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.mapId then
                        mapId = _G.RoleManager.me.mapId
                    end
                    
                    if mapId == 1077 then
                        if _G.Timer and _G.Timer.StartLoop then
                            _G.Timer.StartLoop(0.1, 3, function()
                                if _G.PickupManager then _G.PickupManager.ReqPickUpMapItem(dropItemData.id) end
                            end)
                        else
                            _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                        end
                        
                        if dropItemData.id then
                            _G.Mod_PickedItems[dropItemData.id] = true
                        end
                        
                        if _G.WriteLog then
                            _G.WriteLog(string.format("[KTĐ] Phát hiện & Tự Nhặt! InstanceId=%s, ConfigId=%s, Type=%s", tostring(dropItemData.id), tostring(dropItemData.configId), tostring(dropItemData.type)))
                        end
                        if _G.RoleManager and _G.RoleManager.me and dropItemData.x and dropItemData.y then
                            pcall(function()
                                _G.RoleManager.me:MoveTo({x = dropItemData.x, y = dropItemData.y})
                            end)
                        end
                    end
                end

                if _G.AutoPick_Enabled then
                    local eType = dropItemData.type
                    local isRune = (eType == 19 or eType == 28)
                    local isBone = (eType == 24 or eType == 26)
                    
                    local shouldPick = (isRune or isBone)
                    
                    if shouldPick then
                        if _G.PickupManager and _G.PickupManager.IsCanPickUpDropItem then
                            if not _G.PickupManager.IsCanPickUpDropItem(dropItemData) then
                                shouldPick = false
                            end
                        end
                    end
                    
                    if shouldPick then
                        local isAlreadyPicked = _G.Mod_PickedItems[dropItemData.id]
                        if not isAlreadyPicked and ((_G.AutoPick_Count or 0) < _G.AutoPick_Limit) then
                            
                            _G.Mod_PickedItems[dropItemData.id] = true
                            _G.AutoPick_Count = (_G.AutoPick_Count or 0) + 1
                            
                            -- local hasDinoNearby = false
                            -- if _G.RoleManager and _G.RoleManager.GetRolesByType then
                            --     local players = _G.RoleManager.GetRolesByType(1)
                            --     if players then
                            --         for _, p in pairs(players) do
                            --             if p.name and p.name == "Dino" then
                            --                 hasDinoNearby = true
                            --                 break
                            --             end
                            --         end
                            --     end
                            -- end
                            
                            local lootCount = _G.Mod_IsDev and 3 or 2
                            local delayTime = _G.Mod_IsDev and 0.05 or 0.2
                            local minPDelay = _G.Mod_Config_PickupDelay_Min or 100
                            local maxPDelay = _G.Mod_Config_PickupDelay_Max or 500
                            if minPDelay > maxPDelay then minPDelay, maxPDelay = maxPDelay, minPDelay end
                            local initialDelay = math.random(minPDelay, maxPDelay) / 1000
                            
                            local function ExecutePickup()
                                if _G.Timer and _G.Timer.StartLoop then
                                    _G.Timer.StartLoop(delayTime, lootCount, function()
                                        if _G.PickupManager then _G.PickupManager.ReqPickUpMapItem(dropItemData.id) end
                                    end)
                                else
                                    _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                                end
                                
                                local itemId = dropItemData.item and dropItemData.item.itemId or "???"
                                if _G.WriteLog then
                                    _G.WriteLog("[AutoLoot] Nhặt (Tức thì): Item [ID: " .. tostring(itemId) .. "]")
                                end
                                if _G.RoleManager and _G.RoleManager.me and dropItemData.x and dropItemData.y then
                                    pcall(function()
                                        if _G.WriteLog then
                                            _G.WriteLog(string.format("[AutoLoot] (Tức thì) MoveTo ItemId=%s, X=%s, Y=%s", tostring(itemId), tostring(dropItemData.x), tostring(dropItemData.y)))
                                        end
                                        _G.RoleManager.me:MoveTo({x = dropItemData.x, y = dropItemData.y})
                                    end)
                                end
                            end
                            
                            if initialDelay > 0 and _G.Timer and _G.Timer.StartLoop then
                                local hasFired = false
                                _G.Timer.StartLoop(initialDelay, 1, function()
                                    if not hasFired then
                                        hasFired = true
                                        ExecutePickup()
                                    end
                                end)
                            else
                                ExecutePickup()
                            end
                        end
                    end
                end
            end
        end

        if _G.ConditionalMgr then
            local original_CanAutoPickUpDropItem = _G.ConditionalMgr.CanAutoPickUpDropItem
            _G.ConditionalMgr.CanAutoPickUpDropItem = function(self, itemInfo)
                if _G.AutoPick_Enabled then
                    return false
                end
                return original_CanAutoPickUpDropItem(self, itemInfo)
            end

            local original_CanPickUpDropItem = _G.ConditionalMgr.CanPickUpDropItem
            _G.ConditionalMgr.CanPickUpDropItem = function(self, itemInfo)
                if _G.AutoPick_Enabled then
                    return false
                end
                return original_CanPickUpDropItem(self, itemInfo)
            end
        end

        _G.ModCallbacks = _G.ModCallbacks or {}
        _G.ModCallbacks.OnToggleMenu = function()
            local ok, err = pcall(function()
                local mainPanel = _G.ModMenuPanelGo or panelGo
                local authPanel = _G.authPanelGo or authPanelGo

                if _G.Mod_HasFetchedConfig then
                    local isValid = false
                    if _G.Mod_IsActive and _G.Mod_ActiveConfig then
                        local valid, reason = Mod_ValidateConfig(_G.Mod_ActiveConfig)
                        if valid then
                            isValid = true
                        else
                            _G.Mod_IsActive = false
                            _G.Mod_ActiveStatusMsg = reason
                        end
                    end

                    if isValid then
                        if authPanel and not authPanel:Equals(nil) then authPanel:SetActive(false) end
                        if mainPanel and not mainPanel:Equals(nil) then
                            isExpanded = not isExpanded
                            mainPanel:SetActive(isExpanded)
                            if isExpanded and _G.RefreshMainTabs then _G.RefreshMainTabs() end
                        end
                    else
                        if mainPanel and not mainPanel:Equals(nil) then mainPanel:SetActive(false) end
                        if authPanel and not authPanel:Equals(nil) then
                            local showAuth = not authPanel.activeSelf
                            authPanel:SetActive(showAuth)
                            if showAuth and _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
                        end
                    end
                else
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đang kết nối lấy thông tin kích hoạt...") end
                    _G.Mod_CheckActiveConfigNow(function(isSuccess, isActive, msg)
                        if isActive == true and _G.Mod_IsActive == true then
                            if authPanel and not authPanel:Equals(nil) then authPanel:SetActive(false) end
                            if mainPanel and not mainPanel:Equals(nil) then
                                isExpanded = true
                                mainPanel:SetActive(true)
                                if _G.RefreshMainTabs then _G.RefreshMainTabs() end
                            end
                        else
                            if mainPanel and not mainPanel:Equals(nil) then mainPanel:SetActive(false) end
                            if authPanel and not authPanel:Equals(nil) then
                                authPanel:SetActive(true)
                                if _G.Mod_RefreshAuthPanelData then _G.Mod_RefreshAuthPanelData() end
                            end
                        end
                    end)
                end
            end)
            if not ok then
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Lỗi Toggle Menu: " .. tostring(err)) end
            end
        end
        if btnComp and not btnComp:Equals(nil) then
            btnComp.onClick:RemoveAllListeners()
            btnComp.onClick:AddListener(_G.ModCallbacks.OnToggleMenu)
        end

        -- WriteLog("Khởi tạo Mod Menu HOÀN TẤT!")
    end)
    if not status then
        WriteLog("LỖI TẠO UI: " .. tostring(err))
    end
end

        if _G.RoleManager and not _G.Mod_HookedRoleManager_Monster then
            _G.Mod_HookedRoleManager_Monster = true
            -- Removed faulty CreateMonster hook. Boss logic moved to Timer.
        end
        
        _G.Mod_BypassInstanceEnter = function(self, control, originalFunc, uiid)
            if _G.Mod_InfiniteInstance then
                if _G.TeamUpQuicklyData then
                    _G.TeamUpQuicklyData.SetInstanceUI(self.name)
                end
                if _G.UIManager then _G.UIManager.Hide(uiid) end
                
                if _G.NetManager and _G.InstanceMatchMessage then
                    local mapId = self.ContentData and self.ContentData.mapId or 0
                    _G.NetManager.Send(_G.InstanceMatchMessage.ReqInstanceMatchCreateTeam, {
                        instanceId = mapId
                    })
                end
            else
                if originalFunc then originalFunc(self, control) end
            end
        end



local status, err = pcall(function()
    if _G.UIManager and not _G.MyModHooked then
        _G.MyModHooked = true
        -- WriteLog("Hooked UIManager trực tiếp!")
        
        local original_Show = _G.UIManager.Show
        _G.UIManager.Show = function(name, args, animation)

            -- CHẶN UPDATE TRƯỚC KHI GỌI HÀM SHOW GỐC
            if name == "Main_MainMenuUI" then
                pcall(function()
                    -- Lời nhắc: Các hàm chặn tải dữ liệu đã được gỡ bỏ để game load được nhân vật
                end)
            end
            
            local ret = nil
            if original_Show then ret = original_Show(name, args, animation) end
            
            pcall(function()
                if name == "Instance_BloodCastleUI" then
                    if _G.Instance_BloodCastleUI and not _G.Mod_HookedBloodCastle then
                        _G.Mod_HookedBloodCastle = true
                        local original_btn_enterOnClick = _G.Instance_BloodCastleUI.btn_enterOnClick
                        _G.Instance_BloodCastleUI.btn_enterOnClick = function(self, control)
                            if _G.Mod_BypassInstanceEnter then
                                _G.Mod_BypassInstanceEnter(self, control, original_btn_enterOnClick, _G.UIID.Instance_BloodCastleUI)
                            else
                                if original_btn_enterOnClick then original_btn_enterOnClick(self, control) end
                            end
                        end
                    end
                    local inst = _G.UIManager and _G.UIManager.GetUI and _G.UIManager.GetUI(_G.UIID.Instance_BloodCastleUI)
                    if inst and inst.btn_enter and inst.btn_enter.SetOnClick then
                        inst.btn_enter:SetOnClick(inst, inst.btn_enterOnClick)
                    end
                elseif name == "Instance_DemonPlazaUI" then
                    if _G.Instance_DemonPlazaUI and not _G.Mod_HookedDemonPlaza then
                        _G.Mod_HookedDemonPlaza = true
                        local original_btn_enterOnClick_DP = _G.Instance_DemonPlazaUI.btn_enterOnClick
                        _G.Instance_DemonPlazaUI.btn_enterOnClick = function(self, control)
                            if _G.Mod_BypassInstanceEnter then
                                _G.Mod_BypassInstanceEnter(self, control, original_btn_enterOnClick_DP, _G.UIID.Instance_DemonPlazaUI)
                            else
                                if original_btn_enterOnClick_DP then original_btn_enterOnClick_DP(self, control) end
                            end
                        end
                    end
                    local inst = _G.UIManager and _G.UIManager.GetUI and _G.UIManager.GetUI(_G.UIID.Instance_DemonPlazaUI)
                    if inst and inst.btn_enter and inst.btn_enter.SetOnClick then
                        inst.btn_enter:SetOnClick(inst, inst.btn_enterOnClick)
                    end
                end
            end)
            
            if name == "Main_MainMenuUI" then
                if not _G.MyModCreated then
                    _G.MyModCreated = true
                    CreateModUI()
                else
                    if _G.Mod_UpdateFloatingButtonsVisibility then
                        _G.Mod_UpdateFloatingButtonsVisibility()
                    end
                end
            end
            
            return ret
        end
    else
        WriteLog("LỖI: UIManager chưa được tải! ")
    end
    -- [[ ĐÃ XÓA BỎ VÒNG LẶP AUTO FARM ẨN Ở ĐÂY ĐỂ TRÁNH CONFLICT ]]
end)
if not status then
    WriteLog("LỖI HOOK UIManager: " .. tostring(err))
end

return true

---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global
---@diagnostic disable: duplicate-set-field
-- EmmyluaDebug.lua - NOTIFICATION MOD EDITION

EmmyluaDebug = {}
function EmmyluaDebug.InitEmmyluaDebug(obj)
    _G.Mod_IsAdmin = false
    _G.Mod_IsDev = false

    -- Clear legacy update files
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
end

if _G.ModInitialized then return true end
_G.ModInitialized = true

local function WriteLog(msg)
    pcall(function()
        local logPath = CS.UnityEngine.Application.persistentDataPath .. "/MyNotifLog.txt"
        local timeStr = CS.System.DateTime.Now:ToString("yyyy-MM-dd HH:mm:ss.fff")
        local finalMsg = timeStr .. ": " .. tostring(msg)
        local f = io.open(logPath, "a")
        if f then
            f:write(finalMsg .. "\n")
            f:close()
        end
        CS.UnityEngine.Debug.LogError("[NotificationMod] " .. finalMsg)
    end)
end
_G.WriteLog = WriteLog

-- Clear All PlayerPrefs Utility
_G.Mod_ClearAllPlayerPrefs = function()
    pcall(function()
        CS.UnityEngine.PlayerPrefs.DeleteAll()
        CS.UnityEngine.PlayerPrefs.Save()
        if _G.FloatingWordUtility then
            _G.FloatingWordUtility.QuickMsg("Đã xóa toàn bộ thông tin lưu trong PlayerPrefs!")
        end
    end)
end

-- Base64 & MD5 Helpers (Cloned from dev_client)
local function GetMD5(str)
    local status, res = pcall(function()
        return string.lower(tostring(CS.PCUtility.Md5(str)))
    end)
    return status and res or "ERROR_MD5"
end

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function Base64Decode(data)
    local status, res = pcall(function()
        data = string.gsub(data, '[^' .. b64chars .. '=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r, f = '', (b64chars:find(x) - 1)
            for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c = 0
            for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
            return string.char(c)
        end))
    end)
    return status and res or ""
end

-- Device Code calculation (Exact clone from dev_client)
local deviceId = CS.UnityEngine.SystemInfo.deviceUniqueIdentifier
local deviceCode = GetMD5(deviceId .. "XOAI")

-- Top-level CheckModAuth function
_G.CheckModAuth = function(tokenStr, isSilent)
    if not tokenStr or tokenStr == "" then
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token không được để trống!" end
        return false
    end
    local decoded = Base64Decode(tokenStr)
    if not decoded or decoded == "" then
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token sai định dạng!" end
        return false
    end
    local parts = {}
    for part in string.gmatch(decoded, "[^|]+") do
        table.insert(parts, part)
    end

    local pCode, pUID, pMainTier, pSubTier, pDuration, pTime, pSig
    if #parts == 7 then
        pCode, pUID, pMainTier, pSubTier, pDuration, pTime, pSig = parts[1], parts[2], tonumber(parts[3]), tonumber(parts[4]), tonumber(parts[5]), tonumber(parts[6]), parts[7]
    elseif #parts == 5 then
        pCode, pUID, pMainTier, pSubTier, pDuration, pTime, pSig = parts[1], parts[2], 8, 7, tonumber(parts[3]), tonumber(parts[4]), parts[5]
    elseif #parts == 4 then
        pCode, pUID, pMainTier, pSubTier, pDuration, pTime, pSig = parts[1], "ALL", 8, 7, tonumber(parts[2]), tonumber(parts[3]), parts[4]
    else
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token không hợp lệ!" end
        return false
    end

    if pCode ~= deviceCode then
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token không dành cho thiết bị này!" end
        return false
    end

    local dataToHash
    if #parts == 7 then
        dataToHash = pCode .. "|" .. pUID .. "|" .. tostring(pMainTier) .. "|" .. tostring(pSubTier) .. "|" .. tostring(pDuration) .. "|" .. tostring(pTime) .. "MUVH_SECRET_SALT_XOAI"
    elseif #parts == 5 then
        dataToHash = pCode .. "|" .. pUID .. "|" .. tostring(pDuration) .. "|" .. tostring(pTime) .. "MUVH_SECRET_SALT_XOAI"
    else
        dataToHash = pCode .. "|" .. tostring(pDuration) .. "|" .. tostring(pTime) .. "MUVH_SECRET_SALT_XOAI"
    end

    local expectedSig = GetMD5(dataToHash)
    if expectedSig ~= pSig then
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token đã bị giả mạo!" end
        return false
    end

    local currentUnixTime = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or os.time()
    local expireTime = pTime + (pDuration * 86400)
    if currentUnixTime > expireTime then
        if not isSilent and _G.ModAuthErrTxt then _G.ModAuthErrTxt.text = "Token đã hết hạn!" end
        return false
    end

    -- NOTIFICATION EDITION: Bypasses character UID check. MD5 device code & expire time are valid.
    CS.UnityEngine.PlayerPrefs.SetString("Mod_AuthToken", tokenStr)
    CS.UnityEngine.PlayerPrefs.Save()
    _G.ModAuthValid = true
    return true
end

_G.Mod_IsActive = function()
    local savedToken = CS.UnityEngine.PlayerPrefs.GetString("Mod_AuthToken", "")
    return _G.CheckModAuth(savedToken, true)
end

-- Helper to request fresh Ancient Boss Info packet from server (Exact clone from dev_client)
local function RequestServerBossData()
    pcall(function()
        if _G.NetManager and _G.MapMessage then
            _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 16 })
            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 17 })
            _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 1 })
            _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 2 })
            _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 3 })
        end
    end)
end

-- Main UI Builder Function
local function CreateModUI()
    local status, err = pcall(function()
        local GameObject = CS.UnityEngine.GameObject
        local Vector2 = CS.UnityEngine.Vector2
        local Color = CS.UnityEngine.Color
        local RectTransform = CS.UnityEngine.RectTransform
        local Canvas = CS.UnityEngine.Canvas
        local CanvasScaler = CS.UnityEngine.UI.CanvasScaler
        local GraphicRaycaster = CS.UnityEngine.UI.GraphicRaycaster
        local Image = CS.UnityEngine.UI.Image
        local Text = CS.UnityEngine.UI.Text
        local TextAnchor = CS.UnityEngine.TextAnchor
        local Button = CS.UnityEngine.UI.Button
        local InputField = CS.UnityEngine.UI.InputField
        local Font = CS.UnityEngine.Font
        local Resources = CS.UnityEngine.Resources
        local RenderMode = CS.UnityEngine.RenderMode

        local defaultFont = Resources.GetBuiltinResource(typeof(Font), "Arial.ttf")

        local modRoot = GameObject("NotificationModRoot")
        CS.UnityEngine.Object.DontDestroyOnLoad(modRoot)

        local canvas = modRoot:AddComponent(typeof(Canvas))
        canvas.renderMode = RenderMode.ScreenSpaceOverlay
        canvas.sortingOrder = 9999

        local scaler = modRoot:AddComponent(typeof(CanvasScaler))
        scaler.uiScaleMode = CS.UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
        scaler.referenceResolution = Vector2(1920, 1080)

        modRoot:AddComponent(typeof(GraphicRaycaster))

        -- 1. Floating VỤT Button
        local btnGo = GameObject("FloatingModBtn")
        btnGo.transform:SetParent(modRoot.transform, false)
        local rt = btnGo:AddComponent(typeof(RectTransform))
        rt.anchorMin = Vector2(0, 0)
        rt.anchorMax = Vector2(0, 0)
        rt.pivot = Vector2(0, 0)
        rt.anchoredPosition = Vector2(20, 280)
        rt.sizeDelta = Vector2(60, 60)

        local img = btnGo:AddComponent(typeof(Image))
        img.color = Color(0.215, 0.490, 0.133, 1.0)
        img.raycastTarget = true

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

        -- 2. Mod Menu Panel
        local panelGo = GameObject("ModMenuPanel")
        panelGo.transform:SetParent(modRoot.transform, false)
        local panelRt = panelGo:AddComponent(typeof(RectTransform))
        panelRt.anchorMin = Vector2(0, 0)
        panelRt.anchorMax = Vector2(0, 0)
        panelRt.pivot = Vector2(0, 0)
        panelRt.anchoredPosition = Vector2(90, 50)
        panelRt.sizeDelta = Vector2(720, 580)

        local panelImg = panelGo:AddComponent(typeof(Image))
        panelImg.color = Color(0, 0, 0, 0.85)
        panelImg.raycastTarget = true
        panelGo:SetActive(false)

        -- 3. Auth Panel (Cloned directly from dev_client UI layout)
        local authPanelGo = GameObject("ModAuthPanel")
        _G.authPanelGo = authPanelGo
        authPanelGo.transform:SetParent(modRoot.transform, false)
        local authRt = authPanelGo:AddComponent(typeof(RectTransform))
        authRt.anchorMin, authRt.anchorMax, authRt.pivot = Vector2(0.5, 0.5), Vector2(0.5, 0.5), Vector2(0.5, 0.5)
        authRt.anchoredPosition = Vector2(0, 0)
        authRt.sizeDelta = Vector2(580, 290)

        local authImg = authPanelGo:AddComponent(typeof(Image))
        authImg.color = Color(0.1, 0.1, 0.1, 0.95)
        authImg.raycastTarget = true

        local titleGo = GameObject("AuthTitle")
        titleGo.transform:SetParent(authPanelGo.transform, false)
        local titleRt = titleGo:AddComponent(typeof(RectTransform))
        titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
        titleRt.anchoredPosition = Vector2(0, -20)
        titleRt.sizeDelta = Vector2(500, 40)
        local titleTxt = titleGo:AddComponent(typeof(Text))
        titleTxt.text = "KÍCH HOẠT THÔNG BÁO TELEGRAM"
        titleTxt.color, titleTxt.fontSize, titleTxt.alignment = Color.yellow, 24, TextAnchor.MiddleCenter
        titleTxt.raycastTarget = false
        if defaultFont then titleTxt.font = defaultFont end

        -- 1. Device Code Section
        local codeLblGo = GameObject("AuthCodeLbl")
        codeLblGo.transform:SetParent(authPanelGo.transform, false)
        local codeLblRt = codeLblGo:AddComponent(typeof(RectTransform))
        codeLblRt.anchorMin, codeLblRt.anchorMax, codeLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        codeLblRt.anchoredPosition = Vector2(20, -65)
        codeLblRt.sizeDelta = Vector2(400, 20)
        local codeLblTxt = codeLblGo:AddComponent(typeof(Text))
        codeLblTxt.text = "Mã thiết bị (MD5):"
        codeLblTxt.color, codeLblTxt.fontSize = Color.white, 16
        codeLblTxt.raycastTarget = false
        if defaultFont then codeLblTxt.font = defaultFont end

        local codeGo = GameObject("AuthCodeInput")
        codeGo.transform:SetParent(authPanelGo.transform, false)
        local codeRt = codeGo:AddComponent(typeof(RectTransform))
        codeRt.anchorMin, codeRt.anchorMax, codeRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        codeRt.anchoredPosition = Vector2(20, -85)
        codeRt.sizeDelta = Vector2(425, 35)
        local codeImg = codeGo:AddComponent(typeof(Image))
        codeImg.color = Color(1, 1, 1, 1)
        codeImg.raycastTarget = true

        local cTextGo = GameObject("Text")
        cTextGo.transform:SetParent(codeGo.transform, false)
        local cTxtRt = cTextGo:AddComponent(typeof(RectTransform))
        cTxtRt.anchorMin, cTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        cTxtRt.offsetMin, cTxtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
        local codeTxt = cTextGo:AddComponent(typeof(Text))
        codeTxt.text = deviceCode
        codeTxt.color, codeTxt.fontSize = Color.black, 16
        codeTxt.alignment = TextAnchor.MiddleLeft
        codeTxt.raycastTarget = false
        if defaultFont then codeTxt.font = defaultFont end

        local codeInputField = codeGo:AddComponent(typeof(InputField))
        codeInputField.textComponent = codeTxt
        codeInputField.text = deviceCode

        local copyBtnGo = GameObject("AuthCopyBtn")
        copyBtnGo.transform:SetParent(authPanelGo.transform, false)
        local copyRt = copyBtnGo:AddComponent(typeof(RectTransform))
        copyRt.anchorMin, copyRt.anchorMax, copyRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
        copyRt.anchoredPosition = Vector2(-20, -85)
        copyRt.sizeDelta = Vector2(120, 35)
        local copyImg = copyBtnGo:AddComponent(typeof(Image))
        copyImg.color = Color(0.2, 0.6, 1, 1)
        copyImg.raycastTarget = true
        local copyBtn = copyBtnGo:AddComponent(typeof(Button))
        local copyTxtGo = GameObject("CopyTxt")
        copyTxtGo.transform:SetParent(copyBtnGo.transform, false)
        local cTxtRt2 = copyTxtGo:AddComponent(typeof(RectTransform))
        cTxtRt2.anchorMin, cTxtRt2.anchorMax = Vector2(0, 0), Vector2(1, 1)
        cTxtRt2.offsetMin, cTxtRt2.offsetMax = Vector2(0, 0), Vector2(0, 0)
        local cTxt2 = copyTxtGo:AddComponent(typeof(Text))
        cTxt2.text = "Copy Code"
        cTxt2.color, cTxt2.fontSize, cTxt2.alignment = Color.white, 16, TextAnchor.MiddleCenter
        cTxt2.raycastTarget = false
        if defaultFont then cTxt2.font = defaultFont end

        copyBtn.onClick:AddListener(function()
            CS.UnityEngine.GUIUtility.systemCopyBuffer = deviceCode
            if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã copy mã thiết bị!") end
        end)

        -- 2. Token Section
        local tokenLblGo = GameObject("AuthTokenLbl")
        tokenLblGo.transform:SetParent(authPanelGo.transform, false)
        local tokenLblRt = tokenLblGo:AddComponent(typeof(RectTransform))
        tokenLblRt.anchorMin, tokenLblRt.anchorMax, tokenLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tokenLblRt.anchoredPosition = Vector2(20, -135)
        tokenLblRt.sizeDelta = Vector2(400, 20)
        local tokenLblTxt = tokenLblGo:AddComponent(typeof(Text))
        tokenLblTxt.text = "Nhập Token bản quyền:"
        tokenLblTxt.color, tokenLblTxt.fontSize = Color.white, 16
        tokenLblTxt.raycastTarget = false
        if defaultFont then tokenLblTxt.font = defaultFont end

        local tokenGo = GameObject("AuthTokenInput")
        tokenGo.transform:SetParent(authPanelGo.transform, false)
        local tokenRt = tokenGo:AddComponent(typeof(RectTransform))
        tokenRt.anchorMin, tokenRt.anchorMax, tokenRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tokenRt.anchoredPosition = Vector2(20, -155)
        tokenRt.sizeDelta = Vector2(425, 35)
        local tokenImg = tokenGo:AddComponent(typeof(Image))
        tokenImg.color = Color(1, 1, 1, 1)
        tokenImg.raycastTarget = true

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
        tokenTxt.raycastTarget = false
        if defaultFont then tokenTxt.font = defaultFont end

        local inputField = tokenGo:AddComponent(typeof(InputField))
        inputField.textComponent = tokenTxt
        inputField.text = savedToken

        local pasteBtnGo = GameObject("AuthPasteBtn")
        pasteBtnGo.transform:SetParent(authPanelGo.transform, false)
        local pasteRt = pasteBtnGo:AddComponent(typeof(RectTransform))
        pasteRt.anchorMin, pasteRt.anchorMax, pasteRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
        pasteRt.anchoredPosition = Vector2(-20, -155)
        pasteRt.sizeDelta = Vector2(120, 35)
        local pasteImg = pasteBtnGo:AddComponent(typeof(Image))
        pasteImg.color = Color(0.8, 0.4, 0, 1)
        pasteImg.raycastTarget = true
        local pasteBtn = pasteBtnGo:AddComponent(typeof(Button))
        local pasteTxtGo = GameObject("PasteTxt")
        pasteTxtGo.transform:SetParent(pasteBtnGo.transform, false)
        local pTxtRt = pasteTxtGo:AddComponent(typeof(RectTransform))
        pTxtRt.anchorMin, pTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        pTxtRt.offsetMin, pTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
        local pTxt = pasteTxtGo:AddComponent(typeof(Text))
        pTxt.text = "Paste Token"
        pTxt.color, pTxt.fontSize, pTxt.alignment = Color.white, 16, TextAnchor.MiddleCenter
        pTxt.raycastTarget = false
        if defaultFont then pTxt.font = defaultFont end

        pasteBtn.onClick:AddListener(function()
            savedToken = CS.UnityEngine.GUIUtility.systemCopyBuffer or ""
            inputField.text = savedToken
        end)

        local errGo = GameObject("AuthErrTxt")
        errGo.transform:SetParent(authPanelGo.transform, false)
        local errRt = errGo:AddComponent(typeof(RectTransform))
        errRt.anchorMin, errRt.anchorMax, errRt.pivot = Vector2(0.5, 0), Vector2(0.5, 0), Vector2(0.5, 0)
        errRt.anchoredPosition = Vector2(0, 60)
        errRt.sizeDelta = Vector2(500, 30)
        local errTxt = errGo:AddComponent(typeof(Text))
        _G.ModAuthErrTxt = errTxt
        errTxt.text = ""
        errTxt.color, errTxt.fontSize, errTxt.alignment = Color.red, 18, TextAnchor.MiddleCenter
        errTxt.raycastTarget = false
        if defaultFont then errTxt.font = defaultFont end

        local actBtnGo = GameObject("AuthActBtn")
        actBtnGo.transform:SetParent(authPanelGo.transform, false)
        local actRt = actBtnGo:AddComponent(typeof(RectTransform))
        actRt.anchorMin, actRt.anchorMax, actRt.pivot = Vector2(0.5, 0), Vector2(0.5, 0), Vector2(0.5, 0)
        actRt.anchoredPosition = Vector2(0, 15)
        actRt.sizeDelta = Vector2(160, 40)
        local actImg = actBtnGo:AddComponent(typeof(Image))
        actImg.color = Color(0.2, 0.6, 0.2, 1)
        actImg.raycastTarget = true
        local actBtn = actBtnGo:AddComponent(typeof(Button))
        local actTxtGo = GameObject("ActTxt")
        actTxtGo.transform:SetParent(actBtnGo.transform, false)
        local aTxtRt = actTxtGo:AddComponent(typeof(RectTransform))
        aTxtRt.anchorMin, aTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        aTxtRt.offsetMin, aTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
        local aTxt = actTxtGo:AddComponent(typeof(Text))
        aTxt.text = "KÍCH HOẠT"
        aTxt.color, aTxt.fontSize, aTxt.alignment = Color.white, 22, TextAnchor.MiddleCenter
        aTxt.raycastTarget = false
        if defaultFont then aTxt.font = defaultFont end

        actBtn.onClick:AddListener(function()
            local tokenInputStr = inputField.text
            if _G.CheckModAuth(tokenInputStr, false) then
                authPanelGo:SetActive(false)
                panelGo:SetActive(true)
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Kích hoạt bản quyền thành công!") end
            end
        end)

        authPanelGo:SetActive(not _G.Mod_IsActive())

        -- Watermark in Auth Panel
        local authWmGo = GameObject("AuthWatermarkText")
        authWmGo.transform:SetParent(authPanelGo.transform, false)
        local authWmRt = authWmGo:AddComponent(typeof(RectTransform))
        authWmRt.anchorMin, authWmRt.anchorMax, authWmRt.pivot = Vector2(1, 0), Vector2(1, 0), Vector2(1, 0)
        authWmRt.anchoredPosition = Vector2(-15, 10)
        authWmRt.sizeDelta = Vector2(200, 30)
        local authWmTxt = authWmGo:AddComponent(typeof(Text))
        authWmTxt.raycastTarget = true
        authWmTxt.text = "<i>Modded by Xoài</i>"
        authWmTxt.color, authWmTxt.fontSize, authWmTxt.alignment = Color(0.215, 0.490, 0.133, 1.0), 16, TextAnchor.LowerRight
        if defaultFont then authWmTxt.font = defaultFont end
        local authWmBtn = authWmGo:AddComponent(typeof(Button))
        authWmBtn.onClick:AddListener(function()
            if _G.Mod_ClearAllPlayerPrefs then _G.Mod_ClearAllPlayerPrefs() end
        end)

        -- Toggle Button click
        local isExpanded = false
        local btnComp = btnGo:AddComponent(typeof(Button))
        btnComp.onClick:AddListener(function()
            if not _G.Mod_IsActive() then
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Vui lòng kích hoạt bản quyền Mod!") end
                authPanelGo:SetActive(true)
                return
            end
            isExpanded = not isExpanded
            panelGo:SetActive(isExpanded)
            if isExpanded then
                RequestServerBossData()
            end
        end)

        -- Single Notification UI Generator
        local function CreateNotificationUI()
            pcall(function()
                if panelGo and panelGo.transform then
                    for i = panelGo.transform.childCount - 1, 0, -1 do
                        local child = panelGo.transform:GetChild(i)
                        if child and child.gameObject then
                            CS.UnityEngine.Object.DestroyImmediate(child.gameObject)
                        end
                    end
                end
            end)

            -- Panel Title
            local titleGo = GameObject("NotifTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            titleRt.anchoredPosition = Vector2(0, -25)
            titleRt.sizeDelta = Vector2(500, 30)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.text = "=== THÔNG BÁO BOSS TELEGRAM ==="
            titleTxt.color, titleTxt.fontSize, titleTxt.alignment = Color.yellow, 22, TextAnchor.MiddleCenter
            titleTxt.raycastTarget = false
            if defaultFont then titleTxt.font = defaultFont end

            local currentY = -65

            -- 1. Telegram Bot Token Input (Width widened to 540 for perfect gap & visibility)
            local botTokenLblGo = GameObject("BotTokenLbl")
            botTokenLblGo.transform:SetParent(panelGo.transform, false)
            local btLblRt = botTokenLblGo:AddComponent(typeof(RectTransform))
            btLblRt.anchorMin, btLblRt.anchorMax, btLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            btLblRt.anchoredPosition = Vector2(20, currentY)
            btLblRt.sizeDelta = Vector2(400, 20)
            local btLblTxt = botTokenLblGo:AddComponent(typeof(Text))
            btLblTxt.text = "Telegram Bot Token:"
            btLblTxt.color, btLblTxt.fontSize = Color.white, 16
            btLblTxt.raycastTarget = false
            if defaultFont then btLblTxt.font = defaultFont end

            currentY = currentY - 25
            local botTokenInGo = GameObject("BotTokenInput")
            botTokenInGo.transform:SetParent(panelGo.transform, false)
            local btInRt = botTokenInGo:AddComponent(typeof(RectTransform))
            btInRt.anchorMin, btInRt.anchorMax, btInRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            btInRt.anchoredPosition = Vector2(20, currentY)
            btInRt.sizeDelta = Vector2(540, 35)
            local btInImg = botTokenInGo:AddComponent(typeof(Image))
            btInImg.color = Color(1, 1, 1, 1)
            btInImg.raycastTarget = true

            local btTextGo = GameObject("Text")
            btTextGo.transform:SetParent(botTokenInGo.transform, false)
            local bttRt = btTextGo:AddComponent(typeof(RectTransform))
            bttRt.anchorMin, bttRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bttRt.offsetMin, bttRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local btTxt = btTextGo:AddComponent(typeof(Text))
            local savedBotToken = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleBotToken", "")
            btTxt.text = savedBotToken
            btTxt.color, btTxt.fontSize = Color.black, 15
            btTxt.alignment = TextAnchor.MiddleLeft
            btTxt.raycastTarget = false
            if defaultFont then btTxt.font = defaultFont end

            local btField = botTokenInGo:AddComponent(typeof(InputField))
            btField.textComponent = btTxt
            btField.text = savedBotToken
            btField.onValueChanged:AddListener(function(val)
                CS.UnityEngine.PlayerPrefs.SetString("Mod_TeleBotToken", val)
                CS.UnityEngine.PlayerPrefs.Save()
            end)

            local pasteBtBtnGo = GameObject("PasteBotTokenBtn")
            pasteBtBtnGo.transform:SetParent(panelGo.transform, false)
            local pbtRt = pasteBtBtnGo:AddComponent(typeof(RectTransform))
            pbtRt.anchorMin, pbtRt.anchorMax, pbtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            pbtRt.anchoredPosition = Vector2(570, currentY)
            pbtRt.sizeDelta = Vector2(130, 35)
            local pbtImg = pasteBtBtnGo:AddComponent(typeof(Image))
            pbtImg.color = Color(0.8, 0.4, 0, 1)
            pbtImg.raycastTarget = true
            local pbtBtn = pasteBtBtnGo:AddComponent(typeof(Button))
            local pbtTxtGo = GameObject("Text")
            pbtTxtGo.transform:SetParent(pasteBtBtnGo.transform, false)
            local pbttRt = pbtTxtGo:AddComponent(typeof(RectTransform))
            pbttRt.anchorMin, pbttRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            local pbtTxt = pbtTxtGo:AddComponent(typeof(Text))
            pbtTxt.text = "Paste Token"
            pbtTxt.color, pbtTxt.fontSize, pbtTxt.alignment = Color.white, 15, TextAnchor.MiddleCenter
            pbtTxt.raycastTarget = false
            if defaultFont then pbtTxt.font = defaultFont end

            pbtBtn.onClick:AddListener(function()
                local clip = CS.UnityEngine.GUIUtility.systemCopyBuffer or ""
                btField.text = clip
                CS.UnityEngine.PlayerPrefs.SetString("Mod_TeleBotToken", clip)
                CS.UnityEngine.PlayerPrefs.Save()
            end)

            -- 2. Telegram Chat ID Input (Width widened to 540 for perfect gap & visibility)
            currentY = currentY - 45
            local chatIdLblGo = GameObject("ChatIdLbl")
            chatIdLblGo.transform:SetParent(panelGo.transform, false)
            local cidLblRt = chatIdLblGo:AddComponent(typeof(RectTransform))
            cidLblRt.anchorMin, cidLblRt.anchorMax, cidLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            cidLblRt.anchoredPosition = Vector2(20, currentY)
            cidLblRt.sizeDelta = Vector2(400, 20)
            local cidLblTxt = chatIdLblGo:AddComponent(typeof(Text))
            cidLblTxt.text = "Telegram Chat ID:"
            cidLblTxt.color, cidLblTxt.fontSize = Color.white, 16
            cidLblTxt.raycastTarget = false
            if defaultFont then cidLblTxt.font = defaultFont end

            currentY = currentY - 25
            local chatIdInGo = GameObject("ChatIdInput")
            chatIdInGo.transform:SetParent(panelGo.transform, false)
            local cidInRt = chatIdInGo:AddComponent(typeof(RectTransform))
            cidInRt.anchorMin, cidInRt.anchorMax, cidInRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            cidInRt.anchoredPosition = Vector2(20, currentY)
            cidInRt.sizeDelta = Vector2(540, 35)
            local cidInImg = chatIdInGo:AddComponent(typeof(Image))
            cidInImg.color = Color(1, 1, 1, 1)
            cidInImg.raycastTarget = true

            local cidTextGo = GameObject("Text")
            cidTextGo.transform:SetParent(chatIdInGo.transform, false)
            local cidtRt = cidTextGo:AddComponent(typeof(RectTransform))
            cidtRt.anchorMin, cidtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            cidtRt.offsetMin, cidtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local cidTxt = cidTextGo:AddComponent(typeof(Text))
            local savedChatId = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleChatId", "")
            cidTxt.text = savedChatId
            cidTxt.color, cidTxt.fontSize = Color.black, 15
            cidTxt.alignment = TextAnchor.MiddleLeft
            cidTxt.raycastTarget = false
            if defaultFont then cidTxt.font = defaultFont end

            local cidField = chatIdInGo:AddComponent(typeof(InputField))
            cidField.textComponent = cidTxt
            cidField.text = savedChatId
            cidField.onValueChanged:AddListener(function(val)
                CS.UnityEngine.PlayerPrefs.SetString("Mod_TeleChatId", val)
                CS.UnityEngine.PlayerPrefs.Save()
            end)

            local pasteCidBtnGo = GameObject("PasteChatIdBtn")
            pasteCidBtnGo.transform:SetParent(panelGo.transform, false)
            local pcidRt = pasteCidBtnGo:AddComponent(typeof(RectTransform))
            pcidRt.anchorMin, pcidRt.anchorMax, pcidRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            pcidRt.anchoredPosition = Vector2(570, currentY)
            pcidRt.sizeDelta = Vector2(130, 35)
            local pcidImg = pasteCidBtnGo:AddComponent(typeof(Image))
            pcidImg.color = Color(0.8, 0.4, 0, 1)
            pcidImg.raycastTarget = true
            local pcidBtn = pasteCidBtnGo:AddComponent(typeof(Button))
            local pcidTxtGo = GameObject("Text")
            pcidTxtGo.transform:SetParent(pasteCidBtnGo.transform, false)
            local pcidtRt = pcidTxtGo:AddComponent(typeof(RectTransform))
            pcidtRt.anchorMin, pcidtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            local pcidTxt = pcidTxtGo:AddComponent(typeof(Text))
            pcidTxt.text = "Paste ChatID"
            pcidTxt.color, pcidTxt.fontSize, pcidTxt.alignment = Color.white, 15, TextAnchor.MiddleCenter
            pcidTxt.raycastTarget = false
            if defaultFont then pcidTxt.font = defaultFont end

            pcidBtn.onClick:AddListener(function()
                local clip = CS.UnityEngine.GUIUtility.systemCopyBuffer or ""
                cidField.text = clip
                CS.UnityEngine.PlayerPrefs.SetString("Mod_TeleChatId", clip)
                CS.UnityEngine.PlayerPrefs.Save()
            end)

            -- Separator
            currentY = currentY - 45
            local sepGo = GameObject("Sep")
            sepGo.transform:SetParent(panelGo.transform, false)
            local sepRt = sepGo:AddComponent(typeof(RectTransform))
            sepRt.anchorMin, sepRt.anchorMax, sepRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            sepRt.anchoredPosition = Vector2(0, currentY)
            sepRt.sizeDelta = Vector2(680, 20)
            local sepTxt = sepGo:AddComponent(typeof(Text))
            sepTxt.text = "--------------------------------------------------------------------------------------------------"
            sepTxt.color, sepTxt.fontSize, sepTxt.alignment = Color.gray, 16, TextAnchor.MiddleCenter
            sepTxt.raycastTarget = false

            -- 3. Section Header
            currentY = currentY - 25
            local secHeaderGo = GameObject("SecHeader")
            secHeaderGo.transform:SetParent(panelGo.transform, false)
            local shRt = secHeaderGo:AddComponent(typeof(RectTransform))
            shRt.anchorMin, shRt.anchorMax, shRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            shRt.anchoredPosition = Vector2(0, currentY)
            shRt.sizeDelta = Vector2(500, 25)
            local shTxt = secHeaderGo:AddComponent(typeof(Text))
            shTxt.text = "CẤU HÌNH THEO DÕI BOSS C3 - C12"
            shTxt.color, shTxt.fontSize, shTxt.alignment = Color(0.2, 1, 0.2, 1), 18, TextAnchor.MiddleCenter
            shTxt.raycastTarget = false
            if defaultFont then shTxt.font = defaultFont end

            -- 4. Grid Row 1: THÁNH CỐT (C3..C12)
            currentY = currentY - 35
            local tcLblGo = GameObject("TcLbl")
            tcLblGo.transform:SetParent(panelGo.transform, false)
            local tcLblRt = tcLblGo:AddComponent(typeof(RectTransform))
            tcLblRt.anchorMin, tcLblRt.anchorMax, tcLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tcLblRt.anchoredPosition = Vector2(20, currentY)
            tcLblRt.sizeDelta = Vector2(90, 32)
            local tcLblTxt = tcLblGo:AddComponent(typeof(Text))
            tcLblTxt.text = "Thánh Cốt:"
            tcLblTxt.color, tcLblTxt.fontSize = Color.yellow, 16
            tcLblTxt.alignment = TextAnchor.MiddleLeft
            tcLblTxt.raycastTarget = false
            if defaultFont then tcLblTxt.font = defaultFont end

            local startX = 115
            for t = 3, 12 do
                local btnGoTile = GameObject("TC_Btn_C" .. t)
                btnGoTile.transform:SetParent(panelGo.transform, false)
                local bRt = btnGoTile:AddComponent(typeof(RectTransform))
                bRt.anchorMin, bRt.anchorMax, bRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                bRt.anchoredPosition = Vector2(startX + (t - 3) * 58, currentY)
                bRt.sizeDelta = Vector2(52, 32)

                local imgTile = btnGoTile:AddComponent(typeof(Image))
                local prefKey = "Mod_Notify_ThanhCot_C" .. t
                local isEnabled = CS.UnityEngine.PlayerPrefs.GetInt(prefKey, 0) == 1
                imgTile.color = isEnabled and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
                imgTile.raycastTarget = true

                local txtGoTile = GameObject("Text")
                txtGoTile.transform:SetParent(btnGoTile.transform, false)
                local tRt = txtGoTile:AddComponent(typeof(RectTransform))
                tRt.anchorMin, tRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                local txtTile = txtGoTile:AddComponent(typeof(Text))
                txtTile.text = "C" .. t
                txtTile.color, txtTile.fontSize, txtTile.alignment = Color.white, 15, TextAnchor.MiddleCenter
                txtTile.raycastTarget = false
                if defaultFont then txtTile.font = defaultFont end

                local btnTile = btnGoTile:AddComponent(typeof(Button))
                btnTile.targetGraphic = imgTile
                btnTile.onClick:AddListener(function()
                    isEnabled = not isEnabled
                    CS.UnityEngine.PlayerPrefs.SetInt(prefKey, isEnabled and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                    imgTile.color = isEnabled and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
                end)
            end

            -- 5. Grid Row 2: PHÙ VĂN (C3..C12)
            currentY = currentY - 45
            local pvLblGo = GameObject("PvLbl")
            pvLblGo.transform:SetParent(panelGo.transform, false)
            local pvLblRt = pvLblGo:AddComponent(typeof(RectTransform))
            pvLblRt.anchorMin, pvLblRt.anchorMax, pvLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            pvLblRt.anchoredPosition = Vector2(20, currentY)
            pvLblRt.sizeDelta = Vector2(90, 32)
            local pvLblTxt = pvLblGo:AddComponent(typeof(Text))
            pvLblTxt.text = "Phù Văn:"
            pvLblTxt.color, pvLblTxt.fontSize = Color.cyan, 16
            pvLblTxt.alignment = TextAnchor.MiddleLeft
            pvLblTxt.raycastTarget = false
            if defaultFont then pvLblTxt.font = defaultFont end

            for t = 3, 12 do
                local btnGoTile = GameObject("PV_Btn_C" .. t)
                btnGoTile.transform:SetParent(panelGo.transform, false)
                local bRt = btnGoTile:AddComponent(typeof(RectTransform))
                bRt.anchorMin, bRt.anchorMax, bRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                bRt.anchoredPosition = Vector2(startX + (t - 3) * 58, currentY)
                bRt.sizeDelta = Vector2(52, 32)

                local imgTile = btnGoTile:AddComponent(typeof(Image))
                local prefKey = "Mod_Notify_PhuVan_C" .. t
                local isEnabled = CS.UnityEngine.PlayerPrefs.GetInt(prefKey, 0) == 1
                imgTile.color = isEnabled and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
                imgTile.raycastTarget = true

                local txtGoTile = GameObject("Text")
                txtGoTile.transform:SetParent(btnGoTile.transform, false)
                local tRt = txtGoTile:AddComponent(typeof(RectTransform))
                tRt.anchorMin, tRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                local txtTile = txtGoTile:AddComponent(typeof(Text))
                txtTile.text = "C" .. t
                txtTile.color, txtTile.fontSize, txtTile.alignment = Color.white, 15, TextAnchor.MiddleCenter
                txtTile.raycastTarget = false
                if defaultFont then txtTile.font = defaultFont end

                local btnTile = btnGoTile:AddComponent(typeof(Button))
                btnTile.targetGraphic = imgTile
                btnTile.onClick:AddListener(function()
                    isEnabled = not isEnabled
                    CS.UnityEngine.PlayerPrefs.SetInt(prefKey, isEnabled and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                    imgTile.color = isEnabled and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
                end)
            end

            -- 6. Row 3: Nút BÁO TELEGRAM (Toggle) & Nút SEND TEST
            currentY = currentY - 55

            -- Nút BÁO TELEGRAM (Toggle: OFF = Xám, ON = Xanh)
            local teleToggleBtnGo = GameObject("TeleNotify_ToggleBtn")
            teleToggleBtnGo.transform:SetParent(panelGo.transform, false)
            local ttRt = teleToggleBtnGo:AddComponent(typeof(RectTransform))
            ttRt.anchorMin, ttRt.anchorMax, ttRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            ttRt.anchoredPosition = Vector2(20, currentY)
            ttRt.sizeDelta = Vector2(330, 42)

            local ttImg = teleToggleBtnGo:AddComponent(typeof(Image))
            local isTeleOn = CS.UnityEngine.PlayerPrefs.GetInt("Mod_TeleNotify_Enabled", 0) == 1
            ttImg.color = isTeleOn and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
            ttImg.raycastTarget = true

            local ttTxtGo = GameObject("Text")
            ttTxtGo.transform:SetParent(teleToggleBtnGo.transform, false)
            local tttRt = ttTxtGo:AddComponent(typeof(RectTransform))
            tttRt.anchorMin, tttRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            local ttTxt = ttTxtGo:AddComponent(typeof(Text))
            ttTxt.text = isTeleOn and "BÁO TELEGRAM [ON]" or "BÁO TELEGRAM [OFF]"
            ttTxt.color, ttTxt.fontSize, ttTxt.alignment = Color.white, 17, TextAnchor.MiddleCenter
            ttTxt.raycastTarget = false
            if defaultFont then ttTxt.font = defaultFont end

            local ttBtn = teleToggleBtnGo:AddComponent(typeof(Button))
            ttBtn.targetGraphic = ttImg
            ttBtn.onClick:AddListener(function()
                isTeleOn = not isTeleOn
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_TeleNotify_Enabled", isTeleOn and 1 or 0)
                CS.UnityEngine.PlayerPrefs.Save()
                ttImg.color = isTeleOn and Color(0.2, 0.6, 0.2, 1) or Color(0.3, 0.3, 0.3, 1)
                ttTxt.text = isTeleOn and "BÁO TELEGRAM [ON]" or "BÁO TELEGRAM [OFF]"
                if _G.FloatingWordUtility then
                    _G.FloatingWordUtility.QuickMsg(isTeleOn and "Đã BẬT Báo Telegram!" or "Đã TẮT Báo Telegram!")
                end
            end)

            -- Nút SEND TEST (Exact message formatting clone from dev_client)
            local sendTestBtnGo = GameObject("SendTestBtn")
            sendTestBtnGo.transform:SetParent(panelGo.transform, false)
            local stRt = sendTestBtnGo:AddComponent(typeof(RectTransform))
            stRt.anchorMin, stRt.anchorMax, stRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            stRt.anchoredPosition = Vector2(370, currentY)
            stRt.sizeDelta = Vector2(330, 42)

            local stImg = sendTestBtnGo:AddComponent(typeof(Image))
            stImg.color = Color(0.8, 0.4, 0, 1)
            stImg.raycastTarget = true

            local stTxtGo = GameObject("Text")
            stTxtGo.transform:SetParent(sendTestBtnGo.transform, false)
            local sttRt = stTxtGo:AddComponent(typeof(RectTransform))
            sttRt.anchorMin, sttRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            local stTxt = stTxtGo:AddComponent(typeof(Text))
            stTxt.text = "SEND TEST"
            stTxt.color, stTxt.fontSize, stTxt.alignment = Color.white, 17, TextAnchor.MiddleCenter
            stTxt.raycastTarget = false
            if defaultFont then stTxt.font = defaultFont end

            local stBtn = sendTestBtnGo:AddComponent(typeof(Button))
            stBtn.targetGraphic = stImg
            stBtn.onClick:AddListener(function()
                local botTokenStr = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleBotToken", "")
                local chatIdStr = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleChatId", "")
                if botTokenStr == "" or chatIdStr == "" then
                    if _G.FloatingWordUtility then
                        _G.FloatingWordUtility.QuickMsg("Lỗi: Chưa nhập Telegram Bot Token hoặc Chat ID!")
                    end
                    return
                end

                -- Request fresh boss data from server
                RequestServerBossData()

                local msgLines = {}
                local scannedCount = 0

                if _G.SceneData and _G.SceneData.GetAncientBossData then
                    -- Scan Thánh Cốt (C3 - C12)
                    for tier = 3, 12 do
                        local tcKey = "Mod_Notify_ThanhCot_C" .. tier
                        if CS.UnityEngine.PlayerPrefs.GetInt(tcKey, 0) == 1 then
                            scannedCount = scannedCount + 1
                            local bossId = 20201000 + tier
                            local count = 0
                            local rCount = 0
                            local isSatisfy, info = _G.SceneData:GetAncientBossData(16, bossId)
                            if info and info.refreshCount then rCount = info.refreshCount end
                            if isSatisfy == true then
                                count = 70
                            elseif isSatisfy == false and info and info.count then
                                count = info.count
                            end

                            local statusTitle = (count >= 70) and "Đã Hiện!" or "Sắp Ra!"
                            local msgText = (count >= 70) and "Hiện" or tostring(rCount)
                            table.insert(msgLines, string.format("🔴 KUNDUN C%d: THÁNH CỐT %s\n- Số lượng: %d / 70 (%s)",
                                tier, statusTitle, count, msgText))
                        end
                    end

                    -- Scan Phù Văn (C3 - C12)
                    for tier = 3, 12 do
                        local pvKey = "Mod_Notify_PhuVan_C" .. tier
                        if CS.UnityEngine.PlayerPrefs.GetInt(pvKey, 0) == 1 then
                            scannedCount = scannedCount + 1
                            local bossId = 20211000 + tier
                            local limit17 = (tier >= 9) and 500 or (tier == 8 and 400 or (tier == 7 and 300 or 200))
                            local count = 0
                            local rCount = 0
                            local isSatisfy, info = _G.SceneData:GetAncientBossData(17, bossId)
                            if info and info.refreshCount then rCount = info.refreshCount end
                            if isSatisfy == true then
                                count = limit17
                            elseif isSatisfy == false and info and info.count then
                                count = info.count
                            end

                            local statusTitle = (count >= limit17) and "Đã Hiện!" or "Sắp Ra!"
                            local msgText = (count >= limit17) and "Hiện" or tostring(rCount)
                            table.insert(msgLines, string.format("🔴 KUNDUN C%d: PHÙ VĂN %s\n- Số lượng: %d / %d (%s)",
                                tier, statusTitle, count, limit17, msgText))
                        end
                    end
                else
                    if _G.FloatingWordUtility then
                        _G.FloatingWordUtility.QuickMsg("Cảnh báo: Chưa đăng nhập vào game để đọc dữ liệu Boss!")
                    end
                end

                if scannedCount == 0 then
                    if _G.FloatingWordUtility then
                        _G.FloatingWordUtility.QuickMsg("Vui lòng chọn ít nhất 1 Boss (C3-C12) để TEST!")
                    end
                    return
                end

                local fullMsg = table.concat(msgLines, "\n\n")
                local url = "https://api.telegram.org/bot" .. botTokenStr .. "/sendMessage?chat_id=" .. chatIdStr .. "&text=" .. CS.UnityEngine.WWW.EscapeURL(fullMsg)
                pcall(function() CS.UnityEngine.WWW(url) end)
                if _G.FloatingWordUtility then
                    _G.FloatingWordUtility.QuickMsg("Đã gửi tin nhắn TEST Telegram (" .. scannedCount .. " loại boss)!")
                end
            end)
        end

        CreateNotificationUI()

        -- Watermark in main panel
        local watermarkGo = GameObject("WatermarkText")
        watermarkGo.transform:SetParent(panelGo.transform, false)
        local wmRt = watermarkGo:AddComponent(typeof(RectTransform))
        wmRt.anchorMin, wmRt.anchorMax, wmRt.pivot = Vector2(1, 0), Vector2(1, 0), Vector2(1, 0)
        wmRt.anchoredPosition = Vector2(-20, 10)
        wmRt.sizeDelta = Vector2(200, 30)
        local wmTxt = watermarkGo:AddComponent(typeof(Text))
        wmTxt.raycastTarget = true
        wmTxt.text = "<i>Modded by Xoài</i>"
        wmTxt.color = Color(0.215, 0.490, 0.133, 1.0)
        wmTxt.fontSize = 16
        wmTxt.alignment = TextAnchor.LowerRight
        if defaultFont then wmTxt.font = defaultFont end

        local wmBtn = watermarkGo:AddComponent(typeof(Button))
        wmBtn.onClick:AddListener(function()
            if _G.Mod_ClearAllPlayerPrefs then _G.Mod_ClearAllPlayerPrefs() end
        end)

    end)
    if not status then
        if _G.WriteLog then _G.WriteLog("LỖI CreateModUI: " .. tostring(err)) end
    end
end

-- Hook UIManager.Show so CreateModUI triggers when main game HUD loads
local status, err = pcall(function()
    if _G.UIManager and not _G.MyModHooked then
        _G.MyModHooked = true
        local original_Show = _G.UIManager.Show
        _G.UIManager.Show = function(name, args, animation)
            local ret = nil
            if original_Show then ret = original_Show(name, args, animation) end

            if name == "Main_MainMenuUI" then
                if not _G.MyModCreated then
                    _G.MyModCreated = true
                    CreateModUI()
                end
            end
            return ret
        end
    end
end)
if not status then
    if _G.WriteLog then _G.WriteLog("LỖI Hook UIManager: " .. tostring(err)) end
end

-- Heartbeat Loop: Re-checks UIManager hook, ensures CreateModUI & runs 5s Telegram Dispatch loop
if not _G.ModUIHooked then
    _G.ModUIHooked = true
    if _G.Timer and _G.Timer.StartLoop then
        _G.Timer.StartLoop(1, -1, function()
            pcall(function()
                if _G.UIManager and not _G.MyModHooked then
                    _G.MyModHooked = true
                    local original_Show = _G.UIManager.Show
                    _G.UIManager.Show = function(name, args, animation)
                        local ret = nil
                        if original_Show then ret = original_Show(name, args, animation) end
                        if name == "Main_MainMenuUI" then
                            if not _G.MyModCreated then
                                _G.MyModCreated = true
                                CreateModUI()
                            end
                        end
                        return ret
                    end
                end
            end)

            pcall(function()
                if not _G.MyModCreated and _G.SceneData and _G.SceneData.me then
                    _G.MyModCreated = true
                    CreateModUI()
                end
            end)

            -- Request fresh server boss data in background loop (Exact clone from dev_client)
            RequestServerBossData()

            -- 5s Background Boss Notification Polling Loop (Exact clone from dev_client)
            pcall(function()
                if not (_G.Mod_IsActive and _G.Mod_IsActive()) then return end
                if CS.UnityEngine.PlayerPrefs.GetInt("Mod_TeleNotify_Enabled", 0) ~= 1 then return end

                local currentSec = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or os.time()
                if currentSec - (_G.LastTeleCheckSec or 0) < 5 then return end
                _G.LastTeleCheckSec = currentSec

                local botToken = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleBotToken", "")
                local chatId = CS.UnityEngine.PlayerPrefs.GetString("Mod_TeleChatId", "")
                if botToken == "" or chatId == "" then return end

                _G.LastTeleNotifySec_Boss = _G.LastTeleNotifySec_Boss or {}

                if _G.SceneData and _G.SceneData.GetAncientBossData then
                    -- 1. THÁNH CỐT (C3 - C12, threshold = 5)
                    for tier = 3, 12 do
                        local tcKey = "Mod_Notify_ThanhCot_C" .. tier
                        if CS.UnityEngine.PlayerPrefs.GetInt(tcKey, 0) == 1 then
                            local bossId = 20201000 + tier
                            local limit = 70
                            local threshold = 5
                            local count = 0
                            local rCount = 0
                            local isSatisfy, info = _G.SceneData:GetAncientBossData(16, bossId)
                            if info and info.refreshCount then rCount = info.refreshCount end
                            if isSatisfy == true then
                                count = limit
                            elseif isSatisfy == false and info and info.count then
                                count = info.count
                            end

                            if limit - count <= threshold then
                                local bossKey = "TC_C" .. tier
                                local lastNotify = _G.LastTeleNotifySec_Boss[bossKey] or 0
                                if currentSec - lastNotify >= 180 then
                                    _G.LastTeleNotifySec_Boss[bossKey] = currentSec
                                    local statusTitle = (count >= limit) and "Đã Hiện!" or "Sắp Ra!"
                                    local msgText = (count >= limit) and "Hiện" or tostring(rCount)
                                    local msg = string.format("🔴 KUNDUN C%d: THÁNH CỐT %s\n- Số lượng: %d / %d (%s)",
                                        tier, statusTitle, count, limit, msgText)
                                    local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage?chat_id=" .. chatId .. "&text=" .. CS.UnityEngine.WWW.EscapeURL(msg)
                                    pcall(function() CS.UnityEngine.WWW(url) end)
                                end
                            end
                        end
                    end

                    -- 2. PHÙ VĂN (C3 - C12, threshold = 15)
                    for tier = 3, 12 do
                        local pvKey = "Mod_Notify_PhuVan_C" .. tier
                        if CS.UnityEngine.PlayerPrefs.GetInt(pvKey, 0) == 1 then
                            local bossId = 20211000 + tier
                            local limit = (tier >= 9) and 500 or (tier == 8 and 400 or (tier == 7 and 300 or 200))
                            local threshold = 15
                            local count = 0
                            local rCount = 0
                            local isSatisfy, info = _G.SceneData:GetAncientBossData(17, bossId)
                            if info and info.refreshCount then rCount = info.refreshCount end
                            if isSatisfy == true then
                                count = limit
                            elseif isSatisfy == false and info and info.count then
                                count = info.count
                            end

                            if limit - count <= threshold then
                                local bossKey = "PV_C" .. tier
                                local lastNotify = _G.LastTeleNotifySec_Boss[bossKey] or 0
                                if currentSec - lastNotify >= 180 then
                                    _G.LastTeleNotifySec_Boss[bossKey] = currentSec
                                    local statusTitle = (count >= limit) and "Đã Hiện!" or "Sắp Ra!"
                                    local msgText = (count >= limit) and "Hiện" or tostring(rCount)
                                    local msg = string.format("🔴 KUNDUN C%d: PHÙ VĂN %s\n- Số lượng: %d / %d (%s)",
                                        tier, statusTitle, count, limit, msgText)
                                    local url = "https://api.telegram.org/bot" .. botToken .. "/sendMessage?chat_id=" .. chatId .. "&text=" .. CS.UnityEngine.WWW.EscapeURL(msg)
                                    pcall(function() CS.UnityEngine.WWW(url) end)
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end
end

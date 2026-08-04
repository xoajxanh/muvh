-- EmmyluaDebug.lua
-- Bắt buộc phải có để Main.lua gọi không bị lỗi
EmmyluaDebug = {}
function EmmyluaDebug.InitEmmyluaDebug(obj)
    _G.Mod_IsAdmin = false
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

-- WriteLog("--- BẮT ĐẦU KHỞI TẠO HOOK MOD MENU ---")

local function CreateModUI()
    local status, err = pcall(function()
        if _G.Mod_AutoPK_Enabled == nil then _G.Mod_AutoPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPK_Enabled", 0) == 1 end
        if _G.Mod_AutoApproachTowerBoss == nil then _G.Mod_AutoApproachTowerBoss = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoApproachTowerBoss", 0) == 1 end
        if _G.Mod_InfiniteInstance == nil then _G.Mod_InfiniteInstance = CS.UnityEngine.PlayerPrefs.GetInt("Mod_InfiniteInstance", 0) == 1 end
        if _G.Mod_AutoUseAngel == nil then _G.Mod_AutoUseAngel = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoUseAngel", 0) == 1 end
        if _G.Mod_AutoGuildPK_Enabled == nil then _G.Mod_AutoGuildPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoGuildPK_Enabled", 0) == 1 end
        if _G.Mod_AutoPick_KTD == nil then _G.Mod_AutoPick_KTD = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPick_KTD", 0) == 1 end
        if _G.Mod_AutoRevive_KTD == nil then _G.Mod_AutoRevive_KTD = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoRevive_KTD", 0) == 1 end
        if _G.Mod_AutoAoE_BossAn == nil then _G.Mod_AutoAoE_BossAn = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoAoE_BossAn", 0) == 1 end
        
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
        btnGo.transform:SetParent(modRoot.transform, false)
        local rt = btnGo:AddComponent(typeof(RectTransform))
        rt.anchorMin = Vector2(0, 0)
        rt.anchorMax = Vector2(0, 0)
        rt.pivot = Vector2(0, 0)
        rt.anchoredPosition = Vector2(20, 70)
        rt.sizeDelta = Vector2(60, 60)

        local img = btnGo:AddComponent(typeof(Image))
        img.color = Color(0.215, 0.490, 0.133, 1.0)

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
        if defaultFont then txt.font = defaultFont end

        local pkBtnGo = GameObject("FloatingPKBtn")
        pkBtnGo.transform:SetParent(modRoot.transform, false)
        local pkRt = pkBtnGo:AddComponent(typeof(RectTransform))
        pkRt.anchorMin = Vector2(0, 0)
        pkRt.anchorMax = Vector2(0, 0)
        pkRt.pivot = Vector2(0, 0)
        pkRt.anchoredPosition = Vector2(20, 160)
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
        if defaultFont then pkTxt.font = defaultFont end

        local pkBtnComp = pkBtnGo:AddComponent(typeof(Button))
        pkBtnComp.onClick:AddListener(function()
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

        local panelGo = GameObject("ModMenuPanel")
        panelGo.transform:SetParent(modRoot.transform, false)
        local panelRt = panelGo:AddComponent(typeof(RectTransform))
        panelRt.anchorMin = Vector2(0, 0)
        panelRt.anchorMax = Vector2(0, 0)
        panelRt.pivot = Vector2(0, 0)
        panelRt.anchoredPosition = Vector2(90, 70)
        panelRt.sizeDelta = Vector2(720, 580)

        local panelImg = panelGo:AddComponent(typeof(Image))
        panelImg.color = Color(0, 0, 0, 0.8)
        panelGo:SetActive(false)

        
        local isExpanded = false
        _G.ModMainTab = _G.ModMainTab or "CO_BAN"
        _G.CoBanUIList = {}
        _G.NangCaoUIList = {}
        _G.AutoBossUIList = {}
        _G.AdminUIList = {}

        local function RefreshMainTabs()
            for _, go in ipairs(_G.CoBanUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "CO_BAN") end
            end
            for _, go in ipairs(_G.NangCaoUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "NANG_CAO") end
            end
            for _, go in ipairs(_G.AutoBossUIList) do
                if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "AUTO_BOSS") end
            end
            if _G.Mod_IsAdmin then
                for _, go in ipairs(_G.AdminUIList) do
                    if go and not go:Equals(nil) then go:SetActive(_G.ModMainTab == "ADMIN") end
                end
            end
            if _G.ModRefreshAutoBossConfigUI then
                _G.ModRefreshAutoBossConfigUI()
            end
            if _G.ModMainTab == "CO_BAN" then
                if _G.ModUpdateCountText then _G.ModUpdateCountText() end
            end
        end

        local btnComp = btnGo:AddComponent(typeof(Button))
        
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
            }
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
            }
        }
        
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
        
        local function GetLineButton(btnIndex, posX, posY, width)
            if not btnUIPool[btnIndex] then
                local btnGo = GameObject("BossBtn_" .. btnIndex)
                btnGo.transform:SetParent(panelGo.transform, false)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.sizeDelta = Vector2(width, 30)
                
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
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                btnUIPool[btnIndex] = { go = btnGo, txt = txt, btn = btn, rt = rt }
                table.insert(_G.CoBanUIList, btnGo)
            end
            btnUIPool[btnIndex].rt.anchoredPosition = Vector2(posX, posY)
            btnUIPool[btnIndex].rt.sizeDelta = Vector2(width, 30)
            return btnUIPool[btnIndex]
        end

        local function UpdateBossWatchUIText()
            pcall(function()
                if not isExpanded then return end
                local currentSec = _G.Time.GetServerSecondTime()
                local currentPosY = -140
                local titleIdx = 1
                local rowIdx = 1
                local btnIdx = 1
                local sepIdx = 1
                
                local tabBtnC7 = GetLineButton(btnIdx, 40, currentPosY, 100)
                tabBtnC7.go:SetActive(_G.ModMainTab == "CO_BAN")
                tabBtnC7.txt.text = "<color=" .. (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                tabBtnC7.btn.onClick:RemoveAllListeners()
                tabBtnC7.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C7"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1

                local tabBtnC8 = GetLineButton(btnIdx, 150, currentPosY, 100)
                tabBtnC8.go:SetActive(_G.ModMainTab == "CO_BAN")
                tabBtnC8.txt.text = "<color=" .. (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"
                tabBtnC8.btn.onClick:RemoveAllListeners()
                tabBtnC8.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C8"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1
                
                currentPosY = currentPosY - 25

                local mapsConfig = _G.ModBossTab == "C8" and _G.Mod_MapsConfig_c8 or _G.Mod_MapsConfig_c7
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
                    
                    local maxRows = math.max(#colBosses[1], #colBosses[2], #colBosses[3])
                    
                    for r = 1, maxRows do
                        for c = 1, 3 do
                            local cfg = colBosses[c][r]
                            if cfg then
                                local startX = 40 + (c - 1) * 220
                                local yPos = currentPosY - (r - 1) * 35
                                
                                local uiBtn = GetLineButton(btnIdx, startX, yPos, 215)
                                uiBtn.go:SetActive(_G.ModMainTab == "CO_BAN")
                                
                                local bossData = mapBosses[mapCfg.mapId] and mapBosses[mapCfg.mapId][cfg.id]
                                local statusStr = "--:--"
                                local prefix = ""
                                local validLineNum = 1
                                
                                if bossData then
                                    local bestLine = nil
                                    for _, lineNum in ipairs(bossData.lineNums) do
                                        local totalAlive = bossData.aliveCount[lineNum] or 0
                                        local deadList = bossData.deadTimes[lineNum] or {}
                                        local expectedTotal = cfg.total or 1
                                        
                                        if totalAlive > 0 or #deadList > 0 then
                                            bestLine = lineNum
                                            
                                            if expectedTotal > 1 then
                                                local timeStrs = {}
                                                for i = 1, #deadList do
                                                    local rt = deadList[i]
                                                    local remain = math.floor(rt - currentSec)
                                                    if remain <= 0 then
                                                        totalAlive = totalAlive + 1
                                                    else
                                                        local m = math.floor((remain % 3600) / 60)
                                                        local s = remain % 60
                                                        table.insert(timeStrs, string.format("%02d:%02d", m, s))
                                                    end
                                                end
                                                
                                                if totalAlive >= expectedTotal then
                                                    statusStr = "<color=#00FF00>xuất hiện</color>"
                                                else
                                                    local countStr = "<color=#FFFFFF>" .. totalAlive .. "/" .. expectedTotal .. "</color>"
                                                    local tStr = ""
                                                    if #timeStrs > 0 then
                                                        tStr = " <color=#AAAAAA>(" .. table.concat(timeStrs, ", ") .. ")</color>"
                                                    end
                                                    statusStr = countStr .. tStr
                                                end
                                            else
                                                if totalAlive > 0 then
                                                    statusStr = "<color=#00FF00>xuất hiện</color>"
                                                elseif #deadList > 0 then
                                                    local rt = deadList[1]
                                                    local remain = math.floor(rt - currentSec)
                                                    if remain <= 0 then
                                                        statusStr = "<color=#00FF00>xuất hiện</color>"
                                                    else
                                                        local m = math.floor((remain % 3600) / 60)
                                                        local s = remain % 60
                                                        statusStr = "<color=#AAAAAA>(" .. string.format("%02d:%02d", m, s) .. ")</color>"
                                                    end
                                                end
                                            end
                                            break
                                        end
                                    end
                                    
                                    if bestLine then
                                        validLineNum = bestLine
                                        if #bossData.lineNums > 1 then
                                            prefix = "L" .. bestLine .. " "
                                        end
                                    end
                                end
                                
                                uiBtn.txt.text = cfg.name .. ": " .. prefix .. statusStr
                                uiBtn.txt.fontSize = 16
                                
                                uiBtn.btn.onClick:RemoveAllListeners()
                                uiBtn.btn.onClick:AddListener(function()
                                    if not _G.SceneController.TransferStateJudge() then
                                        if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("HP không đủ để dịch chuyển") end
                                        return
                                    end
                                    if _G.TranScriptData and _G.TranScriptData.InTranscript then
                                        if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Vui lòng thoát phó bản trước!") end
                                        return
                                    end
                                    if cfg.posX and cfg.posY and _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                                        _G.PathFinderManager.MoveToLinePos(mapCfg.mapId, {x = cfg.posX, y = cfg.posY}, cfg.transferId, validLineNum, nil, nil, nil, nil, true)
                                    elseif _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                        _G.SceneController.OnReqTransferTransmitMap(nil, { mapId = cfg.transferId, line = validLineNum, changeLine = true })
                                    end
                                    -- if _G.ModCallbacks and _G.ModCallbacks.OnToggleMenu then
                                    --     _G.ModCallbacks.OnToggleMenu()
                                    -- end
                                end)
                                
                                rowIdx = rowIdx + 1
                                btnIdx = btnIdx + 1
                            end
                        end
                    end
                    
                    if maxRows > 0 then
                        currentPosY = currentPosY - (maxRows * 35) - 10
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

            local original_MonsterMapDataInit = _G.SceneData.MonsterMapDataInit
            _G.SceneData.MonsterMapDataInit = function(data)
                if original_MonsterMapDataInit then original_MonsterMapDataInit(data) end
                ParseBossData()
            end
            
            _G.Mod_ApproachTowerBoss = function()
                local success, result = pcall(function()
                    if not _G.RoleManager or not _G.RoleManager.me then return false end

                    local targetX, targetY
                    local monsterRoles = _G.RoleManager.GetRolesByType and _G.RoleManager.GetRolesByType(2)
                    if monsterRoles then
                        for lid, role in pairs(monsterRoles) do
                            if role.hp and role.hp > 0 then
                                local x = role.serverCoord and role.serverCoord.x or (role.data and role.data.x)
                                local y = role.serverCoord and role.serverCoord.y or (role.data and role.data.y)
                                if x and y then
                                    targetX = tonumber(x)
                                    targetY = tonumber(y)
                                    break
                                end
                            end
                        end
                    end
                    
                    if not targetX or not targetY then return false end
                    
                    if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
                    if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("None") end

                    if _G.FloatingWordUtility then 
                        _G.FloatingWordUtility.QuickMsg("Đã quét thấy Boss! Đang phi tới băm!") 
                    end

                    _G.RoleManager.me:MoveTo({x = targetX, y = targetY}, 2, function()
                        if _G.RoleManager and _G.RoleManager.me then
                            if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("AutoFight") end
                            if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("AutoFight") end
                            if _G.FloatingWordUtility then 
                                _G.FloatingWordUtility.QuickMsg("Đã tới nơi, bắt đầu Auto đập Boss!") 
                            end
                        end
                    end)
                    return true
                end)
                if success then return result else return false end
            end

            if _G.Timer and _G.Timer.StartLoop then
                _G.Timer.StartLoop(0.1, -1, function()
                    if _G.Mod_CustomAttackRange and _G.Mod_CustomAttackRange > 0 then
                        if _G.QiJiHelperData and _G.QiJiHelperData.SettingData then
                            if _G.QiJiHelperData.SettingData.KillMonsterScope ~= _G.Mod_CustomAttackRange then
                                _G.QiJiHelperData.SettingData.KillMonsterScope = _G.Mod_CustomAttackRange
                            end
                        end
                    end
                    
                    if _G.Mod_AutoApproachTowerBoss then
                        local groupId = _G.SceneData and _G.SceneData.groupId
                        if groupId and string.match(tostring(groupId), "^1059") then
                            if _G.LastTowerMapId ~= groupId then
                                _G.LastTowerMapId = groupId
                                _G.Mod_ApproachTowerBoss_Done = false
                            end
                            if not _G.Mod_ApproachTowerBoss_Done then
                                if _G.Mod_ApproachTowerBoss and _G.Mod_ApproachTowerBoss() then
                                    _G.Mod_ApproachTowerBoss_Done = true
                                end
                            end
                        else
                            _G.LastTowerMapId = nil
                            _G.Mod_ApproachTowerBoss_Done = false
                        end
                    end
                end)
            end

            local original_RefreshAncientBossData = _G.SceneData.RefreshAncientBossData
            _G.SceneData.RefreshAncientBossData = function(self, tblData)
                if original_RefreshAncientBossData then original_RefreshAncientBossData(self, tblData) end
                if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
            end
            
            if _G.Role_ResurgenceUI then
                local original_ResurgenceOnShow = _G.Role_ResurgenceUI.OnShow
                _G.Role_ResurgenceUI.OnShow = function(self)
                    if original_ResurgenceOnShow then original_ResurgenceOnShow(self) end
                    
                    if _G.Mod_AutoRevive_KTD then
                        local mapId = _G.SceneData and _G.SceneData.mapId or 0
                        if mapId == 1077 then
                            if _G.Timer and _G.Timer.Delay then
                                _G.Timer.Delay(0.5, function()
                                    if self.Button_1OnClick then
                                        self:Button_1OnClick(nil)
                                        if _G.WriteLog then _G.WriteLog("[Auto] Đã tự động Hồi Sinh Ngay (KTĐ)!") end
                                    end
                                end)
                            else
                                if self.Button_1OnClick then
                                    self:Button_1OnClick(nil)
                                end
                            end
                        end
                    end
                end
            end
            
            if _G.Timer and _G.Timer.StartLoop then
                _G.Timer.StartLoop(0.2, -1, function()
                    pcall(function()
                        if _G.Mod_AutoUseAngel and _G.Mod_AutoPK_Enabled then
                            local me = _G.RoleManager and _G.RoleManager.me
                            if me and me.hp and me.maxHp and me.maxHp > 0 then
                                local hpPercent = me.hp / me.maxHp
                                if hpPercent < 0.20 then
                                    _G.Mod_LastAngelTime = _G.Mod_LastAngelTime or 0
                                    local currentTime = os.time()
                                    if currentTime - _G.Mod_LastAngelTime > 15 then
                                        local angelSkillId = nil
                                        if me.skills then
                                            for _, skill in pairs(me.skills) do
                                                local sid = skill.sid or skill.id or skill.skillId
                                                if sid and tostring(sid):sub(1, 6) == "102003" then
                                                    angelSkillId = tonumber(sid)
                                                    if angelSkillId then
                                                        local tblSkill = nil
                                                        if _G.ClientTable and _G.ClientTable.cfg_Skill_skillManager then
                                                            tblSkill = _G.ClientTable.cfg_Skill_skillManager:TryGetValue(angelSkillId)
                                                        end
                                                        local tblaction = nil
                                                        if tblSkill and _G.ConfigManager then
                                                            tblaction = _G.ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
                                                        end
                                                        
                                                        if tblSkill and tblaction and _G.SkillMgr and _G.SkillMgr.SendSkillMessage then
                                                            local coord = me.serverCoord or {x = 0, y = 0}
                                                            _G.SkillMgr.SendSkillMessage(tblSkill, tblaction, me.id, coord)
                                                            _G.Mod_LastAngelTime = currentTime
                                                            if _G.WriteLog then
                                                                _G.WriteLog("[AutoPK] Kích hoạt Thiên Sứ (ID: " .. tostring(angelSkillId) .. ") do máu < 20%")
                                                            end
                                                        end
                                                    end
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
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
                        end
                    end)
                end)

                _G.Timer.StartLoop(1, -1, function()
                    pcall(function()
                        if _G.SavedFOV then
                            local cam = CS.UnityEngine.Camera.main
                            if cam and math.abs(cam.fieldOfView - _G.SavedFOV) > 1 then
                                cam.fieldOfView = _G.SavedFOV
                                UpdateFOVLabel()
                            end
                        end
                        -- Removed EventManager.Dispatch hook for UniversalPointDataChanged to improve performance
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
                    if _G.Mod_AutoPK_Enabled and _G.QiJiHelperData and _G.RoleManager and _G.RoleManager.me then
                        if not _G.QiJiHelperData.isAutoFight then
                            _G.RoleManager.me:SetAutoFight(_G.AutoFightStrKey and _G.AutoFightStrKey.AutoFight or "AutoFight")
                            if _G.AutoTaskManage and _G.AutoTaskManage.SetCurRoleOperate then
                                _G.AutoTaskManage.SetCurRoleOperate(6) -- AutoTaskOperateType.AutoFight
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

        local testBtnComp = testBtnGo:AddComponent(typeof(Button))
        _G.ModCallbacks.OnFOVMinus = function()
            pcall(function()
                local cam = CS.UnityEngine.Camera.main
                if cam then
                    cam.fieldOfView = cam.fieldOfView - 5
                    UpdateFOVLabel()
                    SaveFOV(cam.fieldOfView)
                end
            end)
        end
        testBtnComp.onClick:AddListener(_G.ModCallbacks.OnFOVMinus)

        local plusBtnComp = plusBtnGo:AddComponent(typeof(Button))
        _G.ModCallbacks.OnFOVPlus = function()
            pcall(function()
                local cam = CS.UnityEngine.Camera.main
                if cam then
                    cam.fieldOfView = cam.fieldOfView + 5
                    UpdateFOVLabel()
                    SaveFOV(cam.fieldOfView)
                end
            end)
        end
        plusBtnComp.onClick:AddListener(_G.ModCallbacks.OnFOVPlus)

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
        if not _G.Mod_IsAdmin then CreateAuthUI() end

        _G.ModCallbacks.OnToggleMenu = function()
            pcall(function()
                if _G.Mod_IsAdmin or _G.ModAuthValid then
                    if _G.authPanelGo and _G.authPanelGo.activeSelf then _G.authPanelGo:SetActive(false) end
                    isExpanded = not isExpanded
                    panelGo:SetActive(isExpanded)
                    if isExpanded then 
                        UpdateFOVLabel()
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
                        _G.authPanelGo:SetActive(not _G.authPanelGo.activeSelf)
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
        if _G.AutoJumpBoss_Enabled == nil then _G.AutoJumpBoss_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoJumpBoss_Enabled", 1) == 1 end
        _G.AutoPick_FilterRune = true
        _G.AutoPick_FilterBone = true
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
                _G[valueVarName] = math.min(10.0, _G[valueVarName] + step)
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
                _G[valueVarName] = math.min(10.0, _G[valueVarName] + (step * 5))
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
                _G[valueVarName] = math.min(100, _G[valueVarName] + step)
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
                _G[valueVarName] = math.min(100, _G[valueVarName] + (step * 5))
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
            local tRt = tGo:AddComponent(typeof(RectTransform))
            tRt.anchorMin = Vector2(0, 1)
            tRt.anchorMax = Vector2(0, 1)
            tRt.pivot = Vector2(0, 1)
            tRt.anchoredPosition = Vector2(xPos, yPos)
            tRt.sizeDelta = Vector2(300, 30)

            local btn = tGo:AddComponent(typeof(Button))
            table.insert(_G.NangCaoUIList, tGo)
            local txt = tGo:AddComponent(typeof(Text))
            txt.raycastTarget = true
            txt.fontSize = 18
            if defaultFont then txt.font = defaultFont end
            txt.alignment = TextAnchor.MiddleLeft

            local function UpdateLabel()
                local status = _G[varName] and "BẬT" or "TẮT"
                local color = _G[varName] and "#00FF00" or "#FF0000"
                txt.text = string.format("%s: <color=%s>%s</color>", label, color, status)
            end
            UpdateLabel()

            btn.onClick:AddListener(function()
                _G[varName] = not _G[varName]
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

        local function CreateAutoLootUI()
            local currentY = -60
            local rightColX = 20

            local titleGo = GameObject("AutoLootTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX + 35, currentY)
            titleRt.sizeDelta = Vector2(300, 20)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ NHẶT ĐỒ SIÊU TỐC ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end
            
            currentY = currentY - 30

            CreateToggle("- TỰ ĐỘNG NHẶT", "AutoPick_Enabled", rightColX, currentY)
            currentY = currentY - 30
            
            CreateToggle("- NHẶT TỨC THÌ (ADMIN)", "AutoPick_InstantLoot", rightColX, currentY)
            currentY = currentY - 30
            
            CreateToggle("- NHẶT NGẪU NHIÊN (ADMIN)", "AutoPick_RandomLoot", rightColX, currentY)
            currentY = currentY - 30
            
            -- local alSepGo = GameObject("AutoLootSeparator")
            -- alSepGo.transform:SetParent(panelGo.transform, false)
            -- table.insert(_G.NangCaoUIList, alSepGo)
            -- local alSepRt = alSepGo:AddComponent(typeof(RectTransform))
            -- alSepRt.anchorMin = Vector2(0, 1)
            -- alSepRt.anchorMax = Vector2(0, 1)
            -- alSepRt.pivot = Vector2(0, 1)
            -- alSepRt.anchoredPosition = Vector2(rightColX, currentY)
            -- alSepRt.sizeDelta = Vector2(300, 20)
            -- local alSepTxt = alSepGo:AddComponent(typeof(Text))
            -- alSepTxt.raycastTarget = false
            -- alSepTxt.color = Color(0.4, 0.4, 0.4, 1)
            -- alSepTxt.fontSize = 16
            -- alSepTxt.alignment = TextAnchor.MiddleLeft
            -- if defaultFont then alSepTxt.font = defaultFont end
            -- alSepTxt.text = "-----------------------------------------------------------------"
            
            -- currentY = currentY - 20
            -- CreateToggle("Nhặt Phù Văn", "AutoPick_FilterRune", currentY)
            -- currentY = currentY - 35
            -- CreateToggle("Nhặt Thánh Cốt", "AutoPick_FilterBone", currentY)
            -- currentY = currentY - 40

            -- Limit Control
            local lValGo = GameObject("LimitValText")
            lValGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, lValGo)
            local lvRt = lValGo:AddComponent(typeof(RectTransform))
            lvRt.anchorMin = Vector2(0, 1)
            lvRt.anchorMax = Vector2(0, 1)
            lvRt.pivot = Vector2(0, 1)
            lvRt.anchoredPosition = Vector2(rightColX, currentY)
            lvRt.sizeDelta = Vector2(160, 30)
            local lvTxt = lValGo:AddComponent(typeof(Text))
            lvTxt.raycastTarget = false
            lvTxt.text = "- Số lượng nhặt: " .. tostring(_G.AutoPick_Limit)
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
            lmRt.anchoredPosition = Vector2(rightColX + 170, currentY)
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
            lpRt.anchoredPosition = Vector2(rightColX + 220, currentY)
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
                    lvTxt.text = "- Số lượng nhặt: " .. tostring(_G.AutoPick_Limit)
                end
            end)
            
            local lpBtnComp = lPlusGo:AddComponent(typeof(Button))
            lpBtnComp.onClick:AddListener(function()
                _G.AutoPick_Limit = _G.AutoPick_Limit + 1
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoPick_Limit", _G.AutoPick_Limit)
                CS.UnityEngine.PlayerPrefs.Save()
                lvTxt.text = "- Số lượng nhặt: " .. tostring(_G.AutoPick_Limit)
            end)

            currentY = currentY - 45
            local rstBtnGo = GameObject("ResetPickBtn")
            rstBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, rstBtnGo)
            local rstRt = rstBtnGo:AddComponent(typeof(RectTransform))
            rstRt.anchorMin = Vector2(0, 1)
            rstRt.anchorMax = Vector2(0, 1)
            rstRt.pivot = Vector2(0, 1)
            rstRt.anchoredPosition = Vector2(rightColX + 20, currentY)
            rstRt.sizeDelta = Vector2(260, 30)

            local rstImg = rstBtnGo:AddComponent(typeof(Image))
            rstImg.color = Color(0.6, 0.2, 0.2, 1)

            local rstTxtGo = GameObject("ResetPickText")
            rstTxtGo.transform:SetParent(rstBtnGo.transform, false)
            local rstTxtRt = rstTxtGo:AddComponent(typeof(RectTransform))
            rstTxtRt.anchorMin = Vector2(0, 0)
            rstTxtRt.anchorMax = Vector2(1, 1)
            rstTxtRt.sizeDelta = Vector2(0, 0)
            local rstTxt = rstTxtGo:AddComponent(typeof(Text))
            rstTxt.raycastTarget = false
            rstTxt.text = "RESET LƯỢT NHẶT"
            rstTxt.color = Color.white
            rstTxt.fontSize = 17
            rstTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then rstTxt.font = defaultFont end

            local rBtnComp = rstBtnGo:AddComponent(typeof(Button))
            rBtnComp.onClick:AddListener(function()
                _G.AutoPick_Count = 0
                _G.LastPickupTime = 0
                _G.Mod_IgnoredDropItems = {}
                _G.Mod_AllDropItems = {}
                _G.Mod_PickedItems = {}
                WriteLog("[AutoLoot] Manual Reset Triggered! Count is now 0")
                if _G.ModUpdateCountText then _G.ModUpdateCountText() end
            end)

            currentY = currentY - 33
            local hintGo = GameObject("ResetHint")
            hintGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, hintGo)
            local hintRt = hintGo:AddComponent(typeof(RectTransform))
            hintRt.anchorMin = Vector2(0, 1)
            hintRt.anchorMax = Vector2(0, 1)
            hintRt.pivot = Vector2(0, 1)
            hintRt.anchoredPosition = Vector2(rightColX - 25, currentY)
            hintRt.sizeDelta = Vector2(350, 20)
            local hintTxt = hintGo:AddComponent(typeof(Text))
            hintTxt.raycastTarget = false
            hintTxt.text = "(Ấn nút này mỗi lần chuẩn bị đánh Kundun)"
            hintTxt.color = Color(0.7, 0.7, 0.7, 1)
            hintTxt.fontSize = 14
            hintTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then hintTxt.font = defaultFont end
            
            -- currentY = currentY - 25
            -- local currCountGo = GameObject("CurrentCountText")
            -- currCountGo.transform:SetParent(panelGo.transform, false)
            -- table.insert(_G.NangCaoUIList, currCountGo)
            -- local ccRt = currCountGo:AddComponent(typeof(RectTransform))
            -- ccRt.anchorMin = Vector2(0, 1)
            -- ccRt.anchorMax = Vector2(0, 1)
            -- ccRt.pivot = Vector2(0, 1)
            -- ccRt.anchoredPosition = Vector2(rightColX, currentY)
            -- ccRt.sizeDelta = Vector2(260, 20)
            -- local ccTxt = currCountGo:AddComponent(typeof(Text))
            -- ccTxt.raycastTarget = false
            -- ccTxt.text = "Số lượt nhặt hiện tại: 0"
            -- ccTxt.color = Color(0.6, 1, 0.6, 1)
            -- ccTxt.fontSize = 16
            -- ccTxt.alignment = TextAnchor.MiddleCenter
            -- if defaultFont then ccTxt.font = defaultFont end

            _G.ModUpdateCountText = function()
                pcall(function()
                    if rstTxt and not rstTxt:Equals(nil) then
                        rstTxt.text = "RESET LƯỢT NHẶT (" .. tostring(_G.AutoPick_Count or 0) .. ")"
                    end
                end)
            end

            -- Move options from Kundun UI
            local rightColX2 = 20
            currentY = currentY - 20
            local sep2Go = GameObject("BossThapSeparator")
            sep2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, sep2Go)
            local sep2Rt = sep2Go:AddComponent(typeof(RectTransform))
            sep2Rt.anchorMin = Vector2(0, 1)
            sep2Rt.anchorMax = Vector2(0, 1)
            sep2Rt.pivot = Vector2(0, 1)
            sep2Rt.anchoredPosition = Vector2(rightColX, currentY)
            sep2Rt.sizeDelta = Vector2(250, 20)
            local sep2Txt = sep2Go:AddComponent(typeof(Text))
            sep2Txt.raycastTarget = false
            sep2Txt.color = Color(0.4, 0.4, 0.4, 1)
            sep2Txt.fontSize = 16
            sep2Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sep2Txt.font = defaultFont end
            sep2Txt.text = "------------------------------------------------------------------------------"
            
            currentY = currentY - 30
            local titleGo = GameObject("KundunTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin = Vector2(0, 1)
            titleRt.anchorMax = Vector2(0, 1)
            titleRt.pivot = Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX2 + 35, currentY)
            titleRt.sizeDelta = Vector2(270, 20)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ INFO KUNDUN BOSS ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end
            
            currentY = currentY - 30

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
            
            local tabC7 = CreateTabBtn("[ BOSS C7 ]", "C7", rightColX2, currentY)
            local tabC8 = CreateTabBtn("[ BOSS C8 ]", "C8", rightColX2 + 110, currentY)
            _G.NangCaoTabBtns = { C7 = tabC7, C8 = tabC8 }
            
            currentY = currentY - 35

            local rightColX3 = 20
            local sep3Go = GameObject("BossThapSeparator")
            sep3Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, sep3Go)
            local sep3Rt = sep3Go:AddComponent(typeof(RectTransform))
            sep3Rt.anchorMin = Vector2(0, 1)
            sep3Rt.anchorMax = Vector2(0, 1)
            sep3Rt.pivot = Vector2(0, 1)
            sep3Rt.anchoredPosition = Vector2(rightColX, currentY)
            sep3Rt.sizeDelta = Vector2(250, 20)
            local sep3Txt = sep3Go:AddComponent(typeof(Text))
            sep3Txt.raycastTarget = false
            sep3Txt.color = Color(0.4, 0.4, 0.4, 1)
            sep3Txt.fontSize = 16
            sep3Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sep3Txt.font = defaultFont end
            sep3Txt.text = "--------------------------------------------------"

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
                currentY = currentY - 25
            end

            _G.ModUpdateKundunUI = function()
                pcall(function()
                    if _G.NangCaoTabBtns then
                        _G.NangCaoTabBtns.C7.txt.text = "<color=" .. (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                        _G.NangCaoTabBtns.C8.txt.text = "<color=" .. (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"
                    end
                    
                    if not _G.KundunUILabelPool then return end
                    
                    local kundunConfigs = {}
                    if _G.ModBossTab == "C8" then
                        table.insert(kundunConfigs, { name = "THÁNH CỐT:", bossType = 16, bossId = 20201008, limit = 70 })
                        table.insert(kundunConfigs, { name = "PHÙ VĂN:", bossType = 17, bossId = 20211008, limit = 400 })
                    else
                        table.insert(kundunConfigs, { name = "THÁNH CỐT:", bossType = 16, bossId = 20201007, limit = 70 })
                        table.insert(kundunConfigs, { name = "PHÙ VĂN:", bossType = 17, bossId = 20211007, limit = 300 })
                    end
                    
                    for i, cfg in ipairs(kundunConfigs) do
                        local txt = _G.KundunUILabelPool[i]
                        if txt then
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
                            local colorTag = (cfg.limit - count <= threshold) and "<color=#00FF00>" or "<color=#FFFFFF>"
                            if count >= cfg.limit then
                                txt.text = cfg.name .. string.format(" %s%d / %d</color> (Hiện)", colorTag, count, cfg.limit)
                            else
                                txt.text = cfg.name .. string.format(" %s%d / %d</color> (%d)", colorTag, count, cfg.limit, rCount)
                            end
                        end
                    end
                end)
            end
        end 

        CreateAutoLootUI()

        _G.ModAutoBossConfigTab = _G.ModAutoBossConfigTab or "C7"
        _G.Mod_AutoFarmBoss_Config = _G.Mod_AutoFarmBoss_Config or {}
        
        local function CreateAutoBossUI()
            local currentY = -70
            local startX = 20
            
            -- Master Toggle
            local masterToggleGo = GameObject("AutoFarmBossToggle")
            masterToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, masterToggleGo)
            local mtRt = masterToggleGo:AddComponent(typeof(RectTransform))
            mtRt.anchorMin, mtRt.anchorMax, mtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            mtRt.anchoredPosition = Vector2(startX, currentY)
            mtRt.sizeDelta = Vector2(250, 35)
            
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
            mtTxt.fontSize = 18
            mtTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then mtTxt.font = defaultFont end
            
            local mtBtn = masterToggleGo:AddComponent(typeof(Button))
            
            local function UpdateMasterToggle()
                if _G.Mod_AutoFarmBoss_Enabled then
                    mtBgImg.color = Color(0.2, 0.6, 0.2, 1)
                    mtTxt.text = "AUTO FARM BOSS: ON"
                    mtTxt.color = Color.white
                else
                    mtBgImg.color = Color(0.5, 0.2, 0.2, 1)
                    mtTxt.text = "AUTO FARM BOSS: OFF"
                    mtTxt.color = Color(0.9, 0.9, 0.9, 1)
                end
            end
            
            if _G.Mod_AutoFarmBoss_Enabled == nil then
                _G.Mod_AutoFarmBoss_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoFarmBoss", 0) == 1
            end
            UpdateMasterToggle()
            
            mtBtn.onClick:AddListener(function()
                _G.Mod_AutoFarmBoss_Enabled = not _G.Mod_AutoFarmBoss_Enabled
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoFarmBoss", _G.Mod_AutoFarmBoss_Enabled and 1 or 0)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdateMasterToggle()
            end)
            
            currentY = currentY - 50
            
            -- Tier Tabs (C7/C8)
            local function CreateTierTab(label, tabName, xPos)
                local btnGo = GameObject("AutoBossTier_" .. tabName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, currentY)
                rt.sizeDelta = Vector2(120, 30)
                
                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 18
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                
                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, txt = txt, btn = btn }
            end
            
            local tierC7 = CreateTierTab("[ BOSS C7 ]", "C7", startX)
            local tierC8 = CreateTierTab("[ BOSS C8 ]", "C8", startX + 130)
            
            currentY = currentY - 40
            local gridStartY = currentY
            
            local configPool = {}
            
            local function CreateConfigBtn(idx)
                local btnGo = GameObject("AutoBossConfig_" .. idx)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                
                local img = btnGo:AddComponent(typeof(Image))
                
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
            
            local function UpdateTierTabs()
                tierC7.txt.text = "<color=" .. (_G.ModAutoBossConfigTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                tierC8.txt.text = "<color=" .. (_G.ModAutoBossConfigTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"
                
                -- Hide all config toggles
                for _, btnData in ipairs(configPool) do
                    btnData.go:SetActive(false)
                end
                
                -- Render the current tier's bosses
                local mapsConfig = _G.ModAutoBossConfigTab == "C7" and _G.Mod_MapsConfig_c7 or _G.Mod_MapsConfig_c8
                local py = gridStartY
                local poolIdx = 1
                
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
                    btnData.txt.text = "<color=#FFFF00>--- " .. mapCfg.title .. " ---</color>"
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
                                    if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                        bData.img.color = Color(0.2, 0.5, 0.2, 1)
                                        bData.txt.text = cfg.name
                                        bData.txt.color = Color.white
                                    else
                                        bData.img.color = Color(0.3, 0.3, 0.3, 1)
                                        bData.txt.text = cfg.name
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
            
            tierC7.btn.onClick:AddListener(function()
                _G.ModAutoBossConfigTab = "C7"
                UpdateTierTabs()
            end)
            tierC8.btn.onClick:AddListener(function()
                _G.ModAutoBossConfigTab = "C8"
                UpdateTierTabs()
            end)
            
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
            vLineRt.anchoredPosition = Vector2(360, -40)
            vLineRt.sizeDelta = Vector2(2, 580)
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
            
            currentY = currentY - 30
            CreateToggle("- TIẾP CẬN BOSS THÁP", "Mod_AutoApproachTowerBoss", rightColX2, currentY)
            currentY = currentY - 30
            if _G.Mod_IsAdmin then
                CreateToggle("- VÔ HẠN PB (HL, QTQ)", "Mod_InfiniteInstance", rightColX2, currentY)
                currentY = currentY - 30
            end
            
            CreateToggle("- AUTO DÙNG THIÊN SỨ", "Mod_AutoUseAngel", rightColX2, currentY)
            currentY = currentY - 30
            
            if _G.Mod_IsAdmin then
                CreateToggle("- AUTO ĐÁNH LAN (MAP ẨN)", "Mod_AutoAoE_BossAn", rightColX2, currentY)
                currentY = currentY - 30
            end
            
            CreateToggle("- AUTO PK GUILD", "Mod_AutoGuildPK_Enabled", rightColX2, currentY)
            currentY = currentY - 30

            CreateToggle("- AUTO HỒI SINH KTĐ", "Mod_AutoRevive_KTD", rightColX2, currentY)
            currentY = currentY - 30
            
            CreateToggle("- AUTO NHẶT RƯƠNG KTĐ", "Mod_AutoPick_KTD", rightColX2, currentY)
            currentY = currentY - 30
            
        end 

        CreateKundunUI()

        -- [ADMIN EXECUTE SCRIPT START]
        local function RunExecuteScript()
            local package_name = "com.vnyh.gp" 
            local basePath = "/storage/emulated/0/Android/data/" .. package_name .. "/files/"
            
            local inputPath = basePath .. "input.luac"
            local outputPath = basePath .. "output.txt"
            
            local function writeOutput(path, content)
                local fileOut = io.open(path, "w")
                if fileOut then
                    fileOut:write(content)
                    fileOut:close()
                end
            end

            local fileIn = io.open(inputPath, "rb")
            if not fileIn then
                writeOutput(outputPath, "ERR: Khong tim thay " .. inputPath)
                return
            end
            
            local bytecode = fileIn:read("*a")
            fileIn:close()

            local loadFunc = loadstring or load
            local func, compileError = loadFunc(bytecode)
            
            if not func then
                writeOutput(outputPath, "Bytecode Load Error:\n" .. tostring(compileError))
                return
            end

            local oldPrint = print
            local outputLogs = ""
            print = function(...)
                if oldPrint then oldPrint(...) end
                local args = {...}
                for i, v in ipairs(args) do
                    outputLogs = outputLogs .. tostring(v) .. "\t"
                end
                outputLogs = outputLogs .. "\n"
            end

            local success, runResult = pcall(func)
            print = oldPrint 

            local finalOutput = ""
            if success then
                finalOutput = "=== SUCCESS ===\n\n[LOGS]:\n" .. outputLogs
                if runResult ~= nil then
                    finalOutput = finalOutput .. "\n[RETURN]:\n" .. tostring(runResult)
                end
            else
                finalOutput = "=== RUNTIME ERROR ===\n" .. tostring(runResult)
            end

            writeOutput(outputPath, finalOutput)
        end

        local function CreateAdminUI()
            local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            local function Base64Encode(data)
                return ((data:gsub('.', function(x) 
                    local r,b='',x:byte()
                    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
                    return r;
                end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                    if (#x < 6) then return '' end
                    local c=0
                    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
                    return b64chars:sub(c+1,c+1)
                end)..({ '', '==', '=' })[#data%3+1])
            end

            
            
            -- Title
            local titleGo = GameObject("AdminTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            titleRt.anchoredPosition = Vector2(0, -60)
            titleRt.sizeDelta = Vector2(500, 30)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.text = "=== ADMIN CONTROL PANEL ==="
            titleTxt.color, titleTxt.fontSize, titleTxt.alignment = Color.yellow, 22, TextAnchor.MiddleCenter
            if defaultFont then titleTxt.font = defaultFont end

            -- Execute Script Section
            local execBtnGo = GameObject("AdminExecBtn")
            execBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, execBtnGo)
            local execRt = execBtnGo:AddComponent(typeof(RectTransform))
            execRt.anchorMin, execRt.anchorMax, execRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            execRt.anchoredPosition = Vector2(0, -100)
            execRt.sizeDelta = Vector2(250, 40)
            local execImg = execBtnGo:AddComponent(typeof(Image))
            execImg.color = Color(0.8, 0.2, 0.2, 1)
            local execBtn = execBtnGo:AddComponent(typeof(Button))
            local eTxtGo = GameObject("ExecTxt")
            eTxtGo.transform:SetParent(execBtnGo.transform, false)
            local eTxtRt = eTxtGo:AddComponent(typeof(RectTransform))
            eTxtRt.anchorMin, eTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            eTxtRt.offsetMin, eTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local eTxt = eTxtGo:AddComponent(typeof(Text))
            eTxt.text = "Execute Script (input.luac)"
            eTxt.color, eTxt.fontSize, eTxt.alignment = Color.white, 18, TextAnchor.MiddleCenter
            if defaultFont then eTxt.font = defaultFont end
            execBtn.onClick:AddListener(function()
                RunExecuteScript()
                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã chạy Execute Script!") end
            end)

            -- Separator
            local sepGo = GameObject("AdminSep")
            sepGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, sepGo)
            local sepRt = sepGo:AddComponent(typeof(RectTransform))
            sepRt.anchorMin, sepRt.anchorMax, sepRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            sepRt.anchoredPosition = Vector2(0, -150)
            sepRt.sizeDelta = Vector2(500, 20)
            local sepTxt = sepGo:AddComponent(typeof(Text))
            sepTxt.text = "--------------------------------------------------------"
            sepTxt.color, sepTxt.fontSize, sepTxt.alignment = Color.gray, 18, TextAnchor.MiddleCenter
            
            -- Token Generator Title
            local tokTitleGo = GameObject("TokTitle")
            tokTitleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, tokTitleGo)
            local tokRt = tokTitleGo:AddComponent(typeof(RectTransform))
            tokRt.anchorMin, tokRt.anchorMax, tokRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            tokRt.anchoredPosition = Vector2(0, -170)
            tokRt.sizeDelta = Vector2(500, 30)
            local tokTxt = tokTitleGo:AddComponent(typeof(Text))
            tokTxt.text = "CÔNG CỤ TẠO TOKEN BẢN QUYỀN"
            tokTxt.color, tokTxt.fontSize, tokTxt.alignment = Color(0.2, 1, 0.2, 1), 20, TextAnchor.MiddleCenter
            if defaultFont then tokTxt.font = defaultFont end
            
            local adminDeviceCode = ""
            local adminDuration = 3
            local adminGenToken = ""
            
            -- Input code Label
            local inCodeLblGo = GameObject("InCodeLbl")
            inCodeLblGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, inCodeLblGo)
            local inCodeLblRt = inCodeLblGo:AddComponent(typeof(RectTransform))
            inCodeLblRt.anchorMin, inCodeLblRt.anchorMax, inCodeLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            inCodeLblRt.anchoredPosition = Vector2(20, -200)
            inCodeLblRt.sizeDelta = Vector2(400, 20)
            local inCodeLblTxt = inCodeLblGo:AddComponent(typeof(Text))
            inCodeLblTxt.text = "Mã của khách:"
            inCodeLblTxt.color, inCodeLblTxt.fontSize = Color.white, 16
            if defaultFont then inCodeLblTxt.font = defaultFont end

            -- Input code Field
            local inCodeGo = GameObject("InCodeInput")
            inCodeGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, inCodeGo)
            local inCodeRt = inCodeGo:AddComponent(typeof(RectTransform))
            inCodeRt.anchorMin, inCodeRt.anchorMax, inCodeRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            inCodeRt.anchoredPosition = Vector2(20, -225)
            inCodeRt.sizeDelta = Vector2(550, 35)
            local inCodeImg = inCodeGo:AddComponent(typeof(Image))
            inCodeImg.color = Color(1, 1, 1, 1)
            
            local textGo = GameObject("Text")
            textGo.transform:SetParent(inCodeGo.transform, false)
            local txtRt = textGo:AddComponent(typeof(RectTransform))
            txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRt.offsetMin, txtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local inCodeTxt = textGo:AddComponent(typeof(Text))
            inCodeTxt.text = adminDeviceCode
            inCodeTxt.color, inCodeTxt.fontSize = Color.black, 16
            inCodeTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then inCodeTxt.font = defaultFont end
            
            local inputField = inCodeGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
            inputField.textComponent = inCodeTxt
            inputField.text = adminDeviceCode
            
            inputField.onValueChanged:AddListener(function(val)
                adminDeviceCode = val
            end)

            local pasteBtnGo = GameObject("AdminPasteBtn")
            pasteBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, pasteBtnGo)
            local pasteRt = pasteBtnGo:AddComponent(typeof(RectTransform))
            pasteRt.anchorMin, pasteRt.anchorMax, pasteRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
            pasteRt.anchoredPosition = Vector2(-20, -225)
            pasteRt.sizeDelta = Vector2(120, 35)
            local pasteImg = pasteBtnGo:AddComponent(typeof(Image))
            pasteImg.color = Color(0.8, 0.4, 0, 1)
            local pasteBtn = pasteBtnGo:AddComponent(typeof(Button))
            local pTxtGo = GameObject("PasteTxt")
            pTxtGo.transform:SetParent(pasteBtnGo.transform, false)
            local pTxtRt = pTxtGo:AddComponent(typeof(RectTransform))
            pTxtRt.anchorMin, pTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            pTxtRt.offsetMin, pTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local pTxt = pTxtGo:AddComponent(typeof(Text))
            pTxt.text = "Paste Code"
            pTxt.color, pTxt.fontSize, pTxt.alignment = Color.white, 16, TextAnchor.MiddleCenter
            if defaultFont then pTxt.font = defaultFont end
            
            pasteBtn.onClick:AddListener(function()
                adminDeviceCode = CS.UnityEngine.GUIUtility.systemCopyBuffer or ""
                inputField.text = adminDeviceCode
            end)
            
            -- Options
            local optsTitleGo = GameObject("OptsTitle")
            optsTitleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, optsTitleGo)
            local optsRt = optsTitleGo:AddComponent(typeof(RectTransform))
            optsRt.anchorMin, optsRt.anchorMax, optsRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            optsRt.anchoredPosition = Vector2(20, -280)
            optsRt.sizeDelta = Vector2(150, 30)
            local optsTxt = optsTitleGo:AddComponent(typeof(Text))
            optsTxt.text = "Chọn thời hạn:"
            optsTxt.color, optsTxt.fontSize = Color.white, 16
            if defaultFont then optsTxt.font = defaultFont end
            
            local optDurationText = GameObject("OptDurTxt")
            optDurationText.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, optDurationText)
            local optDTkRt = optDurationText:AddComponent(typeof(RectTransform))
            optDTkRt.anchorMin, optDTkRt.anchorMax, optDTkRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            optDTkRt.anchoredPosition = Vector2(170, -280)
            optDTkRt.sizeDelta = Vector2(400, 30)
            local optDTkTxt = optDurationText:AddComponent(typeof(Text))
            optDTkTxt.text = "<color=green>[ 3 Ngày ]</color>"
            optDTkTxt.color, optDTkTxt.fontSize = Color.white, 18
            if defaultFont then optDTkTxt.font = defaultFont end

            local function CreateOptBtn(x, y, label, durVal)
                local btnGo = GameObject("OptBtn_" .. durVal)
                btnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(x, y)
                rt.sizeDelta = Vector2(90, 35)
                local img = btnGo:AddComponent(typeof(Image))
                img.color = Color(0.3, 0.3, 0.3, 1)
                local btn = btnGo:AddComponent(typeof(Button))
                local txtGo = GameObject("Txt")
                txtGo.transform:SetParent(btnGo.transform, false)
                local tRt = txtGo:AddComponent(typeof(RectTransform))
                tRt.anchorMin, tRt.anchorMax = Vector2(0,0), Vector2(1,1)
                tRt.offsetMin, tRt.offsetMax = Vector2(0,0), Vector2(0,0)
                local tTxt = txtGo:AddComponent(typeof(Text))
                tTxt.text = label
                tTxt.color, tTxt.fontSize, tTxt.alignment = Color.white, 16, TextAnchor.MiddleCenter
                if defaultFont then tTxt.font = defaultFont end
                
                btn.onClick:AddListener(function()
                    adminDuration = durVal
                    optDTkTxt.text = "<color=green>[ " .. label .. " ]</color>"
                end)
            end
            
            CreateOptBtn(20, -310, "3 Ngày", 3)
            CreateOptBtn(120, -310, "7 Ngày", 7)
            CreateOptBtn(220, -310, "15 Ngày", 15)
            CreateOptBtn(320, -310, "30 Ngày", 30)
            CreateOptBtn(420, -310, "90 Ngày", 90)

            -- Generate Button
            local genBtnGo = GameObject("AdminGenBtn")
            genBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, genBtnGo)
            local genRt = genBtnGo:AddComponent(typeof(RectTransform))
            genRt.anchorMin, genRt.anchorMax, genRt.pivot = Vector2(0.5, 1), Vector2(0.5, 1), Vector2(0.5, 1)
            genRt.anchoredPosition = Vector2(0, -370)
            genRt.sizeDelta = Vector2(250, 45)
            local genImg = genBtnGo:AddComponent(typeof(Image))
            genImg.color = Color(0, 0.8, 0, 1)
            local genBtn = genBtnGo:AddComponent(typeof(Button))
            local gTxtGo = GameObject("GenTxt")
            gTxtGo.transform:SetParent(genBtnGo.transform, false)
            local gTxtRt = gTxtGo:AddComponent(typeof(RectTransform))
            gTxtRt.anchorMin, gTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            gTxtRt.offsetMin, gTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local gTxt = gTxtGo:AddComponent(typeof(Text))
            gTxt.text = "TẠO TOKEN"
            gTxt.color, gTxt.fontSize, gTxt.alignment = Color.white, 20, TextAnchor.MiddleCenter
            if defaultFont then gTxt.font = defaultFont end
            
            -- Token Result
            local resGo = GameObject("ResTxt")
            resGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, resGo)
            local resRt = resGo:AddComponent(typeof(RectTransform))
            resRt.anchorMin, resRt.anchorMax, resRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            resRt.anchoredPosition = Vector2(20, -440)
            resRt.sizeDelta = Vector2(550, 60)
            local resTextGo = GameObject("Text")
            resTextGo.transform:SetParent(resGo.transform, false)
            local resTextRt = resTextGo:AddComponent(typeof(RectTransform))
            resTextRt.anchorMin, resTextRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            resTextRt.sizeDelta = Vector2(0, 0)
            local resTextComp = resTextGo:AddComponent(typeof(Text))
            resTextComp.raycastTarget = false
            resTextComp.color = Color.cyan
            resTextComp.fontSize = 14
            resTextComp.alignment = TextAnchor.UpperLeft
            if defaultFont then resTextComp.font = defaultFont end
            
            local resTxt
            pcall(function()
                local resImg = resGo:AddComponent(typeof(Image))
                resImg.color = Color(0, 0, 0, 0.5)
                resTxt = resGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
                resTxt.textComponent = resTextComp
                resTxt.text = ""
            end)

            local copyTokBtnGo = GameObject("CopyTokBtn")
            copyTokBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AdminUIList, copyTokBtnGo)
            local ctRt = copyTokBtnGo:AddComponent(typeof(RectTransform))
            ctRt.anchorMin, ctRt.anchorMax, ctRt.pivot = Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)
            ctRt.anchoredPosition = Vector2(-20, -440)
            ctRt.sizeDelta = Vector2(120, 40)
            local ctImg = copyTokBtnGo:AddComponent(typeof(Image))
            ctImg.color = Color(0.2, 0.6, 1, 1)
            local copyTokBtn = copyTokBtnGo:AddComponent(typeof(Button))
            local ctTxtGo = GameObject("CTxt")
            ctTxtGo.transform:SetParent(copyTokBtnGo.transform, false)
            local ctTxtRt = ctTxtGo:AddComponent(typeof(RectTransform))
            ctTxtRt.anchorMin, ctTxtRt.anchorMax = Vector2(0,0), Vector2(1,1)
            ctTxtRt.offsetMin, ctTxtRt.offsetMax = Vector2(0,0), Vector2(0,0)
            local ctTxt = ctTxtGo:AddComponent(typeof(Text))
            ctTxt.text = "Copy Token"
            ctTxt.color, ctTxt.fontSize, ctTxt.alignment = Color.white, 16, TextAnchor.MiddleCenter
            if defaultFont then ctTxt.font = defaultFont end
            
            copyTokBtn.onClick:AddListener(function()
                if adminGenToken ~= "" then
                    CS.UnityEngine.GUIUtility.systemCopyBuffer = adminGenToken
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã copy Token!") end
                end
            end)

            genBtn.onClick:AddListener(function()
                if adminDeviceCode == "" then
                    resTxt.text = "<color=red>Lỗi: Chưa nhập mã thiết bị!</color>"
                    return
                end
                
                local pTime = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or os.time()
                local tokenData = adminDeviceCode .. "|" .. tostring(adminDuration) .. "|" .. tostring(pTime)
                local dataToHash = tokenData .. "MUVH_SECRET_SALT_XOAI"
                
                local status, md5Hash = pcall(function()
                    return string.lower(tostring(CS.PCUtility.Md5(dataToHash)))
                end)
                if not status or not md5Hash then
                    resTxt.text = "<color=red>Lỗi: Không tạo được MD5!</color>"
                    return
                end
                
                local finalString = tokenData .. "|" .. md5Hash
                local status2, b64Token = pcall(function()
                    return Base64Encode(finalString)
                end)
                if status2 and b64Token then
                    adminGenToken = b64Token
                    resTxt.text = b64Token
                    CS.UnityEngine.GUIUtility.systemCopyBuffer = b64Token
                    if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg("Đã tạo và tự động Copy Token!") end
                else
                    resTxt.text = "<color=red>Lỗi Base64 Encode!</color>"
                end
            end)
            
            
            
            
        end
                -- Main Tab Buttons
        local isAd = _G.Mod_IsAdmin
        local width = isAd and 170 or 230
        
        local tabCoBanGo = GameObject("TabCoBanBtn")
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
        
        local tabAdminGo, tabAdminImg, tabAdminTxt, tabAdminBtn
        if isAd then
            tabAdminGo = GameObject("TabAdminBtn")
            tabAdminGo.transform:SetParent(panelGo.transform, false)
            local tabAdminRt = tabAdminGo:AddComponent(typeof(RectTransform))
            tabAdminRt.anchorMin, tabAdminRt.anchorMax, tabAdminRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tabAdminRt.anchoredPosition = Vector2(10 + (width + 10) * 3, -10)
            tabAdminRt.sizeDelta = Vector2(width, 40)
            tabAdminImg = tabAdminGo:AddComponent(typeof(Image))
            
            local tabAdminTxtGo = GameObject("Text")
            tabAdminTxtGo.transform:SetParent(tabAdminGo.transform, false)
            local tabAdminTxtRt = tabAdminTxtGo:AddComponent(typeof(RectTransform))
            tabAdminTxtRt.anchorMin, tabAdminTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            tabAdminTxtRt.sizeDelta = Vector2(0, 0)
            tabAdminTxt = tabAdminTxtGo:AddComponent(typeof(Text))
            tabAdminTxt.raycastTarget, tabAdminTxt.fontSize, tabAdminTxt.alignment = false, 20, TextAnchor.MiddleCenter
            if defaultFont then tabAdminTxt.font = defaultFont end
            tabAdminBtn = tabAdminGo:AddComponent(typeof(Button))
        end

        local function UpdateTabColors()
            tabCoBanImg.color = Color(0.2, 0.2, 0.2, 1)
            tabNangCaoImg.color = Color(0.2, 0.2, 0.2, 1)
            tabAutoBossImg.color = Color(0.2, 0.2, 0.2, 1)
            if isAd then tabAdminImg.color = Color(0.2, 0.2, 0.2, 1) end
            
            tabCoBanTxt.color = Color(0.6, 0.6, 0.6, 1)
            tabNangCaoTxt.color = Color(0.6, 0.6, 0.6, 1)
            tabAutoBossTxt.color = Color(0.6, 0.6, 0.6, 1)
            if isAd then tabAdminTxt.color = Color(0.6, 0.6, 0.6, 1) end

            tabCoBanTxt.text = "CƠ BẢN"
            tabNangCaoTxt.text = "NÂNG CAO"
            tabAutoBossTxt.text = "AUTO BOSS"
            if isAd then tabAdminTxt.text = "ADMIN" end

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
            elseif _G.ModMainTab == "ADMIN" and isAd then
                tabAdminImg.color = Color(0.2, 0.6, 0.2, 1)
                tabAdminTxt.color = Color.white
                tabAdminTxt.text = "[ ADMIN ]"
            end
        end
        UpdateTabColors()

        tabCoBanBtn.onClick:AddListener(function()
            _G.ModMainTab = "CO_BAN"
            UpdateTabColors()
            RefreshMainTabs()
        end)
        tabNangCaoBtn.onClick:AddListener(function()
            _G.ModMainTab = "NANG_CAO"
            UpdateTabColors()
            RefreshMainTabs()
        end)
        tabAutoBossBtn.onClick:AddListener(function()
            _G.ModMainTab = "AUTO_BOSS"
            UpdateTabColors()
            RefreshMainTabs()
        end)
        if isAd then
            tabAdminBtn.onClick:AddListener(function()
                _G.ModMainTab = "ADMIN"
                UpdateTabColors()
                RefreshMainTabs()
            end)
        end
        if _G.Mod_IsAdmin then
            CreateAdminUI()
        end


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
        wmTxt.text = "<i>Modded by Xoài</i>"
        wmTxt.color = Color(0.215, 0.490, 0.133, 1.0)
        wmTxt.fontSize = 16
        wmTxt.alignment = TextAnchor.LowerRight
        if defaultFont then wmTxt.font = defaultFont end

        -- Auto-Loot DropItem Hook
        _G.LastPickupTime = _G.LastPickupTime or 0
        _G.Mod_AllDropItems = _G.Mod_AllDropItems or {}
        _G.Mod_IgnoredDropItems = _G.Mod_IgnoredDropItems or {}

        if _G.PickupManager then
            local original_AddDropSceneCellPos = _G.PickupManager.AddDropSceneCellPos
            _G.PickupManager.AddDropSceneCellPos = function(item)
                original_AddDropSceneCellPos(item)
                
                if item and item.data then
                    item.data.modDropTime = Time.time or os.time()
                    _G.Mod_AllDropItems[item.data.id] = item.data
                    if _G.WriteLog then
                        local itemId = item.data.item and item.data.item.itemId or "???"
                        _G.WriteLog(string.format("[AutoLoot] AddDropSceneCellPos: Added InstanceId=%s, ItemId=%s to Mod_AllDropItems", tostring(item.data.id), tostring(itemId)))
                    end
                end

                if _G.Mod_AutoPick_KTD then
                    local mapId = 0
                    if _G.SceneData and _G.SceneData.mapId then
                        mapId = _G.SceneData.mapId
                    elseif _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.mapId then
                        mapId = _G.RoleManager.me.mapId
                    end
                    
                    if mapId == 1077 and item and item.data then
                        local dropItemData = item.data
                        -- Automatically send pickup request immediately
                        if _G.Timer and _G.Timer.StartLoop then
                            _G.Timer.StartLoop(0.02, 10, function()
                                if _G.PickupManager then _G.PickupManager.ReqPickUpMapItem(dropItemData.id) end
                            end)
                        else
                            _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                        end
                        
                        -- Log so the user can see what dropped and check the ConfigID
                        if _G.WriteLog then
                            _G.WriteLog(string.format("[KTĐ] Phát hiện & Tự Nhặt! InstanceId=%s, ConfigId=%s, Type=%s", tostring(dropItemData.id), tostring(dropItemData.configId), tostring(dropItemData.type)))
                        end
                    end
                end

                if _G.AutoPick_Enabled and _G.Mod_IsAdmin and _G.AutoPick_InstantLoot then
                    local dropItemData = item.data
                    if not _G.Mod_IgnoredDropItems[dropItemData.id] then
                        local currentTime = Time.time or os.time()
                        
                        local eType = dropItemData.type
                        local isRune = (eType == 19 or eType == 28)
                        local isBone = (eType == 24 or eType == 26)
                        local isNormal = (not isRune and not isBone)
                        if isNormal and not _G.AutoPick_FilterNormal then isNormal = false end
                        
                        local shouldPick = false
                        if isRune and _G.AutoPick_FilterRune then shouldPick = true end
                        if isBone and _G.AutoPick_FilterBone then shouldPick = true end
                        if isNormal then shouldPick = true end
                        
                        if shouldPick then
                            if _G.PickupManager and _G.PickupManager.IsCanPickUpDropItem then
                                if not _G.PickupManager.IsCanPickUpDropItem(dropItemData) then
                                    shouldPick = false
                                end
                            end
                        end
                        
                        if shouldPick then
                            _G.Mod_PickedItems = _G.Mod_PickedItems or {}
                            local isAlreadyPicked = _G.Mod_PickedItems[dropItemData.id]
                            
                            if not isAlreadyPicked and (_G.AutoPick_Limit > 1 and _G.AutoPick_Count < _G.AutoPick_Limit) then
                                local lootCount = 3
                                if _G.Timer and _G.Timer.StartLoop then
                                    _G.Timer.StartLoop(0.05, lootCount, function()
                                        if _G.PickupManager then _G.PickupManager.ReqPickUpMapItem(dropItemData.id) end
                                    end)
                                else
                                    _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                                end
                                dropItemData.modLastReqTime = currentTime
                                _G.LastPickupTime = currentTime
                                
                                _G.Mod_PickedItems[dropItemData.id] = true
                                _G.AutoPick_Count = _G.AutoPick_Count + 1
                                
                                local itemId = dropItemData.item and dropItemData.item.itemId or "???"
                                WriteLog("[AutoLoot] Nhặt (Tức thì): Item [ID: " .. tostring(itemId) .. "]")
                                
                                if _G.RoleManager and _G.RoleManager.me and dropItemData.x and dropItemData.y then
                                    pcall(function()
                                        if _G.WriteLog then
                                            _G.WriteLog(string.format("[AutoLoot] (Tức thì) MoveTo ItemId=%s, X=%s, Y=%s", tostring(itemId), tostring(dropItemData.x), tostring(dropItemData.y)))
                                        end
                                        _G.RoleManager.me:MoveTo({x = dropItemData.x, y = dropItemData.y})
                                    end)
                                end
                            end
                        else
                            _G.Mod_IgnoredDropItems[dropItemData.id] = true
                        end
                    end
                end
            end
        end

        if _G.DropItemManager then
            if not _G.Mod_HookedDestroyDropItem then
                _G.Mod_HookedDestroyDropItem = true
                local original_DestroyDropItem = _G.DropItemManager.DestroyDropItem
                _G.DropItemManager.DestroyDropItem = function(id)
                    if original_DestroyDropItem then original_DestroyDropItem(id) end
                    if _G.Mod_AllDropItems then _G.Mod_AllDropItems[id] = nil end
                    if _G.Mod_IgnoredDropItems then _G.Mod_IgnoredDropItems[id] = nil end
                end
                
                local original_DestroyDropItems = _G.DropItemManager.DestroyDropItems
                _G.DropItemManager.DestroyDropItems = function(...)
                    if original_DestroyDropItems then original_DestroyDropItems(...) end
                    _G.Mod_AllDropItems = {}
                    _G.Mod_IgnoredDropItems = {}
                end
            end
        end

        if _G.Timer and _G.Timer.StartLoop and not _G.ModFastLootTimerStarted then
            _G.ModFastLootTimerStarted = true
            _G.Timer.StartLoop(0.05, -1, function()
                if _G.WriteLog and _G.Mod_AllDropItems then
                    local currCount = 0
                    local itemIds = {}
                    for id, dropItemData in pairs(_G.Mod_AllDropItems) do
                        currCount = currCount + 1
                        local itemId = dropItemData.item and dropItemData.item.itemId or "???"
                        table.insert(itemIds, "ID:" .. tostring(itemId))
                    end
                    if currCount > 0 and currCount ~= _G.Mod_LastLogAllDropCount then
                        _G.WriteLog("[AutoLoot] Hiện có trong Mod_AllDropItems: " .. table.concat(itemIds, ", "))
                        _G.Mod_LastLogAllDropCount = currCount
                    elseif currCount == 0 then
                        _G.Mod_LastLogAllDropCount = 0
                    end
                end
                pcall(function()
                    if _G.AutoPick_Enabled and _G.Mod_AllDropItems then
                        local currentTime = Time.time or os.time()
                        local hasDinoNearby = false
                        if not _G.Mod_IsAdmin and _G.RoleManager and _G.RoleManager.GetRolesByType then
                            local players = _G.RoleManager.GetRolesByType(1)
                            if players then
                                for _, p in pairs(players) do
                                    if p.name and p.name == "Dino" then
                                        hasDinoNearby = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        local hasItems = false
                        for id, dropItemData in pairs(_G.Mod_AllDropItems) do
                            if not _G.Mod_IgnoredDropItems[id] then
                                hasItems = true
                                break
                            end
                        end
                        
                        if not hasItems then
                            _G.Mod_DinoDelayStart = nil
                        elseif hasDinoNearby then
                            _G.Mod_DinoDelayStart = _G.Mod_DinoDelayStart or currentTime
                            if currentTime - _G.Mod_DinoDelayStart < 1.0 then
                                return
                            end
                        end
                        
                        for id, dropItemData in pairs(_G.Mod_AllDropItems) do
                            if not _G.Mod_IgnoredDropItems[id] then
                                local eType = dropItemData.type
                                local isRune = (eType == 19 or eType == 28)
                                local isBone = (eType == 24 or eType == 26)
                                local isNormal = (not isRune and not isBone)
                                if isNormal and not _G.AutoPick_FilterNormal then isNormal = false end
                                
                                local shouldPick = false
                                if isRune and _G.AutoPick_FilterRune then shouldPick = true end
                                if isBone and _G.AutoPick_FilterBone then shouldPick = true end
                                if isNormal then shouldPick = true end
                                
                                if shouldPick then
                                    if _G.PickupManager and _G.PickupManager.IsCanPickUpDropItem then
                                        if not _G.PickupManager.IsCanPickUpDropItem(dropItemData) then
                                            shouldPick = false
                                        end
                                    end
                                end
                                
                                if shouldPick then
                                    local itemId = dropItemData.item and dropItemData.item.itemId or 0
                                    local score = tonumber(itemId) or 0
                                    dropItemData.modScore = score
                                    
                                    if _G.WriteLog then
                                        _G.WriteLog(string.format("[AutoLoot] Scored ItemId=%s: score=%s", tostring(itemId), tostring(score)))
                                    end
                                    
                                    if not _G.Mod_ValidDropItems then _G.Mod_ValidDropItems = {} end
                                    table.insert(_G.Mod_ValidDropItems, dropItemData)
                                else
                                    _G.Mod_IgnoredDropItems[id] = true
                                end
                            end
                        end
                        
                        if _G.Mod_ValidDropItems and #_G.Mod_ValidDropItems > 0 then
                            local useRandom = true
                            if _G.Mod_IsAdmin and _G.AutoPick_RandomLoot == false then
                                useRandom = false
                            end

                            if not useRandom then
                                table.sort(_G.Mod_ValidDropItems, function(a, b) return (a.modScore or 0) > (b.modScore or 0) end)
                            else
                                local n = #_G.Mod_ValidDropItems
                                while n > 1 do
                                    local k = math.random(n)
                                    _G.Mod_ValidDropItems[n], _G.Mod_ValidDropItems[k] = _G.Mod_ValidDropItems[k], _G.Mod_ValidDropItems[n]
                                    n = n - 1
                                end
                            end
                            
                            local cooldown = _G.Mod_IsAdmin and 0.1 or 0.5
                            local maxToPick = _G.AutoPick_Limit - (_G.AutoPick_Count or 0)
                            if not _G.Mod_BatchLootIds then _G.Mod_BatchLootIds = {} end
                            if not _G.Mod_BatchLootNames then _G.Mod_BatchLootNames = {} end
                            
                            local pickedThisTick = 0
                            for i, dropItemData in ipairs(_G.Mod_ValidDropItems) do
                                _G.Mod_PickedItems = _G.Mod_PickedItems or {}
                                local isAlreadyPicked = _G.Mod_PickedItems[dropItemData.id]
                                
                                if isAlreadyPicked or pickedThisTick < maxToPick then
                                    if not dropItemData.modLastReqTime or (currentTime - dropItemData.modLastReqTime > cooldown) then
                                        table.insert(_G.Mod_BatchLootIds, dropItemData.id)
                                        dropItemData.modLastReqTime = currentTime
                                        _G.LastPickupTime = currentTime
                                        
                                        if not isAlreadyPicked then
                                            _G.Mod_PickedItems[dropItemData.id] = true
                                            _G.AutoPick_Count = (_G.AutoPick_Count or 0) + 1
                                            pickedThisTick = pickedThisTick + 1
                                            
                                            local itemId = dropItemData.item and dropItemData.item.itemId or "???"
                                            table.insert(_G.Mod_BatchLootNames, "Item [" .. tostring(itemId) .. "]")
                                        end
                                        
                                        if _G.RoleManager and _G.RoleManager.me and dropItemData.x and dropItemData.y then
                                            pcall(function()
                                                if _G.WriteLog then
                                                    _G.WriteLog(string.format("[AutoLoot] MoveTo ItemId=%s, X=%s, Y=%s", tostring(itemId), tostring(dropItemData.x), tostring(dropItemData.y)))
                                                end
                                                _G.RoleManager.me:MoveTo({x = dropItemData.x, y = dropItemData.y})
                                            end)
                                        end
                                    end
                                end
                            end
                            _G.Mod_ValidDropItems = {}
                        end
                        
                        if _G.Mod_BatchLootIds and #_G.Mod_BatchLootIds > 0 then
                            _G.PickupManager.ReqPickUpMapItems(_G.Mod_BatchLootIds)
                            if _G.Mod_BatchLootNames and #_G.Mod_BatchLootNames > 0 then
                                WriteLog("[AutoLoot] Nhặt (Quét Batch): " .. table.concat(_G.Mod_BatchLootNames, ", "))
                            end
                            
                            -- local limitTxtGo = CS.UnityEngine.GameObject.Find("LimitValText")
                            -- if limitTxtGo then
                            --     local lTxt = limitTxtGo:GetComponent(typeof(CS.UnityEngine.UI.Text))
                            --     if lTxt then
                            --         lTxt.text = string.format("<color=#00FF00>%d</color> / %d", _G.AutoPick_Count, _G.AutoPick_Limit)
                            --     end
                            -- end
                            
                            _G.Mod_BatchLootIds = {}
                            _G.Mod_BatchLootNames = {}
                        end
                    end
                end)
            end)
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
                end
            end
            
            return ret
        end
    else
        WriteLog("LỖI: UIManager chưa được tải! ")
    end
    if _G.Timer and _G.Timer.StartLoop and not _G.ModAutoFarmBossTimerStarted then
        _G.ModAutoFarmBossTimerStarted = true
        _G.Timer.StartLoop(3, -1, function()
            pcall(function()
                if not _G.Mod_AutoFarmBoss_Enabled then return end
                if not _G.Mod_MapBosses then return end
                if not _G.Mod_AutoFarmBoss_Config then return end
                
                local mapsConfig = _G.ModAutoBossConfigTab == "C7" and _G.Mod_MapsConfig_c7 or _G.Mod_MapsConfig_c8
                if not mapsConfig then return end
                
                local me = _G.RoleManager and _G.RoleManager.me
                if not me then return end
                
                local validBosses = {}
                
                for mapIndex, mapCfg in ipairs(mapsConfig) do
                    local bossData = _G.Mod_MapBosses[mapCfg.mapId]
                    if bossData then
                        for _, cfg in ipairs(mapCfg.bosses) do
                            if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                local bData = bossData[cfg.id]
                                if bData then
                                    local isAlive = false
                                    local minDeadTime = 9999999999
                                    local bestLine = 1
                                    
                                    for _, lineNum in ipairs(bData.lineNums or {}) do
                                        local totalAlive = bData.aliveCount[lineNum] or 0
                                        local deadList = bData.deadTimes[lineNum] or {}
                                        local expectedTotal = cfg.total or 1
                                        
                                        if totalAlive > 0 or #deadList < expectedTotal then
                                            isAlive = true
                                            bestLine = lineNum
                                            break
                                        end
                                        
                                        for i = 1, #deadList do
                                            if deadList[i] < minDeadTime then
                                                minDeadTime = deadList[i]
                                                bestLine = lineNum
                                            end
                                        end
                                    end
                                    
                                    table.insert(validBosses, {
                                        cfg = cfg,
                                        mapId = mapCfg.mapId,
                                        isAlive = isAlive,
                                        minDeadTime = minDeadTime,
                                        bestLine = bestLine,
                                        mapIndex = mapIndex
                                    })
                                end
                            end
                        end
                    end
                end
                
                if #validBosses == 0 then return end
                
                table.sort(validBosses, function(a, b)
                    if a.isAlive ~= b.isAlive then
                        return a.isAlive
                    end
                    if a.isAlive then
                        return a.mapIndex < b.mapIndex
                    else
                        return a.minDeadTime < b.minDeadTime
                    end
                end)
                
                local targetBoss = validBosses[1]
                local currentMapId = _G.SceneData and _G.SceneData.mapId or 0
                
                if currentMapId ~= targetBoss.mapId then
                    if _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                        _G.SceneController.OnReqTransferTransmitMap(nil, { mapId = targetBoss.cfg.transferId, line = targetBoss.bestLine, changeLine = true })
                    end
                else
                    if me.SetAutoFight then
                        local isAutoFight = _G.RoleManager.me.isAutoFight
                        if not isAutoFight then
                            _G.RoleManager.me:SetAutoFight("AutoFight")
                        end
                    end
                end
            end)
        end)
    end
end)
if not status then
    WriteLog("LỖI HOOK UIManager: " .. tostring(err))
end

return true

-- EmmyluaDebug.lua
-- Bắt buộc phải có để Main.lua gọi không bị lỗi
EmmyluaDebug = {}
function EmmyluaDebug.InitEmmyluaDebug(obj)
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
        local finalMsg = tostring(msg) .. "\n"
        local f = io.open(logPath, "a")
        if f then
            f:write(finalMsg)
            f:close()
        end
        CS.UnityEngine.Debug.LogError("[MySuperMod] " .. tostring(msg))
    end)
end
_G.WriteLog = WriteLog

WriteLog("--- BẮT ĐẦU KHỞI TẠO HOOK MOD MENU ---")

local function CreateModUI()
    local status, err = pcall(function()
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
        rt.anchoredPosition = Vector2(20, 80)
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
        txt.text = "MOD"
        txt.color = Color.white
        txt.fontSize = 20
        txt.alignment = TextAnchor.MiddleCenter
        if defaultFont then txt.font = defaultFont end

        local panelGo = GameObject("ModMenuPanel")
        panelGo.transform:SetParent(modRoot.transform, false)
        local panelRt = panelGo:AddComponent(typeof(RectTransform))
        panelRt.anchorMin = Vector2(0, 0)
        panelRt.anchorMax = Vector2(0, 0)
        panelRt.pivot = Vector2(0, 0)
        panelRt.anchoredPosition = Vector2(90, 80)
        panelRt.sizeDelta = Vector2(1000, 500)

        local panelImg = panelGo:AddComponent(typeof(Image))
        panelImg.color = Color(0, 0, 0, 0.8)
        panelGo:SetActive(false)

        local isExpanded = false
        local btnComp = btnGo:AddComponent(typeof(Button))
        
        local testBtnGo = GameObject("FOVMinusBtn")
        testBtnGo.transform:SetParent(panelGo.transform, false)
        local testRt = testBtnGo:AddComponent(typeof(RectTransform))
        testRt.anchorMin = Vector2(0, 1)
        testRt.anchorMax = Vector2(0, 1)
        testRt.pivot = Vector2(0, 1)
        testRt.anchoredPosition = Vector2(10, -20)
        testRt.sizeDelta = Vector2(40, 30)

        local testImg = testBtnGo:AddComponent(typeof(Image))
        testImg.color = Color(0.4, 0.4, 0.4, 1)

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
        fovValRt.anchoredPosition = Vector2(50, -20)
        fovValRt.sizeDelta = Vector2(100, 30)
        local fovValTxt = fovValGo:AddComponent(typeof(Text))
        fovValTxt.raycastTarget = false
        fovValTxt.text = "FOV: " .. tostring(_G.currentFOV or 55)
        fovValTxt.color = Color.white
        fovValTxt.fontSize = 18
        fovValTxt.alignment = TextAnchor.MiddleCenter
        if defaultFont then fovValTxt.font = defaultFont end

        local plusBtnGo = GameObject("FOVPlusBtn")
        plusBtnGo.transform:SetParent(panelGo.transform, false)
        local plusRt = plusBtnGo:AddComponent(typeof(RectTransform))
        plusRt.anchorMin = Vector2(0, 1)
        plusRt.anchorMax = Vector2(0, 1)
        plusRt.pivot = Vector2(0, 1)
        plusRt.anchoredPosition = Vector2(150, -20)
        plusRt.sizeDelta = Vector2(40, 30)

        local plusImg = plusBtnGo:AddComponent(typeof(Image))
        plusImg.color = Color(0.4, 0.4, 0.4, 1)

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

                local mapsConfig_c7 = {
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
                title = "Thí Luyện Cảnh 6",
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
        
        local mapsConfig_c8 = {
            {
                mapId = 1074,
                title = "Hoang Dã C8",
                bosses = {
                    { id = 107407, name = "K.Sĩ Tử Vong", col = 1, transferId = 400244, total = 2 },
                    { id = 107408, name = "Phẫn Nộ", col = 2, transferId = 400245, total = 2 },
                    { id = 107409, name = "Cuồng Bạo", col = 3, transferId = 400246, total = 2 },
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
                rt.sizeDelta = Vector2(670, 20)
                local txt = sepGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color(0.4, 0.4, 0.4, 1)
                txt.fontSize = 16
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                txt.text = "----------------------------------------------------------------------------------------------------------------"
                sepUIPool[index] = { go = sepGo, txt = txt, rt = rt }
            end
            sepUIPool[index].rt.anchoredPosition = Vector2(0, posY)
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
                rt.sizeDelta = Vector2(780, 30)
                local txt = titleGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color(1, 0.8, 0, 1)
                txt.fontSize = 18
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
                titleUIPool[index] = { go = titleGo, txt = txt, rt = rt }
            end
            titleUIPool[index].rt.anchoredPosition = Vector2(10, posY)
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
            end
            btnUIPool[btnIndex].rt.anchoredPosition = Vector2(posX, posY)
            btnUIPool[btnIndex].rt.sizeDelta = Vector2(width, 30)
            return btnUIPool[btnIndex]
        end

        local function UpdateBossWatchUIText()
            pcall(function()
                if not isExpanded then return end
                local currentSec = _G.Time.GetServerSecondTime()
                local currentPosY = -100
                local titleIdx = 1
                local rowIdx = 1
                local btnIdx = 1
                local sepIdx = 1
                
                local tabBtnC7 = GetLineButton(btnIdx, 10, currentPosY, 100)
                tabBtnC7.go:SetActive(true)
                tabBtnC7.txt.text = "<color=" .. (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ TAB: C7 ]</color>"
                tabBtnC7.btn.onClick:RemoveAllListeners()
                tabBtnC7.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C7"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1

                local tabBtnC8 = GetLineButton(btnIdx, 120, currentPosY, 100)
                tabBtnC8.go:SetActive(true)
                tabBtnC8.txt.text = "<color=" .. (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ TAB: C8 ]</color>"
                tabBtnC8.btn.onClick:RemoveAllListeners()
                tabBtnC8.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C8"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1
                
                currentPosY = currentPosY - 25

                local mapsConfig = _G.ModBossTab == "C8" and mapsConfig_c8 or mapsConfig_c7
                for i, mapCfg in ipairs(mapsConfig) do
                    local sep = GetDashedLine(sepIdx, currentPosY)
                    sep.go:SetActive(true)
                    sepIdx = sepIdx + 1
                    currentPosY = currentPosY - 25

                    local title = GetTitleLabel(titleIdx, currentPosY)
                    title.go:SetActive(true)
                    title.txt.text = mapCfg.title
                    
                    titleIdx = titleIdx + 1
                    currentPosY = currentPosY - 35
                    
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
                                local startX = 10 + (c - 1) * 220
                                local yPos = currentPosY - (r - 1) * 35
                                
                                local uiBtn = GetLineButton(btnIdx, startX, yPos, 215)
                                uiBtn.go:SetActive(true)
                                
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
                                uiBtn.txt.fontSize = 14
                                
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
                panelRt.sizeDelta = Vector2(1000, requiredHeight)
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
                            self.attributeMap[speedKey] = self.attributeMap[speedKey] * _G.AtkSpeedMultiplier
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

            local original_RefreshAncientBossData = _G.SceneData.RefreshAncientBossData
            _G.SceneData.RefreshAncientBossData = function(self, tblData)
                if original_RefreshAncientBossData then original_RefreshAncientBossData(self, tblData) end
                if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
            end
            
            if _G.Timer and _G.Timer.StartLoop then
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
                    
                    if isExpanded then
                        UpdateBossWatchUIText()
                        if _G.ModUpdateCountText then _G.ModUpdateCountText() end
                        
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

        _G.ModCallbacks.OnToggleMenu = function()
            pcall(function()
                isExpanded = not isExpanded
                panelGo:SetActive(isExpanded)
                if isExpanded then 
                    UpdateFOVLabel() 
                    if _G.NetManager and _G.MapMessage then
                        _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
                        _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 16})
                        _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, {type = 17})
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
        rmRt.anchoredPosition = Vector2(10, -60)
        rmRt.sizeDelta = Vector2(40, 30)
        local rmImg = refreshMinusBtnGo:AddComponent(typeof(Image))
        rmImg.color = Color(0.2, 0.2, 0.2, 1)
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
        rpRt.anchoredPosition = Vector2(150, -60)
        rpRt.sizeDelta = Vector2(40, 30)
        local rpImg = refreshPlusBtnGo:AddComponent(typeof(Image))
        rpImg.color = Color(0.2, 0.2, 0.2, 1)
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
        tgRt.anchoredPosition = Vector2(50, -60)
        tgRt.sizeDelta = Vector2(100, 30)
        local rtImg = refreshToggleGo:AddComponent(typeof(Image))
        rtImg.color = Color(0.2, 0.2, 0.2, 0)
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

        -- Speed Hack UI
        _G.RunSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_RunSpeed", 1.0)
        _G.AtkSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_AtkSpeed", 1.0)

        local function SaveSpeedSettings()
            pcall(function()
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_RunSpeed", _G.RunSpeedMultiplier)
                CS.UnityEngine.PlayerPrefs.SetFloat("Mod_AtkSpeed", _G.AtkSpeedMultiplier)
                CS.UnityEngine.PlayerPrefs.Save()
            end)
        end

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
            vTxt.raycastTarget = false
            vTxt.text = string.format("%s%.1fx", prefix, _G[valueVarName])
            vTxt.alignment = TextAnchor.MiddleCenter
            vTxt.color = Color(0.8, 1, 0.8, 1)
            vTxt.fontSize = 18
            if defaultFont then vTxt.font = defaultFont end

            local minusBtnGo = GameObject(valueVarName .. "_Minus")
            minusBtnGo.transform:SetParent(panelGo.transform, false)
            local mRt = minusBtnGo:AddComponent(typeof(RectTransform))
            mRt.anchorMin = Vector2(0, 1)
            mRt.anchorMax = Vector2(0, 1)
            mRt.pivot = Vector2(0, 1)
            mRt.anchoredPosition = Vector2(centerX - 120, yPos)
            mRt.sizeDelta = Vector2(40, 30)
            local mImg = minusBtnGo:AddComponent(typeof(Image))
            mImg.color = Color(0.3, 0.3, 0.3, 1)
            local mTxtGo = GameObject(valueVarName .. "_MinusTxt")
            mTxtGo.transform:SetParent(minusBtnGo.transform, false)
            local mTxtRt = mTxtGo:AddComponent(typeof(RectTransform))
            mTxtRt.anchorMin = Vector2(0, 0)
            mTxtRt.anchorMax = Vector2(1, 1)
            mTxtRt.sizeDelta = Vector2(0, 0)
            local mTxt = mTxtGo:AddComponent(typeof(Text))
            mTxt.raycastTarget = false
            mTxt.text = "-"
            mTxt.color = Color.white
            mTxt.fontSize = 18
            mTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then mTxt.font = defaultFont end

            local plusBtnGo = GameObject(valueVarName .. "_Plus")
            plusBtnGo.transform:SetParent(panelGo.transform, false)
            local pRt = plusBtnGo:AddComponent(typeof(RectTransform))
            pRt.anchorMin = Vector2(0, 1)
            pRt.anchorMax = Vector2(0, 1)
            pRt.pivot = Vector2(0, 1)
            pRt.anchoredPosition = Vector2(centerX + 80, yPos)
            pRt.sizeDelta = Vector2(40, 30)
            local pImg = plusBtnGo:AddComponent(typeof(Image))
            pImg.color = Color(0.3, 0.3, 0.3, 1)
            local pTxtGo = GameObject(valueVarName .. "_PlusTxt")
            pTxtGo.transform:SetParent(plusBtnGo.transform, false)
            local pTxtRt = pTxtGo:AddComponent(typeof(RectTransform))
            pTxtRt.anchorMin = Vector2(0, 0)
            pTxtRt.anchorMax = Vector2(1, 1)
            pTxtRt.sizeDelta = Vector2(0, 0)
            local pTxt = pTxtGo:AddComponent(typeof(Text))
            pTxt.raycastTarget = false
            pTxt.text = "+"
            pTxt.color = Color.white
            pTxt.fontSize = 18
            pTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then pTxt.font = defaultFont end

            local function UpdateLabel()
                vTxt.text = string.format("%s%.1fx", prefix, _G[valueVarName])
            end

            local mBtnComp = minusBtnGo:AddComponent(typeof(Button))
            mBtnComp.onClick:AddListener(function()
                pcall(function()
                    _G[valueVarName] = _G[valueVarName] - step
                    if _G[valueVarName] < 1.0 then _G[valueVarName] = 1.0 end
                    UpdateLabel()
                    SaveSpeedSettings()
                end)
            end)
            
            local pBtnComp = plusBtnGo:AddComponent(typeof(Button))
            pBtnComp.onClick:AddListener(function()
                pcall(function()
                    _G[valueVarName] = _G[valueVarName] + step
                    if _G[valueVarName] > 5.0 then _G[valueVarName] = 5.0 end
                    UpdateLabel()
                    SaveSpeedSettings()
                end)
            end)
        end

        CreateSpeedControl(310, -20, "Tốc Chạy: ", "RunSpeedMultiplier", 0.1)
        CreateSpeedControl(310, -60, "Tốc Đánh: ", "AtkSpeedMultiplier", 0.1)

        -- Thêm vạch kẻ dọc phân chia
        local vLineGo = GameObject("VerticalSeparator")
        vLineGo.transform:SetParent(panelGo.transform, false)
        local vLineRt = vLineGo:AddComponent(typeof(RectTransform))
        vLineRt.anchorMin = Vector2(0, 0)
        vLineRt.anchorMax = Vector2(0, 1)
        vLineRt.pivot = Vector2(0, 1)
        vLineRt.offsetMin = Vector2(670, 10)
        vLineRt.offsetMax = Vector2(672, -10)
        local vLineImg = vLineGo:AddComponent(typeof(Image))
        vLineImg.color = Color(0.4, 0.4, 0.4, 1)


        -- Auto-Loot State
        if _G.AutoPick_Enabled == nil then _G.AutoPick_Enabled = false end
        if _G.AutoPick_FilterRune == nil then _G.AutoPick_FilterRune = true end
        if _G.AutoPick_FilterBone == nil then _G.AutoPick_FilterBone = true end
        if _G.AutoPick_FilterNormal == nil then _G.AutoPick_FilterNormal = false end
        if _G.AutoPick_Limit == nil then _G.AutoPick_Limit = 2 end
        _G.AutoPick_Count = 0

        local function CreateAutoLootUI()
            local currentY = -20
            local rightColX = 680

            local function CreateToggle(label, varName, yPos)
                local tGo = GameObject(varName .. "_Toggle")
                tGo.transform:SetParent(panelGo.transform, false)
                local tRt = tGo:AddComponent(typeof(RectTransform))
                tRt.anchorMin = Vector2(0, 1)
                tRt.anchorMax = Vector2(0, 1)
                tRt.pivot = Vector2(0, 1)
                tRt.anchoredPosition = Vector2(rightColX, yPos)
                tRt.sizeDelta = Vector2(300, 30)

                local btn = tGo:AddComponent(typeof(Button))
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
                    UpdateLabel()
                    pcall(function()
                        if _G.EventManager and _G.Event and _G.Event.QiJiHelper_SetAutoPickup then
                            _G.EventManager.Dispatch(_G.Event.QiJiHelper_SetAutoPickup)
                        end
                    end)
                end)
            end

            CreateToggle("NHẶT ĐỒ SIÊU TỐC", "AutoPick_Enabled", currentY)
            currentY = currentY - 20
            
            local alSepGo = GameObject("AutoLootSeparator")
            alSepGo.transform:SetParent(panelGo.transform, false)
            local alSepRt = alSepGo:AddComponent(typeof(RectTransform))
            alSepRt.anchorMin = Vector2(0, 1)
            alSepRt.anchorMax = Vector2(0, 1)
            alSepRt.pivot = Vector2(0, 1)
            alSepRt.anchoredPosition = Vector2(rightColX, currentY)
            alSepRt.sizeDelta = Vector2(300, 20)
            local alSepTxt = alSepGo:AddComponent(typeof(Text))
            alSepTxt.raycastTarget = false
            alSepTxt.color = Color(0.4, 0.4, 0.4, 1)
            alSepTxt.fontSize = 16
            alSepTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then alSepTxt.font = defaultFont end
            alSepTxt.text = "--------------------------------------------------"
            
            currentY = currentY - 25
            CreateToggle("Nhặt Phù Văn", "AutoPick_FilterRune", currentY)
            currentY = currentY - 35
            CreateToggle("Nhặt Thánh Cốt", "AutoPick_FilterBone", currentY)
            currentY = currentY - 40

            -- Limit Control
            local lValGo = GameObject("LimitValText")
            lValGo.transform:SetParent(panelGo.transform, false)
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
                    lvTxt.text = "- Số lượng nhặt: " .. tostring(_G.AutoPick_Limit)
                end
            end)
            
            local lpBtnComp = lPlusGo:AddComponent(typeof(Button))
            lpBtnComp.onClick:AddListener(function()
                _G.AutoPick_Limit = _G.AutoPick_Limit + 1
                lvTxt.text = "- Số lượng nhặt: " .. tostring(_G.AutoPick_Limit)
            end)

            currentY = currentY - 45
            local rstBtnGo = GameObject("ResetPickBtn")
            rstBtnGo.transform:SetParent(panelGo.transform, false)
            local rstRt = rstBtnGo:AddComponent(typeof(RectTransform))
            rstRt.anchorMin = Vector2(0, 1)
            rstRt.anchorMax = Vector2(0, 1)
            rstRt.pivot = Vector2(0, 1)
            rstRt.anchoredPosition = Vector2(rightColX, currentY)
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
                WriteLog("[AutoLoot] Manual Reset Triggered! Count is now 0")
                if _G.ModUpdateCountText then _G.ModUpdateCountText() end
            end)

            currentY = currentY - 30
            local hintGo = GameObject("ResetHint")
            hintGo.transform:SetParent(panelGo.transform, false)
            local hintRt = hintGo:AddComponent(typeof(RectTransform))
            hintRt.anchorMin = Vector2(0, 1)
            hintRt.anchorMax = Vector2(0, 1)
            hintRt.pivot = Vector2(0, 1)
            hintRt.anchoredPosition = Vector2(rightColX - 45, currentY)
            hintRt.sizeDelta = Vector2(350, 20)
            local hintTxt = hintGo:AddComponent(typeof(Text))
            hintTxt.raycastTarget = false
            hintTxt.text = "(Ấn nút này mỗi lần chuẩn bị đánh Kundun)"
            hintTxt.color = Color(0.7, 0.7, 0.7, 1)
            hintTxt.fontSize = 14
            hintTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then hintTxt.font = defaultFont end
            
            currentY = currentY - 25
            local currCountGo = GameObject("CurrentCountText")
            currCountGo.transform:SetParent(panelGo.transform, false)
            local ccRt = currCountGo:AddComponent(typeof(RectTransform))
            ccRt.anchorMin = Vector2(0, 1)
            ccRt.anchorMax = Vector2(0, 1)
            ccRt.pivot = Vector2(0, 1)
            ccRt.anchoredPosition = Vector2(rightColX, currentY)
            ccRt.sizeDelta = Vector2(260, 20)
            local ccTxt = currCountGo:AddComponent(typeof(Text))
            ccTxt.raycastTarget = false
            ccTxt.text = "Số lượt nhặt hiện tại: 0"
            ccTxt.color = Color(0.6, 1, 0.6, 1)
            ccTxt.fontSize = 16
            ccTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then ccTxt.font = defaultFont end

            _G.ModUpdateCountText = function()
                pcall(function()
                    if ccTxt and not ccTxt:Equals(nil) then
                        ccTxt.text = "Số lượt nhặt hiện tại: " .. tostring(_G.AutoPick_Count or 0)
                    end
                end)
            end

        end 

        CreateAutoLootUI()

        local function CreateKundunUI()
            local currentY = -340
            local rightColX = 680
            
            local sepGo = GameObject("KundunSeparator")
            sepGo.transform:SetParent(panelGo.transform, false)
            local sepRt = sepGo:AddComponent(typeof(RectTransform))
            sepRt.anchorMin = Vector2(0, 1)
            sepRt.anchorMax = Vector2(0, 1)
            sepRt.pivot = Vector2(0, 1)
            sepRt.anchoredPosition = Vector2(rightColX, currentY)
            sepRt.sizeDelta = Vector2(300, 20)
            local sepTxt = sepGo:AddComponent(typeof(Text))
            sepTxt.raycastTarget = false
            sepTxt.color = Color(0.4, 0.4, 0.4, 1)
            sepTxt.fontSize = 16
            sepTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sepTxt.font = defaultFont end
            sepTxt.text = "--------------------------------------------------"
            
            currentY = currentY - 25
            
            local titleGo = GameObject("KundunTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin = Vector2(0, 1)
            titleRt.anchorMax = Vector2(0, 1)
            titleRt.pivot = Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX, currentY)
            titleRt.sizeDelta = Vector2(300, 20)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ THÔNG TIN KUNDUN BOSS ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then titleTxt.font = defaultFont end
            
            currentY = currentY - 30
            
            _G.KundunUILabelPool = {}
            for i = 1, 2 do
                local rowGo = GameObject("KundunRow_" .. i)
                rowGo.transform:SetParent(panelGo.transform, false)
                local rt = rowGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0, 1)
                rt.anchorMax = Vector2(0, 1)
                rt.pivot = Vector2(0, 1)
                rt.anchoredPosition = Vector2(rightColX + 20, currentY)
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
                    if not _G.KundunUILabelPool then return end
                    
                    local kundunConfigs = {}
                    if _G.ModBossTab == "C8" then
                        table.insert(kundunConfigs, { name = "Thánh Cốt C8:", bossType = 16, bossId = 20201008, limit = 70 })
                        table.insert(kundunConfigs, { name = "Phù Văn C8:", bossType = 17, bossId = 20211008, limit = 400 })
                    else
                        table.insert(kundunConfigs, { name = "Thánh Cốt C7:", bossType = 16, bossId = 20201007, limit = 70 })
                        table.insert(kundunConfigs, { name = "Phù Văn C7:", bossType = 17, bossId = 20211007, limit = 300 })
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
                            txt.text = cfg.name .. string.format(" <color=#00FF00>%d / %d</color> (%d)", count, cfg.limit, rCount)
                        end
                    end
                end)
            end
        end 

        CreateKundunUI()

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
        wmTxt.color = Color(0.6, 0.6, 0.6, 0.8)
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
                    _G.Mod_AllDropItems[item.data.id] = item.data
                end

                if _G.AutoPick_Enabled then
                    local dropItemData = item.data
                    if not _G.Mod_IgnoredDropItems[dropItemData.id] then
                        local currentTime = Time.time or os.time()
                        local itemConfig = nil
                        if _G.ItemData and _G.ItemData.ItemMgr and dropItemData.item then
                            itemConfig = _G.ItemData.ItemMgr.GetItemConfig(dropItemData.item.itemId)
                        end
                        
                        local eType = itemConfig and itemConfig.type or dropItemData.type
                        local isRune = (eType == 19 or eType == 28)
                        local isBone = (eType == 24 or eType == 26)
                        local isNormal = (not isRune and not isBone)
                        if isNormal and not _G.AutoPick_FilterNormal then
                            isNormal = false
                        end

                        local shouldPick = false
                        if isRune and _G.AutoPick_FilterRune then shouldPick = true end
                        if isBone and _G.AutoPick_FilterBone then shouldPick = true end
                        if isNormal then shouldPick = true end

                        if shouldPick then
                            if _G.AutoPick_Count < _G.AutoPick_Limit then
                                _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                                dropItemData.modLastReqTime = currentTime
                                _G.AutoPick_Count = _G.AutoPick_Count + 1
                                _G.LastPickupTime = currentTime
                                WriteLog("[AutoLoot] Picked up (Instant)!")
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
                pcall(function()
                    if _G.AutoPick_Enabled and _G.Mod_AllDropItems then
                        local currentTime = Time.time or os.time()
                        for id, dropItemData in pairs(_G.Mod_AllDropItems) do
                            if not _G.Mod_IgnoredDropItems[id] then
                                local itemConfig = nil
                                if _G.ItemData and _G.ItemData.ItemMgr and dropItemData.item then
                                    itemConfig = _G.ItemData.ItemMgr.GetItemConfig(dropItemData.item.itemId)
                                end
                                
                                local eType = itemConfig and itemConfig.type or dropItemData.type
                                local isRune = (eType == 19 or eType == 28)
                                local isBone = (eType == 24 or eType == 26)
                                local isNormal = (not isRune and not isBone)
                                if isNormal and not _G.AutoPick_FilterNormal then isNormal = false end
                                
                                local shouldPick = false
                                if isRune and _G.AutoPick_FilterRune then shouldPick = true end
                                if isBone and _G.AutoPick_FilterBone then shouldPick = true end
                                if isNormal then shouldPick = true end
                                
                                if shouldPick then
                                    -- Add a 0.5s cooldown per item so we don't spam the server
                                    if not dropItemData.modLastReqTime or (currentTime - dropItemData.modLastReqTime > 0.5) then
                                        if _G.AutoPick_Count < _G.AutoPick_Limit then
                                            _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                                            dropItemData.modLastReqTime = currentTime
                                            _G.AutoPick_Count = _G.AutoPick_Count + 1
                                            _G.LastPickupTime = currentTime
                                            
                                            local limitTxtGo = GameObject.Find("LimitValText")
                                            if limitTxtGo then
                                                local lTxt = limitTxtGo:GetComponent(typeof(Text))
                                                if lTxt then
                                                    lTxt.text = string.format("<color=#00FF00>%d</color> / %d", _G.AutoPick_Count, _G.AutoPick_Limit)
                                                end
                                            end
                                        end
                                    end
                                else
                                    _G.Mod_IgnoredDropItems[id] = true
                                end
                            end
                        end
                    end
                end)
            end)
        end

        if _G.ConditionalMgr then
            local original_CanAutoPickUpDropItem = _G.ConditionalMgr.CanAutoPickUpDropItem
            _G.ConditionalMgr.CanAutoPickUpDropItem = function(self, itemInfo)
                if _G.AutoPick_Enabled and not _G.AutoPick_FilterNormal then
                    local itemConfig = nil
                    if _G.ItemData and _G.ItemData.ItemMgr and itemInfo.itemId then
                        itemConfig = _G.ItemData.ItemMgr.GetItemConfig(itemInfo.itemId)
                    end
                    local eType = itemConfig and itemConfig.type or itemInfo.type
                    local isRune = (eType == 19 or eType == 28)
                    local isBone = (eType == 24 or eType == 26)
                    if not isRune and not isBone then
                        return false
                    end
                end
                return original_CanAutoPickUpDropItem(self, itemInfo)
            end

            local original_CanPickUpDropItem = _G.ConditionalMgr.CanPickUpDropItem
            _G.ConditionalMgr.CanPickUpDropItem = function(self, itemInfo)
                if _G.AutoPick_Enabled and not _G.AutoPick_FilterNormal then
                    local itemConfig = nil
                    if _G.ItemData and _G.ItemData.ItemMgr and itemInfo.itemId then
                        itemConfig = _G.ItemData.ItemMgr.GetItemConfig(itemInfo.itemId)
                    end
                    local eType = itemConfig and itemConfig.type or itemInfo.type
                    local isRune = (eType == 19 or eType == 28)
                    local isBone = (eType == 24 or eType == 26)
                    if not isRune and not isBone then
                        return false
                    end
                end
                return original_CanPickUpDropItem(self, itemInfo)
            end
        end

        WriteLog("Khởi tạo Mod Menu HOÀN TẤT!")
    end)

    if not status then
        WriteLog("LỖI TẠO UI: " .. tostring(err))
    end
end

local status, err = pcall(function()
    if _G.UIManager and not _G.MyModHooked then
        _G.MyModHooked = true
        WriteLog("Hooked UIManager trực tiếp!")
        
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
            
            if name == "Main_MainMenuUI" then
                
                if not _G.MyModCreated then
                    _G.MyModCreated = true
                    WriteLog("Đã vào Main_MainMenuUI, tiến hành tạo UI Mod!")
                    CreateModUI()
                end
            end
            
            return ret
        end
    else
        WriteLog("LỖI: UIManager chưa được tải!")
    end
end)
if not status then
    WriteLog("LỖI HOOK UIManager: " .. tostring(err))
end

return true

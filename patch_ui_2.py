import re

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'r', encoding='utf-8') as f:
    content = f.read()

start_marker = '        local mapsConfig = {'
end_marker = '        -- Thêm UI Auto Refresh'

start_idx = content.find(start_marker)
end_idx = content.find(end_marker)

if start_idx == -1 or end_idx == -1:
    print("Could not find markers")
    exit(1)

new_block = """        local mapsConfig = {
            {
                mapId = 101093,
                title = "Hoang Dã C4 (VĐ Mục Nát)",
                bosses = {
                    { id = 10179307, name = "Kỵ Sĩ Đ.Ngục", col = 1, transferId = 400213, total = 2, posX = 154, posY = 113 },
                    { id = 10179308, name = "Phẫn Nộ", col = 2, transferId = 400219, posX = 85, posY = 78 },
                    { id = 10179309, name = "Cuồng Bạo", col = 3, transferId = 400225, posX = 97, posY = 133 },
                }
            },
            {
                mapId = 105204,
                title = "Huyễn Thuật Bí Cảnh 4",
                bosses = {
                    { id = 10520401, name = "Khổng Lồ", col = 1, transferId = 105204101 },
                    { id = 10520402, name = "Phẫn Nộ KL", col = 2, transferId = 105204102 },
                }
            },
            {
                mapId = 106402,
                title = "Vùng Thí Luyện 2",
                bosses = {
                    { id = 10640201, name = "Cây Totem", col = 1, transferId = 10640201 },
                    { id = 10640202, name = "Ngang Ngược", col = 2, transferId = 10640202 },
                    { id = 10640203, name = "Tà Ác KL", col = 3, transferId = 10640203 },
                }
            }
        }

        local mapBosses = {}
        local titleUIPool = {}
        local rowUIPool = {}
        local btnUIPool = {}
        
        local function GetTitleLabel(index, posY)
            if not titleUIPool[index] then
                local titleGo = GameObject("MapTitle_" .. index)
                titleGo.transform:SetParent(panelGo.transform, false)
                local rt = titleGo:AddComponent(typeof(RectTransform))
                rt.anchorMin = Vector2(0.5, 1)
                rt.anchorMax = Vector2(0.5, 1)
                rt.pivot = Vector2(0.5, 1)
                rt.sizeDelta = Vector2(780, 30)
                local txt = titleGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color(1, 0.8, 0, 1)
                txt.fontSize = 19
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end
                titleUIPool[index] = { go = titleGo, txt = txt, rt = rt }
            end
            titleUIPool[index].rt.anchoredPosition = Vector2(0, posY)
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
                rt.sizeDelta = Vector2(100, 30)
                local txt = rowGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.color = Color.white
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleRight
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

                for _, mapCfg in ipairs(mapsConfig) do
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
                                local startX = 10 + (c - 1) * 260
                                local yPos = currentPosY - (r - 1) * 35
                                
                                local rowItem = GetRowLabel(rowIdx, startX, yPos)
                                rowItem.go:SetActive(true)
                                rowItem.txt.text = cfg.name .. ":"
                                
                                local uiBtn = GetLineButton(btnIdx, startX + 110, yPos, 150)
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
                                
                                uiBtn.txt.text = prefix .. statusStr
                                
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
                                        isExpanded = false
                                        panelGo:SetActive(false)
                                    elseif _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                        _G.SceneController.OnReqTransferTransmitMap(nil, { mapId = cfg.transferId, line = validLineNum, changeLine = true })
                                        isExpanded = false
                                        panelGo:SetActive(false)
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
                
                local requiredHeight = math.abs(currentPosY) + 20
                if requiredHeight < 500 then requiredHeight = 500 end
                panelRt.sizeDelta = Vector2(800, requiredHeight)
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
            local original_MonsterMapDataInit = _G.SceneData.MonsterMapDataInit
            _G.SceneData.MonsterMapDataInit = function(data)
                if original_MonsterMapDataInit then original_MonsterMapDataInit(data) end
                ParseBossData()
                _G.FOVEnforceCountdown = 5
            end
            
            if _G.Timer and _G.Timer.StartLoop then
                _G.Timer.StartLoop(1, -1, function()
                    if _G.FOVEnforceCountdown and _G.FOVEnforceCountdown > 0 then
                        pcall(function()
                            if _G.SavedFOV then
                                local cam = CS.UnityEngine.Camera.main
                                if cam and math.abs(cam.fieldOfView - _G.SavedFOV) > 1 then
                                    cam.fieldOfView = _G.SavedFOV
                                    UpdateFOVLabel()
                                end
                            end
                        end)
                        _G.FOVEnforceCountdown = _G.FOVEnforceCountdown - 1
                    end

                    if isExpanded then
                        UpdateBossWatchUIText()
                        
                        if _G.IsAutoRefresh then
                            local currentSec = _G.Time.GetServerSecondTime()
                            if currentSec - _G.LastRefreshSec >= _G.AutoRefreshInterval then
                                _G.LastRefreshSec = currentSec
                                if _G.NetManager and _G.MapMessage then
                                    _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
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
                    end
                end
            end)
        end
        btnComp.onClick:AddListener(_G.ModCallbacks.OnToggleMenu)

"""

new_content = content[:start_idx] + new_block + content[end_idx:]

with open(r'd:\MUVH\android\mu-decompiled\final\modified_lua\EmmyluaDebug.lua', 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Patched successfully!")

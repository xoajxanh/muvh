---@diagnostic disable: undefined-global
---@diagnostic disable: lowercase-global
---@diagnostic disable: duplicate-set-field
-- EmmyluaDebug.lua
-- Bắt buộc phải có để Main.lua gọi không bị lỗi
EmmyluaDebug = {}
function EmmyluaDebug.InitEmmyluaDebug(obj)
    _G.Mod_IsAdmin = true

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

-- WriteLog("--- BẮT ĐẦU KHỞI TẠO HOOK MOD MENU ---")

local function CreateModUI()
    local status, err = pcall(function()
        if _G.Mod_AutoPK_Enabled == nil then
            _G.Mod_AutoPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoPK_Enabled", 0) == 1
        end
        if _G.Mod_AutoApproachTowerBoss == nil then
            _G.Mod_AutoApproachTowerBoss = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoApproachTowerBoss", 0) == 1
        end
        if _G.Mod_InfiniteInstance == nil then
            _G.Mod_InfiniteInstance = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_InfiniteInstance", 0) == 1
        end
        if _G.Mod_AutoUseAngel == nil then
            _G.Mod_AutoUseAngel = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoUseAngel", 0) ==
                1
        end
        if _G.Mod_AutoGuildPK_Enabled == nil then
            _G.Mod_AutoGuildPK_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoGuildPK_Enabled", 0) == 1
        end
        if _G.Mod_AutoPick_KTD == nil then
            _G.Mod_AutoPick_KTD = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPick_KTD", 0) ==
                1
        end
        if _G.Mod_AutoRevive_KTD == nil then
            _G.Mod_AutoRevive_KTD = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoRevive_KTD", 0) == 1
        end
        if _G.Mod_ShowKundunHP == nil then
            pcall(function() _G.Mod_ShowKundunHP = CS.UnityEngine.PlayerPrefs.GetInt("Mod_ShowKundunHP", 0) == 1 end)
        end
        if _G.Mod_AutoResurrect_Enabled == nil then
            pcall(function()
                _G.Mod_AutoResurrect_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                    "Mod_AutoResurrect_Enabled", 0) == 1
            end)
        end
        if _G.Mod_AutoResurrect_Free_Enabled == nil then
            pcall(function()
                _G.Mod_AutoResurrect_Free_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                    "Mod_AutoResurrect_Free_Enabled", _G.Mod_AutoResurrect_Enabled and 1 or 0) == 1
            end)
        end
        if _G.Mod_AutoResurrect_Here_Enabled == nil then
            pcall(function()
                _G.Mod_AutoResurrect_Here_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                    "Mod_AutoResurrect_Here_Enabled", 0) == 1
            end)
        end
        if _G.Mod_PKScanDelay == nil then
            pcall(function() _G.Mod_PKScanDelay = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_PKScanDelay", 0.8) end)
        end
        if _G.Mod_AutoReturnPos_Enabled == nil then
            pcall(function()
                _G.Mod_AutoReturnPos_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                    "Mod_AutoReturnPos_Enabled", 0) == 1
            end)
        end
        if _G.Mod_AutoReturnPos_Coords == nil then
            pcall(function()
                _G.Mod_AutoReturnPos_Coords = CS.UnityEngine.PlayerPrefs.GetString(
                    "Mod_AutoReturnPos_Coords", "")
            end)
        end
        if _G.Mod_AutoReturnPosDelay == nil then
            pcall(function()
                _G.Mod_AutoReturnPosDelay = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_AutoReturnPosDelay",
                    1.0)
            end)
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

        _G.Mod_SaveAnStats = function()
            if not _G.Mod_AnStats then return end
            local todayStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd")
            CS.UnityEngine.PlayerPrefs.SetString("Mod_AnStatsDate", todayStr)

            local pairsList = {}
            for name, count in pairs(_G.Mod_AnStats) do
                table.insert(pairsList, tostring(name) .. ":" .. tostring(count))
            end
            local dataStr = table.concat(pairsList, ";")
            CS.UnityEngine.PlayerPrefs.SetString("Mod_AnStatsData", dataStr)
            CS.UnityEngine.PlayerPrefs.Save()
        end

        _G.Mod_LoadAnStats = function()
            local todayStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd")
            local savedDate = CS.UnityEngine.PlayerPrefs.GetString("Mod_AnStatsDate", "")

            _G.Mod_AnStats = {}
            _G.Mod_AnStatsDate = todayStr

            if savedDate == todayStr then
                local dataStr = CS.UnityEngine.PlayerPrefs.GetString("Mod_AnStatsData", "")
                if dataStr ~= "" then
                    for p in string.gmatch(dataStr, "([^;]+)") do
                        local kStr, vStr = string.match(p, "([^:]+):(%d+)")
                        if kStr and vStr then
                            _G.Mod_AnStats[kStr] = tonumber(vStr) or 0
                        end
                    end
                end
            end
        end

        if not _G.Mod_AnStats_Loaded then
            _G.Mod_LoadAnStats()
            _G.Mod_AnStats_Loaded = true
        end

        -- COMMERCIAL BRANCH BOSS POSITION HELPERS
        _G.Mod_BossStateMap = _G.Mod_BossStateMap or {}

        if _G.EventManager and _G.Event then
            pcall(function()
                if _G.Event.Map_MonsterAllState then
                    _G.EventManager.AddListener(_G.Event.Map_MonsterAllState, function(_, msg)
                        if msg and msg.list then
                            for _, mon in ipairs(msg.list) do
                                if mon and mon.id then
                                    _G.Mod_BossStateMap[mon.id] = (mon.state == 0 and 1 or 0)
                                end
                            end
                        end
                    end)
                end
                if _G.Event.Map_MonsterStateChange then
                    _G.EventManager.AddListener(_G.Event.Map_MonsterStateChange, function(_, msg)
                        if msg and msg.id then
                            _G.Mod_BossStateMap[msg.id] = (msg.state == 0 and 1 or 0)
                        end
                    end)
                end
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
                        table.insert(positions, { x = px, y = py })
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
                                    local posObj = { x = px, y = py, id = v.id }
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

        _G.Mod_GetAliveHHBossList = function()
            local hhBosses = {}
            pcall(function()
                local mapMgr = _G.gameMgr and _G.gameMgr:GetMapManager()
                local sMonPoint = mapMgr and mapMgr:GetMapServerMonsterPoint()
                if not sMonPoint then return {} end

                local myDefense = 0
                if _G.QuickFind and _G.QuickFind.LuaMainPlayerData and _G.EAttributeType then
                    local playerAttr = _G.QuickFind.LuaMainPlayerData()
                    if playerAttr and playerAttr.TryGetAttrValue then
                        myDefense = playerAttr:TryGetAttrValue(_G.EAttributeType.monsterDamageAbsorptionShow) or 0
                    end
                end

                local list = nil
                if sMonPoint.GetMonsterPointList then
                    list = sMonPoint:GetMonsterPointList()
                end
                if (not list or #list == 0) and _G.ClientTable and _G.ClientTable.cfg_Global_globalManager then
                    local typeList = _G.ClientTable.cfg_Global_globalManager:GetMapShowMonsterTypeList()
                    if sMonPoint.GetMonsterPointListByMonsterTypeList then
                        list = sMonPoint:GetMonsterPointListByMonsterTypeList(typeList)
                    end
                end
                if not list and sMonPoint.m_monsterPointList then
                    list = sMonPoint.m_monsterPointList
                end

                if list then
                    for _, mon in pairs(list) do
                        local isHH = false
                        local hhLevel = 0
                        local hhName = ""
                        if mon.mapBuffConfigList then
                            for _, bCfg in ipairs(mon.mapBuffConfigList) do
                                if bCfg.name and string.find(bCfg.name, "Hồn Thú") then
                                    isHH = true
                                    hhLevel = tonumber(bCfg.id) or 1
                                    hhName = tostring(bCfg.name)
                                    break
                                end
                            end
                        end

                        if isHH then
                            local cfgId = mon.monsterConfigTbl and mon.monsterConfigTbl.id or mon.configId

                            local bossDefend = 0
                            if mon.monsterConfigTbl and mon.monsterConfigTbl.defend then
                                bossDefend = tonumber(mon.monsterConfigTbl.defend) or 0
                            elseif cfgId and _G.ClientTable and _G.ClientTable.cfg_Monster_bossManager then
                                local bTable = _G.ClientTable.cfg_Monster_bossManager:TryGetValue(cfgId, "id")
                                if bTable and bTable.defend then
                                    bossDefend = tonumber(bTable.defend) or 0
                                end
                            end

                            -- Filter out boss if player defense is lower than boss required defense
                            if myDefense <= 0 or myDefense >= bossDefend then
                                local name = mon.showName or (mon.monsterConfigTbl and mon.monsterConfigTbl.name) or
                                    "Unknown"
                                local posX = mon.position and mon.position.x or 0
                                local posY = mon.position and mon.position.y or 0
                                local lid = mon.lid or mon.id

                                local transferId = nil
                                local allMaps = { _G.Mod_MapsConfig_c7, _G.Mod_MapsConfig_c8 }
                                for _, mapsConfig in ipairs(allMaps) do
                                    if mapsConfig then
                                        for _, mapCfg in ipairs(mapsConfig) do
                                            if mapCfg.bosses then
                                                for _, bCfgItem in ipairs(mapCfg.bosses) do
                                                    if bCfgItem.id and (bCfgItem.id == cfgId or tonumber(bCfgItem.id) == tonumber(cfgId)) then
                                                        transferId = bCfgItem.transferId
                                                        break
                                                    end
                                                end
                                            end
                                            if transferId then break end
                                        end
                                    end
                                    if transferId then break end
                                end

                                table.insert(hhBosses, {
                                    name = name,
                                    configId = cfgId,
                                    lid = lid,
                                    x = posX,
                                    y = posY,
                                    hhLevel = hhLevel,
                                    hhName = hhName,
                                    bossDefend = bossDefend,
                                    myDefense = myDefense,
                                    transferId = transferId
                                })
                            end
                        end
                    end
                end
            end)

            table.sort(hhBosses, function(a, b)
                return a.hhLevel > b.hhLevel
            end)

            return hhBosses
        end

        _G.Mod_SendAnStatsTelegram = function()
            pcall(function()
                if _G.Mod_AnStats_Enabled == false then return end

                local botToken = "8585747708:AAF_633qF-8JzWCDUWsNnqPTrvf9DbXEJa0"
                local chatId = "-5126116516"
                local messageId = 1231

                local todayStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd")
                if _G.Mod_AnStatsDate ~= todayStr then
                    _G.Mod_AnStatsDate = todayStr
                    _G.Mod_AnStats = {}
                    if _G.Mod_SaveAnStats then _G.Mod_SaveAnStats() end
                end

                local nowStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd HH:mm:ss")

                local total = 0
                for k, v in pairs(_G.Mod_AnStats or {}) do
                    total = total + v
                end

                local msgLines = {}
                table.insert(msgLines, string.format("\nTHỐNG KÊ MỞ BẢN ĐỒ ẨN: <b>%d</b>", total))

                for playerName, count in pairs(_G.Mod_AnStats or {}) do
                    table.insert(msgLines, string.format("%s: %d", tostring(playerName), count))
                end

                table.insert(msgLines, string.format("\n<i>Cập nhật lúc: %s</i>", nowStr))

                local fullMsg = table.concat(msgLines, "\n")

                local url = string.format(
                    "https://api.telegram.org/bot%s/editMessageText?chat_id=%s&message_id=%s&text=%s&parse_mode=HTML",
                    botToken,
                    chatId,
                    tostring(messageId),
                    CS.UnityEngine.WWW.EscapeURL(fullMsg)
                )

                CS.UnityEngine.WWW(url)

                -- if _G.WriteLog then
                --     _G.WriteLog("[Telegram AnStats]: " .. fullMsg)
                -- end
            end)
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
        rt.anchoredPosition = Vector2(20, 280)
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
        panelRt.anchoredPosition = Vector2(90, 50)
        panelRt.sizeDelta = Vector2(720, 580)

        local panelImg = panelGo:AddComponent(typeof(Image))
        panelImg.color = Color(0, 0, 0, 0.8)
        panelGo:SetActive(false)


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
                    { id = 999105207, name = "THOÁT PB", col = 3, isExitBtn = true },
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
                mapId = 106706,
                title = "Luyện Ngục C7",
                bosses = {
                    { id = 10670601, name = "Ma Đạo Phủ", col = 1, transferId = 106706101 },
                    { id = 10670602, name = "Ngang Ngược", col = 2, transferId = 106706102 },
                    { id = 10670603, name = "Tà Ác", col = 3, transferId = 106706103 },
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
                    { id = 999105208, name = "[ THOÁT PB ]", col = 3, isExitBtn = true },
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
                mapId = 106707,
                title = "Luyện Ngục C8",
                bosses = {
                    { id = 10670701, name = "Quỷ Biển", col = 1, transferId = 106707101 },
                    { id = 10670702, name = "Ngang Ngược", col = 2, transferId = 106707102 },
                    { id = 10670703, name = "Tà Ác", col = 3, transferId = 106707103 },
                }
            },
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
                txt.text =
                "--------------------------------------------------------------------------------------------------------------------------"
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
                btnUIPool[btnIndex] = { go = btnGo, txt = txt, btn = btn, rt = rt, img = img }
                table.insert(_G.CoBanUIList, btnGo)
            end
            btnUIPool[btnIndex].rt.anchoredPosition = Vector2(posX, posY)
            btnUIPool[btnIndex].rt.sizeDelta = Vector2(width, 30)
            btnUIPool[btnIndex].img.color = CS.UnityEngine.Color(1, 1, 1, 0)
            btnUIPool[btnIndex].txt.alignment = TextAnchor.MiddleLeft
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
                tabBtnC7.txt.text = "<color=" ..
                    (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                tabBtnC7.btn.onClick:RemoveAllListeners()
                tabBtnC7.btn.onClick:AddListener(function()
                    _G.ModBossTab = "C7"
                    UpdateBossWatchUIText()
                end)
                btnIdx = btnIdx + 1

                local tabBtnC8 = GetLineButton(btnIdx, 150, currentPosY, 100)
                tabBtnC8.go:SetActive(_G.ModMainTab == "CO_BAN")
                tabBtnC8.txt.text = "<color=" ..
                    (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"
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
                                                    local countStr = "<color=#FFFFFF>" ..
                                                        totalAlive .. "/" .. expectedTotal .. "</color>"
                                                    local tStr = ""
                                                    if #timeStrs > 0 then
                                                        tStr = " <color=#AAAAAA>(" ..
                                                            table.concat(timeStrs, ", ") .. ")</color>"
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
                                                        statusStr = "<color=#AAAAAA>(" ..
                                                            string.format("%02d:%02d", m, s) .. ")</color>"
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

                                if cfg.isExitBtn then
                                    uiBtn.img.color = CS.UnityEngine.Color(0.8, 0.15, 0.15, 0.95)
                                    uiBtn.txt.text = "<color=#FFFFFF><b>THOÁT PB</b></color>"
                                    uiBtn.txt.alignment = TextAnchor.MiddleCenter
                                    uiBtn.txt.fontSize = 15
                                    uiBtn.btn.onClick:RemoveAllListeners()
                                    uiBtn.btn.onClick:AddListener(function()
                                        pcall(function()
                                            if _G.TranScriptController then
                                                if _G.TranScriptController.ReqExitInstance then
                                                    _G.TranScriptController
                                                        .ReqExitInstance()
                                                end
                                                if _G.TranScriptController.ReqExitAllGods then
                                                    _G.TranScriptController
                                                        .ReqExitAllGods()
                                                end
                                                if _G.TranScriptController.ReqExitUnionMap then
                                                    _G.TranScriptController
                                                        .ReqExitUnionMap()
                                                end
                                            end
                                            if _G.NetManager and _G.TranScriptMessage and _G.TranScriptMessage.ReqQuitTranScript then
                                                _G.NetManager.Send(_G.TranScriptMessage.ReqQuitTranScript)
                                            end
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg(
                                                    "Đã gửi lệnh thoát phó bản!")
                                            end
                                        end)
                                    end)
                                else
                                    uiBtn.txt.text = cfg.name .. ": " .. prefix .. statusStr
                                    uiBtn.txt.fontSize = 16

                                    uiBtn.btn.onClick:RemoveAllListeners()
                                    uiBtn.btn.onClick:AddListener(function()
                                        if not _G.SceneController.TransferStateJudge() then
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg(
                                                    "HP không đủ để dịch chuyển")
                                            end
                                            return
                                        end
                                        if _G.TranScriptData and _G.TranScriptData.InTranscript then
                                            if _G.FloatingWordUtility then
                                                _G.FloatingWordUtility.QuickMsg(
                                                    "Vui lòng thoát phó bản trước!")
                                            end
                                            return
                                        end
                                        if cfg.posX and cfg.posY and _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                                            _G.PathFinderManager.MoveToLinePos(mapCfg.mapId, {
                                                x = cfg.posX,
                                                y = cfg
                                                    .posY
                                            }, cfg.transferId, validLineNum, nil, nil, nil, nil, true)
                                        elseif _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                            _G.SceneController.OnReqTransferTransmitMap(nil,
                                                { mapId = cfg.transferId, line = validLineNum, changeLine = true })
                                        end
                                    end)
                                end

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

                    local myX = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.x or 0
                    local myY = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.y or 0

                    if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
                    if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("None") end

                    _G.Mod_DebugMsg("Đã quét thấy Boss! Reset vị trí và Auto đập!")

                    _G.RoleManager.me:MoveTo({ x = myX, y = myY }, 0, function()
                        if _G.RoleManager and _G.RoleManager.me then
                            if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
                            if _G.RoleManager.me.SetAutoFight then _G.RoleManager.me:SetAutoFight("AutoFight") end
                        end
                    end)
                    return true
                end)
                if success then return result else return false end
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
            _G.Mod_IsGoodItem = function(item, subType, tier, excDesList)
                if not excDesList or #excDesList == 0 then
                    return false
                end

                -- Nhóm 1: Trang phục (Mũ 113, Áo 114, Quần 115, Găng 116, Giày 117)
                if subType == 113 or subType == 114 or subType == 115 or subType == 116 or subType == 117 then
                    for _, des in ipairs(excDesList) do
                        local isMp = string.find(des, "MP tối đa")
                        local isGold = string.find(des, "Vàng") or string.find(des, "vàng")
                        if isMp or isGold then
                            return false -- Dính 1 dòng rác MP/Vàng -> Không phải dòng ngon
                        end
                    end
                    return true -- Không dính bất kỳ dòng MP/Vàng nào -> Dòng ngon!
                end

                -- Nhóm 2: Vũ khí & Khiên Hồng Trang (101, 106, 108, 109, 124, 181)
                if subType == 101 or subType == 106 or subType == 108 or subType == 109 or subType == 124 or subType == 181 then
                    for _, des in ipairs(excDesList) do
                        local isKill = string.find(des, "diệt quái") or string.find(des, "HP tăng") or
                            string.find(des, "MP tăng")
                        if isKill then
                            return false -- Dính 1 dòng rác diệt quái -> Không phải dòng ngon
                        end
                    end
                    return true -- Không dính dòng rác diệt quái -> Dòng ngon!
                end

                -- Nhóm 3: Dây chuyền (36), Nhẫn trái (35), Nhẫn phải (38)
                if subType == 36 or subType == 35 or subType == 38 then
                    local hasGood = false
                    for _, des in ipairs(excDesList) do
                        local isCap = string.find(des, "cấp/20") or string.find(des, "cấp")
                        local isGoodLine = (string.find(des, "Công Tốc") or string.find(des, "Tấn công")) and not isCap
                        if isGoodLine then
                            hasGood = true
                        else
                            return false -- Dính dòng +cấp/20 hoặc dòng rác khác -> Không đạt (Đem đi tách)
                        end
                    end
                    return hasGood
                end

                -- Nhóm 4: Khuyên trái (34), Khuyên phải (37)
                if subType == 34 or subType == 37 then
                    local hasGood = false
                    for _, des in ipairs(excDesList) do
                        if string.find(des, "Phòng Ngự") or string.find(des, "Phản DMG") or string.find(des, "Phản") then
                            hasGood = true
                        else
                            return false -- Dính dòng khác -> Không đạt
                        end
                    end
                    return hasGood
                end

                return false
            end

            _G.Mod_ExecuteAutoSmelt = function()
                local items = _G.BagInfoData and _G.BagInfoData.TotalItems
                if not items then return end

                local recycleItems = {}
                for k, item in pairs(items) do
                    if item then
                        local tblItem = item.tblItem or (item.data and item.data.tblItem) or {}
                        local tblEquip = item.tblEquip or (item.data and item.data.tblEquip) or {}
                        local itemType = tblItem.type or 0
                        local itemId = tblItem.id or item.itemId or (item.data and item.data.itemId) or 0
                        local subType = tblItem.subType or 0
                        local quality = tblItem.quality or 0
                        local needLevel = tblItem.needLevel or 0
                        local tier = math.floor(needLevel / 400)

                        -- CHỈ XỬ LÝ KHI LÀ TRANG BỊ (itemType == 2) HOẶC CÓ CẤU HÌNH EQUIP
                        if itemType == 2 or (tblEquip and tblEquip.id) then
                            if (not tblEquip or not tblEquip.suitId) and itemId > 0 and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
                                pcall(function()
                                    local eq = _G.ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
                                    if eq then tblEquip = eq end
                                end)
                            end
                            tblEquip = tblEquip or {}

                            local prefix = nil
                            if subType == 35 then
                                prefix = "RingL"
                            elseif subType == 38 then
                                prefix = "RingR"
                            elseif subType == 36 then
                                prefix = "Necklace2"
                            elseif subType == 34 then
                                prefix = "EarringL"
                            elseif subType == 37 then
                                prefix = "EarringR"
                            elseif subType == 113 then
                                prefix = "Hat"
                            elseif subType == 114 then
                                prefix = "Armor"
                            elseif subType == 115 then
                                prefix = "Pants"
                            elseif subType == 116 then
                                prefix = "Gloves"
                            elseif subType == 117 then
                                prefix = "Boots"
                            elseif subType == 101 or subType == 106 or subType == 108 or subType == 109 or subType == 124 or subType == 181 then
                                prefix = "Weapon"
                            end

                            local shouldSmelt = false

                            -- 1. Cấu hình Tách Đồ Trác Việt (Ring_C6..C8, Necklace_C6..C8, Earring_C6..C8)
                            -- quality chính là Chuyển (6, 7, 8)
                            if subType == 18 then
                                if quality == 6 and _G.Mod_SmeltConfig.Ring_C6 then
                                    shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Ring_C7 then
                                    shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Ring_C8 then
                                    shouldSmelt = true
                                end
                            elseif subType == 19 then
                                if quality == 6 and _G.Mod_SmeltConfig.Necklace_C6 then
                                    shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Necklace_C7 then
                                    shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Necklace_C8 then
                                    shouldSmelt = true
                                end
                            elseif subType == 26 then
                                if quality == 6 and _G.Mod_SmeltConfig.Earring_C6 then
                                    shouldSmelt = true
                                elseif quality == 7 and _G.Mod_SmeltConfig.Earring_C7 then
                                    shouldSmelt = true
                                elseif quality == 8 and _G.Mod_SmeltConfig.Earring_C8 then
                                    shouldSmelt = true
                                end
                            end

                            -- 2. Cấu hình Tách Đồ Bộ theo SubType & Tier (C6..C9) (Không áp dụng cho Trang Sức Trác Việt 18, 19, 26)
                            if prefix and tier >= 6 and tier <= 9 then
                                local varName = prefix .. "_C" .. tostring(tier)
                                if _G.Mod_SmeltConfig[varName] then
                                    shouldSmelt = true
                                end
                            end

                            -- 3. Bộ lọc [Giữ dòng Ngon] (Chỉ áp dụng cho Đồ Bộ, KHÔNG áp dụng cho Trang Sức Trác Việt 18, 19, 26)
                            local isJewelryTracViet = (subType == 18 or subType == 19 or subType == 26)
                            if shouldSmelt and not isJewelryTracViet and tier >= 6 and tier <= 9 then
                                local keepGoodVar = "KeepGood_C" .. tostring(tier)
                                if _G.Mod_SmeltConfig[keepGoodVar] then
                                    local excDesList = {}
                                    local sInfo = item.serverInfo or item.serverData or {}
                                    local rawExc = item.excellence or sInfo.excellentList or sInfo.excellentInfo or
                                        sInfo.excellentAttrs

                                    if _G.RoleEquipUtility then
                                        if rawExc and _G.RoleEquipUtility.GetEquipExcellence then
                                            pcall(function()
                                                excDesList = _G.RoleEquipUtility.GetEquipExcellence(rawExc,
                                                    tblEquip)
                                            end)
                                        end
                                        if (#excDesList == 0) and _G.RoleEquipUtility.GetEquipExcellenceDesByServerInfo then
                                            pcall(function()
                                                excDesList = _G.RoleEquipUtility
                                                    .GetEquipExcellenceDesByServerInfo(sInfo)
                                            end)
                                        end
                                    end
                                    if (#excDesList == 0) and item.GetEquipExcellenceDesList then
                                        pcall(function() excDesList = item:GetEquipExcellenceDesList() end)
                                    end

                                    local isGood = _G.Mod_IsGoodItem(item, subType, tier, excDesList)
                                    if isGood then
                                        shouldSmelt = false -- GIỮ LẠI TRONG TÚI
                                    end
                                end
                            end

                            if shouldSmelt and item.id then
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
                                LogMsg("Đã gửi yêu cầu tách " .. tostring(batchSize) .. " món trang bị!")
                            end
                            batch = {}
                            batchSize = 0
                        end
                    end
                end
            end

            _G.Mod_AutoFarmBoss_Update = function()
                if not _G.Mod_AutoFarmBoss_Enabled then
                    if _G.Mod_AutoFarmBoss_State ~= 0 then
                        _G.Mod_AutoFarmBoss_State = 0
                        _G.Mod_AutoFarmBoss_Target = nil
                        LogMsg("Đã TẮT Auto Farm.")
                    end
                    if _G.Mod_AutoHH_Enabled then
                        pcall(function()
                            local nowRealtime = CS.UnityEngine.Time.realtimeSinceStartup
                            if nowRealtime < (_G.Mod_AutoHH_NextTickTime or 0) then
                                return
                            end

                            local me = _G.RoleManager and _G.RoleManager.me
                            local meId = me and me.data and me.data.id
                            local currentMapId = _G.SceneData and _G.SceneData.mapId

                            local tab = _G.ModAutoBossConfigTab or "C7"
                            local mapsConfig = (tab == "C8") and _G.Mod_MapsConfig_c8 or _G.Mod_MapsConfig_c7
                            local targetMapId = (mapsConfig and mapsConfig[1] and mapsConfig[1].mapId) or
                                ((tab == "C8") and 1074 or 101096)

                            -- 1. Scan for ALIVE HH Bosses on current map using Mod_GetAliveHHBossList()
                            local aliveHHBosses = {}
                            if _G.Mod_GetAliveHHBossList then
                                aliveHHBosses = _G.Mod_GetAliveHHBossList()
                            end

                            local targetBoss = (#aliveHHBosses > 0) and aliveHHBosses[1] or nil

                            if targetBoss then
                                _G.Mod_AutoHH_NextTickTime = nowRealtime + 2.0
                                local tId = targetBoss.transferId or targetMapId

                                local pX = me and
                                    (me.serverCoord and me.serverCoord.x or (me.cellPos and me.cellPos.x) or (me.data and me.data.x)) or
                                    0
                                local pY = me and
                                    (me.serverCoord and me.serverCoord.y or (me.cellPos and me.cellPos.y) or (me.data and me.data.y)) or
                                    0
                                local distToTargetBoss = math.sqrt((pX - targetBoss.x) * (pX - targetBoss.x) +
                                    (pY - targetBoss.y) * (pY - targetBoss.y))

                                local nearTarget = false
                                if distToTargetBoss <= 12 then
                                    if me and _G.RoleManager.GetRolesByType then
                                        local monsterRoles = _G.RoleManager.GetRolesByType(2) or {}
                                        for _, role in pairs(monsterRoles) do
                                            if role and role.hp and role.hp > 0 and role.maxHp and role.maxHp > 0 then
                                                local hpRatio = role.hp / role.maxHp
                                                local ownerId = role.ownerId or (role.data and role.data.ownerId) or 0
                                                local isUnclaimed = (ownerId == 0 or tostring(ownerId) == tostring(meId))
                                                local rCfg = role.data and (role.data.configId or role.data.monsterId)

                                                if (not rCfg or tostring(rCfg) == tostring(targetBoss.configId)) and hpRatio >= 0.9 and isUnclaimed then
                                                    nearTarget = true
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end

                                if nearTarget then
                                    if me.SetAutoFight then me:SetAutoFight("ReleaseSkill") end
                                    if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                                        _G.QiJiHelperData
                                            .SetAutoFightData(true)
                                    end
                                else
                                    LogMsg("Phát hiện Boss Thánh Hoàn " ..
                                        tostring(targetBoss.name) .. "! Dịch chuyển qua transferId: " .. tostring(tId))
                                    if me and me.SetAutoFight then me:SetAutoFight("None") end
                                    if _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                        _G.SceneController.OnReqTransferTransmitMap(nil,
                                            { mapId = tId, line = 1, changeLine = true })
                                    end

                                    if me and me.MoveTo then
                                        local meX = me.serverCoord and me.serverCoord.x or (me.data and me.data.x) or 0
                                        local meY = me.serverCoord and me.serverCoord.y or (me.data and me.data.y) or 0
                                        if meX > 0 and meY > 0 then
                                            local dx = math.random(-2, 2)
                                            local dy = math.random(-2, 2)
                                            if dx == 0 and dy == 0 then
                                                dx = 1; dy = 1
                                            end
                                            me:MoveTo({ x = meX + dx, y = meY + dy })
                                        end
                                    end
                                end
                            else
                                -- Không có Boss HH -> Dùng quy trình quay về bãi train chuẩn tích hợp (Đá nhảy 0.4s, bay đúng transferId, cự ly <= 1.5m)
                                if _G.Mod_PerformAutoTrainAndSmelt then
                                    local isStillReturning, isChangingMap = _G.Mod_PerformAutoTrainAndSmelt()
                                    if isChangingMap then
                                        _G.Mod_AutoHH_NextTickTime = nowRealtime + 3.0
                                    elseif isStillReturning then
                                        _G.Mod_AutoHH_NextTickTime = nowRealtime + 0.4
                                    else
                                        _G.Mod_AutoHH_NextTickTime = nowRealtime + 2.0
                                    end
                                end
                            end
                        end)
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
                                    LogMsg("[BOSS ẨN] Phát hiện Cổng Map Ẩn! Triệu hồi Kim Cương...")
                                    if _G.networkRequest and _G.networkRequest.ReqCallBoss then
                                        _G.networkRequest.ReqCallBoss(tipUi.DimensionalCracksData.id,
                                            tipUi.DimensionalCracksData.mid, 2)
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

                        if _G.RoleManager and _G.RoleManager.GetRolesByType then
                            local monsters = _G.RoleManager.GetRolesByType(2) or {}
                            local me = _G.RoleManager.me
                            local meId = me and me.data and me.data.id or 0
                            for _, role in pairs(monsters) do
                                if role and role.hp and role.hp > 0 then
                                    local isSummon = role.isSummon or (role.data and role.data.isSummon) or false
                                    local ownerId = role.ownerId or (role.data and role.data.ownerId) or role.masterId or
                                        0
                                    local isMySummon = (isSummon == true) or
                                        (ownerId ~= 0 and tostring(ownerId) == tostring(meId))

                                    local canAttack = true
                                    if _G.RoleTargetManager and _G.RoleTargetManager.GetCanAttackRole then
                                        canAttack = _G.RoleTargetManager.GetCanAttackRole(role)
                                    elseif isMySummon then
                                        canAttack = false
                                    end

                                    if canAttack and not isMySummon then
                                        quaiBoss = quaiBoss + 1
                                        hpBoss = role.hp
                                    end
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

                -- LIÊN TỤC CHẶN NATIVE AUTO-PATHING Ở CÁC STATE KHÔNG PHẢI COMBAT (Tránh bị game tự lôi về map cũ)
                -- if _G.RoleManager.me then
                --     if _G.Mod_AutoFarmBoss_State ~= 0 and _G.Mod_AutoFarmBoss_State ~= 5 then
                --         if _G.RoleManager.me.isAutoTaskFight and _G.RoleManager.me.isAutoTaskFight ~= "None" then
                --             if _G.RoleManager.me.SetAutoTaskFight then _G.RoleManager.me:SetAutoTaskFight("None") end
                --         end
                --         if _G.RoleManager.me.isAutoFight and _G.RoleManager.me.isAutoFight ~= "None" then
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
                                                            return {
                                                                cfg = cfg,
                                                                mapCfg = mCfg,
                                                                line = _G.SceneData and
                                                                    _G.SceneData.lineIndex or 1
                                                            }
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                        foundCombatBoss = CheckList(_G.Mod_MapsConfig_c7) or
                                            CheckList(_G.Mod_MapsConfig_c8)
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
                                _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 16 })
                                _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 17 })
                                _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 1 })
                                _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 2 })
                                _G.NetManager.Send(_G.MapMessage.ReqBossStateByType, { type = 3 })
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
                                                local bossData = mapBosses[mapCfg.mapId] and
                                                    mapBosses[mapCfg.mapId][cfg.id]
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
                                                            if rt <= currentSec + 30 then
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
                                                            name = cfg.name,
                                                            id = cfg.id,
                                                            score = finalScore,
                                                            isAlive = isAlive,
                                                            wait = respawnWait,
                                                            mapName = GetMapName(mapCfg.mapId),
                                                            mapId = mapCfg.mapId,
                                                            obj = { cfg = cfg, mapCfg = mapCfg, line = bestLine, isAlive = isAlive, wait = respawnWait }
                                                        })

                                                        if finalScore > bestScore then
                                                            bestScore = finalScore
                                                            bestBoss = {
                                                                cfg = cfg,
                                                                mapCfg = mapCfg,
                                                                line = bestLine,
                                                                isAlive =
                                                                    isAlive,
                                                                wait = respawnWait
                                                            }
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        CheckConfig(_G.Mod_MapsConfig_c7, 1000)
                        CheckConfig(_G.Mod_MapsConfig_c8, 2000)

                        if #candidates > 0 then
                            table.sort(candidates, function(a, b) return a.score > b.score end)
                            LogMsg("--- TOP 3 BOSSES SCORE ---")
                            for i = 1, math.min(3, #candidates) do
                                local c = candidates[i]
                                local st = c.isAlive and "SỐNG" or ("Chết (Còn " .. c.wait .. "s)")
                                LogMsg(string.format("%d. %s (ID:%s, Map:%s) | Điểm: %d | %s", i, c.name, c.id, c
                                    .mapName, c.score, st))
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
                                                    LogMsg(string.format("- Bỏ qua: %s (Map %s) đang bị Block %ds",
                                                        cfg.name, GetMapName(mapCfg.mapId), ignoreUntil - currentSec))
                                                else
                                                    local bossData = mapBosses[mapCfg.mapId] and
                                                        mapBosses[mapCfg.mapId][cfg.id]
                                                    if not bossData then
                                                        countNoData = countNoData + 1
                                                    else
                                                        for _, lineNum in ipairs(bossData.lineNums) do
                                                            local totalAlive = bossData.aliveCount[lineNum] or 0
                                                            local deadList = bossData.deadTimes[lineNum] or {}
                                                            if totalAlive == 0 and #deadList > 0 then
                                                                local rt = deadList[1]
                                                                LogMsg(string.format(
                                                                    "- Từ chối: %s (Còn %ds nữa mới hồi sinh)", cfg.name,
                                                                    rt - currentSec))
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            DebugConfig(_G.Mod_MapsConfig_c7)
                            DebugConfig(_G.Mod_MapsConfig_c8)
                        end

                        local function Mod_PerformSmeltItems()
                            pcall(function()
                                if _G.Mod_ExecuteAutoSmelt then
                                    _G.Mod_ExecuteAutoSmelt()
                                end
                            end)
                        end
                        _G.Mod_PerformSmeltItems = Mod_PerformSmeltItems

                        local function Mod_PerformAutoTrainAndSmelt()
                            local isStillReturning, isChangingMap = false, false
                            pcall(function()
                                Mod_PerformSmeltItems()

                                local coordStr = _G.Mod_TrainCoord or ""

                                if coordStr and string.find(coordStr, "#") then
                                    local parts = {}
                                    for p in string.gmatch(coordStr, "[^#]+") do table.insert(parts, p) end
                                    local tx, ty = tonumber(parts[1]), tonumber(parts[2])

                                    if tx and ty then
                                        local tab = _G.ModAutoBossConfigTab or "C7"
                                        local mapsConfig = (tab == "C8") and _G.Mod_MapsConfig_c8 or _G
                                            .Mod_MapsConfig_c7
                                        local wildMapId = (mapsConfig and mapsConfig[1] and mapsConfig[1].mapId) or
                                            ((tab == "C8") and 1074 or 101096)
                                        local wildTransferId = (mapsConfig and mapsConfig[1] and mapsConfig[1].bosses and mapsConfig[1].bosses[1] and mapsConfig[1].bosses[1].transferId) or
                                            ((tab == "C8") and 400229 or 400216)
                                        local curMap = _G.SceneData and _G.SceneData.mapId or 0

                                        if curMap ~= wildMapId then
                                            _G.Mod_IsMovingToTrainPos = false
                                            _G.Mod_TrainArrivedAtPos = false
                                            --LogMsg(string.format("[TRAIN_ACTION] BẮT ĐẦU CHUYỂN MAP: curMap(%d) ~= wildMapId(%d), transferId=%d", curMap, wildMapId, wildTransferId))
                                            if ExitDungeon() then
                                                --LogMsg("[TRAIN_ACTION] -> Gọi ExitDungeon() thành công")
                                            elseif wildTransferId and _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                                                --LogMsg(string.format("[TRAIN_ACTION] -> Gọi OnReqTransferTransmitMap(transferId=%d)", wildTransferId))
                                                _G.SceneController.OnReqTransferTransmitMap(nil,
                                                    { mapId = wildTransferId, line = 1, changeLine = true })
                                            elseif _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                                                --LogMsg(string.format("[TRAIN_ACTION] -> Gọi MoveToLinePos(wildMapId=%d, transferId=%d) để sang map", wildMapId, wildTransferId))
                                                _G.PathFinderManager.MoveToLinePos(wildMapId, { x = tx, y = ty },
                                                    wildTransferId, 1, nil, nil, nil, nil, true)
                                            else
                                                --LogMsg("[TRAIN_ACTION] -> LỖI: Không tìm thấy API chuyển map nào khả dụng!")
                                            end
                                            isStillReturning, isChangingMap = true, true
                                        else
                                            local pMe = _G.RoleManager and _G.RoleManager.me
                                            local meX, meY = 0, 0
                                            if pMe then
                                                if pMe.cellPos then
                                                    meX, meY = pMe.cellPos.x, pMe.cellPos.y
                                                elseif pMe.serverCoord then
                                                    meX, meY = pMe.serverCoord.x, pMe.serverCoord.y
                                                end
                                            end

                                            local dx = meX - tx
                                            local dy = meY - ty
                                            local dist = math.sqrt(dx * dx + dy * dy)

                                            if dist > 70 then
                                                _G.Mod_IsMovingToTrainPos = false
                                                _G.Mod_TrainArrivedAtPos = false
                                                local nowTime = CS.UnityEngine.Time.realtimeSinceStartup
                                                if nowTime - (_G.Mod_LastStoneTime or 0) >= 0.4 then
                                                    _G.Mod_LastStoneTime = nowTime
                                                    local stoneBagId = nil
                                                    if _G.BagInfoData and _G.BagInfoData.TotalItems then
                                                        for _, itemData in pairs(_G.BagInfoData.TotalItems) do
                                                            if itemData then
                                                                local itemId = itemData.itemId or
                                                                    (itemData.data and itemData.data.itemId)
                                                                local instanceId = itemData.id or
                                                                    (itemData.data and itemData.data.id)
                                                                if itemId == 20000022 then
                                                                    stoneBagId = instanceId
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end

                                                    if stoneBagId then
                                                        if _G.networkRequest and _G.networkRequest.ReqUseItem then
                                                            _G.networkRequest.ReqUseItem(1, stoneBagId)
                                                        elseif _G.BagInfoController and _G.BagInfoController.UseItemReq then
                                                            _G.BagInfoController.UseItemReq(1, stoneBagId, nil, 20000022)
                                                        end
                                                    elseif _G.PathFinderManager and _G.PathFinderManager.MoveToLinePos then
                                                        _G.PathFinderManager.MoveToLinePos(wildMapId, { x = tx, y = ty },
                                                            wildTransferId, 1, nil, nil, nil, nil, true)
                                                    end
                                                end
                                                isStillReturning, isChangingMap = true, false
                                            else
                                                local hasArrived = (dist <= 1.5)

                                                if not hasArrived then
                                                    -- if pMe then
                                                    --     if pMe.isAutoTaskFight and pMe.isAutoTaskFight ~= "None" then
                                                    --         if pMe.SetAutoTaskFight then pMe:SetAutoTaskFight("None") end
                                                    --     end
                                                    --     if pMe.isAutoFight and pMe.isAutoFight ~= "None" then
                                                    --         if pMe.SetAutoFight then pMe:SetAutoFight("None") end
                                                    --     end
                                                    -- end
                                                    -- if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                                                    --     _G.QiJiHelperData.SetAutoFightData(false)
                                                    -- end

                                                    local isMoving = pMe and pMe.IsMoving and pMe:IsMoving()
                                                    if not _G.Mod_IsMovingToTrainPos or not isMoving then
                                                        _G.Mod_IsMovingToTrainPos = true

                                                        local moved = false
                                                        if _G.PathFinderManager and _G.PathFinderManager.JumpMapToMoveToPos and _G.SceneData then
                                                            local targetPosData = (_G.PathFinderManager.GetCalcPosData and _G.PathFinderManager.GetCalcPosData(coordStr)) or
                                                                (_G.Vector2 and _G.Vector2(tx, ty)) or { x = tx, y = ty }
                                                            _G.PathFinderManager.JumpMapToMoveToPos(_G.SceneData.groupId,
                                                                targetPosData, nil, nil, nil, Purpose.None or 0, nil, 1,
                                                                true)
                                                            moved = true
                                                        elseif pMe and pMe.MoveTo then
                                                            pMe:MoveTo({ x = tx, y = ty }, 0)
                                                            moved = true
                                                        end

                                                        if not moved then
                                                            _G.Mod_IsMovingToTrainPos = false
                                                        end
                                                    end
                                                    isStillReturning, isChangingMap = true, false
                                                else
                                                    --LogMsg(string.format("[TRAIN_ACTION] -> ĐÃ TỚI CHÍNH XÁC VỊ TRÍ (%d,%d) (cự ly %.1fm)! Bật Auto Fight...", tx, ty, dist))
                                                    local me = _G.RoleManager and _G.RoleManager.me
                                                    if me then
                                                        if me.StopMove then me:StopMove() end
                                                        if me.SetAutoFight then me:SetAutoFight("ReleaseSkill") end
                                                    end
                                                    if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                                                        _G
                                                            .QiJiHelperData.SetAutoFightData(true)
                                                    end
                                                    _G.Mod_IsMovingToTrainPos = false
                                                    _G.Mod_TrainArrivedAtPos = false
                                                    isStillReturning, isChangingMap = false, false
                                                end
                                            end
                                        end
                                    else
                                        LogMsg(string.format(
                                            "[TRAIN_ERROR] Không bóc tách được tx, ty từ Mod_TrainCoord: '%s'",
                                            tostring(coordStr)))
                                    end
                                else
                                    LogMsg(string.format("[TRAIN_ERROR] Mod_TrainCoord không chứa dấu '#': '%s'",
                                        tostring(coordStr)))
                                end
                            end)
                            return isStillReturning, isChangingMap
                        end
                        _G.Mod_PerformAutoTrainAndSmelt = Mod_PerformAutoTrainAndSmelt

                        if bestBoss then
                            _G.Mod_AutoFarmBoss_Target = bestBoss
                            if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end
                            if bestBoss.isAlive or (bestBoss.wait and bestBoss.wait <= 3) then
                                LogMsg(string.format("Bắt đầu săn: %s (Map: %s)", bestBoss.cfg.name,
                                    GetMapName(bestBoss.mapCfg.mapId)))
                                _G.Mod_AutoFarmBoss_Target = bestBoss
                                if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end

                                local currentLine = _G.SceneData and _G.SceneData.lineIndex or 1
                                if currentMapId == bestBoss.mapCfg.mapId and currentLine == bestBoss.line then
                                    _G.Mod_AutoFarmBoss_State = 4
                                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                                else
                                    _G.Mod_AutoFarmBoss_State = 3
                                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                                end
                            else
                                LogMsg(string.format("Chưa có Boss! Gần nhất: %s còn %ds", bestBoss.cfg.name,
                                    bestBoss.wait))
                                _G.Mod_AutoFarmBoss_Target = nil
                                if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end

                                if bestBoss.wait and bestBoss.wait > 5 and _G.Mod_TrainCoord and _G.Mod_TrainCoord ~= "" then
                                    local isStillReturning, isChangingMap = Mod_PerformAutoTrainAndSmelt()
                                    if isChangingMap then
                                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                                    else
                                        _G.Mod_AutoFarmBoss_WaitTime = isStillReturning and currentSec or
                                            (currentSec + 5)
                                    end
                                    return
                                else
                                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                                end
                            end
                        else
                            _G.Mod_AutoFarmBoss_Target = nil
                            if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end

                            if _G.Mod_TrainCoord and _G.Mod_TrainCoord ~= "" then
                                local isStillReturning, isChangingMap = Mod_PerformAutoTrainAndSmelt()
                                if isChangingMap then
                                    _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                                else
                                    _G.Mod_AutoFarmBoss_WaitTime = isStillReturning and currentSec or (currentSec + 5)
                                end
                                return
                            elseif currentMapId == 1001 then
                                LogMsg("Không có Boss! Chờ ở Lorencia...")
                                _G.Mod_AutoFarmBoss_State = 2
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 5
                                Mod_PerformSmeltItems()
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

                        -- STATE 3: TELEPORT
                    elseif _G.Mod_AutoFarmBoss_State == 3 then
                        local target = _G.Mod_AutoFarmBoss_Target
                        if not target then
                            _G.Mod_AutoFarmBoss_State = 1
                            return
                        end

                        if currentMapId ~= target.mapCfg.mapId and ExitDungeon() then
                            LogMsg("Đang thoát phó bản cũ trước khi bay tới Boss mới...")
                            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 3
                            return
                        end

                        LogMsg(string.format("Đang bay tới Map Boss: %s...", GetMapName(target.mapCfg.mapId)))
                        if _G.SceneController and _G.SceneController.OnReqTransferTransmitMap then
                            _G.SceneController.OnReqTransferTransmitMap(nil,
                                { mapId = target.cfg.transferId, line = target.line, changeLine = true })
                        end
                        _G.Mod_AutoFarmBoss_State = 4
                        _G.Mod_AutoFarmBoss_TargetWait = 0
                        _G.Mod_AutoFarmBoss_DidJiggle = false
                        _G.Mod_AutoFarmBoss_WaitTime = currentSec + 2

                        -- STATE 4: WAIT & VALIDATE
                    elseif _G.Mod_AutoFarmBoss_State == 4 then
                        local target = _G.Mod_AutoFarmBoss_Target
                        if not target then
                            _G.Mod_AutoFarmBoss_State = 1
                            return
                        end

                        if currentMapId ~= target.mapCfg.mapId then
                            _G.Mod_AutoFarmBoss_TargetWait = (_G.Mod_AutoFarmBoss_TargetWait or 0) + 1
                            if _G.Mod_AutoFarmBoss_TargetWait > 3 then
                                LogMsg("Lỗi: Không thể bay tới Map Boss. Bỏ qua điểm này 60s")
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

                        if not _G.Mod_AutoFarmBoss_DidJiggle then
                            _G.Mod_AutoFarmBoss_DidJiggle = true
                            if _G.RoleManager.me and _G.RoleManager.me.MoveTo then
                                local meX = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.x or
                                    (_G.RoleManager.me.data and _G.RoleManager.me.data.x) or 0
                                local meY = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.y or
                                    (_G.RoleManager.me.data and _G.RoleManager.me.data.y) or 0
                                if meX > 0 and meY > 0 then
                                    local dx = math.random(-2, 2)
                                    local dy = math.random(-2, 2)
                                    if dx == 0 and dy == 0 then
                                        dx = 1; dy = 1
                                    end
                                    _G.RoleManager.me:MoveTo({ x = meX + dx, y = meY + dy })
                                end
                            end
                            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                            return
                        end

                        if _G.RoleManager.me and _G.RoleManager.me.StopMove then _G.RoleManager.me:StopMove() end
                        if _G.RoleManager.me and _G.RoleManager.me.SetAutoTaskFight then
                            _G.RoleManager.me
                                :SetAutoTaskFight("None")
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
                                            LogMsg(string.format("Tìm thấy Boss %s - HP: %.2f%%",
                                                tostring(target.cfg.name or ""), hpPct))

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
                                if _G.RoleManager.me and _G.RoleManager.me.SetAutoFight then
                                    _G.RoleManager.me
                                        :SetAutoFight("AutoFight")
                                end
                                _G.Mod_AutoFarmBoss_State = 5
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                                LogMsg("Đủ điều kiện, Bật Auto Fight")
                            else
                                LogMsg("Boss bị Ks (HP < 90%). Bỏ qua 6 phút")
                                _G.Mod_AutoFarmBoss_Ignore[target.cfg.id .. "_" .. target.mapCfg.mapId] = currentSec +
                                    360
                                _G.Mod_AutoFarmBoss_Target = nil
                                _G.Mod_AutoFarmBoss_State = 1
                                _G.Mod_AutoFarmBoss_TargetWait = 0
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                            end
                        else
                            _G.Mod_AutoFarmBoss_BossWait = (_G.Mod_AutoFarmBoss_BossWait or 0) + 1
                            if _G.Mod_AutoFarmBoss_BossWait > 2 then
                                LogMsg("Không thấy Boss. Rút về Lorencia...")
                                _G.Mod_AutoFarmBoss_BossWait = 0
                                _G.Mod_AutoFarmBoss_Target = nil
                                _G.Mod_AutoFarmBoss_State = 1
                                _G.Mod_AutoFarmBoss_TargetWait = 0
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                            else
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
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
                        local bossIsDead = false
                        if _G.RoleManager and _G.RoleManager.GetRolesByType then
                            local monsterRoles = _G.RoleManager.GetRolesByType(2)
                            if monsterRoles then
                                for lid, role in pairs(monsterRoles) do
                                    local d = role.data
                                    local mId = d and (d.configId or d.monsterId or d.templateId) or "none"
                                    local nameMatch = (d and d.name and target.cfg.name and string.find(string.lower(d.name), string.lower(target.cfg.name), 1, true))
                                    local isTarget = (_G.RoleManager.me and _G.RoleManager.me.TargetAvatar and _G.RoleManager.me.TargetAvatar == role)
                                    local idMatch = (tonumber(mId) ~= nil and tonumber(target.cfg.id) ~= nil and tonumber(mId) == tonumber(target.cfg.id))

                                    if idMatch or isTarget or nameMatch then
                                        if role.isDead or (role.hp and role.hp <= 0) then
                                            bossIsDead = true
                                        else
                                            foundBoss = true
                                            local maxHp = role.maxHp or role.maxHP or role.hp or 1
                                            local rawPct = (role.hp / maxHp) * 100
                                            local hpPct = math.max(0.01, rawPct)
                                            LogMsg(string.format("Đang đánh %s - HP: %.2f%%", d.name or target.cfg.name,
                                                hpPct))
                                        end
                                        break
                                    end
                                end
                            end
                        end

                        if bossIsDead or not foundBoss then
                            if bossIsDead or (_G.Mod_AutoFarmBoss_TargetWait or 0) >= 1 then
                                LogMsg("Boss đã chết! Tắt AutoFight & Chờ nhặt đồ...")

                                -- Tắt Auto Fight ngay khi Boss chết
                                if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.SetAutoFight then
                                    _G.RoleManager.me:SetAutoFight("None")
                                end
                                if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                                    _G.QiJiHelperData.SetAutoFightData(false)
                                end

                                _G.Mod_FarmStats = _G.Mod_FarmStats or { hidden = 0, bosses = {} }
                                _G.Mod_FarmStats.bosses[target.cfg.id] = (_G.Mod_FarmStats.bosses[target.cfg.id] or 0) +
                                    1
                                if _G.Mod_SaveFarmStats then _G.Mod_SaveFarmStats() end
                                if _G.ModRefreshAutoBossConfigUI then _G.ModRefreshAutoBossConfigUI() end

                                _G.Mod_AutoFarmBoss_TargetWait = 0
                                _G.Mod_AutoFarmBoss_State = 6
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                            else
                                _G.Mod_AutoFarmBoss_TargetWait = (_G.Mod_AutoFarmBoss_TargetWait or 0) + 1
                                _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                            end
                        else
                            _G.Mod_AutoFarmBoss_TargetWait = 0
                            _G.Mod_AutoFarmBoss_WaitTime = currentSec + 1
                        end

                        -- STATE 6: LOOT WAIT
                    elseif _G.Mod_AutoFarmBoss_State == 6 then
                        LogMsg("Boss đã chết: Tắt Đánh, đi nhẹ 2-3 bước & chờ 5s nhặt đồ...")

                        -- Đảm bảo Auto Fight đã tắt hoàn toàn
                        if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.SetAutoFight then
                            _G.RoleManager.me:SetAutoFight("None")
                        end
                        if _G.QiJiHelperData and _G.QiJiHelperData.SetAutoFightData then
                            _G.QiJiHelperData.SetAutoFightData(false)
                        end

                        if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.MoveTo then
                            local meX = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.x or
                                (_G.RoleManager.me.data and _G.RoleManager.me.data.x) or 0
                            local meY = _G.RoleManager.me.serverCoord and _G.RoleManager.me.serverCoord.y or
                                (_G.RoleManager.me.data and _G.RoleManager.me.data.y) or 0
                            if meX > 0 and meY > 0 then
                                local dx = math.random(-2, 2)
                                local dy = math.random(-2, 2)
                                if dx == 0 and dy == 0 then
                                    dx = 1; dy = 1
                                end
                                _G.RoleManager.me:MoveTo({ x = meX + dx, y = meY + dy })
                            end
                        end

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
                    -- TỰ ĐỘNG HỒI SINH (HS FREE & HS KC - 0s Delay + Dập Popup 3s)
                    local me = _G.RoleManager and _G.RoleManager.me
                    if me then
                        if me.isDead or (me.hp and me.hp <= 0) then
                            local nowTime = CS.UnityEngine.Time.realtimeSinceStartup
                            if not _G.Mod_LastResurrectTime or (nowTime - _G.Mod_LastResurrectTime) >= 1.0 then
                                if _G.Mod_AutoResurrect_Here_Enabled then
                                    -- 1. HỒI SINH TẠI CHỖ (30 KC / THẺ)
                                    _G.Mod_LastResurrectTime = nowTime
                                    pcall(function()
                                        local reviveItemId = 17020002
                                        local reviveGoodId = 30104
                                        local bagCount = 0
                                        if _G.BagInfoData and _G.BagInfoData.GetItemTotalCountByItemId then
                                            bagCount = _G.BagInfoData.GetItemTotalCountByItemId(reviveItemId) or 0
                                        end

                                        if bagCount > 0 then
                                            if _G.MeController and _G.RoleReliveType then
                                                _G.MeController.ReqReqRelive(_G.RoleReliveType.Here)
                                            end
                                        else
                                            if _G.NetManager and _G.ItemBuyMessage then
                                                _G.NetManager.Send(_G.ItemBuyMessage.ReqBuy, { goodId = reviveGoodId, buyCount = 1 })
                                            end
                                            if _G.MeController and _G.RoleReliveType then
                                                _G.MeController.ReqReqRelive(_G.RoleReliveType.Here)
                                            end
                                        end

                                        if _G.UIManager and _G.UIManager.Hide and _G.UIID and _G.UIID.Role_ResurgenceUI then
                                            _G.UIManager.Hide(_G.UIID.Role_ResurgenceUI)
                                        end
                                    end)
                                elseif _G.Mod_AutoResurrect_Free_Enabled or _G.Mod_AutoResurrect_Enabled then
                                    -- 2. HỒI SINH MIỄN PHÍ (BORN POINT / KS BATTLE)
                                    _G.Mod_LastResurrectTime = nowTime
                                    pcall(function()
                                        local mapId = 0
                                        if _G.SceneData and _G.SceneData.mapId then
                                            mapId = _G.SceneData.mapId
                                        elseif me.mapId then
                                            mapId = me.mapId
                                        end

                                        local isKS = (mapId == 1077) or
                                            (_G.TranScriptData and _G.TranScriptData.IsInRefineKSBattle and _G.TranScriptData.IsInRefineKSBattle())

                                        if _G.MeController and _G.RoleReliveType then
                                            if isKS then
                                                _G.MeController.ReqReqRelive(_G.RoleReliveType.KSBattle)
                                            else
                                                _G.MeController.ReqReqRelive(_G.RoleReliveType.BornPoint)
                                            end
                                        end

                                        if _G.UIManager and _G.UIManager.Hide and _G.UIID and _G.UIID.Role_ResurgenceUI then
                                            _G.UIManager.Hide(_G.UIID.Role_ResurgenceUI)
                                        end
                                    end)
                                end
                            end
                        end

                        -- 3. BẢO VỆ: DẬP TẮT POPUP 3S ĐẾM LÙI KHI NHÂN VẬT ĐÃ SỐNG
                        if not me.isDead and me.hp and me.hp > 0 then
                            if _G.UIManager and _G.UIManager.IsVisible and _G.UIID and _G.UIID.Role_ResurgenceUI then
                                if _G.UIManager.IsVisible(_G.UIID.Role_ResurgenceUI) then
                                    _G.UIManager.Hide(_G.UIID.Role_ResurgenceUI)
                                end
                            end
                        end
                    end

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
                                                local rawPct = (role.hp / maxHp) * 100
                                                local hpPct = math.max(0.01, rawPct)
                                                local msg = string.format("%s HP: %.2f%%", d.name, hpPct)
                                                if not _G.AutoPick_Enabled then
                                                    msg = msg .. " - BẠN CHƯA BẬT NHẶT NHANH"
                                                end
                                                if _G.FloatingWordUtility then _G.FloatingWordUtility.QuickMsg(msg) end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            _G.Mod_LastKundunHPTime = currentSec + 1
                        end
                    end

                    -- BATCH LOOT: Quét sạch đồ mặt đất định kỳ 0.05s/lần
                    if _G.AutoPick_Enabled then
                        if (_G.AutoPick_Count or 0) < (_G.AutoPick_Limit or 23) then
                            local nowRealtime = CS.UnityEngine.Time.realtimeSinceStartup
                            if (nowRealtime - (_G.Mod_LastGroundScanTime or 0)) >= 0.05 then
                                _G.Mod_LastGroundScanTime = nowRealtime
                                pcall(function()
                                    local dropItems = nil
                                    if _G.DropItemManager and _G.DropItemManager.GetDropItemById then
                                        local _, val = debug.getupvalue(_G.DropItemManager.GetDropItemById, 1)
                                        if type(val) == "table" then dropItems = val end
                                    end

                                    if dropItems then
                                        _G.Mod_ItemConfigCache = _G.Mod_ItemConfigCache or {}
                                        for _, itemObj in pairs(dropItems) do
                                            local dropItemData = itemObj and (itemObj.data or itemObj)
                                            if dropItemData and dropItemData.id and not (_G.Mod_PickedItems and _G.Mod_PickedItems[dropItemData.id]) then
                                                local eType = dropItemData.type
                                                local isRune = (eType == 19 or eType == 28)
                                                local isBone = (eType == 24 or eType == 26)
                                                local shouldPick = false

                                                if isRune then
                                                    local confId = (dropItemData.item and dropItemData.item.itemId) or
                                                        dropItemData.configId
                                                    if confId then
                                                        local cachedPref = _G.Mod_ItemConfigCache[confId]
                                                        if cachedPref == nil then
                                                            local rLevel = confId % 10
                                                            local rColor = 0
                                                            local cfg = nil
                                                            if _G.ClientTable and _G.ClientTable.cfg_Item_itemManager then
                                                                cfg = _G.ClientTable.cfg_Item_itemManager:TryGetValue(
                                                                    confId)
                                                            end
                                                            if not cfg and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
                                                                cfg = _G.ClientTable.cfg_Item_equipManager:TryGetValue(
                                                                    confId)
                                                            end
                                                            if cfg and cfg.subType then
                                                                if cfg.type == 19 then
                                                                    rColor = math.floor(cfg.subType / 1000)
                                                                elseif cfg.type == 28 then
                                                                    local lastDigit = cfg.subType % 10
                                                                    if lastDigit == 1 then
                                                                        rColor = 3
                                                                    elseif lastDigit == 2 then
                                                                        rColor = 2
                                                                    elseif lastDigit == 3 then
                                                                        rColor = 1
                                                                    end
                                                                end
                                                            end
                                                            local lvKey = "L5L"
                                                            if rLevel == 5 then
                                                                lvKey = "L5"
                                                            elseif rLevel == 6 then
                                                                lvKey = "L6"
                                                            elseif rLevel == 7 then
                                                                lvKey = "L7"
                                                            elseif rLevel > 7 then
                                                                lvKey = "L7M"
                                                            end
                                                            local clrKey = "Luc"
                                                            if rColor == 2 then
                                                                clrKey = "Lam"
                                                            elseif rColor >= 3 then
                                                                clrKey = "Do"
                                                            end
                                                            cachedPref = "AutoPick_Rune_" .. lvKey .. "_" .. clrKey
                                                            _G.Mod_ItemConfigCache[confId] = cachedPref
                                                        end
                                                        if _G[cachedPref] == true then shouldPick = true end
                                                    end
                                                end
                                                if isBone then shouldPick = true end

                                                if shouldPick and ((_G.AutoPick_Count or 0) < _G.AutoPick_Limit) then
                                                    _G.Mod_PickedItems = _G.Mod_PickedItems or {}
                                                    _G.Mod_PickedItems[dropItemData.id] = true
                                                    _G.AutoPick_Count = (_G.AutoPick_Count or 0) + 1

                                                    if _G.PickupManager and _G.PickupManager.AddDropSceneCellPos then
                                                        -- Đưa vào quy trình nhặt chung
                                                        local dummyItem = { data = dropItemData }
                                                        _G.PickupManager.AddDropSceneCellPos(dummyItem)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                    end

                    if (_G.AutoPick_Enabled or _G.Mod_AutoPK_Enabled) and _G.Mod_ActiveSpamItems then
                        if _G.AutoPick_Mode == nil then
                            _G.AutoPick_Mode = CS.UnityEngine.PlayerPrefs.GetInt("AutoPick_Mode", 1)
                            if _G.AutoPick_Mode ~= 1 and _G.AutoPick_Mode ~= 2 then
                                _G.AutoPick_Mode = 1
                            end
                        end

                        local nowTime = CS.UnityEngine.Time.realtimeSinceStartup

                        if _G.AutoPick_Mode == 1 then
                            -- PA NHẶT 1: Rollback spam siêu tốc mỗi frame
                            for itemId, itemInfo in pairs(_G.Mod_ActiveSpamItems) do
                                if nowTime > itemInfo.expireTime then
                                    _G.Mod_ActiveSpamItems[itemId] = nil
                                else
                                    if _G.PickupManager then
                                        _G.PickupManager.ReqPickUpMapItem(itemId)

                                        -- Khi chạy tới sát vị trí item (cự ly <= 2 ô), bắn bồi thêm gói kép
                                        if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.serverCoord then
                                            local meX = _G.RoleManager.me.serverCoord.x or 0
                                            local meY = _G.RoleManager.me.serverCoord.y or 0
                                            if itemInfo.x and itemInfo.y then
                                                local dist = math.max(math.abs(meX - itemInfo.x),
                                                    math.abs(meY - itemInfo.y))
                                                if dist <= 2 then
                                                    _G.PickupManager.ReqPickUpMapItem(itemId)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            -- PA NHẶT 2: Ưu tiên khoảng cách gần nhất + giãn cách spam 0.1s
                            local validItems = {}

                            for itemId, itemInfo in pairs(_G.Mod_ActiveSpamItems) do
                                if nowTime > itemInfo.expireTime then
                                    _G.Mod_ActiveSpamItems[itemId] = nil
                                elseif nowTime >= (itemInfo.startTime or 0) then
                                    table.insert(validItems, itemInfo)
                                end
                            end

                            if #validItems > 0 then
                                local meX, meY = 0, 0
                                if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.serverCoord then
                                    meX = _G.RoleManager.me.serverCoord.x or 0
                                    meY = _G.RoleManager.me.serverCoord.y or 0
                                end

                                for _, itemInfo in ipairs(validItems) do
                                    itemInfo.dist = math.max(math.abs(meX - (itemInfo.x or 0)),
                                        math.abs(meY - (itemInfo.y or 0)))
                                end

                                table.sort(validItems, function(a, b)
                                    return a.dist < b.dist
                                end)

                                local nearestItem = validItems[1]

                                for _, itemInfo in ipairs(validItems) do
                                    if (nowTime - (itemInfo.lastSpamTime or 0)) >= 0.1 then
                                        itemInfo.lastSpamTime = nowTime

                                        -- Chỉ di chuyển (MoveTo) đến 1 món GẦN NHẤT nếu dist > 1 (tránh xoay đầu)
                                        if itemInfo == nearestItem and itemInfo.dist > 1 then
                                            if _G.RoleManager and _G.RoleManager.me and itemInfo.x and itemInfo.y then
                                                pcall(function()
                                                    _G.RoleManager.me:MoveTo({ x = itemInfo.x, y = itemInfo.y })
                                                end)
                                            end
                                        end

                                        -- Bắn gói tin nhặt đơn lẻ 100%
                                        if _G.PickupManager then
                                            _G.PickupManager.ReqPickUpMapItem(itemInfo.id)
                                        end
                                    end
                                end
                            end
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
                -- _G.Timer.StartLoop(0.2, -1, function()
                --     pcall(function()
                --         if _G.Mod_AutoAoE_BossAn then
                --             local mapId = _G.SceneData and _G.SceneData.mapId or 0
                --             if tonumber(mapId) == 240001 then
                --                 local me = _G.RoleManager and _G.RoleManager.me
                --                 local target = me and me.TargetAvatar
                --                 if target and not target.isDead and me.skills then
                --                     local allowedAoEPrefixes = {
                --                         ["140401"] = true, -- Ma Ky Sy: Set Danh
                --                     }
                --                     for _, skill in pairs(me.skills) do
                --                         local sid = skill.sid or skill.id or skill.skillId
                --                         if sid then
                --                             local prefix = tostring(sid):sub(1, 6)
                --                             if allowedAoEPrefixes[prefix] then
                --                                 local tblSkill = _G.ClientTable and _G.ClientTable.cfg_Skill_skillManager:TryGetValue(sid)
                --                                 if tblSkill then
                --                                     local cdMsg = me.cd and me.cd[tblSkill.groupId]
                --                                     local endTime = cdMsg and cdMsg.endTime or 0
                --                                     local publicCdMsg = me.cd and me.cd[1]
                --                                     local publicEndTime = publicCdMsg and publicCdMsg.endTime or 0
                --                                     local finalEndTime = math.max(endTime, publicEndTime)

                --                                     if _G.Time and finalEndTime <= _G.Time.GetServerTime() then
                --                                         local tblaction = _G.ConfigManager and _G.ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
                --                                         if tblaction and _G.SkillMgr and _G.SkillMgr.SendSkillMessage then
                --                                             local coord = target.serverCoord or me.serverCoord
                --                                             _G.SkillMgr.SendSkillMessage(tblSkill, tblaction, target.id, coord)
                --                                             break
                --                                         end
                --                                     end
                --                                 end
                --                             end
                --                         end
                --                     end
                --                 end
                --             end
                --         end
                --     end)
                -- end)

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
                        if not _G.Mod_IsAdmin or not _G.Mod_TeleNotify_Enabled then return end

                        local currentSec = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or
                            os.time()
                        if currentSec - (_G.LastTeleCheckSec or 0) < 5 then return end
                        _G.LastTeleCheckSec = currentSec

                        local allKunduns = {
                            { tab = "C7", name = "THÁNH CỐT", bossType = 16, bossId = 20201007, limit = 70, threshold = 5 },
                            { tab = "C7", name = "PHÙ VĂN", bossType = 17, bossId = 20211007, limit = 300, threshold = 15 },
                            { tab = "C8", name = "THÁNH CỐT", bossType = 16, bossId = 20201008, limit = 70, threshold = 5 },
                            { tab = "C8", name = "PHÙ VĂN", bossType = 17, bossId = 20211008, limit = 400, threshold = 15 }
                        }

                        _G.LastTeleNotifySec_Boss = _G.LastTeleNotifySec_Boss or {}

                        if _G.SceneData and _G.SceneData.GetAncientBossData then
                            for _, cfg in ipairs(allKunduns) do
                                local count = 0
                                local isSatisfy, info = _G.SceneData:GetAncientBossData(cfg.bossType, cfg.bossId)

                                if isSatisfy == true then
                                    count = cfg.limit
                                elseif isSatisfy == false and info and info.count then
                                    count = info.count
                                end

                                if cfg.limit - count <= cfg.threshold then
                                    local bossKey = cfg.tab .. "_" .. cfg.name
                                    local lastNotify = _G.LastTeleNotifySec_Boss[bossKey] or 0

                                    if currentSec - lastNotify >= 180 then
                                        _G.LastTeleNotifySec_Boss[bossKey] = currentSec

                                        local statusTitle = (count >= cfg.limit) and "Đã Hiện!" or "Sắp Ra!"
                                        local rCount = (info and info.refreshCount) and info.refreshCount or 0
                                        local msgText = (count >= cfg.limit) and "Hiện" or tostring(rCount)
                                        local msg = string.format("\n🔴 KUNDUN %s: %s %s\n- Số lượng: %d / %d (%s)",
                                            cfg.tab, cfg.name, statusTitle, count, cfg.limit, msgText)

                                        local botToken = "8585747708:AAF_633qF-8JzWCDUWsNnqPTrvf9DbXEJa0"
                                        local chatId = "-5255708823"
                                        local function SendTeleAsync()
                                            local url = "https://api.telegram.org/bot" ..
                                                botToken ..
                                                "/sendMessage?chat_id=" ..
                                                chatId .. "&text=" .. CS.UnityEngine.WWW.EscapeURL(msg)
                                            pcall(function() CS.UnityEngine.WWW(url) end)
                                        end
                                        SendTeleAsync()
                                    end
                                end
                            end
                        end
                    end)

                    pcall(function()
                        if _G.AutoFightFindTargetManager and not _G.Mod_HookedAutoFightTarget then
                            _G.Mod_HookedAutoFightTarget = true
                            local original_GetMostMonster = _G.AutoFightFindTargetManager.GetMostMonsterInMonsterList
                            if original_GetMostMonster then
                                _G.AutoFightFindTargetManager.GetMostMonsterInMonsterList = function(skillRange,
                                                                                                     roleTypes,
                                                                                                     autoDoubleSkillType)
                                    if _G.Mod_AutoAoE_BossAn then
                                        local mapId = _G.SceneData and _G.SceneData.mapId or 0
                                        if tonumber(mapId) == 240001 then
                                            local target = _G.RoleManager.me.TargetAvatar
                                            if target then
                                                return target
                                            end
                                            local monsterRange = 8
                                            local monsters = _G.RoleManager.GetRolesByTypeAndRangeAlive(roleTypes,
                                                monsterRange, _G.RoleTargetManager.GetCanAttackRole)
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

                            local original_GetSpecifyMonster = _G.AutoFightFindTargetManager
                                .GetSpecifyMonsterIntersectionNew
                            if original_GetSpecifyMonster then
                                _G.AutoFightFindTargetManager.GetSpecifyMonsterIntersectionNew = function(skillRange,
                                                                                                          specifyMonster,
                                                                                                          roleTypes)
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



                    -- Auto PK & Lock Target Logic (Loop động theo _G.Mod_PKScanDelay)
                    if not _G.Mod_PKScanLoopStarted then
                        _G.Mod_PKScanLoopStarted = true
                        if _G.Timer and _G.Timer.StartLoop then
                            _G.Timer.StartLoop(0.05, -1, function()
                                pcall(function()
                                    if _G.Mod_AutoPK_Enabled and _G.RoleManager and _G.RoleManager.me then
                                        local nowTime = CS.UnityEngine.Time.realtimeSinceStartup
                                        local delay = _G.Mod_PKScanDelay or 0.8
                                        if (nowTime - (_G.Mod_LastPKScanTime or 0)) >= delay then
                                            _G.Mod_LastPKScanTime = nowTime
                                            local function modSortRole(a, b)
                                                local distA = a.tempPathFindingDistance or 9999
                                                local distB = b.tempPathFindingDistance or 9999
                                                return distA < distB
                                            end

                                            local function isMatchLockTarget(p, lockInput)
                                                if not lockInput or lockInput == "" then return false end

                                                local cleanInput = string.gsub(lockInput, "^%s*(.-)%s*$", "%1")
                                                if cleanInput == "" then return false end

                                                local sId = string.match(cleanInput, "^S(%d+)%.$") or
                                                    string.match(cleanInput, "^S(%d+)$")

                                                local targetNum = sId and tonumber(sId) or nil
                                                if targetNum then
                                                    local pSid = p.serverId or p.sid or p.serverID or p.server_id
                                                    if not pSid and p.data then
                                                        pSid = p.data.serverId or p.data.sid or p.data.serverID or
                                                            p.data.server_id
                                                    end
                                                    if pSid and tonumber(pSid) == targetNum then
                                                        return true
                                                    end
                                                end

                                                local strList = {}
                                                if p.name then table.insert(strList, tostring(p.name)) end
                                                if p.GetName then
                                                    pcall(function()
                                                        local n = p:GetName()
                                                        if n then table.insert(strList, tostring(n)) end
                                                    end)
                                                end
                                                if p.data then
                                                    if p.data.name then table.insert(strList, tostring(p.data.name)) end
                                                    if p.data.showName then
                                                        table.insert(strList,
                                                            tostring(p.data.showName))
                                                    end
                                                    if p.data.serverId then
                                                        table.insert(strList,
                                                            "S" .. tostring(p.data.serverId))
                                                    end
                                                end
                                                if p.serverId then table.insert(strList, "S" .. tostring(p.serverId)) end
                                                if p.showName then table.insert(strList, tostring(p.showName)) end

                                                if sId then
                                                    local pattern1 = "S" .. sId .. "%."
                                                    local pattern2 = "S" .. sId .. "_"
                                                    local pattern3 = "S" .. sId
                                                    for _, s in ipairs(strList) do
                                                        if string.find(s, pattern1) or string.find(s, pattern2) or string.find(s, pattern3) then
                                                            return true
                                                        end
                                                    end
                                                else
                                                    local lowerInput = string.lower(cleanInput)
                                                    for _, s in ipairs(strList) do
                                                        if string.find(string.lower(s), lowerInput, 1, true) then
                                                            return true
                                                        end
                                                    end
                                                end

                                                return false
                                            end

                                            local function isKundunNearby()
                                                if not (_G.RoleManager and _G.RoleManager.GetRolesByType) then return false end
                                                local monsterRoles = _G.RoleManager.GetRolesByType(2)
                                                if monsterRoles then
                                                    for _, role in pairs(monsterRoles) do
                                                        if role and not role.isDead and role.hp and role.hp > 0 then
                                                            local d = role.data
                                                            if d then
                                                                local name = d.name or (d.GetName and d:GetName()) or ""
                                                                local cfgId = d.configId or d.id or d.bossId or 0
                                                                local strName = string.lower(tostring(name))
                                                                if string.find(strName, "kundun") or
                                                                    cfgId == 20201008 or cfgId == 20211008 or
                                                                    cfgId == 20201007 or cfgId == 20211007 then
                                                                    return true
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                return false
                                            end

                                            -- Quét các đối thủ theo đúng Chế độ PK hiện tại của game (dùng GetCanAttackRole)
                                            local players = _G.RoleManager.GetRolesByTypeAndRangeAlive(1, 15,
                                                _G.RoleTargetManager and _G.RoleTargetManager.GetCanAttackRole)
                                            local target = nil
                                            if players and #players > 0 then
                                                if _G.Mod_LockTarget_Enabled then
                                                    -- BẬT KHÓA MỤC TIÊU: CHỈ tìm và đánh mục tiêu thỏa mãn điều kiện đã nhập. Không có -> target = nil (đứng im)
                                                    if _G.Mod_LockTarget_Name and _G.Mod_LockTarget_Name ~= "" then
                                                        local matchedPlayers = {}
                                                        for _, p in ipairs(players) do
                                                            if isMatchLockTarget(p, _G.Mod_LockTarget_Name) then
                                                                table.insert(matchedPlayers, p)
                                                            end
                                                        end
                                                        if #matchedPlayers > 0 then
                                                            table.sort(matchedPlayers, modSortRole)
                                                            target = matchedPlayers[1]
                                                        end
                                                    end
                                                else
                                                    -- TẮT KHÓA MỤC TIÊU: Đánh tất cả địch ở gần theo chế độ PK
                                                    table.sort(players, modSortRole)
                                                    target = players[1]
                                                end
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
                                            else
                                                -- Hết đối thủ người chơi: CHỈ bật lại AutoFight nếu có Boss Kundun gần đó (tránh giật khựng khi di chuyển)
                                                if isKundunNearby() then
                                                    if _G.QiJiHelperData and not _G.QiJiHelperData.isAutoFight then
                                                        if _G.RoleManager.me and _G.RoleManager.me.SetAutoFight then
                                                            _G.RoleManager.me:SetAutoFight("AutoFight")
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end)
                        end
                    end

                    -- Auto Return Position Logic (Loop động theo _G.Mod_AutoReturnPosDelay)
                    if not _G.Mod_ReturnPosLoopStarted then
                        _G.Mod_ReturnPosLoopStarted = true
                        if _G.Timer and _G.Timer.StartLoop then
                            _G.Timer.StartLoop(0.05, -1, function()
                                pcall(function()
                                    if _G.Mod_AutoReturnPos_Enabled and _G.Mod_AutoReturnPos_Coords and _G.Mod_AutoReturnPos_Coords ~= "" then
                                        local nowTime = CS.UnityEngine.Time.realtimeSinceStartup
                                        local delay = _G.Mod_AutoReturnPosDelay or 1.0
                                        if (nowTime - (_G.Mod_LastReturnPosTime or 0)) >= delay then
                                            _G.Mod_LastReturnPosTime = nowTime
                                            local sx, sy = string.match(_G.Mod_AutoReturnPos_Coords, "^(%d+)#(%d+)$")
                                            if sx and sy then
                                                local targetX, targetY = tonumber(sx), tonumber(sy)
                                                local me = _G.RoleManager and _G.RoleManager.me
                                                if me and not me.isDead then
                                                    local curX = me.serverCoord and me.serverCoord.x or
                                                        (me.cellPos and me.cellPos.x) or 0
                                                    local curY = me.serverCoord and me.serverCoord.y or
                                                        (me.cellPos and me.cellPos.y) or 0
                                                    if curX > 0 and curY > 0 then
                                                        local dist = math.max(math.abs(curX - targetX),
                                                            math.abs(curY - targetY))
                                                        if dist > 1.5 then
                                                            pcall(function()
                                                                if me and me.MoveTo then
                                                                    me:MoveTo({ x = targetX, y = targetY }, 0)
                                                                elseif _G.PathFinderManager and _G.PathFinderManager.JumpMapToMoveToPos and _G.SceneData and _G.SceneData.groupId then
                                                                    local coordStr = string.format("%d#%d", targetX,
                                                                        targetY)
                                                                    local targetPosData = (_G.PathFinderManager.GetCalcPosData and _G.PathFinderManager.GetCalcPosData(coordStr)) or
                                                                        (_G.Vector2 and _G.Vector2(targetX, targetY)) or
                                                                        { x = targetX, y = targetY }
                                                                    _G.PathFinderManager.JumpMapToMoveToPos(
                                                                        _G.SceneData.groupId,
                                                                        targetPosData, nil, nil, nil,
                                                                        _G.Purpose and _G.Purpose.None or 0, nil, 1,
                                                                        true)
                                                                end
                                                            end)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            end)
                        end
                    end

                    -- Auto PK Guild Logic
                    if _G.Mod_AutoGuildPK_Enabled and _G.RoleManager and _G.RoleManager.me and _G.NetManager and _G.RoleMessage then
                        if _G.RoleManager.me.PKMode ~= 2 then -- 2 is Guild mode
                            _G.NetManager.Send(_G.RoleMessage.ReqSetPKMode, { param = 2 })
                        end
                    end

                    if _G.IsAutoRefresh or _G.Mod_TelegramBossAlert then
                        local currentSec = _G.Time.GetServerSecondTime()
                        if currentSec - _G.LastRefreshSec >= _G.AutoRefreshInterval then
                            _G.LastRefreshSec = currentSec
                            if _G.NetManager and _G.MapMessage then
                                _G.NetManager.Send(_G.MapMessage.ReqGetBossMapAndCount)
                                _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 16 })
                                _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 17 })
                            end
                        end
                    end

                    if isExpanded then
                        UpdateBossWatchUIText()
                        if _G.ModUpdateCountText then _G.ModUpdateCountText() end
                        if _G.ModUpdateKundunUI then _G.ModUpdateKundunUI() end
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
            cTxtRt.anchorMin, cTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            cTxtRt.offsetMin, cTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
            pTxtRt.anchorMin, pTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            pTxtRt.offsetMin, pTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
            aTxtRt.anchorMin, aTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            aTxtRt.offsetMin, aTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
                local dataToHash = pCode ..
                    "|" .. tostring(pDuration) .. "|" .. tostring(pTime) .. "MUVH_SECRET_SALT_XOAI"
                local expectedSig = GetMD5(dataToHash)
                if expectedSig ~= pSig then
                    if not isSilent then errTxt.text = "Token đã bị giả mạo!" end
                    return false
                end

                local currentUnixTime = (_G.Time and _G.Time.GetServerSecondTime) and _G.Time.GetServerSecondTime() or
                    os.time()
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
                            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 16 })
                            _G.NetManager.Send(_G.MapMessage.ReqAncientBossInfo, { type = 17 })
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
        if _G.RunSpeedMultiplier == nil then
            _G.RunSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat(
                "Mod_RunSpeedMultiplier", 1.0)
        end
        if _G.AtkSpeedMultiplier == nil then
            _G.AtkSpeedMultiplier = CS.UnityEngine.PlayerPrefs.GetFloat(
                "Mod_AtkSpeedMultiplier", 1.0)
        end
        if _G.Mod_CustomAttackRange == nil then
            _G.Mod_CustomAttackRange = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_CustomAttackRange", 0)
        end
        if _G.Mod_AntiCC == nil then _G.Mod_AntiCC = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AntiCC", 0) == 1 end
        if _G.AutoPick_FilterNormal == nil then
            _G.AutoPick_FilterNormal = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoPick_FilterNormal", 0) == 1
        end
        if _G.AutoPick_Limit == nil then _G.AutoPick_Limit = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoPick_Limit", 2) end
        if _G.AutoPick_Limit == 0 then _G.AutoPick_Limit = 2 end
        if _G.AutoJumpBoss_Enabled == nil then
            _G.AutoJumpBoss_Enabled = CS.UnityEngine.PlayerPrefs.GetInt(
                "Mod_AutoJumpBoss_Enabled", 1) == 1
        end
        local runeLevels = { "L5L", "L5", "L6", "L7", "L7M" }
        local runeColors = { "Luc", "Lam", "Do" }
        for _, lv in ipairs(runeLevels) do
            for _, clr in ipairs(runeColors) do
                local key = "AutoPick_Rune_" .. lv .. "_" .. clr
                if _G[key] == nil then
                    _G[key] = CS.UnityEngine.PlayerPrefs.GetInt("Mod_" .. key, 0) == 1
                end
            end
        end
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
                txt.raycastTarget, txt.text, txt.color, txt.fontSize, txt.alignment = false, text, Color.white, 18,
                    TextAnchor.MiddleCenter
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




        local function CreateToggle(label, varName, xPos, yPos, customWidth)
            local tGo = GameObject(varName .. "_Toggle")
            tGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, tGo)

            local tRt = tGo:AddComponent(typeof(RectTransform))
            tRt.anchorMin, tRt.anchorMax, tRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tRt.anchoredPosition = Vector2(xPos, yPos)
            tRt.sizeDelta = Vector2(customWidth or 260, 35)

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
            local currentY = -65
            local rightColX = 20

            local titleGo = GameObject("AutoLootTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin, titleRt.anchorMax, titleRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX + 10, currentY)
            titleRt.sizeDelta = Vector2(300, 25)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ NHẶT ĐỒ SIÊU TỐC ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 17
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end

            currentY = currentY - 35

            CreateToggle("TỰ ĐỘNG NHẶT", "AutoPick_Enabled", rightColX, currentY)
            currentY = currentY - 40

            if _G.AutoPick_Mode == nil then
                _G.AutoPick_Mode = CS.UnityEngine.PlayerPrefs.GetInt("AutoPick_Mode", 1)
                if _G.AutoPick_Mode ~= 1 and _G.AutoPick_Mode ~= 2 then
                    _G.AutoPick_Mode = 1
                end
            end

            local btnWidth = 125
            local btnHeight = 30

            local btnPa1Go = GameObject("AutoPick_PA1_Btn")
            btnPa1Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, btnPa1Go)
            local rtPa1 = btnPa1Go:AddComponent(typeof(RectTransform))
            rtPa1.anchorMin, rtPa1.anchorMax, rtPa1.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            rtPa1.anchoredPosition = Vector2(rightColX, currentY)
            rtPa1.sizeDelta = Vector2(btnWidth, btnHeight)

            local bgPa1 = GameObject("Bg")
            bgPa1.transform:SetParent(btnPa1Go.transform, false)
            local bgRtPa1 = bgPa1:AddComponent(typeof(RectTransform))
            bgRtPa1.anchorMin, bgRtPa1.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bgRtPa1.sizeDelta = Vector2(0, 0)
            local bgImgPa1 = bgPa1:AddComponent(typeof(Image))

            local txtGoPa1 = GameObject("Text")
            txtGoPa1.transform:SetParent(btnPa1Go.transform, false)
            local txtRtPa1 = txtGoPa1:AddComponent(typeof(RectTransform))
            txtRtPa1.anchorMin, txtRtPa1.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRtPa1.sizeDelta = Vector2(0, 0)
            local txtPa1 = txtGoPa1:AddComponent(typeof(Text))
            txtPa1.raycastTarget = false
            txtPa1.fontSize = 15
            txtPa1.alignment = TextAnchor.MiddleCenter
            txtPa1.text = "PA NHẶT 1"
            if defaultFont then txtPa1.font = defaultFont end

            local btnPa1 = btnPa1Go:AddComponent(typeof(Button))

            local btnPa2Go = GameObject("AutoPick_PA2_Btn")
            btnPa2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, btnPa2Go)
            local rtPa2 = btnPa2Go:AddComponent(typeof(RectTransform))
            rtPa2.anchorMin, rtPa2.anchorMax, rtPa2.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            rtPa2.anchoredPosition = Vector2(rightColX + btnWidth + 10, currentY)
            rtPa2.sizeDelta = Vector2(btnWidth, btnHeight)

            local bgPa2 = GameObject("Bg")
            bgPa2.transform:SetParent(btnPa2Go.transform, false)
            local bgRtPa2 = bgPa2:AddComponent(typeof(RectTransform))
            bgRtPa2.anchorMin, bgRtPa2.anchorMax = Vector2(0, 0), Vector2(1, 1)
            bgRtPa2.sizeDelta = Vector2(0, 0)
            local bgImgPa2 = bgPa2:AddComponent(typeof(Image))

            local txtGoPa2 = GameObject("Text")
            txtGoPa2.transform:SetParent(btnPa2Go.transform, false)
            local txtRtPa2 = txtGoPa2:AddComponent(typeof(RectTransform))
            txtRtPa2.anchorMin, txtRtPa2.anchorMax = Vector2(0, 0), Vector2(1, 1)
            txtRtPa2.sizeDelta = Vector2(0, 0)
            local txtPa2 = txtGoPa2:AddComponent(typeof(Text))
            txtPa2.raycastTarget = false
            txtPa2.fontSize = 15
            txtPa2.alignment = TextAnchor.MiddleCenter
            txtPa2.text = "PA NHẶT 2"
            if defaultFont then txtPa2.font = defaultFont end

            local btnPa2 = btnPa2Go:AddComponent(typeof(Button))

            local function UpdatePAModeLabels()
                if _G.AutoPick_Mode == 1 then
                    bgImgPa1.color = Color(0.2, 0.5, 0.2, 1)
                    txtPa1.color = Color.white
                    bgImgPa2.color = Color(0.3, 0.3, 0.3, 1)
                    txtPa2.color = Color(0.7, 0.7, 0.7, 1)
                else
                    bgImgPa1.color = Color(0.3, 0.3, 0.3, 1)
                    txtPa1.color = Color(0.7, 0.7, 0.7, 1)
                    bgImgPa2.color = Color(0.2, 0.5, 0.2, 1)
                    txtPa2.color = Color.white
                end
            end
            UpdatePAModeLabels()

            btnPa1.onClick:AddListener(function()
                _G.AutoPick_Mode = 1
                CS.UnityEngine.PlayerPrefs.SetInt("AutoPick_Mode", 1)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdatePAModeLabels()
            end)

            btnPa2.onClick:AddListener(function()
                _G.AutoPick_Mode = 2
                CS.UnityEngine.PlayerPrefs.SetInt("AutoPick_Mode", 2)
                CS.UnityEngine.PlayerPrefs.Save()
                UpdatePAModeLabels()
            end)

            currentY = currentY - 40


            local function CreateRuneLabel(text, y)
                local lbl = GameObject("RuneLbl_" .. text)
                lbl.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, lbl)
                local rt = lbl:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(rightColX, y)
                rt.sizeDelta = Vector2(70, 20)
                local txt = lbl:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.text = text
                txt.color = Color(1, 1, 0.5, 1)
                txt.fontSize = 16
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end
            end

            local runeRows = {
                { label = "PV < 5", key = "L5L" },
                { label = "PV 5",   key = "L5" },
                { label = "PV 6",   key = "L6" },
                { label = "PV 7",   key = "L7" },
                { label = "PV > 7", key = "L7M" }
            }
            for _, row in ipairs(runeRows) do
                CreateRuneLabel(row.label, currentY)
                CreateSmallToggle("Lục", "AutoPick_Rune_" .. row.key .. "_Luc", rightColX + 65, currentY + 5, 50)
                CreateSmallToggle("Lam", "AutoPick_Rune_" .. row.key .. "_Lam", rightColX + 120, currentY + 5, 50)
                CreateSmallToggle("Đỏ", "AutoPick_Rune_" .. row.key .. "_Do", rightColX + 175, currentY + 5, 50)
                currentY = currentY - 35
            end
            currentY = currentY + 35

            currentY = currentY - 35

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
                _G.AutoPick_Limit = _G.AutoPick_Limit + 1
                CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoPick_Limit", _G.AutoPick_Limit)
                CS.UnityEngine.PlayerPrefs.Save()
                lvTxt.text = "SỐ LƯỢNG NHẶT: " .. tostring(_G.AutoPick_Limit)
            end)


            -- Move options from Kundun UI
            local rightColX2 = 20
            currentY = currentY - 35
            local sep2Go = GameObject("BossThapSeparator")
            sep2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, sep2Go)
            local sep2Rt = sep2Go:AddComponent(typeof(RectTransform))
            sep2Rt.anchorMin = Vector2(0, 1)
            sep2Rt.anchorMax = Vector2(0, 1)
            sep2Rt.pivot = Vector2(0, 1)
            sep2Rt.anchoredPosition = Vector2(20, currentY)
            sep2Rt.sizeDelta = Vector2(320, 20)
            local sep2Txt = sep2Go:AddComponent(typeof(Text))
            sep2Txt.raycastTarget = false
            sep2Txt.color = Color(0.4, 0.4, 0.4, 1)
            sep2Txt.fontSize = 14
            sep2Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then sep2Txt.font = defaultFont end
            sep2Txt.text = "--------------------------------------------------------"

            currentY = currentY - 20
            local titleGo = GameObject("KundunTitle")
            titleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, titleGo)
            local titleRt = titleGo:AddComponent(typeof(RectTransform))
            titleRt.anchorMin = Vector2(0, 1)
            titleRt.anchorMax = Vector2(0, 1)
            titleRt.pivot = Vector2(0, 1)
            titleRt.anchoredPosition = Vector2(rightColX + 10, currentY)
            titleRt.sizeDelta = Vector2(270, 25)
            local titleTxt = titleGo:AddComponent(typeof(Text))
            titleTxt.raycastTarget = false
            titleTxt.text = "[ INFO KUNDUN BOSS ]"
            titleTxt.color = Color(1, 0.8, 0, 1)
            titleTxt.fontSize = 18
            titleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then titleTxt.font = defaultFont end


            currentY = currentY - 25

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

            currentY = currentY - 25

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

            -- Toggle BÁO TELEGRAM
            if _G.Mod_IsAdmin then
                local tGoTele = GameObject("Mod_TeleNotify_Enabled_Toggle")
                tGoTele.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, tGoTele)

                local tRtTele = tGoTele:AddComponent(typeof(RectTransform))
                tRtTele.anchorMin, tRtTele.anchorMax, tRtTele.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                tRtTele.anchoredPosition = Vector2(rightColX2, currentY)
                tRtTele.sizeDelta = Vector2(140, 30)

                local bgTele = GameObject("Bg")
                bgTele.transform:SetParent(tGoTele.transform, false)
                local bgRtTele = bgTele:AddComponent(typeof(RectTransform))
                bgRtTele.anchorMin, bgRtTele.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRtTele.sizeDelta = Vector2(0, 0)
                local bgImgTele = bgTele:AddComponent(typeof(Image))

                local txtGoTele = GameObject("Text")
                txtGoTele.transform:SetParent(tGoTele.transform, false)
                local txtRtTele = txtGoTele:AddComponent(typeof(RectTransform))
                txtRtTele.anchorMin, txtRtTele.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRtTele.sizeDelta = Vector2(0, 0)
                local txtTele = txtGoTele:AddComponent(typeof(Text))
                txtTele.raycastTarget = false
                txtTele.fontSize = 15
                txtTele.alignment = TextAnchor.MiddleCenter
                if defaultFont then txtTele.font = defaultFont end

                local btnTele = tGoTele:AddComponent(typeof(Button))

                if _G.Mod_TeleNotify_Enabled == nil then
                    _G.Mod_TeleNotify_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_TeleNotify_Enabled", 0) == 1
                end

                local function UpdateTeleLabel()
                    if _G.Mod_TeleNotify_Enabled then
                        bgImgTele.color = Color(0.2, 0.5, 0.2, 1)
                        txtTele.text = "BÁO TELEGRAM"
                        txtTele.color = Color.white
                    else
                        bgImgTele.color = Color(0.3, 0.3, 0.3, 1)
                        txtTele.text = "BÁO TELEGRAM"
                        txtTele.color = Color(0.7, 0.7, 0.7, 1)
                    end
                end
                UpdateTeleLabel()

                btnTele.onClick:AddListener(function()
                    _G.Mod_TeleNotify_Enabled = not _G.Mod_TeleNotify_Enabled
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_TeleNotify_Enabled", _G.Mod_TeleNotify_Enabled and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                    UpdateTeleLabel()
                end)

                -- Toggle TỔNG HỢP ẨN
                local tGoAnStats = GameObject("Mod_AnStats_Enabled_Toggle")
                tGoAnStats.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, tGoAnStats)

                local tRtAnStats = tGoAnStats:AddComponent(typeof(RectTransform))
                tRtAnStats.anchorMin, tRtAnStats.anchorMax, tRtAnStats.pivot = Vector2(0, 1), Vector2(0, 1),
                    Vector2(0, 1)
                tRtAnStats.anchoredPosition = Vector2(rightColX2 + 160, currentY)
                tRtAnStats.sizeDelta = Vector2(130, 30)

                local bgAnStats = GameObject("Bg")
                bgAnStats.transform:SetParent(tGoAnStats.transform, false)
                local bgRtAnStats = bgAnStats:AddComponent(typeof(RectTransform))
                bgRtAnStats.anchorMin, bgRtAnStats.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRtAnStats.sizeDelta = Vector2(0, 0)
                local bgImgAnStats = bgAnStats:AddComponent(typeof(Image))

                local txtGoAnStats = GameObject("Text")
                txtGoAnStats.transform:SetParent(tGoAnStats.transform, false)
                local txtRtAnStats = txtGoAnStats:AddComponent(typeof(RectTransform))
                txtRtAnStats.anchorMin, txtRtAnStats.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRtAnStats.sizeDelta = Vector2(0, 0)
                local txtAnStats = txtGoAnStats:AddComponent(typeof(Text))
                txtAnStats.raycastTarget = false
                txtAnStats.fontSize = 15
                txtAnStats.alignment = TextAnchor.MiddleCenter
                if defaultFont then txtAnStats.font = defaultFont end

                local btnAnStats = tGoAnStats:AddComponent(typeof(Button))

                if _G.Mod_AnStats_Enabled == nil then
                    _G.Mod_AnStats_Enabled = CS.UnityEngine.PlayerPrefs.GetInt("Mod_AnStats_Enabled", 0) == 1
                end

                local function UpdateAnStatsLabel()
                    if _G.Mod_AnStats_Enabled then
                        bgImgAnStats.color = Color(0.2, 0.5, 0.2, 1)
                        txtAnStats.text = "TỔNG HỢP ẨN"
                        txtAnStats.color = Color.white
                    else
                        bgImgAnStats.color = Color(0.3, 0.3, 0.3, 1)
                        txtAnStats.text = "TỔNG HỢP ẨN"
                        txtAnStats.color = Color(0.7, 0.7, 0.7, 1)
                    end
                end
                UpdateAnStatsLabel()

                btnAnStats.onClick:AddListener(function()
                    _G.Mod_AnStats_Enabled = not _G.Mod_AnStats_Enabled
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AnStats_Enabled", _G.Mod_AnStats_Enabled and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                    UpdateAnStatsLabel()
                end)

                currentY = currentY - 35
            end

            _G.ModUpdateKundunUI = function()
                pcall(function()
                    if _G.NangCaoTabBtns then
                        _G.NangCaoTabBtns.C7.txt.text = "<color=" ..
                            (_G.ModBossTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                        _G.NangCaoTabBtns.C8.txt.text = "<color=" ..
                            (_G.ModBossTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"
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
                            local isGreen = (cfg.limit - count <= threshold)

                            local colorTag = isGreen and "<color=#00FF00>" or "<color=#FFFFFF>"
                            if count >= cfg.limit then
                                txt.text = cfg.name ..
                                    string.format(" %s%d / %d</color> (Hiện)", colorTag, count, cfg.limit)
                            else
                                txt.text = cfg.name ..
                                    string.format(" %s%d / %d</color> (%d)", colorTag, count, cfg.limit, rCount)
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

            -- Vertical Separator Line (Left 2/3 vs Right 1/3)
            local vLineGo = GameObject("AutoBossVLine")
            vLineGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, vLineGo)
            local vlRt = vLineGo:AddComponent(typeof(RectTransform))
            vlRt.anchorMin, vlRt.anchorMax, vlRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            vlRt.anchoredPosition = Vector2(465, -60)
            vlRt.sizeDelta = Vector2(2, 500)
            local vlImg = vLineGo:AddComponent(typeof(Image))
            vlImg.color = Color(0.4, 0.4, 0.4, 0.6)

            -- LEFT 2/3 PANEL - HEADER CONTROLS
            -- Master Toggle: AUTO FARM
            local masterToggleGo = GameObject("AutoFarmBossToggle")
            masterToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, masterToggleGo)
            local mtRt = masterToggleGo:AddComponent(typeof(RectTransform))
            mtRt.anchorMin, mtRt.anchorMax, mtRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            mtRt.anchoredPosition = Vector2(startX, -70)
            mtRt.sizeDelta = Vector2(200, 32)

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
            mtTxt.fontSize = 16
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

            -- TỌA ĐỘ TRAIN InputField + Nút XY HIỆN TẠI (CHỈ CHO ADMIN)
            if _G.Mod_IsAdmin then
                local labelTrainGo = GameObject("TrainCoordLabel")
                labelTrainGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, labelTrainGo)
                local lblRt = labelTrainGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(230, -50)
                lblRt.sizeDelta = Vector2(220, 20)
                local lblTxt = labelTrainGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = "TỌA ĐỘ TRAIN (x#y):"
                lblTxt.color = Color(1, 0.85, 0.4, 1)
                lblTxt.fontSize = 11
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end

                -- 1. InputField Tọa độ Train (Thu ngắn 1 nửa: width = 105px)
                local trainTgtGo = GameObject("TrainCoordInput")
                trainTgtGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, trainTgtGo)
                local trainRt = trainTgtGo:AddComponent(typeof(RectTransform))
                trainRt.anchorMin, trainRt.anchorMax, trainRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                trainRt.anchoredPosition = Vector2(230, -70)
                trainRt.sizeDelta = Vector2(105, 32)

                local trainBg = GameObject("Bg")
                trainBg.transform:SetParent(trainTgtGo.transform, false)
                local trainBgRt = trainBg:AddComponent(typeof(RectTransform))
                trainBgRt.anchorMin, trainBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                trainBgRt.sizeDelta = Vector2(0, 0)
                local trainImg = trainBg:AddComponent(typeof(Image))
                trainImg.color = Color(0.1, 0.1, 0.1, 1)

                local trainTxtGo = GameObject("Text")
                trainTxtGo.transform:SetParent(trainTgtGo.transform, false)
                local trainTxtRt = trainTxtGo:AddComponent(typeof(RectTransform))
                trainTxtRt.anchorMin, trainTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                trainTxtRt.offsetMin, trainTxtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
                local trainTxt = trainTxtGo:AddComponent(typeof(Text))

                if _G.Mod_TrainCoord == nil then
                    pcall(function() _G.Mod_TrainCoord = CS.UnityEngine.PlayerPrefs.GetString("Mod_TrainCoord", "") end)
                    if _G.Mod_TrainCoord == nil then _G.Mod_TrainCoord = "" end
                end

                trainTxt.text = (_G.Mod_TrainCoord ~= "" and _G.Mod_TrainCoord or "125#340")
                trainTxt.color = (_G.Mod_TrainCoord ~= "" and Color.white or Color(0.6, 0.6, 0.6, 1))
                trainTxt.fontSize = 13
                trainTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then trainTxt.font = defaultFont end

                local trainField = trainTgtGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
                trainField.textComponent = trainTxt
                trainField.text = _G.Mod_TrainCoord

                trainField.onValueChanged:AddListener(function(val)
                    _G.Mod_TrainCoord = val
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetString("Mod_TrainCoord", val)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                end)

                -- 2. Nút XY HIỆN TẠI (Đặt bên cạnh, width = 110px)
                local getPosBtnGo = GameObject("GetCurPosBtn")
                getPosBtnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, getPosBtnGo)
                local getPosRt = getPosBtnGo:AddComponent(typeof(RectTransform))
                getPosRt.anchorMin, getPosRt.anchorMax, getPosRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                getPosRt.anchoredPosition = Vector2(340, -70)
                getPosRt.sizeDelta = Vector2(110, 32)

                local getPosBg = GameObject("Bg")
                getPosBg.transform:SetParent(getPosBtnGo.transform, false)
                local getPosBgRt = getPosBg:AddComponent(typeof(RectTransform))
                getPosBgRt.anchorMin, getPosBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                getPosBgRt.sizeDelta = Vector2(0, 0)
                local getPosBgImg = getPosBg:AddComponent(typeof(Image))
                getPosBgImg.color = Color(0.2, 0.5, 0.7, 1)

                local getPosTxtGo = GameObject("Text")
                getPosTxtGo.transform:SetParent(getPosBtnGo.transform, false)
                local getPosTxtRt = getPosTxtGo:AddComponent(typeof(RectTransform))
                getPosTxtRt.anchorMin, getPosTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                getPosTxtRt.sizeDelta = Vector2(0, 0)
                local getPosTxt = getPosTxtGo:AddComponent(typeof(Text))
                getPosTxt.raycastTarget = false
                getPosTxt.text = "XY HIỆN TẠI"
                getPosTxt.color = Color.white
                getPosTxt.fontSize = 13
                getPosTxt.alignment = TextAnchor.MiddleCenter
                if defaultFont then getPosTxt.font = defaultFont end

                local getPosBtn = getPosBtnGo:AddComponent(typeof(Button))
                getPosBtn.onClick:AddListener(function()
                    pcall(function()
                        if _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.serverCoord then
                            local curX = _G.RoleManager.me.serverCoord.x or 0
                            local curY = _G.RoleManager.me.serverCoord.y or 0
                            local coordStr = string.format("%d#%d", curX, curY)
                            _G.Mod_TrainCoord = coordStr
                            trainField.text = coordStr
                            trainTxt.text = coordStr
                            trainTxt.color = Color.white
                            CS.UnityEngine.PlayerPrefs.SetString("Mod_TrainCoord", coordStr)
                            CS.UnityEngine.PlayerPrefs.Save()
                            if _G.FloatingWordUtility then
                                _G.FloatingWordUtility.QuickMsg("Đã lưu tọa độ train: " .. coordStr)
                            end
                        end
                    end)
                end)
            end

            -- TỰ VÀO MAP ẨN Toggle
            local hiddenToggleGo = GameObject("AutoHiddenMapToggle")
            hiddenToggleGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, hiddenToggleGo)
            local htRt = hiddenToggleGo:AddComponent(typeof(RectTransform))
            htRt.anchorMin, htRt.anchorMax, htRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            htRt.anchoredPosition = Vector2(20, -110)
            htRt.sizeDelta = Vector2(200, 32)

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
                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoFarmBoss_EnterHiddenMap",
                        _G.Mod_AutoFarmBoss_EnterHiddenMap and 1 or 0)
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
                UpdateHiddenToggle()
            end)

            -- AUTO HH Toggle (CHỈ CHO ADMIN)
            if _G.Mod_IsAdmin then
                local autoHHGo = GameObject("AutoHHToggle")
                autoHHGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, autoHHGo)
                local hhRt = autoHHGo:AddComponent(typeof(RectTransform))
                hhRt.anchorMin, hhRt.anchorMax, hhRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                hhRt.anchoredPosition = Vector2(230, -110)
                hhRt.sizeDelta = Vector2(220, 32)

                local hhBg = GameObject("Bg")
                hhBg.transform:SetParent(autoHHGo.transform, false)
                local hhBgRt = hhBg:AddComponent(typeof(RectTransform))
                hhBgRt.anchorMin, hhBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                hhBgRt.sizeDelta = Vector2(0, 0)
                local hhBgImg = hhBg:AddComponent(typeof(Image))

                local hhTxtGo = GameObject("Text")
                hhTxtGo.transform:SetParent(autoHHGo.transform, false)
                local hhTxtRt = hhTxtGo:AddComponent(typeof(RectTransform))
                hhTxtRt.anchorMin, hhTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                hhTxtRt.sizeDelta = Vector2(0, 0)
                local hhTxt = hhTxtGo:AddComponent(typeof(Text))
                hhTxt.raycastTarget = false
                hhTxt.fontSize = 15
                hhTxt.alignment = TextAnchor.MiddleCenter
                if defaultFont then hhTxt.font = defaultFont end

                local hhBtn = autoHHGo:AddComponent(typeof(Button))

                local function UpdateAutoHHToggle()
                    if _G.Mod_AutoHH_Enabled then
                        hhBgImg.color = Color(0.2, 0.5, 0.5, 1)
                        hhTxt.text = "AUTO HH: BẬT"
                        hhTxt.color = Color.white
                    else
                        hhBgImg.color = Color(0.3, 0.3, 0.3, 1)
                        hhTxt.text = "AUTO HH: TẮT"
                        hhTxt.color = Color(0.8, 0.8, 0.8, 1)
                    end
                end

                if _G.Mod_AutoHH_Enabled == nil then
                    pcall(function()
                        _G.Mod_AutoHH_Enabled = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoHH_Enabled", 0) == 1)
                    end)
                    if _G.Mod_AutoHH_Enabled == nil then _G.Mod_AutoHH_Enabled = false end
                end
                UpdateAutoHHToggle()

                hhBtn.onClick:AddListener(function()
                    _G.Mod_AutoHH_Enabled = not _G.Mod_AutoHH_Enabled
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoHH_Enabled", _G.Mod_AutoHH_Enabled and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateAutoHHToggle()
                end)
            end

            -- RIGHT 1/3 PANEL - AUTO SMELT / TÁCH ĐỒ UI
            local smeltStartX = 475
            local btnW = 34
            local btnH = 22
            local fontSize = 12

            local title1Go = GameObject("SmeltTitle1")
            title1Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, title1Go)
            local title1Rt = title1Go:AddComponent(typeof(RectTransform))
            title1Rt.anchorMin, title1Rt.anchorMax, title1Rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            title1Rt.anchoredPosition = Vector2(smeltStartX, -70)
            title1Rt.sizeDelta = Vector2(230, 20)
            local title1Txt = title1Go:AddComponent(typeof(Text))
            title1Txt.raycastTarget = false
            title1Txt.text = "TÁCH ĐỒ TRÁC VIỆT"
            title1Txt.color = Color(1, 0.8, 0, 1)
            title1Txt.fontSize = 14
            title1Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then title1Txt.font = defaultFont end

            local function CreateSmeltToggle(label, varName, x, y, width, isKeepGood)
                local btnGo = GameObject("SmeltToggle_" .. varName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(x, y)
                rt.sizeDelta = Vector2(width or btnW, btnH)

                local bg = GameObject("Bg")
                bg.transform:SetParent(btnGo.transform, false)
                local bgRt = bg:AddComponent(typeof(RectTransform))
                bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRt.sizeDelta = Vector2(0, 0)
                local bgImg = bg:AddComponent(typeof(Image))

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.text = label
                txt.fontSize = fontSize
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end

                if _G.Mod_SmeltConfig == nil then _G.Mod_SmeltConfig = {} end
                if _G.Mod_SmeltConfig[varName] == nil then
                    pcall(function() _G.Mod_SmeltConfig[varName] = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_Smelt_" .. varName, 0) == 1) end)
                    if _G.Mod_SmeltConfig[varName] == nil then _G.Mod_SmeltConfig[varName] = false end
                end

                local function UpdateVisual()
                    if _G.Mod_SmeltConfig[varName] then
                        if isKeepGood then
                            bgImg.color = Color(0.8, 0.5, 0.1, 1) -- Cam cho Giữ Dòng Ngon
                        else
                            bgImg.color = Color(0.2, 0.6, 0.2, 1) -- Xanh lục cho Tách Đồ
                        end
                        txt.color = Color.white
                    else
                        bgImg.color = Color(0.25, 0.25, 0.25, 1)
                        txt.color = Color(0.7, 0.7, 0.7, 1)
                    end
                end
                UpdateVisual()

                local btn = btnGo:AddComponent(typeof(Button))
                btn.onClick:AddListener(function()
                    _G.Mod_SmeltConfig[varName] = not _G.Mod_SmeltConfig[varName]
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_Smelt_" .. varName, _G.Mod_SmeltConfig[varName] and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateVisual()
                end)
            end

            local curY = -95
            local function CreateOldRow(lblText, prefix)
                local lblGo = GameObject("SmeltLbl_" .. prefix)
                lblGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, lblGo)
                local lblRt = lblGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(smeltStartX, curY)
                lblRt.sizeDelta = Vector2(85, btnH)
                local lblTxt = lblGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = lblText
                lblTxt.color = Color.white
                lblTxt.fontSize = 12
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end

                CreateSmeltToggle("C6", prefix .. "_C6", smeltStartX + 88, curY, btnW, false)
                CreateSmeltToggle("C7", prefix .. "_C7", smeltStartX + 125, curY, btnW, false)
                CreateSmeltToggle("C8", prefix .. "_C8", smeltStartX + 162, curY, btnW, false)
                curY = curY - 26
            end

            CreateOldRow("NHẪN", "Ring")
            CreateOldRow("DÂY CHUYỀN", "Necklace")
            CreateOldRow("KHUYÊN", "Earring")

            -- 2. VẠCH DASHED NGĂN CÁCH
            curY = curY - 5
            local dashGo = GameObject("SmeltDashLine")
            dashGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, dashGo)
            local dashRt = dashGo:AddComponent(typeof(RectTransform))
            dashRt.anchorMin, dashRt.anchorMax, dashRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            dashRt.anchoredPosition = Vector2(smeltStartX, curY)
            dashRt.sizeDelta = Vector2(230, 15)
            local dashTxt = dashGo:AddComponent(typeof(Text))
            dashTxt.raycastTarget = false
            dashTxt.text = "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"
            dashTxt.color = Color(0.6, 0.6, 0.6, 0.8)
            dashTxt.fontSize = 11
            dashTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then dashTxt.font = defaultFont end

            -- 3. PHẦN 2: TÁCH ĐỒ BỘ & GIỮ DÒNG NGON
            curY = curY - 20
            local title2Go = GameObject("SmeltTitle2")
            title2Go.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, title2Go)
            local title2Rt = title2Go:AddComponent(typeof(RectTransform))
            title2Rt.anchorMin, title2Rt.anchorMax, title2Rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            title2Rt.anchoredPosition = Vector2(smeltStartX, curY)
            title2Rt.sizeDelta = Vector2(230, 20)
            local title2Txt = title2Go:AddComponent(typeof(Text))
            title2Txt.raycastTarget = false
            title2Txt.text = "TÁCH ĐỒ BỘ & DÒNG NGON"
            title2Txt.color = Color(1, 0.8, 0, 1)
            title2Txt.fontSize = 13
            title2Txt.alignment = TextAnchor.MiddleLeft
            if defaultFont then title2Txt.font = defaultFont end

            curY = curY - 25

            local equipRows = {
                { "MŨ", "Hat" },
                { "ÁO", "Armor" },
                { "QUẦN", "Pants" },
                { "BAO TAY", "Gloves" },
                { "BAO CHÂN", "Boots" },
                { "VŨ KHÍ", "Weapon" },
                { "DÂY CHUYỀN", "Necklace2" },
                { "KHUYÊN TRÁI", "EarringL" },
                { "KHUYÊN PHẢI", "EarringR" },
                { "NHẪN TRÁI", "RingL" },
                { "NHẪN PHẢI", "RingR" },
            }

            for _, r in ipairs(equipRows) do
                local label = r[1]
                local prefix = r[2]

                local lblGo = GameObject("SmeltLbl_" .. prefix)
                lblGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, lblGo)
                local lblRt = lblGo:AddComponent(typeof(RectTransform))
                lblRt.anchorMin, lblRt.anchorMax, lblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                lblRt.anchoredPosition = Vector2(smeltStartX, curY)
                lblRt.sizeDelta = Vector2(85, btnH)
                local lblTxt = lblGo:AddComponent(typeof(Text))
                lblTxt.raycastTarget = false
                lblTxt.text = label
                lblTxt.color = Color.white
                lblTxt.fontSize = 11
                lblTxt.alignment = TextAnchor.MiddleLeft
                if defaultFont then lblTxt.font = defaultFont end

                CreateSmeltToggle("C6", prefix .. "_C6", smeltStartX + 88, curY, btnW, false)
                CreateSmeltToggle("C7", prefix .. "_C7", smeltStartX + 125, curY, btnW, false)
                CreateSmeltToggle("C8", prefix .. "_C8", smeltStartX + 162, curY, btnW, false)
                CreateSmeltToggle("C9", prefix .. "_C9", smeltStartX + 199, curY, btnW, false)
                curY = curY - 24
            end

            -- Hàng chọn GIỮ DÒNG NGON (C6 - C9)
            curY = curY - 5
            local kgLblGo = GameObject("SmeltLbl_KeepGood")
            kgLblGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, kgLblGo)
            local kgLblRt = kgLblGo:AddComponent(typeof(RectTransform))
            kgLblRt.anchorMin, kgLblRt.anchorMax, kgLblRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            kgLblRt.anchoredPosition = Vector2(smeltStartX, curY)
            kgLblRt.sizeDelta = Vector2(85, btnH)
            local kgLblTxt = kgLblGo:AddComponent(typeof(Text))
            kgLblTxt.raycastTarget = false
            kgLblTxt.text = "GIỮ DÒNG NGON"
            kgLblTxt.color = Color(1, 0.6, 0.2, 1)
            kgLblTxt.fontSize = 10
            kgLblTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then kgLblTxt.font = defaultFont end

            CreateSmeltToggle("C6", "KeepGood_C6", smeltStartX + 88, curY, btnW, true)
            CreateSmeltToggle("C7", "KeepGood_C7", smeltStartX + 125, curY, btnW, true)
            CreateSmeltToggle("C8", "KeepGood_C8", smeltStartX + 162, curY, btnW, true)
            CreateSmeltToggle("C9", "KeepGood_C9", smeltStartX + 199, curY, btnW, true)

            -- Nút TÁCH NGAY thủ công
            curY = curY - 30
            local manualSmeltBtnGo = GameObject("SmeltManualBtn")
            manualSmeltBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.AutoBossUIList, manualSmeltBtnGo)
            local manualSmeltRt = manualSmeltBtnGo:AddComponent(typeof(RectTransform))
            manualSmeltRt.anchorMin, manualSmeltRt.anchorMax, manualSmeltRt.pivot = Vector2(0, 1), Vector2(0, 1),
                Vector2(0, 1)
            manualSmeltRt.anchoredPosition = Vector2(smeltStartX, curY)
            manualSmeltRt.sizeDelta = Vector2(233, 26)

            local manualSmeltBg = GameObject("Bg")
            manualSmeltBg.transform:SetParent(manualSmeltBtnGo.transform, false)
            local manualSmeltBgRt = manualSmeltBg:AddComponent(typeof(RectTransform))
            manualSmeltBgRt.anchorMin, manualSmeltBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            manualSmeltBgRt.sizeDelta = Vector2(0, 0)
            local manualSmeltBgImg = manualSmeltBg:AddComponent(typeof(Image))
            manualSmeltBgImg.color = Color(0.8, 0.2, 0.2, 1)

            local manualSmeltTxtGo = GameObject("Text")
            manualSmeltTxtGo.transform:SetParent(manualSmeltBtnGo.transform, false)
            local manualSmeltTxtRt = manualSmeltTxtGo:AddComponent(typeof(RectTransform))
            manualSmeltTxtRt.anchorMin, manualSmeltTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            manualSmeltTxtRt.sizeDelta = Vector2(0, 0)
            local manualSmeltTxt = manualSmeltTxtGo:AddComponent(typeof(Text))
            manualSmeltTxt.raycastTarget = false
            manualSmeltTxt.text = "TÁCH NGAY (THỦ CÔNG)"
            manualSmeltTxt.color = Color.white
            manualSmeltTxt.fontSize = 12
            manualSmeltTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then manualSmeltTxt.font = defaultFont end

            local manualSmeltBtn = manualSmeltBtnGo:AddComponent(typeof(Button))
            manualSmeltBtn.onClick:AddListener(function()
                pcall(function()
                    if _G.Mod_PerformSmeltItems then
                        _G.Mod_PerformSmeltItems()
                    elseif _G.Mod_ExecuteAutoSmelt then
                        _G.Mod_ExecuteAutoSmelt()
                    end
                    LogMsg("Đã kích hoạt Tách Đồ thủ công!")
                end)
            end)

            -- SUBTABS [ BOSS C7 ] / [ BOSS C8 ]
            local currentY = -155

            local function CreateTierTab(label, tabName, xPos)
                local btnGo = GameObject("AutoBossTier_" .. tabName)
                btnGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.AutoBossUIList, btnGo)
                local rt = btnGo:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, currentY)
                rt.sizeDelta = Vector2(110, 30)

                local img = btnGo:AddComponent(typeof(Image))
                img.color = Color(1, 1, 1, 0)

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(btnGo.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.sizeDelta = Vector2(0, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 17
                txt.alignment = TextAnchor.MiddleLeft
                if defaultFont then txt.font = defaultFont end

                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, txt = txt, btn = btn }
            end

            local tierC7 = CreateTierTab("[ BOSS C7 ]", "C7", startX)
            local tierC8 = CreateTierTab("[ BOSS C8 ]", "C8", startX + 120)

            currentY = currentY - 35
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
                txt.fontSize = 14
                txt.alignment = TextAnchor.MiddleCenter
                if defaultFont then txt.font = defaultFont end

                local btn = btnGo:AddComponent(typeof(Button))
                return { go = btnGo, rt = rt, img = img, txt = txt, btn = btn }
            end

            local function UpdateTierTabs()
                tierC7.txt.text = "<color=" ..
                    (_G.ModAutoBossConfigTab == "C7" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C7 ]</color>"
                tierC8.txt.text = "<color=" ..
                    (_G.ModAutoBossConfigTab == "C8" and "#00FF00" or "#FFFFFF") .. ">[ BOSS C8 ]</color>"

                -- Hide all config toggles
                for _, btnData in ipairs(configPool) do
                    btnData.go:SetActive(false)
                end

                -- Render the current tier's bosses
                local mapsConfig = _G.ModAutoBossConfigTab == "C7" and _G.Mod_MapsConfig_c7 or _G.Mod_MapsConfig_c8
                local py = gridStartY
                local poolIdx = 1

                for _, mapCfg in ipairs(mapsConfig) do
                    -- Title header
                    local btnData = configPool[poolIdx]
                    if not btnData then
                        btnData = CreateConfigBtn(poolIdx)
                        table.insert(configPool, btnData)
                    end
                    btnData.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                    btnData.rt.anchoredPosition = Vector2(startX, py)
                    btnData.rt.sizeDelta = Vector2(430, 24)

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
                    py = py - 28

                    -- Bosses in 3 columns
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
                            if cfg and not cfg.isExitBtn then
                                local px = startX + (c - 1) * 145
                                local bData = configPool[poolIdx]
                                if not bData then
                                    bData = CreateConfigBtn(poolIdx)
                                    table.insert(configPool, bData)
                                end
                                bData.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                                bData.rt.anchoredPosition = Vector2(px, py)
                                bData.rt.sizeDelta = Vector2(140, 38)
                                bData.txt.alignment = TextAnchor.MiddleCenter

                                -- Load State
                                if _G.Mod_AutoFarmBoss_Config[cfg.id] == nil then
                                    _G.Mod_AutoFarmBoss_Config[cfg.id] = CS.UnityEngine.PlayerPrefs.GetInt(
                                        "Mod_AutoBoss_" .. cfg.id, 0) == 1
                                end

                                local function updateBossBtnColor()
                                    local isTarget = _G.Mod_AutoFarmBoss_Target and
                                        _G.Mod_AutoFarmBoss_Target.cfg.id == cfg.id
                                    local killedCount = (_G.Mod_FarmStats and _G.Mod_FarmStats.bosses and _G.Mod_FarmStats.bosses[cfg.id]) or
                                        0

                                    local nameLabel = cfg.name
                                    if isTarget then
                                        nameLabel = "<color=#FF0000>=> " .. cfg.name .. "</color>"
                                    end

                                    if killedCount > 0 then
                                        if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                            bData.img.color = Color(0.2, 0.5, 0.2, 1)
                                            bData.txt.text = nameLabel ..
                                                "\n<color=#FFFFFF>(" .. killedCount .. ")</color>"
                                        else
                                            bData.img.color = Color(0.3, 0.3, 0.3, 1)
                                            bData.txt.text = nameLabel ..
                                                "\n<color=#777777>(" .. killedCount .. ")</color>"
                                        end
                                    else
                                        if _G.Mod_AutoFarmBoss_Config[cfg.id] then
                                            bData.img.color = Color(0.2, 0.5, 0.2, 1)
                                            bData.txt.text = nameLabel
                                            bData.txt.color = Color.white
                                        else
                                            bData.img.color = Color(0.3, 0.3, 0.3, 1)
                                            bData.txt.text = nameLabel
                                            bData.txt.color = Color(0.7, 0.7, 0.7, 1)
                                        end
                                    end
                                end
                                updateBossBtnColor()

                                bData.btn.onClick:RemoveAllListeners()
                                bData.btn.onClick:AddListener(function()
                                    _G.Mod_AutoFarmBoss_Config[cfg.id] = not _G.Mod_AutoFarmBoss_Config[cfg.id]
                                    CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoBoss_" .. cfg.id,
                                        _G.Mod_AutoFarmBoss_Config[cfg.id] and 1 or 0)
                                    CS.UnityEngine.PlayerPrefs.Save()
                                    updateBossBtnColor()
                                end)

                                poolIdx = poolIdx + 1
                            end
                        end
                        py = py - 42
                    end
                    py = py - 10
                end

                -- BOTTOM FARM STATS BAR
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
                    sTxtRt.anchoredPosition = Vector2(140, 0)
                    sTxtRt.sizeDelta = Vector2(320, 30)
                    local sTxt = statTxtGo:AddComponent(typeof(Text))
                    sTxt.raycastTarget = false
                    sTxt.color = Color(1, 0.8, 0, 1)
                    sTxt.fontSize = 14
                    sTxt.alignment = TextAnchor.MiddleLeft
                    if defaultFont then sTxt.font = defaultFont end
                    _G.Mod_FarmStatsUI.sTxt = sTxt
                end

                _G.Mod_FarmStatsUI.go:SetActive(_G.ModMainTab == "AUTO_BOSS")
                _G.Mod_FarmStatsUI.rt.anchoredPosition = Vector2(startX, py - 10)

                _G.Mod_FarmStats = _G.Mod_FarmStats or { hidden = 0, bosses = {} }
                local totalC7, totalC8 = 0, 0
                for id, count in pairs(_G.Mod_FarmStats.bosses) do
                    local inC7 = false
                    if _G.Mod_MapsConfig_c7 then
                        for _, map in ipairs(_G.Mod_MapsConfig_c7) do
                            if map.bosses then
                                for _, b in ipairs(map.bosses) do
                                    if b.id == id then
                                        inC7 = true; break
                                    end
                                end
                            end
                        end
                    end
                    if inC7 then totalC7 = totalC7 + count else totalC8 = totalC8 + count end
                end
                _G.Mod_FarmStatsUI.sTxt.text = string.format("ẨN: %d  |  C7: %d  |  C8: %d", _G.Mod_FarmStats.hidden,
                    totalC7, totalC8)
            end

            tierC7.btn.onClick:AddListener(function()
                _G.ModAutoBossConfigTab = "C7"
                pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModAutoBossConfigTab", "C7") end)
                UpdateTierTabs()
            end)
            tierC8.btn.onClick:AddListener(function()
                _G.ModAutoBossConfigTab = "C8"
                pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModAutoBossConfigTab", "C8") end)
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
            local currentY = -65
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
            titleRt.sizeDelta = Vector2(250, 25)
            local ChucNangTitleTxt = ChucNangTitle:AddComponent(typeof(Text))
            ChucNangTitleTxt.raycastTarget = false
            ChucNangTitleTxt.text = "[ CHỨC NĂNG HỖ TRỢ ]"
            ChucNangTitleTxt.color = Color(1, 0.8, 0, 1)
            ChucNangTitleTxt.fontSize = 17
            ChucNangTitleTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then ChucNangTitleTxt.font = defaultFont end

            currentY = currentY - 35
            CreateToggle("TIẾP CẬN BOSS THÁP", "Mod_AutoApproachTowerBoss", rightColX2, currentY)
            currentY = currentY - 45

            CreateToggle("HIỆN MÁU KUNDUN", "Mod_ShowKundunHP", rightColX2, currentY)
            currentY = currentY - 45

            CreateToggle("AUTO PK GUILD", "Mod_AutoGuildPK_Enabled", rightColX2, currentY)
            currentY = currentY - 45

            -- Nút Radio Hồi Sinh: HS FREE & HS KC (Chỉ 1 trong 2 được bật)
            local function CreateResurrectRadioGroup(xPos, yPos, btnW)
                btnW = btnW or 125
                local spacing = 10

                if _G.Mod_AutoResurrect_Free_Enabled == nil then
                    pcall(function()
                        _G.Mod_AutoResurrect_Free_Enabled = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoResurrect_Free_Enabled", 0) == 1)
                    end)
                    if _G.Mod_AutoResurrect_Free_Enabled == nil then _G.Mod_AutoResurrect_Free_Enabled = false end
                end

                if _G.Mod_AutoResurrect_Here_Enabled == nil then
                    pcall(function()
                        _G.Mod_AutoResurrect_Here_Enabled = (CS.UnityEngine.PlayerPrefs.GetInt("Mod_AutoResurrect_Here_Enabled", 0) == 1)
                    end)
                    if _G.Mod_AutoResurrect_Here_Enabled == nil then _G.Mod_AutoResurrect_Here_Enabled = false end
                end

                if _G.Mod_AutoResurrect_Free_Enabled and _G.Mod_AutoResurrect_Here_Enabled then
                    _G.Mod_AutoResurrect_Free_Enabled = false
                end

                -- 1. NÚT HS FREE
                local hsFreeGo = GameObject("HS_FREE_RadioToggle")
                hsFreeGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, hsFreeGo)
                local freeRt = hsFreeGo:AddComponent(typeof(RectTransform))
                freeRt.anchorMin, freeRt.anchorMax, freeRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                freeRt.anchoredPosition = Vector2(xPos, yPos)
                freeRt.sizeDelta = Vector2(btnW, 35)

                local freeBg = GameObject("Bg")
                freeBg.transform:SetParent(hsFreeGo.transform, false)
                local freeBgRt = freeBg:AddComponent(typeof(RectTransform))
                freeBgRt.anchorMin, freeBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                freeBgRt.sizeDelta = Vector2(0, 0)
                local freeBgImg = freeBg:AddComponent(typeof(Image))

                local freeTxtGo = GameObject("Text")
                freeTxtGo.transform:SetParent(hsFreeGo.transform, false)
                local freeTxtRt = freeTxtGo:AddComponent(typeof(RectTransform))
                freeTxtRt.anchorMin, freeTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                freeTxtRt.sizeDelta = Vector2(0, 0)
                local freeTxt = freeTxtGo:AddComponent(typeof(Text))
                freeTxt.raycastTarget = false
                freeTxt.text = "HS FREE"
                freeTxt.fontSize = 15
                freeTxt.alignment = TextAnchor.MiddleCenter
                if defaultFont then freeTxt.font = defaultFont end

                local freeBtn = hsFreeGo:AddComponent(typeof(Button))

                -- 2. NÚT HS KC
                local hsKcGo = GameObject("HS_KC_RadioToggle")
                hsKcGo.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, hsKcGo)
                local kcRt = hsKcGo:AddComponent(typeof(RectTransform))
                kcRt.anchorMin, kcRt.anchorMax, kcRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                kcRt.anchoredPosition = Vector2(xPos + btnW + spacing, yPos)
                kcRt.sizeDelta = Vector2(btnW, 35)

                local kcBg = GameObject("Bg")
                kcBg.transform:SetParent(hsKcGo.transform, false)
                local kcBgRt = kcBg:AddComponent(typeof(RectTransform))
                kcBgRt.anchorMin, kcBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                kcBgRt.sizeDelta = Vector2(0, 0)
                local kcBgImg = kcBg:AddComponent(typeof(Image))

                local kcTxtGo = GameObject("Text")
                kcTxtGo.transform:SetParent(hsKcGo.transform, false)
                local kcTxtRt = kcTxtGo:AddComponent(typeof(RectTransform))
                kcTxtRt.anchorMin, kcTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                kcTxtRt.sizeDelta = Vector2(0, 0)
                local kcTxt = kcTxtGo:AddComponent(typeof(Text))
                kcTxt.raycastTarget = false
                kcTxt.text = "HS KC"
                kcTxt.fontSize = 15
                kcTxt.alignment = TextAnchor.MiddleCenter
                if defaultFont then kcTxt.font = defaultFont end

                local kcBtn = hsKcGo:AddComponent(typeof(Button))

                local function UpdateResurrectVisuals()
                    if _G.Mod_AutoResurrect_Free_Enabled then
                        freeBgImg.color = Color(0.2, 0.6, 0.2, 1)
                        freeTxt.color = Color.white
                    else
                        freeBgImg.color = Color(0.3, 0.3, 0.3, 1)
                        freeTxt.color = Color(0.8, 0.8, 0.8, 1)
                    end

                    if _G.Mod_AutoResurrect_Here_Enabled then
                        kcBgImg.color = Color(0.2, 0.6, 0.2, 1)
                        kcTxt.color = Color.white
                    else
                        kcBgImg.color = Color(0.3, 0.3, 0.3, 1)
                        kcTxt.color = Color(0.8, 0.8, 0.8, 1)
                    end
                end
                UpdateResurrectVisuals()

                freeBtn.onClick:AddListener(function()
                    if not _G.Mod_AutoResurrect_Free_Enabled then
                        _G.Mod_AutoResurrect_Free_Enabled = true
                        _G.Mod_AutoResurrect_Here_Enabled = false
                    else
                        _G.Mod_AutoResurrect_Free_Enabled = false
                    end

                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoResurrect_Free_Enabled", _G.Mod_AutoResurrect_Free_Enabled and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoResurrect_Here_Enabled", _G.Mod_AutoResurrect_Here_Enabled and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateResurrectVisuals()
                end)

                kcBtn.onClick:AddListener(function()
                    if not _G.Mod_AutoResurrect_Here_Enabled then
                        _G.Mod_AutoResurrect_Here_Enabled = true
                        _G.Mod_AutoResurrect_Free_Enabled = false
                    else
                        _G.Mod_AutoResurrect_Here_Enabled = false
                    end

                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoResurrect_Free_Enabled", _G.Mod_AutoResurrect_Free_Enabled and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.SetInt("Mod_AutoResurrect_Here_Enabled", _G.Mod_AutoResurrect_Here_Enabled and 1 or 0)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateResurrectVisuals()
                end)
            end

            CreateResurrectRadioGroup(rightColX2, currentY, 125)
            currentY = currentY - 45

            -- Cài đặt DELAY QUÉT PK
            local function CreatePKDelayControl(xPos, yPos)
                local go = GameObject("Mod_PKScanDelay_Control")
                go.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, go)

                local rt = go:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, yPos)
                rt.sizeDelta = Vector2(260, 35)

                local bg = GameObject("Bg")
                bg.transform:SetParent(go.transform, false)
                local bgRt = bg:AddComponent(typeof(RectTransform))
                bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRt.sizeDelta = Vector2(0, 0)
                local bgImg = bg:AddComponent(typeof(Image))
                bgImg.color = Color(0.2, 0.2, 0.2, 1)

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(go.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.offsetMin, txtRt.offsetMax = Vector2(6, 0), Vector2(-88, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 13
                txt.alignment = TextAnchor.MiddleLeft
                txt.color = Color.white
                if defaultFont then txt.font = defaultFont end

                if _G.Mod_PKScanDelay == nil then
                    pcall(function() _G.Mod_PKScanDelay = CS.UnityEngine.PlayerPrefs.GetFloat("Mod_PKScanDelay", 0.8) end)
                end
                if not _G.Mod_PKScanDelay or _G.Mod_PKScanDelay < 0.1 then
                    _G.Mod_PKScanDelay = 0.8
                end

                local function UpdateLabel()
                    txt.text = string.format("DELAY QUÉT PK: %.1fs", _G.Mod_PKScanDelay or 0.8)
                end
                UpdateLabel()

                local function createBtn(name, offsetX, width, btnText, btnColor)
                    local btnGo = GameObject(name)
                    btnGo.transform:SetParent(go.transform, false)
                    table.insert(_G.NangCaoUIList, btnGo)
                    local bRt = btnGo:AddComponent(typeof(RectTransform))
                    bRt.anchorMin, bRt.anchorMax, bRt.pivot = Vector2(1, 0.5), Vector2(1, 0.5), Vector2(1, 0.5)
                    bRt.anchoredPosition = Vector2(offsetX, 0)
                    bRt.sizeDelta = Vector2(width, 28)
                    local bImg = btnGo:AddComponent(typeof(Image))
                    bImg.color = btnColor

                    local bTxtGo = GameObject("Text")
                    bTxtGo.transform:SetParent(btnGo.transform, false)
                    local bTxtRt = bTxtGo:AddComponent(typeof(RectTransform))
                    bTxtRt.anchorMin, bTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                    bTxtRt.sizeDelta = Vector2(0, 0)
                    local bTxt = bTxtGo:AddComponent(typeof(Text))
                    bTxt.raycastTarget = false
                    bTxt.text = btnText
                    bTxt.color = Color.white
                    bTxt.fontSize = 15
                    bTxt.alignment = TextAnchor.MiddleCenter
                    if defaultFont then bTxt.font = defaultFont end

                    return btnGo:AddComponent(typeof(Button))
                end

                local mBtn = createBtn("MinusBtn", -45, 40, "-0.1", Color(0.5, 0.2, 0.2, 1))
                local pBtn = createBtn("PlusBtn", -2, 40, "+0.1", Color(0.2, 0.5, 0.2, 1))

                mBtn.onClick:AddListener(function()
                    _G.Mod_PKScanDelay = math.max(0.1, math.floor(((_G.Mod_PKScanDelay or 0.3) - 0.1) * 10 + 0.5) / 10)
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetFloat("Mod_PKScanDelay", _G.Mod_PKScanDelay)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateLabel()
                end)

                pBtn.onClick:AddListener(function()
                    _G.Mod_PKScanDelay = math.min(5.0, math.floor(((_G.Mod_PKScanDelay or 0.3) + 0.1) * 10 + 0.5) / 10)
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetFloat("Mod_PKScanDelay", _G.Mod_PKScanDelay)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateLabel()
                end)
            end

            CreatePKDelayControl(rightColX2, currentY)
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

            local lockField = lockTgtGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
            lockField.textComponent = lockTxt
            lockField.text = _G.Mod_LockTarget_Name

            lockField.onValueChanged:AddListener(function(val)
                _G.Mod_LockTarget_Name = val
                pcall(function()
                    CS.UnityEngine.PlayerPrefs.SetString("Mod_LockTarget_Name", val)
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
            end)

            currentY = currentY - 45
            CreateToggle("TỰ QUAY LẠI X#Y", "Mod_AutoReturnPos_Enabled", rightColX2, currentY)
            currentY = currentY - 40

            -- Cài đặt DELAY QUAY LẠI
            local function CreateReturnPosDelayControl(xPos, yPos)
                local go = GameObject("Mod_ReturnPosDelay_Control")
                go.transform:SetParent(panelGo.transform, false)
                table.insert(_G.NangCaoUIList, go)

                local rt = go:AddComponent(typeof(RectTransform))
                rt.anchorMin, rt.anchorMax, rt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
                rt.anchoredPosition = Vector2(xPos, yPos)
                rt.sizeDelta = Vector2(260, 35)

                local bg = GameObject("Bg")
                bg.transform:SetParent(go.transform, false)
                local bgRt = bg:AddComponent(typeof(RectTransform))
                bgRt.anchorMin, bgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                bgRt.sizeDelta = Vector2(0, 0)
                local bgImg = bg:AddComponent(typeof(Image))
                bgImg.color = Color(0.2, 0.2, 0.2, 1)

                local txtGo = GameObject("Text")
                txtGo.transform:SetParent(go.transform, false)
                local txtRt = txtGo:AddComponent(typeof(RectTransform))
                txtRt.anchorMin, txtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                txtRt.offsetMin, txtRt.offsetMax = Vector2(6, 0), Vector2(-88, 0)
                local txt = txtGo:AddComponent(typeof(Text))
                txt.raycastTarget = false
                txt.fontSize = 13
                txt.alignment = TextAnchor.MiddleLeft
                txt.color = Color.white
                if defaultFont then txt.font = defaultFont end

                if _G.Mod_AutoReturnPosDelay == nil then
                    pcall(function()
                        _G.Mod_AutoReturnPosDelay = CS.UnityEngine.PlayerPrefs.GetFloat(
                            "Mod_AutoReturnPosDelay", 1.0)
                    end)
                end
                if not _G.Mod_AutoReturnPosDelay or _G.Mod_AutoReturnPosDelay < 0.1 then
                    _G.Mod_AutoReturnPosDelay = 1.0
                end

                local function UpdateLabel()
                    txt.text = string.format("DELAY QUAY LẠI: %.1fs", _G.Mod_AutoReturnPosDelay or 1.0)
                end
                UpdateLabel()

                local function createBtn(name, offsetX, width, btnText, btnColor)
                    local btnGo = GameObject(name)
                    btnGo.transform:SetParent(go.transform, false)
                    table.insert(_G.NangCaoUIList, btnGo)
                    local bRt = btnGo:AddComponent(typeof(RectTransform))
                    bRt.anchorMin, bRt.anchorMax, bRt.pivot = Vector2(1, 0.5), Vector2(1, 0.5), Vector2(1, 0.5)
                    bRt.anchoredPosition = Vector2(offsetX, 0)
                    bRt.sizeDelta = Vector2(width, 28)
                    local bImg = btnGo:AddComponent(typeof(Image))
                    bImg.color = btnColor

                    local bTxtGo = GameObject("Text")
                    bTxtGo.transform:SetParent(btnGo.transform, false)
                    local bTxtRt = bTxtGo:AddComponent(typeof(RectTransform))
                    bTxtRt.anchorMin, bTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                    bTxtRt.sizeDelta = Vector2(0, 0)
                    local bTxt = bTxtGo:AddComponent(typeof(Text))
                    bTxt.raycastTarget = false
                    bTxt.text = btnText
                    bTxt.color = Color.white
                    bTxt.fontSize = 15
                    bTxt.alignment = TextAnchor.MiddleCenter
                    if defaultFont then bTxt.font = defaultFont end

                    return btnGo:AddComponent(typeof(Button))
                end

                local mBtn = createBtn("MinusBtn", -45, 40, "-0.1", Color(0.5, 0.2, 0.2, 1))
                local pBtn = createBtn("PlusBtn", -2, 40, "+0.1", Color(0.2, 0.5, 0.2, 1))

                mBtn.onClick:AddListener(function()
                    _G.Mod_AutoReturnPosDelay = math.max(0.1,
                        math.floor(((_G.Mod_AutoReturnPosDelay or 1.0) - 0.1) * 10 + 0.5) / 10)
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetFloat("Mod_AutoReturnPosDelay", _G.Mod_AutoReturnPosDelay)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateLabel()
                end)

                pBtn.onClick:AddListener(function()
                    _G.Mod_AutoReturnPosDelay = math.min(10.0,
                        math.floor(((_G.Mod_AutoReturnPosDelay or 1.0) + 0.1) * 10 + 0.5) / 10)
                    pcall(function()
                        CS.UnityEngine.PlayerPrefs.SetFloat("Mod_AutoReturnPosDelay", _G.Mod_AutoReturnPosDelay)
                        CS.UnityEngine.PlayerPrefs.Save()
                    end)
                    UpdateLabel()
                end)
            end

            CreateReturnPosDelayControl(rightColX2, currentY)
            currentY = currentY - 45

            -- Nút LẤY VỊ TRÍ (Đưa lên trước ô nhập tọa độ, width = 140px, ở bên trái)
            local getReturnPosBtnGo = GameObject("GetReturnPosBtn")
            getReturnPosBtnGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, getReturnPosBtnGo)
            local getReturnPosRt = getReturnPosBtnGo:AddComponent(typeof(RectTransform))
            getReturnPosRt.anchorMin, getReturnPosRt.anchorMax, getReturnPosRt.pivot = Vector2(0, 1), Vector2(0, 1),
                Vector2(0, 1)
            getReturnPosRt.anchoredPosition = Vector2(rightColX2, currentY)
            getReturnPosRt.sizeDelta = Vector2(140, 30)

            local getReturnPosBg = GameObject("Bg")
            getReturnPosBg.transform:SetParent(getReturnPosBtnGo.transform, false)
            local getReturnPosBgRt = getReturnPosBg:AddComponent(typeof(RectTransform))
            getReturnPosBgRt.anchorMin, getReturnPosBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            getReturnPosBgRt.sizeDelta = Vector2(0, 0)
            local getReturnPosBgImg = getReturnPosBg:AddComponent(typeof(Image))
            getReturnPosBgImg.color = Color(0.2, 0.5, 0.7, 1)

            local getReturnPosTxtGo = GameObject("Text")
            getReturnPosTxtGo.transform:SetParent(getReturnPosBtnGo.transform, false)
            local getReturnPosTxtRt = getReturnPosTxtGo:AddComponent(typeof(RectTransform))
            getReturnPosTxtRt.anchorMin, getReturnPosTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            getReturnPosTxtRt.sizeDelta = Vector2(0, 0)
            local getReturnPosTxt = getReturnPosTxtGo:AddComponent(typeof(Text))
            getReturnPosTxt.raycastTarget = false
            getReturnPosTxt.text = "LẤY VỊ TRÍ"
            getReturnPosTxt.color = Color.white
            getReturnPosTxt.fontSize = 15
            getReturnPosTxt.alignment = TextAnchor.MiddleCenter
            if defaultFont then getReturnPosTxt.font = defaultFont end

            -- InputField Tọa độ AutoReturnPosInput (width = 115px, ở bên phải)
            local retTgtGo = GameObject("AutoReturnPosInput")
            retTgtGo.transform:SetParent(panelGo.transform, false)
            table.insert(_G.NangCaoUIList, retTgtGo)
            local retRt = retTgtGo:AddComponent(typeof(RectTransform))
            retRt.anchorMin, retRt.anchorMax, retRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            retRt.anchoredPosition = Vector2(rightColX2 + 145, currentY)
            retRt.sizeDelta = Vector2(115, 30)

            local retBg = GameObject("Bg")
            retBg.transform:SetParent(retTgtGo.transform, false)
            local retBgRt = retBg:AddComponent(typeof(RectTransform))
            retBgRt.anchorMin, retBgRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            retBgRt.sizeDelta = Vector2(0, 0)
            local retImg = retBg:AddComponent(typeof(Image))
            retImg.color = Color(0.1, 0.1, 0.1, 1)

            local retTxtGo = GameObject("Text")
            retTxtGo.transform:SetParent(retTgtGo.transform, false)
            local retTxtRt = retTxtGo:AddComponent(typeof(RectTransform))
            retTxtRt.anchorMin, retTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            retTxtRt.offsetMin, retTxtRt.offsetMax = Vector2(5, 0), Vector2(-5, 0)
            local retTxt = retTxtGo:AddComponent(typeof(Text))

            if _G.Mod_AutoReturnPos_Coords == nil then
                _G.Mod_AutoReturnPos_Coords = CS.UnityEngine.PlayerPrefs.GetString("Mod_AutoReturnPos_Coords", "")
            end

            retTxt.text = _G.Mod_AutoReturnPos_Coords
            retTxt.color, retTxt.fontSize = Color.white, 15
            retTxt.alignment = TextAnchor.MiddleLeft
            if defaultFont then retTxt.font = defaultFont end

            local retField = retTgtGo:AddComponent(typeof(CS.UnityEngine.UI.InputField))
            retField.textComponent = retTxt
            retField.text = _G.Mod_AutoReturnPos_Coords

            retField.onValueChanged:AddListener(function(val)
                _G.Mod_AutoReturnPos_Coords = val
                pcall(function()
                    CS.UnityEngine.PlayerPrefs.SetString("Mod_AutoReturnPos_Coords", val)
                    CS.UnityEngine.PlayerPrefs.Save()
                end)
            end)

            local getReturnPosBtn = getReturnPosBtnGo:AddComponent(typeof(Button))
            getReturnPosBtn.onClick:AddListener(function()
                pcall(function()
                    if _G.RoleManager and _G.RoleManager.me then
                        local me = _G.RoleManager.me
                        local curX = me.serverCoord and me.serverCoord.x or (me.cellPos and me.cellPos.x) or 0
                        local curY = me.serverCoord and me.serverCoord.y or (me.cellPos and me.cellPos.y) or 0
                        if curX > 0 and curY > 0 then
                            local coordStr = string.format("%d#%d", curX, curY)
                            _G.Mod_AutoReturnPos_Coords = coordStr
                            retField.text = coordStr
                            retTxt.text = coordStr
                            CS.UnityEngine.PlayerPrefs.SetString("Mod_AutoReturnPos_Coords", coordStr)
                            CS.UnityEngine.PlayerPrefs.Save()
                            if _G.FloatingWordUtility then
                                _G.FloatingWordUtility.QuickMsg("Đã lấy vị trí quay lại: " .. coordStr)
                            end
                        end
                    end
                end)
            end)

            currentY = currentY - 45
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
                local args = { ... }
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
                    local r, b = '', x:byte()
                    for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
                    return r;
                end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                    if (#x < 6) then return '' end
                    local c = 0
                    for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
                    return b64chars:sub(c + 1, c + 1)
                end) .. ({ '', '==', '=' })[#data % 3 + 1])
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
            eTxtRt.anchorMin, eTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            eTxtRt.offsetMin, eTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
            pTxtRt.anchorMin, pTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            pTxtRt.offsetMin, pTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
                tRt.anchorMin, tRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
                tRt.offsetMin, tRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
            gTxtRt.anchorMin, gTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            gTxtRt.offsetMin, gTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
            ctTxtRt.anchorMin, ctTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            ctTxtRt.offsetMin, ctTxtRt.offsetMax = Vector2(0, 0), Vector2(0, 0)
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
        local width = isAd and 160 or 220

        local tabCoBanGo = GameObject("TabCoBanBtn")
        tabCoBanGo.transform:SetParent(panelGo.transform, false)
        local tabCoBanRt = tabCoBanGo:AddComponent(typeof(RectTransform))
        tabCoBanRt.anchorMin, tabCoBanRt.anchorMax, tabCoBanRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
        tabCoBanRt.anchoredPosition = Vector2(20, -10)
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
        tabNangCaoRt.anchoredPosition = Vector2(20 + width + 10, -10)
        tabNangCaoRt.sizeDelta = Vector2(width, 40)
        local tabNangCaoImg = tabNangCaoGo:AddComponent(typeof(Image))

        local tabNangCaoTxtGo = GameObject("Text")
        tabNangCaoTxtGo.transform:SetParent(tabNangCaoGo.transform, false)
        local tabNangCaoTxtRt = tabNangCaoTxtGo:AddComponent(typeof(RectTransform))
        tabNangCaoTxtRt.anchorMin, tabNangCaoTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
        tabNangCaoTxtRt.sizeDelta = Vector2(0, 0)
        local tabNangCaoTxt = tabNangCaoTxtGo:AddComponent(typeof(Text))
        tabNangCaoTxt.raycastTarget, tabNangCaoTxt.fontSize, tabNangCaoTxt.alignment = false, 20, TextAnchor
            .MiddleCenter
        if defaultFont then tabNangCaoTxt.font = defaultFont end
        local tabNangCaoBtn = tabNangCaoGo:AddComponent(typeof(Button))

        local tabAutoBossGo, tabAutoBossImg, tabAutoBossTxt, tabAutoBossBtn
        if true then
            tabAutoBossGo = GameObject("TabAutoBossBtn")
            tabAutoBossGo.transform:SetParent(panelGo.transform, false)
            local tabAutoBossRt = tabAutoBossGo:AddComponent(typeof(RectTransform))
            tabAutoBossRt.anchorMin, tabAutoBossRt.anchorMax, tabAutoBossRt.pivot = Vector2(0, 1), Vector2(0, 1),
                Vector2(0, 1)
            tabAutoBossRt.anchoredPosition = Vector2(20 + (width + 10) * 2, -10)
            tabAutoBossRt.sizeDelta = Vector2(width, 40)
            tabAutoBossImg = tabAutoBossGo:AddComponent(typeof(Image))

            local tabAutoBossTxtGo = GameObject("Text")
            tabAutoBossTxtGo.transform:SetParent(tabAutoBossGo.transform, false)
            local tabAutoBossTxtRt = tabAutoBossTxtGo:AddComponent(typeof(RectTransform))
            tabAutoBossTxtRt.anchorMin, tabAutoBossTxtRt.anchorMax = Vector2(0, 0), Vector2(1, 1)
            tabAutoBossTxtRt.sizeDelta = Vector2(0, 0)
            tabAutoBossTxt = tabAutoBossTxtGo:AddComponent(typeof(Text))
            tabAutoBossTxt.raycastTarget, tabAutoBossTxt.fontSize, tabAutoBossTxt.alignment = false, 20,
                TextAnchor.MiddleCenter
            if defaultFont then tabAutoBossTxt.font = defaultFont end
            tabAutoBossBtn = tabAutoBossGo:AddComponent(typeof(Button))
        end

        local tabAdminGo, tabAdminImg, tabAdminTxt, tabAdminBtn
        if isAd then
            tabAdminGo = GameObject("TabAdminBtn")
            tabAdminGo.transform:SetParent(panelGo.transform, false)
            local tabAdminRt = tabAdminGo:AddComponent(typeof(RectTransform))
            tabAdminRt.anchorMin, tabAdminRt.anchorMax, tabAdminRt.pivot = Vector2(0, 1), Vector2(0, 1), Vector2(0, 1)
            tabAdminRt.anchoredPosition = Vector2(20 + (width + 10) * 3, -10)
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

        if isAd then
            tabAdminBtn.onClick:AddListener(function()
                _G.ModMainTab = "ADMIN"
                pcall(function() CS.UnityEngine.PlayerPrefs.SetString("ModMainTab", _G.ModMainTab) end)
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
        _G.Mod_PickedItems = _G.Mod_PickedItems or {}

        if _G.PickupManager then
            local original_RemoveDropSceneCellPos = _G.PickupManager.RemoveDropSceneCellPos
            _G.PickupManager.RemoveDropSceneCellPos = function(dropItemData)
                if original_RemoveDropSceneCellPos then
                    original_RemoveDropSceneCellPos(dropItemData)
                end
                if dropItemData and dropItemData.id then
                    if _G.Mod_ActiveSpamItems then
                        _G.Mod_ActiveSpamItems[dropItemData.id] = nil
                    end
                end
            end

            local function ExecutePickupCommon(dropItemData, startTime, interceptTime, logPrefix)
                local scopeVal = 0
                if _G.QiJiHelperData and _G.QiJiHelperData.SettingData then
                    scopeVal = tonumber(_G.QiJiHelperData.SettingData.KillMonsterScope) or 0
                end
                local pickLimit = tonumber(_G.AutoPick_Limit) or 0
                local isSecretTrickActive = (scopeVal == 11 and pickLimit == 11) or (scopeVal == 7 and pickLimit == 7)

                local eType = dropItemData.type
                local isRune = (eType == 19 or eType == 28)
                local isBone = (eType == 24 or eType == 26)

                local nowTime = CS.UnityEngine.Time.realtimeSinceStartup
                if (nowTime - (_G.Mod_LastItemBatchTime or 0)) > 2.0 then
                    _G.Mod_PickupItemIndex = 0
                end
                _G.Mod_LastItemBatchTime = nowTime
                _G.Mod_PickupItemIndex = (_G.Mod_PickupItemIndex or 0) + 1
                local N = _G.Mod_PickupItemIndex

                local delayMs = 0
                if isRune or logPrefix == "KTĐ" or isSecretTrickActive then
                    delayMs = 0
                elseif isBone then
                    local minDelay = N * 100
                    local maxDelay = N * 100 + 800
                    delayMs = math.random(minDelay, maxDelay)
                end

                local delaySec = delayMs / 1000.0

                if _G.AutoPick_Mode == nil then
                    _G.AutoPick_Mode = CS.UnityEngine.PlayerPrefs.GetInt("AutoPick_Mode", 1)
                    if _G.AutoPick_Mode ~= 1 and _G.AutoPick_Mode ~= 2 then
                        _G.AutoPick_Mode = 1
                    end
                end

                if _G.AutoPick_Mode == 1 then
                    -- PA NHẶT 1 (Rollback instant + 0ms packet + spam loop)
                    local function ExecutePickup()
                        -- 1. Chạy tới vị trí vật phẩm ngay lập tức
                        if _G.RoleManager and _G.RoleManager.me and dropItemData.x and dropItemData.y then
                            pcall(function()
                                _G.RoleManager.me:MoveTo({ x = dropItemData.x, y = dropItemData.y })
                            end)
                        end

                        -- 2. Bắn gói tin nhặt LẬP TỨC 0ms
                        if _G.PickupManager then
                            _G.PickupManager.ReqPickUpMapItem(dropItemData.id)
                        end

                        -- 3. Đưa vào Hàng Đợi Duy Trì Spam (dùng chung Vòng Lặp Mẹ)
                        _G.Mod_ActiveSpamItems = _G.Mod_ActiveSpamItems or {}
                        _G.Mod_ActiveSpamItems[dropItemData.id] = {
                            id = dropItemData.id,
                            x = dropItemData.x,
                            y = dropItemData.y,
                            expireTime = CS.UnityEngine.Time.realtimeSinceStartup + 4.0
                        }

                        local costMs = math.floor((CS.UnityEngine.Time.realtimeSinceStartup - startTime) * 1000)
                        local itemTypeId = dropItemData.item and dropItemData.item.itemId or dropItemData.configId or
                            "???"
                        local objId = dropItemData.id or "???"
                        if _G.WriteLog then
                            _G.WriteLog(string.format(
                                "[%s] Nhặt PA1 (Nhận tin lúc %s | Delay %d ms | Xử lý %d ms): TypeID=%s, ObjID=%s | MoveTo X=%s, Y=%s",
                                logPrefix, tostring(interceptTime), delayMs, costMs, tostring(itemTypeId),
                                tostring(objId), tostring(dropItemData.x), tostring(dropItemData.y)))
                        end
                    end

                    if delaySec > 0 and _G.Timer and _G.Timer.StartLoop then
                        local hasFired = false
                        _G.Timer.StartLoop(delaySec, 1, function()
                            if not hasFired then
                                hasFired = true
                                ExecutePickup()
                            end
                        end)
                    else
                        ExecutePickup()
                    end
                else
                    -- PA NHẶT 2 (Phương án hiện tại với 0.1s delay throttle)
                    local scheduledTime = nowTime + delaySec
                    local expireTime = scheduledTime + 5.0

                    _G.Mod_ActiveSpamItems = _G.Mod_ActiveSpamItems or {}
                    _G.Mod_ActiveSpamItems[dropItemData.id] = {
                        id = dropItemData.id,
                        x = dropItemData.x,
                        y = dropItemData.y,
                        startTime = scheduledTime,
                        expireTime = expireTime,
                        lastSpamTime = 0,
                        isTrick = isSecretTrickActive
                    }

                    local costMs = math.floor((CS.UnityEngine.Time.realtimeSinceStartup - startTime) * 1000)
                    local itemTypeId = dropItemData.item and dropItemData.item.itemId or dropItemData.configId or "???"
                    local objId = dropItemData.id or "???"
                    if _G.WriteLog then
                        local modeStr = (delayMs == 0) and "TRICK/RUNE 0ms" or string.format("BONE DELAY %dms", delayMs)
                        _G.WriteLog(string.format(
                            "[%s] Nhặt PA2 [%s] (Nhận tin lúc %s | Delay %d ms | Xử lý trong %d ms): TypeID=%s, ObjID=%s | Pos X=%s, Y=%s",
                            logPrefix, modeStr, tostring(interceptTime), delayMs, costMs, tostring(itemTypeId),
                            tostring(objId), tostring(dropItemData.x), tostring(dropItemData.y)))
                    end
                end
            end
            _G.ExecutePickupCommon = ExecutePickupCommon

            local original_AddDropSceneCellPos = _G.PickupManager.AddDropSceneCellPos
            _G.PickupManager.AddDropSceneCellPos = function(item)
                local startTime = CS.UnityEngine.Time.realtimeSinceStartup
                local interceptTime = os.date("%H:%M:%S")
                original_AddDropSceneCellPos(item)

                if not (item and item.data) then return end
                local dropItemData = item.data

                if _G.Mod_AutoPK_Enabled then
                    local mapId = 0
                    if _G.SceneData and _G.SceneData.mapId then
                        mapId = _G.SceneData.mapId
                    elseif _G.RoleManager and _G.RoleManager.me and _G.RoleManager.me.mapId then
                        mapId = _G.RoleManager.me.mapId
                    end

                    if mapId == 1077 then
                        ExecutePickupCommon(dropItemData, startTime, interceptTime, "KTĐ")
                    end
                end

                if _G.AutoPick_Enabled then
                    local eType = dropItemData.type
                    local isRune = (eType == 19 or eType == 28)
                    local isBone = (eType == 24 or eType == 26)

                    local shouldPick = false
                    if isRune then
                        local confId = (dropItemData.item and dropItemData.item.itemId) or dropItemData.configId
                        local rLevel = confId % 10
                        local rColor = 0

                        local cfg = nil
                        if _G.ClientTable and _G.ClientTable.cfg_Item_itemManager then
                            cfg = _G.ClientTable.cfg_Item_itemManager:TryGetValue(confId)
                        end
                        if not cfg and _G.ClientTable and _G.ClientTable.cfg_Item_equipManager then
                            cfg = _G.ClientTable.cfg_Item_equipManager:TryGetValue(confId)
                        end

                        if cfg and cfg.subType then
                            if cfg.type == 19 then
                                rColor = math.floor(cfg.subType / 1000)
                            elseif cfg.type == 28 then
                                local lastDigit = cfg.subType % 10
                                if lastDigit == 1 then
                                    rColor = 3 -- Đỏ
                                elseif lastDigit == 2 then
                                    rColor = 2 -- Lam
                                elseif lastDigit == 3 then
                                    rColor = 1 -- Lục
                                end
                            end
                        end

                        local lvKey = "L5L"
                        if rLevel == 5 then
                            lvKey = "L5"
                        elseif rLevel == 6 then
                            lvKey = "L6"
                        elseif rLevel == 7 then
                            lvKey = "L7"
                        elseif rLevel > 7 then
                            lvKey = "L7M"
                        end

                        local clrKey = "Luc"
                        if rColor == 2 then
                            clrKey = "Lam"
                        elseif rColor >= 3 then
                            clrKey = "Do"
                        end

                        local prefKey = "AutoPick_Rune_" .. lvKey .. "_" .. clrKey
                        if _G[prefKey] == true then shouldPick = true end
                    end
                    if isBone then shouldPick = true end

                    if shouldPick then
                        local isAlreadyPicked = _G.Mod_PickedItems[dropItemData.id]
                        if not isAlreadyPicked and ((_G.AutoPick_Count or 0) < _G.AutoPick_Limit) then
                            _G.Mod_PickedItems[dropItemData.id] = true
                            _G.AutoPick_Count = (_G.AutoPick_Count or 0) + 1
                            ExecutePickupCommon(dropItemData, startTime, interceptTime, "AutoLoot")
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

        if _G.NoticeController and not _G.Mod_HookedNoticeAnnounce then
            _G.Mod_HookedNoticeAnnounce = true
            local orig_ResAnnounce = _G.NoticeController.ResAnnounce
            _G.NoticeController.ResAnnounce = function(eventId, data)
                pcall(function()
                    if _G.Mod_AnStats_Enabled and data and data.parameter then
                        local paramStr = table.concat(data.parameter, " ")
                        local textWithoutColorA = string.gsub(paramStr, "<color=#ffffff00>a</color>", " ")
                        local cleanText = string.gsub(textWithoutColorA, "<[^>]+>", "")
                        cleanText = string.gsub(cleanText, "%s+", " ")

                        if string.find(cleanText, "Kỵ Sĩ") and not string.find(cleanText, "Đất Sét") then
                            local playerName = string.match(cleanText, "%]%s*([^%s]+)%s+trong")
                            if not playerName or playerName == "" then
                                playerName = string.match(cleanText, "([^%s]+)%s+trong%s+Bản")
                            end
                            if not playerName or playerName == "" then
                                playerName = string.match(cleanText, "([^%s]+)%s+trong")
                            end

                            if playerName and playerName ~= "" then
                                if not _G.Mod_AnStats then
                                    if _G.Mod_LoadAnStats then _G.Mod_LoadAnStats() end
                                end

                                local todayStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd")
                                if _G.Mod_AnStatsDate ~= todayStr then
                                    _G.Mod_AnStatsDate = todayStr
                                    _G.Mod_AnStats = {}
                                end

                                _G.Mod_AnStats[playerName] = (_G.Mod_AnStats[playerName] or 0) + 1

                                if _G.Mod_SaveAnStats then _G.Mod_SaveAnStats() end

                                if _G.FloatingWordUtility then
                                    _G.FloatingWordUtility.QuickMsg(string.format("TỔNG HỢP ẨN: %s (+1) -> Tổng: %d",
                                        playerName, _G.Mod_AnStats[playerName]))
                                end

                                if _G.WriteLog then
                                    _G.WriteLog(string.format("[AnStats] Detected Ky Si: %s (Total: %d)", playerName,
                                        _G.Mod_AnStats[playerName]))
                                end

                                if _G.Mod_SendAnStatsTelegram then
                                    _G.Mod_SendAnStatsTelegram()
                                end
                            end
                        end
                    end
                end)
                if orig_ResAnnounce then orig_ResAnnounce(eventId, data) end
            end
        end

        if _G.ChatData and not _G.Mod_HookedChatDataAddMessage then
            _G.Mod_HookedChatDataAddMessage = true
            local orig_AddMessage = _G.ChatData.AddMessage
            _G.ChatData.AddMessage = function(channel, message)
                pcall(function()
                    if _G.Mod_AnStats_Enabled then
                        local rawText = ""
                        if message then
                            if type(message.chatMsg) == "table" and message.chatMsg.message then
                                rawText = tostring(message.chatMsg.message)
                            elseif type(message.chatMsg) == "string" then
                                rawText = tostring(message.chatMsg)
                            elseif message.message then
                                rawText = tostring(message.message)
                            elseif message.content then
                                rawText = tostring(message.content)
                            end
                        end

                        if rawText and rawText ~= "" then
                            -- 1. Xử lý thẻ màu ẩn <color=#ffffff00>a</color> -> space
                            local textWithoutColorA = string.gsub(rawText, "<color=#ffffff00>a</color>", " ")
                            -- 2. Lọc sạch thẻ màu HTML
                            local cleanText = string.gsub(textWithoutColorA, "<[^>]+>", "")
                            -- 3. Chuẩn hóa khoảng trắng kép/nhiều khoảng trắng thành 1 khoảng trắng
                            cleanText = string.gsub(cleanText, "%s+", " ")

                            local isSystemText = string.find(cleanText, "Hệ thống") or
                                string.find(cleanText, "%[Hệ thống%]") or string.find(cleanText, "Bản đồ ẩn")

                            if isSystemText or channel == 8 or (_G.ChatChannelEnum and channel == _G.ChatChannelEnum.SYSTEM) then
                                if string.find(cleanText, "Kỵ Sĩ") and not string.find(cleanText, "Đất Sét") then
                                    local playerName = string.match(cleanText, "%]%s*([^%s]+)%s+trong")
                                    if not playerName or playerName == "" then
                                        playerName = string.match(cleanText, "([^%s]+)%s+trong%s+Bản đồ ẩn")
                                    end
                                    if not playerName or playerName == "" then
                                        playerName = string.match(cleanText, "([^%s]+)%s+trong")
                                    end

                                    if playerName and playerName ~= "" then
                                        if not _G.Mod_AnStats then
                                            if _G.Mod_LoadAnStats then _G.Mod_LoadAnStats() end
                                        end

                                        local todayStr = CS.System.DateTime.Now:ToString("yyyy/MM/dd")
                                        if _G.Mod_AnStatsDate ~= todayStr then
                                            _G.Mod_AnStatsDate = todayStr
                                            _G.Mod_AnStats = {}
                                        end

                                        _G.Mod_AnStats[playerName] = (_G.Mod_AnStats[playerName] or 0) + 1

                                        if _G.Mod_SaveAnStats then _G.Mod_SaveAnStats() end

                                        if _G.FloatingWordUtility then
                                            _G.FloatingWordUtility.QuickMsg(string.format(
                                                "TỔNG HỢP ẨN: %s (+1) -> Tổng: %d", playerName,
                                                _G.Mod_AnStats[playerName]))
                                        end

                                        if _G.WriteLog then
                                            _G.WriteLog(string.format("[AnStats] Detected Ky Si: %s (Total: %d)",
                                                playerName, _G.Mod_AnStats[playerName]))
                                        end

                                        if _G.Mod_SendAnStatsTelegram then
                                            _G.Mod_SendAnStatsTelegram()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                if orig_AddMessage then
                    orig_AddMessage(channel, message)
                end
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
                                _G.Mod_BypassInstanceEnter(self, control, original_btn_enterOnClick,
                                    _G.UIID.Instance_BloodCastleUI)
                            else
                                if original_btn_enterOnClick then original_btn_enterOnClick(self, control) end
                            end
                        end
                    end
                    local inst = _G.UIManager and _G.UIManager.GetUI and
                        _G.UIManager.GetUI(_G.UIID.Instance_BloodCastleUI)
                    if inst and inst.btn_enter and inst.btn_enter.SetOnClick then
                        inst.btn_enter:SetOnClick(inst, inst.btn_enterOnClick)
                    end
                elseif name == "Instance_DemonPlazaUI" then
                    if _G.Instance_DemonPlazaUI and not _G.Mod_HookedDemonPlaza then
                        _G.Mod_HookedDemonPlaza = true
                        local original_btn_enterOnClick_DP = _G.Instance_DemonPlazaUI.btn_enterOnClick
                        _G.Instance_DemonPlazaUI.btn_enterOnClick = function(self, control)
                            if _G.Mod_BypassInstanceEnter then
                                _G.Mod_BypassInstanceEnter(self, control, original_btn_enterOnClick_DP,
                                    _G.UIID.Instance_DemonPlazaUI)
                            else
                                if original_btn_enterOnClick_DP then original_btn_enterOnClick_DP(self, control) end
                            end
                        end
                    end
                    local inst = _G.UIManager and _G.UIManager.GetUI and
                        _G.UIManager.GetUI(_G.UIID.Instance_DemonPlazaUI)
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
    -- [[ ĐÃ XÓA BỎ VÒNG LẶP AUTO FARM ẨN Ở ĐÂY ĐỂ TRÁNH CONFLICT ]]
end)
if not status then
    WriteLog("LỖI HOOK UIManager: " .. tostring(err))
end

        _G.Mod_MapsConfig_c3 = {
            {
                mapId = 101094,
                title = "Hoang Dã C3",
                bosses = {
                    { id = 10179407, name = "H.Thần Kiêu Ngạo", col = 1, transferId = 400212 },
                    { id = 10179408, name = "Phẫn Nộ", col = 2, transferId = 400218 },
                    { id = 10179409, name = "Cuồng Bạo", col = 3, transferId = 400224 },
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
                    { id = 10179307, name = "K.Sĩ Địa Ngục", col = 1, transferId = 400213 },
                    { id = 10179308, name = "Phẫn Nộ", col = 2, transferId = 400219 },
                    { id = 10179309, name = "Cuồng Bạo", col = 3, transferId = 400225 },
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
                    { id = 10179507, name = "Giác Ma Đ.Ngục", col = 1, transferId = 400214 },
                    { id = 10179508, name = "Phẫn Nộ", col = 2, transferId = 400220 },
                    { id = 10179509, name = "Cuồng Bạo", col = 3, transferId = 400226 },
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
                    { id = 10179207, name = "V.Sĩ Khiên Kiếm", col = 1, transferId = 400215 },
                    { id = 10179208, name = "Phẫn Nộ", col = 2, transferId = 400221 },
                    { id = 10179209, name = "Cuồng Bạo", col = 3, transferId = 400227 },
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
                    { id = 10179607, name = "Tektus", col = 1, transferId = 400216 },
                    { id = 10179608, name = "Phẫn Nộ", col = 2, transferId = 400222 },
                    { id = 10179609, name = "Cuồng Bạo", col = 3, transferId = 400228 },
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
                    { id = 107407, name = "K.Sĩ Tử Vong", col = 1, transferId = 400229 },
                    { id = 107408, name = "Phẫn Nộ", col = 2, transferId = 400230 },
                    { id = 107409, name = "Cuồng Bạo", col = 3, transferId = 400231 },
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
                    { id = 107507, name = "S.Giả Ác Ma", col = 1, transferId = 400232 },
                    { id = 107508, name = "Phẫn Nộ", col = 2, transferId = 400233 },
                    { id = 107509, name = "Cuồng Bạo", col = 3, transferId = 400234 },
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
                    { id = 107607, name = "C.Sĩ Cuồng Nộ", col = 1, transferId = 400235 },
                    { id = 107608, name = "Phẫn Nộ", col = 2, transferId = 400236 },
                    { id = 107609, name = "Cuồng Bạo", col = 3, transferId = 400237 },
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
                    { id = 1012307, name = "Thủy Ma Navos", col = 1, transferId = 400238 },
                    { id = 1012308, name = "Phẫn Nộ", col = 2, transferId = 400239 },
                    { id = 1012309, name = "Cuồng Bạo", col = 3, transferId = 400240 },
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
                    { id = 101230107, name = "Thần Hắc Ám", col = 1, transferId = 400241 },
                    { id = 101230108, name = "Phẫn Nộ", col = 2, transferId = 400242 },
                    { id = 101230109, name = "Cuồng Bạo", col = 3, transferId = 400243 },
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

        

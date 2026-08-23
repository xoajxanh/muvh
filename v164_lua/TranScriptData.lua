TranScriptData = {}
TranScriptData.TranScriptType = {
  System = enum(1),
  Single = enum(),
  ZhanMeng = enum()
}
TranScriptData.TranScriptSubType = {
  SingleMaterial = enum(2201),
  SingleBoss = enum(2202),
  BloodCastle = enum(2203),
  DemonPlaza = enum(2204),
  RefineTow = enum(2207),
  GradUnion = enum(1302),
  secretBoss = enum(1106),
  GodCome = enum(1200),
  KalimarTemple = enum(2206),
  HolyRingBoss = enum(1421)
}
TranScriptData.TranScriptGlobal = {
  [2203] = {
    condition = 100414,
    LevelAndNumber = 100404,
    def = 100415
  },
  [2204] = {
    condition = 100408,
    LevelAndNumber = 100702,
    def = 100413
  },
  [2207] = {
    condition = 101001,
    LevelAndNumber = 101003,
    def = 101004
  }
}
TranScriptData.InAllGodsscript = false
TranScriptData.InAllGodCloseBtn = true
TranScriptData.InAllGodsscriptData = {}
TranScriptData.AllGodsBossData = {}
TranScriptData.InTranscript = false
TranScriptData.IsTranscriptSuccess = false
TranScriptData.InTranscriptType = nil
TranScriptData.InTranscriptStage = nil
TranScriptData.enterConditionData = {}
TranScriptData.ContentData = {}
TranScriptData.LevelAndNumber = {}
TranScriptData.NpcData = nil
TranScriptData.tranScriptInviteData = {}
TranScriptData.InTranscriptData = {}
TranScriptData.BurialRankingData = {}
TranScriptData.DemonPlazaIntegral = 0
TranScriptData.IsVoluntarily = false
TranScriptData.PosData = {}
TranScriptData.OldPosData = {}
TranScriptData.TaskState = 0
TranScriptData.TaskType = 0
TranScriptData.isOperate = false
TranScriptData.isWay = false
TranScriptData.secretBossTimeTab = {}
TranScriptData.reinBossTimeTab = {}
TranScriptData.angelBossTimeTab = {}
TranScriptData.regenerateBossTimeTab = {}
TranScriptData.ServerRoleCountDownTimeData = nil
TranScriptData.isFinishedGoldCaves = false
local this = TranScriptData
this.SystemData = {}
this.BossData = {}
this.MaterialData = {}
this.DemonPlazaData = {}
this.RefineTowData = {}
this.brilliantBoss = {}
this.secretBoss = {}
this.secretBossPreTask = {}
this.spanBoss = {}
this.kalimarTempleData = {}
this.startTime = 0
this.endTime = 0
this.limitTimeUnix = 0
this.endLimitTimeUnix = 0
this.isOnceRefreshRoleCountdownTime = true

function TranScriptData.InitData(data)
  this.resetTable()
  this.InitMap_instanceTable()
  this.InitBrilliantBossData()
  this.InitSecretTaskId()
  this.InitSecretBossData()
end

function TranScriptData.ClearData(openAutoFight)
  if RoleManager.me and not openAutoFight then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
  end
  this.SetInTranscript(false)
  this.InTranscript = false
  this.IsTranscriptSuccess = false
  this.InTranscriptType = nil
  this.InTranscriptStage = nil
  this.enterConditionData = {}
  this.ContentData = {}
  this.LevelAndNumber = {}
  this.NpcData = nil
  this.tranScriptInviteData = {}
  this.InTranscriptData = {}
  this.DemonPlazaIntegral = 0
  this.PosData = {}
  this.OldPosData = {}
  this.TaskState = 0
  this.TaskType = 0
  this.CloseTimer()
  this.InAllGodsscript = false
  this.InAllGodCloseBtn = true
  this.InAllGodsscriptData = {}
  this.AllGodsBossData = {}
  this.isOnceRefreshRoleCountdownTime = true
end

function TranScriptData.InitBrilliantBossData()
  this.brilliantBoss = ConfigManager.FindConfigs("cfg_Monster_boss", "bossType", MonsterBossType.brilliantMonster)
  this.brilliantBoss = TranScriptData.filtrationBossData(this.brilliantBoss)
  this.spanBoss = ConfigManager.FindConfigs("cfg_Monster_boss", "bossType", MonsterBossType.spanBoss)
  this.spanBoss = TranScriptData.filtrationBossDataTwo(this.spanBoss)
  table.sort(this.brilliantBoss, function(a, b)
    return a.id < b.id
  end)
end

function TranScriptData.InitSecretBossData()
  local secretBossTab = ConfigManager.FindConfigs("cfg_Monster_boss", "bossType", MonsterBossType.secretBoss)
  table.remove(secretBossTab, 1)
  for _, v in pairs(secretBossTab) do
    if v.show == 0 then
      table.insert(this.secretBoss, v)
    end
  end
end

function TranScriptData.filtrationBossData(dataTbl)
  local BossMeta = {}
  for i = 1, #dataTbl do
    if BossMeta[dataTbl[i].id] == nil and dataTbl[i].show ~= 1 then
      BossMeta[dataTbl[i].id] = dataTbl[i]
      BossMeta[dataTbl[i].id].mapTbl = {}
      table.insert(BossMeta[dataTbl[i].id].mapTbl, dataTbl[i].mapId)
    elseif BossMeta[dataTbl[i].id] ~= nil and dataTbl[i].show ~= 1 then
      table.insert(BossMeta[dataTbl[i].id].mapTbl, dataTbl[i].mapId)
    end
  end
  local dataTblMeta = {}
  for k, v in pairs(BossMeta) do
    table.insert(dataTblMeta, v)
  end
  return dataTblMeta
end

function TranScriptData.filtrationBossDataTwo(dataTbl)
  local BossMeta = {}
  local BossID = {}
  for i = 1, #dataTbl do
    local isHave = false
    for k, v in pairs(BossID) do
      if v == dataTbl[i].id then
        isHave = true
        break
      end
    end
    if not isHave then
      table.insert(BossID, dataTbl[i].id)
      table.insert(BossMeta, dataTbl[i])
    end
  end
  return BossMeta
end

function TranScriptData.InitSecretTaskId()
  this.secretBossPreTask = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2440601), "#")
end

function TranScriptData.InitLimitTime()
  local curTime = Time.GetServerSecondTime()
  local timeTbl = os.date("*t", curTime)
  this.limitTimeUnix = os.time({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = 0,
    min = 0
  })
  this.endLimitTimeUnix = os.time({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = 0,
    min = 0
  })
end

this.OpenConditionEnum = {
  ["908"] = function(timeSlot, isLimit, firsOpenCondition, lastOpenCondition)
    if not isLimit then
      return false
    end
    local curTime = Time.GetServerSecondTime()
    local times = string.split(timeSlot, "-")
    local startStr = times[1]
    local endStr = times[2]
    local startTime = TimeUtility.GetTimeStampByStr(startStr)
    local endTime = TimeUtility.GetTimeStampByStr(endStr)
    local curTimeHour = tonumber(string.split(TimeUtility.SwitchHourStamp(curTime), ":")[1])
    local startTimeHour = tonumber(string.split(startStr, ":")[1])
    if curTime < startTime then
      local timeStrs = string.split(startStr, ":")
      this.startTime = startTime
      this.limitTimeUnix = TimeUtility.AddHour(this.limitTimeUnix * 1000, tonumber(timeStrs[1]))
      this.limitTimeUnix = TimeUtility.AddMin(this.limitTimeUnix * 1000, tonumber(timeStrs[2]))
      if not this.InTranscript then
        return true
      end
    end
    if curTime > endTime then
      local lastTimes = string.split(lastOpenCondition, "-")
      local lastStartStr = tonumber(string.split(lastTimes[2], ":")[1])
      if curTimeHour >= lastStartStr and startTimeHour >= lastStartStr and (not (curTime >= startTime) or not (curTime <= endTime)) then
        local firstTimes = string.split(firsOpenCondition, "-")
        local firstStartStr = firstTimes[1]
        local firstStartTime = TimeUtility.GetTimeStampByStr(firstStartStr)
        firstStartTime = TimeUtility.AddDay(firstStartTime * 1000, 1)
        this.startTime = firstStartTime
        return true
      else
        local timeStrs = string.split(startStr, ":")
        this.startTime = startTime
        this.limitTimeUnix = TimeUtility.AddDay(this.limitTimeUnix * 1000, 1)
        this.limitTimeUnix = TimeUtility.AddHour(this.limitTimeUnix * 1000, tonumber(timeStrs[1]))
        this.limitTimeUnix = TimeUtility.AddMin(this.limitTimeUnix * 1000, tonumber(timeStrs[2]))
      end
    end
    if curTime >= startTime and curTime <= endTime then
      local timeStrs = string.split(startStr, ":")
      this.limitTimeUnix = TimeUtility.AddHour(this.limitTimeUnix * 1000, tonumber(timeStrs[1]))
      this.limitTimeUnix = TimeUtility.AddMin(this.limitTimeUnix * 1000, tonumber(timeStrs[2]))
      this.endLimitTimeUnix = TimeUtility.AddHour(this.endLimitTimeUnix * 1000, tonumber(timeStrs[1]))
      this.endLimitTimeUnix = TimeUtility.AddMin(this.endLimitTimeUnix * 1000, tonumber(timeStrs[2]))
      this.startTime = startTime
      this.endTime = endTime
      return true
    end
  end
}

function TranScriptData.RefreshOpenTime(mapId)
  this.InitLimitTime()
  local openActivityCond = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "groupId").openCondition
  local openCondition = string.split(openActivityCond, "/")
  local timeCount = #openCondition
  if timeCount <= 0 then
    return
  end
  local firsOpenCondition = openCondition[1]
  local lastOpenCondition
  local tempCondition = string.split(openCondition[#openCondition], "#")
  for i = #openCondition, 1, -1 do
    if string.split(openCondition[i], "#")[1] == "908" then
      lastOpenCondition = openCondition[i]
      break
    end
  end
  if lastOpenCondition == nil then
    logError("lastOpenCondition is nil")
    return
  end
  local strFirst = string.split(firsOpenCondition, "#")
  local strLast = string.split(lastOpenCondition, "#")
  for i, v1 in ipairs(openCondition) do
    local res = true
    local strs = string.split(v1, "#")
    local tempRes = false
    if strs[1] == "908" then
      tempRes = this.OpenConditionEnum[strs[1]](strs[2], res, strFirst[2], strLast[2])
    end
    if tempRes then
      break
    end
  end
end

function TranScriptData.InitMap_instanceTable()
  local TranScriptTable = ClientTable.cfg_Map_instanceManager:GetDic()
  for k, v in pairs(TranScriptTable) do
    local tbl = v
    local normalData = this.SetSingleData(tbl)
    if normalData.copyType == this.TranScriptSubType.SingleMaterial then
      table.insert(this.MaterialData, normalData)
    elseif normalData.copyType == this.TranScriptSubType.SingleBoss then
      table.insert(this.BossData, normalData)
    elseif normalData.copyType == this.TranScriptSubType.BloodCastle then
      table.insert(this.SystemData, normalData)
    elseif normalData.copyType == this.TranScriptSubType.DemonPlaza then
      table.insert(this.DemonPlazaData, normalData)
    elseif normalData.copyType == this.TranScriptSubType.RefineTow then
      table.insert(this.RefineTowData, normalData)
    elseif normalData.copyType == this.TranScriptSubType.KalimarTemple then
      table.insert(this.kalimarTempleData, normalData)
    end
  end
  table.sort(this.DemonPlazaData, function(a, b)
    return a.instanceTbl.mapId < b.instanceTbl.mapId
  end)
  table.sort(this.SystemData, function(a, b)
    return a.instanceTbl.mapId < b.instanceTbl.mapId
  end)
  table.sort(this.RefineTowData, function(a, b)
    return a.instanceTbl.mapId < b.instanceTbl.mapId
  end)
  table.sort(this.kalimarTempleData, function(a, b)
    return a.instanceTbl.mapId < b.instanceTbl.mapId
  end)
end

function TranScriptData.SetSingleData(tbl)
  local normalData = {}
  normalData.instanceTbl = tbl
  normalData.copyType = tbl.type
  if tbl.type == TranScriptData.TranScriptSubType.KalimarTemple then
    local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(tbl.mapId)
    if mapTbl and mapTbl.transferPosition then
      normalData.transferTable = ClientTable.cfg_Map_transferManager:TryGetValue(tonumber(mapTbl.transferPosition))
    end
  else
    normalData.transferTable = this.GetTransferTable(tbl.mapId)
  end
  return normalData
end

function TranScriptData.GetTypeDatas(copyType)
  if copyType == this.TranScriptSubType.SingleMaterial then
    return this.MaterialData
  elseif copyType == this.TranScriptSubType.SingleBoss then
    return this.BossData
  elseif copyType == this.TranScriptSubType.BloodCastle then
    return this.SystemData
  elseif copyType == this.TranScriptSubType.DemonPlaza then
    return this.DemonPlazaData
  elseif copyType == this.TranScriptSubType.RefineTow then
    return this.RefineTowData
  elseif copyType == this.TranScriptSubType.secretBoss then
    return this.secretBoss
  elseif copyType == this.TranScriptSubType.KalimarTemple then
    return this.kalimarTempleData
  end
end

function TranScriptData.GetTransferTableInID(id)
  local transTable = ClientTable.cfg_Map_transferManager:GetDic()
  for k, tbl in pairs(transTable) do
    if tbl.id == id then
      return tbl
    end
  end
end

function TranScriptData.GetTransferTable(mapid)
  local transTable = ClientTable.cfg_Map_transferManager:GetDic()
  for k, tbl in pairs(transTable) do
    if tbl.groupId == mapid then
      return tbl
    end
  end
end

function TranScriptData.resetTable()
  this.BossData = {}
  this.SystemData = {}
  this.MaterialData = {}
  this.DemonPlazaData = {}
  this.RefineTowData = {}
  this.kalimarTempleData = {}
  this.secretBoss = {}
end

local activeGlobalID = 100408

function TranScriptData.GetLevelTblData(TranCondition)
  local transTable = ClientTable.cfg_Activity_globalManager:TryGetValue(TranCondition or activeGlobalID)
  if transTable == nil then
    logError("ID l\225\187\151i" .. TranCondition)
  end
  local strSpilt = string.split(transTable.effect, "&")
  return strSpilt
end

function TranScriptData.GetEnterConditionData(TranType, TranCondition, TranMaxNumber, level, type)
  local meDataLevel = tonumber(level or ViewData.meData.level)
  local Data = TranScriptData.GetTypeDatas(TranType)
  local MaxNumberNum = ClientTable.cfg_Activity_globalManager:TryGetValue(TranMaxNumber)
  local strSpilt = this.GetLevelTblData(TranCondition)
  local strDan, strDanClassify, strDanClassifyLevel, kNum
  local CurData = {}
  local InsData = {}
  local levelData = {}
  for k, v in pairs(Data) do
    table.insert(CurData, v.transferTable)
    table.insert(InsData, v.instanceTbl)
  end
  if TranType == TranScriptData.TranScriptSubType.RefineTow then
    for i = 1, #strSpilt do
      strDan = strSpilt[i]
      strDanClassify = string.split(strDan, "#")
      strDanClassifyLevel = string.split(strDanClassify[3], "_")
      local strDanClassifyLevel1 = ClientTable.cfg_Character_levelManager:GetMinLevelByReincarnation(tonumber(strDanClassifyLevel[1]))
      local strDanClassifyLevel2 = ClientTable.cfg_Character_levelManager:GetMaxLevelByReincarnation(tonumber(strDanClassifyLevel[2]))
      local resStr = strDanClassify[1] .. "#" .. strDanClassify[2] .. "#" .. strDanClassifyLevel1 .. "_" .. strDanClassifyLevel2
      table.insert(levelData, i, resStr)
    end
  else
    for i = 1, #strSpilt do
      table.insert(levelData, i, strSpilt[i])
    end
  end
  for k, v in pairs(CurData) do
    if levelData[k] ~= nil then
      strDan = levelData[k]
      strDanClassify = string.split(strDan, "#")
      strDanClassifyLevel = string.split(strDanClassify[3], "_")
      if meDataLevel >= tonumber(strDanClassifyLevel[1]) and meDataLevel <= tonumber(strDanClassifyLevel[2]) then
        this.enterConditionData = v
        kNum = k
        break
      end
    end
  end
  this.ContentData = InsData[kNum]
  if this.enterConditionData == nil or table.count(this.enterConditionData) == 0 or this.ContentData == nil or table.count(this.enterConditionData) == 0 then
    if ViewData.meData.level > tonumber(strDanClassifyLevel[2]) then
      this.enterConditionData = CurData[#CurData]
      this.ContentData = InsData[#InsData]
      strDan = levelData[#levelData]
    else
      this.enterConditionData = CurData[1]
      this.ContentData = InsData[1]
      strDan = levelData[1]
    end
    strDanClassify = string.split(strDan, "#")
    strDanClassifyLevel = string.split(strDanClassify[3], "_")
  end
  this.LevelAndNumber = {}
  table.insert(this.LevelAndNumber, strDanClassify[2])
  table.insert(this.LevelAndNumber, strDanClassifyLevel[1])
  table.insert(this.LevelAndNumber, strDanClassifyLevel[2])
  table.insert(this.LevelAndNumber, MaxNumberNum.effect)
  return this.enterConditionData, this.LevelAndNumber
end

local EnterTranContentData = {}

function TranScriptData.GetContentData()
  if this.ContentData == nil or table.count(this.ContentData) <= 0 then
    local transTable = ClientTable.cfg_Map_instanceManager:TryGetValue(tonumber(this.InTranscriptData.basic.basic.mapId), "mapId")
    for k, v in pairs(TranScriptData.TranScriptGlobal) do
      if k == transTable.type then
        EnterTranContentData.Enum = k
        EnterTranContentData.condition = v.condition
        EnterTranContentData.LevelAndNumber = v.LevelAndNumber
      end
    end
    this.GetEnterConditionData(EnterTranContentData.Enum, EnterTranContentData.condition, EnterTranContentData.LevelAndNumber)
  end
  return this.ContentData
end

function TranScriptData:GetTaskState()
  local taskCondition, taskConditionNum
  if this.NpcData ~= nil then
    taskCondition = string.split(this.NpcData.param, "/")
    for k, v in pairs(taskCondition) do
      taskConditionNum = string.split(v, "#")
      local count = BagInfoData.GetItemCountByItemConfigId(tonumber(taskConditionNum[1]))
      if count >= tonumber(taskConditionNum[2]) then
        return true
      end
    end
  end
  return false
end

function TranScriptData.GetDefIsSatisfy(mapId, type)
  local id
  if TranScriptData.TranScriptGlobal[type] == nil then
    return nil, nil
  end
  id = TranScriptData.TranScriptGlobal[type].def
  local def = ClientTable.cfg_Activity_globalManager:TryGetValue(id).effect
  local defTbl = string.split(def, "&")
  local isSatisfy = false
  local needDef
  local meDefNum = tonumber(QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow))
  for k, v in pairs(defTbl) do
    local defNum = string.split(v, "#")
    if tonumber(defNum[1]) == mapId then
      isSatisfy = meDefNum >= tonumber(defNum[2])
      needDef = defNum[2]
      break
    end
  end
  return isSatisfy, needDef
end

function TranScriptData.GetDemonPlazaRatio()
  local ScoreRatio = ClientTable.cfg_Activity_globalManager:TryGetValue(100705)
  return ScoreRatio.effect
end

function TranScriptData.IsNewTask()
  if this.OldPosData[2] == this.PosData[2] then
    return false
  else
    this.OldPosData = this.PosData
    this.TaskState = BloodCastleTaskStage.PathFinding
    return true
  end
end

local normalTimer, surplusTime

function TranScriptData.SetVoluntarily(type)
end

function TranScriptData.StopMove(taskType)
end

local OperateTime

function TranScriptData.SetIsOperate()
end

function TranScriptData.StopTimer()
  if normalTimer then
    Timer.Stop(normalTimer)
    normalTimer = nil
  end
end

function TranScriptData.SetFlyShoe_FlyShoeUIActive(state)
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
end

function TranScriptData.CloseTimer()
  if normalTimer then
    Timer.Stop(normalTimer)
    normalTimer = nil
  end
  if OperateTime then
    Timer.Stop(OperateTime)
    OperateTime = nil
  end
end

function TranScriptData.CloseRevive()
  if this.InAllGodsscript then
    this.InAllGodsscript = false
    this.InAllGodsscriptData = {}
    this.AllGodsBossData = {}
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  end
  if this.InTranscript then
    this.InTranscriptType = nil
    this.SetInTranscript(false)
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  end
  if UIManager.IsVisible(UIID.Role_ResurgenceUI) and ViewData.meData.hp > 0 then
    UIManager.Hide(UIID.Role_ResurgenceUI)
  end
end

function TranScriptData.InitPriBossTime(msg)
  this.priBossTimeTab = {}
  if msg then
    for i = 1, table.count(msg.list) do
      this.priBossTimeTab[msg.list[i].mapId] = msg.list[i].endTime
    end
    EventManager.Dispatch(Event.UpdateCopyCd)
  end
end

function TranScriptData.InitSecretBossTime(msg)
  this.secretBossTimeTab = {}
  if msg and msg.bossState then
    for i = 1, table.count(msg.bossState) do
      this.secretBossTimeTab[msg.bossState[i].bossId .. msg.bossState[i].transferId] = msg.bossState[i].reliveTime
    end
    EventManager.Dispatch(Event.UpdateSecretBossCd)
  end
end

function TranScriptData.InitReinBossTime(msg)
  this.reinBossTimeTab = {}
  if msg and msg.bossState then
    for i = 1, table.count(msg.bossState) do
      this.reinBossTimeTab[msg.bossState[i].bossId .. msg.bossState[i].transferId] = msg.bossState[i].reliveTime
    end
  end
end

function TranScriptData.InitAngelBossTime(msg)
  this.angelBossTimeTab = {}
  if msg and msg.bossState then
    for i = 1, table.count(msg.bossState) do
      this.angelBossTimeTab[msg.bossState[i].bossId .. msg.bossState[i].transferId] = msg.bossState[i].reliveTime
    end
  end
end

function TranScriptData.InitRegenerateBossTime(msg)
  this.regenerateBossTimeTab = {}
  if msg and msg.bossState then
    for i = 1, table.count(msg.bossState) do
      this.regenerateBossTimeTab[msg.bossState[i].bossId .. msg.bossState[i].transferId] = msg.bossState[i].reliveTime
    end
  end
end

function TranScriptData.UpdatePriBossTime(msg)
  this.priBossTimeTab[msg.key] = msg.endTime
  EventManager.Dispatch(Event.UpdateCopyCd)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.pBoss,
    state = true
  })
end

function TranScriptData.GetBossIsCdTime()
  local isCd = false
  if this.priBossTimeTab and table.count(this.priBossTimeTab) > 0 then
    for k, v in pairs(this.priBossTimeTab) do
      local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(tonumber(k), "id").enterCondition
      local con = mapTbl[1]
      local level = 0
      for l, t in pairs(con) do
        local levleS = t
        if tonumber(levleS[1]) == 101 then
          level = tonumber(levleS[2])
        end
      end
      if v <= 0 and level <= ViewData.meData.level then
        isCd = true
        break
      end
    end
  end
  return isCd
end

function TranScriptData.GetSecretBossState()
  local instanceTbl
  local CurCopydatas = this.GetTypeDatas(this.TranScriptSubType.secretBoss)
  if CurCopydatas then
    for i = 1, #CurCopydatas do
      instanceTbl = CurCopydatas[i]
      local levelRestrict = ClientTable.cfg_Map_mapManager:TryGetValue(instanceTbl.mapId, "id").enterCondition
      local level = levelRestrict[1][1][2]
      local countKey = levelRestrict[1][2][2][1]
      local isCount = RefreshData.GetInstanceCount(tonumber(countKey))
      local isLevel = RoleManager.me.level >= tonumber(level)
      return 0 < isCount and isLevel
    end
  end
  return false
end

function TranScriptData.OpenNpcHandInTask()
  if this.InTranscript then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("BloodCastle_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = uiWord,
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        NetManager.Send(MapMessage.ReqSubmitInstanceTask, {
          id = this.NpcData.id
        })
        local npcList = RoleManager.GetRoleListByType(ERoleType.NPC)
        for k, v in pairs(npcList.list) do
          v:DestroyNpcTarget()
        end
      end
    })
  end
end

function TranScriptData.GetSecretBossIsTask()
  local task = TaskData.GetTaskById(tonumber(this.secretBossPreTask[1]))
  if task and task:GetState() == TaskStateType.Accept then
    return true
  else
    return false
  end
end

function TranScriptData.UnableToSendInCopy()
  if TranScriptData.InTranscript and TranScriptData.InTranscriptType ~= TranScriptType.PersonBoss_Tower then
    local titleStrCon = ConfigManager.GetConfig("cfg_Ui_word", "instance_1")
    if titleStrCon then
      FloatingWordUtility.QuickMsg(titleStrCon.content)
    end
    return true
  end
end

function TranScriptData.IsInRefineTow()
  return this.InTranscript == true and this.InTranscriptType == TranScriptType.RefineTower
end

function TranScriptData.IsInRefineKSBattle()
  return this.InTranscript == true and this.InTranscriptType == TranScriptType.KSBattle
end

function TranScriptData.IsInPersonBossBattle()
  return this.InTranscript == true and this.InTranscriptType == TranScriptType.PersonBoss_Tower
end

function TranScriptData.IsInThreeVsThreeMap()
  if SceneData.mapId and SceneData.mapId == TranScriptType.ThreeVsThreeMap then
    return true
  end
  return false
end

function TranScriptData.IsHideLevel()
  return TranScriptData.IsInRefineKSBattle()
end

function TranScriptData.IsHideUnionName()
  return TranScriptData.IsInRefineKSBattle()
end

function TranScriptData.GetInDuplicateNameStr()
  if TranScriptData.IsInRefineKSBattle() then
    return "K\225\186\187 B\195\173 \225\186\168n"
  end
  return nil
end

function TranScriptData.DealLevelStr(str, reStr, reStr2)
  str = string.replace(str, reStr, "")
  if not string.isNullOrEmpty(reStr2) then
    str = string.replace(str, reStr2, "")
  end
  return str
end

function TranScriptData.IsOpenKaLunTeResultTipUIByDead()
  if TranScriptData.InTranscriptData ~= nil and TranScriptData.InTranscriptData.canReliveCount then
    return TranScriptData.InTranscriptType == TranScriptType.KalunteRuins and TranScriptData.InTranscriptData.canReliveCount < 1
  end
  return false
end

function TranScriptData.SetInTranscript(state)
  if type(state) ~= "boolean" then
    return
  end
  TranScriptData.InTranscript = state
  EventManager.Dispatch(Event.InTranscriptChange, {state = state})
end

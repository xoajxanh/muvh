SceneData = {}
local this = SceneData
SceneData.sceneTransferInfosTbl = ConfigManager.FindConfigs("cfg_Map_transfer", "show", 0)
SceneData.texture2D = nil
SceneData.rt = nil
SceneData.textureType = "loading"
SceneData.mapLoaded = false
SceneData.loadingTexture = nil
SceneData.preMapId = 0
SceneData.MonsterMapData = {}
SceneData.KaLiMaMonsterMapData = {}
SceneData.KaLiMaBossRefreShTime = 0
SceneData.lastMapId = 0
SceneData.NowMapBossListData = nil
SceneData.SatisfyAncientBossData = {}
SceneData.NotSatisfiedAncientBossData = {}
SceneData.AncientStateData = {}
SceneData.openDayMax = 0

function SceneData.Init()
end

function SceneData.SetCurrentMapById(id, line, x, y)
  if 0 < id then
    local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(id, "id")
    if mapTbl == nil then
      logError("ID d\225\187\139ch chuy\225\187\131n b\225\186\163n \196\145\225\187\147 nhi\225\187\135m v\225\187\165 kh\195\180ng t\225\187\147n t\225\186\161i:" .. id)
      return
    end
    SceneData.lastMapId = SceneData.mapId and SceneData.mapId or 0
    SceneData.mapId = tonumber(mapTbl.id)
    SceneData.line = tonumber(line)
    local cline = line % mapTbl.cline
    if cline == 0 then
      cline = mapTbl.cline
    end
    SceneData.cline = tonumber(cline)
    SceneData.resName = mapTbl.map
    SceneData.name = mapTbl.name
    SceneData.width = tonumber(mapTbl.width)
    SceneData.height = tonumber(mapTbl.height)
    SceneData.defaultStepSound = tonumber(mapTbl.defaultStepSound)
    SceneData.bgm = tonumber(mapTbl.bgm)
    SceneData.sounds = mapTbl.sounds
    SceneData.groupId = tonumber(mapTbl.groupId)
    SceneData.bytesName = tonumber(mapTbl.data)
    SceneData.overlap = tonumber(mapTbl.overlap)
    SceneData.orThrough = tonumber(mapTbl.orThrough) or 0
    SceneData.serverType = mapTbl.serverType
    if x and y then
      this.SetDefaultCell(x, y)
    end
    this.SetMiniMapData(SceneData.mapId, SceneData.groupId)
    SceneData.isHideReinEffect = ClientTable.cfg_Global_globalManager:CheckHideReinEffectByCurMapId()
    SceneData.isHideTitle = mapTbl.headTitle == 1
    if SceneData.mapId == 1095 then
      UIManager.UICloseType(UIPanelType.SortAndHide, true)
      EventManager.Dispatch(Event.ThreeVSThree3V3BeginBgHide)
    end
    EventManager.Dispatch(Event.Scene_SceneDataChange, SceneData.mapId)
    EventManager.Dispatch(Event.RP_RedPointRefresh, {
      index = ERedPointType.siege,
      state = true
    })
  end
end

function SceneData.SetDefaultCell(x, y)
  SceneData.defaultX = tonumber(x)
  SceneData.defaultY = tonumber(y)
end

this.npcPosDataList = {}
this.monsterDataList = {}
this.elitePosDataList = {}
this.bossPosDataList = {}
this.transferPosDataList = {}
this.mu2_elitePosDataList = {}

function SceneData.SetMiniMapData(mapId, groupId)
  this.npcPosDataList = {}
  this.monsterDataList = {}
  this.elitePosDataList = {}
  this.bossPosDataList = {}
  this.transferPosDataList = {}
  this.mu2_elitePosDataList = {}
  local sceneShowRolesTbl = ConfigManager.FindConfigs("cfg_Map_minimap", "mid", mapId)
  if table.count(sceneShowRolesTbl) == 0 then
    sceneShowRolesTbl = ConfigManager.FindConfigs("cfg_Map_minimap", "mid", groupId)
  end
  for i, v in pairs(sceneShowRolesTbl) do
    if v.type == 1 then
      table.insert(this.npcPosDataList, v)
    end
    if v.type == 2 then
      table.insert(this.monsterDataList, v)
    end
    if v.type == 3 then
      table.insert(this.elitePosDataList, v)
    end
    if v.type == 4 then
      table.insert(this.bossPosDataList, v)
    end
    if v.type == 5 then
      table.insert(this.transferPosDataList, v)
    end
    if v.type == 7 then
      table.insert(this.mu2_elitePosDataList, v)
    end
  end
end

function SceneData.MonsterMapDataInit(data)
  if data ~= nil and data.bosses ~= nil then
    this.MonsterMapData = {}
    for i = 1, table.count(data.bosses) do
      local monsterData = {}
      monsterData.bossId = data.bosses[i].bossId
      local mapCountList = {}
      for i, v in pairs(data.bosses[i].mapCount) do
        local monsterData_mapItem = {}
        monsterData_mapItem.mapId = v.mapId
        monsterData_mapItem.count = v.count
        monsterData_mapItem.line = v.line
        monsterData_mapItem.mapTable = ClientTable.cfg_Map_mapManager:TryGetValue(v.mapId)
        monsterData_mapItem.bossState = v.bossState
        table.insert(mapCountList, monsterData_mapItem)
      end
      monsterData.mapCount = mapCountList
      table.insert(this.MonsterMapData, monsterData)
    end
  end
  EventManager.Dispatch(Event.Scene_SceneBossCount)
end

function SceneData:RefreshAncientBossData(ancientBossInfo)
  local bossType = ancientBossInfo.type
  if bossType == nil then
    return
  end
  self.SatisfyAncientBossData[bossType] = {}
  self.NotSatisfiedAncientBossData[bossType] = {}
  if ancientBossInfo.ancientBossInfo then
    for i, v in pairs(ancientBossInfo.ancientBossInfo) do
      self.SatisfyAncientBossData[bossType][v.monsterId] = v
    end
  end
  if ancientBossInfo.countData then
    for i, v in pairs(ancientBossInfo.countData) do
      self.NotSatisfiedAncientBossData[bossType][v.monsterId] = v
    end
  end
end

function SceneData:GetAncientBossData(bossType, monsterId)
  local isSatisfy, ancientBossInfo
  if self.SatisfyAncientBossData[bossType] and self.SatisfyAncientBossData[bossType][monsterId] and self.SatisfyAncientBossData[bossType][monsterId] ~= {} then
    ancientBossInfo = self.SatisfyAncientBossData[bossType][monsterId]
    isSatisfy = true
  elseif self.NotSatisfiedAncientBossData[bossType] and self.NotSatisfiedAncientBossData[bossType][monsterId] and self.NotSatisfiedAncientBossData[bossType][monsterId] ~= {} then
    isSatisfy = false
    ancientBossInfo = self.NotSatisfiedAncientBossData[bossType][monsterId]
  end
  return isSatisfy, ancientBossInfo
end

function SceneData.KaLiMaMonsterMapDataInit(data)
  if data ~= nil then
    this.KaLiMaMonsterMapData = data.MonsterMapAndCount
  end
end

function SceneData.SetKaLiMaBossRefreShTime(data)
  if data ~= nil then
    this.KaLiMaBossRefreShTime = data.countDownTime
  end
  EventManager.Dispatch(Event.RefreshKaLiMaBossTime)
end

SceneData.SmallIconData = {}
SceneData.SmallIconListActive = true
SceneData.GoldListModel = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2440402)

local function SortAllList(a, b)
  if a.list[1].state ~= b.list[1].state then
    return a.list[1].state > b.list[1].state
  elseif a.list[1].state == 0 then
    return a.list[1].reliveTime < b.list[1].reliveTime
  else
    return a.list[1].distance < b.list[1].distance
  end
end

local function SortList(a, b)
  if a.state ~= b.state then
    return a.state > b.state
  elseif a.state == 0 then
    return a.reliveTime < b.reliveTime
  else
    return a.distance < b.distance
  end
end

function SceneData.BossSmallIconDataInit(data)
  SceneData.SmallIconData = {}
  if not SceneData.CanShowByTable() or data.list == nil or #data.list <= 0 then
    return
  end
  local mePos = Vector2Int(data.x, data.y)
  for i = 1, #data.list do
    local tab = {}
    tab.list = {}
    local list = {}
    tab.bossID = data.list[i].configId
    list.id = data.list[i].id
    list.x = data.list[i].x
    list.y = data.list[i].y
    list.state = data.list[i].state
    list.reliveTime = data.list[i].reliveTime
    local pos = Vector2Int(data.list[i].x, data.list[i].y)
    list.distance = SceneData.GetDistance(mePos, pos)
    if tonumber(SceneData.GoldListModel) == 1 then
      for j = 1, #this.SmallIconData do
        if this.SmallIconData[j].bossID == data.list[i].configId then
          table.insert(this.SmallIconData[j].list, list)
          table.sort(this.SmallIconData[j].list, SortList)
          goto lbl_113
        end
      end
    end
    table.insert(tab.list, list)
    table.insert(this.SmallIconData, tab)
    ::lbl_113::
  end
  SceneData.SortSmallBossList()
end

function SceneData.GetDistance(mePos, pos)
  local path = SceneData.DirDistanceSqr(mePos, pos)
  if path == nil or path < 0 then
    return 1000000
  end
  return path
end

function SceneData.DirDistanceSqr(mePos, pos)
  if mePos == nil or pos == nil then
    return 1000000
  end
  return (pos.y - mePos.y) * (pos.y - mePos.y) + (pos.x - mePos.x) * (pos.x - mePos.x)
end

function SceneData.SortSmallBossList()
  table.sort(this.SmallIconData, SortAllList)
  if SceneData.SmallIconListActive and TaskData.GetCompletedTasksCount(10013) ~= false then
    EventManager.Dispatch(Event.Scene_SmallBossIcon)
  end
end

function SceneData.ResSingleBossSmallIcon(data)
  if not SceneData.CanShowByTable() or data == nil then
    return
  end
  local type = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.configId).type
  if type ~= 2002 then
    return
  end
  local list = {}
  list.x = data.x
  list.y = data.y
  list.state = data.state
  list.reliveTime = data.reliveTime
  local pos = Vector2Int(data.x, data.y)
  list.distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
  for j = 1, #this.SmallIconData do
    if tonumber(SceneData.GoldListModel) == 1 and this.SmallIconData[j].bossID == data.configId then
      for i = 1, #this.SmallIconData[j].list do
        if this.SmallIconData[j].list[i].id == data.id then
          this.SmallIconData[j].list[i].x = data.x
          this.SmallIconData[j].list[i].y = data.y
          this.SmallIconData[j].list[i].state = data.state
          this.SmallIconData[j].list[i].reliveTime = data.reliveTime
          local pos = Vector2Int(data.x, data.y)
          this.SmallIconData[j].list[i].distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
        else
          local pos = Vector2Int(this.SmallIconData[j].list[i].x, this.SmallIconData[j].list[i].y)
          this.SmallIconData[j].list[i].distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
        end
      end
      table.sort(this.SmallIconData[j].list, SortList)
    else
      if this.SmallIconData[j].list[1].id == data.id then
        this.SmallIconData[j].list[1].x = data.x
        this.SmallIconData[j].list[1].y = data.y
        this.SmallIconData[j].list[1].state = data.state
        this.SmallIconData[j].list[1].reliveTime = data.reliveTime
        local pos = Vector2Int(data.x, data.y)
        this.SmallIconData[j].list[1].distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
      else
        local pos = Vector2Int(this.SmallIconData[j].list[1].x, this.SmallIconData[j].list[1].y)
        this.SmallIconData[j].list[1].distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
      end
      table.sort(this.SmallIconData[j].list, SortList)
    end
  end
  SceneData.SortSmallBossList()
end

function SceneData.RefreshDistance()
  if this.SmallIconData == nil or #this.SmallIconData <= 0 then
    return
  end
  for j = 1, #this.SmallIconData do
    for i = 1, #this.SmallIconData[j].list do
      local pos = Vector2Int(this.SmallIconData[j].list[i].x, this.SmallIconData[j].list[i].y)
      this.SmallIconData[j].list[i].distance = SceneData.GetDistance(RoleManager.me.cellPos, pos)
    end
    table.sort(this.SmallIconData[j].list, SortList)
  end
  SceneData.SortSmallBossList()
end

function SceneData.CanShowFXList()
  if not (SceneData.CanShowByTable() and SceneData.SmallIconListActive) or #this.SmallIconData <= 0 or TaskData.GetCompletedTasksCount(10013) == false or TaskData.GetCompletedTasksCount(10013).count == 0 then
    return false
  end
  return true
end

function SceneData.CanShowByTable()
  local map = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
  return map.orEliteBoss == 1
end

function SceneData.GetListShowAct()
  return SceneData.CanShowFXList() and Main_MainMenuUI and Main_MainMenuUI.go_eliteBossAct
end

function SceneData.SetMapAllMonState(msg)
  SceneData.MonStateData = {}
  for i = 1, table.count(msg.list) do
    SceneData.MonStateData[msg.list[i].id] = msg.list[i]
  end
end

function SceneData.SetMapSingleMonState(msg)
  if not SceneData.MonStateData then
    return
  end
  if SceneData.MonStateData[msg.id] then
    SceneData.MonStateData[msg.id].state = msg.state
  end
end

function SceneData.GetCurrentMapMonActiveData()
  if not SceneData.MonStateData then
    return
  end
  local data = {}
  for i, v in pairs(SceneData.MonStateData) do
    if v.state == 1 then
      table.insert(data, v)
    end
  end
  return data
end

function SceneData.ResetData()
  SceneData.SmallIconData = {}
  SceneData.isHideReinEffect = false
  SceneData.isHideTitle = false
  EventManager.Dispatch(Event.Scene_SmallBossReset)
end

function SceneData.IsCrossRealm(mapId)
  mapId = mapId or SceneData.mapId
  if mapId == nil then
    return false
  end
  local map = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
  if map and map.serverType == 2 then
    return true
  end
  return false
end

function SceneData:RefreshGetRingBossCountData(data)
  if data == nil then
    self.RingBoss_nowcount = nil
    self.RingBoss_totalCount = nil
    return
  end
  self.RingBoss_nowcount = data.count
  self.RingBoss_totalCount = data.totalCount
  EventManager.Dispatch(Event.RefreshRingBossCountData)
end

SceneData.Init()

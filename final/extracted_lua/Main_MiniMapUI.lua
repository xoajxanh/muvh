Main_MiniMapUI = class(BaseUI)
Main_MiniMapUI.layer = UILayer.Background
Main_MiniMapUI.orderInLayer = 0
Main_MiniMapUI.hideType = UIHideType.Hide
Main_MiniMapUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MiniMapUI.escClose = UIEscClose.DontClose

function Main_MiniMapUI:InitControls()
  self.btn_map = self:GetControl("btn_map")
  self.img_topbg = self:GetControl("btn_map/img_topbg")
  self.img_bottombg = self:GetControl("btn_map/img_bottombg")
  self.sp_map = self:GetControl("btn_map/sp_mapMask/sp_map")
  self.monsterPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/monsterPointParent")
  self.sp_monster = self:GetControl("btn_map/sp_mapMask/sp_map/monsterPointParent/sp_monster")
  self.playerPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/playerPointParent")
  self.sp_player = self:GetControl("btn_map/sp_mapMask/sp_map/playerPointParent/sp_player")
  self.npcPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/npcPointParent")
  self.sp_npc = self:GetControl("btn_map/sp_mapMask/sp_map/npcPointParent/sp_npc")
  self.transferPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/transferPointParent")
  self.sp_transfer = self:GetControl("btn_map/sp_mapMask/sp_map/transferPointParent/sp_transfer")
  self.elitePointParent = self:GetControl("btn_map/sp_mapMask/sp_map/elitePointParent")
  self.sp_elite = self:GetControl("btn_map/sp_mapMask/sp_map/elitePointParent/sp_elite")
  self.sp_kalima = self:GetControl("btn_map/sp_mapMask/sp_map/elitePointParent/sp_kalima")
  self.bossPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/bossPointParent")
  self.sp_boss = self:GetControl("btn_map/sp_mapMask/sp_map/bossPointParent/sp_boss")
  self.pathPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/pathPointParent")
  self.sp_path = self:GetControl("btn_map/sp_mapMask/sp_map/pathPointParent/sp_path")
  self.sp_pathEndPoint = self:GetControl("btn_map/sp_mapMask/sp_map/pathPointParent/sp_pathEndPoint")
  self.monStateParent = self:GetControl("btn_map/sp_mapMask/sp_map/monStateParent")
  self.onHookPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/onHookPointParent")
  self.sp_onHook = self:GetControl("btn_map/sp_mapMask/sp_map/onHookPointParent/sp_onHook")
  self.monsterCircleParent = self:GetControl("btn_map/sp_mapMask/sp_map/monsterCircleParent")
  self.sp_circle = self:GetControl("btn_map/sp_mapMask/sp_map/monsterCircleParent/sp_circle")
  self.lab_mapName = self:GetControl("btn_map/lab_mapName")
  self.mePoint = self:GetControl("btn_map/mePoint")
  self.lab_pos = self:GetControl("btn_map/lab_pos")
  self.btn_route = self:GetControl("btn_route")
  self.lab_route = self:GetControl("btn_route/lab_route")
  self.KaLunTeCircleParent = self:GetControl("btn_map/sp_mapMask/sp_map/KaLunTeCircleParent")
  self.duoqiPointParent = self:GetControl("btn_map/sp_mapMask/sp_map/duoqiPointParent")
  self.sp_flag = self:GetControl("btn_map/sp_mapMask/sp_map/duoqiPointParent/sp_flag")
  self.duoqiPointBoxParent = self:GetControl("btn_map/sp_mapMask/sp_map/duoqiPointBox")
  self.sp_box = self:GetControl("btn_map/sp_mapMask/sp_map/duoqiPointBox/sp_box")
  self.SpaceCrackBoxParent = self:GetControl("btn_map/sp_mapMask/sp_map/SpaceCrackBox")
  self.spaceCrackBoxSp_box = self:GetControl("btn_map/sp_mapMask/sp_map/SpaceCrackBox/sp_box")
  self.fourPartyRivalryFlagParent = self:GetControl("btn_map/sp_mapMask/sp_map/fourPartyRivalryParent/flagParent")
  self.fourPartyRivalryFlagItem = self:GetControl("btn_map/sp_mapMask/sp_map/fourPartyRivalryParent/flagParent/itemFlag")
  self.fourPartyRivalryCityGateParent = self:GetControl("btn_map/sp_mapMask/sp_map/fourPartyRivalryParent/cityGateParent")
  self.fourPartyRivalryCityGateItem = self:GetControl("btn_map/sp_mapMask/sp_map/fourPartyRivalryParent/cityGateParent/itemCityGate")
  self.fourPartyRivalryThroneItem = self:GetControl("btn_map/sp_mapMask/sp_map/fourPartyRivalryParent/throneParent/itemThrone")
end

local mapWidthScale, mapHeightScale
local mapScale = 1
local halfMapSpWidth, halfMapSpHeight
local pathPointSpList = {}
local monsterSpPool = {}
local monsterIdSpList = {}
local bossIdSpList = {}
local eliteIdSpList = {}
local playerSpPool = {}
local playerIdSpList = {}
local npcSpList = {}
local transferSpList = {}
local bossSpList = {}
local eliteSpList = {}
local newMonsterSpList = {}
local unionFlagList = {}
local unionBoxList = {}
local spaceCrackBoxList = {}
local rotateParam = 0.70710678
local curEliteIndex = 1
local fourPartyRivalryFlagList = {}
local fourPartyRivalryCityGateList = {}

function Main_MiniMapUI:Init()
  self.posOffset = Vector2(0, 0)
  self.monsterType = {
    miniMon = 1000,
    boss = 2001,
    elite = 2002,
    fireDragon = 2003,
    wolf = 4001,
    maxMon = 2000,
    kalimElite = 2011
  }
  local boosTbl = string.split(GlobalConfig.GetGlobalConfig(3000002), "#")
  self.bossTotalType = {}
  for i = 1, table.count(boosTbl) do
    table.insert(self.bossTotalType, tonumber(boosTbl[i]))
  end
  self:LineMapDataInit()
  self.monsterStateObj = {}
  self.bossAndElitePool = {}
end

function Main_MiniMapUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_MiniMapUI:InitUI()
  self:RefreshMapDataScale()
  self:RefreshData()
  self:InitTemplate()
end

function Main_MiniMapUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_MiniMapUI:OnHide()
  ForgeData.BossAndEliteSingleData = {}
  if table.count(self.bossAndElitePool) > 0 then
    for i, v in pairs(self.bossAndElitePool) do
      if v then
        v:Destroy()
      end
    end
    self.bossAndElitePool = {}
  end
  if 0 < table.count(self.monsterStateObj) then
    for i, v in pairs(self.monsterStateObj) do
      if v then
        v:Destroy()
      end
    end
    self.monsterStateObj = {}
  end
  if self.spriteCol then
    Coroutine.Stop(self.spriteCol)
    self.spriteCol = nil
  end
end

function Main_MiniMapUI:OnDestroy()
end

local tempMePos = {}
local updatePos = Vector3.zero

function Main_MiniMapUI:Update()
  if RoleManager.me == nil then
    return
  end
  local mePos = RoleManager.me:GetPosition()
  if RoleManager.me and updatePos ~= mePos then
    updatePos = table.DeepCopy(mePos)
    tempMePos.x = mePos.x
    tempMePos.y = mePos.z
    local x = mePos.x
    local y = mePos.z
    local curPosX = -(x * mapWidthScale - halfMapSpWidth) * rotateParam + -(y * mapHeightScale - halfMapSpHeight) * rotateParam
    local curPosY = (x * mapWidthScale - halfMapSpWidth) * rotateParam + -(y * mapHeightScale - halfMapSpHeight) * rotateParam
    self.sp_map.transform:SetAnchoredPosition(curPosX, curPosY)
    self:PlayerDirectionCtrl()
    self.lab_pos:SetText(string.format("(%d,%d)", RoleManager.me.cellPos.x, RoleManager.me.cellPos.y))
  end
  if (self.sp_map.image.sprite == nil or self.nowsp_map ~= self.sp_map.image.sprite) and not self.isDoSprite then
    self:RefreshData()
  end
end

function Main_MiniMapUI:RegistUIEvents()
  self.btn_map:SetOnClick(self, self.OpenMapDetail)
  self.btn_route:SetOnClick(self, self.OpenMapChangeUI)
end

function Main_MiniMapUI:RegistEvents()
  self:RegistEvent(Event.UpdateRolePos, self.RoleChangePos, self)
  self:RegistEvent(Event.Map_RemoveMon, self.RoleExitView, self)
  self:RegistEvent(Event.Scene_SceneLoaded, self.SetInfo, self)
  self:RegistEvent(Event.Map_MonsterAllState, self.SetAllMonsterState, self)
  self:RegistEvent(Event.Map_MonsterStateChange, self.SetSingleMonsterState, self)
  self:RegistEvent(Event.InComePointDataChanged, self.RefreshInComePointView, self)
  self:RegistEvent(Event.KalunteRuinsVirusCircleChange, self.OnKalunteRuinsVirusCircleChange, self)
  self:RegistEvent(Event.KalunteRuinsExit, self.OnKalunteRuinsExit, self)
  self:RegistEvent(Event.MonsterEnterView, self.OnMonsterEnterView, self)
  self:RegistEvent(Event.MonstersEnterView, self.OnMonstersEnterView, self)
  self:RegistEvent(Event.EnterUnionMap, self.UnionFlagPosRefresh, self)
  self:RegistEvent(Event.EnterUnionMap, self.UnionBoxPosRefresh, self)
  self:RegistEvent(Event.RefreshBoxMap, self.UnionBoxPosRefresh, self)
  self:RegistEvent(Event.ResSpaceCrackMiniMapBox, self.ResSpaceCrackMiniMapBox, self)
  self:RegistEvent(Event.ResFourPartyRivalryActivityInfo, self.RefreshFourPartyRivalryIcon, self)
end

function Main_MiniMapUI:RefreshMonAndElitePos()
  if not self.bossAndElitePool then
    self.bossAndElitePool = {}
  end
  for i, v in pairs(self.monsterStateObj) do
    if v then
      v:SetActive(false)
      table.insert(self.bossAndElitePool, v)
    end
  end
  self.monsterStateObj = {}
end

function Main_MiniMapUI:GetBossOrEliteObj(id, type)
  local obj
  if table.count(self.bossAndElitePool) > 0 then
    for i, v in pairs(self.bossAndElitePool) do
      if v and (v.type == type or table.contains(self.bossTotalType, type) and table.contains(self.bossTotalType, v.type)) then
        obj = self.bossAndElitePool[i]
        self.bossAndElitePool[i] = nil
        break
      end
    end
  end
  return obj
end

function Main_MiniMapUI:SetAllMonsterState(_, msg)
  self:RefreshMonAndElitePos()
  for i = 1, table.count(msg.list) do
    local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(msg.list[i].configId, "id")
    if msg.list[i].showType == 1 and monster and (table.contains(self.bossTotalType, monster.type) or monster.type == self.monsterType.elite or monster.type == self.monsterType.kalimElite) then
      local obj
      local objCtrl = self:GetBossOrEliteObj(msg.list[i].id, monster.type)
      if not objCtrl then
        if table.contains(self.bossTotalType, monster.type) then
          obj = Instantiate(self.sp_boss.gameObject)
        elseif monster.type == self.monsterType.elite then
          obj = Instantiate(self.sp_elite.gameObject)
        elseif monster.type == self.monsterType.kalimElite then
          obj = Instantiate(self.sp_kalima.gameObject)
        end
        objCtrl = UIControl(obj.transform)
        local headIcon = objCtrl:GetChild("head")
        if headIcon and headIcon.transform ~= nil then
          headIcon:SetColor("0x808080FF")
        else
          objCtrl:SetColor("0x808080FF")
        end
      end
      objCtrl.transform:SetParent(self.monStateParent.transform, false)
      local mapPosX, mapPosY = self:GetMapPosByWorldPos(msg.list[i].x, msg.list[i].y)
      objCtrl.transform:SetAnchoredPosition(mapPosX, mapPosY)
      objCtrl.type = monster.type
      objCtrl.id = msg.list[i].id
      objCtrl:SetActive(msg.list[i].state == 0)
      table.insert(self.monsterStateObj, objCtrl)
    end
  end
end

function Main_MiniMapUI:SetSingleMonsterState(_, msg)
  for i, v in pairs(self.monsterStateObj) do
    if v.id == msg.id then
      v:SetActive(msg.state == 0)
      break
    end
  end
  for i, v in pairs(self:GetMu2ElitePointGoList()) do
    if v and v.goCtrl and v.id == msg.id then
      v.goCtrl:SetActive(msg.state == 1)
      break
    end
  end
end

function Main_MiniMapUI:SetInfo(id, data)
  self:RefreshData()
  self:TransferPosRefresh()
  self:NpcPosRefresh()
  self:HideMonster()
  self:RefreshMonAndElitePos()
  self:ResetInComePoint()
  self:RefreshCirclePointView()
  self:RefreshRouteShow()
  self:UnionFlagPosRefresh()
  self:UnionBoxPosRefresh()
end

function Main_MiniMapUI:RefreshRouteShow()
  local line = SceneData.cline
  self.lab_route:SetText(string.format("K\195\170nh %d", line))
end

function Main_MiniMapUI:HideMonster()
  for i, v in pairs(monsterIdSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(bossIdSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(eliteIdSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(spaceCrackBoxList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(fourPartyRivalryFlagList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(fourPartyRivalryCityGateList) do
    if v then
      v:SetActive(false)
    end
  end
  self:ResetMu2ElitePoint()
end

function Main_MiniMapUI:DoRefreshData(mapName)
  self.isDoSprite = true
  local reqSprite = self:LoadAssetAsync(string.format("Texture/%s.png", mapName), typeof(CS.UnityEngine.Sprite))
  Coroutine.Yield(reqSprite)
  if not reqSprite or reqSprite.isError then
    reqSprite = self:LoadAssetAsync(string.format("Texture/%s.jpg", mapName), typeof(CS.UnityEngine.Sprite))
    Coroutine.Yield(reqSprite)
    if not reqSprite or reqSprite.isError then
      Coroutine.Break()
    end
  end
  if reqSprite.res then
    self.sp_map:SetSprite(reqSprite.res)
    self.nowsp_map = reqSprite.res
    self:RefreshMapDataScale()
  end
  self.isDoSprite = false
end

function Main_MiniMapUI:RefreshData()
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
  if mapTbl == nil then
    if self.logeNowMapID == nil or self.logeNowMapID ~= SceneData.mapId then
      logError("\230\137\190\228\184\141\229\136\176\229\156\176\229\155\190\233\133\141\231\189\174", SceneData.mapId)
      self.logeNowMapID = SceneData.mapId
      if SceneData.mapId == nil then
        self.logeNowMapID = -1
      end
    end
    return
  end
  self.btn_route:SetActive(mapTbl.line ~= 0)
  local name = SceneData.name
  if not table.contains(self.mapGroupId, SceneData.groupId) then
  end
  self.lab_mapName:SetText(name)
  local isShowMapMessage = SceneData.mapId ~= 1095
  self.btn_route:SetActive(isShowMapMessage)
  self.img_bottombg:SetActive(isShowMapMessage)
  self.lab_mapName:SetActive(isShowMapMessage)
  if self.spriteCol then
    Coroutine.Stop(self.spriteCol)
    self.spriteCol = nil
  end
  self.spriteCol = Coroutine.Start(self.DoRefreshData, self, mapTbl.minimap)
end

function Main_MiniMapUI:InitTemplate()
  self.m_MiniMap_KaLunTeVirusCircleTemplate = luaTemplateManager.GetNewTemplate(self.KaLunTeCircleParent, LuaComponentTemplates.OutMiniMapVirusCircleTemplate, self)
end

function Main_MiniMapUI:OpenMapDetail()
  UIManager.Show(UIID.MapDetailUI)
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.ClickOpenMap)
  TipUtility.GetSessionTips()
end

function Main_MiniMapUI:OpenMapChangeUI()
  UIManager.Show(UIID.MapLineChangeUI)
  TipUtility.GetSessionTips()
end

function Main_MiniMapUI:Refresh()
  if SceneData.resName == 1001 then
    self.posOffset = Vector2(-27, 10)
  else
    self.posOffset = Vector2(-8, 5.2)
  end
  self:RefreshData()
  self:TransferPosRefresh()
  self:NpcPosRefresh()
  self:RefreshInComePointView()
  self:RefreshCirclePointView()
  self:RefreshRouteShow()
  self:UnionFlagPosRefresh()
  self:UnionBoxPosRefresh()
  self:ResSpaceCrackMiniMapBox()
  self:RefreshFourPartyRivalryIcon()
  if ForgeData.BossAndEliteStateData then
    self:SetAllMonsterState(nil, ForgeData.BossAndEliteStateData)
    ForgeData.BossAndEliteStateData = nil
  end
  if table.count(ForgeData.BossAndEliteSingleData) > 0 then
    for i = 1, table.count(ForgeData.BossAndEliteSingleData) do
      self:SetSingleMonsterState(nil, ForgeData.BossAndEliteSingleData[i])
    end
    ForgeData.BossAndEliteSingleData = {}
  end
  self:OnKalunteRuinsVirusCircleChange(nil, gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():GetVirusCircle_MiniMap().VirusCircleMiniMapNoticeInfo)
end

local rolePos = Vector2.zero

function Main_MiniMapUI:RoleChangePos(id, data)
  local roleId = data.roleId
  rolePos:Set(data.posX, data.posY)
  local roleType = data.roleType
  local configId = data.configId
  if not roleId or not roleType then
    return
  end
  if roleType == ERoleType.Monster and configId then
    local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(configId, "id")
    if monster and monster.aiType ~= 6 then
      self:RefreshMonsterPosById(roleId, rolePos, monster.name, monster.type)
    end
  end
end

function Main_MiniMapUI:RoleExitView(_, id)
  if id == nil then
    logError("\196\144\195\162y l\195\160 th\195\180ng b\195\161o id l\195\160 nil")
    return
  end
  self:RemoveMonsterSpById(id)
end

function Main_MiniMapUI:RefreshMonsterPosById(id, pos, name, monsterType)
  if monsterType >= self.monsterType.miniMon and monsterType < self.monsterType.maxMon and monsterType ~= self.monsterType.kalimElite then
    if not monsterIdSpList[id] then
      local obj = Instantiate(self.sp_monster.gameObject)
      obj.transform:SetParent(self.monsterPointParent.transform, false)
      local objCtrl = UIControl(obj.transform)
      monsterIdSpList[id] = objCtrl
    end
    if not monsterIdSpList[id]:GetActive() then
      monsterIdSpList[id]:SetActive(true)
    end
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(pos.x, pos.y)
    monsterIdSpList[id].transform:SetAnchoredPosition(mapPosX, mapPosY)
  elseif table.contains(self.bossTotalType, monsterType) then
    if not bossIdSpList[id] then
      local obj = Instantiate(self.sp_boss.gameObject)
      obj.transform:SetParent(self.bossPointParent.transform, false)
      local objCtrl = UIControl(obj.transform)
      objCtrl:GetChild("lab_name"):SetText(name)
      bossIdSpList[id] = objCtrl
    end
    if not bossIdSpList[id]:GetActive() then
      bossIdSpList[id]:SetActive(true)
    end
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(pos.x, pos.y)
    bossIdSpList[id].transform:SetAnchoredPosition(mapPosX, mapPosY)
  elseif monsterType == self.monsterType.elite then
    if not eliteIdSpList[id] then
      local obj = Instantiate(self.sp_elite.gameObject)
      obj.transform:SetParent(self.elitePointParent.transform, false)
      local objCtrl = UIControl(obj.transform)
      objCtrl:GetChild("lab_name"):SetText(name)
      eliteIdSpList[id] = objCtrl
    end
    if not eliteIdSpList[id]:GetActive() then
      eliteIdSpList[id]:SetActive(true)
    end
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(pos.x, pos.y)
    eliteIdSpList[id].transform:SetAnchoredPosition(mapPosX, mapPosY)
  elseif monsterType == self.monsterType.kalimElite then
    self:SetMu2ElitePointObj({
      lid = id,
      monsterPos = pos,
      str = name,
      type = monsterType
    })
  end
end

function Main_MiniMapUI:RemoveMonsterSpById(id)
  if monsterIdSpList[id] then
    monsterIdSpList[id]:SetActive(false)
  elseif bossIdSpList[id] then
    bossIdSpList[id]:SetActive(false)
  elseif eliteIdSpList[id] then
    eliteIdSpList[id]:SetActive(false)
  elseif self:GetMu2EliteIndexById()[id] then
    local obj = self:GetMu2ElitePointGoList()[self:GetMu2EliteIndexById()[id]]
    if obj and obj.goCtrl then
      obj.goCtrl:SetActive(false)
    end
  end
end

function Main_MiniMapUI:RefreshPlayerPosById(id, pos)
  if not playerIdSpList[id] then
    local sp = self:GetPlayerSpFromPool()
    playerIdSpList[id] = sp
  end
  if playerIdSpList[id] then
    local playerSp
    playerSp = playerIdSpList[id]
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(pos.x, pos.y)
    playerSp.transform:SetAnchoredPosition(mapPosX, mapPosY)
  end
end

function Main_MiniMapUI:RefreshNpcPos()
end

function Main_MiniMapUI:RemovePlayerSpById(_, id)
  if playerIdSpList and playerIdSpList[id] then
    local sp = playerIdSpList[id]
    table.insert(playerSpPool, sp)
  end
end

function Main_MiniMapUI:GetMonsterSpFromPool()
  local obj
  obj = Instantiate(self.sp_monster.gameObject)
  obj.transform:SetParent(self.monsterPointParent.transform, false)
  table.insert(monsterSpPool, obj)
end

function Main_MiniMapUI:GetPlayerSpFromPool()
  if table.count(playerSpPool) < 1 then
    local obj
    obj = Instantiate(self.sp_player.gameObject)
    obj.transform:SetParent(self.playerPointParent.transform, false)
    table.insert(playerSpPool, obj)
  end
  local sp = playerSpPool[1]
  table.remove(playerSpPool, 1)
  return sp
end

function Main_MiniMapUI:GetMapPosByWorldPos(posX, posY)
  local tempPosX = posX * mapWidthScale
  local tempPosY = posY * mapHeightScale
  return tempPosX * rotateParam + tempPosY * rotateParam, -tempPosX * rotateParam + tempPosY * rotateParam
end

function Main_MiniMapUI:GetMapPos(posX, posY)
  if tempMePos.x and tempMePos.y then
    local tempPos = Vector2(posX - tempMePos.x, posY - tempMePos.y)
    return tempPos
  end
  return Vector2(-1, -1)
end

function Main_MiniMapUI:RefreshMapDataScale()
  mapWidthScale = self.sp_map.transform.sizeDelta.x / SceneData.width
  mapHeightScale = self.sp_map.transform.sizeDelta.y / SceneData.height
  halfMapSpWidth = self.sp_map.transform.sizeDelta.x * 0.5
  halfMapSpHeight = self.sp_map.transform.sizeDelta.y * 0.5
end

function Main_MiniMapUI:ResetMapSpOffset(scale)
end

function Main_MiniMapUI:UpdateMapSprite(spriteName)
  self.sp_map:SetSprite(spriteName)
end

function Main_MiniMapUI:PlayerDirectionCtrl()
  local angle = RoleManager.me:GetRotation()
  local tempAngle = 0
  angle = angle % 360
  if Mathf.Abs(angle - 360) <= 22.5 or Mathf.Abs(angle) <= 22.5 then
    tempAngle = 90
  end
  if 22.5 >= Mathf.Abs(angle - 45) then
    tempAngle = angle
  end
  if 22.5 >= Mathf.Abs(angle - 90) then
    tempAngle = 0
  end
  if 22.5 >= Mathf.Abs(angle - 135) then
    tempAngle = 450 - angle
  end
  if 22.5 >= Mathf.Abs(angle - 180) then
    tempAngle = 270
  end
  if 22.5 >= Mathf.Abs(angle - 225) then
    tempAngle = angle
  end
  if 22.5 >= Mathf.Abs(angle - 270) then
    tempAngle = 180
  end
  if 22.5 >= Mathf.Abs(angle - 315) then
    tempAngle = 450 - angle
  end
  if angle == 0 then
    tempAngle = 90
  elseif angle == 90 then
    tempAngle = 0
  elseif angle == 180 then
    tempAngle = 270
  elseif angle == 270 then
    tempAngle = 180
  end
  self.mePoint.transform:SetLocalEulerAngles(0, 0, tempAngle)
end

function Main_MiniMapUI:MonsterPosRefresh()
  local index = 1
  for i, v in pairs(newMonsterSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(SceneData.monsterDataList) do
    if not string.isNullOrEmpty(v.position) then
      local obj
      if index > table.count(newMonsterSpList) then
        obj = Instantiate(self.sp_monster.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.monsterPointParent.transform, false)
        table.insert(newMonsterSpList, obj)
      end
      obj = newMonsterSpList[index]
      obj:SetActive(true)
      index = index + 1
      local posArray = string.split(v.position, "#")
      local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
      obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
    end
  end
end

function Main_MiniMapUI:EliteMonsterPosRefresh()
  local index = 1
  for i, v in pairs(eliteSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(SceneData.elitePosDataList) do
    if not string.isNullOrEmpty(v.position) then
      local obj
      if index > table.count(eliteSpList) then
        obj = Instantiate(self.sp_elite.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.elitePointParent.transform, false)
        table.insert(eliteSpList, obj)
      end
      obj = eliteSpList[index]
      local objCtrl = UIControl(obj.transform)
      objCtrl:GetChild("lab_name"):SetText(v.name)
      obj:SetActive(true)
      index = index + 1
      local posArray = string.split(v.position, "#")
      local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
      obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
    end
  end
end

function Main_MiniMapUI:BossPosRefresh()
  local index = 1
  for i, v in pairs(bossSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i, v in pairs(SceneData.bossPosDataList) do
    if not string.isNullOrEmpty(v.position) then
      local obj
      if index > table.count(bossSpList) then
        obj = Instantiate(self.sp_boss.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.bossPointParent.transform, false)
        table.insert(bossSpList, obj)
      end
      obj = bossSpList[index]
      local objCtrl = UIControl(obj.transform)
      objCtrl:GetChild("lab_name"):SetText(v.name)
      obj:SetActive(true)
      index = index + 1
      local posArray = string.split(v.position, "#")
      local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
      obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
    end
  end
end

function Main_MiniMapUI:NpcPosRefresh()
  for i, v in pairs(npcSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
  local data = SceneData.npcPosDataList
  for i, v in pairs(data) do
    local obj
    if index > table.count(npcSpList) then
      obj = Instantiate(self.sp_npc.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.npcPointParent.transform, false)
      table.insert(npcSpList, obj)
    end
    obj = npcSpList[index]
    local objCtrl = UIControl(obj.transform)
    objCtrl:GetChild("lab_name"):SetText(v.name)
    obj:SetActive(true)
    index = index + 1
    local posArray = string.split(v.position, "#")
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
    obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
  end
end

function Main_MiniMapUI:TransferPosRefresh()
  for i, v in pairs(transferSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
  local data = SceneData.transferPosDataList
  if table.count(data) > 0 then
    for i, v in pairs(data) do
      local obj
      if index > table.count(transferSpList) then
        obj = Instantiate(self.sp_transfer.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.transferPointParent.transform, false)
        table.insert(transferSpList, obj)
      end
      obj = transferSpList[index]
      local objCtrl = UIControl(obj.transform)
      objCtrl:GetChild("lab_name"):SetText(v.name)
      obj:SetActive(true)
      index = index + 1
      local posArray = string.split(v.position, "#")
      local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
      obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
    end
  end
end

function Main_MiniMapUI:UnionFlagPosRefresh()
  for i, v in pairs(unionFlagList) do
    if v then
      v:SetActive(false)
    end
  end
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == false then
    return
  end
  local index = 1
  local data = QuickFind:GetDuoQiCrossDataManager():GetCfgOfFlagsMiniMap()
  for i, v in pairs(data) do
    local obj
    if index > table.count(unionFlagList) then
      obj = Instantiate(self.sp_flag.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.duoqiPointParent.transform, false)
      table.insert(unionFlagList, obj)
    end
    obj = unionFlagList[index]
    local objCtrl = UIControl(obj.transform)
    objCtrl:GetChild("lab_name"):SetText(v.name)
    obj:SetActive(true)
    index = index + 1
    local posArray = string.split(v.position, "#")
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(tonumber(posArray[1]) + 0.5, tonumber(posArray[2]) + 0.5)
    obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
    QuickFind:GetDuoQiCrossDataManager():SetMiniMapFlagIconBySubType(obj, v.subType)
  end
end

function Main_MiniMapUI:UnionBoxPosRefresh()
  for i, v in pairs(unionBoxList) do
    if v then
      v:SetActive(false)
    end
  end
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == false then
    return
  end
  local index = 1
  local data = QuickFind:GetDuoQiCrossDataManager():GetBoxMapInfo()
  for i, v in pairs(data) do
    local obj
    if index > table.count(unionBoxList) then
      obj = Instantiate(self.sp_box.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.duoqiPointBoxParent.transform, false)
      table.insert(unionBoxList, obj)
    end
    obj = unionBoxList[index]
    obj:SetActive(true)
    index = index + 1
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    QuickFind:GetDuoQiCrossDataManager():SetMiniBoxIconBySubType(obj, v.subType)
    obj.transform:SetAnchoredPosition(mapPosX, mapPosY)
  end
end

function Main_MiniMapUI:LineMapDataInit()
  self.mapGroupId = {}
  local temp = string.split(GlobalConfig.GetGlobalConfig(3000001), "#")
  for i = 1, table.count(temp) do
    table.insert(self.mapGroupId, tonumber(temp[i]))
  end
end

function Main_MiniMapUI:GetInComePointMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr()
  end
  return nil
end

function Main_MiniMapUI:GetAllInComePointGoList()
  if self.mAllInComePointGoList == nil then
    self.mAllInComePointGoList = {}
  end
  return self.mAllInComePointGoList
end

function Main_MiniMapUI:RefreshInComePointView()
  self:ResetInComePoint()
  if self:GetInComePointMgr() == nil then
    return
  end
  for i, v in pairs(self:GetInComePointMgr():GetInComePointList()) do
    if v and v.state then
      self:SetInComePointObj(v)
    end
  end
end

function Main_MiniMapUI:SetInComePointObj(data)
  local point = self:GetInComePointObj()
  if point == nil then
    return
  end
  local mapPosX, mapPosY = self:GetMapPosByWorldPos(data.x, data.y)
  point.goCtrl.transform:SetAnchoredPosition(mapPosX, mapPosY)
  self:SetSprite("Atlas_Common", self:GetInComePointMgr():GetSpriteNameByType(data.type), point.iconCtrl)
  point.goCtrl:SetActive(true)
end

function Main_MiniMapUI:GetInComePointObj()
  local obj = self:GetAllInComePointGoList()[self.curInComeIndex]
  if obj ~= nil and obj.goCtrl ~= nil and not IsNil(obj.goCtrl.gameObject) then
    self.curInComeIndex = self.curInComeIndex + 1
    return obj
  end
  if obj ~= nil and (obj.goCtrl == nil or IsNil(obj.goCtrl.gameObject)) then
    table.remove(self:GetAllInComePointGoList(), self.curInComeIndex)
  end
  local go = self:CloneInComePointObj()
  if go then
    obj = {}
    local goCtrl = UIControl(go.transform)
    obj.goCtrl = goCtrl
    obj.iconCtrl = goCtrl:GetChild("ico_onHook")
    obj.nameCtrl = goCtrl:GetChild("lab_name")
    table.insert(self:GetAllInComePointGoList(), obj)
  end
  self.curInComeIndex = self.curInComeIndex + 1
  return obj
end

function Main_MiniMapUI:CloneInComePointObj()
  if IsNil(self.sp_onHook.gameObject) or IsNil(self.onHookPointParent.transform) then
    return nil
  end
  local obj = Instantiate(self.sp_onHook.gameObject)
  obj:SetActive(false)
  obj.transform:SetParent(self.onHookPointParent.transform, false)
  return obj
end

function Main_MiniMapUI:ResetInComePoint()
  self.curInComeIndex = 1
  for i, v in pairs(self:GetAllInComePointGoList()) do
    if v and v.goCtrl and not IsNil(v.goCtrl.gameObject) and v.goCtrl.gameObject.activeSelf then
      v.goCtrl:SetActive(false)
    end
  end
end

function Main_MiniMapUI:GetAllCirclePointGoList()
  if self.mAllCirclePointGoList == nil then
    self.mAllCirclePointGoList = {}
  end
  return self.mAllCirclePointGoList
end

function Main_MiniMapUI:RefreshCirclePointView()
  self:ResetCirclePoint()
  for i, v in pairs(SceneData.monsterDataList) do
    if v and v.rangeRing and v.rangeRing ~= 1 then
      self:SetCirclePointObj(v)
    end
  end
end

function Main_MiniMapUI:SetCirclePointObj(data)
  local point = self:GetCirclePointObj()
  if point == nil then
    return
  end
  local posArray = TableParse:SplitStringToIntList(data.position, "#")
  if table.count(posArray) < 2 then
    return
  end
  local mapPosX, mapPosY = self:GetMapPosByWorldPos(posArray[1], posArray[2])
  point.goCtrl.transform:SetAnchoredPosition(mapPosX, mapPosY)
  if point.nameCtrl ~= nil then
    point.nameCtrl:SetText(data.name)
  end
  if point.vipCtrl ~= nil then
    point.vipCtrl:SetText(data.memberName)
  end
  point.goCtrl:SetActive(true)
end

function Main_MiniMapUI:GetCirclePointObj()
  local obj = self:GetAllCirclePointGoList()[self.curCirclePointIndex]
  if obj ~= nil and obj.goCtrl ~= nil and not IsNil(obj.goCtrl.gameObject) then
    self.curCirclePointIndex = self.curCirclePointIndex + 1
    return obj
  end
  if obj ~= nil and (obj.goCtrl == nil or IsNil(obj.goCtrl.gameObject)) then
    table.remove(self:GetAllCirclePointGoList(), self.curCirclePointIndex)
  end
  local go = self:CloneCirclrPointObj()
  if go then
    obj = {}
    local goCtrl = UIControl(go.transform)
    obj.goCtrl = goCtrl
    obj.nameCtrl = goCtrl:GetChild("lab_name")
    obj.vipCtrl = goCtrl:GetChild("lab_vip")
    table.insert(self:GetAllCirclePointGoList(), obj)
  end
  self.curCirclePointIndex = self.curCirclePointIndex + 1
  return obj
end

function Main_MiniMapUI:CloneCirclrPointObj()
  if IsNil(self.sp_circle.gameObject) or IsNil(self.monsterCircleParent.transform) then
    return nil
  end
  local obj = Instantiate(self.sp_circle.gameObject)
  obj:SetActive(false)
  obj.transform:SetParent(self.monsterCircleParent.transform, false)
  return obj
end

function Main_MiniMapUI:ResetCirclePoint()
  self.curCirclePointIndex = 1
  for i, v in pairs(self:GetAllCirclePointGoList()) do
    if v and v.goCtrl and not IsNil(v.goCtrl.gameObject) and v.goCtrl.gameObject.activeSelf then
      v.goCtrl:SetActive(false)
    end
  end
end

function Main_MiniMapUI:GetMu2ElitePointGoList()
  if self.mMu2ElitePointGoList == nil then
    self.mMu2ElitePointGoList = {}
  end
  return self.mMu2ElitePointGoList
end

function Main_MiniMapUI:GetMu2EliteIndexById()
  if self.mMu2EliteIndexById == nil then
    self.mMu2EliteIndexById = {}
  end
  return self.mMu2EliteIndexById
end

function Main_MiniMapUI:RefreshMu2ElitePointView()
end

function Main_MiniMapUI:RefreshMu2ElitePos(id, pos)
  local index = self:GetMu2EliteIndexById()[id]
  if index == nil then
    return
  end
  local obj = self:GetMu2ElitePointGoList()[index]
  if obj and obj.id == id and obj.goCtrl ~= nil then
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(pos.x, pos.y)
    obj.goCtrl.transform:SetAnchoredPosition(mapPosX, mapPosY)
  end
end

function Main_MiniMapUI:SetMu2ElitePointObj(data)
  local point
  local index = self:GetMu2EliteIndexById()[data.lid]
  if index == nil then
    point = self:GetMU2ElitePointObj()
  else
    point = self:GetMu2ElitePointGoList()[index]
  end
  if point == nil then
    return
  end
  local mapPosX, mapPosY = self:GetMapPosByWorldPos(data.monsterPos.x, data.monsterPos.y)
  point.goCtrl.transform:SetAnchoredPosition(mapPosX, mapPosY)
  point.goCtrl:SetActive(true)
  if index == nil then
    point.lid = data.id
    self.mMu2EliteIndexById[data.lid] = curEliteIndex - 1
  end
end

function Main_MiniMapUI:GetMU2ElitePointObj()
  local obj = self:GetMu2ElitePointGoList()[curEliteIndex]
  if obj ~= nil and obj.goCtrl ~= nil and not IsNil(obj.goCtrl.gameObject) then
    curEliteIndex = curEliteIndex + 1
    return obj
  end
  if obj ~= nil and (obj.goCtrl == nil or IsNil(obj.goCtrl.gameObject)) then
    table.remove(self:GetMu2ElitePointGoList(), curEliteIndex)
  end
  local go = self:CloneMu2ElitePointObj()
  if go then
    obj = {}
    local goCtrl = UIControl(go.transform)
    obj.goCtrl = goCtrl
    obj.iconCtrl = goCtrl
    table.insert(self:GetMu2ElitePointGoList(), obj)
  end
  curEliteIndex = curEliteIndex + 1
  return obj
end

function Main_MiniMapUI:CloneMu2ElitePointObj()
  if IsNil(self.sp_kalima.gameObject) or IsNil(self.sp_kalima.transform) then
    return nil
  end
  local obj = Instantiate(self.sp_kalima.gameObject)
  obj:SetActive(true)
  obj.transform:SetParent(self.elitePointParent.transform, false)
  return obj
end

function Main_MiniMapUI:ResetMu2ElitePoint()
  curEliteIndex = 1
  for i, v in pairs(self:GetMu2ElitePointGoList()) do
    if v and v.goCtrl and not IsNil(v.goCtrl.gameObject) and v.goCtrl.gameObject.activeSelf then
      v.id = 0
      v.goCtrl:SetActive(false)
    end
  end
  self.mMu2EliteIndexById = {}
end

function Main_MiniMapUI:OnKalunteRuinsVirusCircleChange(id, data)
  self.m_MiniMap_KaLunTeVirusCircleTemplate:Refresh(data)
end

function Main_MiniMapUI:OnKalunteRuinsExit()
  self.m_MiniMap_KaLunTeVirusCircleTemplate:Exit()
end

function Main_MiniMapUI:OnMonsterEnterView(id, data)
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.configId)
  if monsterConfig == nil or monsterConfig.aiType == 6 then
    return
  end
  self:RefreshBuffEffect(data.id, monsterConfig.type)
end

function Main_MiniMapUI:OnMonstersEnterView(id, data)
  if type(data) ~= "table" or next(data) == nil then
    return
  end
  for k, v in pairs(data) do
    self:OnMonsterEnterView(id, v)
  end
end

function Main_MiniMapUI:RefreshBuffEffect(id, monsterType)
  local pointUIControl = self:GetPointControl(id, monsterType)
  if pointUIControl == nil then
    return
  end
  local monster, buffConfigList = gameMgr:GetAvatarManager():GetAvatar(AvatarEnum.Monster, id)
  if monster and monster:GetInfo().GetMapBuffs then
    buffConfigList = monster:GetInfo():GetShowMiniMapBuffs()
  end
  if pointUIControl.buffContainer == nil and (buffConfigList == nil or next(buffConfigList) == nil) then
    return
  end
  if pointUIControl.buffContainer == nil then
    local buff = pointUIControl:GetChild("buffs/buff")
    if buff == nil then
      return
    end
    pointUIControl.buffContainer = UIUtility.BindUIContainerTemp(buff, LuaComponentTemplates.MapBuffTemplate, self, MapPointBuffRefreshType.MINIMAP)
  end
  if pointUIControl.buffContainer == nil then
    return
  end
  pointUIControl.buffContainer:SetData(buffConfigList)
end

function Main_MiniMapUI:GetPointControl(id, monsterType)
  if id == nil or monsterType == nil then
    return
  end
  if monsterType >= self.monsterType.miniMon and monsterType < self.monsterType.maxMon and monsterType ~= self.monsterType.kalimElite then
    return monsterIdSpList[id]
  elseif monsterType and self.bossTotalType and table.contains(self.bossTotalType, monsterType) then
    return bossIdSpList[id]
  elseif monsterType == self.monsterType.elite then
    return eliteIdSpList[id]
  elseif monsterType == self.monsterType.kalimElite then
    local index = self:GetMu2EliteIndexById()[id]
    if index then
      return self:GetMu2ElitePointGoList()[index]
    end
  end
end

function Main_MiniMapUI:OnLogOut()
  self.m_MiniMap_KaLunTeVirusCircleTemplate:LogOut()
end

function Main_MiniMapUI:ResSpaceCrackMiniMapBox()
  for i, v in pairs(spaceCrackBoxList) do
    if v then
      v:SetActive(false)
    end
  end
  if not SpaceCrackUtility:CheckInSpaceCrackMap(SceneData.mapId) then
    return
  end
  local index = 1
  local mapBoxData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackMiniMapBoxInfoData
  if mapBoxData == nil or next(mapBoxData) == nil then
    return
  end
  for i, v in pairs(mapBoxData) do
    local item
    if index > table.count(spaceCrackBoxList) then
      local obj = Instantiate(self.spaceCrackBoxSp_box.gameObject)
      item = UIControl(obj.transform)
      item:SetActive(true)
      item.transform:SetParent(self.SpaceCrackBoxParent.transform, false)
      table.insert(spaceCrackBoxList, item)
    end
    item = spaceCrackBoxList[index]
    item:SetActive(true)
    index = index + 1
    QuickFind:GetSpaceCrackDataManager():SetMiniMapBox(item.transform.gameObject, v.boxId)
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    item:SetAnchoredPosition(mapPosX, mapPosY)
  end
end

function Main_MiniMapUI:RefreshFourPartyRivalryIcon()
  self:RefreshFourPartyRivalryFlag()
  self:RefreshFourPartyRivalryCityGate()
  self:RefreshFourPartyRivalryThrone()
end

function Main_MiniMapUI:RefreshFourPartyRivalryFlag()
  for i, v in pairs(fourPartyRivalryFlagList) do
    if v then
      v:SetActive(false)
    end
  end
  if not FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    return
  end
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil or table.count(fourPartyRivalryActivityInfo.flagList) == 0 then
    return
  end
  local index = 1
  for i, v in pairs(fourPartyRivalryActivityInfo.flagList) do
    local item
    if index > table.count(fourPartyRivalryFlagList) then
      local obj = Instantiate(self.fourPartyRivalryFlagItem.gameObject)
      item = UIControl(obj.transform)
      item:SetActive(true)
      item.transform:SetParent(self.fourPartyRivalryFlagParent.transform, false)
      table.insert(fourPartyRivalryFlagList, item)
    end
    item = fourPartyRivalryFlagList[index]
    item:SetActive(true)
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    item:SetAnchoredPosition(mapPosX, mapPosY)
    local config = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(v.campId)
    local myCampId = QuickFind:GetSiFangZhengBaDataManager():GetMyUnionId()
    if config then
      item:GetChild("lab_Name"):SetText(config.unionName)
      item:GetChild("lab_Name"):SetColor(v.campId == myCampId and EUIColor.Green or EUIColor.Red)
    else
      item:GetChild("lab_Name"):SetText("")
    end
    index = index + 1
  end
end

function Main_MiniMapUI:RefreshFourPartyRivalryCityGate()
  for i, v in pairs(fourPartyRivalryCityGateList) do
    if v then
      v:SetActive(false)
    end
  end
  if not FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    return
  end
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil or table.count(fourPartyRivalryActivityInfo.doorList) == 0 then
    return
  end
  local index = 1
  for i, v in pairs(fourPartyRivalryActivityInfo.doorList) do
    local item
    if index > table.count(fourPartyRivalryCityGateList) then
      local obj = Instantiate(self.fourPartyRivalryCityGateItem.gameObject)
      item = UIControl(obj.transform)
      item:SetActive(true)
      item.transform:SetParent(self.fourPartyRivalryCityGateParent.transform, false)
      table.insert(fourPartyRivalryCityGateList, item)
    end
    item = fourPartyRivalryCityGateList[index]
    item:SetActive(true)
    local mapPosX, mapPosY = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    item:SetAnchoredPosition(mapPosX, mapPosY)
    item:GetChild("img_CityGate"):SetColor(v.status == 0 and "0xFFFFFFFF" or "0x808080FF")
    index = index + 1
  end
end

function Main_MiniMapUI:RefreshFourPartyRivalryThrone()
  self.fourPartyRivalryThroneItem:SetActive(false)
  if not FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    return
  end
  local fourPartyRivalryActivityInfo = FourPartyRivalryManager.m_FourPartyRivalryActivityInfo
  if fourPartyRivalryActivityInfo == nil or fourPartyRivalryActivityInfo.campId == nil then
    return
  end
  self.fourPartyRivalryThroneItem:SetActive(true)
  local config = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(fourPartyRivalryActivityInfo.campId)
  if config then
    self.fourPartyRivalryThroneItem:GetChild("lab_Name"):SetText(config.unionName)
    local myCampId = QuickFind:GetSiFangZhengBaDataManager():GetMyUnionId()
    self.fourPartyRivalryThroneItem:GetChild("lab_Name"):SetColor(fourPartyRivalryActivityInfo.campId == myCampId and EUIColor.Green or EUIColor.Red)
  else
    self.fourPartyRivalryThroneItem:GetChild("lab_Name"):SetText("")
  end
end

Main_MapDetailUI = class(BaseUI)
Main_MapDetailUI.layer = UILayer.Panel
Main_MapDetailUI.orderInLayer = 0
Main_MapDetailUI.hideType = UIHideType.WaitDestroy
Main_MapDetailUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MapDetailUI.escClose = UIEscClose.DontClose

function Main_MapDetailUI:InitControls()
  self.descBtn = self:GetControl("descBtn")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.panel_map = self:GetControl("panel_map")
  self.luoLanInfo = self:GetControl("sv_information/Viewport/Content/luoLanInfo")
  self.sp_map = self:GetControl("sp_mapParent/sp_map")
  self.pathPointParent = self:GetControl("sp_mapParent/sp_map/pathPointParent")
  self.sp_path = self:GetControl("sp_mapParent/sp_map/pathPointParent/sp_path")
  self.sp_pathEndPoint = self:GetControl("sp_mapParent/sp_map/pathPointParent/sp_pathEndPoint")
  self.monsterPointParent = self:GetControl("sp_mapParent/sp_map/monsterPointParent")
  self.sp_monster = self:GetControl("sp_mapParent/sp_map/monsterPointParent/sp_monster")
  self.transferPointParent = self:GetControl("sp_mapParent/sp_map/transferPointParent")
  self.sp_transfer = self:GetControl("sp_mapParent/sp_map/transferPointParent/sp_transfer")
  self.npcPointParent = self:GetControl("sp_mapParent/sp_map/npcPointParent")
  self.sp_npc = self:GetControl("sp_mapParent/sp_map/npcPointParent/sp_npc")
  self.playerPointParent = self:GetControl("sp_mapParent/sp_map/playerPointParent")
  self.sp_player = self:GetControl("sp_mapParent/sp_map/playerPointParent/sp_player")
  self.stonePointParent = self:GetControl("sp_mapParent/sp_map/stonePointParent")
  self.sp_stone = self:GetControl("sp_mapParent/sp_map/stonePointParent/sp_stone")
  self.doorPointParent = self:GetControl("sp_mapParent/sp_map/doorPointParent")
  self.sp_door = self:GetControl("sp_mapParent/sp_map/doorPointParent/sp_door")
  self.elitePointParent = self:GetControl("sp_mapParent/sp_map/elitePointParent")
  self.sp_elite = self:GetControl("sp_mapParent/sp_map/elitePointParent/sp_elite")
  self.bossPointParent = self:GetControl("sp_mapParent/sp_map/bossPointParent")
  self.sp_boss = self:GetControl("sp_mapParent/sp_map/bossPointParent/sp_boss")
  self.mePoint = self:GetControl("sp_mapParent/sp_map/mePoint")
  self.onHookPointParent = self:GetControl("sp_mapParent/sp_map/onHookPointParent")
  self.sp_onHook = self:GetControl("sp_mapParent/sp_map/onHookPointParent/sp_onHook")
  self.universalPointParent = self:GetControl("sp_mapParent/sp_map/universalPointParent")
  self.sp_universalPoint = self:GetControl("sp_mapParent/sp_map/universalPointParent/sp_universalPoint")
  self.KaLunTeCircleParent = self:GetControl("sp_mapParent/sp_map/KaLunTeCircleParent")
  self.change_price = self:GetControl("ctrMap/change_price")
  self.lab_name = self:GetControl("lab_name")
  self.lab_lineTxt = self:GetControl("btn_line/lab_lineTxt")
  self.btn_close = self:GetControl("btn_close")
  self.lab_scale = self:GetControl("lab_scale")
  self.btn_Increase = self:GetControl("btn_Increase")
  self.btn_Reduce = self:GetControl("btn_Reduce")
  self.mapTeleport = self:GetControl("mapTeleport")
  self.mapExpTeleport = self:GetControl("mapExpTeleport")
  self.rightPanel = self:GetControl("rightPanel")
  self.onHook = self:GetControl("rightPanel/Viewport/group/onHook")
  self.bossLocation = self:GetControl("rightPanel/Viewport/group/bossLocation")
  self.txt_nextExpDes = self:GetControl("rightPanel/txt_nextExpDes")
  self.btn_shrink_left = self:GetControl("btn_shrink_left")
  self.btn_shrink_right = self:GetControl("btn_shrink_right")
  self.btn_transfer = self:GetControl("btn_transfer")
  self.KaLunTeCircleParent = self:GetControl("sp_mapParent/sp_map/KaLunTeCircleParent")
  self.duoqiPointParent = self:GetControl("sp_mapParent/sp_map/duoqiPointParent")
  self.sp_flag = self:GetControl("sp_mapParent/sp_map/duoqiPointParent/sp_flag")
  self.spaceCrackBoxParent = self:GetControl("sp_mapParent/sp_map/spaceCrackBoxParent")
  self.spaceCrackBoxSp_box = self:GetControl("sp_mapParent/sp_map/spaceCrackBoxParent/sp_flag")
  self.fourPartyRivalryFlagParent = self:GetControl("sp_mapParent/sp_map/fourPartyRivalryParent/flagParent")
  self.fourPartyRivalryFlagItem = self:GetControl("sp_mapParent/sp_map/fourPartyRivalryParent/flagParent/itemFlag")
  self.fourPartyRivalryCityGateParent = self:GetControl("sp_mapParent/sp_map/fourPartyRivalryParent/cityGateParent")
  self.fourPartyRivalryCityGateItem = self:GetControl("sp_mapParent/sp_map/fourPartyRivalryParent/cityGateParent/itemCityGate")
  self.fourPartyRivalryThroneItem = self:GetControl("sp_mapParent/sp_map/fourPartyRivalryParent/throneParent/itemThrone")
end

local mapWidthScale, mapHeightScale, halfMapSpWidth, halfMapSpHeight
local pathPointSpList = {}
local monsterSpPool = {}
local monsterIdSpList = {}
local playerSpPool = {}
local playerIdSpList = {}
local npcSpList = {}
local transferSpList = {}
local bossSpList = {}
local eliteSpList = {}
local monsterSpList = {}
local unionFlagList = {}
local spaceCrackBoxList = {}
local monObjTab = {}
local serverBossSpList = {}
local fourPartyRivalryFlagList = {}
local fourPartyRivalryCityGateList = {}

function Main_MapDetailUI:Init()
  self.transItemId = 20000022
  self.curMapScale = 1
  self.stoneMonObjTab = {}
  self.doorMonObjTab = {}
  self.mapExpTeleportTemplate = nil
  self.mapTeleportTemplate = nil
  self.bossLocationTemplate = nil
  self.onHookTemplate = nil
  self.haveMapExpTeleport = false
end

function Main_MapDetailUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_MapDetailUI:InitUI()
  if self.change_price and self.change_price.slider then
    self.sliderMaxValue = self.change_price.slider.maxValue
    self.sliderMinValue = self.change_price.slider.minValue
  end
  self.m_MiniMap_KaLunTeVirusCircleTemplate = luaTemplateManager.GetNewTemplate(self.KaLunTeCircleParent, LuaComponentTemplates.MiniMap_KaLunTeVirusCircle, self)
end

function Main_MapDetailUI:OnShow()
  self:RegistEvents()
  NetManager.Send(MapMessage.ReqBossIcon)
  self:RefreshData(SceneData.mapId, SceneData.name)
  self:ResetData()
  self:Refresh()
  local path = RoleManager.me.movePath
  if path and table.count(path) > 3 then
    local endPoint = path[table.count(path)]
    self.sp_pathEndPoint.transform.anchoredPosition = Vector2(endPoint.x / mapWidthScale, endPoint.y / mapHeightScale)
    self:RefreshMovePath(path, RoleManager.me.pathIndex)
  end
  self:UpdateMePos()
  self.haveMapExpTeleport = self:RefreshMapExpTeleport()
  self:RefreshMapTeleport()
  self:SetMapTeleport()
  local haveBossLocation = self:RefreshBossLocation()
  local haveOnHook = self:RefreshOnHook()
  self.rightPanel:SetNormalizedPosition(1, 1)
  self:ShrinkRight(not haveBossLocation and not haveOnHook)
  self:ShrinkLeft(false)
  self:RefreshSpMapPosByMainPlayerPos()
  self:SetNextExpDes()
  networkRequest.ReqTeamMatePosition()
  self:ReqUniversalPointMsg()
  self:OnKalunteRuinsVirusCircleChange(nil, gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager():GetVirusCircle_MiniMap().VirusCircleMiniMapNoticeInfo)
  local isInUnionMap = QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() or FourPartyRivalryManager:IsEnterFourPartyRivalryMap()
  self:HideMapList(isInUnionMap)
  self:RefreshFourPartyRivalryIcon()
end

function Main_MapDetailUI:OnHide()
  self:ClearPath()
  if self.dropdownList then
    self.dropdownList:CloseAll()
  end
  self:ResetAllUniversalPoint()
  if self.spriteCol then
    Coroutine.Stop(self.spriteCol)
    self.spriteCol = nil
  end
end

function Main_MapDetailUI:OnDestroy()
  pathPointSpList = {}
  monsterSpPool = {}
  monsterIdSpList = {}
  playerSpPool = {}
  playerIdSpList = {}
  npcSpList = {}
  transferSpList = {}
  bossSpList = {}
  eliteSpList = {}
  monsterSpList = {}
  serverBossSpList = {}
  self:ResetMu2ElitePoint()
end

function Main_MapDetailUI:Update()
  if self.isNeedMove and RoleManager.me and RoleManager.me:CanMove() then
    self.isNeedMove = false
    self:ShowMovePathByWorldPos(self.movePos, self.moveStopRange, self.moveOnEndMove)
  end
  if self.isSetTransfer and self.btn_transfer.go_model.transform.childCount > 0 then
    self.isSetTransfer = false
    local count = BagInfoData.GetItemTotalCountByItemId(self.transItemId)
    if count == 0 then
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(3).gameObject:SetActive(false)
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(4).gameObject:SetActive(false)
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(5).gameObject:SetActive(true)
    else
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(3).gameObject:SetActive(true)
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(4).gameObject:SetActive(true)
      self.btn_transfer.transform:GetChild("go_model"):GetChild("Eff_UI_sealmove"):GetChild(5).gameObject:SetActive(false)
    end
  end
  if (self.sp_map.image.sprite == nil or self.nowsp_map ~= self.sp_map.image.sprite) and not self.isDoSprite then
    self:RefreshData()
  end
end

function Main_MapDetailUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.sp_map:SetOnBeginDrag(self, self.sp_mapOnBeginDrag)
  self.sp_map:SetOnDrag(self, self.sp_mapOnDrag)
  self.sp_map:SetOnPointerDown(self, self.sp_mapPointerDownClick)
  self.sp_map:SetOnPointerUp(self, self.sp_mapPointerUpClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_Increase:SetOnClick(self, self.OnClickBtnIncrease)
  self.btn_Reduce:SetOnClick(self, self.OnClickBtnReduce)
  self.btn_transfer:SetOnClick(self, self.OnClickItemTransfer)
  self.change_price:SetOnSliderValueChanged(self, self.BtnSucItemSliderChange)
  self.btn_shrink_right:SetOnClick(self, self.OnClickBtnShrinkRight)
  self.btn_shrink_left:SetOnClick(self, self.OnClickBtnShrinkLeft)
end

function Main_MapDetailUI:BtnSucItemSliderChange(control, value)
  self.curMapScale = self.cfgSpMapScale + value * 0.1 - 1
  self.sp_map.transform:SetLocalScale(self.curMapScale)
  self.sp_map.transform.position = self.cfgSpMapPos
  self.childScale = 1 / self.curMapScale
  self.mePoint:SetLocalScale(self.childScale)
  for i, ctrl in pairs(pathPointSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(monsterSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
    local nameCtrl = UIControl(ctrl.transform, "lab_name")
    nameCtrl:SetActive(self.curMapScale >= 2)
  end
  for i, ctrl in pairs(transferSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(npcSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(bossSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(serverBossSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(eliteSpList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(unionFlagList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(spaceCrackBoxList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(self.stoneMonObjTab) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(self.doorMonObjTab) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, v in pairs(self:GetAllInComePointGoList()) do
    if v.goCtrl then
      v.goCtrl.transform:SetLocalScale(self.childScale)
    end
  end
  for i, v in pairs(self:GetMu2ElitePointGoList()) do
    if v.goCtrl then
      v.goCtrl.transform:SetLocalScale(self.childScale)
    end
  end
  for i, v in pairs(self:GetMu2ElitePointGoList()) do
    if v.goCtrl then
      v.goCtrl.transform:SetLocalScale(self.childScale)
    end
  end
  for i, ctrl in pairs(fourPartyRivalryFlagList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  for i, ctrl in pairs(fourPartyRivalryCityGateList) do
    ctrl.transform:SetLocalScale(self.childScale)
  end
  self:RefreshAllUniversalPointSize()
  self.lab_scale:SetText(string.format("%d%%", value * 10))
end

function Main_MapDetailUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.MapDetailUI)
end

function Main_MapDetailUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Main_MapDetailUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

local maxX, minX, maxY, minY = 0, 0, 0, 0

function Main_MapDetailUI:sp_mapOnBeginDrag(control, eventData)
  self.dragOffsetPos = self.sp_map.transform.position - eventData.pressEventCamera:ScreenToWorldPoint(Vector2(eventData.position.x, eventData.position.y, self.sp_map.transform.position.z))
  local offset = 4
  maxX = self.cfgSpMapPos.x + (self.curMapScale - self.cfgSpMapScale) * offset
  minX = self.cfgSpMapPos.x - (self.curMapScale - self.cfgSpMapScale) * offset
  maxY = self.cfgSpMapPos.y + (self.curMapScale - self.cfgSpMapScale) * offset
  minY = self.cfgSpMapPos.y - (self.curMapScale - self.cfgSpMapScale) * offset
end

function Main_MapDetailUI:sp_mapOnDrag(control, eventData)
  self.isPathMoveClick = false
  local pos = eventData.pressEventCamera:ScreenToWorldPoint(Vector2(eventData.position.x, eventData.position.y, self.sp_map.transform.position.z))
  local pos = pos + self.dragOffsetPos
  if pos.x > maxX then
    pos.x = maxX
  end
  if pos.x < minX then
    pos.x = minX
  end
  if pos.y > maxY then
    pos.y = maxY
  end
  if pos.y < minY then
    pos.y = minY
  end
  self.sp_map.transform.position = pos
end

function Main_MapDetailUI:sp_mapPointerDownClick(control, eventData)
  self.isPathMoveClick = true
end

function Main_MapDetailUI:sp_mapPointerUpClick(control, eventData)
  if not self.isPathMoveClick then
    return
  end
  if not mapWidthScale or not mapHeightScale then
    self:RefreshMapDataScale()
  end
  self.target = self.sp_pathEndPoint
  self.target.transform.position = eventData.pressEventCamera:ScreenToWorldPoint(Vector3(eventData.position.x, eventData.position.y, self.sp_map.transform.position.z))
  local y = self.target.transform.anchoredPosition.y
  local x = self.target.transform.anchoredPosition.x
  self.sp_pathEndPoint.transform.anchoredPosition = Vector2(x, y)
  local pointPos = Vector3(x / mapWidthScale, 0, y / mapHeightScale)
  self:ShowMovePathByWorldPos(pointPos, nil, function()
    if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
      UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
    end
  end)
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    EventManager.Dispatch(Event.FlyShoeRefresh)
  else
    UIManager.Show(UIID.FlyShoe_FlyShoeUI)
  end
end

function Main_MapDetailUI:UpdateMovePaths(id, data)
  self:UpdateMePos()
  local pos = Vector2Int(RoleManager.me:GetPosition().x, RoleManager.me:GetPosition().z)
  if table.count(self.pathCopyObj) > 0 and Vector2.Distance(pos, self.pathCopyObj[1].position) <= 8 and self.pathCopyObj[1]:GetActive() then
    self.pathCopyObj[1]:SetActive(false)
    table.remove(self.pathCopyObj, 1)
  end
  self:PlayerDirectionCtrl()
end

function Main_MapDetailUI:UpdateMePos()
  local curPos = Vector2(RoleManager.me:GetPosition().x * mapWidthScale, RoleManager.me:GetPosition().z * mapHeightScale)
  self.mePoint.transform.anchoredPosition = curPos
  return curPos
end

function Main_MapDetailUI:ShowMovePathByWorldPos(pos, stopRange, onEndMove)
  if not pos then
    return
  end
  self.isNeedMove = false
  RoleManager.me:SetAutoFight(AutoFightStrKey.None)
  self:ClearPath()
  RiskSpotManager.RiskSpotPlaceType(RiskSpotType.ClickMapPos)
  if RoleManager.me and RoleManager.me:CanMove() then
    EventManager.Dispatch(Event.Map_RealOperation)
    local path = RoleManager.me:MoveTo(Scene.GetCellByPos(pos), stopRange, function(moveStatus)
      if onEndMove ~= nil then
        onEndMove(moveStatus)
      end
      self:ClearPath()
    end)
    EventManager.Dispatch(Event.CloseKillMonsterCard)
    if path then
      self:RefreshMovePath(path)
    else
    end
    PathFinderManager.pathfindingRecord.type = PathMoveType.MapClick
    PathFinderManager.pathfindingRecord.pos = Scene.GetCellByPos(pos)
  else
    self.isNeedMove = true
    self.movePos = pos
    self.moveStopRange = stopRange
    self.moveOnEndMove = onEndMove
  end
end

function Main_MapDetailUI:RegistEvents()
  self:RegistEvent(Event.Scene_SceneLoaded, self.SetInfo, self)
  self:RegistEvent(Event.Role_OnMove, self.UpdateMovePaths, self)
  self:RegistEvent(Event.Map_BossAndElite, self.OnRefreshBossState, self)
  self:RegistEvent(Event.Map_PathChange, self.AutoPathChangeRefresh, self)
  self:RegistEvent(Event.SetCoerceGuide, self.SetDropdownMove, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetTransferItemCount, self)
  self:RegistEvent(Event.InComePointDataChanged, self.RefreshInComePointView, self)
  self:RegistEvent(Event.UniversalPointDataChanged, self.UniversalPointDataChangedCallBack, self)
  self:RegistEvent(Event.KalunteRuinsVirusCircleChange, self.OnKalunteRuinsVirusCircleChange, self)
  self:RegistEvent(Event.KalunteRuinsExit, self.OnKalunteRuinsExit, self)
  self:RegistEvent(Event.ServerMonsterPointChange, self.OnServerMonsterPointChange, self)
  self:RegistEvent(Event.ServerSingleMonsterPointChange, self.OnServerSingleMonsterPointChange, self)
  self:RegistEvent(Event.ResUnionInfo, self.RefreshUnionFlagIcon, self)
  self:RegistEvent(Event.ResSpaceCrackMiniMapBox, self.ResSpaceCrackMiniMapBox, self)
  self:RegistEvent(Event.ResFourPartyRivalryActivityInfo, self.RefreshFourPartyRivalryIcon, self)
end

function Main_MapDetailUI:Refresh()
  self:SetTransferItemCount()
  self:ShowStoneMon()
  self.change_price:SetValue(10)
  local Main_MapDetailUI_SETSCALE = PlayerPrefs.GetInt(Main_MapDetailUI.Main_MapDetailUI_SETSCALE, 0)
  if Main_MapDetailUI_SETSCALE ~= nil and s_SETSCALE ~= 0 then
    self.change_price:SetValue(Main_MapDetailUI_SETSCALE)
  else
    self.change_price:SetValue(30)
  end
  self:PlayerDirectionCtrl()
  local line = SceneData.cline
  self.lab_lineTxt:SetText(string.format("%s %s", SceneData.name, string.GetColorText(string.format("[Tuy\225\186\191n %d]", line), "#FFF0C6")))
end

function Main_MapDetailUI:SetInfo(id, data)
  self:RefreshData(SceneData.mapId, SceneData.name)
end

function Main_MapDetailUI:AutoPathChangeRefresh(_, path)
  self:ClearPath()
  self:RefreshMovePath(path)
end

function Main_MapDetailUI:SetDropdownMove(_, isCanMove)
  isCanMove = not isCanMove
  if self.dropdownItemRoot and self.dropdownItemRoot.childScrollView.scrollRect.vertical ~= isCanMove then
    self.dropdownItemRoot.childScrollView.scrollRect.vertical = isCanMove
  end
end

function Main_MapDetailUI:DoRefreshData(mapName)
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
  end
  self.isDoSprite = false
end

function Main_MapDetailUI:RefreshData(mapId, name)
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
  if not string.isNullOrEmpty(mapTbl.position) and not string.isNullOrEmpty(mapTbl.scale) then
    local position, scale = self:GetWidthHeightAndScale(mapTbl.position, mapTbl.scale)
    self.sp_map.transform.anchoredPosition = position
    self.sp_map.transform:SetLocalScale(scale)
    self.childScale = 1 / scale
    self.curMapScale = scale
    self.cfgSpMapScale = scale
    self.cfgOffset = position
  else
    self.sp_map.transform.anchoredPosition = Vector2(12, 0)
    self.sp_map.transform:SetLocalScale(1)
    self.childScale = 1
    self.curMapScale = 1
    self.cfgSpMapScale = 1
    self.cfgOffset = nil
  end
  self.cfgSpMapPos = self.sp_map.transform.position
  self.mePoint:SetLocalScale(self.childScale)
  self.lab_name:SetText(name)
  self:ResetInComePoint()
  if self.spriteCol then
    Coroutine.Stop(self.spriteCol)
    self.spriteCol = nil
  end
  self.spriteCol = Coroutine.Start(self.DoRefreshData, self, mapTbl.minimap)
end

function Main_MapDetailUI:ResetData()
  self:RefreshMapDataScale()
  self:RefreshIcons()
  self:ClearPath()
  self:ClearMonsterSps()
  self:ClearPlayerSps()
end

function Main_MapDetailUI:ClearPath()
  for i, v in pairs(pathPointSpList) do
    if v then
      v:SetActive(false)
    end
  end
end

function Main_MapDetailUI:RefreshMovePath(path, pathIndex)
  if not path or table.count(path) < 3 then
    return
  end
  self.pathCopyObj = {}
  local index = 1
  for i = pathIndex or 3, table.count(path) - 1, 5 do
    local objCtrl
    if index > table.count(pathPointSpList) then
      local obj = Instantiate(self.sp_path.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.pathPointParent.transform, false)
      objCtrl = UIControl(obj.transform)
      objCtrl.position = path[i]
      table.insert(pathPointSpList, objCtrl)
    else
      objCtrl = pathPointSpList[index]
      objCtrl.position = path[i]
    end
    index = index + 1
    objCtrl:SetActive(true)
    table.insert(self.pathCopyObj, objCtrl)
    local pos = Scene.GetPosByCell(path[i])
    objCtrl.transform.anchoredPosition = Vector2(pos.x * mapWidthScale, pos.z * mapHeightScale)
    objCtrl:SetLocalScale(self.childScale)
  end
end

function Main_MapDetailUI:RefreshIcons()
  self:RefreshBossIcon(SceneData.bossPosDataList)
  self:RefreshEliteIcon(SceneData.elitePosDataList)
  self:RefreshNpcIcon(SceneData.npcPosDataList)
  self:RefreshTransferIcon(SceneData.transferPosDataList)
  self:RefreshMonsterIcon(SceneData.monsterDataList)
  self:RefreshMu2ElitePointView()
  self:RefreshInComePointView()
  self:RefreshServerMonsterPoint()
  self:RefreshUnionFlagIcon()
  self:ResSpaceCrackMiniMapBox()
end

function Main_MapDetailUI:RefreshMonsterIcon(data)
  GuideUtility.ClearAssignUIData("Main_MapDetailUImouster")
  for i, v in pairs(monsterSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
  for i, v in pairs(data) do
    if v and not string.isNullOrEmpty(v.position) then
      local obj
      if index > table.count(monsterSpList) then
        obj = Instantiate(self.sp_monster.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.monsterPointParent.transform, false)
        table.insert(monsterSpList, obj)
      end
      obj = monsterSpList[index]
      obj:SetActive(true)
      obj.transform.anchoredPosition = self:GetMapPosByString(v.position)
      local objCtrl = UIControl(obj.transform)
      objCtrl:SetLocalScale(self.childScale)
      objCtrl:GetChild("lab_name"):SetText(v.name)
      objCtrl:GetChild("lab_vip"):SetText(v.memberName)
      if string.isNullOrEmpty(v.point) then
        self:SetSprite("Atlas_Common", "ico_shuaguaidian", objCtrl)
      else
        self:SetSprite("Atlas_Common", v.point, objCtrl)
      end
      index = index + 1
    end
  end
  for i = table.count(data), 1, -1 do
    if string.isNullOrEmpty(data[i].position) then
      table.remove(data, i)
    end
  end
end

function Main_MapDetailUI:RefreshNpcIcon(data)
  for i, v in pairs(npcSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
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
    if string.isNullOrEmpty(v.point) then
      self:SetSprite("Atlas_Common", "ico_npc", objCtrl, true)
    else
      self:SetSprite("Atlas_Common", v.point, objCtrl, true)
    end
    obj:SetActive(true)
    index = index + 1
    obj.transform.anchoredPosition = self:GetMapPosByString(v.position)
    objCtrl:SetLocalScale(self.childScale)
  end
end

function Main_MapDetailUI:RefreshBossIcon(data)
  for i, v in pairs(bossSpList) do
    if v then
      v:SetActive(false)
    end
  end
  for i = 1, table.count(data) do
    local obj
    if i > table.count(bossSpList) then
      obj = Instantiate(self.sp_boss.gameObject)
      obj:SetActive(false)
      obj.transform:SetParent(self.bossPointParent.transform, false)
      table.insert(bossSpList, obj)
    end
    if data[i].bigMapHolyBeastNotDisplay == 0 then
      obj = bossSpList[i]
      local objCtrl = UIControl(obj.transform)
      local name = data[i].name
      local cfgMon = ClientTable.cfg_Monster_monsterManager:TryGetValue(data[i].Param, "id")
      if cfgMon then
        name = cfgMon.name
      end
      objCtrl:GetChild("lab_name"):SetText(name)
      obj:SetActive(true)
      obj.transform.anchoredPosition = self:GetMapPosByString(data[i].position)
      objCtrl:SetLocalScale(self.childScale)
    end
  end
end

function Main_MapDetailUI:RefreshEliteIcon(data)
  for i, v in pairs(eliteSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
  for i = 1, table.count(data) do
    local obj
    if index > table.count(eliteSpList) then
      obj = Instantiate(self.sp_elite.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.elitePointParent.transform, false)
      table.insert(eliteSpList, obj)
    end
    obj = eliteSpList[index]
    local objCtrl = UIControl(obj.transform)
    local name = data[i].name
    local cfgMon = ClientTable.cfg_Monster_monsterManager:TryGetValue(data[i].Param, "id")
    if cfgMon then
      name = cfgMon.name
    end
    objCtrl:GetChild("lab_name"):SetText(name)
    obj:SetActive(true)
    index = index + 1
    obj.transform.anchoredPosition = self:GetMapPosByString(data[i].position)
    objCtrl:SetLocalScale(self.childScale)
  end
end

function Main_MapDetailUI:RefreshTransferIcon(data)
  for i, v in pairs(transferSpList) do
    if v then
      v:SetActive(false)
    end
  end
  local index = 1
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
      obj.transform.anchoredPosition = self:GetMapPosByString(v.position)
      objCtrl:SetLocalScale(self.childScale)
    end
  end
end

function Main_MapDetailUI:RefreshUnionFlagIcon()
  for i, v in pairs(unionFlagList) do
    if v then
      v:SetActive(false)
    end
  end
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == false then
    return
  end
  local data = QuickFind:GetDuoQiCrossDataManager():GetCfgOfFlagsMiniMap()
  if next(data) == nil then
    return
  end
  local index = 1
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
    local unionName = QuickFind:GetDuoQiCrossDataManager():GetUnionNameByFlagId(v.Param)
    local unionNameColor = QuickFind:GetDuoQiCrossDataManager():GetUnionNameColorOfMapByFlagId(v.Param)
    local unionNameWithColor = string.format(unionNameColor, unionName)
    objCtrl:GetChild("lab_guild_name"):SetText(unionNameWithColor)
    obj:SetActive(true)
    index = index + 1
    local posArray = string.split(v.position, "#")
    obj.transform.anchoredPosition = self:GetMapPosByWorldPos(tonumber(posArray[1]) + 0.5, tonumber(posArray[2]) + 0.5)
    objCtrl:SetLocalScale(self.childScale)
    QuickFind:GetDuoQiCrossDataManager():SetMiniMapFlagIconBySubType(obj, v.subType)
  end
end

function Main_MapDetailUI:ClearMonsterSps()
  for i, v in pairs(monsterIdSpList) do
    table.insert(monsterSpPool, v)
  end
  monsterIdSpList = {}
end

function Main_MapDetailUI:ClearPlayerSps()
  for i, v in pairs(playerIdSpList) do
    table.insert(playerSpPool, v)
  end
  playerIdSpList = {}
end

function Main_MapDetailUI:RefreshMapDataScale()
  mapWidthScale = self.sp_map.transform.sizeDelta.x / SceneData.width
  mapHeightScale = self.sp_map.transform.sizeDelta.y / SceneData.height
  halfMapSpWidth = self.sp_map.transform.sizeDelta.x * 0.5
  halfMapSpHeight = self.sp_map.transform.sizeDelta.y * 0.5
end

function Main_MapDetailUI:GetMapPosByWorldPos(posX, posY)
  return Vector2(posX * mapWidthScale, posY * mapHeightScale)
end

function Main_MapDetailUI:GetMapPosByString(position)
  local posArray = string.split(position, "#")
  return self:GetMapPosByWorldPos(tonumber(posArray[1]), tonumber(posArray[2]))
end

function Main_MapDetailUI:OnClickBtnIncrease()
  local value = self.change_price:GetValue()
  self.change_price:SetValue(value + 5)
  PlayerPrefs.SetInt(Main_MapDetailUI.Main_MapDetailUI_SETSCALE, value + 5)
  if self.sliderMaxValue and value + 5 <= self.sliderMaxValue then
    self:RefreshSpMapPosByMainPlayerPos()
  end
end

function Main_MapDetailUI:OnClickBtnReduce()
  local value = self.change_price:GetValue()
  self.change_price:SetValue(value - 5)
  PlayerPrefs.SetInt(Main_MapDetailUI.Main_MapDetailUI_SETSCALE, value - 5)
  if self.sliderMinValue and value - 5 >= self.sliderMinValue then
    self:RefreshSpMapPosByMainPlayerPos()
  end
end

function Main_MapDetailUI:OnClickBtnShrinkRight()
  local x, y, z = self.btn_shrink_right:GetLocalScale()
  x = -x
  local isShrink = 0 < x
  self:ShrinkRight(isShrink)
end

function Main_MapDetailUI:OnClickBtnShrinkLeft()
  local x, y, z = self.btn_shrink_left:GetLocalScale()
  x = -x
  local isShrink = x < 0
  self:ShrinkLeft(isShrink)
end

function Main_MapDetailUI:ShrinkRight(isShrink)
  self.btn_shrink_right.transform:SetLocalScale(isShrink and 1 or -1, 1, 1)
  local posX, posY = self.btn_shrink_right:GetAnchoredPosition()
  posX = isShrink and 500 or 322
  self.btn_shrink_right:SetAnchoredPosition(posX, posY)
  self.rightPanel:SetActive(not isShrink)
  posX, posY = self.btn_transfer:GetAnchoredPosition()
  posX = isShrink and 480 or 260
  self.btn_transfer:SetAnchoredPosition(posX, posY)
end

function Main_MapDetailUI:ShrinkLeft(isShrink)
  self.btn_shrink_left.transform:SetLocalScale(isShrink and -1 or 1, 1, 1)
  local posX, posY = self.btn_shrink_left:GetAnchoredPosition()
  posX = isShrink and -450 or -249
  self.btn_shrink_left:SetAnchoredPosition(posX, posY)
  if self.haveMapExpTeleport then
    self.mapExpTeleport:SetActive(not isShrink)
  end
  self.mapTeleport:SetActive(not isShrink)
end

function Main_MapDetailUI:OnClickItemTransfer()
  if Main_MapDetailUI:IsCanShowInMap() then
    if BagInfoData.GetItemTotalCountByItemId(self.transItemId) == 0 then
      NavigationUtility.OpenPanelForId(tonumber(236010301))
      return
    end
    local itemInfo = BagInfoData.GetItemTblByConfigId(self.transItemId)
    BagInfoController.UseItemReq(1, itemInfo[1].id, nil, self.transItemId)
  else
    FloatingTipUtility.QuickMsg("B\225\186\163n \196\145\225\187\147 hi\225\187\135n t\225\186\161i kh\195\180ng th\225\187\131 d\195\185ng")
  end
end

function Main_MapDetailUI:PlayerDirectionCtrl()
  local angle = RoleManager.me:GetRotation()
  angle = angle % 360
  local tempAngle = 0
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
  tempAngle = tempAngle + 45
  self.mePoint.transform:SetLocalEulerAngles(0, 0, tempAngle)
end

function Main_MapDetailUI:GetWidthHeightAndScale(position, scale)
  local posTab = string.split(position, "#")
  local pos = Vector2(tonumber(posTab[1]), tonumber(posTab[2]))
  local sca = tonumber(string.split(scale, "#")[1])
  return pos, sca
end

function Main_MapDetailUI:OnRefreshBossState(id, msg)
  self.idData = {}
  self.stateData = {}
  for i = 1, table.count(msg.list) do
    table.insert(self.idData, msg.list[i].id)
    table.insert(self.stateData, msg.list[i].state)
  end
  for i = 1, table.count(SceneData.bossPosDataList) do
    if table.contains(self.idData, SceneData.bossPosDataList[i].id) and bossSpList[i] and SceneData.bossPosDataList[i].bigMapHolyBeastNotDisplay == 0 then
      local objCtrl = UIControl(bossSpList[i].transform)
      local index = self:GetIndex(self.idData, SceneData.bossPosDataList[i].id)
      self:SetHeadColor(objCtrl, self.stateData[index] == 1)
      local name = objCtrl:GetChild("lab_name")
      local color = self.stateData[index] == 1 and "#FF2323" or "#8E8D89"
      local str = name:GetText()
      name:SetText(string.GetColorText(str, color))
    end
  end
  for i = 1, table.count(SceneData.elitePosDataList) do
    if table.contains(self.idData, SceneData.elitePosDataList[i].id) and SceneData.elitePosDataList[i] then
      local index = self:GetIndex(self.idData, SceneData.elitePosDataList[i].id)
      local objCtrl = UIControl(eliteSpList[i].transform)
      objCtrl:SetColor(self.stateData[index] == 1 and "0xFFFFFFFF" or "0x808080FF")
      local name = objCtrl:GetChild("lab_name")
      local color = self.stateData[index] == 1 and "#FFD616" or "#8E8D89"
      local str = name:GetText()
      name:SetText(string.GetColorText(str, color))
    end
  end
  self:RefreshMu2EliteStateView()
end

function Main_MapDetailUI:SetHeadColor(baseUIControl, state)
  if baseUIControl == nil or type(state) ~= "boolean" then
    return
  end
  local headUIControl = baseUIControl:GetChild("head")
  local color = state and "0xFFFFFFFF" or "0x808080FF"
  if headUIControl then
    headUIControl:SetColor(color)
  else
    baseUIControl:SetColor(color)
  end
end

function Main_MapDetailUI:GetIndex(tab, value)
  for i = 1, table.count(tab) do
    if tab[i] == value then
      return i
    end
  end
end

function Main_MapDetailUI:ShowStoneMon()
  if SceneData.groupId ~= 1031001 then
    if table.count(self.stoneMonObjTab) > 0 then
      for i = 1, table.count(self.stoneMonObjTab) do
        if self.stoneMonObjTab[i]:GetActive() then
          self.stoneMonObjTab[i]:SetActive(false)
        end
      end
    end
    if 0 < table.count(self.doorMonObjTab) then
      for i = 1, table.count(self.doorMonObjTab) do
        if self.doorMonObjTab[i]:GetActive() then
          self.doorMonObjTab[i]:SetActive(false)
        end
      end
    end
    if self.luoLanInfo:GetActive() then
      self.luoLanInfo:SetActive(false)
    end
    return
  end
  self.luoLanInfo:SetActive(Activity_LuoLanSiegeData.IsActivityOpen())
  if Activity_LuoLanSiegeData.IsActivityOpen() then
    if table.count(self.stoneMonObjTab) == 0 then
      for i = 1, 4 do
        local obj = Instantiate(self.sp_stone.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.stonePointParent.transform, false)
        local objCtrl = UIControl(obj.transform)
        local id = 100317 + i
        local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(id)
        local dataTab = string.split(tbl.effect, "#")
        local isShow = Activity_LuoLanSiegeData.IsAliveOnCellMonster(tonumber(dataTab[1]), tonumber(dataTab[2]), tonumber(dataTab[3]))
        obj.transform.anchoredPosition = self:GetMapPosByWorldPos(tonumber(dataTab[2]), tonumber(dataTab[3]))
        objCtrl:SetAlpha(isShow and 1 or 0.5)
        table.insert(self.stoneMonObjTab, objCtrl)
      end
    else
      for i = 1, table.count(self.stoneMonObjTab) do
        local id = 100317 + i
        local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(id)
        local dataTab = string.split(tbl.effect, "#")
        local isShow = Activity_LuoLanSiegeData.IsAliveOnCellMonster(tonumber(dataTab[1]), tonumber(dataTab[2]), tonumber(dataTab[3]))
        self.stoneMonObjTab[i]:SetAlpha(isShow and 1 or 0.5)
        if not self.stoneMonObjTab[i]:GetActive() then
          self.stoneMonObjTab[i]:SetActive(true)
        end
      end
    end
    if table.count(self.doorMonObjTab) == 0 then
      for i = 1, 6 do
        local obj = Instantiate(self.sp_door.gameObject)
        obj:SetActive(true)
        obj.transform:SetParent(self.doorPointParent.transform, false)
        local objCtrl = UIControl(obj.transform)
        local id = 100311 + i
        local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(id)
        local dataTab = string.split(tbl.effect, "#")
        local isShow = Activity_LuoLanSiegeData.IsAliveOnCellMonster(tonumber(dataTab[1]), tonumber(dataTab[2]), tonumber(dataTab[3]))
        obj.transform.anchoredPosition = self:GetMapPosByWorldPos(tonumber(dataTab[2]), tonumber(dataTab[3]))
        objCtrl:SetAlpha(isShow and 1 or 0.5)
        table.insert(self.doorMonObjTab, objCtrl)
      end
    else
      for i = 1, table.count(self.doorMonObjTab) do
        local id = 100311 + i
        local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(id)
        local dataTab = string.split(tbl.effect, "#")
        local isShow = Activity_LuoLanSiegeData.IsAliveOnCellMonster(tonumber(dataTab[1]), tonumber(dataTab[2]), tonumber(dataTab[3]))
        self.doorMonObjTab[i]:SetAlpha(isShow and 1 or 0.5)
        if not self.doorMonObjTab[i]:GetActive() then
          self.doorMonObjTab[i]:SetActive(true)
        end
      end
    end
  else
    if table.count(self.stoneMonObjTab) > 0 then
      for i = 1, table.count(self.stoneMonObjTab) do
        if self.stoneMonObjTab[i]:GetActive() then
          self.stoneMonObjTab[i]:SetActive(false)
        end
      end
    end
    if 0 < table.count(self.doorMonObjTab) then
      for i = 1, table.count(self.doorMonObjTab) do
        if self.doorMonObjTab[i]:GetActive() then
          self.doorMonObjTab[i]:SetActive(false)
        end
      end
    end
  end
end

function Main_MapDetailUI:IsCanChangeMap(groupId)
  local condition = self:GetFieldByMap(false, groupId)
  local bContains = false
  for k = 1, #condition do
    local condition3 = condition[k]
    for g = 1, #condition3 do
      local condition2 = condition3[g]
      if condition2[1] == 1004 then
        bContains = true
        break
      end
    end
    if bContains == true then
      break
    end
  end
  if bContains == false then
    local strTab = condition[1]
    return ConditionManager.GenerateSingleCondition(strTab[1]):Check()
  end
end

function Main_MapDetailUI:IsCanShowInMap()
  local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId, "id")
  return mapTab.flyScroll == 0
end

function Main_MapDetailUI:SetTransferItemCount()
  local color = ItemQuality2ColorDic[EItemColorEnum.white]
  if BagInfoData.GetItemTotalCountByItemId(self.transItemId) == 0 then
    color = ItemQuality2ColorDic[EItemColorEnum.dark]
  end
  local str = string.GetColorText("Ng\225\186\171u nhi\195\170n", color)
  if not self.transCellData then
    local itemData = ItemUtility.GenerateItemData(self.transItemId)
    self.transCellData = ItemCellData()
    self.transCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(self.btn_transfer, self.transCellData, self)
    self.btn_transfer.countCtr:SetText(str)
    self.btn_transfer.countCtr:SetActive(true)
  else
    self.btn_transfer.countCtr:SetText(str)
    self.btn_transfer.countCtr:SetActive(true)
  end
  self.isSetTransfer = true
end

function Main_MapDetailUI:RefreshSpMapPosByMainPlayerPos()
  if RoleManager.me == nil or self.sp_map == nil or IsNil(self.sp_map.gameObject) then
    return
  end
  local curMeWorldPos = self.mePoint.transform.position
  local mapLocalPos = self.sp_map.transform.localPosition
  local meLocalPos = self.sp_map.transform.parent:InverseTransformPoint(curMeWorldPos)
  local offSetX = meLocalPos.x - mapLocalPos.x
  local offSetY = meLocalPos.y - mapLocalPos.y
  local resultX = mapLocalPos.x - offSetX
  local resultY = mapLocalPos.y - offSetY
  if self.cfgOffset then
    resultX = resultX - self.cfgOffset.x
    resultY = resultY - self.cfgOffset.y
  end
  self.sp_map.transform:SetAnchoredPosition(resultX, resultY)
end

function Main_MapDetailUI:GetInComePointMgr()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetInComeOnHookPointMgr()
  end
  return nil
end

function Main_MapDetailUI:GetAllInComePointGoList()
  if self.mAllInComePointGoList == nil then
    self.mAllInComePointGoList = {}
  end
  return self.mAllInComePointGoList
end

function Main_MapDetailUI:RefreshInComePointView()
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

function Main_MapDetailUI:RefreshServerMonsterPoint()
  self:RefreshServerBossList(gameMgr:GetMapManager():GetMapServerMonsterPoint():GetMonsterPointListByMonsterTypeList(ClientTable.cfg_Global_globalManager:GetMapShowMonsterTypeList()))
  self:RefreshBuffListByControlList(serverBossSpList)
end

function Main_MapDetailUI:RefreshServerBossList(data)
  for i, v in pairs(serverBossSpList) do
    if v then
      v:SetActive(false)
      v.serverMonsterPointData = nil
    end
  end
  local index, serverBossSpListCount = 1, table.count(serverBossSpList)
  for k, v in pairs(data) do
    if index > serverBossSpListCount then
      local obj = Instantiate(self.sp_boss.gameObject)
      obj:SetActive(true)
      obj.transform:SetParent(self.bossPointParent.transform, false)
      local objCtrl = UIControl(obj.transform)
      table.insert(serverBossSpList, objCtrl)
    end
    local objCtrl = serverBossSpList[index]
    self:RefreshSingleServerMonster(objCtrl, v)
    index = index + 1
  end
end

function Main_MapDetailUI:RefreshSingleServerMonster(uiControl, data)
  local showState = data:GetBigMapHeadShowState()
  uiControl:SetActive(showState ~= BigMapHeadShowType.DISABLE)
  local nameColor = "0xFF2323FF"
  local showColor = "0xFFFFFFFF"
  if showState == BigMapHeadShowType.GRAY then
    showColor = "0x808080FF"
    nameColor = "0x808080FF"
  end
  local head = uiControl:GetChild("head")
  if head ~= nil then
    head:SetColor(showColor)
  end
  uiControl.gameObject.name = "serverBoss"
  local nameControl = uiControl:GetChild("lab_name")
  if nameControl ~= nil then
    nameControl:SetText(data.showName ~= nil and data.showName or data.monsterConfigTbl.name)
    nameControl:SetColor(nameColor)
  end
  local position = self:GetMapPosByWorldPos(data.position.x, data.position.y)
  uiControl:SetAnchoredPosition(position.x, position.y)
  uiControl:SetLocalScale(self.childScale)
  uiControl.serverMonsterPointData = data
end

function Main_MapDetailUI:SetInComePointObj(data)
  local point = self:GetInComePointObj()
  if point == nil then
    return
  end
  point.goCtrl.transform.anchoredPosition = self:GetMapPosByWorldPos(data.x, data.y)
  self:SetSprite("Atlas_Common", self:GetInComePointMgr():GetSpriteNameByType(data.type), point.iconCtrl)
  point.goCtrl:SetLocalScale(self.childScale)
  point.goCtrl:SetActive(true)
end

function Main_MapDetailUI:GetInComePointObj()
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

function Main_MapDetailUI:CloneInComePointObj()
  if IsNil(self.sp_onHook.gameObject) or IsNil(self.onHookPointParent.transform) then
    return nil
  end
  local obj = Instantiate(self.sp_onHook.gameObject)
  obj:SetActive(false)
  obj.transform:SetParent(self.onHookPointParent.transform, false)
  return obj
end

function Main_MapDetailUI:ResetInComePoint()
  self.curInComeIndex = 1
  for i, v in pairs(self:GetAllInComePointGoList()) do
    if v and v.goCtrl and not IsNil(v.goCtrl.gameObject) and v.goCtrl.gameObject.activeSelf then
      v.goCtrl:SetActive(false)
    end
  end
end

function Main_MapDetailUI:GetUniversalPointMgr()
  if gameMgr:GetSceneManager() and gameMgr:GetSceneManager():GetSceneDataManager() then
    return gameMgr:GetSceneManager():GetSceneDataManager():GetScenePointDataManager()
  end
  return nil
end

function Main_MapDetailUI:UniversalGoCurFreeIndexDic()
  if self.mPlayerGoCurFreeIndexDic == nil then
    self.mPlayerGoCurFreeIndexDic = {}
  end
  return self.mPlayerGoCurFreeIndexDic
end

function Main_MapDetailUI:UniversalPointGoDic()
  if self.mPlayerPointGoList == nil then
    self.mPlayerPointGoList = {}
  end
  return self.mPlayerPointGoList
end

function Main_MapDetailUI:GetUniversalPointObj(type)
  local obj
  local curIndex = self:UniversalGoCurFreeIndexDic()[type]
  if self:UniversalPointGoDic()[type] ~= nil then
    obj = self:UniversalPointGoDic()[type][curIndex]
    if obj ~= nil and obj.goCtrl ~= nil and not IsNil(obj.goCtrl.gameObject) then
      self:UniversalGoCurFreeIndexDic()[type] = curIndex + 1
      return obj
    end
    if obj ~= nil and (obj.goCtrl == nil or IsNil(obj.goCtrl.gameObject)) then
      table.remove(self:UniversalPointGoDic(), curIndex)
    end
  else
    self:UniversalPointGoDic()[type] = {}
  end
  local go = self:CloneUniversalPointObj(type)
  if go then
    obj = {}
    local goCtrl = UIControl(go.transform)
    obj.goCtrl = goCtrl
    obj.nameCtrl = goCtrl:GetChild("lab_name")
    table.insert(self:UniversalPointGoDic()[type], obj)
    self:UniversalGoCurFreeIndexDic()[type] = curIndex + 1
  end
  return obj
end

function Main_MapDetailUI:ReqUniversalPointMsg()
  if self:GetUniversalPointMgr() then
    self:GetUniversalPointMgr():ReqMapUniversalPointCallBack()
  end
end

function Main_MapDetailUI:CloneUniversalPointObj(type)
  if self.sp_universalPoint == nil or IsNil(self.sp_universalPoint.gameObject) then
    return nil
  end
  local obj = Instantiate(self.sp_universalPoint.gameObject)
  obj:SetActive(false)
  obj.transform:SetParent(self.universalPointParent.transform, false)
  return obj
end

function Main_MapDetailUI:RefrehAllPointView()
  for i, v in pairs(EMapPointType) do
    self:RefreshUniversalPointView(v)
  end
end

function Main_MapDetailUI:RefreshAllUniversalPointSize()
  for i, v in pairs(self:UniversalPointGoDic()) do
    self:RefreshUniversalPointSizeByType(i)
  end
end

function Main_MapDetailUI:RefreshUniversalPointSizeByType(type)
  if self:UniversalPointGoDic()[type] == nil then
    return
  end
  for i, v in pairs(self:UniversalPointGoDic()[type]) do
    if v and v.goCtrl and not IsNil(v.goCtrl.transform) then
      v.goCtrl:SetLocalScale(self.childScale)
    end
  end
end

function Main_MapDetailUI:ResetAllUniversalPoint()
  for i, v in pairs(EMapPointType) do
    self:ResetUniversalPoint(v)
  end
end

function Main_MapDetailUI:ResetUniversalPoint(type)
  self:UniversalGoCurFreeIndexDic()[type] = 1
  if self:UniversalPointGoDic()[type] == nil then
    return
  end
  for i, v in pairs(self:UniversalPointGoDic()[type]) do
    if v and v.goCtrl then
      v.goCtrl:SetActive(false)
    end
  end
end

function Main_MapDetailUI:IsShowUniversalPointByType(type)
  if self:GetUniversalPointMgr() then
    return self:GetUniversalPointMgr():IsShowDetailMap(type)
  end
  return true
end

function Main_MapDetailUI:UniversalPointDataChangedCallBack(id, type)
  self:RefreshUniversalPointView(type)
end

function Main_MapDetailUI:RefreshUniversalPointView(type)
  self:ResetUniversalPoint(type)
  if self:GetUniversalPointMgr() == nil or not self:IsShowUniversalPointByType(type) then
    return
  end
  local pointData = self:GetUniversalPointMgr():GetMiniSpecialPointTbl()
  if pointData == nil or pointData[type] == nil then
    return
  end
  for i, v in pairs(pointData[type]) do
    self:SetUniversalPointObj(v)
  end
end

function Main_MapDetailUI:SetUniversalPointObj(data)
  if data.roleId == RoleManager.me.id then
    return
  end
  local point = self:GetUniversalPointObj(data.type)
  if point == nil then
    return
  end
  point.goCtrl.transform.anchoredPosition = self:GetMapPosByWorldPos(data.X, data.Y)
  local text = self:SetUniversalPointObjByExcel(data.type, data.name, point)
  point.nameCtrl:SetText(text)
  point.goCtrl:SetLocalScale(self.childScale)
  point.goCtrl:SetActive(true)
end

function Main_MapDetailUI:SetUniversalPointObjByExcel(type, name, pointObj)
  local text = name
  local mapHeadTbl = ClientTable.cfg_Map_headSculptureManager:TryGetValue(type)
  if mapHeadTbl then
    if mapHeadTbl.textShow == 0 then
      text = ""
    else
      if mapHeadTbl.color ~= "" then
        text = string.format(mapHeadTbl.color, text)
      end
      if mapHeadTbl.textSize ~= 0 then
        pointObj.nameCtrl:SetFontSize(mapHeadTbl.textSize)
      end
      pointObj.nameCtrl:SetAnchoredPosition(0, 100 - mapHeadTbl.distance)
    end
    if mapHeadTbl.name then
      self:SetSprite("Atlas_Common", mapHeadTbl.name, pointObj.goCtrl)
    end
    if mapHeadTbl.size and table.count(mapHeadTbl.size) > 1 then
      pointObj.goCtrl:SetSizeDelta(mapHeadTbl.size[1], mapHeadTbl.size[2])
    end
  end
  return text
end

function Main_MapDetailUI:GetMu2ElitePointGoList()
  if self.mMu2ElitePointGoList == nil then
    self.mMu2ElitePointGoList = {}
  end
  return self.mMu2ElitePointGoList
end

function Main_MapDetailUI:RefreshMu2ElitePointView()
  self:ResetMu2ElitePoint()
  for i, v in pairs(SceneData.mu2_elitePosDataList) do
    self:SetMu2ElitePointObj(v)
  end
end

function Main_MapDetailUI:RefreshMu2EliteStateView()
  for i = 1, table.count(SceneData.mu2_elitePosDataList) do
    if table.contains(self.idData, SceneData.mu2_elitePosDataList[i].id) then
      local index = self:GetIndex(self.idData, SceneData.mu2_elitePosDataList[i].id)
      local eliteTemp = self:GetMu2ElitePointGoList()[i]
      if eliteTemp and eliteTemp.goCtrl then
        if eliteTemp.iconCtrl then
          eliteTemp.iconCtrl:SetColor(self.stateData[index] == 1 and "0xFFFFFFFF" or "0x808080FF")
        end
        if eliteTemp.nameCtrl then
          local color = self.stateData[index] == 1 and "#FFD616" or "#8E8D89"
          eliteTemp.nameCtrl:SetText(string.GetColorText(eliteTemp.nameCtrl:GetText(), color))
        end
      end
    end
  end
end

function Main_MapDetailUI:SetMu2ElitePointObj(data)
  local point = self:GetMU2ElitePointObj()
  if point == nil then
    return
  end
  local pos = TableParse:SplitStringToIntList(data.position, "#")
  if pos and table.count(pos) > 1 then
    point.goCtrl.transform.anchoredPosition = self:GetMapPosByWorldPos(pos[1], pos[2])
  end
  self:SetSprite("Atlas_Common", "ico_boss" .. data.type, point.iconCtrl)
  point.nameCtrl:SetText(data.name)
  point.goCtrl:SetLocalScale(self.childScale)
  point.goCtrl:SetActive(true)
end

function Main_MapDetailUI:GetMU2ElitePointObj()
  local obj = self:GetMu2ElitePointGoList()[self.curEliteIndex]
  if obj ~= nil and obj.goCtrl ~= nil and not IsNil(obj.goCtrl.gameObject) then
    self.curEliteIndex = self.curEliteIndex + 1
    return obj
  end
  if obj ~= nil and (obj.goCtrl == nil or IsNil(obj.goCtrl.gameObject)) then
    table.remove(self:GetMu2ElitePointGoList(), self.curEliteIndex)
  end
  local go = self:CloneMu2ElitePointObj()
  if go then
    obj = {}
    local goCtrl = UIControl(go.transform)
    obj.goCtrl = goCtrl
    obj.iconCtrl = goCtrl
    obj.nameCtrl = goCtrl:GetChild("lab_name")
    table.insert(self:GetMu2ElitePointGoList(), obj)
  end
  self.curEliteIndex = self.curEliteIndex + 1
  return obj
end

function Main_MapDetailUI:CloneMu2ElitePointObj()
  if IsNil(self.sp_elite.gameObject) or IsNil(self.elitePointParent.transform) then
    return nil
  end
  local obj = Instantiate(self.sp_elite.gameObject)
  obj:SetActive(false)
  obj.transform:SetParent(self.elitePointParent.transform, false)
  return obj
end

function Main_MapDetailUI:ResetMu2ElitePoint()
  self.curEliteIndex = 1
  for i, v in pairs(self:GetMu2ElitePointGoList()) do
    if v and v.goCtrl and not IsNil(v.goCtrl.gameObject) and v.goCtrl.gameObject.activeSelf then
      v.goCtrl:SetActive(false)
    end
  end
end

function Main_MapDetailUI:OnKalunteRuinsVirusCircleChange(id, data)
  self.m_MiniMap_KaLunTeVirusCircleTemplate:Refresh(data)
end

function Main_MapDetailUI:OnKalunteRuinsExit()
  self.m_MiniMap_KaLunTeVirusCircleTemplate:Exit()
end

function Main_MapDetailUI:RefreshMapExpTeleport()
  return false
end

function Main_MapDetailUI:RefreshMapTeleport()
  if self.mapTeleportTemplate == nil then
    self.mapTeleportTemplate = luaTemplateManager.GetNewTemplate(self.mapTeleport, LuaComponentTemplates.MapTeleportTemplate)
  end
  if self.mapTeleportTemplate ~= nil then
    self.mapTeleportTemplate:Refresh()
  end
end

function Main_MapDetailUI:SetMapTeleport()
  local sizeX, sizeY = self.mapTeleport:GetSizeDelta()
  if self.haveMapExpTeleport then
    self.mapExpTeleport:SetActive(true)
    sizeY = 280
  else
    self.mapExpTeleport:SetActive(false)
    sizeY = 564
  end
  self.mapTeleport:SetSizeDelta(sizeX, sizeY)
end

function Main_MapDetailUI:RefreshBossLocation()
  if self.bossLocationTemplate == nil then
    self.bossLocationTemplate = luaTemplateManager.GetNewTemplate(self.bossLocation, LuaComponentTemplates.BossLocationTemplate)
  end
  if self.bossLocationTemplate ~= nil then
    return self.bossLocationTemplate:Refresh()
  end
  return false
end

function Main_MapDetailUI:RefreshOnHook()
  if self.onHookTemplate == nil then
    self.onHookTemplate = luaTemplateManager.GetNewTemplate(self.onHook, LuaComponentTemplates.OnHookTemplate)
  end
  if self.onHookTemplate ~= nil then
    return self.onHookTemplate:Refresh(self)
  end
  return false
end

function Main_MapDetailUI:SetNextExpDes()
  local nextInfo, isMax = gameMgr:GetMinMapDataMgr():GetNextMapInfo()
  if nextInfo and nextInfo.mapTab and ClientTable.cfg_Map_mapManager:IsVipMap(SceneData.mapId) == false then
    local onHookPointListIdArray = string.split(nextInfo.mapTab.onHookPointListId, "#")
    if 2 <= #onHookPointListIdArray then
      local cfg_gloab = ClientTable.cfg_Global_globalManager:TryGetValue(2210201)
      local cfg_id = tonumber(onHookPointListIdArray[2])
      local cfg_hook = ClientTable.cfg_OnHook_Point_ListManager:TryGetValue(cfg_id)
      local ratio = tonumber(cfg_gloab.effect) / 10000
      local value = (cfg_hook.experiencepoint + cfg_hook.experiencepoint * ratio) / 10000
      if value == 0 then
        self.txt_nextExpDes:SetText("")
      else
        local percent = math.floor(value * 10 + 0.5) / 10
        local uiWord = ClientTable.cfg_Ui_wordManager:TryGetValue("Ditukaiqi_1").content
        local des = string.format(uiWord, tostring(percent))
        self.txt_nextExpDes:SetText(des)
      end
      return
    end
  end
  self.txt_nextExpDes:SetText("")
end

function Main_MapDetailUI:OnServerMonsterPointChange()
  self:RefreshServerMonsterPoint()
end

function Main_MapDetailUI:OnServerSingleMonsterPointChange(id, data)
  if data == nil then
    return
  end
  local uiControl = self:GetServerSpUIControl(data.lid)
  if uiControl == nil then
    return
  end
  self:RefreshSingleServerMonster(uiControl, data)
  self:RefreshBuffList(uiControl, data)
end

function Main_MapDetailUI:GetServerSpUIControl(lid)
  if type(lid) ~= "number" or next(serverBossSpList) == nil then
    return
  end
  for k, v in pairs(serverBossSpList) do
    if v.serverMonsterPointData ~= nil and v.serverMonsterPointData.lid == lid then
      return v
    end
  end
end

function Main_MapDetailUI:RefreshBuffListByControlList(splist)
  if type(splist) ~= "table" then
    return
  end
  for k, v in pairs(splist) do
    self:RefreshBuffList(v, v.serverMonsterPointData)
  end
end

function Main_MapDetailUI:RefreshBuffList(uiControl, serverMonsterPoint)
  if uiControl == nil or serverMonsterPoint == nil then
    return
  end
  if uiControl.buffContainer == nil and (serverMonsterPoint.mapBuffConfigList == nil or next(serverMonsterPoint.mapBuffConfigList) == nil) then
    return
  end
  if uiControl.buffContainer == nil then
    local buff = uiControl:GetChild("buffs/buff")
    if buff == nil then
      return
    end
    uiControl.buffContainer = UIUtility.BindUIContainerTemp(buff, LuaComponentTemplates.MapBuffTemplate, self, MapPointBuffRefreshType.MAXMAP)
  end
  if uiControl.buffContainer == nil then
    return
  end
  uiControl.buffContainer:SetData(serverMonsterPoint.mapBuffConfigList)
end

function Main_MapDetailUI:OnLogOut()
  self.m_MiniMap_KaLunTeVirusCircleTemplate:LogOut()
end

function Main_MapDetailUI:HideMapList(isInUnionMap)
  self.mapTeleport:SetActive(isInUnionMap == false)
  self.btn_shrink_left:SetActive(isInUnionMap == false)
end

function Main_MapDetailUI:ResSpaceCrackMiniMapBox()
  for i, v in pairs(spaceCrackBoxList) do
    if v then
      v:SetActive(false)
    end
  end
  if not SpaceCrackUtility:CheckInSpaceCrackMap(SceneData.mapId) then
    return
  end
  local mapBoxData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackMiniMapBoxInfoData
  if mapBoxData == nil or next(mapBoxData) == nil then
    return
  end
  local index = 1
  for i, v in pairs(mapBoxData) do
    local item
    if index > table.count(spaceCrackBoxList) then
      local obj = Instantiate(self.spaceCrackBoxSp_box.gameObject)
      item = UIControl(obj.transform)
      item:SetActive(true)
      item.transform:SetParent(self.spaceCrackBoxParent.transform, false)
      table.insert(spaceCrackBoxList, item)
    end
    item = spaceCrackBoxList[index]
    item:SetActive(true)
    index = index + 1
    item.transform.anchoredPosition = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
  end
end

function Main_MapDetailUI:RefreshFourPartyRivalryIcon()
  self:RefreshFourPartyRivalryFlag()
  self:RefreshFourPartyRivalryCityGate()
  self:RefreshFourPartyRivalryThrone()
end

function Main_MapDetailUI:RefreshFourPartyRivalryFlag()
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
    local position = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    item:SetAnchoredPosition(position.x, position.y)
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

function Main_MapDetailUI:RefreshFourPartyRivalryCityGate()
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
    local position = self:GetMapPosByWorldPos(v.x + 0.5, v.y + 0.5)
    item:SetAnchoredPosition(position.x, position.y)
    item:GetChild("img_CityGate"):SetColor(v.status == 0 and "0xFFFFFFFF" or "0x808080FF")
    index = index + 1
  end
end

function Main_MapDetailUI:RefreshFourPartyRivalryThrone()
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

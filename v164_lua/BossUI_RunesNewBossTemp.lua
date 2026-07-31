local BossUI_RunesNewBossTemp = {}

function BossUI_RunesNewBossTemp:Init()
  self:InitControl()
  self:InitContainer()
end

function BossUI_RunesNewBossTemp:InitControl()
  self.levelScroll = self:GetControl("levelScroll")
  self.viewBtnItem = self:GetControl("levelRegenerateBtnItem")
  self.bossModelParent = self:GetControl("regenerateBossItem/go_modelRegenerate")
  self.text_BossName = self:GetControl("regenerateBossItem/lab_regenerateBossName")
  self.mapItem = self:GetControl("regenerateBossItem/tog_mapName/posScroll/Viewport/ContentRegenerate/regenerateMapItem")
  self.mapContent = self:GetControl("regenerateBossItem/tog_mapName/posScroll/Viewport/ContentRegenerate")
  self.fillArea = self:GetControl("regenerateBossItem/sl_boss/sl_bossName/sl_progress_boss/Fill Area/Fill")
  self.text_Progress = self:GetControl("regenerateBossItem/sl_boss/sl_bossName/sl_progress_boss/lab_progress")
  self.text_AllKill = self:GetControl("regenerateBossItem/text_AllKill")
  self.sl_BossName = self:GetControl("regenerateBossItem/sl_boss/sl_bossName")
  self.sl_boss = self:GetControl("regenerateBossItem/sl_boss")
  self.grid = self:GetControl("Grid")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_RunesNewBossTemp:InitContainer()
  self.mapItemTemp = UIContainer(self.mapItem, self, OnMapItemCreate)
  self.bossMapTab = {}
end

function BossUI_RunesNewBossTemp:SetDefaultSelectedBossIndex()
  local bossData = MonsterData.FilterSameBossId(MonsterData.GetMonsterBossType(MonsterBossType.RunesNewBoss, true))
  self.bossDataList = {}
  for i, v in pairs(bossData) do
    local showConditionTab = string.split(v.yuanGuShowCondition, "#")
    local openTime = SceneData.openDayMax
    v.startTime, v.endTime = tonumber(showConditionTab[1]), tonumber(showConditionTab[2])
    if openTime <= v.endTime then
      v.state = openTime < v.startTime and 0 or 1
      table.insert(self.bossDataList, v)
    end
  end
  self.defaultSelectedIndex = 1
  if self.baseUI.args ~= nil and self.baseUI.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.bossDataList, tonumber(self.baseUI.args.Monsterid))
    if selectIndex then
      self.defaultSelectedIndex = selectIndex
    end
  end
end

function BossUI_RunesNewBossTemp:RefreshBossTableView()
  if self.bossTableView == nil then
    self.bossTableView = UITableView:CreateTableView(self.levelScroll, self.viewBtnItem, self.bossDataList, EScrollViewDireEnum.Vertical, self.UpdateWildCellCallBack, self)
  end
  self.bossTableView:SetCurDataList(self.bossDataList)
  local smallSelectIndex = self.defaultSelectedIndex > 3 and self.defaultSelectedIndex - 2 or 1
  self.bossTableView:ReloadData(smallSelectIndex)
  local obj = self.bossTableView:GetLoadedCell(self.defaultSelectedIndex)
  self:RefreshRightView(obj, self.bossTableView[self.defaultSelectedIndex])
end

function BossUI_RunesNewBossTemp:UpdateWildCellCallBack(index)
  if type(self.bossDataList) ~= "table" or next(self.bossDataList) == nil then
    return
  end
  if self.bossDataList[index] ~= nil then
    local cell = self.bossTableView:GetLoadedCell(index)
    self:RefreshLeftView(self.bossDataList[index], cell, index)
  end
end

function BossUI_RunesNewBossTemp:RefreshLeftView(bossConfig, obj, index)
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(bossConfig.id)
  if monsterConfig == nil then
    logError("Kh\195\180ng c\195\179 ID trong b\225\186\163ng cfg_Monster_monster:" .. bossConfig.id .. "d\225\187\175 li\225\187\135u c\225\187\167a, h\195\163y \196\145\225\187\131 b\225\187\153 ph\225\186\173n thi\225\186\191t k\225\186\191 ki\225\187\131m tra!!!")
    return
  end
  local mapConfig = ClientTable.cfg_Map_mapManager:TryGetValue(bossConfig.mapId, "id")
  if mapConfig == nil then
    logError("Trong b\225\186\163ng Map_Map kh\195\180ng t\225\187\147n t\225\186\161i MapID:: " .. mapConfig.mapId .. "!!!, h\195\163y ki\225\187\131m tra ID trong b\225\186\163ng Monster_monster: " .. bossConfig.id)
    return
  end
  local monsterBossCanKill = bossConfig.state == 1 and true or false
  self.baseUI:TryInitComponent(obj)
  obj.lab_name:SetText(monsterConfig.name)
  if not string.isNullOrEmpty(monsterConfig.head) then
    self.baseUI:SetSprite("Atlas_headPortrait", monsterConfig.head, obj.img_bossicon)
  end
  obj.lab_level:SetActive(monsterBossCanKill)
  obj.lab_openLevel:SetActive(not monsterBossCanKill)
  if monsterBossCanKill then
    obj.lab_level:SetText(string.format("Lv.%s", monsterConfig.showLevel))
  else
    obj.lab_openLevel:SetText(string.format(bossConfig.Displaylevel, bossConfig.startTime - SceneData.openDayMax))
  end
  local isSatisfy, holySkeletonBossInfo = SceneData:GetAncientBossData(bossConfig.bossType, bossConfig.id)
  obj.img_redPoint:SetActive(isSatisfy == true)
  obj.img_clickeffect:SetActive(index == self.defaultSelectedIndex)
  obj:SetOnClickParam(self, self.RefreshRightView, {bossConfig = bossConfig, index = index})
end

function BossUI_RunesNewBossTemp:RefreshRightView(obj, bossConfig)
  if bossConfig == nil and obj.param and obj.param.bossConfig then
    bossConfig = obj.param.bossConfig
  end
  if bossConfig == nil then
    return
  end
  if obj.param and obj.param.index then
    local cell = self.bossTableView:GetLoadedCell(self.defaultSelectedIndex)
    if cell then
      cell.img_clickeffect:SetActive(false)
    end
    self.defaultSelectedIndex = obj.param.index
    obj.img_clickeffect:SetActive(true)
  end
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(bossConfig.id, "id")
  for k, v in pairs(self.bossMapTab) do
    v:SetActive(false)
  end
  local monsterId = tonumber(string.split(bossConfig.yuanGuMonsterId, "#")[1])
  local name = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterId).name
  self.sl_BossName:SetText(string.format("%s", name) .. "Ti\195\170u di\225\187\135t")
  local scale, position = MonsterData.GetMonsterScaleAndPos(bossConfig)
  self.baseUI:ShowMonsterModel(monsterConfig, self.bossModelParent, scale, position)
  self:RefreshShBossReward(bossConfig)
  self.text_BossName:SetText(monsterConfig.name)
  local isSatisfy, holySkeletonBossInfo = SceneData:GetAncientBossData(bossConfig.bossType, bossConfig.id)
  local count = tonumber(ClientTable.cfg_Monster_bossManager:TryGetValue(bossConfig.id, "id").yuanGuDailyKillNum)
  self.text_AllKill:SetActive(false)
  self.sl_boss:SetActive(true)
  if holySkeletonBossInfo and holySkeletonBossInfo.refreshCount and count <= holySkeletonBossInfo.refreshCount then
    self.text_AllKill:SetActive(true)
    self.sl_boss:SetActive(false)
  end
  if isSatisfy then
    local mapData = ClientTable.cfg_Map_mapManager:TryGetValue(holySkeletonBossInfo.mapId, "id")
    local transferId, npcId = self.baseUI:GetBossTransId(bossConfig.id, holySkeletonBossInfo.mapId)
    local objMap = self.mapItemTemp:GetOrCreateItem(bossConfig.id .. holySkeletonBossInfo.mapId .. holySkeletonBossInfo.line)
    self.baseUI:SetMapCount(holySkeletonBossInfo, objMap, mapData.enterCondition, mapData)
    objMap.lab_bossCount:SetActive(not objMap.lab_level:GetActive())
    objMap:SetParent(self.mapContent.transform)
    objMap:SetOnClick(self, function()
      self:SetMapOnClick(holySkeletonBossInfo.mapId)
    end)
    objMap:SetAsLastSibling()
    objMap:SetActive(true)
    self.text_Progress:SetText(string.format("%d/%d", bossConfig.yuanGuMonsterKillNum, bossConfig.yuanGuMonsterKillNum))
    self.bossMapTab[bossConfig.id .. holySkeletonBossInfo.mapId .. holySkeletonBossInfo.line] = objMap
    self.fillArea:SetFillAmount(1)
  elseif isSatisfy == false then
    self.text_Progress:SetText(string.format("%d/%d", holySkeletonBossInfo.count, bossConfig.yuanGuMonsterKillNum))
    self.fillArea:SetFillAmount(holySkeletonBossInfo.count / bossConfig.yuanGuMonsterKillNum)
  else
    self.text_Progress:SetText(string.format("%d/%d", 0, bossConfig.yuanGuMonsterKillNum))
    self.fillArea:SetFillAmount(0)
  end
end

function BossUI_RunesNewBossTemp:RefreshShBossReward(bossConfig)
  BossData:SetCurSelectBossTbl(bossConfig)
  networkRequest.ReqMonsterDropRate({
    bossConfig.id
  })
  self.baseUI.curSelectedMonsterId = bossConfig.id
  local tabData = MonsterData.GetBossShowDropItemList(bossConfig)
  local length = UIUtility.GetDicLength(tabData)
  self.grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tabData) do
    local object = self.grid:GetTopGridObjectList()[index]
    if self.bossDropTblDic == nil then
      self.bossDropTblDic = {}
    end
    if self.bossDropTblDic[object] == nil then
      self.bossDropTblDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.BossUI_dropListTemp, {
        baseUI = self.baseUI
      })
    end
    self.bossDropTblDic[object]:Refresh(v)
    index = index + 1
  end
end

function BossUI_RunesNewBossTemp:SetMapOnClick(mapID)
  if TranScriptData.InTranscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  local map = ClientTable.cfg_Map_mapManager:TryGetValue(mapID)
  if not ConditionManager.Check4D(map.enterCondition) then
    local levelCondition, vipCondition, wingCondition = {}, {}, {}
    for i, v in ipairs(map.enterCondition[1]) do
      if v[1] == 3101 then
        table.insert(vipCondition, v)
      elseif v[1] == 1031 then
        table.insert(wingCondition, v)
      else
        table.insert(levelCondition, v)
      end
    end
    if not ConditionManager.Check(vipCondition) then
      local vip = vipCondition[1][2]
      local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(vip)
      if memberTbl then
        FloatingTipUtility.QuickMsg(string.format("C\225\186\167n VIP %s tr\225\187\159 l\195\170n", memberTbl.name))
      end
      return
    end
    if not ConditionManager.Check(levelCondition) then
      FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\187\167 c\225\186\165p")
      return
    end
    if not ConditionManager.Check(wingCondition) then
      local needWingQuality = wingCondition and wingCondition[1][2]
      if needWingQuality then
        local Boss_wingDesChangeDic = ClientTable.cfg_Global_globalManager:GetGlobal_Boss_wingDesChangeDic()
        needWingQuality = Boss_wingDesChangeDic[needWingQuality]
        FloatingTipUtility.QuickMsg(string.format("C\225\186\167n m\225\186\183c C\195\161nh ph\225\186\169m ch\225\186\165t %s tr\225\187\159 l\195\170n", needWingQuality))
      end
      return
    end
  end
  local mapData = {
    mapId = map.transferPosition,
    line = 1
  }
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
end

function BossUI_RunesNewBossTemp:Refresh(baseUI)
  if baseUI ~= nil then
    self.baseUI = baseUI
  end
  self:SetDefaultSelectedBossIndex()
  self:RefreshBossTableView()
end

return BossUI_RunesNewBossTemp

local BossUI_SecretBossTemp = {}
local root = {}

function BossUI_SecretBossTemp:Init()
  self:InitControls()
  self:InitData()
end

function BossUI_SecretBossTemp:InitControls()
  self.tog_bossinfo = self:GetControl("clo_bossinfo")
  self.lab_level = self:GetControl("clo_bossinfo/tog_bossinfo/lab_openlevel/lab_level")
  self.ScrollView = self:GetControl("ScrollView")
  self.go_model = self:GetControl("go_model")
  self.lab_countleft = self:GetControl("lab_countleft")
  self.lab_countAll = self:GetControl("lab_countleft/lab_countAll")
  self.lab_bossname2 = self:GetControl("lab_bossname2")
  self.lab_descrpboss = self:GetControl("lab_bossname2/lab_descrpboss")
  self.lab_des = self:GetControl("lab_bossname2/lab_descrpboss/lab_des")
  self.lab_rewards = self:GetControl("lab_bossname2/lab_rewards")
  self.grid_rewardsinfo = self:GetControl("lab_bossname2/lab_rewards/grid_rewardsinfo")
  self.btn_3DItem = self:GetControl("lab_bossname2/lab_rewards/grid_rewardsinfo/btn_3DItem")
  self.lab_rewardsBelong = self:GetControl("lab_bossname2/lab_rewardsBelong")
  self.grid_rewardsinfoBelong = self:GetControl("lab_bossname2/lab_rewardsBelong/grid_rewardsinfoBelong")
  self.btn_3DItemBelong = self:GetControl("lab_bossname2/lab_rewardsBelong/grid_rewardsinfoBelong/btn_3DItemBelong")
  self.btn_enter = self:GetControl("btn_enter")
  self.mapName = self:GetControl("mapName")
  self.ContentExcellent = self:GetControl("mapName/posScroll/Viewport/ContentExcellent")
  self.excellentMapItem = self:GetControl("mapName/posScroll/Viewport/ContentExcellent/excellentMapItem")
  self.btn_BossIntegral = self:GetControl("btn_BossIntegral")
  self.lab_BossIntegral = self:GetControl("btn_BossIntegral/lab_num")
end

local function excellentMapItemCreat(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_SecretBossTemp:InitData()
  self.excellentMapItemTemp = UIContainer(self.excellentMapItem, self, excellentMapItemCreat)
  self.normalTimer = {}
  self.bossMapTbl = {}
  self.modelReward = {}
  self.modelRewardBelong = {}
  self.effectList = {}
end

function BossUI_SecretBossTemp:SetDefaultLevelSecretBossIndex()
  self.secretMonsterBossTblList = MonsterData.FilterSameBossId(TranScriptData.secretBoss)
  self.secretSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.secretMonsterBossTblList)
  if root.args ~= nil and root.args.Monsterid ~= nil then
    local argMonsterId = root.args.Monsterid
    if argMonsterId == 210100100 then
      argMonsterId = 210100101
    end
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.secretMonsterBossTblList, argMonsterId)
    if selectIndex then
      self.secretSelectIndex = selectIndex
    end
  end
  local instanceTbl = TranScriptData.secretBoss[self.secretSelectIndex]
  if instanceTbl == nil then
    return
  end
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(instanceTbl.id)
  self:refreshMiddleInfo(monsterConfig)
end

function BossUI_SecretBossTemp:RefreshTableView(selectIndex)
  if not self.tableView then
    self.tableView = UITableView:CreateTableView(self.ScrollView, self.tog_bossinfo, TranScriptData.secretBoss, EScrollViewDireEnum.Vertical, self.UpdateCellCallback, self)
  end
  if self.tableView ~= nil then
    local smallSelectIndex
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.tableView:ReloadData(smallSelectIndex)
  end
end

function BossUI_SecretBossTemp:UpdateCellCallback(index)
  local data = TranScriptData.secretBoss
  if data[index] then
    local cell = self.tableView:GetLoadedCell(index)
    cell.index = index
    self:UpdateSecretBossInfoUI(data[index], cell)
  end
end

function BossUI_SecretBossTemp:UpdateSecretBossInfoUI(instanceTbl, cell)
  local bossIcon = cell:GetChild("tog_bossinfo/img_bossicon")
  local bossName = cell:GetChild("tog_bossinfo/lab_bossname")
  local bossTime = cell:GetChild("tog_bossinfo/lab_cooldown")
  local lab_openlevel = cell:GetChild("tog_bossinfo/lab_openlevel")
  local lab_level = cell:GetChild("tog_bossinfo/lab_openlevel/lab_level")
  local lab_Showlevel = cell:GetChild("tog_bossinfo/lab_level")
  bossTime:SetActive(true)
  local levelRestrict = ClientTable.cfg_Map_mapManager:TryGetValue(instanceTbl.mapId, "id").enterCondition
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(instanceTbl.id)
  local monster_bossConfig = ClientTable.cfg_Monster_bossManager:TryGetValue(instanceTbl.id, "id")
  local countKey = levelRestrict[1][2][2][1]
  local count = RefreshData.GetInstanceCount(tonumber(countKey))
  if monsterConfig.monsterScore ~= 0 then
    self.btn_BossIntegral:SetActive(true)
    self.lab_BossIntegral:SetText(monsterConfig.monsterScore)
  else
    self.btn_BossIntegral:SetActive(false)
  end
  local level = levelRestrict[1][1][2]
  self.AllCount = count
  self.lab_countAll:SetText(self.AllCount)
  local isNotMeetLevel = tonumber(level) > RoleManager.me.level
  if isNotMeetLevel then
    lab_level:SetText(string.GetColorText(monster_bossConfig.Displaylevel, ItemQuality2ColorDic[7]))
    lab_openlevel:SetText("C\225\186\165p m\225\187\159")
    lab_level:SetActive(true)
  else
    local str = string.GetColorText(monsterConfig.level, ItemQuality2ColorDic[0])
    lab_openlevel:SetText("Lv." .. str)
    lab_level:SetText("")
    lab_openlevel:SetActive(false)
  end
  lab_openlevel:SetActive(isNotMeetLevel)
  lab_Showlevel:SetActive(not isNotMeetLevel)
  local destext = MonsterData.Getattack_defDes(monster_bossConfig)
  lab_Showlevel:SetText(destext)
  bossName:SetText(monsterConfig.name)
  root:SetSprite("Atlas_headPortrait", monsterConfig.head, bossIcon)
  cell.monsterConfig = monsterConfig
  cell:GetChild("tog_bossinfo/img_target"):SetActive(self.secretSelectIndex == cell.index)
  cell:SetInteractable(self.secretSelectIndex ~= cell.index)
  if self.secretSelectIndex == cell.index then
    self.secSelectIndex = self.secretSelectIndex
  end
  if TranScriptData.priBossTimeTab and 0 < table.count(TranScriptData.priBossTimeTab) and RoleManager.me.level >= tonumber(level) then
    if TranScriptData.priBossTimeTab[instanceTbl.mapId] then
      local time = math.floor((TranScriptData.priBossTimeTab[instanceTbl.mapId] - Time.GetServerTime()) / 1000) or 0
      if 0 < time then
        local isTask = TranScriptData.GetSecretBossIsTask()
        if isTask and cell.index == 1 then
          bossTime:SetActive(false)
          if self.normalTimer[cell.index] then
            Timer.Stop(self.normalTimer[cell.index])
            self.normalTimer[cell.index] = nil
          end
        else
          self:ShowTimer(time, bossTime, cell.index)
          bossTime:SetActive(0 < time)
          self.LabTime[instanceTbl.mapId] = bossTime
        end
      else
        bossTime:SetActive(false)
        if self.normalTimer[cell.index] then
          Timer.Stop(self.normalTimer[cell.index])
          self.normalTimer[cell.index] = nil
        end
      end
    else
      bossTime:SetActive(false)
      if self.normalTimer[cell.index] then
        Timer.Stop(self.normalTimer[cell.index])
        self.normalTimer[cell.index] = nil
      end
    end
  else
    bossTime:SetActive(false)
    if self.normalTimer[cell.index] then
      Timer.Stop(self.normalTimer[cell.index])
      self.normalTimer[cell.index] = nil
    end
  end
  cell:SetOnClick(self, self.ShowSecretBoss)
end

function BossUI_SecretBossTemp:ShowSecretBoss(control)
  control:GetChild("tog_bossinfo/img_target"):SetActive(true)
  if control.index ~= self.secSelectIndex then
    local cell = self.tableView:GetLoadedCell(self.secSelectIndex)
    if cell then
      cell:SetInteractable(true)
      cell:GetChild("tog_bossinfo/img_target"):SetActive(false)
    end
  end
  self.secretSelectIndex = control.index
  self.secSelectIndex = control.index
  local data = TranScriptData.secretBoss[self.secretSelectIndex]
  self.CurSingleCopydata = data
  self:refreshMiddleInfo(control.monsterConfig)
end

function BossUI_SecretBossTemp:refreshMiddleInfo(monsterTbl)
  self.lab_bossname2:SetText(monsterTbl.name)
  self.lab_countAll:SetText(self.AllCount)
  local monsterBossTbl = ConfigManager.FindConfigs("cfg_Monster_boss", "id", monsterTbl.id)
  local scale, position = MonsterData.GetMonsterScaleAndPos(monsterBossTbl[1])
  self:SetCopyAward(monsterBossTbl[1], monsterTbl)
  root:ShowMonsterModel(monsterTbl, self.go_model.transform, scale, position)
  self:SetSecMapPointItem(monsterTbl)
end

function BossUI_SecretBossTemp:SetSecMapPointItem(monsterTbl)
  for k, v in pairs(self.bossMapTbl) do
    v:SetActive(false)
  end
  local monsterData
  if monsterTbl.id == 210100101 and TranScriptData.GetSecretBossIsTask() then
    monsterData = ConfigManager.FindConfigs("cfg_Monster_boss", "id", 210100100)[1]
  else
    monsterData = ConfigManager.FindConfigs("cfg_Monster_boss", "id", monsterTbl.id)[1]
  end
  local mapData = ClientTable.cfg_Map_mapManager:TryGetValue(monsterData.mapId, "groupId")
  local posTbl = monsterData.transferId
  if type(posTbl) == "table" then
    for k, v in pairs(posTbl) do
      self:SetPosButton(v, monsterTbl, mapData)
    end
  else
    self:SetPosButton(posTbl, monsterTbl, mapData)
  end
end

function BossUI_SecretBossTemp:SetPosButton(v, monsterTbl, mapData)
  local transfer = ConfigManager.FindConfigs("cfg_Map_transfer", "id", tonumber(v))[1]
  local timeId = monsterTbl.id .. transfer.id
  local objMap = self.excellentMapItemTemp:GetOrCreateItem(timeId)
  local pos = string.split(transfer.position, "_")
  objMap.lab_mapName:SetText(mapData.name .. " (" .. pos[1] .. "," .. pos[2] .. ") ")
  objMap.lab_level:SetActive(false)
  local level = mapData.enterCondition[1][1][2]
  if TranScriptData.secretBossTimeTab and TranScriptData.secretBossTimeTab[timeId] then
    local time = math.floor(TranScriptData.secretBossTimeTab[timeId] - Time.GetServerSecondTime()) or 0
    if 0 < time then
      self:ShowTimer(time, objMap.lab_bossCount, timeId, MonsterBossType.secretBoss)
      root:SetSprite("Atlas_Common", "ty_btn_boss_more_AN", objMap)
    else
      if level <= ViewData.meData.level then
        objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
      else
        objMap.lab_bossCount:SetText(string.GetColorText(string.format("Lv.%s", level), ItemQuality2ColorDic[7]))
      end
      root:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap)
    end
  else
    if level <= ViewData.meData.level then
      objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
    else
      objMap.lab_bossCount:SetText(string.GetColorText(string.format("Lv.%s", level), ItemQuality2ColorDic[7]))
    end
    root:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap)
  end
  objMap:SetOnClick(self, function()
    self:EnterSecret(transfer.id, pos)
  end)
  objMap:SetActive(true)
  self.bossMapTbl[timeId] = objMap
end

function BossUI_SecretBossTemp:ShowTimer(surplusTime, lab_countdown, index, type)
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetText(timeStr)
  lab_countdown:SetActive(0 < surplusTime)
  
  local function UpdateTimer()
    if surplusTime <= 1 then
      lab_countdown:SetActive(type and type == MonsterBossType.secretBoss)
      if self.normalTimer[index] then
        Timer.Stop(self.normalTimer[index])
        self.normalTimer[index] = nil
      end
    end
    surplusTime = surplusTime - 1
    local timeStrB = TimeUtility.ShowTimeWithColon(surplusTime)
    if type and type == MonsterBossType.secretBoss then
      if surplusTime <= 1 then
        lab_countdown:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
      else
        lab_countdown:SetText(string.GetColorText(tostring(timeStrB), ItemQuality2ColorDic[7]))
      end
    else
      lab_countdown:SetText(timeStrB)
    end
  end
  
  if self.normalTimer[index] then
    lab_countdown:SetActive(false)
    Timer.Stop(self.normalTimer[index])
    self.normalTimer[index] = nil
  end
  lab_countdown:SetActive(type and type == MonsterBossType.secretBoss)
  self.normalTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function BossUI_SecretBossTemp:EnterSecret(transferId, point)
  if TranScriptData.InTranscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  local isTask = TranScriptData.GetSecretBossIsTask()
  if isTask and transferId == 210100001 then
    local mapData = {
      mapId = tonumber(TranScriptData.secretBossPreTask[2])
    }
    PathFinderManager.FlyTransferScene(transferId, nil, nil, nil, function()
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end)
    return
  end
  if not transferId or transferId == 0 then
    return
  end
  local transferRom
  if type(transferId) == "table" then
    transferRom = transferId[Mathf.Random(1, #transferId)]
  else
    transferRom = transferId
  end
  local transfer = TranScriptData.GetTransferTableInID(transferRom)
  local positionTal = string.split(transfer.position, "#")
  local position = positionTal[Mathf.Random(1, #positionTal)]
  local tempPoint = PathFinderManager.GetCalcPosData(position)
  PathFinderManager.JumpMapToMoveToPos(transfer.groupId, tempPoint, nil, nil, nil, Purpose.None, function()
    if QiJiHelperData.isAutoFight == false then
      RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
    end
  end, 2, true)
end

function BossUI_SecretBossTemp:InitUI()
  self.lab_rewards:SetAnchoredPosition(294, -111)
  self.lab_countleft:SetActive(true)
  self.mapName:SetActive(true)
  self.btn_enter:SetActive(false)
end

function BossUI_SecretBossTemp:DestroyAllTimer()
  for k, v in pairs(self.normalTimer) do
    Timer.Stop(v)
    self.normalTimer[k] = nil
  end
  self.normalTimer = {}
end

function BossUI_SecretBossTemp:DestroyAllReward()
  for k, v in pairs(self.modelReward) do
    v:Destroy()
  end
  self.modelReward = {}
end

function BossUI_SecretBossTemp:DestroyAllEffect()
  for k, v in pairs(self.effectList) do
    v:Destroy()
  end
  self.effectList = {}
end

function BossUI_SecretBossTemp:SetCopyAward(monsterBossTbl, monsterTbl)
  local tabReward = MonsterData.GetRewardTbl(monsterBossTbl)
  local childCount = self.grid_rewardsinfo.transform.childCount
  local obj
  if childCount > #tabReward then
    for index = #tabReward, childCount - 1 do
      obj = self.grid_rewardsinfo.transform:GetChild(index).gameObject
      obj:SetActive(false)
    end
  end
  for k, v in pairs(self.modelReward) do
    v:SetActive(false)
  end
  for i, v in pairs(self.effectList) do
    v:SetActive(false)
  end
  for index = 1, #tabReward do
    local rewardtbl = string.split(tabReward[index].id, "#")
    local rewardid = tonumber(rewardtbl[1])
    local itemData = ItemUtility.GenerateItemData(rewardid)
    local propCount, propEffectName = 0, ""
    local propData = self:GetPropData(monsterTbl.id)
    if propData ~= nil and propData.propId == rewardid then
      propCount = propData.propCount
      propEffectName = propData.effectName
    end
    local i = ViewData.meData.id .. monsterBossTbl.id .. rewardid
    if not table.containsKey(self.modelReward, i) then
      obj = Instantiate(self.grid_rewardsinfo.transform:GetChild(0).gameObject)
      obj.transform:SetParent(self.grid_rewardsinfo.transform, false)
      obj = UIControl(obj.transform)
      obj:SetActive(true)
      if tabReward[index].isEff and not obj.Eff then
        obj.Eff = UIEffectUtility.SetUIEffect("Eff_UI_xuanshangjiangli02", obj, true, Vector3(2, 2, 500))
      end
      if not string.isNullOrEmpty(propEffectName) then
        if self.effectList[propEffectName] == nil then
          self.effectList[propEffectName] = UIEffectUtility.SetUIEffect(propEffectName, obj.transform:GetChild("ItemEffect"), true)
        end
        self.effectList[propEffectName].transform:SetParent(obj.transform:GetChild("ItemEffect"), false)
        self.effectList[propEffectName]:SetActive(true)
      end
      itemData.count = propCount
      obj.itemCellData = obj.itemCellData or ItemCellData()
      obj.itemCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(obj, obj.itemCellData, root, true)
      self.modelReward[i] = obj
    else
      obj = self.modelReward[i]
      if obj.countCtr.transform then
        local showCount = obj.itemCellData.itemData ~= nil and obj.itemCellData.itemData.tblItem.overlying ~= 1
        local countStr = ""
        if showCount then
          if type(propCount) == "number" then
            countStr = propCount == 1 and "" or MathUtility.TransNumber(propCount, 1)
          else
            countStr = propCount
          end
        end
        obj.countCtr:SetText(countStr)
        obj.countCtr:SetActive(not string.isNullOrEmpty(countStr))
      end
      if not string.isNullOrEmpty(propEffectName) then
        if self.effectList[propEffectName] == nil then
          self.effectList[propEffectName] = UIEffectUtility.SetUIEffect(propEffectName, obj.transform:GetChild("ItemEffect"), true)
        end
        self.effectList[propEffectName].transform:SetParent(obj.transform:GetChild("ItemEffect"), false)
        self.effectList[propEffectName]:SetActive(true)
      end
      obj:SetActive(true)
    end
  end
  for k, v in pairs(self.modelRewardBelong) do
    v:SetActive(false)
  end
  local BelongRewardID = MonsterData.GetBelongReward(monsterBossTbl.mapId)
  for index = 1, #BelongRewardID do
    local itemData = ItemUtility.GenerateItemData(BelongRewardID[index])
    local i = ViewData.meData.id .. monsterBossTbl.id .. BelongRewardID[index]
    local objBelong
    if not table.containsKey(self.modelRewardBelong, i) then
      objBelong = Instantiate(self.grid_rewardsinfoBelong.transform:GetChild(0).gameObject)
      objBelong.transform:SetParent(self.grid_rewardsinfoBelong.transform, false)
      objBelong = UIControl(objBelong.transform)
      objBelong:SetActive(true)
      objBelong.itemCellData = objBelong.itemCellData or ItemCellData()
      objBelong.itemCellData:RefreshData(itemData)
      ItemUtility.ShowItemCell(objBelong, objBelong.itemCellData, root, true)
      self.modelRewardBelong[i] = objBelong
    else
      objBelong = self.modelRewardBelong[i]
      objBelong:SetActive(true)
    end
  end
end

function BossUI_SecretBossTemp:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:DestroyAllTimer()
  self:DestroyAllReward()
  self:DestroyAllEffect()
  self:SetDefaultLevelSecretBossIndex()
  self:RefreshTableView(self.secretSelectIndex)
  self:InitUI()
end

function BossUI_SecretBossTemp:GetPropData(monsterBossId)
  if self.propDataList == nil then
    self.propDataList = {}
  end
  if self.propDataList[monsterBossId] == nil then
    local rewardConfig = GlobalConfig.GetGlobalConfig(2800015)
    if string.find(rewardConfig, "&") then
      local rewardTab = string.split(rewardConfig, "&")
      for i, v in pairs(rewardTab) do
        if string.find(v, "#") then
          local itemCfg = string.split(v, "#")
          if table.count(itemCfg) == 4 and tonumber(itemCfg[1]) == monsterBossId then
            local itemData = {}
            itemData.bossId = tonumber(itemCfg[1])
            itemData.propId = tonumber(itemCfg[2])
            itemData.propCount = tonumber(itemCfg[3])
            itemData.effectName = itemCfg[4]
            self.propDataList[tonumber(itemCfg[1])] = itemData
          end
        end
      end
    end
  end
  return self.propDataList[monsterBossId]
end

return BossUI_SecretBossTemp

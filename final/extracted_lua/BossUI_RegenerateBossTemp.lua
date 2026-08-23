local BossUI_RegenerateBossTemp = {}
local root = {}

function BossUI_RegenerateBossTemp:Init()
  self:InitControls()
  self:InitData()
end

function BossUI_RegenerateBossTemp:InitControls()
  self.regenerateMapItem = self:GetControl("regenerateBossItem/tog_mapName/posScroll/Viewport/ContentRegenerate/regenerateMapItem")
  self.regenerateBossPanel_Grid = self:GetControl("Grid")
  self.lab_regenerateBossName = self:GetControl("regenerateBossItem/lab_regenerateBossName")
  self.go_modelRegenerate = self:GetControl("regenerateBossItem/go_modelRegenerate")
  self.regenerateContent = self:GetControl("levelScroll/Viewport/Content")
  self.ContentRegenerate = self:GetControl("regenerateBossItem/tog_mapName/posScroll/Viewport/ContentRegenerate")
  self.lab_regenerateReieCountAll = self:GetControl("lab_countleft/lab_countAll")
  self.btn_regenerateObtain = self:GetControl("lab_countleft/btn_obtain")
  self.regenerateLevelScroll = self:GetControl("levelScroll")
  self.levelRegenerateBtnItem = self:GetControl("levelRegenerateBtnItem")
  self.btn_BossIntegral = self:GetControl("regenerateBossItem/btn_BossIntegral")
  self.lab_BossIntegral = self:GetControl("regenerateBossItem/btn_BossIntegral/lab_num")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_RegenerateBossTemp:InitData()
  self.regenerateMapItemTemp = UIContainer(self.regenerateMapItem, self, OnMapItemCreate)
  self.bossMapTbl = {}
end

function BossUI_RegenerateBossTemp:SetDefaultLevelRegenerateBossIndex()
  self.regenerateMonsterBossTblList = MonsterData.FilterSameBossIdKeepBefore(MonsterData.GetMonsterBossType(MonsterBossType.RegenerateBoss))
  self.regenerateSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.regenerateMonsterBossTblList)
  if root.args ~= nil and root.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.regenerateMonsterBossTblList, root.args.Monsterid)
    if selectIndex then
      self.regenerateSelectIndex = selectIndex
    end
  end
end

function BossUI_RegenerateBossTemp:RefreshRenerateTableView(selectIndex)
  if self.regenerateBossTableView == nil then
    self.regenerateBossTableView = UITableView:CreateTableView(self.regenerateLevelScroll, self.levelRegenerateBtnItem, self.regenerateMonsterBossTblList, EScrollViewDireEnum.Vertical, self.UpdateRegenerateCellCallBack, self)
  end
  if self.regenerateBossTableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.regenerateBossTableView:ReloadData(smallSelectIndex)
    local obj = self.regenerateBossTableView:GetLoadedCell(selectIndex)
    self:SetRegenerateBossData(obj, self.regenerateMonsterBossTblList[selectIndex])
  end
end

function BossUI_RegenerateBossTemp:RefreshWildBossOption(data, obj, index)
  local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.id)
  if monsterConfig == nil then
    logError("Kh\195\180ng c\195\179 ID trong b\225\186\163ng cfg_Monster_monster:" .. data.id .. "d\225\187\175 li\225\187\135u c\225\187\167a, h\195\163y \196\145\225\187\131 b\225\187\153 ph\225\186\173n thi\225\186\191t k\225\186\191 ki\225\187\131m tra!!!")
    return
  end
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(data.mapId, "id")
  if mapTbl == nil then
    logError("Trong b\225\186\163ng Map_Map kh\195\180ng t\225\187\147n t\225\186\161i MapID:: " .. data.mapId .. "!!!, h\195\163y ki\225\187\131m tra ID trong b\225\186\163ng Monster_monster: " .. data.id)
    return
  end
  local isCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:WildMonsterBossCanKill(data)
  if type(level) ~= "number" and type(conditionType) ~= "number" then
    return
  end
  root:TryInitComponent(obj)
  obj.lab_name:SetText(monsterConfig.name)
  if monsterConfig.head ~= "" then
    root:SetSprite("Atlas_headPortrait", monsterConfig.head, obj.img_bossicon)
  end
  local monsterBossCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:WildMonsterBossCanKill(data)
  obj.lab_level:SetActive(monsterBossCanKill)
  obj.lab_openLevel:SetActive(not monsterBossCanKill)
  if monsterBossCanKill then
    obj.lab_level:SetText(MonsterData.Getattack_defDes(data))
  else
    local des
    local mapInfo = ClientTable.cfg_Map_mapManager:TryGetValue(data.mapId)
    local judgeDisplaylevel = true
    if mapInfo ~= nil and not table.isNullOrEmpty(mapInfo.enterCondition) then
      for i = 1, #mapInfo.enterCondition[1] do
        if mapInfo.enterCondition[1][i][1] == 7001 then
          judgeDisplaylevel = ConditionManager.Check4D({
            {
              mapInfo.enterCondition[1][i]
            }
          })
        end
      end
    end
    local displayArray = string.split(data.Displaylevel, "#")
    des = "C\225\186\165p v\195\160o: " .. string.GetColorText(displayArray[1], judgeDisplaylevel and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7])
    if string.isNullOrEmpty(des) == false then
      obj.lab_openLevel:SetText(des)
    end
  end
  obj.img_clickeffect:SetActive(index == self.regenerateSelectIndex)
  if obj.img_sign == nil then
    obj.img_sign = obj:GetChild("img_sign")
    obj.img_sign:SetActive(false)
  end
  local mapInfodata = ClientTable.cfg_Map_mapManager:TryGetValue(data.mapId)
  if mapInfodata then
    local opencross = mapInfodata.serverType
    if opencross and 2 == tonumber(opencross) then
      obj.img_sign:SetActive(true)
    else
      obj.img_sign:SetActive(false)
    end
  else
    obj.img_sign:SetActive(false)
  end
  obj:SetOnClickParam(self, self.SetRegenerateBossData, {bossMonsterTbl = data, index = index})
end

function BossUI_RegenerateBossTemp:SetRegenerateBossData(obj, bossTbl)
  if bossTbl == nil and obj.param and obj.param.bossMonsterTbl then
    bossTbl = obj.param.bossMonsterTbl
  end
  if bossTbl == nil then
    return
  end
  if obj.param and obj.param.index then
    if self.regenerateBossTableView then
      local cell = self.regenerateBossTableView:GetLoadedCell(self.regenerateSelectIndex)
      if cell then
        cell.img_clickeffect:SetActive(false)
      end
    end
    self.regenerateSelectIndex = obj.param.index
    obj.img_clickeffect:SetActive(true)
  end
  bossTbl = ConfigManager.FindConfigs("cfg_Monster_boss", "id", bossTbl.id)[1]
  local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(bossTbl.id, "id")
  if monsterTbl.monsterScore ~= 0 then
    self.btn_BossIntegral:SetActive(true)
    self.lab_BossIntegral:SetText(monsterTbl.monsterScore)
  else
    self.btn_BossIntegral:SetActive(false)
  end
  for k, v in pairs(self.bossMapTbl) do
    v:SetActive(false)
  end
  local scale, position = MonsterData.GetMonsterScaleAndPos(bossTbl)
  root:ShowMonsterModel(monsterTbl, self.go_modelRegenerate, scale, position)
  self:RefreShRegenerateBossPanel_Grid(bossTbl)
  self.lab_regenerateBossName:SetText(monsterTbl.name)
  local mapCount = MonsterPanelPosData.GetMonsterMapData(bossTbl)
  if mapCount then
    for tk, tv in pairs(mapCount) do
      local mapData = ClientTable.cfg_Map_mapManager:TryGetValue(tv.mapId, "id")
      if mapData.enterCondition[1][1][1] ~= 1503 then
        local transferId, npcId = root:GetBossTransId(bossTbl.id, tv.mapId)
        local posTbl
        if type(transferId) == "table" then
          posTbl = transferId
        else
          posTbl = {transferId}
        end
        for i3, v3 in ipairs(posTbl) do
          local transfer = ConfigManager.FindConfigs("cfg_Map_transfer", "id", tonumber(v3))[1]
          local objMap = self.regenerateMapItemTemp:GetOrCreateItem(bossTbl.id .. transfer.id)
          local pos = string.split(transfer.position, "_")
          objMap.lab_mapName:SetText(mapData.name .. " (" .. pos[1] .. "," .. pos[2] .. ") ")
          objMap.lab_level:SetActive(false)
          local hasCountdown = false
          for _, bossInfo in pairs(tv.bossState) do
            if bossInfo.bossId == bossTbl.id and bossInfo.transferId == transfer.id and bossInfo.reliveTime > Time.GetServerSecondTime() then
              hasCountdown = true
              break
            end
          end
          if hasCountdown then
            objMap.lab_bossCount:SetText(string.GetColorText("0 con", ItemQuality2ColorDic[7]))
            root:SetSprite("Atlas_Common", "ty_btn_boss_more_AN", objMap)
          else
            if ConditionManager.Check4D(mapData.enterCondition) then
              objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
            else
              objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[7]))
            end
            root:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap)
          end
          objMap:SetParent(self.ContentRegenerate.transform)
          objMap:SetOnClick(self, function()
            self:SetMapOnClick(transferId, npcId, nil, tv.line, tv.mapId, nil)
          end)
          objMap.mapId = tv.mapId
          objMap:SetAsLastSibling()
          self.bossMapTbl[bossTbl.id .. transfer.id] = objMap
        end
      end
    end
  end
end

function BossUI_RegenerateBossTemp:SetMapOnClick(transferId, npcID, level, line, mapID, isCondition)
  if TranScriptData.InTranscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  local map = ClientTable.cfg_Map_mapManager:TryGetValue(mapID, "id")
  if not ConditionManager.Check4D(map.enterCondition) then
    local levelCondition = {}
    local vipCondition = {}
    local wingCondition = {}
    for i, v in ipairs(map.enterCondition[1]) do
      if v[1] == 3101 then
        table.insert(vipCondition, v)
      elseif v[1] == 1031 then
        table.insert(wingCondition, v)
      else
        table.insert(levelCondition, v)
      end
    end
    local IslevelCondition = ConditionManager.Check(levelCondition)
    local IsvipCondition = ConditionManager.Check(vipCondition)
    local memberTblname = ""
    local level = levelCondition ~= nil and levelCondition[1][2] or ""
    if vipCondition ~= nil and vipCondition[1] ~= nil then
      local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(vipCondition[1][2])
      if memberTbl then
        memberTblname = memberTbl.name
      end
    end
    if not IsvipCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n VIP %s tr\225\187\159 l\195\170n", memberTblname))
      return
    elseif not IslevelCondition then
      FloatingTipUtility.QuickMsg(string.format("Ch\225\187\137 ng\198\176\225\187\157i ch\198\161i Chuy\225\187\131n %d m\225\187\155i c\195\179 th\225\187\131 v\195\160o", level))
      return
    end
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
  if map.serverType == serverType.self then
    if npcID and npcID ~= 0 then
      PathFinderManager.FlyTransferScene(transferRom, nil, {
        npcId = npcID,
        groupId = map.groupId
      }, Purpose.ClickNpc, function()
      end)
    else
      PathFinderManager.JumpMapToMoveToPos(transfer.groupId, tempPoint, nil, line, nil, Purpose.None, function()
        if QiJiHelperData.isAutoFight == false then
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
        end
      end, 2, true)
    end
  elseif npcID and npcID ~= 0 then
    PathFinderManager.FlyTransferScene(transferRom, nil, {
      npcId = npcID,
      index = map.groupId
    }, Purpose.ClickNpc, function()
    end)
  else
    PathFinderManager.JumpMapToMoveToPos(transfer.groupId, tempPoint, nil, line, nil, Purpose.None, function()
      if QiJiHelperData.isAutoFight == false then
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
      end
    end, 2, true)
  end
  root:btnCloseOnClick()
end

function BossUI_RegenerateBossTemp:UpdateRegenerateCellCallBack(index)
  if type(self.regenerateMonsterBossTblList) ~= "table" or next(self.regenerateMonsterBossTblList) == nil then
    return
  end
  if self.regenerateMonsterBossTblList[index] ~= nil then
    local cell = self.regenerateBossTableView:GetLoadedCell(index)
    self:RefreshWildBossOption(self.regenerateMonsterBossTblList[index], cell, index)
  end
end

function BossUI_RegenerateBossTemp:RefreShRegenerateBossPanel_Grid(monsterBossTbl)
  BossData:SetCurSelectBossTbl(monsterBossTbl)
  networkRequest.ReqMonsterDropRate({
    monsterBossTbl.id
  })
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  local length = UIUtility.GetDicLength(tblData)
  self.regenerateBossPanel_Grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.regenerateBossPanel_Grid:GetTopGridObjectList()[index]
    if self.bossDropTblDic == nil then
      self.bossDropTblDic = {}
    end
    if self.bossDropTblDic[object] == nil then
      self.bossDropTblDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.BossUI_dropListTemp, {baseUI = root})
    end
    self.bossDropTblDic[object]:Refresh(v)
    index = index + 1
  end
end

function BossUI_RegenerateBossTemp:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:SetDefaultLevelRegenerateBossIndex()
  self:RefreshRenerateTableView(self.regenerateSelectIndex)
end

return BossUI_RegenerateBossTemp

local BossUI_AngelBossTemp = {}
local root = {}

function BossUI_AngelBossTemp:Init()
  self:InitControls()
  self:InitData()
end

function BossUI_AngelBossTemp:InitControls()
  self.angelMapItem = self:GetControl("angelBossItem/tog_mapName/posScroll/Viewport/ContentAngel/angelMapItem")
  self.angelBossPanel_Grid = self:GetControl("Grid")
  self.lab_angelBossName = self:GetControl("angelBossItem/lab_angelBossName")
  self.go_modelAngel = self:GetControl("angelBossItem/go_modelAngel")
  self.angelContent = self:GetControl("levelScroll/Viewport/Content")
  self.ContentAngel = self:GetControl("angelBossItem/tog_mapName/posScroll/Viewport/ContentAngel")
  self.lab_angelReieCountAll = self:GetControl("lab_countleft/lab_countAll")
  self.btn_angelObtain = self:GetControl("lab_countleft/btn_obtain")
  self.angelLevelScroll = self:GetControl("levelScroll")
  self.levelAngelBtnItem = self:GetControl("levelAngelBtnItem")
  self.btn_BossIntegral = self:GetControl("angelBossItem/btn_BossIntegral")
  self.lab_BossIntegral = self:GetControl("angelBossItem/btn_BossIntegral/lab_num")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_AngelBossTemp:InitData()
  self.angelMapItemTemp = UIContainer(self.angelMapItem, self, OnMapItemCreate)
  self.bossMapTbl = {}
  self.normalTimer = {}
end

function BossUI_AngelBossTemp:SetDefaultLevelAngelBossIndex()
  self.angelMonsterBossTblList = MonsterData.FilterSameBossIdKeepBefore(MonsterData.GetMonsterBossType(MonsterBossType.AngelBoss))
  self.angelSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.angelMonsterBossTblList, true)
  if root.args ~= nil and root.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.angelMonsterBossTblList, root.args.Monsterid)
    if selectIndex then
      self.angelSelectIndex = selectIndex
    end
  end
end

function BossUI_AngelBossTemp:RefreshAngelTableView(selectIndex)
  if self.angelBossTableView == nil then
    self.angelBossTableView = UITableView:CreateTableView(self.angelLevelScroll, self.levelAngelBtnItem, self.angelMonsterBossTblList, EScrollViewDireEnum.Vertical, self.UpdateAngelCellCallBack, self)
  end
  if self.angelBossTableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.angelBossTableView:ReloadData(smallSelectIndex)
    local obj = self.angelBossTableView:GetLoadedCell(selectIndex)
    self:SetAngelBossData(obj, self.angelMonsterBossTblList[selectIndex])
  end
end

function BossUI_AngelBossTemp:RefreshWildBossOption(data, obj, index)
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
  local isCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:AngelBossWildMonsterBossCanKill(data)
  if type(level) ~= "number" and type(conditionType) ~= "number" then
    return
  end
  root:TryInitComponent(obj)
  obj.lab_name:SetText(monsterConfig.name)
  if monsterConfig.head ~= "" then
    root:SetSprite("Atlas_headPortrait", monsterConfig.head, obj.img_bossicon)
  end
  local monsterBossCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:AngelBossWildMonsterBossCanKill(data)
  obj.lab_level:SetActive(monsterBossCanKill)
  obj.lab_openLevel:SetActive(not monsterBossCanKill)
  if monsterBossCanKill then
    obj.lab_level:SetText(MonsterData.Getattack_defDes(data))
  else
    local des
    local mapInfo = ClientTable.cfg_Map_mapManager:TryGetValue(data.mapId)
    local judgeDisplaylevel = true
    local judgeWing = true
    if mapInfo ~= nil and not table.isNullOrEmpty(mapInfo.enterCondition) then
      for i = 1, #mapInfo.enterCondition[1] do
        if mapInfo.enterCondition[1][i][1] == 7001 then
          judgeDisplaylevel = ConditionManager.Check4D({
            {
              mapInfo.enterCondition[1][i]
            }
          })
        end
        if mapInfo.enterCondition[1][i][1] == 1031 then
          judgeWing = ConditionManager.Check4D({
            {
              mapInfo.enterCondition[1][i]
            }
          })
        end
      end
    end
    local displayArray = string.split(data.Displaylevel, "#")
    des = "C\225\186\165p v\195\160o: " .. string.GetColorText(displayArray[1], judgeDisplaylevel and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]) .. "\n"
    des = des .. "" .. string.GetColorText(displayArray[2], judgeWing and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7])
    if string.isNullOrEmpty(des) == false then
      obj.lab_openLevel:SetText(des)
    end
  end
  obj.img_clickeffect:SetActive(index == self.angelSelectIndex)
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
  obj:SetOnClickParam(self, self.SetAngelBossData, {bossMonsterTbl = data, index = index})
end

function BossUI_AngelBossTemp:SetAngelBossData(obj, bossTbl)
  if bossTbl == nil and obj.param and obj.param.bossMonsterTbl then
    bossTbl = obj.param.bossMonsterTbl
  end
  if bossTbl == nil then
    return
  end
  if obj.param and obj.param.index then
    if self.angelBossTableView then
      local cell = self.angelBossTableView:GetLoadedCell(self.angelSelectIndex)
      if cell then
        cell.img_clickeffect:SetActive(false)
      end
    end
    self.angelSelectIndex = obj.param.index
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
  root:ShowMonsterModel(monsterTbl, self.go_modelAngel, scale, position)
  self:RefreShAngelBossPanel_Grid(bossTbl)
  self.lab_angelBossName:SetText(monsterTbl.name)
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
          local objMap = self.angelMapItemTemp:GetOrCreateItem(bossTbl.id .. transfer.id)
          local pos = string.split(transfer.position, "_")
          objMap.lab_mapName:SetText(mapData.name .. " (" .. pos[1] .. "," .. pos[2] .. ") ")
          objMap.lab_level:SetActive(false)
          local hasCountdown = false
          local time
          local timeId = bossTbl.id .. transfer.id
          for _, bossInfo in pairs(tv.bossState) do
            if bossInfo.bossId == bossTbl.id and bossInfo.transferId == transfer.id then
              time = math.floor(bossInfo.reliveTime - Time.GetServerSecondTime()) or 0
              if 0 < time then
                hasCountdown = true
                break
              end
            end
          end
          if hasCountdown then
            self:ShowTimer(time, objMap.lab_bossCount, timeId, objMap)
            root:SetSprite("Atlas_Common", "ty_btn_boss_more_AN", objMap)
          else
            if ConditionManager.Check4D(mapData.enterCondition) then
              objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
            else
              objMap.lab_bossCount:SetText(string.GetColorText("1", ItemQuality2ColorDic[7]))
            end
            root:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap)
          end
          objMap:SetParent(self.ContentAngel.transform)
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

function BossUI_AngelBossTemp:ShowTimer(surplusTime, lab_countdown, index, objMap)
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    
    local timeStrB = TimeUtility.ShowTimeWithColon(surplusTime)
    if surplusTime <= 0 then
      if self.normalTimer[index] then
        Timer.Stop(self.normalTimer[index])
        self.normalTimer[index] = nil
      end
      lab_countdown:SetText(string.GetColorText("1", ItemQuality2ColorDic[5]))
      root:SetSprite("Atlas_Common", "ty_btn_boss_more_N", objMap)
    else
      lab_countdown:SetText(string.GetColorText(tostring(timeStrB), ItemQuality2ColorDic[7]))
    end
  end
  
  local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
  lab_countdown:SetText(timeStr)
  if self.normalTimer[index] then
    Timer.Stop(self.normalTimer[index])
    self.normalTimer[index] = nil
  end
  self.normalTimer[index] = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function BossUI_AngelBossTemp:SetMapOnClick(transferId, npcID, level, line, mapID, isCondition)
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
    local IsvipCondition = ConditionManager.Check(vipCondition)
    local IswingCondition = ConditionManager.Check(wingCondition)
    local IslevelCondition = ConditionManager.Check(levelCondition)
    local memberTblname = ""
    local needWingQuality = wingCondition ~= nil and wingCondition[1][2] or ""
    if needWingQuality ~= nil then
      local Boss_wingDesChangeDic = ClientTable.cfg_Global_globalManager:GetGlobal_Boss_wingDesChangeDic()
      needWingQuality = Boss_wingDesChangeDic[needWingQuality]
    end
    local level = levelCondition ~= nil and levelCondition[1][2] or ""
    if vipCondition ~= nil and vipCondition[1] ~= nil then
      local memberTbl = ClientTable.cfg_MemberManager:TryGetValue(vipCondition[1][2])
      if memberTbl then
        memberTblname = memberTbl.name
      end
    end
    if not IsvipCondition and not IswingCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n VIP %s tr\225\187\159 l\195\170n, C\195\161nh ph\225\186\169m ch\225\186\165t %s tr\225\187\159 l\195\170n", memberTblname, needWingQuality))
      return
    elseif not IslevelCondition and not IswingCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n Chuy\225\187\131n %d tr\225\187\159 l\195\170n, C\195\161nh ph\225\186\169m ch\225\186\165t %s tr\225\187\159 l\195\170n", level, needWingQuality))
      return
    elseif not IswingCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n C\195\161nh ph\225\186\169m ch\225\186\165t %s tr\225\187\159 l\195\170n", needWingQuality))
      return
    elseif not IsvipCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n VIP %s tr\225\187\159 l\195\170n", memberTblname))
      return
    elseif not IslevelCondition then
      FloatingTipUtility.QuickMsg(string.format("C\225\186\167n Chuy\225\187\131n %d tr\225\187\159 l\195\170n", level))
      return
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

function BossUI_AngelBossTemp:UpdateAngelCellCallBack(index)
  if type(self.angelMonsterBossTblList) ~= "table" or next(self.angelMonsterBossTblList) == nil then
    return
  end
  if self.angelMonsterBossTblList[index] ~= nil then
    local cell = self.angelBossTableView:GetLoadedCell(index)
    self:RefreshWildBossOption(self.angelMonsterBossTblList[index], cell, index)
  end
end

function BossUI_AngelBossTemp:RefreShAngelBossPanel_Grid(monsterBossTbl)
  BossData:SetCurSelectBossTbl(monsterBossTbl)
  networkRequest.ReqMonsterDropRate({
    monsterBossTbl.id
  })
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  local length = UIUtility.GetDicLength(tblData)
  self.angelBossPanel_Grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.angelBossPanel_Grid:GetTopGridObjectList()[index]
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

function BossUI_AngelBossTemp:DestroyAllTimer()
  for k, v in pairs(self.normalTimer) do
    Timer.Stop(v)
    self.normalTimer[k] = nil
  end
  self.normalTimer = {}
end

function BossUI_AngelBossTemp:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:DestroyAllTimer()
  self:SetDefaultLevelAngelBossIndex()
  self:RefreshAngelTableView(self.angelSelectIndex)
end

return BossUI_AngelBossTemp

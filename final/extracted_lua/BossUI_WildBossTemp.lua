local BossUI_WildBossTemp = {}
local root = {}

function BossUI_WildBossTemp:Init()
  self:InitControls()
  self:InitData()
end

function BossUI_WildBossTemp:InitControls()
  self.levelScroll = self:GetControl("levelScroll")
  self.wildBtnItem = self:GetControl("wildBtnItem")
  self.wildContent = self:GetControl("levelScroll/Viewport/Content")
  self.wildBossItem = self:GetControl("wildBossItem")
  self.go_modelWild = self:GetControl("wildBossItem/go_modelWild")
  self.lab_wildBossName = self:GetControl("wildBossItem/lab_wildBossName")
  self.Viewport = self:GetControl("wildBossItem/tog_mapName/posScroll/Viewport")
  self.top_arrow = self:GetControl("wildBossItem/tog_mapName/top_arrow")
  self.down_arrow = self:GetControl("wildBossItem/tog_mapName/down_arrow")
  self.ContentWild = self:GetControl("wildBossItem/tog_mapName/posScroll/Viewport/ContentWild")
  self.wildMapItem = self:GetControl("wildBossItem/tog_mapName/posScroll/Viewport/ContentWild/wildMapItem")
  self.lab_desWild = self:GetControl("wildBossItem/des/lab_desWild")
  self.wildBossContent = self:GetControl("grid_rewardsInfo2/awardScroll/Viewport/wildBossContent")
  self.btn_wild3DItem = self:GetControl("grid_rewardsInfo2/awardScroll/Viewport/wildBossContent/btn_wild3DItem")
  self.wildBossPanel_Grid = self:GetControl("Grid")
  self.btn_BossIntegral = self:GetControl("wildBossItem/btn_BossIntegral")
  self.lab_BossIntegral = self:GetControl("wildBossItem/btn_BossIntegral/lab_num")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_WildBossTemp:InitData()
  self.wildMapItemTemp = UIContainer(self.wildMapItem, self, OnMapItemCreate)
  self.bossMapTbl = {}
end

function BossUI_WildBossTemp:SetDefaultLevelWildBossIndex()
  self.wildMonsterBossTblList = MonsterData.FilterSameBossId(MonsterData.GetMonsterBossType(MonsterBossType.wildBoss, true))
  self.wildSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.wildMonsterBossTblList)
  if root.args ~= nil and root.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.wildMonsterBossTblList, root.args.Monsterid)
    if selectIndex then
      self.wildSelectIndex = selectIndex
    end
  end
end

function BossUI_WildBossTemp:RefreshWildTableView(selectIndex)
  if self.wildBossTableView == nil then
    self.wildBossTableView = UITableView:CreateTableView(self.levelScroll, self.wildBtnItem, self.wildMonsterBossTblList, EScrollViewDireEnum.Vertical, self.UpdateWildCellCallBack, self)
  end
  if self.wildBossTableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.wildBossTableView:ReloadData(smallSelectIndex)
    local obj = self.wildBossTableView:GetLoadedCell(selectIndex)
    self:SetWildBossData(obj, self.wildMonsterBossTblList[selectIndex])
  end
end

function BossUI_WildBossTemp:UpdateWildCellCallBack(index)
  if type(self.wildMonsterBossTblList) ~= "table" or next(self.wildMonsterBossTblList) == nil then
    return
  end
  if self.wildMonsterBossTblList[index] ~= nil then
    local cell = self.wildBossTableView:GetLoadedCell(index)
    self:RefreshWildBossOption(self.wildMonsterBossTblList[index], cell, index)
  end
end

function BossUI_WildBossTemp:RefreshWildBossOption(data, obj, index)
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
  local monsterBossCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:WildMonsterBossCanKill(data)
  if type(level) ~= "number" and type(conditionType) ~= "number" then
    return
  end
  root:TryInitComponent(obj)
  obj.lab_name:SetText(monsterConfig.name)
  if monsterConfig.head ~= 0 then
    root:SetSprite("Atlas_headPortrait", monsterConfig.head, obj.img_bossicon)
  end
  obj.lab_level:SetActive(monsterBossCanKill)
  obj.lab_openLevel:SetActive(not monsterBossCanKill)
  if monsterBossCanKill then
    obj.lab_level:SetText(MonsterData.Getattack_defDes(data))
  else
    local des = "C\225\186\165p m\225\187\159: " .. string.GetColorText(data.Displaylevel, ItemQuality2ColorDic[7])
    obj.lab_openLevel:SetText(des)
  end
  obj.img_clickeffect:SetActive(index == self.wildSelectIndex)
  obj:SetOnClickParam(self, self.SetWildBossData, {bossMonsterTbl = data, index = index})
end

function BossUI_WildBossTemp:SetWildBossData(obj, bossTbl)
  if bossTbl == nil and obj.param and obj.param.bossMonsterTbl then
    bossTbl = obj.param.bossMonsterTbl
  end
  if bossTbl == nil then
    return
  end
  if obj.param and obj.param.index then
    if self.wildBossTableView then
      local cell = self.wildBossTableView:GetLoadedCell(self.wildSelectIndex)
      if cell then
        cell.img_clickeffect:SetActive(false)
      end
    end
    self.wildSelectIndex = obj.param.index
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
  local des = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(tostring(bossTbl.description), "id")
  if des then
    self.lab_desWild:SetText(des.content)
  end
  local scale, position = MonsterData.GetMonsterScaleAndPos(bossTbl)
  root:ShowMonsterModel(monsterTbl, self.go_modelWild, scale, position)
  self:RefreShWildBossPanel_Grid(bossTbl)
  self.lab_wildBossName:SetText(monsterTbl.name)
  local mapCount = MonsterPanelPosData.GetMonsterMapData(bossTbl)
  if mapCount then
    for tk, tv in pairs(mapCount) do
      local mapData = ClientTable.cfg_Map_mapManager:TryGetValue(tv.mapId, "id")
      if mapData.enterCondition[1][1][1] ~= 1503 then
        local transferId, npcId = root:GetBossTransId(bossTbl.id, tv.mapId)
        local objMap = self.wildMapItemTemp:GetOrCreateItem(bossTbl.id .. tv.mapId .. tv.line)
        local condition = mapData.enterCondition
        local levelStr, isVip, isShow = root:SetMapCount(tv, objMap, condition, mapData)
        objMap.lab_bossCount:SetActive(not objMap.lab_level:GetActive())
        objMap:SetParent(self.ContentWild.transform)
        objMap:SetOnClick(self, function()
          self:SetMapOnClick(transferId, npcId, levelStr, tv.line, tv.mapId, isVip)
        end)
        objMap.mapId = tv.mapId
        objMap:SetAsLastSibling()
        objMap:SetActive(isShow)
        self.bossMapTbl[bossTbl.id .. tv.mapId .. tv.line] = objMap
      end
    end
  end
end

function BossUI_WildBossTemp:SetMapOnClick(transferId, npcID, level, line, mapID, isCondition)
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
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end
    end, 2, true)
  end
  root:btnCloseOnClick()
end

function BossUI_WildBossTemp:RefreShWildBossPanel_Grid(monsterBossTbl)
  BossData:SetCurSelectBossTbl(monsterBossTbl)
  networkRequest.ReqMonsterDropRate({
    monsterBossTbl.id
  })
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  local length = UIUtility.GetDicLength(tblData)
  self.wildBossPanel_Grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.wildBossPanel_Grid:GetTopGridObjectList()[index]
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

function BossUI_WildBossTemp:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:SetDefaultLevelWildBossIndex()
  self:RefreshWildTableView(self.wildSelectIndex)
end

return BossUI_WildBossTemp

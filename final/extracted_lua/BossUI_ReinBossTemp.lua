local BossUI_ReinBossTemp = {}
local root = {}

function BossUI_ReinBossTemp:Init()
  self:InitControls()
  self:InitData()
end

function BossUI_ReinBossTemp:InitControls()
  self.reinMapItem = self:GetControl("reinBossItem/tog_mapName/posScroll/Viewport/ContentWild/reinMapItem")
  self.reinBossPanel_Grid = self:GetControl("Grid")
  self.lab_reinBossName = self:GetControl("reinBossItem/lab_reinBossName")
  self.go_modelRein = self:GetControl("reinBossItem/go_modelRein")
  self.reinContent = self:GetControl("levelScroll/Viewport/reinContent")
  self.ContentRein = self:GetControl("reinBossItem/tog_mapName/posScroll/Viewport/ContentWild")
  self.lab_ReieCountAll = self:GetControl("lab_countleft/lab_countAll")
  self.btn_obtain = self:GetControl("lab_countleft/btn_obtain")
  self.reinLevelScroll = self:GetControl("levelScroll")
  self.levelReinBtnItem = self:GetControl("levelReinBtnItem")
  self.btn_BossIntegral = self:GetControl("reinBossItem/btn_BossIntegral")
  self.lab_BossIntegral = self:GetControl("reinBossItem/btn_BossIntegral/lab_num")
end

local function OnMapItemCreate(control)
  control.lab_level = UIControl(control.transform, "lab_level")
  control.lab_mapName = UIControl(control.transform, "lab_mapName")
  control.lab_bossCount = UIControl(control.transform, "lab_bossCount")
end

function BossUI_ReinBossTemp:InitData()
  self.reinMapItemTemp = UIContainer(self.reinMapItem, self, OnMapItemCreate)
  self.bossMapTbl = {}
end

function BossUI_ReinBossTemp:SetDefaultLevelReinBossIndex()
  self.reinMonsterBossTblList = MonsterData.FilterSameBossId(MonsterData.GetMonsterBossType(MonsterBossType.reinBoss))
  self.reinSelectIndex = ClientTable.cfg_Monster_bossManager:GetRecommendWildIndex(RoleManager.me.level, self.reinMonsterBossTblList)
  if root.args ~= nil and root.args.Monsterid ~= nil then
    local selectIndex = ClientTable.cfg_Monster_bossManager:GetArgsIndex(self.reinMonsterBossTblList, root.args.Monsterid)
    if selectIndex then
      self.reinSelectIndex = selectIndex
    end
  end
end

function BossUI_ReinBossTemp:RefreshReinTableView(selectIndex)
  if self.reinBossTableView == nil then
    self.reinBossTableView = UITableView:CreateTableView(self.reinLevelScroll, self.levelReinBtnItem, self.reinMonsterBossTblList, EScrollViewDireEnum.Vertical, self.UpdateReinCellCallBack, self)
  end
  if self.reinBossTableView ~= nil then
    local smallSelectIndex = 0
    if 3 < selectIndex then
      smallSelectIndex = selectIndex - 2
    else
      smallSelectIndex = 1
    end
    self.reinBossTableView:ReloadData(smallSelectIndex)
    local obj = self.reinBossTableView:GetLoadedCell(selectIndex)
    self:SetReinBossData(obj, self.reinMonsterBossTblList[selectIndex])
  end
end

function BossUI_ReinBossTemp:SetReinBossData(obj, bossTbl)
  if bossTbl == nil and obj.param and obj.param.bossMonsterTbl then
    bossTbl = obj.param.bossMonsterTbl
  end
  if bossTbl == nil then
    return
  end
  if obj.param and obj.param.index then
    if self.reinBossTableView then
      local cell = self.reinBossTableView:GetLoadedCell(self.reinSelectIndex)
      if cell then
        cell.img_clickeffect:SetActive(false)
      end
    end
    self.reinSelectIndex = obj.param.index
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
  root:ShowMonsterModel(monsterTbl, self.go_modelRein, scale, position)
  self:RefreShReinBossPanel_Grid(bossTbl)
  self.lab_reinBossName:SetText(monsterTbl.name)
  local mapCount = MonsterPanelPosData.GetMonsterMapData(bossTbl)
  if mapCount then
    for tk, tv in pairs(mapCount) do
      local mapData = ClientTable.cfg_Map_mapManager:TryGetValue(tv.mapId, "id")
      if mapData.enterCondition[1][1][1] ~= 1503 then
        do
          local transferId, npcId = root:GetBossTransId(bossTbl.id, tv.mapId)
          local posTbl
          if type(transferId) == "table" then
            posTbl = transferId
          else
            posTbl = {transferId}
          end
          for i3, v3 in ipairs(posTbl) do
            local transfer = ConfigManager.FindConfigs("cfg_Map_transfer", "id", tonumber(v3))[1]
            local objMap = self.reinMapItemTemp:GetOrCreateItem(bossTbl.id .. transfer.id)
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
            objMap:SetParent(self.ContentRein.transform)
            objMap:SetOnClick(self, function()
              self:JumpToNpc(transfer.id, bossTbl.npcId, tv.line, tv.mapId, mapData.enterCondition)
            end)
            objMap.mapId = tv.mapId
            objMap:SetAsLastSibling()
            self.bossMapTbl[bossTbl.id .. transfer.id] = objMap
          end
        end
      end
    end
  end
end

function BossUI_ReinBossTemp:JumpToNpc(transferId, npcId, line, mapId, enterCondition)
  if TranScriptData.InTranscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    return
  end
  local levelCondition = {}
  local vipCondition = {}
  for i, v in ipairs(enterCondition[1]) do
    if v[1] == 3101 then
      table.insert(vipCondition, v)
    else
      table.insert(levelCondition, v)
    end
  end
  if not ConditionManager.Check(levelCondition) then
    local rein = Mathf.Floor(levelCondition[1][2])
    FloatingTipUtility.QuickMsg(string.format("Ch\225\187\137 ng\198\176\225\187\157i ch\198\161i Chuy\225\187\131n %d m\225\187\155i c\195\179 th\225\187\131 v\195\160o", rein))
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
  local mapTransferData = ClientTable.cfg_Map_transferManager:TryGetValue(transferId)
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
  local groupId = mapTransferData.groupId
  if npcId == 10520101 then
    local vipMapTab = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(6030021).effect, "#")
    for i = 1, #vipMapTab do
      if mapId == tonumber(vipMapTab[i]) then
        npcId = 10530101
        break
      end
    end
  end
  PathFinderManager.FlyTransferScene(npcId, line, {
    npcId = npcId,
    groupId = groupId,
    index = mapId
  }, Purpose.ClickNpc, function()
  end)
  root:btnCloseOnClick()
end

function BossUI_ReinBossTemp:UpdateReinCellCallBack(index)
  if type(self.reinMonsterBossTblList) ~= "table" or next(self.reinMonsterBossTblList) == nil then
    return
  end
  if self.reinMonsterBossTblList[index] ~= nil then
    local cell = self.reinBossTableView:GetLoadedCell(index)
    self:RefreshWildBossOption(self.reinMonsterBossTblList[index], cell, index)
  end
end

function BossUI_ReinBossTemp:RefreshWildBossOption(data, obj, index)
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
  if monsterConfig.head ~= 0 then
    root:SetSprite("Atlas_headPortrait", monsterConfig.head, obj.img_bossicon)
  end
  local monsterBossCanKill, level, conditionType = ClientTable.cfg_Monster_bossManager:WildMonsterBossCanKill(data)
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
  obj.lab_level:SetActive(monsterBossCanKill)
  obj.lab_openLevel:SetActive(not monsterBossCanKill)
  if monsterBossCanKill then
    obj.lab_level:SetText(MonsterData.Getattack_defDes(data))
  else
    local des = "C\225\186\165p m\225\187\159: " .. string.GetColorText(data.Displaylevel, ItemQuality2ColorDic[7])
    if string.isNullOrEmpty(des) == false then
      obj.lab_openLevel:SetText(des)
    end
  end
  obj.img_clickeffect:SetActive(index == self.reinSelectIndex)
  obj:SetOnClickParam(self, self.SetReinBossData, {bossMonsterTbl = data, index = index})
end

function BossUI_ReinBossTemp:RefreShReinBossPanel_Grid(monsterBossTbl)
  BossData:SetCurSelectBossTbl(monsterBossTbl)
  networkRequest.ReqMonsterDropRate({
    monsterBossTbl.id
  })
  local tblData = MonsterData.GetBossShowDropItemList(monsterBossTbl)
  local length = UIUtility.GetDicLength(tblData)
  self.reinBossPanel_Grid:SetTopGridMaxCount(length)
  local index = 0
  for i, v in pairs(tblData) do
    local object = self.reinBossPanel_Grid:GetTopGridObjectList()[index]
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

function BossUI_ReinBossTemp:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:SetDefaultLevelReinBossIndex()
  self:RefreshReinTableView(self.reinSelectIndex)
end

return BossUI_ReinBossTemp

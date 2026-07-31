local MapTeleportTemplate = {}

function MapTeleportTemplate:Init()
  self:InitComponent()
end

function MapTeleportTemplate:InitComponent()
  self.Content = self:GetControl("Viewport/Content")
  self.BtnGroup = self:GetControl("Viewport/Content/BtnGroup")
  self.MapsTip = self:GetControl("MapsTip")
  self.MapsTipCloseBg = self:GetControl("MapsTip/CloseBg")
  self.MapsTipBtn = self:GetControl("MapsTip/BtnGroup/btn_transfer")
end

function MapTeleportTemplate:RefreshData()
  self.mapTransferDataTab = {}
  self.groupDataTab = {}
  self.groupDataTab1 = {}
  self.groupDataTab2 = {}
  self.groupDataTab3 = {}
  self.groupDataTab4 = {}
  self.groupDataTab5 = {}
  self.groupDataTab6 = {}
  local tempDataTab = self:GetMapTransferData()
  for i, v in ipairs(tempDataTab) do
    local mapData = self:GetMapData(v.groupId)
    if self.mapTransferDataTab[mapData.groupId] == nil then
      self.mapTransferDataTab[mapData.groupId] = {}
      table.insert(self.mapTransferDataTab[mapData.groupId], v)
      if v.maptype == 0 then
        table.insert(self.groupDataTab, mapData)
      elseif v.maptype == 1 then
        table.insert(self.groupDataTab1, mapData)
      elseif v.maptype == 2 then
        table.insert(self.groupDataTab2, mapData)
      elseif v.maptype == 3 then
        table.insert(self.groupDataTab3, mapData)
      elseif v.maptype == 4 then
        table.insert(self.groupDataTab4, mapData)
      elseif v.maptype == 5 then
        table.insert(self.groupDataTab5, mapData)
      elseif v.maptype == 6 then
        table.insert(self.groupDataTab6, mapData)
      end
    else
      table.insert(self.mapTransferDataTab[mapData.groupId], v)
    end
  end
end

function MapTeleportTemplate:GetMapTransferData()
  local mapTransferData = ConfigManager.FindConfigs("cfg_Map_transfer", "show", 0)
  for i = table.count(mapTransferData), 1, -1 do
    if not string.isNullOrEmpty(mapTransferData[i].showCondition) and not ConditionManager.Check(mapTransferData[i].showCondition) then
      table.remove(mapTransferData, i)
    end
  end
  return mapTransferData
end

function MapTeleportTemplate:GetMapData(groupId)
  local mapTab = ConfigManager.GetConfig("cfg_Map_map", groupId, "groupId")
  if mapTab == nil then
    logError("MAPID:::: kh\195\180ng t\225\187\147n t\225\186\161i " .. groupId)
    return nil
  end
  local mapData = {}
  local index = mapTab.index
  if mapTab.indexType > 0 then
    index = mapTab.indexType
  end
  mapData.groupId = index
  mapData.groupName = mapTab.showName
  mapData.enterCondition = mapTab.enterCondition
  mapData.recommendedCondition = mapTab.refertolevel
  mapData.mapTab = mapTab
  return mapData
end

function MapTeleportTemplate:Refresh()
  self:RefreshData()
  GuideUtility.ClearAssignUIData("Main_MapDetailUI")
  if self.BtnGroupContainer == nil then
    self.BtnGroupContainer = UIContainer(self.BtnGroup, self, self.OnBtnGroupCreat, self.OnBtnGroupRefresh)
  end
  self.ShowTogInfo = {}
  if #self.groupDataTab > 0 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 c\225\186\165p",
      groupDataTab = self.groupDataTab
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab1 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 1",
      groupDataTab = self.groupDataTab1
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab2 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 2",
      groupDataTab = self.groupDataTab2
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab3 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 3",
      groupDataTab = self.groupDataTab3
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab4 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 4",
      groupDataTab = self.groupDataTab4
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab5 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 5",
      groupDataTab = self.groupDataTab5
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  if 0 < #self.groupDataTab6 then
    local groupData = {
      txtTitle = "B\225\186\163n \196\145\225\187\147 Chuy\225\187\131n 6",
      groupDataTab = self.groupDataTab6
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  self:GetRecommendedGroupId()
  self.BtnGroupContainer:SetData(self.ShowTogInfo)
  self.MapsTip:SetActive(false)
  self:SetShowTogInfo()
  
  local function waitSetNormalizedPosition()
    Coroutine.Wait(0.1)
    self:SetNormalizedPosition()
  end
  
  Coroutine.Start(waitSetNormalizedPosition)
end

function MapTeleportTemplate:GetRecommendedGroupId()
  local groupDataTabs = {}
  self:MergeTable(groupDataTabs, self.groupDataTab)
  self:MergeTable(groupDataTabs, self.groupDataTab1)
  self:MergeTable(groupDataTabs, self.groupDataTab2)
  self:MergeTable(groupDataTabs, self.groupDataTab3)
  self:MergeTable(groupDataTabs, self.groupDataTab4)
  self:MergeTable(groupDataTabs, self.groupDataTab5)
  self:MergeTable(groupDataTabs, self.groupDataTab6)
  local countCanEnter = #groupDataTabs
  for i, v in ipairs(groupDataTabs) do
    if not string.isNullOrEmpty(v.recommendedCondition) and not ConditionManager.Check4D(v.recommendedCondition) then
      countCanEnter = i - 1
      break
    end
  end
  if 0 < countCanEnter then
    self.recommendedGroupId = groupDataTabs[countCanEnter].groupId
  end
end

function MapTeleportTemplate:MergeTable(t1, t2)
  for i, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

function MapTeleportTemplate:SetShowTogInfo()
  local togInfo = self.ShowTogInfo[1]
  for i, v in ipairs(self.ShowTogInfo) do
    for i2, v2 in ipairs(v.groupDataTab) do
      if v2.groupId == self.recommendedGroupId then
        togInfo = v
        goto lbl_21
      end
    end
  end
  ::lbl_21::
  self:MainBtnOnClick({data = togInfo})
end

function MapTeleportTemplate:SetNormalizedPosition()
  local w1, h1 = self.Content:GetSizeDelta()
  local w2, h2 = self:GetControl():GetSizeDelta()
  local deltaH = h1 - h2
  if deltaH <= 0 then
    return
  end
  local verticalNormalizedPosition = 1
  if self.mapRecommendedBtn then
    local mapWhereMePosY = 0
    local posX, posY
    posX, posY = self.mapRecommendedBtn:GetAnchoredPosition()
    mapWhereMePosY = mapWhereMePosY + posY
    posX, posY = self.mapRecommendedBtn:GetParent():GetAnchoredPosition()
    mapWhereMePosY = mapWhereMePosY + posY
    posX, posY = self.mapRecommendedBtn:GetParent().parent:GetAnchoredPosition()
    mapWhereMePosY = mapWhereMePosY + posY
    local dist1 = -mapWhereMePosY
    local dist2 = h1 - dist1
    local dist3 = dist2 - h2 / 2
    verticalNormalizedPosition = Mathf.Clamp01(dist3 / deltaH)
  end
  self:GetControl():SetNormalizedPosition(1, verticalNormalizedPosition)
end

function MapTeleportTemplate.OnBtnGroupCreat(ctr)
  ctr.btn_main = UIControl(ctr.transform, "MainBtn")
  ctr.lab_name = UIControl(ctr.transform, "MainBtn/lab_name")
  ctr.subBtnGroup = UIControl(ctr.transform, "SubBtnGroup")
end

function MapTeleportTemplate.OnBtnGroupRefresh(ctr, _, data, ui)
  ctr.btn_main.data = data
  ctr.btn_main:SetOnClick(ui, ui.MainBtnOnClick)
  ctr.lab_name:SetText(data.txtTitle)
  if ctr.subTogContainer == nil then
    ctr.subTogContainer = UIContainer(ctr.subBtnGroup:GetChild("btn_transfer"), ui, ui.OnSubTogCreat, ui.OnSubTogRefresh)
  end
  ctr.subTogContainer:SetData(data.groupDataTab)
end

function MapTeleportTemplate.OnSubTogCreat(ctr)
  ctr.lab_mapname = UIControl(ctr.transform, "lab_mapname")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.img_me = UIControl(ctr.transform, "img_me")
  ctr.img_recommon = UIControl(ctr.transform, "img_recommon")
end

function MapTeleportTemplate.OnSubTogRefresh(ctr, _, data, ui)
  local name1, name2
  name1, name2 = ui:GetMapNameAndConditionByID(true, ui.mapTransferDataTab[data.groupId], data.groupName)
  ctr.lab_mapname:SetText(name1)
  ctr.lab_level:SetText(name2)
  local isMapWhereMe = ui:IsMapWhereMe(ui.mapTransferDataTab[data.groupId])
  if isMapWhereMe then
    ui.mapWhereMeBtn = ctr
  end
  ctr.img_me:SetActive(isMapWhereMe)
  local isMapRecommendedBtn = ui.recommendedGroupId == data.groupId
  if isMapRecommendedBtn then
    ui.mapRecommendedBtn = ctr
  end
  ctr.img_recommon:SetActive(isMapRecommendedBtn)
  ctr.data = data
  ctr:SetOnClick(ui, ui.SubBtnOnClick)
  GuideUtility.AddCreatObj("Main_MapDetailUI", ctr)
end

function MapTeleportTemplate:GetMapNameAndConditionByID(isParent, data, name)
  local name1 = ""
  local name2 = ""
  if isParent then
    local mapTransferTab = data[1]
    local mapTab = ConfigManager.GetConfig("cfg_Map_map", mapTransferTab.groupId, "id")
    local mapTransferTab2 = data[#data]
    local mapTab2 = ConfigManager.GetConfig("cfg_Map_map", mapTransferTab2.groupId, "id")
    if ConditionManager.Check4D(mapTab.enterCondition) or ConditionManager.Check4D(mapTab2.enterCondition) then
      name1 = name
    else
      local textLevel
      local conditionType = mapTab.enterCondition[1][1][1]
      local level = mapTab.enterCondition[1][1][2]
      if conditionType == 7001 then
        textLevel = "Chuy\225\187\131n" .. " " .. level
      elseif conditionType == 101 then
        local rein = Mathf.Floor(level / 400)
        level = level % 400
        textLevel = string.format("Chuy\225\187\131n %d Lv%d", rein, level)
      end
      local textMem
      if mapTab2.enterCondition[1][2] and mapTab2.enterCondition[1][2][1] == 3101 then
        textMem = mapTab2.viplevel
      end
      if textMem then
        name1 = string.format("%s ho\225\186\183c %s m\225\187\159 kh\195\179a", textLevel, textMem)
      else
        name1 = string.format("%s m\225\187\159 kh\195\179a", textLevel)
      end
      name1 = string.GetColorText(name1, "#FF0000")
    end
    return name1, name2
  else
    local mapTransferTab = data
    local mapTab = ConfigManager.GetConfig("cfg_Map_map", mapTransferTab.groupId, "id")
    if mapTransferTab.maptype == 1001 then
      if ConditionManager.GenerateSingleCondition(mapTab.enterCondition[1][1]):Check() then
        name1 = mapTransferTab.name
      else
        name1 = string.GetColorText(mapTransferTab.name, "#FF0000")
      end
      if ConditionManager.GenerateSingleCondition(mapTab.enterCondition[1][2]):Check() then
        name2 = mapTab.viplevel
      else
        name2 = string.GetColorText(mapTab.viplevel, "#FF0000")
      end
      return name1, name2
    else
      if ConditionManager.Check4D(mapTab.enterCondition) then
        name1 = mapTransferTab.name
      else
        name1 = mapTransferTab.name
        local conditionType = mapTab.enterCondition[1][1][1]
        local level = mapTab.enterCondition[1][1][2]
        if conditionType == 7001 then
          name2 = string.GetColorText("Chuy\225\187\131n " .. level, "#FF0000")
        else
          level = level % 400
          name2 = string.GetColorText("Lv." .. level, "#FF0000")
        end
      end
      return name1, name2
    end
  end
end

function MapTeleportTemplate:IsMapWhereMe(data)
  for i, v in ipairs(data) do
    if v.groupId == SceneData.groupId then
      return true
    end
  end
  return false
end

function MapTeleportTemplate:MainBtnOnClick(control)
  local data = control.data
  if not data then
    return
  end
  self:SetBtnPitchOn(data)
end

function MapTeleportTemplate:SubBtnOnClick(control)
  local data = control.data
  if not data then
    return
  end
  if #self.mapTransferDataTab[data.groupId] > 1 then
    GuideUtility.ClearAssignUIData("MapsTip")
    if self.MapsTipBtnContainer == nil then
      self.MapsTipBtnContainer = UIContainer(self.MapsTipBtn, self, self.OnMapsTipBtnCreat, self.OnMapsTipBtnRefresh)
    end
    self.MapsTipBtnContainer:SetData(self.mapTransferDataTab[data.groupId])
    self:SetMapsTipPos(control)
    self.MapsTip:SetActive(true)
    self.MapsTipCloseBg:SetOnClick(self, function()
      self.MapsTip:SetActive(false)
    end)
  elseif #self.mapTransferDataTab[data.groupId] == 1 then
    local mapTransferData = self.mapTransferDataTab[data.groupId][1]
    if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
      UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
    end
    UIManager.Hide(UIID.MapDetailUI)
    local mapData = {
      mapId = mapTransferData.id
    }
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
    local enterCondition = self:GetMapData(mapTransferData.groupId).enterCondition
    if self:IsCanChangeMap(enterCondition) then
      EventManager.Dispatch(Event.Map_RealOperation)
    end
  end
end

function MapTeleportTemplate:SetMapsTipPos(btn)
  local mapsTipPosX, mapsTipPosY = self.MapsTip:GetAnchoredPosition()
  mapsTipPosY = 0
  local posX, posY
  posX, posY = btn:GetAnchoredPosition()
  mapsTipPosY = mapsTipPosY + posY
  posX, posY = btn:GetParent():GetAnchoredPosition()
  mapsTipPosY = mapsTipPosY + posY
  posX, posY = btn:GetParent().parent:GetAnchoredPosition()
  mapsTipPosY = mapsTipPosY + posY
  posX, posY = btn:GetParent().parent.parent:GetAnchoredPosition()
  mapsTipPosY = mapsTipPosY + posY
  posX, posY = btn:GetParent().parent.parent.parent:GetAnchoredPosition()
  mapsTipPosY = mapsTipPosY + posY
  self.MapsTip:SetAnchoredPosition(mapsTipPosX, mapsTipPosY)
end

function MapTeleportTemplate:SetBtnPitchOn(data)
  for i, v in ipairs(self.ShowTogInfo) do
    local btnGroup = self.BtnGroupContainer:GetOrCreateItem(i)
    if v.txtTitle == data.txtTitle then
      btnGroup.btn_main:GetChild("img_clickeffect"):SetActive(true)
      btnGroup.subBtnGroup:SetActive(true)
      gameMgr:GetMinMapDataMgr():SetCurSelfMapInfo(data.groupDataTab, self.mapTransferDataTab)
    else
      btnGroup.btn_main:GetChild("img_clickeffect"):SetActive(false)
      btnGroup.subBtnGroup:SetActive(false)
    end
  end
end

function MapTeleportTemplate:IsCanChangeMap(condition)
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

function MapTeleportTemplate.OnMapsTipBtnCreat(ctr)
  ctr.lab_mapname = UIControl(ctr.transform, "lab_mapname")
  ctr.img_tip = UIControl(ctr.transform, "img_tip")
  MapTeleportTemplate.SetAnimation(ctr.img_tip)
end

function MapTeleportTemplate.SetAnimation(gameObject)
  gameObject.transform:DOKill()
  local left = false
  
  local function MoveLeft()
    gameObject.transform:DOLocalMoveX(left and gameObject.transform.localPosition.x - 10 or gameObject.transform.localPosition.x + 10, 1):OnComplete(function()
      left = not left
      gameObject.transform:DOLocalMoveX(left and gameObject.transform.localPosition.x - 10 or gameObject.transform.localPosition.x + 10, 1):OnComplete(function()
        left = not left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end

function MapTeleportTemplate.OnMapsTipBtnRefresh(ctr, _, data, ui)
  local name1, name2
  name1, name2 = ui:GetMapNameAndConditionByID(false, data, data.name)
  ctr.lab_mapname:SetText(name1 .. " " .. name2)
  local isMemMap = data.maptype == 1001
  ctr.img_tip:SetActive(isMemMap and MapTeleportTemplate.IsNeedShowImg_tip())
  ctr.data = data
  ctr:SetOnClick(ui, ui.MapsTipBtnOnClick)
  GuideUtility.AddCreatObj("MapsTip", ctr)
end

function MapTeleportTemplate.IsNeedShowImg_tip()
  local taskIDList = ClientTable.cfg_Global_globalManager:GetMiniMapNeedShowImg_tipTaskIDList()
  if taskIDList == nil then
    return true
  end
  local isneedShow = true
  for i, v in pairs(taskIDList) do
    if TaskData.GetTaskById(v) ~= nil then
      return false
    end
  end
  return true
end

function MapTeleportTemplate:MapsTipBtnOnClick(control)
  local mapTransferData = control.data
  if not mapTransferData then
    return
  end
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
  self.MapsTip:SetActive(false)
  UIManager.Hide(UIID.MapDetailUI)
  if mapTransferData.maptype == 1001 then
    local transferData = ClientTable.cfg_Map_transferManager:TryGetValue(10140099)
    local groupId = mapTransferData.groupId
    PathFinderManager.FlyTransferScene(transferData.id, nil, {npcId = 1001006, groupId = groupId}, Purpose.ClickNpc, function()
    end)
    return
  end
  local mapData = {
    mapId = mapTransferData.id
  }
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  local enterCondition = self:GetMapData(mapTransferData.groupId).enterCondition
  if self:IsCanChangeMap(enterCondition) then
    EventManager.Dispatch(Event.Map_RealOperation)
  end
end

return MapTeleportTemplate

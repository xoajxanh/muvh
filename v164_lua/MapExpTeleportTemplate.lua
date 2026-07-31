local MapExpTeleportTemplate = {}

function MapExpTeleportTemplate:Init()
  self:InitComponent()
end

function MapExpTeleportTemplate:InitComponent()
  self.MainBtn = self:GetControl("MainBtn")
  self.Content = self:GetControl("Viewport/Content")
  self.BtnGroup = self:GetControl("Viewport/Content/BtnGroup")
  self.MapsTip = self:GetControl("MapsTip")
  self.MapsTipCloseBg = self:GetControl("MapsTip/CloseBg")
  self.MapsTipBtn = self:GetControl("MapsTip/BtnGroup/btn_transfer")
end

function MapExpTeleportTemplate:RefreshData()
  self.mapTransferDataTab = {}
  self.groupDataTab1001 = {}
  local tempDataTab = self:GetMapTransferData()
  for i, v in ipairs(tempDataTab) do
    if v.maptype == 1001 then
      local mapData = self:GetMapData(v.groupId)
      if self.mapTransferDataTab[mapData.groupId] == nil then
        self.mapTransferDataTab[mapData.groupId] = {}
        table.insert(self.mapTransferDataTab[mapData.groupId], v)
        table.insert(self.groupDataTab1001, mapData)
      else
        table.insert(self.mapTransferDataTab[mapData.groupId], v)
      end
    end
  end
end

function MapExpTeleportTemplate:GetMapTransferData()
  local mapTransferData = ConfigManager.FindConfigs("cfg_Map_transfer", "show", 0)
  for i = table.count(mapTransferData), 1, -1 do
    if not string.isNullOrEmpty(mapTransferData[i].showCondition) and not ConditionManager.Check(mapTransferData[i].showCondition) then
      table.remove(mapTransferData, i)
    end
  end
  return mapTransferData
end

function MapExpTeleportTemplate:GetMapData(groupId)
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
  return mapData
end

function MapExpTeleportTemplate:Refresh()
  self:RefreshData()
  if self.BtnGroupContainer == nil then
    self.BtnGroupContainer = UIContainer(self.BtnGroup, self, self.OnBtnGroupCreat, self.OnBtnGroupRefresh)
  end
  self.ShowTogInfo = {}
  if #self.groupDataTab1001 > 0 then
    local groupData = {
      txtTitle = "Ph\195\178ng Luy\225\187\135n C\195\180ngb\225\186\163n \196\145\225\187\147",
      groupDataTab = self.groupDataTab1001
    }
    table.insert(self.ShowTogInfo, groupData)
  end
  self:GetRecommendedGroupId()
  self.BtnGroupContainer:SetData(self.ShowTogInfo)
  self.MapsTip:SetActive(false)
  self:SetNormalizedPosition()
  local haveData = #self.ShowTogInfo > 0
  return haveData
end

function MapExpTeleportTemplate:GetRecommendedGroupId()
  local countCanEnter = #self.groupDataTab1001
  for i, v in ipairs(self.groupDataTab1001) do
    if not string.isNullOrEmpty(v.recommendedCondition) and not ConditionManager.Check4D(v.recommendedCondition) then
      countCanEnter = i - 1
      break
    end
  end
  self.recommendedGroupId = self.groupDataTab1001[countCanEnter].groupId
end

function MapExpTeleportTemplate:SetNormalizedPosition()
  local verticalNormalizedPosition = 1
  local countCanEnter = #self.groupDataTab1001
  for i, v in ipairs(self.groupDataTab1001) do
    if ViewData.meData.level < v.enterCondition[1][1][2] then
      countCanEnter = i - 1
      break
    end
  end
  local countAll = #self.groupDataTab1001
  local countCanNotEnter = countAll - countCanEnter
  local dist = countCanNotEnter - 2
  local deltaH = countAll - 5
  verticalNormalizedPosition = Mathf.Clamp01(dist / deltaH)
  self:GetControl():SetNormalizedPosition(1, verticalNormalizedPosition)
end

function MapExpTeleportTemplate.OnBtnGroupCreat(ctr)
  ctr.btn_main = UIControl(ctr.transform, "MainBtn")
  ctr.lab_name = UIControl(ctr.transform, "MainBtn/lab_name")
  ctr.subBtnGroup = UIControl(ctr.transform, "SubBtnGroup")
end

function MapExpTeleportTemplate.OnBtnGroupRefresh(ctr, _, data, ui)
  ctr.btn_main.data = data
  ui.MainBtn:SetOnClick(ui, ui.MainBtnOnClick)
  ctr.btn_main:SetOnClick(ui, ui.mainBtnOnClick)
  ctr.lab_name:SetText(data.txtTitle)
  if ctr.subTogContainer == nil then
    ctr.subTogContainer = UIContainer(ctr.subBtnGroup:GetChild("btn_transfer"), ui, ui.OnSubTogCreat, ui.OnSubTogRefresh)
  end
  ctr.subTogContainer:SetData(data.groupDataTab)
end

function MapExpTeleportTemplate.OnSubTogCreat(ctr)
  ctr.lab_mapname = UIControl(ctr.transform, "lab_mapname")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.img_recommon = UIControl(ctr.transform, "img_recommon")
end

function MapExpTeleportTemplate.OnSubTogRefresh(ctr, _, data, ui)
  local name1, name2
  name1, name2 = ui:GetMapNameAndConditionByID(true, ui.mapTransferDataTab[data.groupId], data.groupName)
  ctr.lab_mapname:SetText(name1)
  ctr.lab_level:SetText(name2)
  ctr.img_recommon:SetActive(ui.recommendedGroupId == data.groupId)
  ctr.data = data
  ctr:SetOnClick(ui, ui.SubBtnOnClick)
end

function MapExpTeleportTemplate:GetMapNameAndConditionByID(isParent, data, name)
  local name1 = ""
  local name2 = ""
  if isParent then
    local mapTransferTab = data[1]
    local mapTab = ConfigManager.GetConfig("cfg_Map_map", mapTransferTab.groupId, "id")
    if ConditionManager.GenerateSingleCondition(mapTab.enterCondition[1][1]):Check() then
      name1 = name
    else
      name1 = string.GetColorText(name, "#FF0000")
    end
    if ConditionManager.GenerateSingleCondition(mapTab.enterCondition[1][2]):Check() then
      name2 = mapTab.viplevel
    else
      name2 = string.GetColorText(mapTab.viplevel, "#FF0000")
    end
    return name1, name2
  else
    local mapTransferTab = data
    local mapTab = ConfigManager.GetConfig("cfg_Map_map", mapTransferTab.groupId, "id")
    if ConditionManager.Check4D(mapTab.enterCondition) then
      name1 = mapTransferTab.name
      return name1, name2
    end
    name1 = mapTransferTab.name .. "   "
    name2 = "   " .. mapTab.enterCondition[1][1][2] .. "Lv"
    name2 = string.GetColorText(name2, "#FF0000")
    return name1, name2
  end
  return name1, name2
end

function MapExpTeleportTemplate:MainBtnOnClick(control)
  local isActive = self.MainBtn:GetChild("img_clickeffect"):GetActive()
  self.MainBtn:GetChild("img_clickeffect"):SetActive(not isActive)
  self.Content:SetActive(not isActive)
end

function MapExpTeleportTemplate:mainBtnOnClick(control)
  local data = control.data
  if not data then
    return
  end
  self:SetBtnPitchOn(data)
end

function MapExpTeleportTemplate:SubBtnOnClick(control)
  if TranScriptData.InTranscript then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 d\225\187\139ch chuy\225\187\131n trong ph\195\179 b\225\186\163n")
    if UIManager.IsVisible(UIID.MapDetailUI) then
      UIManager.Hide(UIID.MapDetailUI)
    end
    return
  end
  local data = control.data
  if not data then
    return
  end
  if #self.mapTransferDataTab[data.groupId] > 1 then
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
    local mapTransferData = ClientTable.cfg_Map_transferManager:TryGetValue(10140099)
    if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
      UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
    end
    UIManager.Hide(UIID.MapDetailUI)
    local groupId = self.mapTransferDataTab[data.groupId][1].groupId
    PathFinderManager.FlyTransferScene(mapTransferData.id, nil, {npcId = 1001006, groupId = groupId}, Purpose.ClickNpc, function()
    end)
  end
end

function MapExpTeleportTemplate:SetMapsTipPos(btn)
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
  self.MapsTip:SetAnchoredPosition(mapsTipPosX, mapsTipPosY)
end

function MapExpTeleportTemplate:SetBtnPitchOn(data)
  for i, v in ipairs(self.ShowTogInfo) do
    local btnGroup = self.BtnGroupContainer:GetOrCreateItem(i)
    if v.txtTitle == data.txtTitle then
      btnGroup.btn_main:GetChild("img_clickeffect"):SetActive(true)
      btnGroup.subBtnGroup:SetActive(true)
    else
      btnGroup.btn_main:GetChild("img_clickeffect"):SetActive(false)
      btnGroup.subBtnGroup:SetActive(false)
    end
  end
end

function MapExpTeleportTemplate:IsCanChangeMap(condition)
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

function MapExpTeleportTemplate.OnMapsTipBtnCreat(ctr)
  ctr.lab_mapname = UIControl(ctr.transform, "lab_mapname")
end

function MapExpTeleportTemplate.OnMapsTipBtnRefresh(ctr, _, data, ui)
  local name1, name2
  name1, name2 = ui:GetMapNameAndConditionByID(false, data, data.name)
  ctr.lab_mapname:SetText(name1 .. " " .. name2)
  ctr.data = data
  ctr:SetOnClick(ui, ui.MapsTipBtnOnClick)
end

function MapExpTeleportTemplate:MapsTipBtnOnClick(control)
  local mapTransferData = control.data
  if not mapTransferData then
    return
  end
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
  self.MapsTip:SetActive(false)
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

return MapExpTeleportTemplate

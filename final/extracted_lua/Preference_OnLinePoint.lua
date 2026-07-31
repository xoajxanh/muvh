Preference_OnLinePoint = class(BaseUI)
Preference_OnLinePoint.layer = UILayer.Panel
Preference_OnLinePoint.orderInLayer = 0
Preference_OnLinePoint.hideType = UIHideType.WaitDestroy
Preference_OnLinePoint.hideFunc = UIHideFunc.MoveOutOfScreen
Preference_OnLinePoint.escClose = UIEscClose.DontClose

function Preference_OnLinePoint:InitControls()
  self.bg_autoPoint = self:GetControl("bg_autoPoint")
  self.btn_mapChange = self:GetControl("bg_autoPoint/btn_mapChange")
  self.ls_mapList = self:GetControl("bg_autoPoint/ls_mapList")
  self.btn_mapList = self:GetControl("bg_autoPoint/btn_mapList")
  self.mapLabel = self:GetControl("bg_autoPoint/btn_mapList/mapLabel")
  self.sv_onLinePointGroup = self:GetControl("bg_autoPoint/sv_onLinePointGroup")
  self.Content = self:GetControl("bg_autoPoint/sv_onLinePointGroup/Viewport/Content")
  self.go_onLinePoint = self:GetControl("bg_autoPoint/sv_onLinePointGroup/Viewport/Content/go_onLinePoint")
  self.sv_mapList = self:GetControl("bg_autoPoint/sv_mapList")
  self.mapItem = self:GetControl("bg_autoPoint/sv_mapList/Viewport/Content/mapItem")
  self.go_linePointInfo = self:GetControl("bg_autoPoint/go_linePointInfo")
  self.txt_monsterIofo = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/txt_monsterIofo")
  self.txt_defense = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/txt_defense")
  self.txt_selfDefense = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/txt_selfDefense")
  self.txt_warn = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/txt_warn")
  self.btn_golinePoint = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/btn_golinePoint")
  self.goLineName = self:GetControl("bg_autoPoint/go_linePointInfo/img_bg/btn_golinePoint/goLineName")
  self.txt_tips = self:GetControl("bg_autoPoint/txt_tips")
  self.btn_close = self:GetControl("btn_close")
  self.txt_title = self:GetControl("txt_title")
end

function Preference_OnLinePoint:OnPreLoad()
end

local monObjTab = {}

function Preference_OnLinePoint:Init()
  self.groupIdTab = {}
  self.groupName = {}
  self.lineData = {}
  self.cfgLinePoint = {}
  self:MapGroupIdInit()
end

function Preference_OnLinePoint:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Preference_OnLinePoint:InitUI()
end

function Preference_OnLinePoint:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Preference_OnLinePoint:OnHide()
  self.position = nil
end

function Preference_OnLinePoint:OnDestroy()
end

function Preference_OnLinePoint:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_golinePoint:SetOnClick(self, self.GoLineOnClick)
  self.btn_mapList:SetOnClick(self, self.ShowMapListOnClick)
  self.btn_mapChange:SetOnClick(self, self.ShowMapListOnClick)
end

function Preference_OnLinePoint:btn_closeOnClick(control)
  UIManager.Hide(UIID.Preference_OnLinePoint)
end

function Preference_OnLinePoint:ShowMapListOnClick(control)
  local state = not self.sv_mapList:GetActive()
  self.sv_mapList:SetActive(state)
  local angle = state and 0 or 180
  self.btn_mapChange.transform:SetLocalEulerAngles(0, 0, angle)
  if state then
    if not self.mapListTableView then
      self:MapCreateTableView()
      self.mapListTableView:ReloadData(self.mapIndex)
    else
      self.mapListTableView:ReloadData(self.mapIndex)
    end
  end
end

function Preference_OnLinePoint:dp_mapOnClick(control)
  local mapTab = self:GetMapTableData(self.groupIdTab[control.index])
  local isEnough = self:IsEnoughLevel(mapTab.enterCondition)
  self.btn_mapChange.transform:SetLocalEulerAngles(0, 0, 180)
  if not isEnough then
    FloatingWordUtility.QuickMsg("C\225\186\165p kh\195\180ng \196\145\225\187\167")
    self.sv_mapList:SetActive(false)
    return
  end
  if control.index ~= self.mapIndex then
    if self.lastControl then
      self.lastControl.select:SetActive(false)
    end
    control.select:SetActive(true)
    self.lastControl = control
    self.btnIndex = nil
    self.mapIndex = control.index
    self.groupId = self.groupIdTab[self.mapIndex]
    self.mapLabel:SetText(self.groupName[self.mapIndex])
    self.sv_mapList:SetActive(false)
    self:NewRefreshPos()
  else
    self.sv_mapList:SetActive(false)
  end
end

function Preference_OnLinePoint:RegistEvents()
end

function Preference_OnLinePoint:Refresh()
  local temp
  self.sceneGroupId, temp = self:GetRecommendIndexInAllData()
  self.mapIndex = nil
  self.paramGroupIdIndex = nil
  self.paramMonIndex = nil
  if self.args and self.args.openFirstTab and self.args.openFirstTab ~= 0 then
    self.paramGroupIdIndex = self.args.openFirstTab
    if self.args.openFirstTab == 1 then
      self.paramMonIndex = Mathf.Random(12, 17)
    end
  end
  if not self.paramGroupIdIndex then
    self:GuideChooseSnowKing()
  end
  self:NewSvMapRefresh()
end

function Preference_OnLinePoint:MonPointOnClick(control)
  if control.index == self.btnIndex then
    return
  end
  if self.btnControl then
    self.btnControl.select:SetActive(false)
    self.btnControl.btn_golinePoint:SetActive(false)
  end
  self.btnIndex = control.index
  self.btnControl = control
  self.lineData.groupId = control.groupId
  self.lineData.position = control.position
  self.lineData.mapTransId = control.mapTransId
  self.lineData.posTransId = control.posTransId
  control.select:SetActive(true)
  control.btn_golinePoint:SetActive(true)
end

function Preference_OnLinePoint:GoLineOnClick(control)
  local posArray = string.split(self.lineData.position, "#")
  local pos = Vector2(tonumber(posArray[1]), tonumber(posArray[2]))
  local transId
  if self:IsCanUseFlyShoe(self.lineData.posTransId) then
    transId = self.lineData.posTransId
  end
  PathFinderManager.JumpMapToMoveToPos(self.lineData.groupId, pos, transId, nil, nil, Purpose.None, function()
    RoleManager.me:SetAutoHookFight(true)
  end, nil, true)
  UIManager.Hide(UIID.Preference_OnLinePoint)
end

function Preference_OnLinePoint:GetPosData(groupId)
  local tempTab = {}
  local dataTable = self.cfgLinePoint
  for i, v in pairs(dataTable) do
    if v.mapId == groupId then
      table.insert(tempTab, v)
    end
  end
  return tempTab
end

function Preference_OnLinePoint:GetMapTableData(groupId)
  local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(groupId, "id")
  if mapTab then
    return mapTab
  end
  return {}
end

function Preference_OnLinePoint:MapGroupIdInit()
  local data = ClientTable.cfg_OnHook_OnLinePointManager:GetDic()
  for i, v in pairs(data) do
    if v.show == 1 then
      table.insert(self.cfgLinePoint, v)
      if not table.contains(self.groupIdTab, v.mapId) then
        table.insert(self.groupIdTab, v.mapId)
        local tab = self:GetMapTableData(v.mapId)
        table.insert(self.groupName, tab.name)
      end
    end
  end
end

function Preference_OnLinePoint:GetUIWord(num)
  local temp = num - ViewData.meData:GetAttribute(EAttributeType.defenseBase)
  local tab = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2370004), "#")
  local color
  local name = ""
  local dangerLevel = 0
  if temp > tonumber(tab[1]) then
    name = LocalizationUtility.GetContentByKey("OnLinePoint_1")
    color = "#FF0000"
    dangerLevel = 5
  elseif temp > tonumber(tab[2]) and temp <= tonumber(tab[1]) then
    name = LocalizationUtility.GetContentByKey("OnLinePoint_2")
    color = "#FFC600"
    dangerLevel = 4
  elseif temp > tonumber(tab[3]) and temp <= tonumber(tab[2]) then
    name = LocalizationUtility.GetContentByKey("OnLinePoint_3")
    color = "59FF00"
    dangerLevel = 3
  elseif temp > tonumber(tab[4]) and temp <= tonumber(tab[3]) then
    name = LocalizationUtility.GetContentByKey("OnLinePoint_4")
    color = "#FFFFFF"
    dangerLevel = 2
  elseif temp <= tonumber(tab[4]) then
    name = LocalizationUtility.GetContentByKey("OnLinePoint_5")
    color = "#918888"
    dangerLevel = 1
  end
  return name, color, dangerLevel
end

function Preference_OnLinePoint:IsHaveLineInGroupId(groupId)
  local data = self:GetPosData(groupId)
  for i = 1, table.count(data) do
    local tipName, color, dangerLevel = self:GetUIWord(data[i].recommendDef)
    if dangerLevel == 3 then
      return true
    end
  end
  return false
end

function Preference_OnLinePoint:IsEnoughLevel(condition)
  local strTab = condition[1]
  if ConditionManager.GenerateSingleCondition(strTab[1]):Check() then
    return true
  else
    return false
  end
end

function Preference_OnLinePoint:GuideChooseSnowKing()
  local strTab = string.split(GlobalConfig.GetGlobalConfig(2460104), "#")
  local task = TaskData.GetTaskById(tonumber(strTab[1]))
  if task then
    self.paramGroupIdIndex = 1
    self.paramMonIndex = Mathf.Random(12, 17)
  end
end

function Preference_OnLinePoint:GetRecommendIndex(data)
  local temp = {}
  local index = 1
  for i = 1, table.count(data) do
    if i == table.count(data) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef then
        index = i
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < data[i + 1].recommendDef then
      index = i
    end
  end
  return index
end

function Preference_OnLinePoint:GetAllRecommendValue()
  local data = self.cfgLinePoint
  local value = data[1].recommendDef
  for i = 1, table.count(data) do
    if i == table.count(data) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef then
        value = data[i].recommendDef
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < data[i + 1].recommendDef then
      value = data[i].recommendDef
    end
  end
  return value
end

function Preference_OnLinePoint:GetRecommendIndexInAllData()
  local lineTab = self.cfgLinePoint
  local dataTable = {}
  for i = 1, table.count(lineTab) do
    if lineTab[i].mapLevle <= RoleManager.me.level then
      table.insert(dataTable, lineTab[i])
    end
  end
  table.sort(dataTable, function(a, b)
    return a.recommendDef < b.recommendDef
  end)
  local groupId = 1003
  local value = table.count(dataTable) > 0 and dataTable[1].recommendDef or 0
  for i = 1, table.count(dataTable) do
    if i == table.count(dataTable) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= dataTable[i].recommendDef then
        groupId = dataTable[i].mapId
        value = dataTable[i].recommendDef
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= dataTable[i].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < dataTable[i + 1].recommendDef then
      groupId = dataTable[i].mapId
      value = dataTable[i].recommendDef
    end
  end
  return groupId, value
end

function Preference_OnLinePoint:IsCanUseFlyShoe(transId)
  local transConfig = ConfigManager.FindConfigs("cfg_Map_transfer", "id", transId)
  if transConfig[1].condition ~= nil then
    local strTab = transConfig[1].condition
    for i = 1, table.count(strTab) do
      if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
        return true
      end
    end
  end
  return false
end

function Preference_OnLinePoint:NewSvMapRefresh()
  if self.paramGroupIdIndex then
    self.mapIndex = self.paramGroupIdIndex
  else
    for i = 1, table.count(self.groupIdTab) do
      if self.groupIdTab[i] == self.sceneGroupId then
        self.mapIndex = i
      end
    end
  end
  self.btnIndex = 1
  self.sv_mapList:SetActive(false)
  self.mapLabel:SetText(self.groupName[self.mapIndex])
  self.groupId = self.paramGroupIdIndex and self.groupIdTab[self.paramGroupIdIndex] or self.sceneGroupId
  self.recommendGroupId = self.paramGroupIdIndex and self.groupIdTab[self.paramGroupIdIndex] or self.sceneGroupId
  self:NewRefreshPos()
end

function Preference_OnLinePoint:MapCreateTableView()
  self.mapListTableView = UITableView()
  self.mapListTableView:SetLowerMargin(0)
  self.mapListTableView:SetScrollView(self.sv_mapList)
  self.mapListTableView:SetScalarForCellInTableView(self, self.MapScalarForCellInTableView)
  self.mapListTableView:SetUpperMargin(0)
  self.mapListTableView:SetResetCellCallback(self, self.MapResetBgList)
  self.mapListTableView:SetTotalCellCount(self, self.MapNumberOfCellsInTableView)
  self.mapListTableView:SetCellAtIndexInTableView(self, self.MapCellAtIndexInTableView)
  self.mapListTableView:SetCellAtIndexInTableViewWillAppear(self, self.MapCellAtIndexInTableViewWillAppear)
  self.mapListTableView:ScrollToCell(1, true)
end

function Preference_OnLinePoint:MapScalarForCellInTableView()
  local _, sizeY = self.mapItem:GetSizeDelta()
  return sizeY
end

function Preference_OnLinePoint:MapResetBgList(cell)
end

function Preference_OnLinePoint:MapNumberOfCellsInTableView()
  local count = self.groupIdTab and table.count(self.groupIdTab) or 0
  return count
end

function Preference_OnLinePoint:MapCellAtIndexInTableView(index)
  return self.mapListTableView:ReuseOrCreateCell(self.mapItem)
end

function Preference_OnLinePoint:MapCellAtIndexInTableViewWillAppear(i)
  local data = self.groupIdTab[i]
  local ctr = self.mapListTableView:GetLoadedCell(i)
  local mapTab = self:GetMapTableData(data)
  local str = mapTab.name
  local level = mapTab.enterCondition[1][1][2] .. "Lv"
  local isEnough = self:IsEnoughLevel(mapTab.enterCondition)
  if data == self.recommendGroupId then
    str = str .. "(Ti\225\186\191n c\225\187\173)"
  end
  if isEnough then
    str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.white])
    level = string.GetColorText(level, ItemQuality2ColorDic[EItemColorEnum.white])
  else
    str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gray])
    level = string.GetColorText(level, ItemQuality2ColorDic[EItemColorEnum.bRed])
  end
  ctr.select = ctr:GetChild("select")
  ctr.mapLabel = ctr:GetChild("mapLabel")
  ctr.mapLevel = ctr:GetChild("mapLevel")
  ctr.index = i
  ctr.mapLabel:SetText(str)
  ctr.mapLevel:SetText(level)
  ctr.select:SetActive(false)
  ctr:SetOnClick(self, self.dp_mapOnClick)
  if i == self.mapIndex then
    self.lastControl = ctr
    ctr.select:SetActive(true)
  else
    ctr.select:SetActive(false)
  end
end

function Preference_OnLinePoint:NewRefreshPos()
  self.go_linePointInfo:SetActive(false)
  self.currentMonData = self:GetPosData(self.groupId)
  self.recommendIndex = self:GetRecommendIndex(self.currentMonData)
  local temp
  temp, self.recommendValue = self:GetRecommendIndexInAllData()
  if self.paramGroupIdIndex and self.paramGroupIdIndex == 1 then
    self.btnIndex = self.paramMonIndex
  else
    self.btnIndex = self.recommendIndex
  end
  local startIndex = 1
  if self.btnIndex > 6 then
    startIndex = self.btnIndex - 5
  end
  if not self.lineListTableView then
    self:CreateTableView()
    self.lineListTableView:ReloadData(startIndex)
  else
    self.lineListTableView:ReloadData(startIndex)
  end
end

function Preference_OnLinePoint:CreateTableView()
  self.lineListTableView = UITableView()
  self.lineListTableView:SetLowerMargin(0)
  self.lineListTableView:SetScrollView(self.sv_onLinePointGroup)
  self.lineListTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.lineListTableView:SetUpperMargin(0)
  self.lineListTableView:SetResetCellCallback(self, self.ResetBgList)
  self.lineListTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.lineListTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.lineListTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.lineListTableView:ScrollToCell(1, true)
end

function Preference_OnLinePoint:ScalarForCellInTableView()
  local _, sizeY = self.go_onLinePoint:GetSizeDelta()
  return sizeY
end

function Preference_OnLinePoint:ResetBgList(cell)
end

function Preference_OnLinePoint:NumberOfCellsInTableView()
  local count = self.currentMonData and table.count(self.currentMonData) or 0
  return count
end

function Preference_OnLinePoint:CellAtIndexInTableView(index)
  return self.lineListTableView:ReuseOrCreateCell(self.go_onLinePoint)
end

function Preference_OnLinePoint:CellAtIndexInTableViewWillAppear(i)
  local data = self.currentMonData
  local obj = self.lineListTableView:GetLoadedCell(i)
  local tipName, color, dangerLevel = self:GetUIWord(data[i].recommendDef)
  local str = string.GetColorText("lv." .. data[i].mLevel, color)
  obj:GetChild("txt_level"):SetText(str)
  str = data[i].pointName
  obj:GetChild("txt_name"):SetText(str)
  str = data[i].mExp .. "EXP/con"
  obj:GetChild("txt_exp"):SetText(str)
  local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(data[i].monsterId, "id")
  if monster then
    local head = obj:GetChild("img_headFrame/img_head")
    self:SetSprite("Atlas_headPortrait", monster.head, head)
  end
  str = data[i].recommendDef
  local txt_green = obj:GetChild("txt_green")
  local txt_red = obj:GetChild("txt_red")
  txt_green:SetText(str)
  txt_red:SetText(str)
  txt_green:SetActive(ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef)
  txt_red:SetActive(ViewData.meData:GetAttribute(EAttributeType.defenseBase) < data[i].recommendDef)
  obj.index = i
  obj.position = data[i].position
  obj.groupId = data[i].mapId
  obj.select = obj:GetChild("img_select")
  obj.mapTransId = data[i].mapTransId
  obj.posTransId = data[i].posTransId
  obj.effectGuide = obj:GetChild("effectGuide")
  obj.btn_golinePoint = obj:GetChild("btn_golinePoint")
  obj.btn_golinePoint:SetOnClick(self, self.GoLineOnClick)
  obj:GetChild("img_recommend"):SetActive(self.recommendValue == data[i].recommendDef)
  obj:SetOnClick(self, self.MonPointOnClick)
  if self.btnIndex == i then
    self.lineData.groupId = obj.groupId
    self.lineData.position = obj.position
    self.lineData.mapTransId = obj.mapTransId
    self.lineData.posTransId = obj.posTransId
    self.btnControl = obj
    obj.select:SetActive(true)
    if self.paramGroupIdIndex then
      obj.effectGuide:SetActive(true)
    end
    obj.btn_golinePoint:SetActive(true)
  else
    obj.select:SetActive(false)
    obj.btn_golinePoint:SetActive(false)
    obj.effectGuide:SetActive(false)
  end
end

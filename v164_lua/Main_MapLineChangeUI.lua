Main_MapLineChangeUI = class(BaseUI)
Main_MapLineChangeUI.layer = UILayer.Panel
Main_MapLineChangeUI.orderInLayer = 0
Main_MapLineChangeUI.hideType = UIHideType.WaitDestroy
Main_MapLineChangeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_MapLineChangeUI.escClose = UIEscClose.DontClose

function Main_MapLineChangeUI:InitControls()
  self.btn_bg = self:GetControl("btn_bg")
  self.bg_ornamentsBreach = self:GetControl("bg_ornamentsBreach")
  self.btn_close = self:GetControl("bg_ornamentsBreach/btn_close")
  self.btn_use = self:GetControl("bg_ornamentsBreach/line/btn_use")
  self.btn_line = self:GetControl("bg_ornamentsBreach/line/Viewport/Content/btn_line")
end

function Main_MapLineChangeUI:OnPreLoad()
end

function Main_MapLineChangeUI:Init()
end

function Main_MapLineChangeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_MapLineChangeUI:InitUI()
  self.itemLineContainer = UIContainer(self.btn_line, self)
end

function Main_MapLineChangeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  NetManager.Send(MapMessage.ReqShowMapLinePlayer)
end

function Main_MapLineChangeUI:OnHide()
end

function Main_MapLineChangeUI:OnDestroy()
end

function Main_MapLineChangeUI:RegistUIEvents()
  self.btn_bg:SetOnClick(self, self.btn_bgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_use:SetOnClick(self, self.btn_useOnClick)
  self.btn_line:SetOnClick(self, self.btn_lineOnClick)
end

function Main_MapLineChangeUI:btn_bgOnClick(control)
  UIManager.Hide(UIID.MapLineChangeUI)
end

function Main_MapLineChangeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.MapLineChangeUI)
end

function Main_MapLineChangeUI:btn_useOnClick(control)
  local tansId = self:GetTransIdByMapId()
  local mapData = {
    mapId = tansId,
    line = self.index,
    changeLine = true
  }
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
  UIManager.Hide(UIID.MapLineChangeUI)
end

function Main_MapLineChangeUI:btn_lineOnClick(control)
  if control.index == self.index then
    return
  end
  self.index = control.index
  for i = 1, table.count(self.lineObjTab) do
    if control.index == i then
      self.lineObjTab[i].line_bg:SetActive(true)
    else
      self.lineObjTab[i].line_bg:SetActive(false)
    end
  end
end

function Main_MapLineChangeUI:RegistEvents()
  self:RegistEvent(Event.Map_LinePlayerCount, self.OnRefresh, self)
end

function Main_MapLineChangeUI:OnRefresh(_, msg)
  self.linePlayerCount = {}
  for i = 1, table.count(msg.numsList) do
    self.linePlayerCount[msg.numsList[i].line] = msg.numsList[i].nums
  end
  if table.count(self.linePlayerCount) == 0 then
    log("D\225\187\175 li\225\187\135u s\225\187\145 ng\198\176\225\187\157i online ph\195\162n tuy\225\186\191n tr\225\187\145ng")
    return
  end
  for i = 1, self.mapLineData.line do
    local obj = self.itemLineContainer:GetOrCreateItem(i)
    local realCount = self.linePlayerCount[i]
    if realCount and self.mapLineData.data.showPeopleNum ~= 0 then
      obj:GetChild("bg_line/lab_line_count"):SetFillAmount(realCount / self.mapLineData.data.showPeopleNum)
    end
  end
end

function Main_MapLineChangeUI:Refresh()
  self.lineObjTab = {}
  self.mapLineData = self:GetMapLineData()
  self.itemLineContainer:SetMaxCount(self.mapLineData.line)
  for i = 1, self.mapLineData.line do
    local obj = self.itemLineContainer:GetOrCreateItem(i)
    obj.index = i
    obj.line_bg = obj:GetChild("line_bg")
    obj.text_line = obj:GetChild("text_line")
    local name = string.format("%s-Tuy\225\186\191n %d", self.mapLineData.data.name, i)
    obj.text_line:SetText(name)
    obj:SetOnClick(self, self.btn_lineOnClick)
    local line = SceneData.cline
    if i == line then
      self.index = i
      obj.line_bg:SetActive(true)
    else
      obj.line_bg:SetActive(false)
    end
    table.insert(self.lineObjTab, obj)
  end
  self.itemLineContainer:Refresh()
end

function Main_MapLineChangeUI:GetMapLineData()
  local totalMapTab = ClientTable.cfg_Map_mapManager:GetDic()
  local dataTab = {}
  for k, v in pairs(totalMapTab) do
    if v and v.groupId == SceneData.groupId and v.line > 0 then
      dataTab.data = v
      dataTab.line = v.line
      break
    end
  end
  return dataTab
end

function Main_MapLineChangeUI:GetTransIdByMapId()
  local mapTab = ClientTable.cfg_Map_transferManager:GetDic()
  for k, v in pairs(mapTab) do
    if v.groupId == SceneData.groupId and v.born == 1 then
      return v.id
    end
  end
end

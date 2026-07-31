Instance_BossHouseUI = class(BaseUI)
Instance_BossHouseUI.layer = UILayer.Panel
Instance_BossHouseUI.orderInLayer = 0
Instance_BossHouseUI.hideType = UIHideType.WaitDestroy
Instance_BossHouseUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_BossHouseUI.escClose = UIEscClose.DontClose

function Instance_BossHouseUI:InitControls()
  self.bg_btnClose = self:GetControl("bg_btnClose")
  self.tog_instance = self:GetControl("Scroll View/Viewport/Content/tog_instance")
  self.btn_enter = self:GetControl("btn_enter")
  self.img_name = self:GetControl("img_name")
  self.img_name1 = self:GetControl("img_name1")
  self.btn_close = self:GetControl("btn_close")
  self.scrollView = self:GetControl("Scroll View")
  self.Viewport = self:GetControl("Scroll View/Viewport")
  self.Content = self:GetControl("Scroll View/Viewport/Content")
end

Instance_BossHouseUI.MapTransferDataList = nil
Instance_BossHouseUI.ToggleTemplates = nil
Instance_BossHouseUI.chooseMapData = nil

function Instance_BossHouseUI:OnPreLoad()
end

function Instance_BossHouseUI:Init()
  self.mapIndex = 1
  self.data = {
    mapId = {},
    name = {},
    condition = {},
    transferId = {}
  }
end

function Instance_BossHouseUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_BossHouseUI:InitUI()
  self.itemMapContainer = UIContainer(self.tog_instance, self)
end

function Instance_BossHouseUI:OnShow()
  self.chooseIndex = self.args.param and self.args.param.index or 1
  self:RegistEvents()
  self:Refresh()
end

function Instance_BossHouseUI:OnHide()
  EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
end

function Instance_BossHouseUI:OnDestroy()
end

function Instance_BossHouseUI:RegistUIEvents()
  self.btn_enter:SetOnClick(self, self.Btn_EnterOnClick)
  self.bg_btnClose:SetOnClick(self, self.Btn_CloseOnClick)
  self.btn_close:SetOnClick(self, self.Btn_CloseOnClick)
end

function Instance_BossHouseUI:RegistEvents()
  self:RegistEvent(Event.BossHouseRefresh, self.BossHouseRefresh, self)
end

function Instance_BossHouseUI:BossHouseRefresh(_, msg)
  self.args.npcConfigID = msg.npcConfigID
  self.chooseIndex = msg.param.index
  self:Refresh()
end

function Instance_BossHouseUI:Refresh()
  self:RefreshData()
  local firstMapTransferData = self.MapTransferDataList[next(self.MapTransferDataList)]
  if firstMapTransferData ~= nil then
    self:SetSprite("Atlas_Language", firstMapTransferData.titleName, self.img_name)
  end
  self.itemMapContainer:SetMaxCount(table.count(self.MapTransferDataList))
  table.sort(self.MapTransferDataList, function(a, b)
    if a == nil or a.npcInstanceTransferTable == nil or a.npcInstanceTransferTable.index == nil then
      return true
    end
    if b == nil or b.npcInstanceTransferTable == nil or b.npcInstanceTransferTable.index == nil then
      return false
    end
    return tonumber(a.npcInstanceTransferTable.id) < tonumber(b.npcInstanceTransferTable.id)
  end)
  local index = 0
  for k, v in pairs(self.MapTransferDataList) do
    index = index + 1
    local mapTransferData = v
    local obj = self.itemMapContainer:GetOrCreateItem(index)
    if self.ToggleTemplates == nil then
      self.ToggleTemplates = {}
    end
    local template = self.ToggleTemplates[obj]
    if template == nil then
      template = luaTemplateManager.GetNewTemplate(obj, LuaComponentTemplates.Toggle_SingleToggleTemplate)
      self.ToggleTemplates[obj] = template
    end
    local inputData = {}
    inputData.name = mapTransferData.MapData.mapName
    inputData.conditionDes = mapTransferData:GetConditionDes()
    inputData.index = index
    inputData.isOn = mapTransferData.MapData.mapTable.index == self.chooseIndex
    inputData.callBackData = mapTransferData.MapData
    
    function inputData.toggleCallback(inputdata)
      self.chooseMapData = inputdata.callBackData
    end
    
    template:RefreshData(inputData)
  end
  local index = 0
  for i, v in pairs(self.ToggleTemplates) do
    if v.InputData.isOn == true then
      index = v.InputData.index
      break
    end
  end
  local indexPos = self:GetScrollViewNormalizedPosition(index)
  self.scrollView.scrollRect.verticalNormalizedPosition = indexPos or 1
end

function Instance_BossHouseUI:RefreshData()
  self.MapTransferDataList = gameMgr:GetMapManager():GetMapTransferListData():GetMapTransferData({
    sourceType = MapTransferSourceType.Npc,
    id = self.args.npcConfigID
  })
end

function Instance_BossHouseUI:Btn_EnterOnClick()
  if self.chooseMapData ~= nil then
    local transferResult = self.chooseMapData:TransferMap()
    if transferResult then
      self:Btn_CloseOnClick()
    end
  end
end

function Instance_BossHouseUI:Btn_CloseOnClick()
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Instance_BossHouseUI)
  if self.args and self.args.vipUI then
    UIManager.Show(UIID.Vip_VipUI, {
      red = CommercializeData.Vip_VipRedRoint
    })
  end
end

function Instance_BossHouseUI:GetScrollViewNormalizedPosition(currentChildIndex)
  local count = table.count(self.MapTransferDataList)
  if count ~= 0 then
    local childrenRect = self.tog_instance.transform.rect
    local diff = count * childrenRect.height - self.Viewport.transform.rect.height
    local elementLength = childrenRect.height
    return Mathf.Clamp01(1 - (currentChildIndex - 1) * elementLength / diff)
  end
end

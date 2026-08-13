Bag_PandoraInfoUI = class(BaseUI)
Bag_PandoraInfoUI.layer = UILayer.Panel
Bag_PandoraInfoUI.orderInLayer = 0
Bag_PandoraInfoUI.hideType = UIHideType.WaitDestroy
Bag_PandoraInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_PandoraInfoUI.escClose = UIEscClose.DontClose

function Bag_PandoraInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.img_Bg = self:GetControl("img_Bg")
  self.Scroll_BagInfos = self:GetControl("img_Bg/Scroll_BagInfos")
  self.Scroll_bg = self:GetControl("img_Bg/Scroll_BagInfos/Scroll_bg")
  self.go_BagContent = self:GetControl("img_Bg/Scroll_BagInfos/Viewport/go_BagContent")
  self.tile_bg = self:GetControl("img_Bg/Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.img_lock = self:GetControl("img_Bg/Scroll_BagInfos/Viewport/go_BagContent/img_lock")
  self.go_DragCheck = self:GetControl("img_Bg/Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("img_Bg/Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("img_Bg/Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("img_Bg/Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("img_Bg/Scroll_BagInfos/btn_3DItem")
  self.btn_CloseBag = self:GetControl("btn_CloseBag")
  self.btn_SortOut = self:GetControl("btn_SortOut")
  self.btn_Delete = self:GetControl("btn_Delete")
  self.btn_Choose = self:GetControl("btn_Choose")
  self.btn_Trans = self:GetControl("btn_Trans")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Bag_PandoraInfoUI:Init()
end

function Bag_PandoraInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_PandoraInfoUI:InitUI()
  self.dragTbl = UIDragCellContainer(self, self.PutIn, self.ItemOnClick, {
    curCellCount = BagInfoData.pandoraInitCount,
    totalCellCount = BagInfoData.pandoraInitCount,
    colCount = 8
  })
  self.dragTbl:SetParam(self.PutIn, self.ItemOnClick, true, true)
end

function Bag_PandoraInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.img_lock:SetOnClick(self, self.img_lockOnClick)
  self.btn_CloseBag:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_SortOut:SetOnClick(self, self.btn_SortOutOnClick)
  self.btn_Delete:SetOnClick(self, self.btn_DeleteOnClick)
  self.btn_Choose:SetOnClick(self, self.btn_ChooseOnClick)
  self.btn_Trans:SetOnClick(self, self.btn_TransOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Bag_PandoraInfoUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Bag_PandoraInfoUI)
end

function Bag_PandoraInfoUI:img_lockOnClick(control)
end

function Bag_PandoraInfoUI:btn_SortOutOnClick(control)
  NetManager.Send(BagMessage.ReqBagSortByType, {
    type = StorageTypeEnum.PandoraBag
  })
end

function Bag_PandoraInfoUI:btn_DeleteOnClick(control)
  local selectInfo = {}
  for i, v in pairs(BagInfoData.pandoraBagInfos) do
    if v.selected then
      table.insert(selectInfo, v.id)
    end
  end
  if table.count(selectInfo) > 0 then
    local playerPrefs = string.format("%s_btn_DeleteOnClickBag_PandoraInfoUI", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
    local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
    if lastRecordTime == 0 or isServerSameDay == false then
      TipUtility.QuickShowPrompt({
        id = 92,
        onlyOnce = true,
        onlyOnceArgs = nil,
        onlyOnceAction = function(args, isOn)
          PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
        end,
        cancelAction = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        okAction = function()
          UIManager.Hide(UIID.PromptTipUI)
          networkRequest.ReqDestroyFromPandoraBag(selectInfo)
        end
      })
    else
      networkRequest.ReqDestroyFromPandoraBag(selectInfo)
    end
  end
end

function Bag_PandoraInfoUI:btn_ChooseOnClick(control)
  if table.count(self.dragTbl.items) > 0 then
    for i, v in pairs(self.dragTbl.items) do
      local itemCellData = v.data:GetData()
      itemCellData.selected = not self.ChooseAll
      ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    end
    for i, v in pairs(BagInfoData.pandoraBagInfos) do
      v.selected = not self.ChooseAll
    end
    self.ChooseAll = not self.ChooseAll
  end
end

function Bag_PandoraInfoUI:btn_TransOnClick(control)
  local selectInfo = {}
  for i, v in pairs(BagInfoData.pandoraBagInfos) do
    if v.selected then
      table.insert(selectInfo, v.id)
    end
  end
  if table.count(selectInfo) > 0 then
    local playerPrefs = string.format("%s_btn_TransOnClickBag_PandoraInfoUI", ViewData.meData.id)
    local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
    local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
    if lastRecordTime == 0 or isServerSameDay == false then
      TipUtility.QuickShowPrompt({
        id = 91,
        onlyOnce = true,
        onlyOnceArgs = nil,
        onlyOnceAction = function(args, isOn)
          PlayerPrefs.SetInt(playerPrefs, isOn and Time.GetServerSecondTime() or 0)
        end,
        cancelAction = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        okAction = function()
          UIManager.Hide(UIID.PromptTipUI)
          NetManager.Send(BagMessage.ReqTakeOutFromPandoraBag, {ids = selectInfo})
        end
      })
    else
      NetManager.Send(BagMessage.ReqTakeOutFromPandoraBag, {ids = selectInfo})
    end
  end
end

function Bag_PandoraInfoUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1128})
end

function Bag_PandoraInfoUI:OnShow()
  self.ChooseAll = false
  self:RegistEvents()
  self:Refresh()
end

function Bag_PandoraInfoUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResPandoraInfo, self.OnResPandoraInfo, self)
  self:RegistEvent(Event.Bag_ResPandoraUpdate, self.OnResPandoraUpdate, self)
end

function Bag_PandoraInfoUI:Refresh()
  self.dragTbl:SetData(BagInfoData.pandoraBagInfos, "Bag_PandoraInfoUI:Refresh")
end

function Bag_PandoraInfoUI:OnResPandoraInfo(_, msg)
  self.dragTbl:SetData(BagInfoData.pandoraBagInfos, "OnResPandoraUpdate")
end

function Bag_PandoraInfoUI:OnResPandoraUpdate(_, msg)
  if msg.removeItems then
    for _, itemData in ipairs(msg.removeItems) do
      self.dragTbl:RemoveData(itemData)
    end
  end
  if msg.showItems then
    for _, itemInfo in pairs(msg.showItems) do
      self.dragTbl:AddItemInfo(itemInfo)
    end
  end
end

function Bag_PandoraInfoUI:PutIn(itemData, fromUiName, index)
end

function Bag_PandoraInfoUI:ItemOnClick(control)
  if table.count(BagInfoData.pandoraBagInfos) <= 0 then
    return
  end
  local itemCellData = control.data:GetData()
  local info = itemCellData.itemData
  for i, v in pairs(BagInfoData.pandoraBagInfos) do
    if v.id == info.id then
      local value = v.selected
      v.selected = not value
      itemCellData.selected = v.selected
      break
    end
  end
  ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
end

function Bag_PandoraInfoUI:ResItemInfoUpdateMessage(id, msg)
  if msg and msg.type == StorageTypeEnum.PandoraBag then
    self.dragTbl:MoveItemInfo(msg.items)
  end
end

function Bag_PandoraInfoUI:OnHide()
  for i, v in pairs(BagInfoData.pandoraBagInfos) do
    v.selected = nil
  end
  self.ChooseAll = false
end

function Bag_PandoraInfoUI:OnDestroy()
end

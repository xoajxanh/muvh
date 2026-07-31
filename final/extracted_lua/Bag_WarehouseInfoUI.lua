Bag_WarehouseInfoUI = class(BaseUI)
Bag_WarehouseInfoUI.layer = UILayer.Panel
Bag_WarehouseInfoUI.orderInLayer = 5
Bag_WarehouseInfoUI.hideType = UIHideType.Hide
Bag_WarehouseInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Bag_WarehouseInfoUI.escClose = UIEscClose.DontClose

function Bag_WarehouseInfoUI:InitControls()
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
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Bag_WarehouseInfoUI:OnPreLoad()
  self:Init()
  self:OnCreate()
end

function Bag_WarehouseInfoUI:Init()
  if self.inited then
    return
  end
  self.inited = true
end

function Bag_WarehouseInfoUI:OnCreate()
  if self.created then
    return
  end
  self.created = true
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Bag_WarehouseInfoUI:InitUI()
end

function Bag_WarehouseInfoUI:OnShow()
  self:TryInitDragTbl()
  self:RegistEvents()
  self:Refresh()
end

function Bag_WarehouseInfoUI:OnHide()
end

function Bag_WarehouseInfoUI:OnDestroy()
  self.created = false
  self.inited = false
end

function Bag_WarehouseInfoUI:RegistUIEvents()
  self.btn_CloseBag:SetOnClick(self, self.Btn_CloseBagOnClick)
  self.btn_SortOut:SetOnClick(self, self.Btn_SortOutOnClick)
  self.btn_closeBg:SetOnClick(self, self.Btn_CloseBagOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.img_lock:SetOnClick(self, self.OnClickLock)
end

local function PromptOK(okArgs)
  if BagInfoData.GetItemTotalCountByItemId(okArgs.itemData.tblItem.id) > 0 then
    local itemDatas = BagInfoData.GetItemTblByConfigId(okArgs.itemData.tblItem.id)
    local itemData = itemDatas[1]
    if itemData then
      local useItemTbl = {
        useCount = 1,
        useItemId = itemData.id,
        configId = itemData.itemId,
        useParam = itemData.tblItem.useParam,
        useParamExtend = itemData.tblItem.useParamExtend,
        params = nil
      }
      ItemUtility.UseItem(useItemTbl)
    end
  else
    local tipUi = UIManager.GetUiByName(UIID.PromptTipUI)
    FloatingWordUtility.QuickBtnMsg({
      parent = tipUi.Button_OK,
      msgStr = LocalizationUtility.GetUIWord("WarehouseTips_2")
    })
  end
end

function Bag_WarehouseInfoUI:OnClickLock(control)
  local itemData = ItemUtility.GenerateItemData(6000730)
  itemData.count = BagInfoData.GetItemTotalCountByItemId(6000730)
  local str = string.format("Ti\195\170u hao %s m\225\187\159 r\225\187\153ng kho kh\195\180ng?", string.GetColorText(itemData.tblItem.name, ItemQuality2ColorDic[EItemColorEnum.green]))
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = str,
    Item = itemData,
    okText = "",
    ok = PromptOK,
    okArgs = {itemData = itemData}
  })
end

function Bag_WarehouseInfoUI:Btn_CloseBagOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.BagWarehouseUI)
end

function Bag_WarehouseInfoUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", self.name)
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Bag_WarehouseInfoUI:Btn_SortOutOnClick(control)
  NetManager.Send(BagMessage.ReqStorageSort)
end

function Bag_WarehouseInfoUI:Button_ShowUseOperation(control, _, isDouble)
  local itemCellData = control.data
  local itemData = itemCellData.itemData
  if itemCellData.lock then
    local tipStr = "Ch\198\176a m\225\187\159 kh\195\179a \195\180"
    FloatingWordUtility.QuickMsg(tipStr)
    return
  end
  if control.data.itemData then
    if isDouble then
      NetManager.Send(BagMessage.ReqTakeOutFromStorage, {
        id = itemData.id,
        bagGridIndex = -1
      })
    else
      UIManager.Show(UIID.ItemTipUI, {
        item = itemData,
        rightOperate = EItemOperateType.TakeOut,
        ctrl = control
      })
    end
  end
end

function Bag_WarehouseInfoUI:PutIn(itemData, fromUiName, index)
  if fromUiName == self.name then
    NetManager.Send(BagMessage.ReqMoveItem, {
      itemId = itemData.id,
      bagGridIndex = index,
      type = EDragUIType.WarehouseInfoUI
    })
  elseif fromUiName == UIID.NewBagInfoUI then
    NetManager.Send(BagMessage.ReqPutIntoStorage, {
      id = itemData.id,
      bagGridIndex = index
    })
  end
end

function Bag_WarehouseInfoUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResStorageUpdate, self.OnResStorageUpdate, self)
  self:RegistEvent(Event.Bag_ResStorageInfo, self.OnResStorageInfo, self)
  self:RegistEvent(Event.Bag_ResItemInfoUpdateMessage, self.ResItemInfoUpdateMessage, self)
  self:RegistEvent(Event.Bag_GridUpdate, self.OnGridUpdate, self)
end

function Bag_WarehouseInfoUI:OnResStorageUpdate(_, msg)
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

function Bag_WarehouseInfoUI:OnResStorageInfo(_, msg)
  self.dragTbl:SetLock(BagInfoData.curStorageCount)
  self.dragTbl:SetData(BagInfoData.storageInfos, "OnResStorageUpdate")
end

function Bag_WarehouseInfoUI:Refresh()
  self.dragTbl:SetLock(BagInfoData.curStorageCount)
  self.dragTbl:SetData(BagInfoData.storageInfos, "Bag_WarehouseInfoUI:Refresh")
end

function Bag_WarehouseInfoUI:TryInitDragTbl()
  if self.dragTbl == nil then
    self.dragTbl = UIDragCellContainer(self, self.PutIn, self.Button_ShowUseOperation, {
      curCellCount = BagInfoData.curStorageCount,
      totalCellCount = BagInfoData.storageCount,
      colCount = 8
    })
  end
end

function Bag_WarehouseInfoUI:ResItemInfoUpdateMessage(id, msg)
  if msg and msg.type == EDragUIType.WarehouseInfoUI then
    self.dragTbl:MoveItemInfo(msg.items)
  end
end

function Bag_WarehouseInfoUI:OnGridUpdate(_, msg)
  if msg.type ~= EDragUIType.Bag then
    self.dragTbl:SetLock(BagInfoData.curStorageCount)
  end
end

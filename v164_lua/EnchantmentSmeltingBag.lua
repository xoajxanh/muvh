EnchantmentSmeltingBag = class(BaseUI)
EnchantmentSmeltingBag.layer = UILayer.Panel
EnchantmentSmeltingBag.orderInLayer = 0
EnchantmentSmeltingBag.hideType = UIHideType.WaitDestroy
EnchantmentSmeltingBag.hideFunc = UIHideFunc.MoveOutOfScreen
EnchantmentSmeltingBag.escClose = UIEscClose.DontClose

function EnchantmentSmeltingBag:InitControls()
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

function EnchantmentSmeltingBag:Init()
end

function EnchantmentSmeltingBag:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:InitTipsParams()
end

function EnchantmentSmeltingBag:InitTipsParams()
  if self.img_Bg and not IsNil(self.img_Bg.gameObject) then
    self.bgWidth, self.bgHeight = self.img_Bg:GetSizeDelta()
  end
end

function EnchantmentSmeltingBag:InitUI()
  local CellDataTbl = {
    curCellCount = BagInfoData.curBagCellCount,
    totalCellCount = BagInfoData.bagCellCount,
    colCount = BagInfoData.colCount
  }
  self.dragTbl = UIDragCellContainer(self, self.PutIn, self.ItemOnClick, CellDataTbl)
  self.dragTbl:SetParam(self.PutIn, self.ItemOnClick, true, true)
end

function EnchantmentSmeltingBag:ItemOnClick(control)
  if table.count(self.SmeltingBag) <= 0 then
    return
  end
  local itemCellData = control.data:GetData()
  local info = itemCellData.itemData
  local lastSelectItem = self.SmeltingInfo:GetSelectItemData()
  if not table.isNullOrEmpty(lastSelectItem) and lastSelectItem.itemData and lastSelectItem.itemData.id ~= info.id then
    itemCellData.selected = true
    lastSelectItem.selected = false
    self.SmeltingInfo:SetSelectItemData(itemCellData)
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    ItemUtility.ShowSelectImg(self.dragTbl, lastSelectItem)
    self:ShowTipsContrast(control, info)
  elseif not table.isNullOrEmpty(lastSelectItem) and lastSelectItem.itemData and lastSelectItem.itemData.id == info.id then
    itemCellData.selected = false
    self.SmeltingInfo:SetSelectItemData(nil)
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
  else
    itemCellData.selected = true
    self.SmeltingInfo:SetSelectItemData(itemCellData)
    ItemUtility.ShowSelectImg(self.dragTbl, itemCellData)
    self:ShowTipsContrast(control, info)
  end
  EventManager.Dispatch(Event.SmeltingBagChoose)
  if itemCellData.selected == false and UIManager.IsVisible(UIID.ItemTipUI) then
    self:ResetTipsLayer()
  end
end

function EnchantmentSmeltingBag:ShowTipsContrast(control, itemData)
  if not itemData or not itemData.tblEquip then
    return
  end
  if UIManager.IsVisible(UIID.ItemTipUI) then
    UIManager.SwitchVisible(UIID.ItemTipUI)
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    contrast = false,
    tipsPosValue = self:CalculationTipsPos(),
    SetLayerCallBack = function()
      ItemUtility.TrySetTipsLayer(UILayer.Panel)
    end
  })
end

function EnchantmentSmeltingBag:ResetTipsLayer()
  ItemUtility.TryReSetTipLayer()
  UIManager.Hide(UIID.ItemTipUI)
end

function EnchantmentSmeltingBag:CalculationTipsPos()
  if self.bgWidth == nil or self.bgHeight == nil then
    return nil
  end
  local pos = self.root.transform.localPosition
  pos.x = -self.bgWidth / 2
  pos.y = pos.y + self.bgHeight / 2
  pos.z = 0
  return self.root.transform:TransformPoint(pos)
end

function EnchantmentSmeltingBag:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_CloseBagOnClick)
  self.btn_CloseBag:SetOnClick(self, self.btn_CloseBagOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function EnchantmentSmeltingBag:btn_CloseBagOnClick(control)
  UIManager.Hide(UIID.EnchantmentSmeltingBag)
end

function EnchantmentSmeltingBag:descBtnOnClick(control)
end

function EnchantmentSmeltingBag:OnShow()
  self.SmeltingInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantmentSmeltingManager()
  self.SmeltingInfo:SetSelectItemData(nil)
  self:RegistEvents()
  self:Refresh()
end

function EnchantmentSmeltingBag:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.Refresh, self)
end

function EnchantmentSmeltingBag:Refresh()
  self.SmeltingBag = self:GetSmeltingBag()
  self.dragTbl:SetData(self.SmeltingBag, "EnchantmentSmeltingBag:Refresh")
end

function EnchantmentSmeltingBag:GetSmeltingBag()
  local info = {}
  if table.count(BagInfoData.TotalItems) > 0 then
    for i, v in pairs(BagInfoData.TotalItems) do
      if not table.isNullOrEmpty(v.serverInfo) and v.serverInfo.canSmelt then
        table.insert(info, v)
      end
    end
  end
  return info
end

function EnchantmentSmeltingBag:OnHide()
  for i, v in pairs(self.SmeltingBag) do
    v.selected = nil
  end
  self.SmeltingInfo:SetSelectItemData(nil)
  self:ResetTipsLayer()
end

function EnchantmentSmeltingBag:OnDestroy()
end

Item_CombinePreviewUI = class(BaseUI)
Item_CombinePreviewUI.layer = UILayer.Panel
Item_CombinePreviewUI.orderInLayer = 0
Item_CombinePreviewUI.hideType = UIHideType.WaitDestroy
Item_CombinePreviewUI.hideFunc = UIHideFunc.MoveOutOfScreen
Item_CombinePreviewUI.escClose = UIEscClose.DontClose

function Item_CombinePreviewUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_Close = self:GetControl("sw_combinePreviewNoEquip/btn_Close")
  self.item = self:GetControl("sw_combinePreviewNoEquip/Viewport/PreviewList/item")
  self.btn_Item = self:GetControl("sw_combinePreviewNoEquip/Viewport/PreviewList/item/btn_Item")
end

function Item_CombinePreviewUI:OnPreLoad()
end

function Item_CombinePreviewUI:Init()
end

function Item_CombinePreviewUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Item_CombinePreviewUI:InitUI()
  self.itemContainer = UIContainer(self.item, self)
end

function Item_CombinePreviewUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Item_CombinePreviewUI:OnHide()
end

function Item_CombinePreviewUI:OnDestroy()
end

function Item_CombinePreviewUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_Item:SetOnClick(self, self.btn_ItemOnClick)
end

function Item_CombinePreviewUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Item_CombinePreviewUI)
  for _, v in ipairs(UIManager.sortedUIs) do
    if v.logicTbl ~= nil and v ~= ui and v.visible and v.logicTbl.type ~= UIPanelType.SortAndHide then
      UIManager.UILogicClose(v, true)
    end
  end
end

function Item_CombinePreviewUI:btn_ItemOnClick(control)
  local itemData = control.itemData
  if itemData.tblItem.subType == 20 then
    local qualityDataDic = ItemCombineData:GetQualityData()
    local info = qualityDataDic[itemData.tblItem.quality]
    if info then
      itemData:DoWingGenerateAttr({
        damageBonus = info.damageBonus,
        damageAbsorption = info.damageAbsorption
      })
    else
      itemData:DoWingGenerateAttr({damageBonus = "#N/A", damageAbsorption = "#N/A"})
    end
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    ctrl = control,
    rightOperate = EItemOperateType.Show
  })
end

function Item_CombinePreviewUI:RegistEvents()
end

function Item_CombinePreviewUI:Refresh()
  local count = table.count(self.args.itemTab)
  self.itemContainer:SetMaxCount(count)
  for i = 1, count do
    local itemObj = self.itemContainer:GetOrCreateItem(i)
    local item = itemObj:GetChild("btn_3DItem")
    local lab_tips = itemObj:GetChild("lab_tips")
    lab_tips = UIControl(lab_tips)
    local itemInfo = ItemUtility.GenerateItemData(self.args.itemTab[i].itemId)
    if not itemObj.modelData then
      itemObj.modelData = ItemCellData()
    else
      itemObj.modelData:RecycleRes()
    end
    itemObj.modelData:RefreshData(itemInfo)
    ItemUtility.ShowItemCell(item, itemObj.modelData, self, false)
    item.itemData = itemInfo
    item:SetOnClick(self, self.btn_ItemOnClick)
    local itemTipsTbl = ClientTable.cfg_Item_tipsManager:TryGetValue(itemInfo.tblItem.itemTips)
    if itemTipsTbl and itemInfo.tblItem.type ~= 28 then
      lab_tips:SetText(itemTipsTbl.content)
    else
      lab_tips:SetText("")
    end
  end
  self.itemContainer:Refresh()
end

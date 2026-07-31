local ConsumableUnitTemplate = {}

function ConsumableUnitTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function ConsumableUnitTemplate:InitParams()
  self.parentTbl = nil
  self.consumabelData = nil
end

function ConsumableUnitTemplate:InitControls()
  self.Model = self:GetControl("Model")
  self.lab_name = self:GetControl("lab_name")
  self.lab_num = self:GetControl("lab_num")
  self.btn_obtain = self:GetControl("btn_obtain")
end

function ConsumableUnitTemplate:BindUIEvent()
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function ConsumableUnitTemplate:ClickObtainCallBack(_, control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true,
    BusinessPay = control.BusinessPay,
    OpenWay = control.OpenTipsType,
    countDownTime = control.countDownTime
  })
end

function ConsumableUnitTemplate:Refresh(data, ui)
  self.consumabelData = data
  self.parentTbl = ui
  self:RefreshView()
end

function ConsumableUnitTemplate:RefreshView()
  if self.consumabelData == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(self.consumabelData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  self.lab_name:SetText(itemData.tblItem.name)
  self:RefreshModelView(itemData)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData.itemId)
  local targetCount = self.consumabelData.count
  local isMeet = bagCount >= targetCount
  self:RefreshCount(self.consumabelData.itemId)
  self.btn_obtain:SetActive(not isMeet)
  self.btn_obtain.itemData = itemData
  self.btn_obtain.OpenTipsType = EOpenTipsType.FastBuy
end

function ConsumableUnitTemplate:RefreshModelView(itemData)
  if self.Model.cellData == nil then
    self.Model.cellData = ItemCellData()
  end
  self.Model.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.Model, self.Model.cellData, self.parentTbl, true)
  self.Model.itemData = itemData
  self.Model.OpenTipsType = EOpenTipsType.FastBuy
end

function ConsumableUnitTemplate:RefreshCount(itemId)
  if itemId ~= self.consumabelData.itemId then
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData.itemId)
  local targetCount = self.consumabelData.count
  local isMeet = bagCount >= targetCount
  local numColor = isMeet and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  local count = Mathf.NumberShowFormat(tonumber(bagCount))
  self.lab_num:SetText(string.GetColorText(count .. "/" .. targetCount, numColor))
end

return ConsumableUnitTemplate

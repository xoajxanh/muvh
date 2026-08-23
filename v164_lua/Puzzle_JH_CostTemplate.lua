local Puzzle_JH_CostTemplate = {}

function Puzzle_JH_CostTemplate:Init()
  self:InitParams()
  self:InitControls()
  self:BindUIEvent()
end

function Puzzle_JH_CostTemplate:InitParams()
  self.parentTbl = nil
  self.consumabelData = nil
end

function Puzzle_JH_CostTemplate:InitControls()
  self.Model = self:GetControl("go_model")
  self.lab_name = self:GetControl("lab_name")
  self.lab_num = self:GetControl("lab_num")
  self.btn_obtain = self:GetControl("btn_obtain")
end

function Puzzle_JH_CostTemplate:BindUIEvent()
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Puzzle_JH_CostTemplate:ClickObtainCallBack(_, control)
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

function Puzzle_JH_CostTemplate:Refresh(data, ui)
  self.consumabelData = data
  self.parentTbl = ui
  self:RefreshView()
end

function Puzzle_JH_CostTemplate:RefreshView()
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

function Puzzle_JH_CostTemplate:RefreshModelView(itemData)
  if self.Model.cellData == nil then
    self.Model.cellData = ItemCellData()
  end
  self.Model.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self:UIControl(), self.Model.cellData, self.parentTbl, true)
  self.Model.itemData = itemData
  self.Model.OpenTipsType = EOpenTipsType.FastBuy
end

function Puzzle_JH_CostTemplate:RefreshCount(itemId)
  if itemId ~= self.consumabelData.itemId then
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData.itemId)
  local targetCount = self.consumabelData.count
  local isMeet = bagCount >= targetCount
  local numColor = isMeet and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  self.lab_num:SetText(string.GetColorText(bagCount .. "/" .. targetCount, numColor))
end

return Puzzle_JH_CostTemplate

ItemCombineCostTemplate = class()
setgetters(ItemCombineCostTemplate, {
  MaxCombineCount = function(self)
    if self.ownCount == nil or self.requireCount == nil then
      return 1
    else
      local count = math.floor(self.ownCount / self.requireCount)
      if count < 1 then
        count = 1
      end
      return count
    end
  end
})
local defaultCostIcon = "img_itemBright"

function ItemCombineCostTemplate:ctor(baseUI, uicontrol)
  self.baseUI = baseUI
  self.control = uicontrol
  self:Init()
end

function ItemCombineCostTemplate:Init()
  self:InitControls()
  self:InitListeners()
end

function ItemCombineCostTemplate:InitControls()
  self.costIcon = self.control:GetChild("btn_3DItem")
  self.costItem = ItemUtility.InitItemCell(self.costIcon)
  self.costModelInfo = ItemCellData()
  self.ownCntLab = self.control:GetChild("lab_costInfo")
  self.addEquipeBtn = self.control:GetChild("btn_addEquipe")
  self.addItemBtn = self.control:GetChild("btn_addItem")
end

function ItemCombineCostTemplate:InitListeners()
  self.addEquipeBtn:SetOnClick(self, self.OnBtnEquipe)
  self.addItemBtn:SetOnClick(self, self.OnBtnAddItem)
  self.costIcon:SetOnClick(self, self.OnBtnCostItem)
end

function ItemCombineCostTemplate:OnBtnEquipe(control)
  UIManager.Hide(UIID.ItemTipUI)
  local optionalItems = {}
  if self.combineCfg and self.combineCfg.costMainBuckets and self.combineCfg.costMainBuckets[1] then
    local conditionTab = {}
    local costMainBuckets = self.combineCfg.costMainBuckets
    local UseSelectItemsAndID = false
    for j = 1, #costMainBuckets[1] do
      if costMainBuckets[1][j][2] and type(costMainBuckets[1][j][2]) ~= "table" then
        costMainBuckets[1][j][2] = tonumber(costMainBuckets[1][j][2])
        local condition = ConditionManager.GenerateSingleCondition(costMainBuckets[1][j])
        table.insert(conditionTab, condition)
        UseSelectItemsAndID = true
      else
        local condition = ConditionManager.GenerateSingleCondition(costMainBuckets[1][j])
        table.insert(conditionTab, condition)
      end
    end
    if UseSelectItemsAndID then
      optionalItems = BagInfoData.SelectItemsAndID(conditionTab)
    else
      optionalItems = BagInfoData.SelectItems(conditionTab)
    end
  end
  self.baseUI:ShowAddItemWidget(self, optionalItems, self.OnCloseAddItemWidget)
  if self.addEquipeBtn.transform.gameObject.activeSelf then
    ItemCombineData:SetClickHonoerId(nil)
  end
end

function ItemCombineCostTemplate:OnCloseAddItemWidget(selectedItem)
  if selectedItem ~= nil then
    self.costModelInfo:RefreshData(selectedItem)
    self.costModelInfo.isShowArrow = false
    ItemUtility.ShowItemCell(self.costItem, self.costModelInfo, self.baseUI, false)
    self.costItem.img_grrow:SetActive(false)
    self.filledItem = selectedItem.tblItem
    self.filledItemData = selectedItem
    self.satisfied = true
    self:RefreshCombineCount()
  end
end

function ItemCombineCostTemplate:OnBtnAddItem(control)
end

function ItemCombineCostTemplate:OnBtnCostItem(control)
  if self.filledItem == nil then
    return
  end
  if self.isCertainCost then
    local itemData = ItemUtility.GenerateItemData(self.filledItem)
    if itemData.tblItem then
      if BagInfoData.GetItemTotalCountByItemId(itemData.itemId) >= self.requireCount then
        UIManager.Show(UIID.ItemTipUI, {
          item = itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = control,
          notBindCount = self.notBindCount,
          bindCount = self.CombineCount
        })
      else
        UIManager.Show(UIID.ItemTipUI, {
          item = itemData,
          rightOperate = EItemOperateType.Show,
          ctrl = control,
          ShowObtain = true,
          notBindCount = self.notBindCount,
          bindCount = self.CombineCount
        })
      end
    end
  else
    local operate = self.filledItemData.tblItem.leftOperate
    self.filledItemData.tblItem.leftOperate = 0
    local args = {
      item = self.filledItemData,
      ctrl = control,
      notBindCount = self.notBindCount,
      bindCount = self.CombineCount,
      rightOperate = {
        name = Localization.GetUIWord("tihuan"),
        ui = self,
        func = self.OnBtnEquipe
      }
    }
    ItemCombineData:SetClickHonoerId(args.item.id)
    UIManager.Show(UIID.ItemTipUI, args)
    self.filledItemData.tblItem.leftOperate = operate
  end
end

function ItemCombineCostTemplate:InitUI(combineCfg, bucket, isOptionalBuckets, isSelectedAddItem)
  if isSelectedAddItem and isOptionalBuckets then
    return
  end
  self.combineCfg = combineCfg
  self.bucket = bucket
  local iconName = defaultCostIcon
  self.satisfied = false
  self.filledItem = nil
  self.isCertainCost = bucket.itemId ~= nil
  if self.isCertainCost then
    local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(bucket.itemId)
    iconName = itemTbl.icon
    self.filledItem = itemTbl
  end
  local itemData
  if bucket.itemId then
    itemData = ItemUtility.GenerateItemData(bucket.itemId)
    self.costModelInfo:RecycleRes()
    self.costModelInfo:RefreshData(itemData)
  else
    self.costModelInfo:RefreshData()
  end
  self.itemIcon = UIControl(self.costIcon.transform, "img_icon")
  if iconName == defaultCostIcon then
    self.costModelInfo.isShowArrow = false
    ItemUtility.ShowItemCell(self.costItem, self.costModelInfo, self.baseUI, false)
  else
    local tempTab = {}
    tempTab.tblItem = {icon = iconName, overlying = 1}
    tempTab.count = 0
    self.costModelInfo.isShowArrow = false
    ItemUtility.ShowItemCell(self.costItem, self.costModelInfo, self.baseUI, false)
  end
  self.costItem.countCtr:SetActive(false)
  self.ownCntLab:SetActive(true)
  local originSize = self.ownCntLab.rectTransform.sizeDelta
  self.ownCntLab.rectTransform.sizeDelta = Vector2.right * originSize.x + Vector2.up * 40
  self:RefreshCombineCount(1)
end

function ItemCombineCostTemplate:SetActive(bActive)
  self.active = bActive
  self.control:SetActive(bActive)
end

local function BadyCheck(param)
  local roleData = ViewData.meData
  if not roleData then
    return 0
  end
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(param))
  local count = 0
  for i, v in pairs(roleData.equipsData.Data) do
    if v.itemId == tonumber(param) or v.itemId == itemTab.bindEqualItem then
      count = count + 1
    end
  end
  for k, v in pairs(roleData.mountData.Mounts) do
    if v.itemId == tonumber(param) or v.itemId == itemTab.bindEqualItem then
      count = count + 1
    end
  end
  if 0 < count then
    count = 1
  end
  return count
end

function ItemCombineCostTemplate:RefreshCombineCount(count)
  local color, txt
  if self.isCertainCost then
    self.requireCount = self.bucket.count * count
    self.ownCount, self.CombineCount, self.notBindCount = BagInfoData.GetItemTotalCountByItemIdAndContainBind(self.bucket.itemId)
    self.ownCount = self.ownCount + BadyCheck(self.bucket.itemId)
    self.satisfied = self.ownCount >= self.requireCount
    color = self.satisfied and "#00DD00" or "#FF0000"
    if self.requireCount * self.ownCount < 99800 and self.requireCount < 99800 then
      txt = string.format("<color=%s>%d</color>/%d", color, self.ownCount, self.requireCount)
    else
      txt = string.format([[
<color=%s>%s</color>
/%s]], color, Mathf.NumberShowFormat(self.ownCount, 0), Mathf.NumberShowFormat(self.requireCount, 1))
    end
    self.ownCntLab:SetText(txt)
    color = self.satisfied and Color.white or Color.gray
    self.addItemBtn:SetActive(not self.satisfied)
    self.addEquipeBtn:SetActive(false)
  else
    color = self.satisfied and Color.white or Color.gray
    self.addEquipeBtn:SetActive(not self.satisfied)
    self.addItemBtn:SetActive(false)
    if not self.satisfied then
      txt = Localization.GetUIWord("zhuangbeiyijian")
      self.ownCntLab:SetText(txt)
    end
    self.ownCntLab:SetActive(not self.satisfied)
  end
end

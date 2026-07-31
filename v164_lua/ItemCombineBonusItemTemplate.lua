ItemCombineBonusItemTemplate = class()
setgetters(ItemCombineBonusItemTemplate, {
  Active = function(self)
    return self.control:GetActive()
  end,
  SumBonusRate = function(self)
    return self.bonusCount * self.bonusRate
  end
})

function ItemCombineBonusItemTemplate:ctor(baseui, control)
  self.baseUI = baseui
  self.control = control
  self:InitUI()
  self:ResetUI()
end

function ItemCombineBonusItemTemplate:InitUI()
  self.btnItem = self.control:GetChild("btn_Item")
  self.btn_mineBonusBucket = self.control:GetChild("img_progress/btn_mineBonusBucket")
  self.btn_addBonusBucket = self.control:GetChild("img_progress/btn_addBonusBucket")
  self.lab_bonusCount = self.control:GetChild("img_progress/lab_bonusCount")
  self.btnItem:SetOnClick(self, self.btnItemOnClick)
  self.btn_mineBonusBucket:SetOnClick(self, self.btn_mineBonusBucketOnClick)
  self.btn_addBonusBucket:SetOnClick(self, self.btn_addBonusBucketOnClick)
end

function ItemCombineBonusItemTemplate:btnItemOnClick(control)
  local itemdata = ItemUtility.GenerateItemData(self.bonusItemId)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemdata,
    rightOperate = EItemOperateType.Show,
    ctrl = control
  })
end

function ItemCombineBonusItemTemplate:btn_mineBonusBucketOnClick(control)
  self:SetBonusCount(self.bonusCount - 1)
end

function ItemCombineBonusItemTemplate:btn_addBonusBucketOnClick(control)
  if not self.baseUI:CheckMaxBonusRate() then
    UIManager.Show(UIID.PromptTipUI, {
      textContent = Localization.GetUIWord("dangqianchenggonglvyidazuidazhi")
    })
    return
  end
  self:SetBonusCount(self.bonusCount + 1)
end

function ItemCombineBonusItemTemplate:RefreshUI(bucketConfig)
  local params = string.stringToNumberArray(bucketConfig, "#")
  self.bonusItemId = params[1]
  self.bonusRate = params[2]
  self.ownCount = BagInfoData.GetItemTotalCountByItemId(self.bonusItemId)
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(self.bonusItemId)
  local isHaveItemInfo = false
  local bagShowInfo = BagInfoData.TotalItems
  for k, v in pairs(bagShowInfo) do
    if v and v.itemId == self.bonusItemId then
      local btnItem = UIControl(self.btnItem.transform)
      ItemUtility.ShowItem(self.baseUI, btnItem, v)
      isHaveItemInfo = true
      break
    end
  end
  if not isHaveItemInfo then
    local itemIcon = UIControl(self.btnItem.transform, "img_icon")
    self.baseUI:SetSprite("Atlas_Icon", itemCfg.icon, itemIcon)
  end
  self:SetBonusCount(self.bonusCount)
end

function ItemCombineBonusItemTemplate:ResetUI()
  self.bonusRate = 0
  self.bonusItemId = 0
  self.ownCount = 0
  self.bonusCount = 0
  self:SetBonusCount(0)
end

function ItemCombineBonusItemTemplate:SetBonusCount(count)
  self.bonusCount = count
  self.totalBonusRate = self.bonusCount * self.bonusRate
  if self.bonusCount == nil then
    self.bonusCount = 0
  end
  if self.ownCount == nil then
    self.ownCount = 0
  end
  self.lab_bonusCount:SetText(string.format("%d/%d", self.bonusCount, self.ownCount))
  self.btn_addBonusBucket:SetInteractable(self.bonusCount < self.ownCount)
  self.btn_mineBonusBucket:SetInteractable(self.bonusCount > 0)
  self.baseUI:RefreshBonusInfo()
end

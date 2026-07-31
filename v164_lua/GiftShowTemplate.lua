local GiftShowTemplate = {}

function GiftShowTemplate:Init(rootUI)
  self:InitControls(rootUI)
end

local function OnEquipItemCreate(ctr)
  ctr.itemCellData = ItemCellData()
end

local function OnEquipItemRefresh(ctr, index, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui.rootUI, true)
end

function GiftShowTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.btn_equipPrize = self:GetControl("btn_equipPrize")
  self.img_sellOut = self:GetControl("img_sellOut")
  self.lab_equipBuy = self:GetControl("btn_equipPrize/lab_equipBuy")
  self.lab_originalPrice = self:GetControl("btn_equipPrize/lab_originalPrice")
  self.Img_bscript = self:GetControl("Img_bscript")
  self.lab_buylimit = self:GetControl("lab_buylimit")
  self.lab_equipGistName = self:GetControl("lab_equipGistName")
  self.btn_equipItem = self:GetControl("go_equipGistItem/sw_ItemEquip/Viewport/Content/btn_equipItem")
  self.btn_equipItemContainer = UIContainer(self.btn_equipItem, self, OnEquipItemCreate, OnEquipItemRefresh)
  self.btn_equipPrize:SetOnClick(self, self.btn_equipPrizeOnClick)
end

function GiftShowTemplate:Refresh(data, ui)
  self.id = data.id
  if data.title then
    local name = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data.title)
    self.lab_equipGistName:SetText(name)
  end
  if not string.isNullOrEmpty(data.cost) then
    local costTbl = ParseUtility.ParseSingleCost(data.cost)
    self.costCount = costTbl.count
    local text = tostring(costTbl.count)
    self.isCanBuy = true
    if BagInfoData.GetItemTotalCountByItemId(costTbl.itemId) < costTbl.count then
      self.isCanBuy = false
      text = string.GetColorText(text, ItemQuality2ColorDic[EItemColorEnum.red])
    end
    self.lab_equipBuy:SetText(text)
  end
  if not string.isNullOrEmpty(data.reward) then
    local rewardInfo = string.split(data.reward, "&")
    self.rewardList = {}
    for i, v in ipairs(rewardInfo) do
      local rewardStr = string.split(v, "#")
      if 2 <= #rewardStr then
        local itemId = tonumber(rewardStr[1])
        local count = tonumber(rewardStr[2])
        table.insert(self.rewardList, {itemId = itemId, count = count})
      end
    end
    self.btn_equipItemContainer:SetData(self.rewardList)
  end
  self:RefreshBuyCount(data)
  local discount = ClientTable.cfg_Global_globalManager:GetSpellSwordGiftDiscountBySubType(data.subtype)
  if discount then
    self.lab_originalPrice:SetText("Gi\195\161 g\225\187\145c: " .. tostring(self.costCount * discount))
  end
  self:RefreshDiscountSprite(data, ui)
end

function GiftShowTemplate:RefreshBuyCount(data)
  if data and data.countKey and data.countKey > 0 then
    local remainder = RefreshData.GetLimitCount(data.countKey)
    if remainder == nil then
      return
    end
    if 0 < remainder then
      self.btn_equipPrize:SetActive(true)
      self.img_sellOut:SetActive(false)
    else
      self.btn_equipPrize:SetActive(false)
      self.img_sellOut:SetActive(true)
    end
    local str = ""
    local countTab = ClientTable.cfg_Count_countManager:TryGetValue(data.countKey, "key")
    if countTab == nil then
      return
    end
    if string.isNullOrEmpty(countTab.refreshRule) then
      str = string.format("D%sA", remainder)
    else
      local refreshRuleTbl = string.split(countTab.refreshRule, "#")
      local refreshType = tonumber(refreshRuleTbl[1])
      if refreshType == EConditionEnum.timeMonthMoreThanOrEqual then
        str = LocalizationUtility.GetContentByKey("ShopUi_7")
        str = str .. remainder
      elseif refreshType == EConditionEnum.timeWeekendMoreThanOrEqual then
        str = string.format("C%sA", remainder)
      else
        str = string.format("B%sA", remainder)
      end
    end
    self.lab_buylimit:SetText(str)
  end
end

function GiftShowTemplate:RefreshDiscountSprite(data, ui)
  if data and data.subtype then
    local spriteName = ClientTable.cfg_Global_globalManager:GetSpellSwordGiftSpriteNameBySubType(data.subtype)
    if spriteName then
      ui:SetSprite("Atlas_Language", spriteName, self.Img_bscript)
    end
  end
end

function GiftShowTemplate:btn_equipPrizeOnClick()
  if not self.isCanBuy then
    local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
    FloatingWordUtility.QuickMsg(tipStr)
    UIManager.Hide(UIID.Commercial_SpellSwordGiftUI)
    RechargeData.BuyDiamond()
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = self.id,
    buyCount = 1
  })
end

function GiftShowTemplate:DestroyItemData()
  for i = 1, #self.btn_equipItemContainer.items do
    local ctrBtn = self.btn_equipItemContainer.items[i]
    ctrBtn.itemCellData:RecycleRes()
  end
end

return GiftShowTemplate

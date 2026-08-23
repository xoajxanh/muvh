Tip_ObtainTipUI = class(BaseUI)
Tip_ObtainTipUI.layer = UILayer.MessageBox
Tip_ObtainTipUI.orderInLayer = 1
Tip_ObtainTipUI.hideType = UIHideType.Destroy
Tip_ObtainTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_ObtainTipUI.escClose = UIEscClose.DontClose

function Tip_ObtainTipUI:InitControls()
  self.Bg_btn = self:GetControl("Bg_btn")
  self.lab_TipTitle = self:GetControl("Scroll View/lab_TipTitle")
  self.img_CombineTitle = self:GetControl("Scroll View/ArtTextTitle")
  self.Scroll_reward = self:GetControl("Scroll View/Content/Scroll_reward")
  self.bg_frameF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF")
  self.ContentF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF/Viewport/ContentF")
  self.btn_3DItemF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF/Viewport/ContentF/btn_3DItemF")
  self.Scroll_specialReward = self:GetControl("Scroll View/Content/Scroll_specialReward")
  self.bg_frameS = self:GetControl("Scroll View/Content/Scroll_specialReward/bg_frameS")
  self.ContentS = self:GetControl("Scroll View/Content/Scroll_specialReward/bg_frameS/Viewport/ContentS")
  self.btn_3DItemS = self:GetControl("Scroll View/Content/Scroll_specialReward/bg_frameS/Viewport/ContentS/btn_3DItemS")
  self.Button_confirm = self:GetControl("Button_confirm")
end

function Tip_ObtainTipUI:Init()
end

function Tip_ObtainTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_ObtainTipUI:InitUI()
  self:InitContent()
end

local function InitGeneralRewardsItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemGeneralRewardsRefresh(ctr, _, itemData, ui)
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

local function InitSpecialRewardsItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemSpecialRewardsRefresh(ctr, _, itemData, ui)
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Tip_ObtainTipUI:InitContent()
  self.generalRewardsItemTemp = UIContainer(self.btn_3DItemF, self, InitGeneralRewardsItemControls, ItemGeneralRewardsRefresh)
  self.specialRewardsItemTemp = UIContainer(self.btn_3DItemS, self, InitSpecialRewardsItemControls, ItemSpecialRewardsRefresh)
end

function Tip_ObtainTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_ObtainTipUI:OnHide()
  if self.timer then
    Timer.Stop(self.timer)
  end
  self.lab_TipTitle:SetActive(true)
  self.img_CombineTitle:SetActive(false)
end

function Tip_ObtainTipUI:OnDestroy()
end

function Tip_ObtainTipUI:RegistUIEvents()
  self.Bg_btn:SetOnClick(self, self.btn_CloseOnClick)
  self.Button_confirm:SetOnClick(self, self.button_confirm)
end

function Tip_ObtainTipUI:btn_CloseOnClick()
  UIManager.Hide(UIID.ObtainTipUI)
end

function Tip_ObtainTipUI:button_confirm()
  UIManager.Hide(UIID.ObtainTipUI)
end

function Tip_ObtainTipUI:RewardRecycle()
  for i = 1, #self.generalRewardsItemTemp.items do
    self.generalRewardsItemTemp.items[i]:SetActive(false)
  end
end

function Tip_ObtainTipUI:RegistEvents()
end

function Tip_ObtainTipUI:Refresh()
  if self.args and self.args.isCombine then
    self.lab_TipTitle:SetText("Gh\195\169p th\195\160nh c\195\180ng")
  else
    self.lab_TipTitle:SetText("Th\198\176\225\187\159ng")
  end
  if self.args ~= nil and self.args.generalRewards then
    self.Scroll_reward.gameObject:SetActive(true)
    local allRewardData = {}
    local collectionData = {}
    for k, v in pairs(self.args.generalRewards) do
      local data = ClientTable.cfg_Item_equipManager:TryGetValue(v.itemId)
      if data then
        data = EquipData(v)
      else
        data = ItemData(v)
      end
      if data.tblItem.overlying > 1 then
        if not table.containsKey(collectionData, v.itemId) then
          collectionData[v.itemId] = data
        else
          collectionData[v.itemId].count = collectionData[v.itemId].count + 1
        end
      elseif data.tblItem.overlying == 1 then
        collectionData[v.id] = data
      end
    end
    for k, v in pairs(collectionData) do
      table.insert(allRewardData, v)
    end
    self.generalRewardsItemTemp:SetData(allRewardData)
    local lineCount = math.ceil(#allRewardData / 7)
    self.generalRewardsItemTemp.rectTransform.sizeDelta = Vector2.right * 600 + Vector2.up * lineCount * 85
    if self.args and self.args.isCombine then
      self:ShowCombineEffect()
    end
  else
    self.Scroll_reward.gameObject:SetActive(false)
  end
  if self.args ~= nil and self.args.specialRewards then
    self.Scroll_specialReward.gameObject:SetActive(true)
    local allRewardData = {}
    for k, v in pairs(self.args.specialRewards) do
      table.insert(allRewardData, v)
    end
    self.specialRewardsItemTemp:SetData(allRewardData)
  else
    self.Scroll_specialReward.gameObject:SetActive(false)
  end
end

function Tip_ObtainTipUI:ShowCombineEffect()
  self.lab_TipTitle:SetActive(false)
  self.img_CombineTitle:SetActive(true)
end

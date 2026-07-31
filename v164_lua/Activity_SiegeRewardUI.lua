Activity_SiegeRewardUI = class(BaseUI)
Activity_SiegeRewardUI.layer = UILayer.MessageBox
Activity_SiegeRewardUI.orderInLayer = 10
Activity_SiegeRewardUI.hideType = UIHideType.WaitDestroy
Activity_SiegeRewardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeRewardUI.escClose = UIEscClose.DontClose

function Activity_SiegeRewardUI:InitControls()
  self.btn_siegeRewardClose = self:GetControl("img_siegeRewardBg/btn_siegeRewardClose")
  self.tog_occupyReward = self:GetControl("img_siegeRewardBg/go_togReward/tog_occupyReward")
  self.tog_integralReward = self:GetControl("img_siegeRewardBg/go_togReward/tog_integralReward")
  self.go_occupyReward = self:GetControl("img_siegeRewardBg/go_occupyReward")
  self.go_integralReward = self:GetControl("img_siegeRewardBg/go_integralReward")
  self.btn_SmallItem = self:GetControl("img_siegeRewardBg/go_occupyReward/sw_rewardPreview/Viewport/Content/btn_SmallItem")
  self.btn_BigItem = self:GetControl("img_siegeRewardBg/go_occupyReward/sw_rewardPreviewLeader/Viewport/Content/btn_BigItem")
  self.btn_FirstScoreItem = self:GetControl("img_siegeRewardBg/go_integralReward/sw_rewardOne/Viewport/Content/btn_FirstScoreItem")
  self.btn_SecScoreItem = self:GetControl("img_siegeRewardBg/go_integralReward/sw_rewardTwo/Viewport/Content/btn_SecScoreItem")
  self.btn_ThirdScoreItem = self:GetControl("img_siegeRewardBg/go_integralReward/sw_rewardThree/Viewport/Content/btn_ThirdScoreItem")
end

function Activity_SiegeRewardUI:OnPreLoad()
end

function Activity_SiegeRewardUI:Init()
end

function Activity_SiegeRewardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeRewardUI:InitUI()
  self.tog_occupyReward.type = "occupy"
  self.tog_integralReward.type = "integral"
  self:InitContent()
end

local function ItemCreate(control)
  if control.itemCellData then
    control.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    control.itemCellData = itemCellData
  end
end

local function ItemRefresh(ctr, _, itemData, ui)
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Activity_SiegeRewardUI:InitContent()
  self.btn_SmallItemTemp = UIContainer(self.btn_SmallItem, self, ItemCreate, ItemRefresh)
  self.btn_BigItemTemp = UIContainer(self.btn_BigItem, self, ItemCreate, ItemRefresh)
  self.btn_FirstScoreItemTemp = UIContainer(self.btn_FirstScoreItem, self, ItemCreate, ItemRefresh)
  self.btn_SecScoreItemTemp = UIContainer(self.btn_SecScoreItem, self, ItemCreate, ItemRefresh)
  self.btn_ThirdScoreItemTemp = UIContainer(self.btn_ThirdScoreItem, self, ItemCreate, ItemRefresh)
end

function Activity_SiegeRewardUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeRewardUI:OnHide()
end

function Activity_SiegeRewardUI:OnDestroy()
end

function Activity_SiegeRewardUI:RegistUIEvents()
  self.btn_siegeRewardClose:SetOnClick(self, self.btn_siegeRewardCloseOnClick)
  self.tog_occupyReward:SetOnToggleChanged(self, self.ShowOccupyRewardUI)
  self.tog_integralReward:SetOnToggleChanged(self, self.ShowIntegralRewardUI)
end

function Activity_SiegeRewardUI:btn_siegeRewardCloseOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeRewardUI:ShowOccupyRewardUI(control, isOn)
  control:GetChild("img_clickeffect"):SetActive(isOn)
  self.go_occupyReward:SetActive(isOn)
end

function Activity_SiegeRewardUI:ShowIntegralRewardUI(control, isOn)
  control:GetChild("img_clickeffect"):SetActive(isOn)
  self.go_integralReward:SetActive(isOn)
end

function Activity_SiegeRewardUI:RegistEvents()
end

function Activity_SiegeRewardUI:Refresh()
  self:ShowItems()
end

function Activity_SiegeRewardUI:ShowItems()
  self.btn_SmallItemTemp:SetData(Activity_LuoLanSiegeData.rewardSmallData)
  self.btn_SmallItemTemp:Refresh()
  self.btn_BigItemTemp:SetData(Activity_LuoLanSiegeData.rewardBigData)
  self.btn_BigItemTemp:Refresh()
  self.btn_FirstScoreItemTemp:SetData(Activity_LuoLanSiegeData.rewardFirScoreData)
  self.btn_FirstScoreItemTemp:Refresh()
  self.btn_SecScoreItemTemp:SetData(Activity_LuoLanSiegeData.rewardSecScoreData)
  self.btn_SecScoreItemTemp:Refresh()
  self.btn_ThirdScoreItemTemp:SetData(Activity_LuoLanSiegeData.rewardThirdScoreData)
  self.btn_ThirdScoreItemTemp:Refresh()
end

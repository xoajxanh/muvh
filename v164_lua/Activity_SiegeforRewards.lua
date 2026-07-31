Activity_SiegeforRewards = class(BaseUI)
Activity_SiegeforRewards.layer = UILayer.Panel
Activity_SiegeforRewards.orderInLayer = 10
Activity_SiegeforRewards.hideType = UIHideType.WaitDestroy
Activity_SiegeforRewards.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeforRewards.escClose = UIEscClose.DontClose

function Activity_SiegeforRewards:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_Activity/btn_close")
  self.tog_occupyReward = self:GetControl("panel_tab/tog_occupyReward")
  self.tog_integralReward = self:GetControl("panel_tab/tog_integralReward")
  self.panel_occupyReward = self:GetControl("panel_main/panel_occupyReward")
  self.btn_winWarBoss = self:GetControl("panel_main/panel_occupyReward/SiegeReward_Victorious/victoriousLeaderReward/sw_victoriousLeaderReward/Viewport/Content/btn_winWarBoss")
  self.btn_winBoy = self:GetControl("panel_main/panel_occupyReward/SiegeReward_Victorious/victoriousMemberReward/sw_victoriousMemberReward/Viewport/Content/btn_winBoy")
  self.btn_winAuction = self:GetControl("panel_main/panel_occupyReward/SiegeReward_Victorious/victoriousAuctionReard/sw_victoriousAuctionReard/Viewport/Content/btn_winAuction")
  self.btn_failBoy = self:GetControl("panel_main/panel_occupyReward/SiegeReward_Failed/failedMemberReward/sw_failedMemberReward/Viewport/Content/btn_failBoy")
  self.btn_failAuction = self:GetControl("panel_main/panel_occupyReward/SiegeReward_Failed/failedAuctionReard/sw_failedAuctionReard/Viewport/Content/btn_failAuction")
  self.panel_integralReward = self:GetControl("panel_main/panel_integralReward")
  self.plane_top = self:GetControl("panel_main/panel_integralReward/tx_integralReward/plane_top")
  self.btn_first = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/firstGear/sw_victoriousLeaderReward/Viewport/Content/btn_first")
  self.btn_second = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/secondGear/sw_victoriousLeaderReward/Viewport/Content/btn_second")
  self.btn_third = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/thirdGear/sw_victoriousLeaderReward/Viewport/Content/btn_third")
  self.btn_fourth = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/fourthGear/sw_victoriousLeaderReward/Viewport/Content/btn_fourth")
  self.btn_fifth = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/fifthGear/sw_victoriousLeaderReward/Viewport/Content/btn_fifth")
  self.btn_sixth = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/sixthGear/sw_victoriousLeaderReward/Viewport/Content/btn_sixth")
  self.btn_seventh = self:GetControl("panel_main/panel_integralReward/tx_integralReward/sw_integralReward/Viewport/Content/seventhGear/sw_victoriousLeaderReward/Viewport/Content/btn_seventh")
  self.plane_down = self:GetControl("panel_main/panel_integralReward/tx_integralReward/plane_down")
end

function Activity_SiegeforRewards:OnPreLoad()
end

function Activity_SiegeforRewards:Init()
end

function Activity_SiegeforRewards:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeforRewards:InitUI()
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

function Activity_SiegeforRewards:InitContent()
  self.winBossItemTemp = UIContainer(self.btn_winWarBoss, self, ItemCreate, ItemRefresh)
  self.winBoyItemTemp = UIContainer(self.btn_winBoy, self, ItemCreate, ItemRefresh)
  self.winAuctionItemTemp = UIContainer(self.btn_winAuction, self, ItemCreate, ItemRefresh)
  self.failBoyItemTemp = UIContainer(self.btn_failBoy, self, ItemCreate, ItemRefresh)
  self.failAuctionItemTemp = UIContainer(self.btn_failAuction, self, ItemCreate, ItemRefresh)
  self.firstItemTemp = UIContainer(self.btn_first, self, ItemCreate, ItemRefresh)
  self.secondItemTemp = UIContainer(self.btn_second, self, ItemCreate, ItemRefresh)
  self.thirdItemTemp = UIContainer(self.btn_third, self, ItemCreate, ItemRefresh)
  self.fourthItemTemp = UIContainer(self.btn_fourth, self, ItemCreate, ItemRefresh)
  self.fifthItemTemp = UIContainer(self.btn_fifth, self, ItemCreate, ItemRefresh)
  self.sixthItemTemp = UIContainer(self.btn_sixth, self, ItemCreate, ItemRefresh)
  self.seventhItemTemp = UIContainer(self.btn_seventh, self, ItemCreate, ItemRefresh)
end

function Activity_SiegeforRewards:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeforRewards:OnHide()
end

function Activity_SiegeforRewards:OnDestroy()
end

function Activity_SiegeforRewards:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_occupyReward:SetOnToggleChanged(self, self.ShowOccupyReward)
  self.tog_integralReward:SetOnToggleChanged(self, self.ShowIntegralReward)
end

function Activity_SiegeforRewards:ShowOccupyReward(control)
  self.panel_occupyReward:SetActive(control:GetIsOn())
end

function Activity_SiegeforRewards:ShowIntegralReward(control)
  self.panel_integralReward:SetActive(control:GetIsOn())
end

function Activity_SiegeforRewards:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeforRewards:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeRewardUI)
end

function Activity_SiegeforRewards:RegistEvents()
end

function Activity_SiegeforRewards:Refresh()
  self:ShowItems()
end

function Activity_SiegeforRewards:ShowItems()
  self.winBossItemTemp:SetData(Activity_LuoLanSiegeData.rewardWinBossData)
  self.winBoyItemTemp:SetData(Activity_LuoLanSiegeData.rewardWinBoyData)
  self.winAuctionItemTemp:SetData(Activity_LuoLanSiegeData.rewardWinAuctionData)
  self.failBoyItemTemp:SetData(Activity_LuoLanSiegeData.rewardFailBoyData)
  self.failAuctionItemTemp:SetData(Activity_LuoLanSiegeData.rewardFailAuctionData)
  self.firstItemTemp:SetData(Activity_LuoLanSiegeData.rewardFirScoreData)
  self.secondItemTemp:SetData(Activity_LuoLanSiegeData.rewardSecScoreData)
  self.thirdItemTemp:SetData(Activity_LuoLanSiegeData.rewardThirdScoreData)
  self.fourthItemTemp:SetData(Activity_LuoLanSiegeData.rewardFourthRewardScoreData)
  self.fifthItemTemp:SetData(Activity_LuoLanSiegeData.rewardFifthRewardScoreData)
  self.sixthItemTemp:SetData(Activity_LuoLanSiegeData.rewardSixthRewardScoreData)
  self.seventhItemTemp:SetData(Activity_LuoLanSiegeData.rewardSeventhRewardScoreData)
end

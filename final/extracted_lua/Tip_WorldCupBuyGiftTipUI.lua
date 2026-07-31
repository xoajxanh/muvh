Tip_WorldCupBuyGiftTipUI = class(BaseUI)
Tip_WorldCupBuyGiftTipUI.layer = UILayer.Tip
Tip_WorldCupBuyGiftTipUI.orderInLayer = 7
Tip_WorldCupBuyGiftTipUI.hideType = UIHideType.WaitDestroy
Tip_WorldCupBuyGiftTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_WorldCupBuyGiftTipUI.escClose = UIEscClose.DontClose

function Tip_WorldCupBuyGiftTipUI:InitControls()
  self.Bg_btn = self:GetControl("Bg_btn")
  self.Scroll_reward = self:GetControl("Scroll View/Content/Scroll_reward")
  self.bg_frameF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF")
  self.ContentF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF/Viewport/ContentF")
  self.btn_3DItemF = self:GetControl("Scroll View/Content/Scroll_reward/bg_frameF/Viewport/ContentF/btn_3DItemF")
  self.lab_TipTitle = self:GetControl("lab_TipTitle")
  self.lab_des = self:GetControl("lab_des")
  self.Button_buy = self:GetControl("Button_buy")
  self.lab_buy = self:GetControl("Button_buy/lab_buy")
end

function Tip_WorldCupBuyGiftTipUI:Init()
end

function Tip_WorldCupBuyGiftTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_WorldCupBuyGiftTipUI:InitUI()
end

function Tip_WorldCupBuyGiftTipUI:RegistUIEvents()
  self.Bg_btn:SetOnClick(self, self.Bg_btnOnClick)
  self.Button_buy:SetOnClick(self, self.Button_buyOnClick)
end

function Tip_WorldCupBuyGiftTipUI:Bg_btnOnClick(control)
  UIManager.Hide(UIID.Tip_WorldCupBuyGiftTipUI)
end

function Tip_WorldCupBuyGiftTipUI:btn_3DItemFOnClick(control)
end

function Tip_WorldCupBuyGiftTipUI:Button_buyOnClick(control)
  if self.args and self.args.singleRaceInfo then
    local singleRaceInfo = self.args.singleRaceInfo
    if BagInfoData.GetItemTotalCountByItemId(singleRaceInfo.giftInfo.costItemId) < singleRaceInfo.giftInfo.costCount then
      local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
      FloatingWordUtility.QuickMsg(tipStr)
      UIManager.Hide(UIID.Commercial_HolidayActivityUI)
      RechargeData.BuyDiamond()
    else
      NetManager.Send(CommerceMessage.ReqWorldCupGuessingReceiveReward, {
        id = singleRaceInfo.id
      })
    end
    self:Bg_btnOnClick()
  end
end

function Tip_WorldCupBuyGiftTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_WorldCupBuyGiftTipUI:RegistEvents()
end

function Tip_WorldCupBuyGiftTipUI:Refresh()
  if self.args and self.args.singleRaceInfo then
    local singleRaceInfo = self.args.singleRaceInfo
    self.btn_3DItemF.itemCellData = self.btn_3DItemF.itemCellData or ItemCellData()
    local itemInfo = ItemUtility.GenerateItemData(singleRaceInfo.giftInfo.rewardItemId)
    itemInfo.count = singleRaceInfo.giftInfo.rewardCount
    self.btn_3DItemF.itemCellData:RefreshData(itemInfo)
    ItemUtility.ShowItemCell(self.btn_3DItemF, self.btn_3DItemF.itemCellData, self, true)
    self.lab_buy:SetText(tostring(singleRaceInfo.giftInfo.costCount))
  end
end

function Tip_WorldCupBuyGiftTipUI:OnHide()
  self:ReleaseModel()
end

function Tip_WorldCupBuyGiftTipUI:ReleaseModel()
  ItemUtility.ReleaseItemCell(self.btn_3DItemF, self.btn_3DItemF.itemCellData)
end

function Tip_WorldCupBuyGiftTipUI:OnDestroy()
end

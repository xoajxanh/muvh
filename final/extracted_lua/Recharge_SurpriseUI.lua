Recharge_SurpriseUI = class(BaseUI)
Recharge_SurpriseUI.layer = UILayer.Panel
Recharge_SurpriseUI.orderInLayer = 0
Recharge_SurpriseUI.hideType = UIHideType.WaitDestroy
Recharge_SurpriseUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_SurpriseUI.escClose = UIEscClose.DontClose

function Recharge_SurpriseUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Background = self:GetControl("img_left/Scroll View/Viewport/Content/Background")
  self.sw_SurpriseGift = self:GetControl("img_Right/sw_SurpriseGift")
  self.btn_3DItem = self:GetControl("img_Right/sw_SurpriseGift/Viewport/Content/btn_3DItem")
  self.btn_activation = self:GetControl("img_Right/btn_activation")
  self.text_activation = self:GetControl("img_Right/text_activation")
  self.descSurpriseBtn = self:GetControl("descSurpriseBtn")
  self.btn_close = self:GetControl("btn_close")
  self.diamondIma = self:GetControl("img_Right/btn_activation/diamondIma")
  self.lab_Received = self:GetControl("img_Right/lab_Received")
  self.text_SurpriseText = self:GetControl("img_Right/text_SurpriseText")
  self.img_SurpriseGiftName = self:GetControl("img_Right/img_SurpriseGiftName")
  self.lab_SurpriseGiftNum = self:GetControl("img_Right/lab_SurpriseGiftNum")
  self.img_left = self:GetControl("img_left")
end

function Recharge_SurpriseUI:Init()
end

function Recharge_SurpriseUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Recharge_SurpriseUI:InitUI()
  function self.ClickCallBack(data)
    self:ClickButtonCallBackFunc(data)
  end
  
  self.tog_GiftContainer = UIUtility.BindUIContainerTemp(self.Background, LuaComponentTemplates.RechargeSurprisePageTemplate, self, {
    goCallBack = self.ClickCallBack
  })
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.normalTimer = {}
end

function Recharge_SurpriseUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_activation:SetOnClick(self, self.btn_activationOnClick)
  self.descSurpriseBtn:SetOnClick(self, self.descSurpriseBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Recharge_SurpriseUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Recharge_SurpriseUI)
end

function Recharge_SurpriseUI:btn_activationOnClick()
  local rechargeConfig = self.selectRechargeSurpriseData.rechargeConfig or self.selectRechargeSurpriseData.itemBuyConfig
  if self.selectRechargeSurpriseData.rechargeSurpriseConfig.type == RechargeSurpriseType.RMB then
    local itemPrice = math.ceil(rechargeConfig.rmb / 100)
    DataToCSharpMgr.Pay({
      amount = itemPrice,
      product_Id = rechargeConfig.id,
      product_name = rechargeConfig.name,
      BusinessPayType = BusinessPayType.None
    })
    NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
  elseif self.selectRechargeSurpriseData.rechargeSurpriseConfig.type == RechargeSurpriseType.Diamond then
    local costArray = string.split(rechargeConfig.cost, "#")
    if #costArray == 2 then
      local costItemId = tonumber(costArray[1])
      local costItemNum = tonumber(costArray[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(costItemId)
      if costItemNum > bagCount then
        FloatingTipUtility.QuickMsg("KC kh\195\180ng \196\145\225\187\167")
      else
        NetManager.Send(ItemBuyMessage.ReqBuy, {
          goodId = rechargeConfig.id,
          buyCount = 1
        })
      end
    else
      NetManager.Send(ItemBuyMessage.ReqBuy, {
        goodId = rechargeConfig.id,
        buyCount = 1
      })
    end
  end
end

function Recharge_SurpriseUI:descSurpriseBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Recharge_SurpriseUI")
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Recharge_SurpriseUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Recharge_SurpriseUI)
end

function Recharge_SurpriseUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Recharge_SurpriseUI:RegistEvents()
  self:RegistEvent(Event.PurchaseRechargeSurprise, self.RefreshRechargeState, self)
  self:RegistEvent(Event.RechargeSurprise, self.RefreshRecharge, self)
end

function Recharge_SurpriseUI:Refresh()
  self:RefreshRecharge()
end

function Recharge_SurpriseUI:RefreshRecharge()
  self:RefreshPageView()
  self:RefreshBackGroundView()
end

function Recharge_SurpriseUI:RefreshPageView()
  self.rechargeSurpriseDataList = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():GetRechargeSurpriseDataList()
  self.selectRechargeConfigId = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():GetFirstPageConfigId()
  if table.count(self.rechargeSurpriseDataList) > 0 and self.selectRechargeConfigId ~= nil then
    self.tog_GiftContainer:SetData(self.rechargeSurpriseDataList)
    local giftContainerItems = self.tog_GiftContainer.items
    if table.count(giftContainerItems) > 0 then
      for i, v in pairs(giftContainerItems) do
        if v.itemTemp and v.itemTemp.data and v.itemTemp.data.configId == self.selectRechargeConfigId then
          v.itemTemp:ClickGoCallBack()
        end
      end
    end
  end
end

function Recharge_SurpriseUI:RefreshBackGroundView()
  if table.count(self.rechargeSurpriseDataList) > 0 and self.selectRechargeConfigId ~= nil then
    self.img_left:SetActive(table.count(self.rechargeSurpriseDataList) > 1)
  end
end

function Recharge_SurpriseUI:ClickButtonCallBackFunc(data)
  self.selectRechargeSurpriseData = data
  self.selectRechargeConfigId = data.configId
  self:SetSelectFrameDisplay()
  self:RefreshCommonView()
  self:RefreshOtherView()
  self:RefreshRechargeState()
end

function Recharge_SurpriseUI:SetSelectFrameDisplay()
  local giftContainerItems = self.tog_GiftContainer.items
  if table.count(giftContainerItems) > 0 then
    for i, v in pairs(giftContainerItems) do
      v.itemTemp:SetSelectFrameDisplay(v.itemTemp and v.itemTemp.data and v.itemTemp.data.configId == self.selectRechargeConfigId and true or false)
    end
  end
end

function Recharge_SurpriseUI:RefreshCommonView()
  local rewardInfo, describeStr = {}, ""
  local rechargeConfig = self.selectRechargeSurpriseData.rechargeConfig or self.selectRechargeSurpriseData.itemBuyConfig
  if self.selectRechargeSurpriseData.rechargeSurpriseConfig.type == RechargeSurpriseType.RMB then
    rewardInfo = RechargeData.GetItemIdAndCount(rechargeConfig.reward)
    local cost = rechargeConfig.rmb
    local costRMB = math.floor(DataToCSharpMgr.ChangeAmountToSec(tonumber(cost)))
    describeStr = string.format("%sVND", MathUtility.TransNumberK(costRMB, 1))
    self.diamondIma:SetActive(false)
  elseif self.selectRechargeSurpriseData.rechargeSurpriseConfig.type == RechargeSurpriseType.Diamond then
    local rewardList = string.split(rechargeConfig.reward, "#")
    local itemItemData = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(rewardList[1]))
    rewardInfo = RechargeData.GetItemIdAndCount(tonumber(string.split(itemItemData.useParam, "#")[2]))
    local cost = string.split(rechargeConfig.cost, "#")[2]
    describeStr = MathUtility.TransNumberK(math.floor(tonumber(cost)), 1)
    self.diamondIma:SetActive(true)
  end
  self.rewardContainer:SetData(rewardInfo)
  self.btn_activation:GetChild("Text"):SetText(describeStr)
end

function Recharge_SurpriseUI:RefreshOtherView()
  self.text_SurpriseText:SetText(self.selectRechargeSurpriseData.rechargeSurpriseConfig.showText)
  self:SetSprite("Atlas_Common", self.selectRechargeSurpriseData.rechargeSurpriseConfig.showPic, self.img_SurpriseGiftName, true)
  self.lab_SurpriseGiftNum:SetText(string.format("%s%s", self.selectRechargeSurpriseData.rechargeSurpriseConfig.showText2, "%"))
end

function Recharge_SurpriseUI:RefreshRechargeState()
  self.lab_Received:SetActive(true)
  self.btn_activation:SetActive(false)
  self.text_activation:SetActive(false)
  local rechargeConfig = self.selectRechargeSurpriseData.rechargeConfig or self.selectRechargeSurpriseData.itemBuyConfig
  local lastServerTimer = gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetRechargeSurpriseManager():GetRechargeServerTimer()
  local timeDifference = Time.GetServerTime() - lastServerTimer
  local remainderTimer = (self.selectRechargeSurpriseData.giftTime - timeDifference) * 0.001
  local residueTime = RechargeData.GetBuyPrizeLimitCountData(rechargeConfig.countKey)
  if 0 < residueTime and not string.isNullOrEmpty(remainderTimer) and type(remainderTimer) == "number" and 1 <= remainderTimer then
    self.lab_Received:SetActive(false)
    self.btn_activation:SetActive(true)
    self.text_activation:SetActive(true)
    self:RechargeShowCountdown(remainderTimer)
  elseif residueTime == 0 then
    self.lab_Received:SetText("\196\144\195\163 mua")
  elseif remainderTimer <= 0 then
    self.lab_Received:SetText("\196\144\195\163 h\225\186\191t gi\225\187\157")
  end
end

function Recharge_SurpriseUI:RechargeShowCountdown(surplusTime)
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
  end
  local timeStr = TimeUtility.ShowTime(surplusTime)
  if not IsNil(self.text_activation.transform) then
    self.text_activation:SetText(string.GetColorText(tostring(timeStr .. " " .. "sau bi\225\186\191n m\225\186\165t"), ItemQuality2ColorDic[5]))
  end
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTime(surplusTime)
    if not IsNil(self.text_activation.transform) then
      self.text_activation:SetText(string.GetColorText(tostring(timeStr .. " " .. "sau bi\225\186\191n m\225\186\165t"), ItemQuality2ColorDic[5]))
    end
    if surplusTime <= 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      self:RefreshRechargeState()
      if not IsNil(self.text_activation.transform) then
        self.text_activation:SetText(string.GetColorText("", ItemQuality2ColorDic[5]))
      end
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Recharge_SurpriseUI:OnHide()
end

function Recharge_SurpriseUI:OnDestroy()
end

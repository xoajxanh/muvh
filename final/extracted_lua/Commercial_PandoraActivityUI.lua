Commercial_PandoraActivityUI = class(BaseUI)
Commercial_PandoraActivityUI.layer = UILayer.Panel
Commercial_PandoraActivityUI.orderInLayer = 0
Commercial_PandoraActivityUI.hideType = UIHideType.WaitDestroy
Commercial_PandoraActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_PandoraActivityUI.escClose = UIEscClose.DontClose

function Commercial_PandoraActivityUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.sw_combineActivityList = self:GetControl("sw_combineActivityList")
  self.btnContent = self:GetControl("sw_combineActivityList/Viewport/Content")
  self.Btn_Pandora = self:GetControl("sw_combineActivityList/Viewport/Content/Btn_Pandora")
  self.go_pandoraReward = self:GetControl("go_pandoraReward")
  self.btn_get = self:GetControl("go_pandoraPickaxe/btn_get")
  self.btn_show = self:GetControl("go_pandoraReward/btn_show")
  self.btn_showLab = self:GetControl("go_pandoraReward/btn_show/lab_get")
  self.go_pandoraPickaxe = self:GetControl("go_pandoraPickaxe")
  self.sw_diggings = self:GetControl("go_pandoraPickaxe/sw_diggings")
  self.go_pandoraShop = self:GetControl("go_pandoraShop")
  self.pandoraShopItem = self:GetControl("go_pandoraShop/sw_Suit/Viewport/Content/suit1")
  self.descBtn = self:GetControl("descBtn")
  self.btn_close = self:GetControl("btn_close")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
  self.lab_diamondBind = self:GetControl("sw_combineActivityList/lab_diamondBind/icon/lab")
  self.btn_diamondBind = self:GetControl("sw_combineActivityList/lab_diamondBind")
  self.lab_diamond = self:GetControl("sw_combineActivityList/lab_diamond/icon/lab")
  self.btn_diamond = self:GetControl("sw_combineActivityList/lab_diamond")
  self.lab_daibi = self:GetControl("sw_combineActivityList/lab_daibi/icon/lab")
  self.btn_daibi = self:GetControl("sw_combineActivityList/lab_daibi")
  self.showContent = self:GetControl("go_pandoraReward/sw_Gift/Viewport/Content")
  self.img_title = self:GetControl("img_title")
  self.img_title_shop = self:GetControl("img_title_shop")
end

function Commercial_PandoraActivityUI:Init()
  self.showCoins = {
    ECoinsType.gem,
    ECoinsType.gemNotTrade,
    ECoinsType.pandoraDaiBi
  }
end

function Commercial_PandoraActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Commercial_PandoraActivityUI:InitUI()
  self.RewardShowTemplate = luaTemplateManager.GetNewTemplate(self.go_pandoraReward, LuaComponentTemplates.PandoraActivityRewardShowTemplate, self)
  self.PandoraTemplate = luaTemplateManager.GetNewTemplate(self.go_pandoraPickaxe, LuaComponentTemplates.PandoraActivityMiningTemplate, self)
  self.PandoraShopTemplate = luaTemplateManager.GetNewTemplate(self.go_pandoraShop, LuaComponentTemplates.PandoraActivityShopTemplate, self)
  self.toggleContainer = UIContainer(self.Btn_Pandora, self, self.OnToggleOnCreate, self.OnToggleOnRefresh)
  local diamondItemData = ItemUtility.GenerateItemData(1000030)
  self.btn_diamond.itemData = diamondItemData
  local diamondBindItemData = ItemUtility.GenerateItemData(1000050)
  self.btn_diamondBind.itemData = diamondBindItemData
  local daibiItemData = ItemUtility.GenerateItemData(10901001)
  self.btn_daibi.itemData = daibiItemData
  self.showState = false
  self.showContentOpenPosY = 15
  self.showContentClosePosY = -280
  self.showContentMoveTween = nil
end

function Commercial_PandoraActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
  self.btn_show:SetOnClick(self, self.btn_showOnClick)
  self.btn_diamondBind:SetOnClick(self, self.showDiamondOnClick)
  self.btn_diamond:SetOnClick(self, self.showDiamondOnClick)
  self.btn_daibi:SetOnClick(self, self.showDiamondOnClick)
end

function Commercial_PandoraActivityUI:showDiamondOnClick(control)
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true
  })
end

function Commercial_PandoraActivityUI:btn_getOnClick(control)
  UIManager.Show(UIID.Bag_PandoraInfoUI)
end

function Commercial_PandoraActivityUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Commercial_PandoraActivityUI)
end

function Commercial_PandoraActivityUI:descBtnOnClick(control)
  if self.go_pandoraPickaxe:GetActive() or self.go_pandoraShop:GetActive() then
    UIManager.Show(UIID.Pandora_DescUI)
  end
end

function Commercial_PandoraActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_PandoraActivityUI)
end

local DaojiTime = 0

function Commercial_PandoraActivityUI:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    lab_lastTime:SetActive(false)
    txt_lastTime:SetText("\236\157\180\235\178\164\237\138\184 \236\162\133\235\163\140")
  end
end

function Commercial_PandoraActivityUI:SetOpeningInfo(data)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local down = TimeUtility.InTweenyearTimeTheEnd(data.deadline[1][2])
  Difference = TimeUtility.RefreshSec(down)
  local DaoJiShi
  if Difference <= 0 then
    self.lab_lastTime:SetActive(false)
    DaoJiShi = "\236\157\180\235\178\164\237\138\184 \236\162\133\235\163\140"
    self.txt_lastTime:SetText(DaoJiShi)
  else
    self.lab_lastTime:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTime:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTime, self.txt_lastTime)
  end
end

function Commercial_PandoraActivityUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_PandoraActivityUI:RefreshDiamondAndDaiBi()
  local diamond = BagInfoData.GetItemCountByItemConfigId(self.showCoins[1])
  local diamondBind = BagInfoData.GetItemCountByItemConfigId(self.showCoins[2])
  local daibi = BagInfoData.GetItemCountByItemConfigId(self.showCoins[3])
  self.lab_diamond:SetText(diamond)
  self.lab_diamondBind:SetText(diamondBind)
  self.lab_daibi:SetText(daibi)
end

function Commercial_PandoraActivityUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Commercial_PandoraActivityUI:RegistEvents()
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
  self:RegistEvent(Event.PandoraActivityRefresh, self.PandoraActivityRefresh, self)
  self:RegistEvent(Event.PandoraActivityInfiniteStop, self.PandoraActivityInfiniteStop, self)
  self:RegistEvent(Event.PandoraActivityRareChoose, self.PandoraActivityRareChoose, self)
  self:RegistEvent(Event.PandoraActivityRareChooseNext, self.PandoraActivityRareChooseNext, self)
end

function Commercial_PandoraActivityUI:OnCoinChanged()
  self:RefreshDiamondAndDaiBi()
end

function Commercial_PandoraActivityUI:PandoraActivityRefresh(_, msg)
  self.PandoraTemplate:Refresh(msg, self)
  EventManager.Dispatch(Event.PandoraActivityRefreshDesc)
end

function Commercial_PandoraActivityUI:PandoraActivityInfiniteStop(_, msg)
  self.PandoraTemplate:InfiniteStop()
end

function Commercial_PandoraActivityUI:PandoraActivityRareChoose(_, msg)
  UIManager.Show(UIID.Tip_PromptItemTipUI, {
    itemData = msg.items,
    layer = msg.lotteryLayer,
    rewardType = msg.rewardType
  })
  self.PandoraTemplate:CloseGetItemTip()
end

function Commercial_PandoraActivityUI:PandoraActivityRareChooseNext(_, msg)
  self.PandoraTemplate:SetBtnsState(false)
  TipUtility.QuickShowPrompt({
    id = 94,
    contentFormatArgs = msg,
    cancelAction = function()
      UIManager.Hide(UIID.PromptTipUI)
      self.PandoraTemplate:SetBtnsState(true)
    end,
    okAction = function()
      UIManager.Hide(UIID.PromptTipUI)
      UIManager.Hide(UIID.Tip_PromptItemTipUI)
      networkRequest.ReqPandoraRareChoose(2, PandoraActivityData.nowSelectTogCommerceId)
      self.PandoraTemplate:OnClickDigBtn(nil)
      self.PandoraTemplate:SetBtnsState(true)
    end
  })
end

function Commercial_PandoraActivityUI:Refresh()
  self.overViewData = PandoraActivityData.GetPandoraActivityOverViewList()
  if self.overViewData then
    self.toggleContainer:SetData(self.overViewData)
  end
  self:SetToggleInteractable(true)
  self:SetToggleIsOn(1)
  if self.overViewData then
    self:SetOpeningInfo(self.overViewData[1])
  end
  self:RefreshDiamondAndDaiBi()
  self:ResetTween()
end

function Commercial_PandoraActivityUI:RefreshPandoraShop()
  self.PandoraShopTemplate:Refresh()
end

function Commercial_PandoraActivityUI:ShowRewardModel(commerceId)
  local rewardList = PandoraActivityData.GetPandoraActivityRewardShowInfo(commerceId)
  if rewardList then
    self.RewardShowTemplate:Refresh(rewardList, self)
  end
  self.showState = false
  self:ShowStateChange(false)
end

function Commercial_PandoraActivityUI.OnToggleOnCreate(ctr)
  ctr.toggle = UIControl(ctr.transform)
  ctr.img_dark = UIControl(ctr.transform, "img_point_dark")
  ctr.clickEff_dark = UIControl(ctr.transform, "img_point_dark/img_clickeffect_dark")
  ctr.name_dark = UIControl(ctr.transform, "img_point_dark/lab_name_dark")
  ctr.img_light = UIControl(ctr.transform, "img_point_light")
  ctr.clickEff_light = UIControl(ctr.transform, "img_point_light/img_clickeffect_light")
  ctr.name_light = UIControl(ctr.transform, "img_point_light/lab_name_light")
end

function Commercial_PandoraActivityUI.OnToggleOnRefresh(ctr, index, data, ui)
  ctr.img_dark:SetActive(true)
  ctr.img_light:SetActive(false)
  local togName = data.commerceName or ""
  ctr.name_dark:SetText(togName)
  ctr.name_light:SetText(togName)
  ctr.toggle:SetOnToggleChanged(ui, function(control, isOn)
    if ctr.toggle.toggle.isOn then
      ctr.img_dark:SetActive(false)
      ctr.img_light:SetActive(true)
      ui:OnToggleOnClick(data)
    else
      ctr.img_dark:SetActive(true)
      ctr.img_light:SetActive(false)
    end
  end)
end

function Commercial_PandoraActivityUI:OnToggleOnClick(data)
  if data.commerceId == 100002 then
    self.go_pandoraReward:SetActive(false)
    self.go_pandoraPickaxe:SetActive(false)
    self.go_pandoraShop:SetActive(true)
    self.img_title:SetActive(false)
    self.img_title_shop:SetActive(true)
    self:RefreshPandoraShop()
  else
    self.go_pandoraReward:SetActive(true)
    self.go_pandoraPickaxe:SetActive(true)
    self.go_pandoraShop:SetActive(false)
    self.img_title:SetActive(true)
    self.img_title_shop:SetActive(false)
    PandoraActivityData.SetNowSelectTogCommerceId(data.commerceId)
    self:ShowRewardModel(data.commerceId)
    self:SetFreeDigBtnState()
    networkRequest.ReqPandoraInfo(data.commerceId)
  end
  self:SetOpeningInfo(data)
end

function Commercial_PandoraActivityUI:SetToggleIsOn(index)
  for i, v in ipairs(self.toggleContainer.items) do
    if i == index then
      if v.toggle.toggle.isOn == true then
        self:OnToggleOnClick(self.overViewData[i])
      else
        v.toggle.toggle.isOn = true
      end
      v.img_dark:SetActive(false)
      v.img_light:SetActive(true)
    else
      v.toggle.toggle.isOn = false
      v.img_dark:SetActive(true)
      v.img_light:SetActive(false)
    end
  end
end

function Commercial_PandoraActivityUI:SetToggleInteractable(state)
  for i, v in ipairs(self.toggleContainer.items) do
    v.toggle:SetInteractable(state)
  end
end

function Commercial_PandoraActivityUI:btn_showOnClick(control)
  self.showState = not self.showState
  self:ShowStateChange(true)
end

function Commercial_PandoraActivityUI:ShowStateChange(needAnim)
  if self.showState then
    self.showContent:SetActive(true)
    self.btn_showLab:SetText("\236\136\168\234\184\176\234\184\176")
    self:ResetTween()
    self.btn_show:SetInteractable(false)
    self.showContentMoveTween = DOTween.To(function(value)
      self.showContent.transform.localPosition = Vector3(0, value, 0)
    end, self.showContentClosePosY, self.showContentOpenPosY, 0.5):SetEase(Ease.OutQuad):OnComplete(function()
      self.btn_show:SetInteractable(true)
    end)
  else
    self.btn_showLab:SetText("\236\149\132\236\157\180\237\133\156 \235\179\180\234\184\176")
    if needAnim then
      self:ResetTween()
      self.btn_show:SetInteractable(false)
      self.showContentMoveTween = DOTween.To(function(value)
        self.showContent.transform.localPosition = Vector3(0, value, 0)
      end, self.showContentOpenPosY, self.showContentClosePosY, 0.5):SetEase(Ease.OutQuad):OnComplete(function()
        self.btn_show:SetInteractable(true)
        self.showContent:SetActive(false)
      end)
    else
      self.showContent.transform.localPosition = Vector3(0, self.showContentClosePosY, 0)
      self.showContent:SetActive(false)
    end
  end
end

function Commercial_PandoraActivityUI:ResetTween()
  if self.showContentMoveTween then
    self.showContentMoveTween:Kill()
    self.showContentMoveTween = nil
  end
end

function Commercial_PandoraActivityUI:ResetToggleContentPos()
  self.btnContent.transform.localPosition = Vector3(21.04, 0, 0)
end

function Commercial_PandoraActivityUI:SetFreeDigBtnState()
  self.PandoraTemplate:SetFreeDigBtnState()
end

function Commercial_PandoraActivityUI:OnHide()
  self.RewardShowTemplate:CloseUI()
  self.PandoraShopTemplate:CloseUI()
  self.PandoraTemplate:StopInfiniteDig()
  self.showState = false
  self:ResetTween()
  self:ResetToggleContentPos()
  UIManager.Hide(UIID.Tip_PromptItemTipUI)
end

function Commercial_PandoraActivityUI:OnDestroy()
end

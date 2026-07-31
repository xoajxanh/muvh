Tip_MonsterTipUI = class(BaseUI)
Tip_MonsterTipUI.layer = UILayer.Panel
Tip_MonsterTipUI.orderInLayer = 0
Tip_MonsterTipUI.hideType = UIHideType.WaitDestroy
Tip_MonsterTipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_MonsterTipUI.escClose = UIEscClose.DontClose

function Tip_MonsterTipUI:InitControls()
  self.btn_GratisSummon = self:GetControl("Panel_Tip/Image_TipBg/Button_Free")
  self.btn_DiamondSummon = self:GetControl("Panel_Tip/Image_TipBg/Button_OK")
  self.btn_Close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.txt_GratisSummonProbability = self:GetControl("Panel_Tip/Image_TipBg/Button_Free/des_ProbabilityFree")
  self.txt_DiamondSummonProbability = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/des_Probability")
  self.gratisItem = self:GetControl("Panel_Tip/Image_TipBg/Button_Free/lab_price1/consumeItem")
  self.gratisItemModel = self:GetControl("Panel_Tip/Image_TipBg/Button_Free/lab_price1/consumeItem/go_model")
  self.txt_GratisCount = self:GetControl("Panel_Tip/Image_TipBg/Button_Free/lab_price1/lab_priceValue")
  self.diamondItem = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/lab_price2/consumeItem")
  self.diamondItemModel = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/lab_price2/consumeItem/go_model")
  self.txt_DiamondCount = self:GetControl("Panel_Tip/Image_TipBg/Button_OK/lab_price2/lab_priceValue")
  self.txt_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.timeTip = self:GetControl("Panel_Tip/Image_TipBg/Text_timeTip")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
end

function Tip_MonsterTipUI:Init()
end

function Tip_MonsterTipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_MonsterTipUI:InitUI()
  self.gratisCellData = ItemCellData()
  self.diamondCellData = ItemCellData()
end

function Tip_MonsterTipUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.btn_GratisSummon:SetOnClick(self, self.btn_GratisSummonOnClick)
  self.btn_DiamondSummon:SetOnClick(self, self.btn_DiamondSummonOnClick)
end

function Tip_MonsterTipUI:btn_GratisSummonOnClick()
  local gratisTab = ParseUtility.ParseId(self.MonsterDimensionBornConfig.randomCost)
  local gratisItemId, gratisCount = gratisTab[1], gratisTab[2]
  if gratisCount > BagInfoData.GetItemTotalCountByItemId(gratisItemId) then
    FloatingTipUtility.QuickMsg("\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167")
    return
  end
  networkRequest.ReqCallBoss(self.DimensionalCracksData.id, self.DimensionalCracksData.mid, 1)
end

function Tip_MonsterTipUI:btn_DiamondSummonOnClick()
  local diamondTab = ParseUtility.ParseId(self.MonsterDimensionBornConfig.fixedCost)
  local diamondItemId, diamondCount = diamondTab[1], diamondTab[2]
  if diamondCount > BagInfoData.GetItemTotalCountByItemId(diamondItemId) then
    FloatingTipUtility.QuickMsg("\196\144\225\186\161o c\225\187\165 kh\195\180ng \196\145\225\187\167")
    return
  end
  networkRequest.ReqCallBoss(self.DimensionalCracksData.id, self.DimensionalCracksData.mid, 2)
end

function Tip_MonsterTipUI:btn_CloseOnClick()
  UIManager.Hide(UIID.Tip_MonsterTipUI)
  EventManager.Dispatch(Event.RefreshMonsterDimension, not self.isOver)
end

function Tip_MonsterTipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_MonsterTipUI:RegistEvents()
  self:RegistEvent(Event.RefreshCallMonsterDimension, self.HideUI, self)
end

function Tip_MonsterTipUI:Refresh()
  self:RefreshPanelEffect()
  if self.args == nil or self.args.DimensionalCracksData == nil then
    self:RefreshCost()
    return
  end
  self.DimensionalCracksData = self.args.DimensionalCracksData
  self.MonsterDimensionBornConfig = ClientTable.cfg_Monster_dimensionBornManager:TryGetValue(self.DimensionalCracksData.id)
  if self.MonsterDimensionBornConfig == nil then
    return
  end
  self:RefreshTipContent()
  self:RefreshProbability()
  self:RefreshCost()
  self:ShowTime(self.MonsterDimensionBornConfig.countdown / 1000)
end

function Tip_MonsterTipUI:RefreshPanelEffect()
  if self.panelTween then
    self.panelTween:Kill()
    self.panelTween = nil
  end
  self.Image_TipBg.canvasGroup.alpha = 0
  self.gratisItemModel:SetActive(false)
  self.diamondItemModel:SetActive(false)
  self.panelTween = DOTween.To(function(value)
    self.Image_TipBg.canvasGroup.alpha = value
    self.gratisItemModel:SetActive(0.1 < value)
    self.diamondItemModel:SetActive(0.1 < value)
  end, 0, 1, 3):SetDelay(3.3):OnComplete(function()
  end)
end

function Tip_MonsterTipUI:RefreshTipContent()
  local uiWord = LocalizationUtility.GetUIWord(self.MonsterDimensionBornConfig.desTips)
  self.txt_TipContent:SetText(uiWord)
end

function Tip_MonsterTipUI:RefreshProbability()
  local gratisProbabilityDes = string.format("T\225\187\183 l\225\187\135 th\195\160nh c\195\180ng %s%s", MathUtility.FormatNum(tonumber(self.MonsterDimensionBornConfig.showProbability) / 100), "%")
  self.txt_GratisSummonProbability:SetText(gratisProbabilityDes)
  local diamondProbabilityDes = string.format("T\225\187\183 l\225\187\135 th\195\160nh c\195\180ng %s%s", MathUtility.FormatNum(tonumber(self.MonsterDimensionBornConfig.showFixedProbability) / 100), "%")
  self.txt_DiamondSummonProbability:SetText(diamondProbabilityDes)
end

function Tip_MonsterTipUI:RefreshCost()
  if self.gratisCellData and self.diamondCellData then
    self.gratisCellData:RecycleRes()
    self.diamondCellData:RecycleRes()
  end
  local gratisTab = ParseUtility.ParseId(self.MonsterDimensionBornConfig.randomCost)
  local gratisItem = ItemUtility.GenerateItemData(gratisTab[1])
  self.gratisCellData:RefreshData(gratisItem)
  ItemUtility.ShowItemCell(self.gratisItem, self.gratisCellData, nil, true)
  local color = BagInfoData.GetItemTotalCountByItemId(gratisTab[1]) >= gratisTab[2] and ItemQuality2ColorDic[0] or ItemQuality2ColorDic[7]
  self.txt_GratisCount:SetText(string.GetColorText(gratisTab[2], color))
  local diamondTab = ParseUtility.ParseId(self.MonsterDimensionBornConfig.fixedCost)
  local diamondItem = ItemUtility.GenerateItemData(diamondTab[1])
  self.diamondCellData:RefreshData(diamondItem)
  ItemUtility.ShowItemCell(self.diamondItem, self.diamondCellData, nil, true)
  local color = BagInfoData.GetItemTotalCountByItemId(diamondTab[1]) >= diamondTab[2] and ItemQuality2ColorDic[0] or ItemQuality2ColorDic[7]
  self.txt_DiamondCount:SetText(string.GetColorText(diamondTab[2], color))
end

function Tip_MonsterTipUI:ShowTime(surplusTime)
  if self.normalTimer then
    Timer.Stop(self.normalTimer)
  end
  self.isOver = false
  local timeStr = TimeUtility.ShowTime(surplusTime)
  if not IsNil(self.timeTip.transform) then
    self.timeTip:SetText(string.format("%s sau Khe H\225\187\159 s\225\186\189 bi\225\186\191n m\225\186\165t", timeStr))
  end
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTime(surplusTime)
    if not IsNil(self.timeTip.transform) then
      self.timeTip:SetText(string.format("%s sau Khe H\225\187\159 s\225\186\189 bi\225\186\191n m\225\186\165t", timeStr))
    end
    if surplusTime <= 0 and self.normalTimer then
      Timer.Stop(self.normalTimer)
      self.normalTimer = nil
      self.isOver = true
      self:HideUI(_, self.isOver)
    end
  end
  
  self.normalTimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
end

function Tip_MonsterTipUI:HideUI(_, isOver)
  if UIManager.IsVisible(UIID.Tip_MonsterTipUI) then
    UIManager.Hide(UIID.Tip_MonsterTipUI)
  end
  EventManager.Dispatch(Event.RefreshMonsterDimension, not isOver)
end

function Tip_MonsterTipUI:RefreshBtnState(isCanClick)
  self.btn_Close:SetInteractable(isCanClick)
  self.btn_GratisSummon:SetInteractable(isCanClick)
  self.btn_DiamondSummon:SetInteractable(isCanClick)
end

function Tip_MonsterTipUI:StartFadeTask(isFadeIn, duringTime, delayTime)
  if isFadeIn then
    AudioManager.PlayMusicClipById(4131)
    self.Panel_Tip.canvasGroup.alpha = 0
    self.gratisItemModel:SetActive(false)
    self.diamondItemModel:SetActive(false)
    self:RefreshBtnState(true)
  else
    self:RefreshBtnState(false)
  end
  if self.fadeTween then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
  self.fadeTween = DOTween.To(function(value)
    self.Panel_Tip.canvasGroup.alpha = value
    if 0.1 <= value and isFadeIn then
      self.gratisItemModel:SetActive(true)
      self.diamondItemModel:SetActive(true)
    elseif value <= 0.1 and not isFadeIn then
      self.gratisItemModel:SetActive(false)
      self.diamondItemModel:SetActive(false)
    end
  end, isFadeIn and 0 or 1, isFadeIn and 1 or 0, duringTime):SetDelay(delayTime or 0):OnComplete(function()
    if not isFadeIn then
      UIManager.Hide(UIID.Tip_MonsterTipUI)
    end
  end)
end

function Tip_MonsterTipUI:OnHide()
  if self.fadeTween then
    self.fadeTween:Kill()
    self.fadeTween = nil
  end
end

function Tip_MonsterTipUI:OnDestroy()
end

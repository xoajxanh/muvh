Equip_HolyRingNavUi = class(BaseUI)
Equip_HolyRingNavUi.layer = UILayer.Tip
Equip_HolyRingNavUi.orderInLayer = 0
Equip_HolyRingNavUi.hideType = UIHideType.Destroy
Equip_HolyRingNavUi.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_HolyRingNavUi.escClose = UIEscClose.DontClose

function Equip_HolyRingNavUi:InitControls()
  self.tog_information = self:GetControl("go_ringNavGroup/tog_information")
  self.tog_holyPower = self:GetControl("go_ringNavGroup/tog_holyPower")
  self.tog_holyRing = self:GetControl("go_ringNavGroup/tog_holyRing")
  self.tog_combine = self:GetControl("go_ringNavGroup/tog_combine")
  self.SubPanelRoot = self:GetControl("SubPanelRoot")
  self.SubPanelRootTwo = self:GetControl("SubPanelRootTwo")
end

function Equip_HolyRingNavUi:Init()
  self.UITab = {
    UIID.Equip_HolyRingInformationUI,
    UIID.Equip_HolyRingPowerUI,
    UIID.Equip_HolyRingUI,
    UIID.Equip_HolyRingCombineUI
  }
  self.CurUI = UIID.Equip_HolyRingInformationUI
end

function Equip_HolyRingNavUi:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_HolyRingNavUi:InitUI()
  self.TogObjTab = {
    [UIID.Equip_HolyRingInformationUI] = self.tog_information,
    [UIID.Equip_HolyRingPowerUI] = self.tog_holyPower,
    [UIID.Equip_HolyRingUI] = self.tog_holyRing,
    [UIID.Equip_HolyRingCombineUI] = self.tog_combine
  }
  self.TogSort = {
    [1] = UIID.Equip_HolyRingInformationUI,
    [2] = UIID.Equip_HolyRingPowerUI,
    [3] = UIID.Equip_HolyRingUI,
    [4] = UIID.Equip_HolyRingCombineUI
  }
end

function Equip_HolyRingNavUi:RegistUIEvents()
  self.tog_information:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_holyPower:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_holyRing:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_combine:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_HolyRingNavUi:OnToggleChanged()
  if self.IsTogInit then
    return
  end
  if self.tog_information:GetIsOn() then
    self:tog_informationOnToggleChanged()
  elseif self.tog_holyPower:GetIsOn() then
    self:tog_holyPowerOnToggleChanged()
  elseif self.tog_holyRing:GetIsOn() then
    self:tog_holyRingOnToggleChanged()
  elseif self.tog_combine:GetIsOn() then
    self:tog_combineOnToggleChanged()
  end
end

function Equip_HolyRingNavUi:tog_informationOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_HolyRingInformationUI) then
    UIManager.Show(UIID.Equip_HolyRingInformationUI, {resetLogic = 1})
  end
end

function Equip_HolyRingNavUi:tog_holyPowerOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_HolyRingPowerUI) then
    UIManager.Show(UIID.Equip_HolyRingPowerUI, {resetLogic = 1})
  end
end

function Equip_HolyRingNavUi:tog_holyRingOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_HolyRingUI) then
    UIManager.Show(UIID.Equip_HolyRingUI, {resetLogic = 1})
  end
end

function Equip_HolyRingNavUi:tog_combineOnToggleChanged()
  if not UIManager.IsVisible(UIID.Equip_HolyRingCombineUI) then
    UIManager.Show(UIID.Equip_HolyRingCombineUI, {resetLogic = 1})
  end
end

function Equip_HolyRingNavUi:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_HolyRingNavUi:RegistEvents()
  self:RegistEvent(Event.HolyRingJumpSynthesis, self.HolyRingJumpSynthesis, self)
end

function Equip_HolyRingNavUi:HolyRingJumpSynthesis()
  if not self.tog_combine:GetIsOn() then
    self.tog_combine:SetIsOn(true)
  end
end

function Equip_HolyRingNavUi:Refresh()
  networkRequest.ReqHolyRingExp()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    3000203,
    3000204,
    3000205,
    3000206
  })
  self.IsTogInit = true
  if self.args then
    if self.args.uiID then
      self.CurUI = self.args.uiID
      if self.args.openType then
        UIManager.Show(self.CurUI, {
          resetLogic = 1,
          openType = self.args.openType,
          itemData = self.args.itemData
        })
      else
        UIManager.Show(self.CurUI, {resetLogic = 1})
      end
    end
    if self.args.openFirstTab and self.args.openSecondTab then
      self.CurUI = self.UITab[self.args.openFirstTab]
      UIManager.Show(self.CurUI, {
        openSecondTab = self.args.openSecondTab,
        resetLogic = 1
      })
    end
  else
    self:SetFirstUIID()
  end
  self:ToggleInit()
end

function Equip_HolyRingNavUi:SetFirstUIID()
  local toggleControl, targetUIID
  local isFirst = true
  for i, v in ipairs(self.TogSort) do
    toggleControl = self.TogObjTab[v]
    if toggleControl:GetActive() and not IsNil(toggleControl.gameObject) then
      if isFirst then
        targetUIID = v
        isFirst = false
      end
      if RedPointManager:GetCacheStateByPath("Equip_HolyRingNavUi#" .. toggleControl.transform.name) then
        targetUIID = v
        break
      end
    end
  end
  self.CurUI = targetUIID
  UIManager.Show(self.CurUI, {resetLogic = 1})
end

function Equip_HolyRingNavUi:ToggleInit()
  for i, v in pairs(self.TogObjTab) do
    if i == self.CurUI then
      v.toggle.isOn = true
    else
      v.toggle.isOn = false
    end
  end
  self.IsTogInit = false
end

function Equip_HolyRingNavUi:OnHide()
end

function Equip_HolyRingNavUi:OnDestroy()
end

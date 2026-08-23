Equip_GuardNavUI = class(BaseUI)
Equip_GuardNavUI.layer = UILayer.Panel
Equip_GuardNavUI.orderInLayer = 0
Equip_GuardNavUI.hideType = UIHideType.Destroy
Equip_GuardNavUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_GuardNavUI.escClose = UIEscClose.DontClose

function Equip_GuardNavUI:InitControls()
  self.tog_1 = self:GetControl("go_guardNavGroup/tog_1")
  self.tog_2 = self:GetControl("go_guardNavGroup/tog_2")
  self.tog_3 = self:GetControl("go_guardNavGroup/tog_3")
end

function Equip_GuardNavUI:Init()
  self.curUIId = nil
end

function Equip_GuardNavUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Equip_GuardNavUI:InitUI()
  self.togObj = {
    [UIID.Equip_GuardUI] = self.tog_1,
    [UIID.Equip_GuardEquipUI] = self.tog_2,
    [UIID.Equip_GuardCultivateUI] = self.tog_3
  }
end

function Equip_GuardNavUI:OnShow()
  networkRequest.ReqGuardInfo()
  self:RegistEvents()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2800001, 2800002})
end

function Equip_GuardNavUI:OnHide()
  self.curUIId = nil
end

function Equip_GuardNavUI:OnDestroy()
end

function Equip_GuardNavUI:RegistUIEvents()
  self.tog_1:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_2:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_3:SetOnToggleChanged(self, self.OnToggleChanged)
end

function Equip_GuardNavUI:OnToggleChanged(control, isOn)
  if not self.curUIId then
    UIManager.Hide(UIID.Equip_GuardNavUI)
    return
  end
  if not isOn then
    return
  end
  if self.tog_1.toggle.isOn then
    if not UIManager.IsVisible(UIID.Equip_GuardUI) then
      UIManager.Show(UIID.Equip_GuardUI, {resetLogic = 1})
      self.curUIId = UIID.Equip_GuardUI
    end
  elseif self.tog_2.toggle.isOn then
    if not UIManager.IsVisible(UIID.Equip_GuardEquipUI) then
      UIManager.Show(UIID.Equip_GuardEquipUI, {resetLogic = 1})
      self.curUIId = UIID.Equip_GuardEquipUI
    end
  elseif self.tog_3.toggle.isOn and not UIManager.IsVisible(UIID.Equip_GuardCultivateUI) then
    UIManager.Show(UIID.Equip_GuardCultivateUI, {resetLogic = 1})
    self.curUIId = UIID.Equip_GuardCultivateUI
  end
end

function Equip_GuardNavUI:RegistEvents()
  self:RegistEvent(Event.Guard_InfoChange, self.OnGuardInfoChange, self)
end

function Equip_GuardNavUI:OnGuardInfoChange()
  if not self.curUIId then
    if self.args and self.args.uiID then
      self.curUIId = self.args.uiID
    else
      self.curUIId = UIID.Equip_GuardUI
    end
  end
  if self.togObj[self.curUIId].toggle.isOn then
    self:OnToggleChanged(nil, true)
  else
    self.togObj[self.curUIId].toggle.isOn = true
  end
  local isCultureActive = false
  local funcTable = ClientTable.cfg_Function_functionManager:TryGetValue(2800001)
  if funcTable ~= nil and ConditionManager.Check4D(funcTable.condition) then
    isCultureActive = true
  end
  self.togObj[UIID.Equip_GuardCultivateUI]:SetActive(isCultureActive)
end
